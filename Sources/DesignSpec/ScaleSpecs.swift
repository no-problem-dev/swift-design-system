import Foundation

/// A spacing scale, expressed either in absolute points or relative to the character size.
///
/// SmartHR uses the char-relative model, with a base of 8px, a character size of 16px, and each
/// step computed as multiplier × 16px. That differs in spirit from the absolute-point
/// `SpacingScale` used by the token layer, so holding both models is what makes this type adequate.
public struct SpacingSpec: Codable, Sendable, Equatable {
    public var model: SpacingModel
    public var steps: [SpacingStep]

    public init(model: SpacingModel, steps: [SpacingStep]) {
        self.model = model
        self.steps = steps
    }
}

public enum SpacingModel: Codable, Sendable, Equatable {
    /// Treats each step's value as points.
    case absolutePt
    /// Computes each step from the base pixel size and a multiplier. Converting to points is left
    /// to the layer that derives the theme.
    case charRelative(basePx: Double)
}

public struct SpacingStep: Codable, Sendable, Equatable {
    public var name: String
    /// The resolved value: points for the absolute model, or pixels once the multiplier is applied.
    public var value: Double
    /// The original multiplier of the char-relative model, kept for the record and allowed to be nil.
    public var multiplier: Double?

    public init(name: String, value: Double, multiplier: Double? = nil) {
        self.name = name
        self.value = value
        self.multiplier = multiplier
    }
}

public struct RadiusSpec: Codable, Sendable, Equatable {
    public var steps: [RadiusStep]

    public init(steps: [RadiusStep]) {
        self.steps = steps
    }
}

public struct RadiusStep: Codable, Sendable, Equatable {
    public var name: String
    /// The radius in points. A step named full carries a very large value to produce a capsule.
    public var value: Double

    public init(name: String, value: Double) {
        self.name = name
        self.value = value
    }
}
