import SwiftUI

/// カテゴリアイテムの行ビュー
struct CategoryItemRow: View {
    @Environment(\.colorPalette) private var colors
    @Environment(\.spacingScale) private var spacing
    @Environment(\.radiusScale) private var radius

    let category: CatalogCategory
    let item: CatalogItem

    var body: some View {
        NavigationLink {
            CatalogRouter.destination(for: category, item: item)
        } label: {
            HStack(spacing: spacing.md) {
                Image(systemName: item.icon)
                    .font(.title3)
                    .foregroundStyle(colors.primary)
                    .frame(width: 32)

                VStack(alignment: .leading, spacing: 2) {
                    Text(item.name)
                        .typography(.bodyLarge)
                        .foregroundStyle(colors.onSurface)

                    Text(item.description)
                        .typography(.bodySmall)
                        .foregroundStyle(colors.onSurfaceVariant)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .typography(.labelMedium)
                    .foregroundStyle(colors.onSurfaceVariant)
            }
            .padding(.horizontal, spacing.md)
            .padding(.vertical, spacing.md)
            .background(colors.background)
            .clipShape(RoundedRectangle(cornerRadius: radius.md))
        }
        .buttonStyle(.plain)
    }
}
