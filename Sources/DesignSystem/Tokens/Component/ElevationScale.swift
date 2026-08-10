import SwiftUI

/// A shadow style resolved from an elevation level.
public struct ElevationStyle: Sendable, Equatable {
    public var radius: CGFloat
    public var offset: CGSize
    public var opacity: Double

    public init(radius: CGFloat, offset: CGSize, opacity: Double) {
        self.radius = radius
        self.offset = offset
        self.opacity = opacity
    }

    /// The opacity adjusted for the given color scheme.
    ///
    /// Dark mode holds the shadow back, because depth there comes from the difference in
    /// surface brightness.
    public func opacity(for colorScheme: ColorScheme) -> Double {
        colorScheme == .dark ? opacity * 0.55 : opacity
    }
}

/// The shadow style a theme supplies for each elevation level.
///
/// A theme that implements this chooses how heavy its shadows are, anywhere from flat to
/// pronounced, rather than being held to the fixed values on ``Elevation``.
public protocol ElevationScale: Sendable {
    func style(for level: Elevation) -> ElevationStyle
}

/// The shadow ramp used when a theme does not supply its own.
///
/// The values are derived from ``Elevation``, so shadows look the same whether or not a
/// theme is applied.
public struct DefaultElevationScale: ElevationScale {
    public init() {}
    public func style(for level: Elevation) -> ElevationStyle {
        ElevationStyle(radius: level.radius, offset: level.offset, opacity: level.opacity)
    }
}
