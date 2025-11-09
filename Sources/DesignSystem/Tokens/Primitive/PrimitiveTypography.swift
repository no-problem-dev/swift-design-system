import Foundation

/// Primitive typography tokens
///
/// 基本的なフォントサイズと行間の値を定義します。
/// **直接使用は避け**、`Typography` enumから参照してください。
///
/// ## 使用方法
/// ```swift
/// // ❌ 避けるべき
/// Text("Sample").font(.system(size: PrimitiveTypography.size16))
///
/// // ✅ 推奨
/// Text("Sample").typography(.bodyMedium)
/// ```
///
/// ## 値の基準
/// - Material Design 3 タイプスケールに準拠
/// - 8ptグリッドシステムに基づく行間設定
public enum PrimitiveTypography {
    // MARK: - Font Sizes

    /// 11pt - Label Small相当
    public static let size11: CGFloat = 11

    /// 12pt - Body Small, Label Medium相当
    public static let size12: CGFloat = 12

    /// 14pt - Body Medium, Title Small, Label Large相当
    public static let size14: CGFloat = 14

    /// 16pt - Body Large, Title Medium相当
    public static let size16: CGFloat = 16

    /// 22pt - Title Large相当
    public static let size22: CGFloat = 22

    /// 24pt - Headline Small相当
    public static let size24: CGFloat = 24

    /// 28pt - Headline Medium相当
    public static let size28: CGFloat = 28

    /// 32pt - Headline Large相当
    public static let size32: CGFloat = 32

    /// 36pt - Display Small相当
    public static let size36: CGFloat = 36

    /// 45pt - Display Medium相当
    public static let size45: CGFloat = 45

    /// 57pt - Display Large相当
    public static let size57: CGFloat = 57

    // MARK: - Line Heights

    /// 16pt - 最小行間（Small text用）
    public static let lineHeight16: CGFloat = 16

    /// 20pt - Small〜Medium text行間
    public static let lineHeight20: CGFloat = 20

    /// 24pt - Body/Title行間
    public static let lineHeight24: CGFloat = 24

    /// 28pt - Title Large行間
    public static let lineHeight28: CGFloat = 28

    /// 32pt - Headline Small行間
    public static let lineHeight32: CGFloat = 32

    /// 36pt - Headline Medium行間
    public static let lineHeight36: CGFloat = 36

    /// 40pt - Headline Large行間
    public static let lineHeight40: CGFloat = 40

    /// 44pt - Display Small行間
    public static let lineHeight44: CGFloat = 44

    /// 52pt - Display Medium行間
    public static let lineHeight52: CGFloat = 52

    /// 64pt - Display Large行間
    public static let lineHeight64: CGFloat = 64
}
