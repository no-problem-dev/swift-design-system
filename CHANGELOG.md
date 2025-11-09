# 変更履歴

このプロジェクトの全ての重要な変更はこのファイルに記録されます。

フォーマットは [Keep a Changelog](https://keepachangelog.com/ja/1.0.0/) に基づいており、
このプロジェクトは [セマンティックバージョニング](https://semver.org/lang/ja/spec/v2.0.0.html) に準拠しています。

## [未リリース]

なし

## [1.0.16] - 2025-11-09

### 追加
- **Motionシステム** - 統一されたアニメーションタイミングシステム (#20)
  - 10種類の最適化されたアニメーションタイミング
  - マイクロインタラクション: `quick` (70ms), `tap` (110ms)
  - 状態変化: `toggle`, `fadeIn`, `fadeOut` (150ms)
  - トランジション: `slide` (240ms), `slow` (300ms), `slower` (375ms)
  - スプリング: `spring`, `bounce`
  - Material Design 3、IBM Carbon、Apple HIGの業界標準に準拠
  - `.animate()` modifierによる簡単適用
  - 自動Reduce Motion対応（WCAG 2.1 SC 2.3.3準拠）
  - Sendable準拠で並行処理安全

- **Motionカタログビュー** - 包括的なアニメーションカタログ (#20)
  - 概要セクション: システム説明と主な機能
  - インタラクティブデモ: 4カテゴリ別の体験可能なアニメーション
  - 仕様表: 全10モーションの詳細スペック
  - 使用例: 3パターンのコード例
  - アクセシビリティ説明: Reduce Motion自動対応
  - ベストプラクティス: 推奨パターンとアンチパターン
  - MotionDemoCard: AspectGridパターンでレスポンシブデザイン

### 変更
- **カタログUIの改善** (#21)
  - セクション間スペーシングを24pt → 32ptに増加（2025年デザインシステムベストプラクティス準拠）
  - カード風セクションデザインの導入（微妙なエレベーション効果）
  - フルブリードセクション（画面端まで）には角丸なし（iOS標準パターン）
  - 情報セクションには角丸あり（浮いているカード風）
  - Material Design 3、Fluent 2、Carbon Design Systemの2025年ベストプラクティスを調査・適用

- **既存コンポーネントのMotionシステム移行** (#20)
  - Button styles (Primary, Secondary, Tertiary) → Motionトークン使用
  - Chip styles (Filled, Outlined, LiquidGlass) → Motionトークン使用
  - ThemeGalleryView → Motionトークン使用

- **カスタムテーマのダークモード対応** (#21)
  - `SimpleBlueTheme`と`SimpleRedTheme`に完全なダークモード対応を追加
  - `ThemeMode`の全ケース（`.system`, `.light`, `.dark`）を適切に処理
  - ダークモードでは明るい色調に調整してコントラストを確保

### 修正
- **GitHub ActionsのXcode環境更新** (#19)
  - macOS 15 → macOS 26 (arm64)
  - Xcode 16.1 → Xcode 26.0.1
  - iOS 26 SDKサポート（`.glassEffect()` API使用のため）
  - DocCデプロイメントのコンパイルエラーを解消

### ドキュメント
- **カスタムテーマドキュメントの大幅改善** (#21)
  - `SimpleBlueTheme`と`SimpleRedTheme`に詳細なDocCコメント追加
  - README.mdの「カスタムテーマの作成」セクション刷新
    - ステップ1: ColorPaletteの実装（全27色の完全な例）
    - ステップ2: Themeプロトコルの実装
    - ステップ3: ThemeProviderへの登録（3パターン）
    - ステップ4: テーマの切り替え実装例
  - エントリーポイントへのドキュメント追加

## [1.0.15] - 2025-11-09

### 追加
- **Chipコンポーネント** - Material Design 3とLiquid Glassデザイン言語に準拠 (#15)
  - プロトコルベースのChipStyleシステム (ButtonStyleと同様)
  - サイズバリアント: Small (24pt), Medium (32pt)
  - 4つの初期化パターン: 静的、アイコン付き、削除可能、選択可能
  - インタラクティブ状態: pressed, selected
  - 完全なアクセシビリティサポート
  - 3つのスタイルバリアント:
    - **Filled**: 10-20%不透明度背景（ステータス/カテゴリラベル用）
    - **Outlined**: 1.5ptボーダー（フィルターとセカンダリカテゴリ用）
    - **Liquid Glass**: iOS 26+ネイティブ `.glassEffect()` API（インタラクティブサポート付き）
  - Swift 6並行性対応（全スタイルが`Sendable`に準拠、`@MainActor`メソッド）
  - トークンシステムとの統合（3層トークンアーキテクチャを活用）

- **AspectGridレイアウトパターン** - アスペクト比固定グリッドレイアウト (#16)
  - **GridSpacingトークン**: xs, sm, md, lg, xlの5段階の間隔設定
  - **適応サイジング**: 画面サイズに応じた自動調整 (minItemWidth, maxItemWidth)
  - **一般的なユースケース対応**: 商品一覧、写真ギャラリー、動画サムネイル
  - **サポートされるアスペクト比**:
    - 1:1 - 商品サムネイル、プロフィール画像、アイコン
    - 3:4 - 写真、ポートレート
    - 16:9 - 動画サムネイル、ワイドコンテンツ
  - LazyVGridベースの効率的なレンダリング
  - GridItem.adaptiveによる自動カラム調整
  - 完全なドキュメントコメントとコード例

- **カスタムテーマカテゴリ** - テーマ分類の拡張 (#17)
  - 新しい`.custom`カテゴリを追加
    - 名前: "カスタム"
    - 説明: "アプリ固有のカスタムテーマ"
    - アイコン: `wand.and.stars` ✨
  - テーマギャラリーでビルトインとカスタムを明確に区別
  - サンプルカスタムテーマの実装例（SimpleBlueTheme, SimpleRedTheme）

### 修正
- **テーマ動的切り替えの改善** (#17)
  - `ThemeEnvironmentView`のリアクティブ更新を修正
    - 問題: カラーパレットが静的に評価され、テーマ切り替え時に更新されなかった
    - 解決: `resolvedColorPalette`計算プロパティを追加し、`@Observable`の変更検知を活用
  - `ThemeGalleryView`の動的テーマ表示を改善
    - 問題: `ThemeRegistry.themesByCategory`（ビルトインのみ）を使用していた
    - 解決: `themeProvider.availableThemes`を使用してビルトイン + カスタムテーマを動的に表示
  - リアクティブシステム: `@Observable`と計算プロパティによる自動更新
  - 拡張性: カスタムテーマを簡単に追加できる設計
  - 初期テーマ指定: `initialTheme`パラメータで起動時のテーマを制御可能

## [1.0.14] - 2025-11-08

### 修正
- **PR自動作成の確実化（最終版）** - タイムスタンプコメント追加
  - CHANGELOG.mdの末尾に自動生成タイムスタンプコメントを追加
  - 比較リンクが既に正しい値でも必ず変更が発生
  - 確実にコミットが作成され、PR作成が成功する

## [1.0.13] - 2025-11-08

### 修正
- **リリースノート生成の改善** - インストール例のバージョンを動的に設定
  - ハードコードされた "1.0.0" を実際のリリースバージョンに変更
  - より正確で分かりやすいインストール手順を提供
- **PR自動作成の確実化** - CHANGELOG比較リンク更新ロジックを追加
  - リリース後に必ず比較リンクを最新バージョンに更新
  - 「未リリース」セクションが既に存在する場合でも確実にコミットが作成される
  - 次のリリース用ドラフトPRが確実に作成されるように改善

## [1.0.12] - 2025-11-08

### 修正
- **リリースワークフローの統合** - GitHub Release作成をauto-release-on-merge.ymlに統合
  - タグ作成と同時にGitHub Releaseが作成されるように改善
  - release.ymlワークフローを削除（機能を統合）
  - PAT（Personal Access Token）の設定が不要に
  - すべてがGITHUB_TOKENで完結する完全自動化を実現

### ドキュメント
- **RELEASE_PROCESS.mdを大幅に簡素化** - 本質的な情報のみに絞り込み
  - 冗長なセクションを削除
  - リリース手順を6ステップに簡素化
  - トラブルシューティングを必要最小限に整理

## [1.0.11] - 2025-11-08

### 変更
- **リリースワークフローの完全改訂** - よりシンプルで直感的なフローに変更
  - リリースブランチ（`release/vX.Y.Z`）からmainへのPRマージがリリースのトリガーに
  - タグは自動的に作成されるため、手動でのタグ作成が不要に
  - 次のリリースブランチとドラフトPRも自動作成
  - ワークフロー: `auto-release-on-merge.yml`を新規追加、`prepare-next-release.yml`を削除

### ドキュメント
- **RELEASE_PROCESS.mdを新しいワークフローに完全対応**
  - 新しい開発フローの全体像を追加
  - 詳細な手順を6ステップに整理
  - 自動化の仕組みセクションを刷新（`auto-release-on-merge.yml`の詳細な説明）
  - トラブルシューティングを新しいワークフローに対応

## [1.0.10] - 2025-11-08

### ドキュメント
- **リリースプロセスガイドの包括的な更新**
  - リリース思想とコンセプトを詳細に記載（ハイブリッドアプローチの理由、セマンティックバージョニング、Keep a Changelog）
  - 詳細な手順とワークフロー全体像を追加
  - CHANGELOG.mdの書き方のベストプラクティス（良い例/悪い例の比較）
  - 自動化の仕組みを技術的に解説（release.yml、prepare-next-release.yml）
  - トラブルシューティングガイドを充実
  - README.mdに開発者向け情報セクションを追加
  - 旧docsディレクトリを削除（内容は統合済み）

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

[未リリース]: https://github.com/no-problem-dev/swift-design-system/compare/v1.0.16...HEAD
[1.0.16]: https://github.com/no-problem-dev/swift-design-system/compare/v1.0.15...v1.0.16
[1.0.15]: https://github.com/no-problem-dev/swift-design-system/compare/v1.0.14...v1.0.15
[1.0.14]: https://github.com/no-problem-dev/swift-design-system/compare/v1.0.13...v1.0.14
[1.0.13]: https://github.com/no-problem-dev/swift-design-system/compare/v1.0.12...v1.0.13
[1.0.12]: https://github.com/no-problem-dev/swift-design-system/compare/v1.0.11...v1.0.12
[1.0.11]: https://github.com/no-problem-dev/swift-design-system/compare/v1.0.10...v1.0.11
[1.0.10]: https://github.com/no-problem-dev/swift-design-system/compare/v1.0.9...v1.0.10
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

<!-- Auto-generated on 2025-11-08T11:54:43Z by release workflow -->

<!-- Auto-generated on 2025-11-09T00:21:22Z by release workflow -->
