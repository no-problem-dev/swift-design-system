import SwiftUI

/// カタログのサイドバービュー
/// NavigationSplitViewの最初のカラムで、カテゴリ一覧を表示
struct CatalogSidebarView: View {
    @Environment(\.colorPalette) private var colors
    @Environment(\.spacingScale) private var spacing
    @Environment(\.radiusScale) private var radius

    @Binding var selectedCategory: CatalogCategory?

    var body: some View {
        ScrollView {
            VStack(spacing: spacing.xl) {
                // ヘッダー
                VStack(spacing: spacing.sm) {
                    Image(systemName: "book.fill")
                        .font(.system(size: 32))
                        .foregroundStyle(colors.primary)

                    Text("デザインシステム")
                        .typography(.titleLarge)
                        .foregroundStyle(colors.onSurface)

                    Text("カタログ")
                        .typography(.bodySmall)
                        .foregroundStyle(colors.onSurfaceVariant)
                }
                .frame(maxWidth: .infinity)
                .padding(.top, spacing.lg)

                // カテゴリリスト
                VStack(spacing: spacing.sm) {
                    ForEach(CatalogCategory.allCases) { category in
                        Button {
                            selectedCategory = category
                        } label: {
                            HStack(spacing: spacing.md) {
                                Image(systemName: category.icon)
                                    .font(.title3)
                                    .foregroundStyle(colors.primary)
                                    .frame(width: 32)

                                VStack(alignment: .leading, spacing: 2) {
                                    Text(category.rawValue)
                                        .typography(.bodyLarge)
                                        .foregroundStyle(colors.onSurface)

                                    Text(category.description)
                                        .typography(.bodySmall)
                                        .foregroundStyle(colors.onSurfaceVariant)
                                }

                                Spacer()

                                if selectedCategory == category {
                                    Image(systemName: "checkmark")
                                        .typography(.labelMedium)
                                        .foregroundStyle(colors.primary)
                                }
                            }
                            .padding(.horizontal, spacing.md)
                            .padding(.vertical, spacing.md)
                            .background(selectedCategory == category ? colors.primaryContainer : colors.surface)
                            .clipShape(RoundedRectangle(cornerRadius: radius.md))
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, spacing.lg)
            }
            .padding(.bottom, spacing.xl)
        }
        .background(colors.background)
        .navigationTitle("カテゴリ")
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
    }
}

#Preview {
    @Previewable @State var selectedCategory: CatalogCategory? = .themes

    NavigationSplitView {
        CatalogSidebarView(selectedCategory: $selectedCategory)
    } detail: {
        Text("Detail")
    }
    .theme(ThemeProvider())
}
