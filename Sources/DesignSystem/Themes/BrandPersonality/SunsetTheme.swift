import SwiftUI

/// Sunsetテーマ - 温かみ・エネルギッシュ
///
/// 夕焼けのオレンジをベースとした、温かみとエネルギーを感じるテーマ。
/// クリエイティブ、ソーシャル、エンターテイメント関連アプリに最適です。
public struct SunsetTheme: Theme {
    public init() {}

    public var id: String { "sunset" }

    public var name: String { "Sunset" }

    public var description: String { "夕焼けのオレンジ。温かくエネルギッシュな雰囲気" }

    public var category: ThemeCategory { .brandPersonality }

    public var previewColors: [Color] {
        [
            Color(hex: "#FF6B35"), // Primary
            Color(hex: "#F77F00"), // Secondary
            Color(hex: "#FCBF49"), // Tertiary
        ]
    }

    public func colorPalette(for mode: ThemeMode) -> any ColorPalette {
        switch mode {
        case .system, .light:
            return SunsetLightPalette()
        case .dark:
            return SunsetDarkPalette()
        }
    }
}
