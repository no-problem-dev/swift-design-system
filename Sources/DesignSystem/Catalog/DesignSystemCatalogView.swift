import SwiftUI

/// The entry point of the design system catalog, presenting every element in a hierarchy.
///
/// The layout follows the horizontal size class:
/// - Regular: a three-column NavigationSplitView
/// - Compact: a list built on NavigationStack
///
/// This keeps the catalog usable in iPad Split View and Slide Over.
public struct DesignSystemCatalogView: View {
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass

    public init() {}

    public var body: some View {
        if horizontalSizeClass == .regular {
            DesignSystemCatalogSplitView()
        } else {
            CatalogListView()
        }
    }
}

#Preview {
    DesignSystemCatalogView()
        .theme(ThemeProvider())
}
