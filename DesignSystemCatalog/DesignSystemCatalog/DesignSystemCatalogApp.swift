import SwiftUI
import DesignSystem

// MARK: - アプリエントリーポイント

/// デザインシステムカタログアプリのエントリーポイント
///
/// ## ThemeProviderの初期化パターン
///
/// このアプリでは、カスタムテーマの使用例を示すために、
/// `ThemeProvider`をカスタムテーマ付きで初期化しています。
///
/// ### パターン1: カスタムテーマを初期テーマに設定（現在の実装）
/// ```swift
/// @State private var themeProvider = ThemeProvider(
///     initialTheme: SimpleRedTheme(),      // 赤テーマを初期テーマに
///     additionalThemes: [SimpleBlueTheme()] // 青テーマも選択可能
/// )
/// ```
///
/// ### パターン2: デフォルトテーマで開始、カスタムテーマを追加
/// ```swift
/// @State private var themeProvider = ThemeProvider(
///     additionalThemes: [SimpleBlueTheme(), SimpleRedTheme()]
/// )
/// // DefaultThemeが初期テーマ、カスタムテーマも選択可能
/// ```
///
/// ### パターン3: ビルトインテーマのみ使用（最もシンプル）
/// ```swift
/// @State private var themeProvider = ThemeProvider()
/// // DefaultThemeで開始、7つのビルトインテーマから選択可能
/// ```
///
/// ## テーマの適用
///
/// ThemeProviderをビュー階層に適用するには、`.theme()`モディファイアを使用：
/// ```swift
/// ContentView()
///     .theme(themeProvider)
/// ```
///
/// ## 参考
/// - カスタムテーマの実装例: `Themes/SimpleBlueTheme.swift`, `Themes/SimpleRedTheme.swift`
/// - README.md: カスタムテーマ作成の詳細ガイド
@main
struct DesignSystemCatalogApp: App {
    @State private var themeProvider = ThemeProvider(
        initialTheme: SimpleRedTheme(),
        additionalThemes: [
            SimpleBlueTheme()
        ]
    )

    var body: some Scene {
        WindowGroup {
            DesignSystemCatalogView()
                .theme(themeProvider)
        }
    }
}
