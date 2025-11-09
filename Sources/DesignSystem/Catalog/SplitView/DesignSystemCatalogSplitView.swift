import SwiftUI

/// デザインシステムカタログのスプリットビュー
/// iPadに最適化された3カラムレイアウトで、デザインシステムの全要素を階層的に表示
public struct DesignSystemCatalogSplitView: View {
    @Environment(ThemeProvider.self) private var themeProvider
    @Environment(\.colorPalette) private var colorPalette
    @Environment(\.spacingScale) private var spacing

    // カラム可視性
    @State private var columnVisibility: NavigationSplitViewVisibility = .all

    // 選択状態
    @State private var selectedCategory: CatalogCategory? = .themes
    @State private var selectedFoundationItem: FoundationItem?
    @State private var selectedComponentItem: ComponentType?
    @State private var selectedPatternItem: PatternItem?

    public init() {}

    public var body: some View {
        NavigationSplitView(columnVisibility: $columnVisibility) {
            // Sidebar: カテゴリ一覧
            CatalogSidebarView(selectedCategory: $selectedCategory)
        } content: {
            // Content: 選択されたカテゴリのアイテムリスト
            CatalogContentView(
                category: selectedCategory,
                selectedFoundationItem: $selectedFoundationItem,
                selectedComponentItem: $selectedComponentItem,
                selectedPatternItem: $selectedPatternItem
            )
        } detail: {
            // Detail: 選択されたアイテムの詳細
            CatalogDetailView(
                category: selectedCategory,
                foundationItem: selectedFoundationItem,
                componentItem: selectedComponentItem,
                patternItem: selectedPatternItem
            )
        }
        .navigationSplitViewStyle(.balanced)
        .onChange(of: selectedCategory) { _, newCategory in
            // カテゴリが変わったら選択をリセット
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
