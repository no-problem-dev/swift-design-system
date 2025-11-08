import Foundation

/// ビルトインテーマのレジストリ
///
/// システムに組み込まれている全てのテーマを管理します。
///
/// ## 利用可能なテーマ
/// - **Standard**: デフォルトテーマ
/// - **Brand Personality**: Ocean, Forest, Sunset, PurpleHaze, Monochrome
/// - **Accessibility**: HighContrast (WCAG AAA準拠)
///
/// ## 使用例
/// ```swift
/// // 全テーマを取得
/// let themes = ThemeRegistry.builtInThemes
///
/// // カテゴリ別に取得
/// let brandThemes = ThemeRegistry.themesByCategory[.brandPersonality]
///
/// // IDで検索
/// if let ocean = ThemeRegistry.theme(withID: "ocean") {
///     themeProvider.applyTheme(ocean)
/// }
/// ```
public enum ThemeRegistry {
    /// 全てのビルトインテーマ（7種類）
    public static let builtInThemes: [any Theme] = [
        // Standard
        DefaultTheme(),

        // Brand Personality
        OceanTheme(),
        ForestTheme(),
        SunsetTheme(),
        PurpleHazeTheme(),
        MonochromeTheme(),

        // Accessibility
        HighContrastTheme(),
    ]

    /// カテゴリ別にグループ化されたテーマ
    public static var themesByCategory: [ThemeCategory: [any Theme]] {
        Dictionary(grouping: builtInThemes) { $0.category }
    }

    /// IDでテーマを検索
    /// - Parameter id: テーマID
    /// - Returns: 見つかったテーマ、またはnil
    public static func theme(withID id: String) -> (any Theme)? {
        builtInThemes.first { $0.id == id }
    }
}
