import SwiftUI

/// A gradient held as a design token.
///
/// Stores the colors and the direction, and builds the linear gradient from them. Naming a
/// gradient here rather than defining it inline in a component lets a theme restyle every
/// gradient in the app at once.
public struct GradientToken: Sendable, Equatable {
    public var colors: [Color]
    public var startPoint: UnitPoint
    public var endPoint: UnitPoint

    public init(colors: [Color], startPoint: UnitPoint = .topLeading, endPoint: UnitPoint = .bottomTrailing) {
        self.colors = colors
        self.startPoint = startPoint
        self.endPoint = endPoint
    }

    public var linearGradient: LinearGradient {
        LinearGradient(colors: colors, startPoint: startPoint, endPoint: endPoint)
    }
}

/// The set of semantic gradients a theme supplies, so that a brand can substitute its own.
public protocol GradientTokens: Sendable {
    /// The brand's headline gradient.
    var brand: GradientToken { get }
    /// A restrained gradient for surfaces and backgrounds.
    var surface: GradientToken { get }
    var accent: GradientToken { get }
}

/// The gradients used when a theme does not supply its own.
public struct DefaultGradientTokens: GradientTokens {
    public init() {}
    public var brand: GradientToken {
        GradientToken(colors: [PrimitiveColors.blue500, PrimitiveColors.purple500])
    }
    public var surface: GradientToken {
        GradientToken(colors: [PrimitiveColors.gray50, PrimitiveColors.gray100])
    }
    public var accent: GradientToken {
        GradientToken(colors: [PrimitiveColors.cyan500, PrimitiveColors.blue500])
    }
}
