import SwiftUI

/// An inventive theme built on vivid purple and magenta.
///
/// Suited to technology, design, and creative tools.
public struct PurpleHazeTheme: Theme {
    public init() {}

    public var id: String { "purple-haze" }

    public var name: String { "Purple Haze" }

    public var description: String { "Vivid purple. Creative and inventive" }

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
