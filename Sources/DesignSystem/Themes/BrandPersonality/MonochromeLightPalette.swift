import SwiftUI

/// Monochromeテーマ - ライトモードパレット
struct MonochromeLightPalette: ColorPalette {
    // MARK: - Primary
    var primary: Color { Color(hex: "#2D3748") } // Charcoal
    var onPrimary: Color { .white }
    var primaryContainer: Color { Color(hex: "#E2E8F0") }
    var onPrimaryContainer: Color { Color(hex: "#1A202C") }

    // MARK: - Secondary
    var secondary: Color { Color(hex: "#4A5568") } // Slate
    var onSecondary: Color { .white }
    var secondaryContainer: Color { Color(hex: "#EDF2F7") }
    var onSecondaryContainer: Color { Color(hex: "#2D3748") }

    // MARK: - Tertiary
    var tertiary: Color { Color(hex: "#718096") } // Gray
    var onTertiary: Color { .white }

    // MARK: - Background & Surface
    var background: Color { .white }
    var onBackground: Color { Color(hex: "#1A202C") }
    var surface: Color { Color(hex: "#F7FAFC") }
    var onSurface: Color { Color(hex: "#1A202C") }
    var surfaceVariant: Color { Color(hex: "#EDF2F7") }
    var onSurfaceVariant: Color { Color(hex: "#4A5568") }

    // MARK: - Semantic State
    var error: Color { Color(hex: "#DC2626") }
    var warning: Color { Color(hex: "#F59E0B") }
    var success: Color { Color(hex: "#10B981") }
    var info: Color { Color(hex: "#2D3748") } // Matches primary

    // MARK: - Outline
    var outline: Color { Color(hex: "#CBD5E0") }
    var outlineVariant: Color { Color(hex: "#E2E8F0") }
}
