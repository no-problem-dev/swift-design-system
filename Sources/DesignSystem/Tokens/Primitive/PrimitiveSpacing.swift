import Foundation

/// 基本スペーシングトークン
///
/// 基本的なスペーシング値を定義する。
/// **直接使用は避け**、`SpacingScale` プロトコルの実装から参照すること。
///
/// ## 使用方法
/// ```swift
/// // ❌ 避けるべき
/// .padding(PrimitiveSpacing.space16)
///
/// // ✅ 推奨
/// @Environment(\.spacingScale) var spacing
/// .padding(spacing.lg)
/// ```
///
/// カスタムスペーシングスケールでの使用：
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
