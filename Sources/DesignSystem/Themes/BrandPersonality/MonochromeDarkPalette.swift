import SwiftUI

/// Monochromeテーマ - ダークモードパレット
struct MonochromeDarkPalette: ColorPalette {
    // MARK: - Primary
    var primary: Color { Color(hex: "#CBD5E0") } // Light gray for dark mode
    var onPrimary: Color { Color(hex: "#1A202C") }
    var primaryContainer: Color { Color(hex: "#4A5568") }
    var onPrimaryContainer: Color { Color(hex: "#E2E8F0") }

    // MARK: - Secondary
    var secondary: Color { Color(hex: "#A0AEC0") } // Medium gray for dark mode
    var onSecondary: Color { Color(hex: "#2D3748") }
    var secondaryContainer: Color { Color(hex: "#718096") }
    var onSecondaryContainer: Color { Color(hex: "#EDF2F7") }

    // MARK: - Tertiary
    var tertiary: Color { Color(hex: "#E2E8F0") } // Lighter gray for dark mode
    var onTertiary: Color { Color(hex: "#2D3748") }

    // MARK: - Background & Surface
    var background: Color { Color(hex: "#0F1419") } // Near black
    var onBackground: Color { Color(hex: "#F7FAFC") }
    var surface: Color { Color(hex: "#1A202C") } // Elevated surface
    var onSurface: Color { Color(hex: "#F7FAFC") }
    var surfaceVariant: Color { Color(hex: "#2D3748") }
    var onSurfaceVariant: Color { Color(hex: "#CBD5E0") }

    // MARK: - Semantic State
    var error: Color { Color(hex: "#EF4444") }
    var warning: Color { Color(hex: "#FBBF24") }
    var success: Color { Color(hex: "#34D399") }
    var info: Color { Color(hex: "#CBD5E0") } // Matches primary

    // MARK: - Outline
    var outline: Color { Color(hex: "#4A5568") }
    var outlineVariant: Color { Color(hex: "#2D3748") }
}
