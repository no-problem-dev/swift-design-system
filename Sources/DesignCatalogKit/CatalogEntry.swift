import SwiftUI
import DesignSystem
import DesignSpec

/// The reasoning behind a component or token decision.
///
/// Keeping the "why" next to the component is what makes comparing brands side by side worth doing.
public struct DesignAnnotation: Sendable, Equatable {
    /// What the design solves.
    public var purpose: String
    /// Why it works, in terms of conversion, retention, or accessibility.
    public var whyItWorks: String
    /// The URL of the primary source.
    public var sourceURL: String?

    public init(purpose: String, whyItWorks: String, sourceURL: String? = nil) {
        self.purpose = purpose
        self.whyItWorks = whyItWorks
        self.sourceURL = sourceURL
    }

    /// Creates an annotation from a component in a design spec.
    ///
    /// Use it when the spec is the source of truth, so the catalog does not restate the reasoning.
    public init(from component: ComponentSpec) {
        self.purpose = component.name
        self.whyItWorks = component.annotation
        self.sourceURL = component.sourceURL
    }
}

/// A single showcase in the catalog.
///
/// An entry draws a brand's signature component under that brand's own theme, and carries both the
/// archetype it is compared on and the reasoning behind its design.
/// Putting entries that share an archetype next to each other is the point of compare mode:
/// SmartHR's form control sits beside another brand's form control.
public struct CatalogEntry: Identifiable {
    public let id: String
    /// The brand identifier, such as "smarthr".
    public let brandId: String
    public let brandName: String
    /// The axis entries are compared on, such as "FormControl", "FocusIndicator", or "ProductCard".
    public let archetype: String
    /// The headline shown on the entry's gallery card.
    public let title: String
    public let annotation: DesignAnnotation
    /// The brand theme this entry is drawn under.
    public let theme: any Theme
    /// The view that draws the component, type erased.
    public let content: AnyView

    @MainActor
    public init<Content: View>(
        id: String,
        brandId: String,
        brandName: String,
        archetype: String,
        title: String,
        annotation: DesignAnnotation,
        theme: any Theme,
        @ViewBuilder content: @MainActor () -> Content
    ) {
        self.id = id
        self.brandId = brandId
        self.brandName = brandName
        self.archetype = archetype
        self.title = title
        self.annotation = annotation
        self.theme = theme
        self.content = AnyView(content())
    }
}

public extension Array where Element == CatalogEntry {
    /// Groups the entries by archetype, sorted by archetype name, for use in compare mode.
    func groupedByArchetype() -> [(archetype: String, entries: [CatalogEntry])] {
        Dictionary(grouping: self, by: \.archetype)
            .sorted { $0.key < $1.key }
            .map { (archetype: $0.key, entries: $0.value) }
    }

    /// Returns only the entries with the given archetype.
    func entries(ofArchetype archetype: String) -> [CatalogEntry] {
        filter { $0.archetype == archetype }
    }
}
