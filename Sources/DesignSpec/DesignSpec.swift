import Foundation

/// The root model that describes a brand's design specification in machine-readable form.
///
/// It ports the nine sections of `DESIGN.md` from `awesome-design-md-jp` into a Codable model.
/// The type is pure data with no SwiftUI dependency, so a command line tool can generate, validate,
/// diff, and import it. Deriving a `Theme`, meaning the tokens, deterministically from a spec is the
/// job of the layer above, DesignSystemCore.
///
/// Design principles:
/// - Values are platform independent: colors are hex strings and dimensions are numbers.
/// - A spec keeps what makes a brand different instead of flattening it. Being able to express
///   SmartHR's char-relative spacing, a harmonic type ramp, and a double focus ring is the test
///   of whether the model is adequate.
public struct DesignSpec: Codable, Sendable, Equatable {
    /// §0 Brand metadata
    public var meta: BrandMeta
    /// §1 Visual Theme & Atmosphere
    public var theme: VisualTheme
    /// §2 Color Palette & Roles
    public var color: ColorSpec
    /// §3 Typography Rules, where the CJK extensions matter most
    public var typography: TypographySpec
    /// §5 Layout spacing, either char-relative or absolute
    public var spacing: SpacingSpec
    public var radius: RadiusSpec
    /// §6 Depth & Elevation
    public var elevation: ElevationSpec
    /// §5/§8 Layout Principles & Responsive
    public var layout: LayoutSpec
    /// §4 Component Stylings, one per archetype, each carrying the reasoning behind it
    public var components: [ComponentSpec]
    /// §7/§9 Do's & Don'ts + Agent Prompt Guide
    public var guidance: Guidance

    public init(
        meta: BrandMeta,
        theme: VisualTheme,
        color: ColorSpec,
        typography: TypographySpec,
        spacing: SpacingSpec,
        radius: RadiusSpec,
        elevation: ElevationSpec,
        layout: LayoutSpec,
        components: [ComponentSpec],
        guidance: Guidance
    ) {
        self.meta = meta
        self.theme = theme
        self.color = color
        self.typography = typography
        self.spacing = spacing
        self.radius = radius
        self.elevation = elevation
        self.layout = layout
        self.components = components
        self.guidance = guidance
    }
}

/// Metadata about a brand.
///
/// Because a catalog built from these specs is published as open source, the metadata states
/// explicitly whether assets such as typefaces and logos may be redistributed.
public struct BrandMeta: Codable, Sendable, Equatable {
    /// A unique identifier for the brand, such as "smarthr".
    public var id: String
    public var name: String
    /// The URL of the primary source, such as the brand's published design system.
    ///
    /// It is the evidence behind any claim that the spec follows the brand faithfully.
    public var sourceURL: String?
    /// Notes on fidelity: how closely the spec follows the brand and what was left out.
    public var fidelityNotes: String?
    /// Declares which assets are not bundled, such as licensed typefaces, logos, and trademarks.
    public var assetPolicy: String?

    public init(id: String, name: String, sourceURL: String? = nil, fidelityNotes: String? = nil, assetPolicy: String? = nil) {
        self.id = id
        self.name = name
        self.sourceURL = sourceURL
        self.fidelityNotes = fidelityNotes
        self.assetPolicy = assetPolicy
    }
}

/// §1 Visual theme and atmosphere: the keywords that name the aesthetic direction.
public struct VisualTheme: Codable, Sendable, Equatable {
    /// Keywords that describe the atmosphere, such as "warm", "trustworthy", "business", "accessible".
    public var atmosphere: [String]
    /// A single sentence stating the direction.
    public var summary: String

    public init(atmosphere: [String], summary: String) {
        self.atmosphere = atmosphere
        self.summary = summary
    }
}
