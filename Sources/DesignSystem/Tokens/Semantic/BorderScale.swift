import SwiftUI

/// The stroke widths used for borders, dividers, and focus rings.
///
/// Line weight differs a lot between brands: some draw nearly everything at 1px and render
/// focus as a 2px + 2px double ring. Reaching for this scale instead of writing
/// `lineWidth: 1` inside a component lets a theme change the weight of every line at once.
public protocol BorderScale: Sendable {
    /// 0
    var none: CGFloat { get }
    /// A hairline (0.5).
    var thin: CGFloat { get }
    /// The standard width (1).
    var regular: CGFloat { get }
    /// A heavier width for emphasis (2).
    var thick: CGFloat { get }
    /// A heavy width for focus rings and the like (4).
    var heavy: CGFloat { get }
}

public struct DefaultBorderScale: BorderScale {
    public init() {}
    public var none: CGFloat { 0 }
    public var thin: CGFloat { 0.5 }
    public var regular: CGFloat { 1 }
    public var thick: CGFloat { 2 }
    public var heavy: CGFloat { 4 }
}
