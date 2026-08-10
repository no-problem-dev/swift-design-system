import Foundation

/// §3 Typography rules, where the CJK extensions matter most.
///
/// This type holds everything the fixed `Typography` enum could not express:
/// - A Japanese font stack, including the case where a family is named but not bundled and
///   rendering is left to the system font.
/// - Size and leading kept apart, so SmartHR's body text reads as 16px at a leading of 1.5.
/// - The model that generated the ramp, such as SmartHR's harmonic scale, recorded rather than
///   flattened into a list of sizes.
public struct TypographySpec: Codable, Sendable, Equatable {
    public var fontStack: FontStack
    /// The model that generated the ramp. It is what makes the sizes explainable and reproducible.
    public var scaleModel: ScaleModel
    /// The type styles, one per role.
    public var ramp: [TypeStyle]
    /// The leading tokens, as multipliers. A type style refers to one of these by name.
    public var leading: [LeadingToken]

    public init(fontStack: FontStack, scaleModel: ScaleModel, ramp: [TypeStyle], leading: [LeadingToken]) {
        self.fontStack = fontStack
        self.scaleModel = scaleModel
        self.ramp = ramp
        self.leading = leading
    }

    public func leading(named name: String) -> LeadingToken? {
        leading.first { $0.name == name }
    }
}

/// A font stack.
///
/// When the stack is marked as a system stack, no typeface is bundled and rendering is left to the
/// host's system font. That is what SmartHR does in practice, and it is the default here because it
/// avoids typeface licensing problems by construction.
public struct FontStack: Codable, Sendable, Equatable {
    /// Family names in priority order, from Japanese to Latin to generic.
    ///
    /// It may be left empty for a system stack.
    public var families: [String]
    /// Whether rendering is left to the host's system font.
    public var system: Bool
    public var note: String?

    public init(families: [String] = [], system: Bool = true, note: String? = nil) {
        self.families = families
        self.system = system
        self.note = note
    }
}

/// The model that generates a type ramp.
public enum ScaleModel: Codable, Sendable, Equatable {
    /// A harmonic series, where size = base * scaleFactor / (scaleFactor + diff). SmartHR uses this.
    case harmonic(base: Double, scaleFactor: Double)
    /// A geometric series, where size = base * ratio^step. A major third is one example.
    case modular(base: Double, ratio: Double)
    /// Every size is written out individually.
    case manual
}

/// The type style for a single role.
///
/// The size is kept in rem, where 1rem is 16px, so the style stays platform independent.
public struct TypeStyle: Codable, Sendable, Equatable {
    /// The name of the role, such as "body-m" or "heading-l".
    ///
    /// The brand's own vocabulary is kept as it is.
    public var role: String
    /// The size in rem, where 1rem is 16px.
    public var sizeRem: Double
    public var weight: FontWeightToken
    /// The name of the leading token to use, such as "normal".
    public var leadingRef: String
    /// The letter spacing in em. Japanese text normally leaves this nil or zero.
    public var trackingEm: Double?

    public init(role: String, sizeRem: Double, weight: FontWeightToken, leadingRef: String, trackingEm: Double? = nil) {
        self.role = role
        self.sizeRem = sizeRem
        self.weight = weight
        self.leadingRef = leadingRef
        self.trackingEm = trackingEm
    }
}

/// A font weight token, equivalent to the keywords of the CSS `font-weight` property.
///
/// The eight steps run from `thin` (100) to `black` (900).
public enum FontWeightToken: String, Codable, Sendable, Equatable {
    case thin, light, regular, medium, semibold, bold, heavy, black
}

/// A leading token expressed as a multiplier, such as normal at 1.5.
public struct LeadingToken: Codable, Sendable, Equatable {
    public var name: String
    public var multiplier: Double

    public init(name: String, multiplier: Double) {
        self.name = name
        self.multiplier = multiplier
    }
}
