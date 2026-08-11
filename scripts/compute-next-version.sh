#!/bin/bash
# 次の版を「決める」のではなく「計算する」。
#
# 公開 API の実差分から必要な bump を求め、次の版を標準出力に出す。
# 人間が版番号を判断する余地を残さないための機構。
#
#   使い方: scripts/compute-next-version.sh [--repo <path>] [--baseline <tag>]
#   出力  : bump=<major|minor|patch> current=<x.y.z> next=<x.y.z> removed=<n> added=<n>
#
# 判定（強い順に評価して最も強いものを採る）:
#   public dependency が世代を上げた            → 破壊的   ← シンボル差分には映らない
#   public シンボルの削除・シグネチャ変更あり   → 破壊的
#   追加のみ                                    → 追加
#   どちらも無い                                → 無変化
#
# 版への写し方は 1.0.0 を境に変わる（SemVer 4 項: 0.y.z の互換性は保証されない）:
#   1.x 以降 : 破壊的 → major / 追加 → minor / 無変化 → patch
#   0.x      : 破壊的 → minor / それ以外 → patch
#              （0.x で major を繰り上げると「安定版を出した」という別の意味になるため）
#
# public dependency とは、その型が自分の public シグネチャに露出している依存のこと。
# semver.org の FAQ は「公開 API を変えずに依存を更新するのは互換」と明言しており、
# 依存を上げただけで major を打つのは誤り。ただし Rust API Guidelines C-STABLE / RFC 1977 が
# 定める例外があり、**依存の型が自分の公開 API に出ている場合は、その依存の major は自分の major になる**。
# 利用者はその型を自分のコードで扱うので、依存の世代が変われば利用者のコードが壊れるため。
#
# なぜシンボル差分だけでは足りないか（実測で判明）:
#   voice-input 1.1.1 → 2.0.0 は design-system を 1.x → 2.0.1 へ上げている。
#   DesignSystem の型は voice-input の公開 API に 130 箇所出ているが、**型名の綴りは変わらない**ので
#   USR も宣言文字列も同一になり、シンボル差分では removed=0 added=0 = patch と出てしまう。
#   実際には利用者は DesignSystem 2.x へ移行させられるので major が正しい。
#   この偽陰性は swift package diagnose-api-breaking-changes も同じく持つ。
#
# なぜこれが要るか（2026-08-10 の実測）:
#   29 回の major のうち 4 回は「依存のピンを上げただけ」で、自分の公開 API は無変更だった。
#   voice-input 2.0.0 は Package.swift 1 行の変更しかなく、本スクリプトで測ると
#   削除 0 / 追加 0 = patch。正しくは 1.1.2 だった。
#   被依存の多いパッケージの major が消費者へ連鎖し、dep-generation-gap を量産していた。
#
# 落とし穴（これを踏むと機構が壊れる）:
#   --skip-synthesized-members と SYNTHESIZED 除外は必須。付けないと、依存が
#   SwiftUI の View 等に生やした extension が自分の型に合成されて公開面に現れ、
#   **依存を上げるたびに API が変わったように見える**。voice-input の実測では
#   1738 件 → 50 件 と 35 倍違った。測っているものが自分の API ではなくなる。

set -eo pipefail

REPO="$(pwd)"
BASELINE=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --repo) REPO="$2"; shift 2 ;;
    --baseline) BASELINE="$2"; shift 2 ;;
    *) echo "unknown option: $1" >&2; exit 2 ;;
  esac
done

cd "$REPO"

latest_semver_tag() {
  git tag | grep -E '^v?[0-9]+\.[0-9]+\.[0-9]+$' \
    | sed 's/^v//' | sort -t. -k1,1n -k2,2n -k3,3n | tail -1
}

# 自前の public API 表面を「USR + 宣言文字列」の集合として書き出す。
# 宣言文字列も含めるのは、USR が同じままシグネチャだけ変わる破壊的変更を捉えるため。
#
# 読むのは今回の dump が書いた出力ディレクトリだけ。.build 全体を舐めると、DocC や
# oss-doctor が以前に残した extracted-symbols/ の古い *.symbols.json まで cat され、
# 「昔の宣言」と「今の宣言」の和集合が HEAD 側として出てくる。古い行が消えないので
# removed=0 になり、シグネチャ変更を捉えるという上の目的がそこで無効化される。
dump_api() {
  local dir="$1" out="$2" graph_dir
  : > "$out"
  graph_dir="$( cd "$dir" && swift package dump-symbol-graph \
      --minimum-access-level public --skip-synthesized-members 2>/dev/null \
      | sed -n 's/^Files written to //p' | tail -1 || true )"
  [ -n "$graph_dir" ] && [ -d "$graph_dir" ] || return 0
  find "$graph_dir" -name '*.symbols.json' -exec cat {} + 2>/dev/null \
    | jq -r '.symbols[]? | select(.accessLevel=="public" or .accessLevel=="open")
             | select(.identifier.precise|contains("SYNTHESIZED")|not)
             | "\(.identifier.precise)\t\([.declarationFragments[]?.spelling]|join(""))"' \
    | sort -u > "$out"
}

CURRENT="$(latest_semver_tag || true)"
if [ -z "$CURRENT" ]; then
  echo "bump=initial current=none next=0.1.0 removed=0 added=0"
  exit 0
fi
[ -z "$BASELINE" ] && BASELINE="$CURRENT"

BASE_REF="$BASELINE"
git rev-parse -q --verify "$BASE_REF" >/dev/null 2>&1 || BASE_REF="v$BASELINE"
if ! git rev-parse -q --verify "$BASE_REF" >/dev/null 2>&1; then
  echo "baseline タグが見つからない: $BASELINE" >&2
  exit 1
fi

WORK="$(mktemp -d)"
cleanup() { git worktree remove --force "$WORK/baseline" >/dev/null 2>&1 || true; rm -rf "$WORK"; }
trap cleanup EXIT

git worktree add --detach "$WORK/baseline" "$BASE_REF" >/dev/null 2>&1
dump_api "$WORK/baseline" "$WORK/baseline.api"
dump_api "$REPO" "$WORK/head.api"

# どちらかが空なら測定に失敗している。baseline が空だと patch、HEAD が空だと全消し=major と
# 誤判定するので、どちらも黙って通さない。
if [ ! -s "$WORK/baseline.api" ]; then
  echo "baseline の symbol graph を取得できなかった（ビルド失敗の可能性）" >&2
  exit 1
fi
if [ ! -s "$WORK/head.api" ]; then
  echo "HEAD の symbol graph を取得できなかった（ビルド失敗の可能性）" >&2
  exit 1
fi

REMOVED=$(comm -23 "$WORK/baseline.api" "$WORK/head.api" | wc -l | tr -d ' ')
ADDED=$(comm -13 "$WORK/baseline.api" "$WORK/head.api" | wc -l | tr -d ' ')

# --- public dependency の世代変化を見る（シンボル差分に映らない破壊的変更） ---

# 自分の public 宣言に型が現れる外部モジュール名の集合。
leaked_modules() {
  local dir="$1"
  find "$dir/.build" -name '*.symbols.json' -exec cat {} + 2>/dev/null \
    | jq -r '.symbols[]? | select(.accessLevel=="public" or .accessLevel=="open")
             | select(.identifier.precise|contains("SYNTHESIZED")|not)
             | .declarationFragments[]? | select(.kind=="typeIdentifier") | .preciseIdentifier // empty' \
    | grep -oE '^s:[0-9]+[A-Za-z0-9_]+' \
    | sed -E 's/^s:([0-9]+)([A-Za-z0-9_]+)/\1 \2/' \
    | awk '{print substr($2,1,$1)}' | sort -u
}

# Package.swift の内部依存を「リポ名 → ピンの major」で書き出す。
dep_majors() {
  grep -oE 'no-problem-dev/[A-Za-z0-9._-]+\.git"[^)]*?from: *"[0-9]+' "$1/Package.swift" 2>/dev/null \
    | sed -E 's|no-problem-dev/([A-Za-z0-9._-]+)\.git".*from: *"([0-9]+)|\1 \2|' | sort -u
}

leaked_modules "$REPO" > "$WORK/leaked" || true
dep_majors "$WORK/baseline" > "$WORK/dep.base" || true
dep_majors "$REPO"          > "$WORK/dep.head" || true

# モジュール名とリポ名の対応は綴りで取る（swift-design-system ↔ DesignSystem）。
#
# 突合にプロセス置換 <(...) を使わないこと。この環境の grep は ugrep で、
# プロセス置換を渡すと**一致しても常に false を返す**。検査が静かに発火しなくなり、
# 「緑だが何も見ていない」状態を作る。実ファイル経由で比較する。
tr 'A-Z' 'a-z' < "$WORK/leaked" | sort -u > "$WORK/leaked.lc"

PUBLIC_DEP_BREAK=""
while read -r repo_name base_major; do
  [ -z "${repo_name:-}" ] && continue
  [ -z "${base_major:-}" ] && continue
  head_major=$(awk -v r="$repo_name" '$1==r {print $2}' "$WORK/dep.head" | head -1)
  [ -z "$head_major" ] && continue
  [ "$base_major" = "$head_major" ] && continue
  key=$(printf '%s' "$repo_name" | sed 's/^swift-//; s/-//g' | tr 'A-Z' 'a-z')
  if grep -qixF "$key" "$WORK/leaked.lc"; then
    PUBLIC_DEP_BREAK="$PUBLIC_DEP_BREAK $repo_name($base_major->$head_major)"
  fi
done < "$WORK/dep.base"

MAJOR="${CURRENT%%.*}"
REST="${CURRENT#*.}"
MINOR="${REST%%.*}"
PATCH="${CURRENT##*.}"

# 0.x は minor が破壊的軸（SemVer 4 項: 0.y.z の互換性は保証されない）。
# 1.0.0 未満で major を繰り上げると「安定版を出した」という別の意味になってしまうため、
# 破壊的変更は minor、非破壊は patch に写す。oss-doctor の dep-generation-gap と同じ規則。
if [ "$REMOVED" -gt 0 ] || [ -n "$PUBLIC_DEP_BREAK" ]; then
  BREAKING=true
else
  BREAKING=false
fi

if [ -n "$PUBLIC_DEP_BREAK" ]; then
  REASON="public dependency の世代変化:$PUBLIC_DEP_BREAK"
elif [ "$REMOVED" -gt 0 ]; then
  REASON="public シンボルの削除・変更 ${REMOVED} 件"
elif [ "$ADDED" -gt 0 ]; then
  REASON="public シンボルの追加 ${ADDED} 件"
else
  REASON="公開 API に変化なし"
fi

if [ "$MAJOR" -eq 0 ]; then
  if [ "$BREAKING" = true ]; then
    BUMP=minor; NEXT="0.$((MINOR + 1)).0"
  else
    BUMP=patch; NEXT="0.${MINOR}.$((PATCH + 1))"
  fi
else
  if [ "$BREAKING" = true ]; then
    BUMP=major; NEXT="$((MAJOR + 1)).0.0"
  elif [ "$ADDED" -gt 0 ]; then
    BUMP=minor; NEXT="${MAJOR}.$((MINOR + 1)).0"
  else
    BUMP=patch; NEXT="${MAJOR}.${MINOR}.$((PATCH + 1))"
  fi
fi

echo "bump=$BUMP current=$CURRENT next=$NEXT removed=$REMOVED added=$ADDED"
echo "reason=$REASON" >&2
