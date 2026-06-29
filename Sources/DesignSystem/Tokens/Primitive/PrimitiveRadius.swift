import Foundation

/// 基本角丸トークン
///
/// 基本的な角丸の値を定義する。
/// **直接使用は避け**、`RadiusScale` プロトコルの実装から参照すること。
///
/// ## 使用方法
/// ```swift
/// // ❌ 避けるべき
/// .cornerRadius(PrimitiveRadius.radius8)
///
/// // ✅ 推奨
/// @Environment(\.radiusScale) var radius
/// .cornerRadius(radius.md)
/// ```
///
/// カスタム角丸スケールでの使用：
/// ```swift
/// struct CustomRadiusScale: RadiusScale {
///     var md: CGFloat { PrimitiveRadius.radius8 }
///     var lg: CGFloat { PrimitiveRadius.radius12 }
///     // ...
/// }
/// ```
public enum PrimitiveRadius {
    public static let radius0: CGFloat = 0
    public static let radius2: CGFloat = 2
    public static let radius4: CGFloat = 4
    public static let radius6: CGFloat = 6
    public static let radius8: CGFloat = 8
    public static let radius12: CGFloat = 12
    public static let radius16: CGFloat = 16
    public static let radius20: CGFloat = 20
    public static let radius24: CGFloat = 24
    public static let radiusFull: CGFloat = .infinity
}
