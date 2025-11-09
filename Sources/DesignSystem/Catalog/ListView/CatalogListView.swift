import SwiftUI

/// カタログのリストビュー
/// iPhoneやiPad Split View時に表示される縦スクロールリスト
struct CatalogListView: View {
    @Environment(\.colorPalette) private var colors
    @Environment(\.spacingScale) private var spacing

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: spacing.xxl) {
                    // カテゴリセクション
                    ForEach(CatalogCategory.allCases) { category in
                        CategorySectionView(category: category)
                    }

                    // 情報セクション
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
