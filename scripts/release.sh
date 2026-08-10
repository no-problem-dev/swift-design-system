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

BASE="${VERSION%%.*}.0.0"
TODAY=$(date -u +%Y-%m-%d)

if $DRY_RUN; then
  echo "[dry-run] $NAME を $VERSION として出す（install の基準点は $BASE）"
  exit 0
fi

VERSION="$VERSION" TODAY="$TODAY" perl -0pi -e '
  my ($v, $d) = ($ENV{VERSION}, $ENV{TODAY});
  s{^\#\#\s*\[?(?:Unreleased|unreleased|未リリース)\]?.*$}{## [Unreleased]\n\n## [$v] - $d}m;
' CHANGELOG.md

# README の install 行は人間に書かせない。major の基準点だけを機械が同期する。
for f in README.md README.ja.md README_EN.md; do
  [[ -f "$f" ]] || continue
  NAME="$NAME" BASE="$BASE" perl -0pi -e '
    my ($repo, $base) = ($ENV{NAME}, $ENV{BASE});
    s{(\.package\(\s*url:\s*"[^"]*\Q$repo\E(?:\.git)?"[^)]*?from:\s*")[^"]+(")}{$1$base$2}g;
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
