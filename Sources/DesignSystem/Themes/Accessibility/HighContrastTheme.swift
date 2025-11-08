import SwiftUI

/// HighContrastテーマ - 高コントラスト・アクセシビリティ重視
///
/// WCAG AAA準拠の高コントラスト配色テーマ。
/// ロービジョンユーザーやアクセシビリティを重視するアプリに最適です。
public struct HighContrastTheme: Theme {
    public init() {}

    public var id: String { "high-contrast" }

    public var name: String { "High Contrast" }

    public var description: String { "WCAG AAA準拠。最大限の視認性とアクセシビリティ" }

    public var category: ThemeCategory { .accessibility }

    public var previewColors: [Color] {
        [
            Color(hex: "#0050B3"), // Primary (Light mode)
            Color(hex: "#6B0080"), // Secondary (Light mode)
            Color(hex: "#006B56"), // Tertiary (Light mode)
        ]
    }

    public func colorPalette(for mode: ThemeMode) -> any ColorPalette {
        switch mode {
        case .system, .light:
            return HighContrastLightPalette()
        case .dark:
            return HighContrastDarkPalette()
        }
    }
}
