import SwiftUI

/// Oceanテーマ - プロフェッショナル・落ち着き
///
/// 深い海の青をベースとした、信頼感と落ち着きを表現するテーマ。
/// 企業向けアプリや生産性ツールに最適です。
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
