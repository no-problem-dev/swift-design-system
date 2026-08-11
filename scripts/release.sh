#!/bin/bash
# リリースする。版は人間が決めない — 公開 API の実差分から計算する。
#
#   使い方: scripts/release.sh [--dry-run]
#
# やること:
#   1. CHANGELOG の `## [Unreleased]` に中身があるか確認（無ければ何もしない）
#   2. compute-next-version.sh で次の版を計算
#   3. CHANGELOG の未リリース節にその版を刻印し、空の未リリース節を上に足す
#   4. README の install 行を major の基準点へ同期
#   5. commit → tag → push（タグ push が CI の Release 作成を起動する）
#
# なぜローカルで走らせるか:
#   版の計算にはシンボルグラフの抽出が要り、それは baseline と HEAD の 2 回ビルドを意味する。
#   CI でやると macOS ランナーのキュー（実測で 10 分超）と 2 回のフルビルドが乗る。
#   手元なら .build が温まっているので桁で速い。判定するのは機械のままなので決定論は変わらない。
#   CI に残すのはタグから Release を作る処理だけで、ビルドもテストも走らせない。

set -eo pipefail

DRY_RUN=false
[[ "${1:-}" == "--dry-run" ]] && DRY_RUN=true

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO="$(git rev-parse --show-toplevel)"
cd "$REPO"
NAME="$(basename "$REPO")"

[[ -f CHANGELOG.md ]] || { echo "CHANGELOG.md が無い"; exit 1; }

BODY=$(awk '/^## \[?([Uu]nreleased|未リリース)\]?/{flag=1; next} /^## /{flag=0} flag' CHANGELOG.md | grep -vE '^\s*$' || true)
if [[ -z "$BODY" ]]; then
  echo "未リリース節が空。リリースするものが無い。"
  exit 0
fi

if [[ -n "$(git status --porcelain)" ]]; then
  echo "作業ツリーに未コミットの変更がある。先にコミットすること。" >&2
  git status --short >&2
  exit 1
fi

RESULT="$("$SCRIPT_DIR/compute-next-version.sh")"
echo "$RESULT"
VERSION=$(echo "$RESULT" | tr ' ' '\n' | sed -n 's/^next=//p')
BUMP=$(echo "$RESULT" | tr ' ' '\n' | sed -n 's/^bump=//p')
REMOVED=$(echo "$RESULT" | tr ' ' '\n' | sed -n 's/^removed=//p')
ADDED=$(echo "$RESULT" | tr ' ' '\n' | sed -n 's/^added=//p')
[[ -n "$VERSION" ]] || { echo "版を計算できなかった" >&2; exit 1; }

if git rev-parse -q --verify "$VERSION" >/dev/null 2>&1 || git rev-parse -q --verify "v$VERSION" >/dev/null 2>&1; then
  echo "$VERSION は既にタグ済み" >&2
  exit 1
fi

# install 行に書く依存要件。**0.x と 1.x 以降で書き方が違う。**
#
# SPM の `from:` は up-to-next-major、つまり `from: "0.3.0"` は `>=0.3.0, <1.0.0` を意味する。
# ところが 0.x では破壊的変更の軸は minor なので、この範囲は 0.4.0 の破壊を含んでしまう。
# 0.x に `from:` を使うと「壊れる版まで自動で取りに行く」指定になる。
# 0.x は upToNextMinor、1.x 以降は from（major を基準点に）で書く。
MAJOR="${VERSION%%.*}"
if [[ "$MAJOR" == "0" ]]; then
  REST="${VERSION#*.}"
  BASE="0.${REST%%.*}.0"
  REQ_KIND="upToNextMinor"
else
  BASE="${MAJOR}.0.0"
  REQ_KIND="from"
fi
TODAY=$(date -u +%Y-%m-%d)

# 空の値で上書きするくらいなら、何も出さずに止まる。
# 実際に BASE と TODAY が空のまま走った回があり、README に `from: ""`（SPM が
# 解決できない）と `## [0.3.0] - `（日付なし）を書き込んで出荷した。
# しかも下の置換は `[^"]*` になるまで**自分が書いた空文字を修復できなかった**。
[[ -n "$BASE" && -n "$TODAY" ]] || { echo "BASE か TODAY が空。中止する" >&2; exit 1; }

if $DRY_RUN; then
  echo "[dry-run] $NAME を $VERSION として出す（install は $REQ_KIND: \"$BASE\"）"
  exit 0
fi

VERSION="$VERSION" TODAY="$TODAY" perl -0pi -e '
  my ($v, $d) = ($ENV{VERSION}, $ENV{TODAY});
  s{^\#\#\s*\[?(?:Unreleased|unreleased|未リリース)\]?.*$}{## [Unreleased]\n\n## [$v] - $d}m;
' CHANGELOG.md

# README の install 行は人間に書かせない。基準点だけを機械が同期する。
#
# `[^"]+` ではなく `[^"]*` にしてある。+ だと空文字に一致しないので、
# 一度 `from: ""` を書いてしまうと**二度と直せない**（実際にそうなった）。
# from: と upToNextMinor(from:) のどちらの形も拾って、正しい方へ書き換える。
for f in README.md README.ja.md README_EN.md; do
  [[ -f "$f" ]] || continue
  NAME="$NAME" BASE="$BASE" REQ_KIND="$REQ_KIND" perl -0pi -e '
    my ($repo, $base, $kind) = ($ENV{NAME}, $ENV{BASE}, $ENV{REQ_KIND});
    my $req = $kind eq "upToNextMinor" ? qq{.upToNextMinor(from: "$base")} : qq{from: "$base"};
    s{(\.package\(\s*url:\s*"[^"]*\Q$repo\E(?:\.git)?"\s*,\s*)
      (?:from:\s*"[^"]*"|\.upToNext(?:Minor|Major)\(\s*from:\s*"[^"]*"\s*\))}{$1$req}gx;
  ' "$f"
done

FILES=(CHANGELOG.md)
for f in README.md README.ja.md README_EN.md; do [[ -f "$f" ]] && FILES+=("$f"); done
git add -- "${FILES[@]}"
git commit --quiet -m "release: ${VERSION}（bump=${BUMP} / API 削除 ${REMOVED}・追加 ${ADDED}）"
git tag "$VERSION"
git push --quiet origin HEAD:main
git push --quiet origin "$VERSION"

echo "✓ $NAME $VERSION を push した（CI が Release を作る）"
