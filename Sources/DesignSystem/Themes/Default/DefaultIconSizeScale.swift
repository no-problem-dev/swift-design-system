import Foundation

/// Seven icon sizes, taken from the sizes Material Design 3 and the Human Interface Guidelines recommend.
public struct DefaultIconSizeScale: IconSizeScale {
    public init() {}

    public var xxs: CGFloat { 8 }
    public var xs: CGFloat { 12 }
    public var sm: CGFloat { 16 }
    public var md: CGFloat { 24 }
    public var lg: CGFloat { 32 }
    public var xl: CGFloat { 48 }
    public var xxl: CGFloat { 64 }
}
