import SwiftUI

/// Light-mode palette for the high contrast theme, where each pair of colors meets WCAG AAA.
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
    var tertiary: Color { Color(hex: "#005745") } // Deep teal for high contrast
    var onTertiary: Color { .white }

    // MARK: - Background & Surface
    var background: Color { .white }
    var onBackground: Color { .black }
    var surface: Color { Color(hex: "#FAFAFA") }
    var onSurface: Color { .black }
    var surfaceVariant: Color { Color(hex: "#F5F5F5") }
    var onSurfaceVariant: Color { Color(hex: "#212121") }

    // MARK: - Semantic State
    // Every fill is dark enough to reach AAA (7.0) both against a white background and beneath
    // white text. warning is the exception: its default on-color is black, and that pairing
    // falls short of AAA, so onWarning is overridden to give it the dark fill with white text
    // the other semantic colors use.
    var error: Color { Color(hex: "#991B1B") } // Deep red for high contrast
    var warning: Color { Color(hex: "#8F2900") } // Deep orange for high contrast
    var onWarning: Color { .white }
    var success: Color { Color(hex: "#1B5E20") } // Deep green for high contrast
    var info: Color { Color(hex: "#0050B3") } // Matches primary

    // MARK: - Outline
    var outline: Color { Color(hex: "#424242") } // High contrast outline
    var outlineVariant: Color { Color(hex: "#757575") }
}
