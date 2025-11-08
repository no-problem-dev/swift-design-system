# リリースプロセスガイド

swift-design-systemの新バージョンをリリースする手順を説明します。

## 📋 リリース手順

### 1. リリースブランチで開発

```bash
# リリースブランチに切り替え（例: release/v1.0.12）
git checkout release/v1.0.12
git pull origin release/v1.0.12
```

### 2. CHANGELOG.mdを更新

開発中は「未リリース」セクションに変更を記録：

```markdown
## [未リリース]

### 追加
- 新機能の説明

### 修正
- バグ修正の説明
```

### 3. リリース準備

リリース準備ができたら、「未リリース」をバージョン番号に変換：

```markdown
## [1.0.12] - 2025-11-08

### 追加
- 新機能の説明

### 修正
- バグ修正の説明
```

**重要**: バージョン番号は必ずブランチ名と一致させる（`release/v1.0.12` → `[1.0.12]`）

### 4. 変更をコミット・プッシュ

```bash
git add CHANGELOG.md
git commit -m "chore: prepare for v1.0.12 release"
git push origin release/v1.0.12
```

### 5. PRをmainにマージ

```bash
# PRをマージ（これが自動リリースのトリガー）
gh pr merge <PR番号> --squash
```

**このマージで自動的に実行されること:**
1. タグ `v1.0.12` が作成される
2. GitHub Release `v1.0.12` が作成される
3. 次のリリースブランチ `release/v1.0.13` が作成される
4. 次のリリース用のドラフトPRが作成される

### 6. リリース完了を確認

```bash
# GitHub Releaseを確認
gh release view v1.0.12

# 次のドラフトPRを確認
gh pr list --state all --limit 1
```

## 🔢 バージョニング規則

[セマンティックバージョニング](https://semver.org/lang/ja/)に準拠: `MAJOR.MINOR.PATCH`

| 変更内容 | バージョン | 例 |
|---------|-----------|-----|
| バグ修正のみ | PATCH | 1.0.12 → 1.0.13 |
| 新機能追加（後方互換） | MINOR | 1.0.13 → 1.1.0 |
| 破壊的変更 | MAJOR | 1.1.0 → 2.0.0 |

**注意**: 現在のワークフローは自動的にPATCHをインクリメントします。MINOR/MAJORバージョンアップの場合は、次のリリースブランチ名を手動で調整してください。

## 📝 CHANGELOGの書き方

[Keep a Changelog](https://keepachangelog.com/ja/1.0.0/)形式に準拠します。

### 変更の分類

- **追加 (Added)**: 新機能
- **変更 (Changed)**: 既存機能の変更
- **非推奨 (Deprecated)**: 間もなく削除される機能
- **削除 (Removed)**: 削除された機能
- **修正 (Fixed)**: バグ修正
- **セキュリティ (Security)**: セキュリティ関連の変更

### 良い例

```markdown
## [1.0.12] - 2025-11-08

### 追加
- **新しいテーマ**: Ocean、Forest、Sunset など7種類のビルトインテーマを追加

### 修正
- **ダークモード**: カードコンポーネントの影がダークモードで正しく表示されない問題を修正
```

**良い点:**
- 具体的で詳細な説明
- ユーザーにとっての価値が明確
- 太字で重要なポイントを強調

### 悪い例

```markdown
## [1.0.12] - 2025-11-08

### 変更
- いろいろ修正した
- バグ直した
```

**悪い点:**
- 何が変わったのか不明確
- ユーザーにとっての価値が不明

## ⚙️ 自動化の仕組み

### auto-release-on-merge.yml

**トリガー**: リリースブランチ（`release/vX.Y.Z`）がmainにマージされたとき

**処理内容:**
1. ブランチ名からバージョンを抽出
2. CHANGELOG.mdにバージョンセクションが存在するか検証
3. タグを自動作成してプッシュ
4. CHANGELOG.mdから該当バージョンのセクションを抽出
5. リリースノートを生成
6. GitHub Releaseを作成
7. 次のバージョンを計算（PATCHインクリメント）
8. 次のリリースブランチを作成
9. CHANGELOG.mdに「未リリース」セクションを追加
10. 次のリリース用のドラフトPRを作成

### フロー図

```
PRマージ (release/vX.Y.Z → main)
  ↓
auto-release-on-merge.yml 実行
  ↓
タグ作成 → GitHub Release作成 → 次のリリース準備
```

## 🔧 トラブルシューティング

### CHANGELOG検証エラー

**エラー**: `❌ エラー: CHANGELOG.mdにバージョン [X.Y.Z] のセクションが見つかりません`

**対処法**:
1. リリースブランチでCHANGELOG.mdを修正
2. フォーマットを確認: `## [X.Y.Z] - YYYY-MM-DD`
3. 再度コミット・プッシュしてPRをマージ

### GitHub Release作成失敗

**原因**: ワークフローの権限不足

**対処法**:
1. リポジトリ設定 > Actions > General
2. "Workflow permissions" を "Read and write permissions" に設定

### バージョン番号を間違えた場合

**マージ前**: PRを閉じて、CHANGELOG.mdを修正してから再度PRを作成

**マージ後**:
```bash
# タグを削除
git push origin :refs/tags/vX.Y.Z

# GitHub Releaseを手動で削除（Webページから）

# mainブランチでCHANGELOG.mdを修正してコミット
# 正しいバージョンで再度リリースブランチを作成してPRをマージ
```

## 📚 参考資料

- [セマンティックバージョニング](https://semver.org/lang/ja/)
- [Keep a Changelog](https://keepachangelog.com/ja/1.0.0/)
- [GitHub Releases](https://docs.github.com/ja/repositories/releasing-projects-on-github/about-releases)

## 📁 関連ファイル

- [.github/workflows/auto-release-on-merge.yml](.github/workflows/auto-release-on-merge.yml) - リリース自動化ワークフロー
- [CHANGELOG.md](CHANGELOG.md) - 変更履歴
