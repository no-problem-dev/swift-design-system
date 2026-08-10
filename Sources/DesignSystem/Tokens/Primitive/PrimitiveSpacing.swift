import Foundation

/// The base spacing values the design system is built from.
///
/// **Avoid using these directly.** Refer to them from an implementation of the
/// `SpacingScale` protocol.
///
/// ## How to use it
/// ```swift
/// // ❌ Avoid
/// .padding(PrimitiveSpacing.space16)
///
/// // ✅ Preferred
/// @Environment(\.spacingScale) var spacing
/// .padding(spacing.lg)
/// ```
///
/// Using them in a custom spacing scale:
/// ```swift
/// struct CustomSpacingScale: SpacingScale {
///     var lg: CGFloat { PrimitiveSpacing.space16 }
///     var xl: CGFloat { PrimitiveSpacing.space24 }
///     // ...
/// }
/// ```
public enum PrimitiveSpacing {
    public static let space0: CGFloat = 0
    public static let space2: CGFloat = 2
    public static let space4: CGFloat = 4
    public static let space8: CGFloat = 8
    public static let space12: CGFloat = 12
    public static let space16: CGFloat = 16
    public static let space20: CGFloat = 20
    public static let space24: CGFloat = 24
    public static let space32: CGFloat = 32
    public static let space40: CGFloat = 40
    public static let space48: CGFloat = 48
    public static let space64: CGFloat = 64
    public static let space80: CGFloat = 80
    public static let space96: CGFloat = 96
}
