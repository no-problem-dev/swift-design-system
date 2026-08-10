import SwiftUI

/// A calm, dependable theme built on deep ocean blue.
///
/// Suited to enterprise apps and productivity tools.
public struct OceanTheme: Theme {
    public init() {}

    public var id: String { "ocean" }

    public var name: String { "Ocean" }

    public var description: String { "深い海の青。プロフェッショナルで落ち着いた雰囲気" }

    public var category: ThemeCategory { .brandPersonality }

    public var previewColors: [Color] {
        [
            Color(hex: "#0077BE"), // Primary
            Color(hex: "#00A8CC"), // Secondary
            Color(hex: "#4ECDC4"), // Tertiary
        ]
    }

    public func colorPalette(for mode: ThemeMode) -> any ColorPalette {
        switch mode {
        case .system, .light:
            return OceanLightPalette()
        case .dark:
            return OceanDarkPalette()
        }
    }
}
