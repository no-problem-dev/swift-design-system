#!/bin/bash

# 次のパッチバージョンの準備を行うスクリプト
# 使用方法: ./scripts/prepare_next_version.sh [current_version]
# 例: ./scripts/prepare_next_version.sh 1.0.2

set -e

# 引数チェック
if [ $# -eq 0 ]; then
    echo "エラー: 現在のバージョンを指定してください"
    echo "使用方法: $0 <current_version>"
    echo "例: $0 1.0.2"
    exit 1
fi

CURRENT_VERSION="$1"

# バージョン番号からパッチバージョンをインクリメント
IFS='.' read -r MAJOR MINOR PATCH <<< "$CURRENT_VERSION"
NEXT_PATCH=$((PATCH + 1))
NEXT_VERSION="$MAJOR.$MINOR.$NEXT_PATCH"

echo "現在のバージョン: v$CURRENT_VERSION"
echo "次のバージョン: v$NEXT_VERSION"

# mainブランチにいることを確認
CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
if [ "$CURRENT_BRANCH" != "main" ]; then
    echo "エラー: mainブランチから実行してください（現在のブランチ: $CURRENT_BRANCH）"
    exit 1
fi

# mainブランチを最新化
echo "mainブランチを最新化..."
git pull origin main

# 新しいブランチを作成
BRANCH_NAME="prepare/v${NEXT_VERSION}"
echo "ブランチを作成: $BRANCH_NAME"
git checkout -b "$BRANCH_NAME"

# CHANGELOGを更新
echo "CHANGELOG.mdを更新..."
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS
    sed -i '' '/## \[未リリース\]/,/^## \[/{
        /## \[未リリース\]/!{
            /^## \[/!d
        }
    }' CHANGELOG.md
    sed -i '' '/## \[未リリース\]/a\
\
なし
' CHANGELOG.md
else
    # Linux
    sed -i '/## \[未リリース\]/,/^## \[/{
        /## \[未リリース\]/!{
            /^## \[/!d
        }
    }' CHANGELOG.md
    sed -i '/## \[未リリース\]/a\\n\nなし' CHANGELOG.md
fi

# 変更をコミット
echo "変更をコミット..."
git add CHANGELOG.md
git commit -m "chore: prepare for v${NEXT_VERSION} development"

# ブランチをプッシュ
echo "ブランチをプッシュ..."
git push origin "$BRANCH_NAME"

# PRを作成
echo "プルリクエストを作成..."
gh pr create \
    --title "chore: prepare for v${NEXT_VERSION} development" \
    --body "## 概要

v${CURRENT_VERSION} リリース後の次期バージョン v${NEXT_VERSION} の開発準備PRです。

## 変更内容

- CHANGELOG.md の「未リリース」セクションをリセット

## 備考

このPRは次の開発サイクルを開始するためのものです。

---

🤖 このPRは \`scripts/prepare_next_version.sh\` により生成されました。" \
    --base main \
    --head "$BRANCH_NAME"

echo "✅ 完了！"
echo "PR URL: $(gh pr view --json url -q .url)"
