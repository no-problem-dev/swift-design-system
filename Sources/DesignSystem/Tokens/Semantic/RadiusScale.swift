import Foundation

/// 角丸スケールプロトコル
///
/// 一貫した角丸（border-radius）を提供するためのスケールシステム。
/// カード、ボタン、入力フィールドなどの角丸を統一できる。
///
/// ## 使用例
/// ```swift
/// @Environment(\.radiusScale) var radius
///
/// RoundedRectangle(cornerRadius: radius.md)
///     .fill(Color.blue)
///     .frame(width: 100, height: 100)
///
/// // または
/// Text("ボタン")
///     .padding()
///     .background(Color.blue)
///     .cornerRadius(radius.lg)
/// ```
///
/// ## スケール一覧
/// - `none`: 0pt - 角丸なし（四角）
/// - `xs`: 2pt - 最小の角丸
/// - `sm`: 4pt - 小さい角丸
/// - `md`: 8pt - 中程度の角丸（カードなどに推奨）
/// - `lg`: 12pt - 大きい角丸
/// - `xl`: 16pt - とても大きい角丸
/// - `xxl`: 20pt - 非常に大きい角丸
/// - `card`: 24pt - 主役サーフェス（コンポーザー、ヒーローカードなど）
/// - `full`: 9999pt - 完全な円形（ボタン、アバターなど）
public protocol RadiusScale: Sendable {
    /// 角丸なし（0pt）
    var none: CGFloat { get }

    /// 最小の角丸（2pt）
    var xs: CGFloat { get }

    /// 小さい角丸（4pt）
    var sm: CGFloat { get }

    /// 中程度の角丸（8pt）- カードなどに推奨
    var md: CGFloat { get }

    /// 大きい角丸（12pt）
    var lg: CGFloat { get }

    /// とても大きい角丸（16pt）
    var xl: CGFloat { get }

    /// 非常に大きい角丸（20pt）
    var xxl: CGFloat { get }

    /// 主役サーフェスの角丸（24pt）- コンポーザー、ヒーローカードなど
    /// 画面の主役となる大きな面に使う。xxl(20) より一段強い丸み。
    var card: CGFloat { get }

    /// 完全な円形（9999pt）- ボタン、アバターなど
    var full: CGFloat { get }
}

public extension RadiusScale {
    /// 既存テーマの後方互換のためのデフォルト（24pt）。
    var card: CGFloat { 24 }
}
