# 変更履歴

このプロジェクトの全ての重要な変更はこのファイルに記録されます。

フォーマットは [Keep a Changelog](https://keepachangelog.com/ja/1.0.0/) に基づいており、
このプロジェクトは [セマンティックバージョニング](https://semver.org/lang/ja/spec/v2.0.0.html) に準拠しています。

## [未リリース]

なし

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

[未リリース]: https://github.com/no-problem-dev/swift-design-system/compare/v1.0.1...HEAD
[1.0.1]: https://github.com/no-problem-dev/swift-design-system/compare/v1.0.0...v1.0.1
[1.0.0]: https://github.com/no-problem-dev/swift-design-system/releases/tag/v1.0.0
