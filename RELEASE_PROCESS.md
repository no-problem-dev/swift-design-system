# リリースプロセスガイド

このドキュメントでは、swift-design-systemの正しいリリースプロセスと、その背景にある思想・コンセプトを説明します。

## 目次

- [リリース思想とコンセプト](#リリース思想とコンセプト)
- [リリースワークフロー](#リリースワークフロー)
- [詳細な手順](#詳細な手順)
- [バージョニング規則](#バージョニング規則)
- [CHANGELOGの書き方](#changelogの書き方)
- [自動化の仕組み](#自動化の仕組み)
- [トラブルシューティング](#トラブルシューティング)
- [ベストプラクティス](#ベストプラクティス)

## リリース思想とコンセプト

### ハイブリッドアプローチ

このプロジェクトは **ハイブリッドアプローチ** を採用しています：

- **CHANGELOG.md**: 人間が手動で管理（Keep a Changelog形式）
- **GitHub Releases**: Gitタグから自動生成

#### なぜハイブリッドなのか？

**完全自動化アプローチの問題点：**
- Git commitメッセージからCHANGELOGを自動生成すると、技術的すぎて読みにくい
- ユーザー視点での価値が伝わりにくい
- 重要な変更とマイナーな変更の区別がつきにくい

**完全手動アプローチの問題点：**
- CHANGELOGとGitHub Releasesの二重メンテナンスが必要
- 人的ミスによる不整合が発生しやすい
- リリース作業に時間がかかる

**ハイブリッドアプローチの利点：**
- ✅ 人間がCHANGELOGを丁寧に書くことで、ユーザーに価値を伝えやすい
- ✅ GitHub Releaseは自動生成されるため、二重メンテナンス不要
- ✅ リリース作業が効率化され、ミスが減る
- ✅ Keep a Changelogのベストプラクティスに準拠

### セマンティックバージョニング

[セマンティックバージョニング](https://semver.org/lang/ja/)に準拠することで：

- **ユーザーが変更の影響を予測できる**
- **依存関係管理が容易になる**
- **後方互換性への意識が高まる**

バージョン形式: `MAJOR.MINOR.PATCH`

- **MAJOR** (1.x.x): 互換性のない破壊的変更
- **MINOR** (x.1.x): 後方互換性のある機能追加
- **PATCH** (x.x.1): 後方互換性のあるバグ修正

### Keep a Changelog

[Keep a Changelog](https://keepachangelog.com/ja/1.0.0/)形式を採用する理由：

- **人間が読みやすい**: ユーザー視点で書かれた変更履歴
- **標準化されている**: 広く採用されているフォーマット
- **検索しやすい**: バージョンごとに整理されている
- **リンク可能**: 各バージョンへの比較リンクを含む

### 完全自動化されたリリースフロー

タグをプッシュすると、以下が自動的に実行されます：

1. **GitHub Releaseの作成** (release.yml)
   - CHANGELOG.mdから該当バージョンを抽出
   - 整形されたリリースノートを生成
   - インストール方法とリンクを追加

2. **次回リリースの準備** (prepare-next-release.yml)
   - 新しい「未リリース」セクションを追加
   - 比較リンクを最新バージョンに更新
   - ドラフトPRを自動作成

この自動化により：
- **リリース後の手作業を削減**: 次回リリース準備が自動化
- **一貫性の確保**: 常に同じ形式でリリースが作成される
- **ミスの防止**: 手動更新忘れがなくなる

## リリースワークフロー

### 全体像

```
開発 → PRマージ → 蓄積 → リリース準備 → タグプッシュ → 自動化
  ↓        ↓         ↓          ↓            ↓           ↓
feature  CHANGELOG  複数の    バージョン    release    次回準備PR
ブランチ  更新      変更      セクション    作成       自動作成
```

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

## [1.0.9] - 2025-11-08
...
```

```bash
# PRを作成してmainにマージ
gh pr create --title "feat: add Ocean theme" --base main
```

**重要**: PRマージ時にCHANGELOGも更新する習慣をつけましょう。リリース時にまとめて書くと忘れやすくなります。

### 2. リリース準備

複数の変更が蓄積したら、リリースの準備をします：

```bash
# mainブランチを最新化
git checkout main
git pull origin main
```

CHANGELOG.mdを編集して、「未リリース」セクションを新しいバージョンセクションに変換します。

### 3. タグ作成とプッシュ

```bash
# バージョンタグを作成
git tag v1.0.10

# タグをプッシュ（これが自動リリースをトリガー）
git push origin v1.0.10
```

### 4. 自動化の実行

タグがプッシュされると、2つのワークフローが並行実行されます：

#### release.yml
- CHANGELOG.mdから該当バージョンを抽出
- 整形されたリリースノートを生成
- GitHub Releaseを作成

#### prepare-next-release.yml
- `chore/prepare-next-release`ブランチを作成
- 新しい「未リリース」セクションを追加
- 比較リンクを最新バージョンに自動更新
- ドラフトPRを作成

### 5. ドラフトPRをマージ

次の開発サイクルを開始するため、自動作成されたドラフトPRをマージします：

```bash
# PRをReady for reviewに変更
gh pr ready <PR番号>

# PRをマージ
gh pr merge <PR番号> --squash

# ローカルを更新
git pull origin main
```

## 詳細な手順

### ステップ1: 最新のmainブランチを取得

```bash
git checkout main
git pull origin main
```

### ステップ2: CHANGELOG.mdを更新

#### 2.1 「未リリース」セクションをバージョンセクションに変換

**変更前:**
```markdown
## [未リリース]

### 追加
- 新機能Aを追加
- 新機能Bを追加

### 修正
- バグXを修正
```

**変更後:**
```markdown
## [1.0.10] - 2025-11-08

### 追加
- 新機能Aを追加
- 新機能Bを追加

### 修正
- バグXを修正
```

**重要事項:**
- バージョン番号は[セマンティックバージョニング](#バージョニング規則)に従う
- 日付は`YYYY-MM-DD`形式で記載

#### 2.2 比較リンクセクションを更新

ファイルの末尾にある比較リンクセクションを更新します：

**変更前:**
```markdown
[未リリース]: https://github.com/no-problem-dev/swift-design-system/compare/v1.0.9...HEAD
[1.0.9]: https://github.com/no-problem-dev/swift-design-system/compare/v1.0.8...v1.0.9
```

**変更後:**
```markdown
[未リリース]: https://github.com/no-problem-dev/swift-design-system/compare/v1.0.10...HEAD
[1.0.10]: https://github.com/no-problem-dev/swift-design-system/compare/v1.0.9...v1.0.10
[1.0.9]: https://github.com/no-problem-dev/swift-design-system/compare/v1.0.8...v1.0.9
```

**注意**:
- `[未リリース]`のリンクは新バージョンを基準に更新
- 新バージョンの比較リンクを追加

### ステップ3: 変更をコミット

```bash
git add CHANGELOG.md
git commit -m "chore: vX.Y.Zリリース準備"
git push origin main
```

### ステップ4: タグを作成してプッシュ

```bash
git tag vX.Y.Z
git push origin vX.Y.Z
```

**例:**
```bash
git tag v1.0.10
git push origin v1.0.10
```

### ステップ5: 自動化の確認

#### 5.1 release.ymlワークフローの確認

```bash
# ワークフローの実行状況を確認
gh run list --workflow=release.yml --limit 1

# 詳細ログを確認（必要に応じて）
gh run view <run-id> --log
```

GitHubのWebページでも確認可能:
https://github.com/no-problem-dev/swift-design-system/actions/workflows/release.yml

**完了後の確認:**
```bash
# 作成されたリリースを確認
gh release view vX.Y.Z
```

または:
https://github.com/no-problem-dev/swift-design-system/releases

#### 5.2 prepare-next-release.ymlワークフローの確認

```bash
# ワークフローの実行状況を確認
gh run list --workflow=prepare-next-release.yml --limit 1

# 作成されたPRを確認
gh pr list --state all --limit 1
```

GitHubのWebページでも確認可能:
https://github.com/no-problem-dev/swift-design-system/pulls

**ドラフトPRの内容確認:**
- タイトル: "chore: prepare for next release"
- ステータス: DRAFT
- 変更内容: 新しい「未リリース」セクションと更新された比較リンク

### ステップ6: ドラフトPRをマージ

```bash
# PRをReady for reviewに変更
gh pr ready <PR番号>

# PRをマージ
gh pr merge <PR番号> --squash

# ローカルブランチを更新
git pull origin main
```

## バージョニング規則

### セマンティックバージョニング

バージョン形式: `MAJOR.MINOR.PATCH` (例: 1.2.3)

| 変更内容 | バージョン | 例 |
|---------|-----------|-----|
| バグ修正のみ | PATCH | 1.0.9 → 1.0.10 |
| 新機能追加（後方互換） | MINOR | 1.0.10 → 1.1.0 |
| 破壊的変更 | MAJOR | 1.1.0 → 2.0.0 |
| ドキュメント更新のみ | PATCH | 1.0.9 → 1.0.10 |
| 依存関係の更新 | PATCH | 1.0.9 → 1.0.10 |

### 破壊的変更の例

- 公開APIの削除
- 関数のシグネチャ変更
- デフォルト動作の変更
- 必須パラメータの追加

**破壊的変更の場合は、必ずMAJORバージョンを上げてください。**

### ホットフィックス

緊急のバグ修正が必要な場合はPATCHバージョンをインクリメント：

```bash
# 現在: v1.0.10
# 緊急バグ修正 → v1.0.11

git checkout main
git pull origin main

# バグ修正
# CHANGELOG.md更新

git add .
git commit -m "fix: critical security issue"
git push origin main

git tag v1.0.11
git push origin v1.0.11
```

## CHANGELOGの書き方

### Keep a Changelog形式

[Keep a Changelog](https://keepachangelog.com/ja/1.0.0/)に準拠します。

#### 変更の分類

- **追加 (Added)**: 新機能
- **変更 (Changed)**: 既存機能の変更
- **非推奨 (Deprecated)**: 間もなく削除される機能
- **削除 (Removed)**: 削除された機能
- **修正 (Fixed)**: バグ修正
- **セキュリティ (Security)**: セキュリティ関連の変更

### 良い例

```markdown
## [1.0.10] - 2025-11-08

### 追加
- **新しいテーマ**: Ocean、Forest、Sunset など7種類のビルトインテーマを追加
- **タイポグラフィシステム**: 一貫したテキストスタイルを提供する Typography modifier を追加

### 修正
- **ダークモード**: カードコンポーネントの影がダークモードで正しく表示されない問題を修正
- **フォーカス状態**: TextFieldのフォーカス状態が視覚的に分かりづらかった問題を改善

### ドキュメント
- READMEのインストール方法を`upToNextMajor`に変更し、ベストプラクティスに準拠
```

**良い点:**
- 具体的で詳細な説明
- ユーザーにとっての価値が明確
- 太字で重要なポイントを強調
- 技術的な背景を簡潔に記載

### 悪い例

```markdown
## [1.0.10] - 2025-11-08

### 変更
- いろいろ修正した
- バグ直した
- 更新
- テーマ追加
```

**悪い点:**
- 何が変わったのか不明確
- ユーザーにとっての価値が不明
- 技術的な詳細が不足
- 検索しづらい

### 記述のポイント

1. **ユーザー視点で書く**
   - ❌ 「ColorPaletteプロトコルを実装」
   - ✅ 「カスタムカラーパレットを作成できるようになりました」

2. **具体的に書く**
   - ❌ 「パフォーマンス改善」
   - ✅ 「大量のコンポーネント表示時のレンダリング速度を50%向上」

3. **影響範囲を明記**
   - ❌ 「API変更」
   - ✅ 「`ThemeProvider`の初期化パラメータを変更（破壊的変更）」

4. **リンクを活用**
   ```markdown
   ### 修正
   - カラーパレットの型安全性を向上 (#123)
   ```

## 自動化の仕組み

### release.ymlワークフロー

**トリガー**: タグプッシュ (`push: tags: - 'v*'`)

**処理内容:**

1. **バージョン抽出**
   ```bash
   VERSION=${GITHUB_REF#refs/tags/v}  # v1.0.10 → 1.0.10
   ```

2. **CHANGELOG抽出**
   - 該当バージョンのセクションを抽出
   - バージョン見出しとリンクセクションを削除
   - 空行を整理

3. **リリースノート生成**
   ```markdown
   # 🎉 v1.0.10 リリース

   swift-design-system v1.0.10 がリリースされました。

   ## 📝 変更内容
   [CHANGELOG.mdから抽出した内容]

   ## 📦 インストール
   [インストール方法]

   ## 🔗 リンク
   - 変更履歴
   - ドキュメント
   ```

4. **GitHub Release作成**
   - `softprops/action-gh-release`を使用
   - 生成されたリリースノートを本文に設定

### prepare-next-release.ymlワークフロー

**トリガー**: タグプッシュ (`push: tags: - 'v*'`) または手動実行

**処理内容:**

1. **バージョン抽出**
   ```bash
   VERSION=${GITHUB_REF#refs/tags/v}  # タグイベントの場合
   VERSION=$(git describe --tags --abbrev=0 | sed 's/^v//')  # 手動実行の場合
   ```

2. **既存ブランチ削除**
   ```bash
   git push origin --delete chore/prepare-next-release 2>/dev/null || true
   ```

3. **新ブランチ作成**
   ```bash
   git checkout -b chore/prepare-next-release
   ```

4. **CHANGELOG更新**
   - 「未リリース」セクションが存在しない場合のみ実行
   - 最初のバージョンセクションの前に挿入
   - 比較リンクを最新バージョンに更新

5. **ドラフトPR作成**
   - `gh pr create --draft`を使用
   - 開発フローの説明を本文に含む

**条件付き実行:**
- すべてのステップは`if: steps.update_changelog.outputs.updated == 'true'`で制御
- 「未リリース」セクションが既に存在する場合はスキップ

## トラブルシューティング

### ワークフローが失敗した場合

#### release.ymlの失敗

**エラー**: `⚠️ CHANGELOG.mdにバージョン X.Y.Z が見つかりませんでした`

**原因**: CHANGELOG.mdに該当バージョンのセクションが存在しない

**対処法**:
1. CHANGELOG.mdに正しいバージョンセクションが存在するか確認
2. フォーマットが`## [X.Y.Z] - YYYY-MM-DD`になっているか確認
3. 修正後、タグを削除して再プッシュ:
```bash
git tag -d vX.Y.Z
git push origin :refs/tags/vX.Y.Z
# CHANGELOG.md修正
git add CHANGELOG.md
git commit -m "fix: correct changelog format"
git push origin main
git tag vX.Y.Z
git push origin vX.Y.Z
```

#### prepare-next-release.ymlの失敗

**エラー**: `pull request create failed: GraphQL: GitHub Actions is not permitted to create or approve pull requests`

**原因**: 組織の設定でGitHub ActionsのPR作成が許可されていない

**対処法**:
1. 組織の設定ページにアクセス:
   https://github.com/organizations/no-problem-dev/settings/actions

2. 「Workflow permissions」セクションで「Allow GitHub Actions to create and approve pull requests」を有効化

3. 設定保存後、ワークフローを手動実行:
```bash
gh workflow run prepare-next-release.yml
```

**エラー**: ワークフローが成功したがPRが作成されていない

**原因**: 「未リリース」セクションが既に存在する（正常動作）

**確認方法**:
```bash
# CHANGELOG.mdを確認
head -20 CHANGELOG.md | grep "未リリース"
```

### バージョン番号を間違えた場合

**タグプッシュ前の場合:**
```bash
# ローカルのタグを削除
git tag -d vX.Y.Z

# 正しいバージョンで再作成
git tag vX.Y.Z
git push origin vX.Y.Z
```

**タグプッシュ後の場合:**
```bash
# リモートのタグを削除
git push origin :refs/tags/vX.Y.Z

# GitHubのReleaseを手動で削除（Webページから）
# https://github.com/no-problem-dev/swift-design-system/releases

# CHANGELOG.mdを修正
# 正しいバージョン番号に変更

git add CHANGELOG.md
git commit -m "fix: correct version number"
git push origin main

# 正しいバージョンで再実行
git tag vX.Y.Z
git push origin vX.Y.Z
```

### リリースが自動作成されない

**確認手順:**

1. **GitHub Actionsの実行を確認**
   ```bash
   gh run list --workflow=release.yml --limit 3
   ```

2. **ワークフローのログを確認**
   ```bash
   gh run view <run-id> --log
   ```

3. **権限の確認**
   - リポジトリ設定 > Actions > General
   - "Workflow permissions" が "Read and write permissions" になっているか確認

4. **CHANGELOG.mdの形式確認**
   ```markdown
   ## [1.0.10] - 2025-11-08

   ### 追加
   ...

   ## [1.0.9] - 2025-11-08
   ```
   - バージョン番号が `## [X.Y.Z]` の形式か
   - 各バージョンの間に空行があるか

## ベストプラクティス

### 1. 小さく頻繁にリリース

**推奨:**
- 1-2週間に1回のリリース
- 5-10個の変更をまとめてリリース

**メリット:**
- ユーザーは小さな変更の方が受け入れやすい
- 問題が発生した場合の原因特定が容易
- リリース作業がルーティン化される

### 2. CHANGELOGは開発と同時に更新

**悪い習慣:**
```bash
# 複数のPRをマージ
git merge feature/a
git merge feature/b
git merge feature/c

# リリース時にまとめてCHANGELOG更新
# → 何を変更したか思い出せない
```

**良い習慣:**
```bash
# PRごとにCHANGELOGを更新
# feature/a ブランチで
# - コード変更
# - CHANGELOG.md更新
# → PR作成

# 常に最新のCHANGELOGが維持される
```

### 3. ユーザー視点で書く

**技術者視点（悪い例）:**
```markdown
### 変更
- ColorPaletteProtocolのリファクタリング
- ThemeProviderの依存性注入パターン実装
```

**ユーザー視点（良い例）:**
```markdown
### 追加
- カスタムカラーパレットを簡単に作成できるようになりました
- テーマの切り替えがよりスムーズになりました
```

### 4. リンクを活用

```markdown
### 追加
- 新しいOceanテーマを追加 (#45)

### 修正
- ダークモードでのカード表示問題を修正 (#67)

詳細は [ドキュメント](https://example.com/docs) を参照してください。
```

**メリット:**
- ユーザーが詳細を確認しやすい
- PRとの関連性が明確
- 議論の経緯を追跡できる

### 5. セマンティックバージョニングを厳守

**重要な原則:**
- 破壊的変更 = 必ずMAJORバージョンを上げる
- 機能追加 = MINORバージョンを上げる
- バグ修正 = PATCHバージョンを上げる

**ユーザーへの影響:**
```swift
// ユーザーのPackage.swift
dependencies: [
    .package(url: "...", .upToNextMajor(from: "1.0.0"))
]

// 1.0.0 → 1.9.9 は自動更新される（安全）
// 1.9.9 → 2.0.0 は自動更新されない（破壊的変更の可能性）
```

### 6. リリース前の最終確認

**チェックリスト:**
- [ ] CHANGELOG.mdのバージョン番号は正しいか
- [ ] 日付は正しいか
- [ ] すべての変更が記載されているか
- [ ] 比較リンクは更新されているか
- [ ] mainブランチは最新か
- [ ] CIは通っているか

## 参考資料

- [セマンティックバージョニング](https://semver.org/lang/ja/) - バージョン番号の付け方
- [Keep a Changelog](https://keepachangelog.com/ja/1.0.0/) - CHANGELOGのベストプラクティス
- [Conventional Commits](https://www.conventionalcommits.org/ja/v1.0.0/) - コミットメッセージ規約
- [GitHub Releases](https://docs.github.com/ja/repositories/releasing-projects-on-github/about-releases) - GitHubのリリース機能
- [GitHub Actions - Events](https://docs.github.com/en/actions/using-workflows/events-that-trigger-workflows#push) - ワークフロートリガー

## ワークフローファイル

自動化の詳細は以下のファイルを参照してください：
- [.github/workflows/release.yml](.github/workflows/release.yml) - GitHub Release作成
- [.github/workflows/prepare-next-release.yml](.github/workflows/prepare-next-release.yml) - 次回リリース準備
