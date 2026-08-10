import SwiftUI

struct CategorySectionView: View {
    @Environment(\.colorPalette) private var colors
    @Environment(\.spacingScale) private var spacing

    let category: CatalogCategory

    var body: some View {
        CategoryItemRow(category: category)
            .padding(spacing.lg)
            .background(colors.surface)
            .elevation(.level1)
    }
}
