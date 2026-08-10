import SwiftUI

/// The middle column of the navigation split view, listing the items in the selected category.
struct CatalogContentView: View {
    @Environment(\.colorPalette) private var colors
    @Environment(\.spacingScale) private var spacing

    let category: CatalogCategory?
    @Binding var selectedFoundationItem: FoundationItem?
    @Binding var selectedComponentItem: ComponentType?
    @Binding var selectedPatternItem: PatternItem?

    var body: some View {
        Group {
            if let category {
                switch category {
                case .themes:
                    themeContentView
                case .foundations:
                    foundationContentView
                case .components:
                    componentContentView
                case .patterns:
                    patternContentView
                }
            } else {
                emptyStateView
            }
        }
        .navigationTitle(category?.rawValue ?? "")
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
    }

    private var themeContentView: some View {
        ContentUnavailableView {
            Label("テーマギャラリー", systemImage: "paintpalette.fill")
        } description: {
            Text("詳細エリアにテーマギャラリーが表示されます")
        }
        .background(colors.background)
    }

    private var foundationContentView: some View {
        ScrollView {
            VStack(spacing: spacing.sm) {
                ForEach(FoundationItem.allCases) { item in
                    Button {
                        selectedFoundationItem = item
                    } label: {
                        CatalogItemRowContent(
                            icon: item.icon,
                            title: item.rawValue,
                            description: item.description,
                            isSelected: selectedFoundationItem == item,
                            showChevron: true
                        )
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(spacing.lg)
        }
        .background(colors.background)
    }

    private var componentContentView: some View {
        ScrollView {
            VStack(spacing: spacing.sm) {
                ForEach(ComponentType.allCases) { component in
                    Button {
                        selectedComponentItem = component
                    } label: {
                        CatalogItemRowContent(
                            icon: component.icon,
                            title: component.rawValue,
                            description: component.description,
                            isSelected: selectedComponentItem == component,
                            showChevron: true
                        )
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(spacing.lg)
        }
        .background(colors.background)
    }

    private var patternContentView: some View {
        ScrollView {
            VStack(spacing: spacing.sm) {
                ForEach(PatternItem.allCases) { pattern in
                    Button {
                        selectedPatternItem = pattern
                    } label: {
                        CatalogItemRowContent(
                            icon: pattern.icon,
                            title: pattern.rawValue,
                            description: pattern.description,
                            isSelected: selectedPatternItem == pattern,
                            showChevron: true
                        )
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(spacing.lg)
        }
        .background(colors.background)
    }

    private var emptyStateView: some View {
        ContentUnavailableView {
            Label("カテゴリを選択", systemImage: "sidebar.left")
        } description: {
            Text("サイドバーからカテゴリを選択してください")
        }
        .background(colors.background)
    }
}

#Preview("Foundations") {
    @Previewable @State var selectedFoundationItem: FoundationItem?
    @Previewable @State var selectedComponentItem: ComponentType?
    @Previewable @State var selectedPatternItem: PatternItem?

    NavigationSplitView {
        Text("Sidebar")
    } content: {
        CatalogContentView(
            category: .foundations,
            selectedFoundationItem: $selectedFoundationItem,
            selectedComponentItem: $selectedComponentItem,
            selectedPatternItem: $selectedPatternItem
        )
    } detail: {
        Text("Detail")
    }
    .theme(ThemeProvider())
}

#Preview("Empty") {
    @Previewable @State var selectedFoundationItem: FoundationItem?
    @Previewable @State var selectedComponentItem: ComponentType?
    @Previewable @State var selectedPatternItem: PatternItem?

    NavigationSplitView {
        Text("Sidebar")
    } content: {
        CatalogContentView(
            category: nil,
            selectedFoundationItem: $selectedFoundationItem,
            selectedComponentItem: $selectedComponentItem,
            selectedPatternItem: $selectedPatternItem
        )
    } detail: {
        Text("Detail")
    }
    .theme(ThemeProvider())
}
