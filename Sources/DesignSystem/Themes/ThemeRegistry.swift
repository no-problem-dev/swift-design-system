import Foundation

/// The themes that ship with the design system.
///
/// The set is fixed and every app starts from it. To offer a theme of your own, pass it to
/// a theme provider as an additional theme; the provider appends it to this list and ignores
/// it if its identifier is already taken.
///
/// ## Themes
/// - **Standard**: Default
/// - **Brand Personality**: Ocean, Forest, Sunset, PurpleHaze, Monochrome
/// - **Accessibility**: HighContrast, whose color pairs meet WCAG AAA
///
/// ## Example
/// ```swift
/// // Every built-in theme
/// let themes = ThemeRegistry.builtInThemes
///
/// // Grouped by category
/// let brandThemes = ThemeRegistry.themesByCategory[.brandPersonality]
///
/// // Looked up by identifier
/// if let ocean = ThemeRegistry.theme(withID: "ocean") {
///     themeProvider.applyTheme(ocean)
/// }
/// ```
public enum ThemeRegistry {
    /// The built-in themes, in the order an app should offer them.
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

    /// The built-in themes grouped by category.
    ///
    /// A category that no built-in theme belongs to is absent from the dictionary rather
    /// than mapped to an empty array.
    public static var themesByCategory: [ThemeCategory: [any Theme]] {
        Dictionary(grouping: builtInThemes) { $0.category }
    }

    /// Returns the built-in theme with the given identifier, or `nil` if there is none.
    ///
    /// The comparison is exact, so identifiers that differ in case do not match.
    /// - Parameter id: The identifier to look for.
    public static func theme(withID id: String) -> (any Theme)? {
        builtInThemes.first { $0.id == id }
    }
}
