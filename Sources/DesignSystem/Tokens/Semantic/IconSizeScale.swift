import Foundation

/// アイコンサイズスケールプロトコル。
///
/// SF Symbol / Emoji / Image の表示サイズを token 化する。
/// `Typography` (テキスト) と `SpacingScale` (余白) とは責務が異なる — icon は
/// 「視覚要素のサイズ」であり、テキストの lineHeight や余白とは独立した scale を持つ。
///
/// ## 使用例
/// ```swift
/// @Environment(\.iconSizeScale) var iconSize
///
/// Image(systemName: "checkmark")
///     .iconSize(.sm)          // body テキストと並ぶインラインアイコン
///
/// Image(systemName: "star.fill")
///     .iconSize(.lg)          // セクションヘッダーアイコン
///
/// Image(systemName: "sparkles")
///     .iconSize(.xl)          // ヒーローアイコン (onboarding / empty state)
/// ```
///
/// ## スケール一覧
/// - `xxs`: 8pt - 極小 badge
/// - `xs`: 12pt - badge indicator / decoration
/// - `sm`: 16pt - body テキストと並ぶインラインアイコン
/// - `md`: 24pt - 標準的なアイコン（推奨デフォルト）
/// - `lg`: 32pt - 中見出しやカテゴリアイコン
/// - `xl`: 48pt - ヒーローアイコン（section header / empty state）
/// - `xxl`: 64pt - ディスプレイアイコン（onboarding welcome 等）
public protocol IconSizeScale: Sendable {
    /// 極小（8pt）
    var xxs: CGFloat { get }

    /// 最小（12pt）
    var xs: CGFloat { get }

    /// 小（16pt）- body インライン
    var sm: CGFloat { get }

    /// 中（24pt）- 標準
    var md: CGFloat { get }

    /// 大（32pt）
    var lg: CGFloat { get }

    /// 特大（48pt）- ヒーロー
    var xl: CGFloat { get }

    /// 最大（64pt）- ディスプレイ
    var xxl: CGFloat { get }
}
