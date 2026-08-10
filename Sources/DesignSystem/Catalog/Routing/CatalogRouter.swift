import SwiftUI

/// Maps a catalog category to the detail view that presents it.
@MainActor
enum CatalogRouter {
    @ViewBuilder
    static func destination(for category: CatalogCategory) -> some View {
        switch category {
        case .themes:
            destinationForTheme()
        case .foundations:
            destinationForFoundation()
        case .components:
            destinationForComponent()
        case .patterns:
            destinationForPattern()
        }
    }

    // MARK: - Private Helpers

    @ViewBuilder
    private static func destinationForTheme() -> some View {
        ThemeGalleryView()
    }

    @ViewBuilder
    private static func destinationForFoundation() -> some View {
        FoundationCatalogView()
    }

    @ViewBuilder
    private static func destinationForComponent() -> some View {
        ComponentsCatalogView()
    }

    @ViewBuilder
    private static func destinationForPattern() -> some View {
        PatternsCatalogView()
    }
}
