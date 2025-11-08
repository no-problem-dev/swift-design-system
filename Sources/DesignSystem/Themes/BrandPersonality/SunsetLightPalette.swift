import SwiftUI

/// Sunsetテーマ - ライトモードパレット
struct SunsetLightPalette: ColorPalette {
    // MARK: - Primary
    var primary: Color { Color(hex: "#FF6B35") } // Coral Orange
    var onPrimary: Color { .white }
    var primaryContainer: Color { Color(hex: "#FFE5DC") }
    var onPrimaryContainer: Color { Color(hex: "#A02F00") }

    // MARK: - Secondary
    var secondary: Color { Color(hex: "#F77F00") } // Pumpkin
    var onSecondary: Color { .white }
    var secondaryContainer: Color { Color(hex: "#FFEACC") }
    var onSecondaryContainer: Color { Color(hex: "#7A3800") }

    // MARK: - Tertiary
    var tertiary: Color { Color(hex: "#FCBF49") } // Golden Yellow
    var onTertiary: Color { Color(hex: "#3D2600") }

    // MARK: - Background & Surface
    var background: Color { .white }
    var onBackground: Color { Color(hex: "#1F1412") }
    var surface: Color { Color(hex: "#FFF9F5") } // Warm tint
    var onSurface: Color { Color(hex: "#1F1412") }
    var surfaceVariant: Color { Color(hex: "#FFF4ED") }
    var onSurfaceVariant: Color { Color(hex: "#52443C") }

    // MARK: - Semantic State
    var error: Color { Color(hex: "#DC2626") }
    var warning: Color { Color(hex: "#F77F00") } // Matches secondary
    var success: Color { Color(hex: "#10B981") }
    var info: Color { Color(hex: "#0284C7") }

    // MARK: - Outline
    var outline: Color { Color(hex: "#F0D4C1") }
    var outlineVariant: Color { Color(hex: "#F7E7D9") }
}
