import Foundation

public struct DefaultSpacingScale: SpacingScale {
    public init() {}

    public var none: CGFloat { PrimitiveSpacing.space0 }
    public var xxs: CGFloat { PrimitiveSpacing.space2 }
    public var xs: CGFloat { PrimitiveSpacing.space4 }
    public var sm: CGFloat { PrimitiveSpacing.space8 }
    public var md: CGFloat { PrimitiveSpacing.space12 }
    public var lg: CGFloat { PrimitiveSpacing.space16 }
    public var xl: CGFloat { PrimitiveSpacing.space24 }
    public var xxl: CGFloat { PrimitiveSpacing.space32 }
    public var xxxl: CGFloat { PrimitiveSpacing.space48 }
    public var xxxxl: CGFloat { PrimitiveSpacing.space64 }
}
