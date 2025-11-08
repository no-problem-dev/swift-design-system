import SwiftUI

/// HighContrastテーマ - ライトモードパレット（WCAG AAA準拠）
struct HighContrastLightPalette: ColorPalette {
    // MARK: - Primary
    var primary: Color { Color(hex: "#0050B3") } // Deep blue for high contrast
    var onPrimary: Color { .white }
    var primaryContainer: Color { Color(hex: "#E0EDFF") }
    var onPrimaryContainer: Color { Color(hex: "#002952") }

    // MARK: - Secondary
    var secondary: Color { Color(hex: "#6B0080") } // Deep purple for high contrast
    var onSecondary: Color { .white }
    var secondaryContainer: Color { Color(hex: "#F3E0F7") }
    var onSecondaryContainer: Color { Color(hex: "#2D0033") }

    // MARK: - Tertiary
    var tertiary: Color { Color(hex: "#006B56") } // Deep teal for high contrast
    var onTertiary: Color { .white }

    // MARK: - Background & Surface
    var background: Color { .white }
    var onBackground: Color { .black }
    var surface: Color { Color(hex: "#FAFAFA") }
    var onSurface: Color { .black }
    var surfaceVariant: Color { Color(hex: "#F5F5F5") }
    var onSurfaceVariant: Color { Color(hex: "#212121") }

    // MARK: - Semantic State
    var error: Color { Color(hex: "#B71C1C") } // Deep red for high contrast
    var warning: Color { Color(hex: "#E65100") } // Deep orange for high contrast
    var success: Color { Color(hex: "#1B5E20") } // Deep green for high contrast
    var info: Color { Color(hex: "#0050B3") } // Matches primary

    // MARK: - Outline
    var outline: Color { Color(hex: "#424242") } // High contrast outline
    var outlineVariant: Color { Color(hex: "#757575") }
}
