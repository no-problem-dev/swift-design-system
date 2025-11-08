import SwiftUI

/// Forestテーマ - ナチュラル・地に足がついた
///
/// 深い森の緑をベースとした、自然で落ち着きのあるテーマ。
/// ヘルスケア、アウトドア、サステナビリティ関連アプリに最適です。
public struct ForestTheme: Theme {
    public init() {}

    public var id: String { "forest" }

    public var name: String { "Forest" }

    public var description: String { "深い森の緑。自然で落ち着いた雰囲気" }

    public var category: ThemeCategory { .brandPersonality }

    public var previewColors: [Color] {
        [
            Color(hex: "#2D5016"), // Primary
            Color(hex: "#52B788"), // Secondary
            Color(hex: "#74C69D"), // Tertiary
        ]
    }

    public func colorPalette(for mode: ThemeMode) -> any ColorPalette {
        switch mode {
        case .system, .light:
            return ForestLightPalette()
        case .dark:
            return ForestDarkPalette()
        }
    }
}
