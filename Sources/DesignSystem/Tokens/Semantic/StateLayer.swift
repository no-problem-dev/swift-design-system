import SwiftUI

/// The opacity of the overlay drawn while a control is being interacted with.
///
/// Hover, press, focus, and the other states are expressed by laying the foreground color
/// over the control at these opacities, the way a Material state layer does. Brands express
/// these states in different ways, some by darkening the control rather than overlaying it;
/// this scale settles on the opacity overlay model.
public protocol StateLayer: Sendable {
    var hover: Double { get }
    var focus: Double { get }
    var pressed: Double { get }
    var dragged: Double { get }
    var selected: Double { get }
}

public struct DefaultStateLayer: StateLayer {
    public init() {}
    public var hover: Double { 0.08 }
    public var focus: Double { 0.10 }
    public var pressed: Double { 0.10 }
    public var dragged: Double { 0.16 }
    public var selected: Double { 0.12 }
}
