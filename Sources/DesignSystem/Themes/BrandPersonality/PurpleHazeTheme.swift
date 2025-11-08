import SwiftUI

/// PurpleHazeテーマ - クリエイティブ・革新的
///
/// 鮮やかな紫とマゼンタをベースとした、創造性と革新性を感じるテーマ。
/// テクノロジー、デザイン、クリエイティブツールに最適です。
public struct PurpleHazeTheme: Theme {
    public init() {}

    public var id: String { "purple-haze" }

    public var name: String { "Purple Haze" }

    public var description: String { "鮮やかな紫。クリエイティブで革新的な雰囲気" }

    public var category: ThemeCategory { .brandPersonality }

    public var previewColors: [Color] {
        [
            Color(hex: "#7209B7"), // Primary
            Color(hex: "#B5179E"), // Secondary
            Color(hex: "#F72585"), // Tertiary
        ]
    }

    public func colorPalette(for mode: ThemeMode) -> any ColorPalette {
        switch mode {
        case .system, .light:
            return PurpleHazeLightPalette()
        case .dark:
            return PurpleHazeDarkPalette()
        }
    }
}
