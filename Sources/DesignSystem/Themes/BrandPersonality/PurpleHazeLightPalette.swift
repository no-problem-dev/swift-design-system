import SwiftUI

/// PurpleHazeテーマ - ライトモードパレット
struct PurpleHazeLightPalette: ColorPalette {
    // MARK: - Primary
    var primary: Color { Color(hex: "#7209B7") } // Royal Purple
    var onPrimary: Color { .white }
    var primaryContainer: Color { Color(hex: "#F3E5F7") }
    var onPrimaryContainer: Color { Color(hex: "#40005D") }

    // MARK: - Secondary
    var secondary: Color { Color(hex: "#B5179E") } // Magenta
    var onSecondary: Color { .white }
    var secondaryContainer: Color { Color(hex: "#FCE4F5") }
    var onSecondaryContainer: Color { Color(hex: "#5A0048") }

    // MARK: - Tertiary
    var tertiary: Color { Color(hex: "#F72585") } // Hot Pink
    var onTertiary: Color { .white }

    // MARK: - Background & Surface
    var background: Color { .white }
    var onBackground: Color { Color(hex: "#1C111E") }
    var surface: Color { Color(hex: "#FBF7FC") } // Slight purple tint
    var onSurface: Color { Color(hex: "#1C111E") }
    var surfaceVariant: Color { Color(hex: "#F7F1F9") }
    var onSurfaceVariant: Color { Color(hex: "#4A4050") }

    // MARK: - Semantic State
    var error: Color { Color(hex: "#DC2626") }
    var warning: Color { Color(hex: "#F59E0B") }
    var success: Color { Color(hex: "#10B981") }
    var info: Color { Color(hex: "#7209B7") } // Matches primary

    // MARK: - Outline
    var outline: Color { Color(hex: "#E6D6EB") }
    var outlineVariant: Color { Color(hex: "#F2E8F5") }
}
