import SwiftUI

/// Oceanテーマ - ダークモードパレット
struct OceanDarkPalette: ColorPalette {
    // MARK: - Primary
    var primary: Color { Color(hex: "#3BA4DB") } // Lighter ocean blue for dark mode
    var onPrimary: Color { Color(hex: "#003A5D") }
    var primaryContainer: Color { Color(hex: "#00557A") }
    var onPrimaryContainer: Color { Color(hex: "#B3E0F7") }

    // MARK: - Secondary
    var secondary: Color { Color(hex: "#52C9E5") } // Lighter cyan for dark mode
    var onSecondary: Color { Color(hex: "#00495A") }
    var secondaryContainer: Color { Color(hex: "#006B7E") }
    var onSecondaryContainer: Color { Color(hex: "#C2E9F4") }

    // MARK: - Tertiary
    var tertiary: Color { Color(hex: "#6DE3DC") } // Brighter turquoise for dark mode
    var onTertiary: Color { Color(hex: "#00534E") }

    // MARK: - Background & Surface
    var background: Color { Color(hex: "#0B1621") } // Deep ocean dark
    var onBackground: Color { Color(hex: "#E1E7ED") }
    var surface: Color { Color(hex: "#162231") } // Elevated surface
    var onSurface: Color { Color(hex: "#E1E7ED") }
    var surfaceVariant: Color { Color(hex: "#1F2D3D") }
    var onSurfaceVariant: Color { Color(hex: "#C1CBD6") }

    // MARK: - Semantic State
    var error: Color { Color(hex: "#EF4444") }
    var warning: Color { Color(hex: "#FBBF24") }
    var success: Color { Color(hex: "#34D399") }
    var info: Color { Color(hex: "#3BA4DB") } // Matches primary

    // MARK: - Outline
    var outline: Color { Color(hex: "#3D4B5C") }
    var outlineVariant: Color { Color(hex: "#2A3644") }
}
