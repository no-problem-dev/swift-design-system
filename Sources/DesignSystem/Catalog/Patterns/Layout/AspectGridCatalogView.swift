import SwiftUI

/// AspectGridパターンのカタログビュー
struct AspectGridCatalogView: View {
    @Environment(\.colorPalette) private var colors
    @Environment(\.spacingScale) private var spacing
    @Environment(\.radiusScale) private var radius

    var body: some View {
        CatalogPageContainer(title: "AspectGrid") {
            CatalogOverview(description: "統一されたアスペクト比を適用するグリッドレイアウトパターン")

            SectionCard(title: "1:1 - Square") {
                VStack(alignment: .leading, spacing: spacing.sm) {
                    Text("商品サムネイル、プロフィール画像に最適")
                        .typography(.bodySmall)
                        .foregroundStyle(colors.onSurfaceVariant)

                    AspectGrid(
                        minItemWidth: 80,
                        maxItemWidth: 100,
                        itemAspectRatio: 1,
                        spacing: .sm
                    ) {
                        ForEach(0..<6, id: \.self) { index in
                            RoundedRectangle(cornerRadius: radius.md)
                                .fill(colors.primary.opacity(0.3))
                                .overlay {
                                    Text("\(index + 1)")
                                        .typography(.bodySmall)
                                        .foregroundStyle(colors.onPrimary)
                                }
                        }
                    }
                }
            }

            SectionCard(title: "3:4 - Photos") {
                VStack(alignment: .leading, spacing: spacing.sm) {
                    Text("写真、ポートレートに最適")
                        .typography(.bodySmall)
                        .foregroundStyle(colors.onSurfaceVariant)

                    AspectGrid(
                        minItemWidth: 80,
                        maxItemWidth: 100,
                        itemAspectRatio: 3/4,
                        spacing: .sm
                    ) {
                        ForEach(0..<6, id: \.self) { index in
                            RoundedRectangle(cornerRadius: radius.md)
                                .fill(colors.secondary.opacity(0.3))
                                .overlay {
                                    Text("\(index + 1)")
                                        .typography(.bodySmall)
                                        .foregroundStyle(colors.onSecondary)
                                }
                        }
                    }
                }
            }

            SectionCard(title: "16:9 - Videos") {
                VStack(alignment: .leading, spacing: spacing.sm) {
                    Text("動画サムネイル、ワイドコンテンツに最適")
                        .typography(.bodySmall)
                        .foregroundStyle(colors.onSurfaceVariant)

                    AspectGrid(
                        minItemWidth: 120,
                        maxItemWidth: 160,
                        itemAspectRatio: 16/9,
                        spacing: .md
                    ) {
                        ForEach(0..<4, id: \.self) { index in
                            RoundedRectangle(cornerRadius: radius.md)
                                .fill(colors.tertiary.opacity(0.3))
                                .overlay {
                                    Text("\(index + 1)")
                                        .typography(.bodySmall)
                                        .foregroundStyle(colors.onTertiary)
                                }
                        }
                    }
                }
            }

            SectionCard(title: "間隔バリエーション") {
                VStack(alignment: .leading, spacing: spacing.lg) {
                    ForEach([
                        (GridSpacing.xs, "Extra Small (8pt)"),
                        (GridSpacing.md, "Medium (16pt)"),
                        (GridSpacing.xl, "Extra Large (24pt)")
                    ], id: \.0.rawValue) { item in
                        VStack(alignment: .leading, spacing: spacing.sm) {
                            Text(item.1)
                                .typography(.labelLarge)
                                .foregroundStyle(colors.primary)

                            AspectGrid(
                                minItemWidth: 60,
                                maxItemWidth: 80,
                                itemAspectRatio: 1,
                                spacing: item.0
                            ) {
                                ForEach(0..<6, id: \.self) { index in
                                    Circle()
                                        .fill(colors.primary.opacity(0.3))
                                        .overlay {
                                            Text("\(index + 1)")
                                                .typography(.bodySmall)
                                                .foregroundStyle(colors.onPrimary)
                                        }
                                }
                            }
                        }
                    }
                }
            }

            SectionCard(title: "使用例") {
                CodeExample(code: """
                    AspectGrid(
                        minItemWidth: 140,
                        maxItemWidth: 180,
                        itemAspectRatio: 1,  // 正方形
                        spacing: .md
                    ) {
                        ForEach(products) { product in
                            ProductCardView(product)
                        }
                    }
                    """)
            }

            SectionCard(title: "ベストプラクティス") {
                VStack(alignment: .leading, spacing: spacing.md) {
                    BestPracticeItem(
                        icon: "checkmark.circle.fill",
                        title: "統一されたアスペクト比",
                        description: "すべてのアイテムに同じアスペクト比を適用",
                        isGood: true
                    )
                    Divider()
                    BestPracticeItem(
                        icon: "checkmark.circle.fill",
                        title: "maxItemWidthを設定",
                        description: "大画面でアイテムが不自然に大きくなるのを防ぐ",
                        isGood: true
                    )
                    Divider()
                    BestPracticeItem(
                        icon: "checkmark.circle.fill",
                        title: "適切な間隔の選択",
                        description: "コンテンツに応じてspacing(.xs〜.xl)を選択",
                        isGood: true
                    )
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        AspectGridCatalogView()
            .theme(ThemeProvider())
    }
}
