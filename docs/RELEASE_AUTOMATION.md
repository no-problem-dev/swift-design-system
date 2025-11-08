# リリース自動化ガイド

このドキュメントでは、swift-design-systemのリリースプロセスと自動化について説明します。

## リリースワークフロー

### 1. 通常のリリースプロセス

```bash
# 1. feature ブランチで開発
git checkout -b feature/new-feature
# ... 開発作業 ...
git commit -m "feat: add new feature"
git push origin feature/new-feature

# 2. PRを作成してmainにマージ
gh pr create --title "feat: add new feature" --base main

# 3. mainブランチでリリース準備
git checkout main
git pull origin main

# 4. CHANGELOG.mdを更新（手動）
# - [未リリース]セクションに変更内容を記載
# - 新しいバージョンセクションを追加
# - 日付を設定

# 5. README.mdのバージョンを更新（必要に応じて）

# 6. リリースコミット
git add CHANGELOG.md README.md
git commit -m "chore: prepare for v1.0.x release"
git push origin main

# 7. GitHubでリリースを作成
gh release create v1.0.x \
  --title "v1.0.x - Feature Name" \
  --notes-file release_notes.md
```

### 2. 自動化された次バージョン準備

リリース公開後、次のパッチバージョンの準備が **自動的** に行われます。

#### 自動化の仕組み

リリースが公開されると：

1. **GitHub Actions** が自動的にトリガーされる（`.github/workflows/prepare-next-version.yml`）
2. 現在のバージョンタグから次のパッチバージョンを計算（例: v1.0.2 → v1.0.3）
3. `prepare/v1.0.3` ブランチを自動作成
4. CHANGELOG.md の「未リリース」セクションをリセット
5. 変更をコミット・プッシュ
6. PRを自動作成

#### 自動生成されるPRの内容

```markdown
## 概要

v1.0.2 リリース後の次期バージョン v1.0.3 の開発準備PRです。

## 変更内容

- CHANGELOG.md の「未リリース」セクションをリセット

## 備考

このPRはリリース後に自動生成されました。
次の開発サイクルを開始するために、このPRをマージしてください。
```

#### PRのマージ

自動生成されたPRを確認し、問題がなければマージしてください：

```bash
# PRを確認
gh pr view 3

# マージ
gh pr merge 3 --squash
```

## 手動での次バージョン準備

自動化が失敗した場合や、手動で実行したい場合は、以下のスクリプトを使用できます：

```bash
# 現在のバージョンを指定して実行
./scripts/prepare_next_version.sh 1.0.2
```

このスクリプトは以下を実行します：

1. mainブランチであることを確認
2. mainブランチを最新化
3. `prepare/v1.0.3` ブランチを作成
4. CHANGELOG.md の「未リリース」セクションをリセット
5. 変更をコミット・プッシュ
6. PRを作成

## ホットフィックスのリリース

緊急のバグ修正が必要な場合：

```bash
# 1. mainブランチからhotfixブランチを作成
git checkout main
git pull origin main
git checkout -b hotfix/critical-bug

# 2. バグ修正
# ... 修正作業 ...
git commit -m "fix: critical bug"

# 3. PRを作成してmainにマージ
gh pr create --title "fix: critical bug" --base main

# 4. マージ後、通常のリリースプロセスに従う
# パッチバージョンをインクリメント（例: 1.0.2 → 1.0.3）
```

## バージョニング規則

このプロジェクトは [セマンティックバージョニング](https://semver.org/lang/ja/) に従います：

- **MAJOR** (1.x.x): 互換性のない API 変更
- **MINOR** (x.1.x): 後方互換性のある機能追加
- **PATCH** (x.x.1): 後方互換性のあるバグ修正

### いつバージョンを上げるか

- **パッチバージョン**: バグ修正、ドキュメント更新、内部リファクタリング
- **マイナーバージョン**: 新機能追加、コンポーネント追加、非破壊的な機能拡張
- **メジャーバージョン**: 破壊的変更、API の大幅な変更

## CHANGELOG.md の管理

### 変更の分類

CHANGELOGは [Keep a Changelog](https://keepachangelog.com/ja/1.0.0/) 形式に従います：

- **追加 (Added)**: 新機能
- **変更 (Changed)**: 既存機能の変更
- **非推奨 (Deprecated)**: 間もなく削除される機能
- **削除 (Removed)**: 削除された機能
- **修正 (Fixed)**: バグ修正
- **セキュリティ (Security)**: セキュリティ関連の変更

### CHANGELOGの書き方

```markdown
## [未リリース]

### 追加
- 新しいコンポーネント `NewButton` を追加

### 修正
- `Card` コンポーネントの影の表示バグを修正

## [1.0.2] - 2025-11-08

### 追加
- マルチテーマシステム
...
```

## トラブルシューティング

### 自動化が動作しない場合

1. **GitHub Actionsの実行を確認**
   ```bash
   gh run list --workflow=prepare-next-version.yml
   ```

2. **手動でスクリプトを実行**
   ```bash
   ./scripts/prepare_next_version.sh 1.0.2
   ```

3. **ログを確認**
   ```bash
   gh run view <run-id> --log
   ```

### CHANGELOGの更新が失敗した場合

手動で編集してください：

```markdown
## [未リリース]

なし
```

## ベストプラクティス

1. **小さく頻繁にリリース**: 大きな変更を一度にリリースするより、小さな変更を頻繁にリリースする
2. **CHANGELOGを常に最新に**: PRマージ時にCHANGELOGも更新する習慣をつける
3. **セマンティックバージョニングを厳守**: ユーザーが変更の影響を予測できるようにする
4. **リリースノートは詳細に**: ユーザーが変更内容を理解しやすいように書く
5. **自動PRは迅速にマージ**: リリース後すぐに次バージョンの準備を完了させる

## 参考資料

- [セマンティックバージョニング](https://semver.org/lang/ja/)
- [Keep a Changelog](https://keepachangelog.com/ja/1.0.0/)
- [GitHub Actions - Events that trigger workflows](https://docs.github.com/en/actions/using-workflows/events-that-trigger-workflows#release)
