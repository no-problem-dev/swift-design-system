import SwiftUI

struct CategoryItemRow: View {
    let category: CatalogCategory

    var body: some View {
        NavigationLink {
            CatalogRouter.destination(for: category)
        } label: {
            CatalogItemRowContent(
                icon: category.icon,
                title: category.rawValue,
                description: category.description
            )
        }
        .buttonStyle(.plain)
    }
}
