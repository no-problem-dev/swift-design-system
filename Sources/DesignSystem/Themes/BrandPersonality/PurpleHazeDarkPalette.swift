import SwiftUI

/// PurpleHazeテーマ - ダークモードパレット
struct PurpleHazeDarkPalette: ColorPalette {
    // MARK: - Primary
    var primary: Color { Color(hex: "#D896FF") } // Lighter purple for dark mode
    var onPrimary: Color { Color(hex: "#40005D") }
    var primaryContainer: Color { Color(hex: "#560080") }
    var onPrimaryContainer: Color { Color(hex: "#F0DBFF") }

    // MARK: - Secondary
    var secondary: Color { Color(hex: "#E896D8") } // Lighter magenta for dark mode
    var onSecondary: Color { Color(hex: "#5A0048") }
    var secondaryContainer: Color { Color(hex: "#7D0066") }
    var onSecondaryContainer: Color { Color(hex: "#FFD9F2") }

    // MARK: - Tertiary
    var tertiary: Color { Color(hex: "#FF80B3") } // Lighter hot pink for dark mode
    var onTertiary: Color { Color(hex: "#5E0039") }

    // MARK: - Background & Surface
    var background: Color { Color(hex: "#16101A") } // Deep purple dark
    var onBackground: Color { Color(hex: "#EAE0E9") }
    var surface: Color { Color(hex: "#211A24") } // Elevated surface
    var onSurface: Color { Color(hex: "#EAE0E9") }
    var surfaceVariant: Color { Color(hex: "#2B232F") }
    var onSurfaceVariant: Color { Color(hex: "#CDC0CE") }

    // MARK: - Semantic State
    var error: Color { Color(hex: "#EF4444") }
    var warning: Color { Color(hex: "#FBBF24") }
    var success: Color { Color(hex: "#34D399") }
    var info: Color { Color(hex: "#D896FF") } // Matches primary

    // MARK: - Outline
    var outline: Color { Color(hex: "#47394C") }
    var outlineVariant: Color { Color(hex: "#362A3A") }
}
