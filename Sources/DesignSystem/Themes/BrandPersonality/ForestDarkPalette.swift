import SwiftUI

/// Forestテーマ - ダークモードパレット
struct ForestDarkPalette: ColorPalette {
    // MARK: - Primary
    var primary: Color { Color(hex: "#74C69D") } // Lighter mint for dark mode
    var onPrimary: Color { Color(hex: "#00391F") }
    var primaryContainer: Color { Color(hex: "#005233") }
    var onPrimaryContainer: Color { Color(hex: "#90F5B9") }

    // MARK: - Secondary
    var secondary: Color { Color(hex: "#95D5B2") } // Lighter emerald for dark mode
    var onSecondary: Color { Color(hex: "#003920") }
    var secondaryContainer: Color { Color(hex: "#1B5E37") }
    var onSecondaryContainer: Color { Color(hex: "#B1EDCE") }

    // MARK: - Tertiary
    var tertiary: Color { Color(hex: "#B7E4C7") } // Pale mint for dark mode
    var onTertiary: Color { Color(hex: "#003822") }

    // MARK: - Background & Surface
    var background: Color { Color(hex: "#121714") } // Deep forest dark
    var onBackground: Color { Color(hex: "#DEE5DD") }
    var surface: Color { Color(hex: "#1A2118") } // Elevated surface
    var onSurface: Color { Color(hex: "#DEE5DD") }
    var surfaceVariant: Color { Color(hex: "#232C25") }
    var onSurfaceVariant: Color { Color(hex: "#BFC8BC") }

    // MARK: - Semantic State
    var error: Color { Color(hex: "#EF4444") }
    var warning: Color { Color(hex: "#FBBF24") }
    var success: Color { Color(hex: "#95D5B2") } // Matches secondary
    var info: Color { Color(hex: "#38BDF8") }

    // MARK: - Outline
    var outline: Color { Color(hex: "#3A4A3B") }
    var outlineVariant: Color { Color(hex: "#2A372B") }
}
