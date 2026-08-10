import Foundation

/// §2 Color palette and roles.
///
/// The model has two levels: primitives, which are the raw color ladders, and roles, which give
/// those colors meaning.
/// States such as hover and disabled are stored as transforms rather than as finished colors, so a
/// brand's own derivation rules survive: SmartHR darkens by 5% on hover and applies 0.5 alpha when
/// disabled.
public struct ColorSpec: Codable, Sendable, Equatable {
    /// The raw color tokens, held in an array so the brand's own ordering is preserved.
    public var primitives: [ColorToken]
    /// The semantic roles, each referring to a primitive by name or giving a hex value directly.
    public var roles: [ColorRole]
    /// The rules that derive state colors such as hover, disabled, and link-hover.
    public var states: [ColorState]

    public init(primitives: [ColorToken], roles: [ColorRole], states: [ColorState] = []) {
        self.primitives = primitives
        self.roles = roles
        self.states = states
    }

    /// Returns the primitive with the given name. Use it when resolving a role's reference.
    public func primitive(named name: String) -> ColorToken? {
        primitives.first { $0.name == name }
    }
}

public struct ColorToken: Codable, Sendable, Equatable {
    public var name: String
    /// The color, written as #rrggbb or #rrggbbaa.
    public var hex: String
    /// A note on where the color came from, such as "warm black hwb(56,17,1)".
    public var note: String?

    public init(name: String, hex: String, note: String? = nil) {
        self.name = name
        self.hex = hex
        self.note = note
    }
}

/// A semantic color role.
///
/// The reference points at a primitive by name, which is preferred, or gives a hex value directly.
public struct ColorRole: Codable, Sendable, Equatable {
    /// The name of the role, such as "MAIN", "TEXT_LINK", or "BRAND".
    ///
    /// The brand's own vocabulary is kept as it is rather than mapped onto a common set of names.
    public var role: String
    /// The name of the primitive to use, or a hex value written as #rrggbb.
    public var ref: String
    public var note: String?

    public init(role: String, ref: String, note: String? = nil) {
        self.role = role
        self.ref = ref
        self.note = note
    }
}

/// A named rule that derives a state color, such as hover or disabled, from a base color.
public struct ColorState: Codable, Sendable, Equatable {
    public var name: String
    public var transform: ColorTransform

    public init(name: String, transform: ColorTransform) {
        self.name = name
        self.transform = transform
    }
}

/// A color transform that keeps a brand's derivation logic in declarative form.
public enum ColorTransform: Codable, Sendable, Equatable {
    /// Darkens the color by the given amount, from 0.0 to 1.0.
    case darken(Double)
    /// Lightens the color by the given amount, from 0.0 to 1.0.
    case lighten(Double)
    /// Multiplies the opacity by the given amount, from 0.0 to 1.0.
    case alpha(Double)
    /// A free-form description of a rule the other cases cannot express.
    case custom(String)
}
