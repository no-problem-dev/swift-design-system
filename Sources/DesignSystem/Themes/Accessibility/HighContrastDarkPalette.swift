import SwiftUI

/// HighContrastテーマ - ダークモードパレット（WCAG AAA準拠）
struct HighContrastDarkPalette: ColorPalette {
    // MARK: - Primary
    var primary: Color { Color(hex: "#82B1FF") } // Bright blue for dark mode high contrast
    var onPrimary: Color { Color(hex: "#00174A") }
    var primaryContainer: Color { Color(hex: "#003D99") }
    var onPrimaryContainer: Color { Color(hex: "#D4E5FF") }

    // MARK: - Secondary
    var secondary: Color { Color(hex: "#E891FF") } // Bright purple for dark mode high contrast
    var onSecondary: Color { Color(hex: "#3D004D") }
    var secondaryContainer: Color { Color(hex: "#6B0080") }
    var onSecondaryContainer: Color { Color(hex: "#F9D5FF") }

    // MARK: - Tertiary
    var tertiary: Color { Color(hex: "#4DFF9F") } // Bright teal for dark mode high contrast
    var onTertiary: Color { Color(hex: "#003828") }

    // MARK: - Background & Surface
    var background: Color { .black }
    var onBackground: Color { .white }
    var surface: Color { Color(hex: "#121212") } // Slightly elevated black
    var onSurface: Color { .white }
    var surfaceVariant: Color { Color(hex: "#1E1E1E") }
    var onSurfaceVariant: Color { Color(hex: "#E0E0E0") }

    // MARK: - Semantic State
    var error: Color { Color(hex: "#FF5252") } // Bright red for high contrast
    var warning: Color { Color(hex: "#FFD54F") } // Bright yellow for high contrast
    var success: Color { Color(hex: "#69F0AE") } // Bright green for high contrast
    var info: Color { Color(hex: "#82B1FF") } // Matches primary

    // MARK: - Outline
    var outline: Color { Color(hex: "#E0E0E0") } // High contrast outline for dark mode
    var outlineVariant: Color { Color(hex: "#BDBDBD") }
}
