import Foundation

/// The group a theme belongs to when themes are listed by purpose.
///
/// ## Categories
/// - **standard**: The basic light and dark theme.
/// - **brandPersonality**: Themes that carry a brand personality, such as Ocean, Forest, and Sunset.
/// - **accessibility**: High contrast themes that meet WCAG.
/// - **custom**: Themes an app defines for itself.
public enum ThemeCategory: String, Sendable, CaseIterable, Identifiable {
    case standard = "標準"

    case custom = "カスタム"

    case brandPersonality = "ブランドパーソナリティ"

    case accessibility = "アクセシビリティ"

    public var id: String { rawValue }

    /// A sentence describing the category, for display below its name.
    public var description: String {
        switch self {
        case .standard:
            return "基本的なライトテーマとダークテーマ"
        case .brandPersonality:
            return "ブランドの個性を表現する多彩なテーマ"
        case .accessibility:
            return "アクセシビリティを重視した高コントラストテーマ"
        case .custom:
            return "アプリ固有のカスタムテーマ"
        }
    }

    /// The name of the SF Symbol that stands for the category.
    public var icon: String {
        switch self {
        case .standard:
            return "circle.lefthalf.filled"
        case .brandPersonality:
            return "paintpalette.fill"
        case .accessibility:
            return "eye.fill"
        case .custom:
            return "wand.and.stars"
        }
    }
}
