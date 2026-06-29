import Foundation

/// スペーシングスケールプロトコル
///
/// 一貫した余白・間隔を提供するためのスケールシステム。
/// Tシャツサイズ命名規則（xs, sm, md, lg, xl...）を採用し、直感的に使用できる。
///
/// ## 使用例
/// ```swift
/// @Environment(\.spacingScale) var spacing
///
/// VStack(spacing: spacing.lg) {  // 16pt間隔
///     Text("タイトル")
///     Text("サブタイトル")
/// }
/// .padding(spacing.xl)  // 24pt余白
/// ```
///
/// ## スケール一覧
/// - `none`: 0pt - 間隔なし
/// - `xxs`: 2pt - 最小の間隔
/// - `xs`: 4pt - とても小さい間隔
/// - `sm`: 8pt - 小さい間隔
/// - `md`: 12pt - 中程度の間隔
/// - `lg`: 16pt - 標準的な間隔（推奨デフォルト）
/// - `xl`: 24pt - 大きい間隔
/// - `xxl`: 32pt - とても大きい間隔
/// - `xxxl`: 48pt - 非常に大きい間隔
/// - `xxxxl`: 64pt - 最大の間隔
public protocol SpacingScale: Sendable {
    /// 間隔なし（0pt）
    var none: CGFloat { get }

    /// 最小の間隔（2pt）
    var xxs: CGFloat { get }

    /// とても小さい間隔（4pt）
    var xs: CGFloat { get }

    /// 小さい間隔（8pt）
    var sm: CGFloat { get }

    /// 中程度の間隔（12pt）
    var md: CGFloat { get }

    /// 標準的な間隔（16pt）- 推奨デフォルト
    var lg: CGFloat { get }

    /// 大きい間隔（24pt）
    var xl: CGFloat { get }

    /// とても大きい間隔（32pt）
    var xxl: CGFloat { get }

    /// 非常に大きい間隔（48pt）
    var xxxl: CGFloat { get }

    /// 最大の間隔（64pt）
    var xxxxl: CGFloat { get }
}
