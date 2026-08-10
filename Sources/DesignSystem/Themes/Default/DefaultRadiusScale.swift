import Foundation

public struct DefaultRadiusScale: RadiusScale {
    public init() {}

    public var none: CGFloat { PrimitiveRadius.radius0 }
    public var xs: CGFloat { PrimitiveRadius.radius2 }
    public var sm: CGFloat { PrimitiveRadius.radius4 }
    public var md: CGFloat { PrimitiveRadius.radius8 }
    public var lg: CGFloat { PrimitiveRadius.radius12 }
    public var xl: CGFloat { PrimitiveRadius.radius16 }
    public var xxl: CGFloat { PrimitiveRadius.radius20 }
    public var card: CGFloat { PrimitiveRadius.radius24 }
    public var full: CGFloat { PrimitiveRadius.radiusFull }
}
