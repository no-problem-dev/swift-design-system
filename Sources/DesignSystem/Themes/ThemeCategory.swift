import Foundation

/// テーマのカテゴリ分類
///
/// テーマを用途や目的によってグループ化します。
///
/// ## カテゴリ
/// - **standard**: デフォルトの基本テーマ
/// - **brandPersonality**: ブランドの個性を表現する多彩なテーマ（Ocean, Forest, Sunsetなど）
/// - **accessibility**: WCAG準拠の高コントラストテーマ
/// - **custom**: アプリ固有のカスタムテーマ
public enum ThemeCategory: String, Sendable, CaseIterable, Identifiable {
    /// 標準テーマ（デフォルト）
    case standard = "標準"

    /// カスタムテーマ（ユーザー定義）
    case custom = "カスタム"

    /// ブランドパーソナリティテーマ
    case brandPersonality = "ブランドパーソナリティ"

    /// アクセシビリティテーマ
    case accessibility = "アクセシビリティ"

    public var id: String { rawValue }

    /// カテゴリの説明
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

    /// カテゴリのアイコン名
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
