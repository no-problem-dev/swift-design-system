import SwiftUI

/// Sunsetテーマ - ダークモードパレット
struct SunsetDarkPalette: ColorPalette {
    // MARK: - Primary
    var primary: Color { Color(hex: "#FFB699") } // Lighter coral for dark mode
    var onPrimary: Color { Color(hex: "#5F1900") }
    var primaryContainer: Color { Color(hex: "#8B2500") }
    var onPrimaryContainer: Color { Color(hex: "#FFD4C1") }

    // MARK: - Secondary
    var secondary: Color { Color(hex: "#FFB870") } // Lighter pumpkin for dark mode
    var onSecondary: Color { Color(hex: "#4A2800") }
    var secondaryContainer: Color { Color(hex: "#6B3C00") }
    var onSecondaryContainer: Color { Color(hex: "#FFDDB3") }

    // MARK: - Tertiary
    var tertiary: Color { Color(hex: "#FFD88A") } // Lighter golden for dark mode
    var onTertiary: Color { Color(hex: "#3D2600") }

    // MARK: - Background & Surface
    var background: Color { Color(hex: "#1A1210") } // Warm dark
    var onBackground: Color { Color(hex: "#ECE0DA") }
    var surface: Color { Color(hex: "#241D19") } // Elevated warm surface
    var onSurface: Color { Color(hex: "#ECE0DA") }
    var surfaceVariant: Color { Color(hex: "#2E2621") }
    var onSurfaceVariant: Color { Color(hex: "#D0C4BC") }

    // MARK: - Semantic State
    var error: Color { Color(hex: "#EF4444") }
    var warning: Color { Color(hex: "#FFB870") } // Matches secondary
    var success: Color { Color(hex: "#34D399") }
    var info: Color { Color(hex: "#38BDF8") }

    // MARK: - Outline
    var outline: Color { Color(hex: "#49403A") }
    var outlineVariant: Color { Color(hex: "#38302B") }
}
