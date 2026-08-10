import Foundation

/// Which of a theme's color palettes is in use.
///
/// ## Modes
/// - **system**: Follows the system appearance. This is the default.
/// - **light**: Always light.
/// - **dark**: Always dark.
///
/// ## Example
/// ```swift
/// // Follow the system appearance (the default)
/// themeProvider.themeMode = .system
///
/// // Stay light
/// themeProvider.themeMode = .light
///
/// // Stay dark
/// themeProvider.themeMode = .dark
/// ```
public enum ThemeMode: String, Sendable, CaseIterable {
    /// Follows the system appearance.
    case system = "System"

    /// Stays light whatever the system appearance is.
    case light = "Light"

    /// Stays dark whatever the system appearance is.
    case dark = "Dark"
}
