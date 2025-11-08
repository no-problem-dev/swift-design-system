import SwiftUI

/// Monochromeテーマ - ミニマル・エレガント
///
/// グレースケールをベースとした、ミニマルで洗練されたテーマ。
/// ビジネス、エディトリアル、プレミアムアプリに最適です。
public struct MonochromeTheme: Theme {
    public init() {}

    public var id: String { "monochrome" }

    public var name: String { "Monochrome" }

    public var description: String { "グレースケール。ミニマルでエレガントな雰囲気" }

    public var category: ThemeCategory { .brandPersonality }

    public var previewColors: [Color] {
        [
            Color(hex: "#2D3748"), // Primary
            Color(hex: "#4A5568"), // Secondary
            Color(hex: "#718096"), // Tertiary
        ]
    }

    public func colorPalette(for mode: ThemeMode) -> any ColorPalette {
        switch mode {
        case .system, .light:
            return MonochromeLightPalette()
        case .dark:
            return MonochromeDarkPalette()
        }
    }
}
