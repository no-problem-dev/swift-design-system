# 変更履歴

このプロジェクトの全ての重要な変更はこのファイルに記録されます。

フォーマットは [Keep a Changelog](https://keepachangelog.com/ja/1.0.0/) に基づいており、
このプロジェクトは [セマンティックバージョニング](https://semver.org/lang/ja/spec/v2.0.0.html) に準拠しています。

## [未リリース]

なし

## [1.0.9] - 2025-11-08

### 追加
- **比較リンク自動更新** - prepare-next-releaseワークフローの改善
  - タグからバージョンを自動抽出
  - [未リリース]の比較リンクを最新バージョンに自動更新
  - リリース後の手動リンク更新作業が不要に

## [1.0.8] - 2025-11-08

### 修正
- **prepare-next-releaseワークフロー検証** - ドラフトPR自動作成の動作確認
  - 「未リリース」セクションが存在しない場合のPR作成フローを検証

## [1.0.7] - 2025-11-08

### 変更
- **リリースワークフローの改善** - GitHub Releaseに定型文とメタ情報を追加
  - リリースタイトル、インストール方法、リンクを自動生成
  - より分かりやすいリリースノート形式に変更

### 修正
- **prepare-next-releaseワークフロー** - ドラフトPR自動作成を実装
  - タグプッシュトリガーに変更（release:publishedイベントは動作しないため）
  - ドラフトPRの自動作成まで完全自動化

## [1.0.6] - 2025-11-08

### 追加
- ドキュメントの改善とリリースフロー検証

## [1.0.5] - 2025-11-08

### 追加
- **自動化ワークフロー** - リリース後の準備を自動化
  - `.github/workflows/prepare-next-release.yml` を追加
  - GitHub Release公開後に自動的に次のリリース準備PRをドラフト作成
  - CHANGELOG.mdの「未リリース」セクションを自動挿入
  - Keep a Changelogのベストプラクティスに基づく実装

## [1.0.4] - 2025-11-08

### 変更
- **リリースプロセスの改善** - ハイブリッドアプローチを採用
  - CHANGELOG.mdは人間が手動で管理（Keep a Changelog形式を維持）
  - GitHub Releasesはタグから自動生成
  - ベストプラクティスに基づく正しい設計に変更

### 削除
- 誤った自動化ワークフロー `prepare-next-version.yml` を削除
- 不要なスクリプト `prepare_next_version.sh` を削除
- 古いドキュメント `RELEASE_AUTOMATION.md` を削除

### 追加
- 新しいリリースワークフロー `.github/workflows/release.yml`
  - タグプッシュ時にCHANGELOG.mdから該当バージョンを抽出
  - GitHub Releaseを自動作成
- 包括的なリリースプロセスガイド `docs/RELEASE_PROCESS.md`

## [1.0.3] - 2025-11-08

### ドキュメント
- README.md のインストール方法を `upToNextMajor` に変更し、セマンティックバージョニングのベストプラクティスに準拠

## [1.0.2] - 2025-11-08

### 追加
- **マルチテーマシステム** - 7種類のビルトインテーマを追加
  - Default - Material Design 3準拠のデフォルトテーマ
  - Ocean - 海の青をベースとした落ち着いたテーマ
  - Forest - 森の緑をベースとした自然なテーマ
  - Sunset - 夕焼けのオレンジをベースとした温かいテーマ
  - Purple Haze - 鮮やかな紫をベースとしたクリエイティブなテーマ
  - Monochrome - グレースケールのミニマルなテーマ
  - High Contrast - WCAG AAA準拠の高コントラストテーマ
- **テーマアーキテクチャ**
  - `Theme` protocol - Protocol指向設計による拡張性の高いテーマシステム
  - `ThemeMode` - システム追従/ライト固定/ダーク固定の3モード対応
  - `ThemeCategory` - テーマの論理的分類（Standard, Brand Personality, Accessibility）
  - `ThemeRegistry` - 全テーマの一元管理
  - 各テーマにLight/Darkパレット実装（計14パレット）
- **カタログアプリUI**
  - `ThemeGalleryView` - カテゴリ別テーマ一覧表示
  - `ThemeDetailView` - テーマ詳細とインタラクティブプレビュー
  - `ThemeCardView` - テーマ選択カード
  - `ThemeColorPreview` - 全27色のカラーパレット表示
  - `AppearanceModeSection` - 外観モード切り替えUI
- **DesignSystemCatalogApp** - Xcodeプロジェクトとしてのカタログアプリケーション

### 変更
- **ThemeProvider の完全リライト**（破壊的変更）
  - `@Observable` マクロに移行
  - 初期化パラメータの変更:
    - 旧: `ThemeProvider(colorScheme:lightPalette:darkPalette:)`
    - 新: `ThemeProvider(initialTheme:initialMode:additionalThemes:)`
  - Environment注入方法の変更:
    - 旧: `.environment(\.themeProvider, provider)`
    - 新: `.environment(provider)`
  - デフォルトモードを `.system` に変更（システム設定に追従）
- **ThemeModifier の改善**
  - `ThemeMode.system` のColorScheme解決ロジック実装
  - `@Environment(\.colorScheme)` と連携して適切なパレットを選択
- **DesignSystemCatalogView の改善**
  - 冗長なヘッダーセクションを削除
  - ナビゲーションタイトルを「デザインシステムカタログ」に変更
  - 情報セクションにリポジトリとドキュメントへのリンク追加
  - バージョン・デザインシステム説明を削除（メンテナンス負荷軽減）

### 修正
- **カタログビューのハードコード色をテーマシステムに統一**
  - PatternsCatalogView/ComponentsCatalogView のヘッダーアイコン色を `colorPalette.primary` に統一
  - FeatureRow コンポーネントをテーマ対応（`color` パラメータを削除）
  - RadiusDemoView/SpacingDemoView の視覚デモをテーマカラーに対応
  - ButtonCatalogView の説明文と背景色をColorPaletteトークンに統一
  - ColorSwatchView の `.primary`/`.secondary`/`.tertiary` を `colorPalette` トークンに統一
  - すべてのカタログビューでSwiftUIネイティブセマンティックカラーを排除し、Material Design 3準拠に統一

### 削除
- `ThemeProviderKey` - @Observableに移行したため不要
- カスタムEnvironmentKeyによるThemeProvider注入パターン

### ドキュメント
- README.md にマルチテーマシステムの包括的なドキュメント追加
  - 7テーマの特徴と用途を説明する表
  - テーマ切り替えとモード選択の使用例
  - カスタムテーマ作成ガイド
- 全テーマファイルに詳細なドキュメントコメント追加
- ThemeProtocol/ThemeRegistry/ThemeMode/ThemeCategory に実践的なコード例追加

## [1.0.1] - 2025-01-08

### 修正
- Swift 6のStrictConcurrency機能がデフォルトで有効になっているため、明示的な設定を削除
- Package.swiftの不要なswiftSettings設定を削除してビルドエラーを解消

## [1.0.0] - 2025-01-08

### 追加
- 3層デザイントークンシステム（Primitive, Semantic, Component）
- プロトコルベースのカラーパレット（`ColorPalette`）
  - Light/Darkテーマのデフォルト実装
  - Primary, Secondary, Tertiary カラースキーム
  - Semantic state colors（Error, Warning, Success, Info）
- スペーシングスケール（`SpacingScale`）
  - Tシャツサイズ命名規則（xs, sm, md, lg, xl, etc.）
  - none (0pt) から xxxxl (96pt) までの11段階
- 角丸スケール（`RadiusScale`）
  - xs (2pt) から xxl (24pt) までの7段階
  - full（完全な円形）サポート
- タイポグラフィシステム（`Typography`）
  - Display, Headline, Title, Body, Label の5カテゴリ
  - 14種類の定義済みテキストスタイル
  - `.typography()` モディファイアによる簡単適用
- ThemeProvider による動的テーマ切り替え
  - Light/Dark/カスタムテーマ対応
  - `@Observable` によるリアクティブな更新
  - システムテーマ追従機能
- ボタンコンポーネント
  - PrimaryButtonStyle - 主要アクション用
  - SecondaryButtonStyle - 補助アクション用
  - TertiaryButtonStyle - 控えめなアクション用
  - TextButtonStyle - テキストのみのボタン
  - ButtonSize（Large, Medium, Small）によるサイズ統一
- カードコンポーネント
  - Card - 汎用カードコンテナ
  - Elevation レベル（Level0-3）による影の管理
- IconButton - アイコンベースのボタン
- FloatingActionButton (FAB) - 主要アクションボタン
- DSTextField - デザインシステム統合テキストフィールド
  - エラー状態、フォーカス状態対応
  - プレースホルダー、キーボードタイプ設定
  - セキュアテキスト入力サポート
- レイアウトパターン
  - SectionCard - タイトル付きカードセクション
- View Modifiers
  - `.theme(_:)` - ThemeProvider 適用
  - `.buttonSize(_:)` - ボタンサイズ指定
  - `.typography(_:)` - タイポグラフィ適用
- カスタムテーマ作成サポート
  - 独自のカラーパレット実装
  - カスタムスペーシング・角丸スケール
- HEX文字列からの Color 初期化（`Color(hex:)`）
  - 3桁、6桁、8桁（アルファ付き）対応
- 完全なドキュメントコメント
  - 全パブリックAPIに実践的なコード例
  - ユーザー視点の使用ガイド

### ドキュメント
- 包括的な README.md
  - クイックスタートガイド
  - デザイントークンの使用例
  - カスタムテーマ作成例
  - ログイン画面・設定画面の実装例
- API リファレンス
- アーキテクチャガイド（3層トークンシステム）
- DocC 対応
  - GitHub Pages での自動ドキュメント公開

[未リリース]: https://github.com/no-problem-dev/swift-design-system/compare/v1.0.9...HEAD
[1.0.9]: https://github.com/no-problem-dev/swift-design-system/compare/v1.0.8...v1.0.9
[1.0.8]: https://github.com/no-problem-dev/swift-design-system/compare/v1.0.7...v1.0.8
[1.0.7]: https://github.com/no-problem-dev/swift-design-system/compare/v1.0.6...v1.0.7
[1.0.6]: https://github.com/no-problem-dev/swift-design-system/compare/v1.0.5...v1.0.6
[1.0.5]: https://github.com/no-problem-dev/swift-design-system/compare/v1.0.4...v1.0.5
[1.0.4]: https://github.com/no-problem-dev/swift-design-system/compare/v1.0.3...v1.0.4
[1.0.3]: https://github.com/no-problem-dev/swift-design-system/compare/v1.0.2...v1.0.3
[1.0.2]: https://github.com/no-problem-dev/swift-design-system/compare/v1.0.1...v1.0.2
[1.0.1]: https://github.com/no-problem-dev/swift-design-system/compare/v1.0.0...v1.0.1
[1.0.0]: https://github.com/no-problem-dev/swift-design-system/releases/tag/v1.0.0
