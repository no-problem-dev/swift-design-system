import SwiftUI

/// A high contrast theme whose color pairs meet WCAG AAA.
///
/// Suited to apps used by people with low vision, and to any app that puts legibility first.
public struct HighContrastTheme: Theme {
    public init() {}

    public var id: String { "high-contrast" }

    public var name: String { "High Contrast" }

    public var description: String { "WCAG AAA compliant. Maximum legibility and accessibility" }

    public var category: ThemeCategory { .accessibility }

    public var previewColors: [Color] {
        [
            Color(hex: "#0050B3"), // Primary (Light mode)
            Color(hex: "#6B0080"), // Secondary (Light mode)
            Color(hex: "#006B56"), // Tertiary (Light mode)
        ]
    }

    public func colorPalette(for mode: ThemeMode) -> any ColorPalette {
        switch mode {
        case .system, .light:
            return HighContrastLightPalette()
        case .dark:
            return HighContrastDarkPalette()
        }
    }
}
