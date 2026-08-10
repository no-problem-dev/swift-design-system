import Foundation

/// §6 Depth and elevation.
///
/// Porting a CSS shadow exactly across platforms is not realistic, so each layer carries both
/// structured fields and the CSS it was derived from. The original CSS is the evidence behind the
/// approximation.
/// A focus ring is an accessibility fingerprint, SmartHR draws a double ring with a white gap and a
/// colored outer ring, so it gets a field of its own instead of being folded into a layer.
public struct ElevationSpec: Codable, Sendable, Equatable {
    public var layers: [ElevationLayer]
    public var focusRing: FocusRing?

    public init(layers: [ElevationLayer], focusRing: FocusRing? = nil) {
        self.layers = layers
        self.focusRing = focusRing
    }
}

public struct ElevationLayer: Codable, Sendable, Equatable {
    public var name: String
    /// The vertical offset of the shadow in points, approximated.
    public var yOffset: Double?
    /// The blur radius in points, approximated.
    public var blur: Double?
    /// The opacity, from 0 to 1, approximated.
    public var opacity: Double?
    /// The CSS the layer was derived from. It is the evidence behind the approximated fields.
    public var rawCSS: String?

    public init(name: String, yOffset: Double? = nil, blur: Double? = nil, opacity: Double? = nil, rawCSS: String? = nil) {
        self.name = name
        self.yOffset = yOffset
        self.blur = blur
        self.opacity = opacity
        self.rawCSS = rawCSS
    }
}

public struct FocusRing: Codable, Sendable, Equatable {
    /// Whether the ring is drawn twice, with a white gap between the control and the colored ring.
    public var doubleRing: Bool
    /// The color of the ring, given as a role name or a hex value.
    public var colorRef: String
    public var note: String?

    public init(doubleRing: Bool, colorRef: String, note: String? = nil) {
        self.doubleRing = doubleRing
        self.colorRef = colorRef
        self.note = note
    }
}

/// §5 Layout principles and §8 responsive breakpoints.
public struct LayoutSpec: Codable, Sendable, Equatable {
    public var principles: [String]
    public var breakpoints: [Breakpoint]

    public init(principles: [String] = [], breakpoints: [Breakpoint] = []) {
        self.principles = principles
        self.breakpoints = breakpoints
    }
}

public struct Breakpoint: Codable, Sendable, Equatable {
    public var name: String
    public var minWidth: Double

    public init(name: String, minWidth: Double) {
        self.name = name
        self.minWidth = minWidth
    }
}

/// §4 Component stylings.
///
/// Only the metadata is standardized. Components are not made to conform to a behavioral protocol,
/// because the shape a brand chose is itself the insight. The archetype is what makes components
/// comparable across brands, and the annotation, which records why the brand did it that way, is
/// what the comparison feeds on.
public struct ComponentSpec: Codable, Sendable, Equatable {
    /// The axis components are compared on across brands, such as "ProductCard" or "FormControl".
    public var archetype: String
    /// What the brand itself calls the component, such as "FormControl".
    public var name: String
    /// Why the brand designed it this way: what it solves and how it affects conversion and retention.
    public var annotation: String
    /// The URL of the primary source for the component.
    public var sourceURL: String?
    /// A note on how faithfully the spec reproduces the brand's original.
    public var fidelity: String?

    public init(archetype: String, name: String, annotation: String, sourceURL: String? = nil, fidelity: String? = nil) {
        self.archetype = archetype
        self.name = name
        self.annotation = annotation
        self.sourceURL = sourceURL
        self.fidelity = fidelity
    }
}

/// §7 Do's and don'ts, plus the §9 agent prompt guide.
public struct Guidance: Codable, Sendable, Equatable {
    public var dos: [String]
    public var donts: [String]
    /// Guidance for prompting a model so that it generates UI consistent with the brand.
    public var agentPrompt: String?

    public init(dos: [String] = [], donts: [String] = [], agentPrompt: String? = nil) {
        self.dos = dos
        self.donts = donts
        self.agentPrompt = agentPrompt
    }
}
