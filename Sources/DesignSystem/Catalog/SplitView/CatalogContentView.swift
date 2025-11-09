import SwiftUI

/// カタログのコンテンツビュー
/// NavigationSplitViewの中央カラムで、選択されたカテゴリのアイテム一覧を表示
struct CatalogContentView: View {
    @Environment(\.colorPalette) private var colors
    @Environment(\.spacingScale) private var spacing
    @Environment(\.radiusScale) private var radius

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
                        HStack(spacing: spacing.md) {
                            Image(systemName: item.icon)
                                .font(.title3)
                                .foregroundStyle(colors.primary)
                                .frame(width: 32)

                            VStack(alignment: .leading, spacing: 2) {
                                Text(item.rawValue)
                                    .typography(.bodyLarge)
                                    .foregroundStyle(colors.onSurface)

                                Text(item.description)
                                    .typography(.bodySmall)
                                    .foregroundStyle(colors.onSurfaceVariant)
                            }

                            Spacer()

                            if selectedFoundationItem == item {
                                Image(systemName: "checkmark")
                                    .typography(.labelMedium)
                                    .foregroundStyle(colors.primary)
                            } else {
                                Image(systemName: "chevron.right")
                                    .typography(.labelMedium)
                                    .foregroundStyle(colors.onSurfaceVariant)
                            }
                        }
                        .padding(.horizontal, spacing.md)
                        .padding(.vertical, spacing.md)
                        .background(selectedFoundationItem == item ? colors.primaryContainer : colors.surface)
                        .clipShape(RoundedRectangle(cornerRadius: radius.md))
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
                        HStack(spacing: spacing.md) {
                            Image(systemName: component.icon)
                                .font(.title3)
                                .foregroundStyle(colors.primary)
                                .frame(width: 32)

                            VStack(alignment: .leading, spacing: 2) {
                                Text(component.rawValue)
                                    .typography(.bodyLarge)
                                    .foregroundStyle(colors.onSurface)

                                Text(component.description)
                                    .typography(.bodySmall)
                                    .foregroundStyle(colors.onSurfaceVariant)
                            }

                            Spacer()

                            if selectedComponentItem == component {
                                Image(systemName: "checkmark")
                                    .typography(.labelMedium)
                                    .foregroundStyle(colors.primary)
                            } else {
                                Image(systemName: "chevron.right")
                                    .typography(.labelMedium)
                                    .foregroundStyle(colors.onSurfaceVariant)
                            }
                        }
                        .padding(.horizontal, spacing.md)
                        .padding(.vertical, spacing.md)
                        .background(selectedComponentItem == component ? colors.primaryContainer : colors.surface)
                        .clipShape(RoundedRectangle(cornerRadius: radius.md))
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
                        HStack(spacing: spacing.md) {
                            Image(systemName: pattern.icon)
                                .font(.title3)
                                .foregroundStyle(colors.primary)
                                .frame(width: 32)

                            VStack(alignment: .leading, spacing: 2) {
                                Text(pattern.rawValue)
                                    .typography(.bodyLarge)
                                    .foregroundStyle(colors.onSurface)

                                Text(pattern.description)
                                    .typography(.bodySmall)
                                    .foregroundStyle(colors.onSurfaceVariant)
                            }

                            Spacer()

                            if selectedPatternItem == pattern {
                                Image(systemName: "checkmark")
                                    .typography(.labelMedium)
                                    .foregroundStyle(colors.primary)
                            } else {
                                Image(systemName: "chevron.right")
                                    .typography(.labelMedium)
                                    .foregroundStyle(colors.onSurfaceVariant)
                            }
                        }
                        .padding(.horizontal, spacing.md)
                        .padding(.vertical, spacing.md)
                        .background(selectedPatternItem == pattern ? colors.primaryContainer : colors.surface)
                        .clipShape(RoundedRectangle(cornerRadius: radius.md))
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
