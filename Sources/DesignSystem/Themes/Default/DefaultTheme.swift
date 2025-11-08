import SwiftUI

/// デフォルトテーマ
///
/// システムの基本となる青ベースのテーマです。
public struct DefaultTheme: Theme {
    public init() {}

    public var id: String { "default" }

    public var name: String { "Default" }

    public var description: String { "システムの標準テーマ（ブルーベース）" }

    public var category: ThemeCategory { .standard }

    public var previewColors: [Color] {
        [
            PrimitiveColors.blue500,
            PrimitiveColors.purple500,
            PrimitiveColors.cyan500,
            PrimitiveColors.gray50,
            PrimitiveColors.gray900,
        ]
    }

    public func colorPalette(for mode: ThemeMode) -> any ColorPalette {
        switch mode {
        case .system, .light:
            return LightColorPalette()
        case .dark:
            return DarkColorPalette()
        }
    }
}
