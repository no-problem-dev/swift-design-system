import SwiftUI

/// カタログのカテゴリセクションビュー
struct CategorySectionView: View {
    @Environment(\.colorPalette) private var colors
    @Environment(\.spacingScale) private var spacing

    let category: CatalogCategory

    var body: some View {
        VStack(alignment: .leading, spacing: spacing.md) {
            // カテゴリヘッダー
            HStack(spacing: spacing.sm) {
                Image(systemName: category.icon)
                    .font(.title3)
                    .foregroundStyle(colors.primary)

                Text(category.rawValue)
                    .typography(.titleMedium)
                    .foregroundStyle(colors.onSurface)
            }

            Text(category.description)
                .typography(.bodySmall)
                .foregroundStyle(colors.onSurfaceVariant)

            // アイテムリスト
            VStack(spacing: spacing.sm) {
                ForEach(category.items) { item in
                    CategoryItemRow(category: category, item: item)
                }
            }
        }
        .padding(spacing.lg)
        .background(colors.surface)
        .shadow(color: .black.opacity(0.03), radius: 4, y: 2)
    }
}
