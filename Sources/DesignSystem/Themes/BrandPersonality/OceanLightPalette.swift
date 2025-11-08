import SwiftUI

/// Oceanテーマ - ライトモードパレット
struct OceanLightPalette: ColorPalette {
    // MARK: - Primary
    var primary: Color { Color(hex: "#0077BE") } // Deep Ocean Blue
    var onPrimary: Color { .white }
    var primaryContainer: Color { Color(hex: "#E6F4FB") }
    var onPrimaryContainer: Color { Color(hex: "#0077BE") }

    // MARK: - Secondary
    var secondary: Color { Color(hex: "#00A8CC") } // Cyan Blue
    var onSecondary: Color { .white }
    var secondaryContainer: Color { Color(hex: "#E6F7FA") }
    var onSecondaryContainer: Color { Color(hex: "#00A8CC") }

    // MARK: - Tertiary
    var tertiary: Color { Color(hex: "#4ECDC4") } // Turquoise
    var onTertiary: Color { .white }

    // MARK: - Background & Surface
    var background: Color { .white }
    var onBackground: Color { Color(hex: "#0F1419") }
    var surface: Color { Color(hex: "#F7FAFC") } // Slight blue tint
    var onSurface: Color { Color(hex: "#1A202C") }
    var surfaceVariant: Color { Color(hex: "#EDF2F7") } // Light gray-blue
    var onSurfaceVariant: Color { Color(hex: "#4A5568") }

    // MARK: - Semantic State
    var error: Color { Color(hex: "#DC2626") }
    var warning: Color { Color(hex: "#F59E0B") }
    var success: Color { Color(hex: "#10B981") }
    var info: Color { Color(hex: "#0077BE") } // Matches primary

    // MARK: - Outline
    var outline: Color { Color(hex: "#CBD5E0") }
    var outlineVariant: Color { Color(hex: "#E2E8F0") }
}
