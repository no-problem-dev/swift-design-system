import SwiftUI

/// The vertically scrolling catalog list shown on iPhone and in the iPad split view.
struct CatalogListView: View {
    @Environment(\.colorPalette) private var colors
    @Environment(\.spacingScale) private var spacing

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: spacing.xxl) {
                    // Category sections
                    ForEach(CatalogCategory.allCases) { category in
                        CategorySectionView(category: category)
                    }

                    // Information section
                    InfoSectionView()
                }
                .padding(.top, spacing.lg)
                .padding(.bottom, spacing.xl)
            }
            .background(colors.background)
            .navigationTitle("デザインシステムカタログ")
            #if os(iOS)
            .navigationBarTitleDisplayMode(.large)
            #endif
        }
    }
}

#Preview {
    CatalogListView()
        .theme(ThemeProvider())
}
