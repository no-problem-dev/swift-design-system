import SwiftUI

/// Forestテーマ - ライトモードパレット
struct ForestLightPalette: ColorPalette {
    // MARK: - Primary
    var primary: Color { Color(hex: "#2D5016") } // Deep Forest Green
    var onPrimary: Color { .white }
    var primaryContainer: Color { Color(hex: "#E8F5E1") }
    var onPrimaryContainer: Color { Color(hex: "#2D5016") }

    // MARK: - Secondary
    var secondary: Color { Color(hex: "#52B788") } // Emerald
    var onSecondary: Color { .white }
    var secondaryContainer: Color { Color(hex: "#E5F6EE") }
    var onSecondaryContainer: Color { Color(hex: "#1B5E37") }

    // MARK: - Tertiary
    var tertiary: Color { Color(hex: "#74C69D") } // Mint
    var onTertiary: Color { Color(hex: "#003822") }

    // MARK: - Background & Surface
    var background: Color { .white }
    var onBackground: Color { Color(hex: "#1A1C18") }
    var surface: Color { Color(hex: "#F7FAF5") } // Slight green tint
    var onSurface: Color { Color(hex: "#1A1C18") }
    var surfaceVariant: Color { Color(hex: "#F0F5EC") }
    var onSurfaceVariant: Color { Color(hex: "#44483D") }

    // MARK: - Semantic State
    var error: Color { Color(hex: "#DC2626") }
    var warning: Color { Color(hex: "#F59E0B") }
    var success: Color { Color(hex: "#52B788") } // Matches secondary
    var info: Color { Color(hex: "#0284C7") }

    // MARK: - Outline
    var outline: Color { Color(hex: "#D6E3CB") }
    var outlineVariant: Color { Color(hex: "#E8F1E1") }
}
