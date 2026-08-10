import SwiftUI

/// A three column layout, tuned for iPad, that presents every part of the design system hierarchically.
public struct DesignSystemCatalogSplitView: View {
    @Environment(ThemeProvider.self) private var themeProvider

    @State private var columnVisibility: NavigationSplitViewVisibility = .all

    // Selection state
    @State private var selectedCategory: CatalogCategory? = .themes
    @State private var selectedFoundationItem: FoundationItem?
    @State private var selectedComponentItem: ComponentType?
    @State private var selectedPatternItem: PatternItem?

    public init() {}

    public var body: some View {
        NavigationSplitView(columnVisibility: $columnVisibility) {
            // Sidebar: the list of categories
            CatalogSidebarView(selectedCategory: $selectedCategory)
        } content: {
            // Content: the items in the selected category
            CatalogContentView(
                category: selectedCategory,
                selectedFoundationItem: $selectedFoundationItem,
                selectedComponentItem: $selectedComponentItem,
                selectedPatternItem: $selectedPatternItem
            )
        } detail: {
            // Detail: the selected item
            CatalogDetailView(
                category: selectedCategory,
                foundationItem: selectedFoundationItem,
                componentItem: selectedComponentItem,
                patternItem: selectedPatternItem
            )
        }
        .navigationSplitViewStyle(.balanced)
        .onChange(of: selectedCategory) { _, newCategory in
            // Reset the item selection when the category changes
            selectedFoundationItem = nil
            selectedComponentItem = nil
            selectedPatternItem = nil
        }
    }
}

#Preview {
    DesignSystemCatalogSplitView()
        .theme(ThemeProvider())
}

#Preview("With Custom Theme") {
    @Previewable @State var themeProvider = ThemeProvider(
        initialTheme: OceanTheme()
    )

    DesignSystemCatalogSplitView()
        .theme(themeProvider)
}
