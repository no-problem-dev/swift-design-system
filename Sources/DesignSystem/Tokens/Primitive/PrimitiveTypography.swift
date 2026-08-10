import Foundation

/// The base font size and line height values the design system is built from.
///
/// **Avoid using these directly.** Refer to them through the `Typography` enum.
///
/// ## How to use it
/// ```swift
/// // ❌ Avoid
/// Text("Sample").font(.system(size: PrimitiveTypography.size16))
///
/// // ✅ Preferred
/// Text("Sample").typography(.bodyMedium)
/// ```
///
/// ## Where the values come from
/// - The Material Design 3 type scale
/// - Line heights that sit on an 8pt grid system
public enum PrimitiveTypography {
    // MARK: - Font Sizes

    /// 11pt - the size behind Label Small
    public static let size11: CGFloat = 11

    /// 12pt - the size behind Body Small and Label Medium
    public static let size12: CGFloat = 12

    /// 14pt - the size behind Body Medium, Title Small, and Label Large
    public static let size14: CGFloat = 14

    /// 16pt - the size behind Body Large and Title Medium
    public static let size16: CGFloat = 16

    /// 22pt - the size behind Title Large
    public static let size22: CGFloat = 22

    /// 24pt - the size behind Headline Small
    public static let size24: CGFloat = 24

    /// 28pt - the size behind Headline Medium
    public static let size28: CGFloat = 28

    /// 32pt - the size behind Headline Large
    public static let size32: CGFloat = 32

    /// 36pt - the size behind Display Small
    public static let size36: CGFloat = 36

    /// 45pt - the size behind Display Medium
    public static let size45: CGFloat = 45

    /// 57pt - the size behind Display Large
    public static let size57: CGFloat = 57

    // MARK: - Line Heights

    /// 16pt - the smallest line height, for small text
    public static let lineHeight16: CGFloat = 16

    /// 20pt - the line height for small to medium text
    public static let lineHeight20: CGFloat = 20

    /// 24pt - the line height for Body and Title
    public static let lineHeight24: CGFloat = 24

    /// 28pt - the line height for Title Large
    public static let lineHeight28: CGFloat = 28

    /// 32pt - the line height for Headline Small
    public static let lineHeight32: CGFloat = 32

    /// 36pt - the line height for Headline Medium
    public static let lineHeight36: CGFloat = 36

    /// 40pt - the line height for Headline Large
    public static let lineHeight40: CGFloat = 40

    /// 44pt - the line height for Display Small
    public static let lineHeight44: CGFloat = 44

    /// 52pt - the line height for Display Medium
    public static let lineHeight52: CGFloat = 52

    /// 64pt - the line height for Display Large
    public static let lineHeight64: CGFloat = 64
}
