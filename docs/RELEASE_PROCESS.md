# リリースプロセスガイド

このドキュメントでは、swift-design-systemの正しいリリースプロセスを説明します。

## 概要

このプロジェクトは **ハイブリッドアプローチ** を採用しています：

- **CHANGELOG.md**: 人間が手動で管理（Keep a Changelog形式）
- **GitHub Releases**: Gitタグから自動生成

## リリースワークフロー

### 1. 開発フェーズ

新機能やバグ修正を開発する際：

```bash
# feature ブランチで開発
git checkout -b feature/new-component

# 開発作業...
# CHANGELOG.mdの「未リリース」セクションに変更内容を追記
```

**CHANGELOG.md の更新例：**
```markdown
## [未リリース]

### 追加
- 新しいOceanテーマを追加

### 修正
- カードコンポーネントの影の表示バグを修正

## [1.0.3] - 2025-11-08
...
```

```bash
# PRを作成してmainにマージ
gh pr create --title "feat: add Ocean theme" --base main
```

### 2. リリース準備

複数の変更が蓄積したら、リリースの準備をします：

```bash
# mainブランチを最新化
git checkout main
git pull origin main

# CHANGELOG.mdを編集
```

**CHANGELOG.md の更新：**
```markdown
## [未リリース]

なし

## [1.0.4] - 2025-11-08

### 追加
- 新しいOceanテーマを追加

### 修正
- カードコンポーネントの影の表示バグを修正

### ドキュメント
- インストール方法をupToNextMajorに変更

## [1.0.3] - 2025-11-08
...

[未リリース]: https://github.com/no-problem-dev/swift-design-system/compare/v1.0.4...HEAD
[1.0.4]: https://github.com/no-problem-dev/swift-design-system/compare/v1.0.3...v1.0.4
[1.0.3]: https://github.com/no-problem-dev/swift-design-system/compare/v1.0.2...v1.0.3
...
```

```bash
# 変更をコミット
git add CHANGELOG.md
git commit -m "chore: prepare for v1.0.4 release"
git push origin main
```

### 3. タグ作成とプッシュ

```bash
# バージョンタグを作成
git tag v1.0.4

# タグをプッシュ（これが自動リリースをトリガー）
git push origin v1.0.4
```

### 4. 自動リリース

タグがプッシュされると、GitHub Actionsが自動的に：

1. CHANGELOG.mdから該当バージョンのセクションを抽出
2. リリースノートとして整形
3. GitHub Releaseを自動作成

**作成されるリリース：**
- タイトル: `v1.0.4`
- 本文: CHANGELOG.mdから抽出された内容
- リリースURL: `https://github.com/no-problem-dev/swift-design-system/releases/tag/v1.0.4`

### 5. 確認

リリースが正常に作成されたことを確認：

```bash
# GitHub Actionsの実行状況を確認
gh run list --workflow=release.yml --limit 3

# 作成されたリリースを確認
gh release view v1.0.4
```

## バージョニング規則

このプロジェクトは [セマンティックバージョニング](https://semver.org/lang/ja/) に従います：

- **MAJOR** (1.x.x): 互換性のない破壊的変更
- **MINOR** (x.1.x): 後方互換性のある機能追加
- **PATCH** (x.x.1): 後方互換性のあるバグ修正

### バージョン決定ガイド

| 変更内容 | バージョン | 例 |
|---------|-----------|-----|
| バグ修正 | PATCH | 1.0.3 → 1.0.4 |
| 新コンポーネント追加 | MINOR | 1.0.4 → 1.1.0 |
| API の破壊的変更 | MAJOR | 1.1.0 → 2.0.0 |
| ドキュメント更新のみ | PATCH | 1.0.3 → 1.0.4 |

## CHANGELOG.md の書き方

### Keep a Changelog 形式

[Keep a Changelog](https://keepachangelog.com/ja/1.0.0/) に準拠します：

**変更の分類：**
- **追加 (Added)**: 新機能
- **変更 (Changed)**: 既存機能の変更
- **非推奨 (Deprecated)**: 間もなく削除される機能
- **削除 (Removed)**: 削除された機能
- **修正 (Fixed)**: バグ修正
- **セキュリティ (Security)**: セキュリティ関連の変更

### 良い例

```markdown
## [1.0.4] - 2025-11-08

### 追加
- 新しいOceanテーマを追加し、7種類のテーマから選択可能に

### 修正
- ダークモードでのカードの影が正しく表示されない問題を修正
- TextFieldのフォーカス状態が視覚的に分かりづらかった問題を改善

### ドキュメント
- READMEのインストール方法を`upToNextMajor`に変更し、ベストプラクティスに準拠
```

### 悪い例

```markdown
## [1.0.4] - 2025-11-08

### 変更
- いろいろ修正した
- バグ直した
- 更新
```

**理由：**
- 何が変わったのか具体的でない
- ユーザーにとって価値がわからない
- 技術的な詳細が不足

## ホットフィックスのリリース

緊急のバグ修正が必要な場合：

```bash
# mainブランチからhotfixブランチを作成
git checkout main
git pull origin main
git checkout -b hotfix/critical-security-issue

# バグ修正
# ... 修正作業 ...

# PRを作成してmainにマージ
gh pr create --title "fix: critical security issue" --base main

# マージ後、通常のリリースプロセスに従う
# パッチバージョンをインクリメント（例: 1.0.4 → 1.0.5）
```

## トラブルシューティング

### リリースが自動作成されない

1. **GitHub Actionsの実行を確認**
   ```bash
   gh run list --workflow=release.yml
   ```

2. **ワークフローのログを確認**
   ```bash
   gh run view <run-id> --log
   ```

3. **権限の確認**
   - リポジトリ設定 > Actions > General
   - "Workflow permissions" が "Read and write permissions" になっているか確認

### CHANGELOG.mdからの抽出が失敗

CHANGELOG.mdの形式が正しいか確認：

```markdown
## [1.0.4] - 2025-11-08

### 追加
...

## [1.0.3] - 2025-11-08
```

- バージョン番号が `## [1.0.4]` の形式になっているか
- 各バージョンの間に空行があるか

### タグを間違えて作成した

```bash
# ローカルのタグを削除
git tag -d v1.0.4

# リモートのタグを削除
git push origin :refs/tags/v1.0.4

# 正しいタグを再作成
git tag v1.0.4
git push origin v1.0.4
```

## ベストプラクティス

1. **小さく頻繁にリリース**
   - 大きな変更を一度にリリースするより、小さな変更を頻繁にリリースする
   - ユーザーは小さな変更の方が受け入れやすい

2. **CHANGELOGは開発と同時に更新**
   - PRマージ時にCHANGELOGも更新する習慣をつける
   - リリース時にまとめて書くと忘れやすい

3. **ユーザー視点で書く**
   - 技術的な詳細より、ユーザーにとっての価値を書く
   - 「○○を修正」より「○○が正しく動作するようになりました」

4. **リンクを活用**
   - PR番号やIssue番号を記載
   - ユーザーが詳細を確認しやすくする

5. **セマンティックバージョニングを厳守**
   - ユーザーが変更の影響を予測できるようにする
   - 破壊的変更は必ずMAJORバージョンを上げる

## 参考資料

- [セマンティックバージョニング](https://semver.org/lang/ja/)
- [Keep a Changelog](https://keepachangelog.com/ja/1.0.0/)
- [Conventional Commits](https://www.conventionalcommits.org/ja/v1.0.0/)
- [GitHub Actions - Events that trigger workflows](https://docs.github.com/en/actions/using-workflows/events-that-trigger-workflows#push)
