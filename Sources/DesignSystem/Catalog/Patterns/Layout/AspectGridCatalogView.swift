import SwiftUI

/// AspectGridパターンのカタログビュー
/// レイアウトパターンとしてのAspectGridの使い方を詳しく説明
struct AspectGridCatalogView: View {
    @Environment(\.colorPalette) private var colorPalette
    @Environment(\.spacingScale) private var spacing

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: spacing.xl) {
                // 概要
                VStack(alignment: .leading, spacing: spacing.md) {
                    Text("AspectGridは、すべてのアイテムに統一されたアスペクト比を適用するグリッドレイアウトパターンです")
                        .typography(.bodyMedium)
                        .foregroundStyle(colorPalette.onSurfaceVariant)

                    Text("写真ギャラリー、商品一覧、メディアライブラリなど、一貫したアスペクト比が求められるコンテンツの表示に最適です")
                        .typography(.bodySmall)
                        .foregroundStyle(colorPalette.onSurfaceVariant)
                }
                .padding(.horizontal, spacing.lg)
                .padding(.top, spacing.lg)

                // 構成
                SectionCard(title: "構成") {
                    VStack(alignment: .leading, spacing: spacing.md) {
                        SpecItem(
                            label: "ベース",
                            value: "LazyVGrid",
                            description: "遅延読み込みによる効率的なレンダリング"
                        )

                        Divider()

                        SpecItem(
                            label: "アスペクト比制御",
                            value: ".aspectRatio() modifier",
                            description: "すべてのアイテムに統一された比率を適用"
                        )

                        Divider()

                        SpecItem(
                            label: "幅制御",
                            value: "GridItem.adaptive(minimum:maximum:)",
                            description: "画面サイズに応じた自動調整"
                        )

                        Divider()

                        SpecItem(
                            label: "間隔",
                            value: "GridSpacing token",
                            description: "xs, sm, md, lg, xl (8-24pt)"
                        )
                    }
                }

                // 基本的な使用例
                SectionCard(title: "基本的な使用例") {
                    VStack(alignment: .leading, spacing: spacing.md) {
                        Text("商品一覧グリッド（1:1アスペクト比）")
                            .typography(.bodySmall)
                            .foregroundStyle(colorPalette.onSurfaceVariant)

                        AspectGrid(
                            minItemWidth: 100,
                            maxItemWidth: 140,
                            itemAspectRatio: 1,
                            spacing: .md
                        ) {
                            ForEach(0..<6, id: \.self) { index in
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.blue.opacity(0.3))
                                    .overlay {
                                        Text("\(index + 1)")
                                            .typography(.bodyMedium)
                                            .foregroundStyle(.white)
                                    }
                            }
                        }
                    }
                }

                // アスペクト比バリエーション
                SectionCard(title: "アスペクト比バリエーション") {
                    VStack(alignment: .leading, spacing: spacing.lg) {
                        // 1:1 - Square
                        VStack(alignment: .leading, spacing: spacing.sm) {
                            Text("1:1 - Square")
                                .typography(.labelLarge)
                                .foregroundStyle(colorPalette.primary)
                            Text("商品サムネイル、プロフィール画像、アイコンに最適")
                                .typography(.bodySmall)
                                .foregroundStyle(colorPalette.onSurfaceVariant)

                            AspectGrid(
                                minItemWidth: 80,
                                maxItemWidth: 100,
                                itemAspectRatio: 1,
                                spacing: .sm
                            ) {
                                ForEach(0..<6, id: \.self) { index in
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(Color.blue.opacity(0.3))
                                        .overlay {
                                            Text("\(index + 1)")
                                                .typography(.bodySmall)
                                                .foregroundStyle(.white)
                                        }
                                }
                            }
                        }

                        Divider()

                        // 3:4 - Photos
                        VStack(alignment: .leading, spacing: spacing.sm) {
                            Text("3:4 - Photos")
                                .typography(.labelLarge)
                                .foregroundStyle(colorPalette.primary)
                            Text("写真、ポートレートに最適")
                                .typography(.bodySmall)
                                .foregroundStyle(colorPalette.onSurfaceVariant)

                            AspectGrid(
                                minItemWidth: 80,
                                maxItemWidth: 100,
                                itemAspectRatio: 3/4,
                                spacing: .sm
                            ) {
                                ForEach(0..<6, id: \.self) { index in
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(Color.purple.opacity(0.3))
                                        .overlay {
                                            Text("\(index + 1)")
                                                .typography(.bodySmall)
                                                .foregroundStyle(.white)
                                        }
                                }
                            }
                        }

                        Divider()

                        // 16:9 - Videos
                        VStack(alignment: .leading, spacing: spacing.sm) {
                            Text("16:9 - Videos")
                                .typography(.labelLarge)
                                .foregroundStyle(colorPalette.primary)
                            Text("動画サムネイル、ワイドコンテンツに最適")
                                .typography(.bodySmall)
                                .foregroundStyle(colorPalette.onSurfaceVariant)

                            AspectGrid(
                                minItemWidth: 120,
                                maxItemWidth: 160,
                                itemAspectRatio: 16/9,
                                spacing: .md
                            ) {
                                ForEach(0..<4, id: \.self) { index in
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(Color.orange.opacity(0.3))
                                        .overlay {
                                            Text("\(index + 1)")
                                                .typography(.bodySmall)
                                                .foregroundStyle(.white)
                                        }
                                }
                            }
                        }
                    }
                }

                // 間隔バリエーション
                SectionCard(title: "間隔バリエーション") {
                    VStack(alignment: .leading, spacing: spacing.lg) {
                        ForEach([
                            (GridSpacing.xs, "Extra Small (8pt)", "密集したレイアウト"),
                            (GridSpacing.sm, "Small (12pt)", "コンパクトなレイアウト"),
                            (GridSpacing.md, "Medium (16pt)", "標準的なレイアウト（デフォルト）"),
                            (GridSpacing.lg, "Large (20pt)", "ゆとりのあるレイアウト"),
                            (GridSpacing.xl, "Extra Large (24pt)", "プレミアムなレイアウト")
                        ], id: \.0.rawValue) { item in
                            VStack(alignment: .leading, spacing: spacing.sm) {
                                Text(item.1)
                                    .typography(.labelLarge)
                                    .foregroundStyle(colorPalette.primary)
                                Text(item.2)
                                    .typography(.bodySmall)
                                    .foregroundStyle(colorPalette.onSurfaceVariant)

                                AspectGrid(
                                    minItemWidth: 60,
                                    maxItemWidth: 80,
                                    itemAspectRatio: 1,
                                    spacing: item.0
                                ) {
                                    ForEach(0..<6, id: \.self) { index in
                                        Circle()
                                            .fill(Color.blue.opacity(0.3))
                                            .overlay {
                                                Text("\(index + 1)")
                                                    .typography(.bodySmall)
                                                    .foregroundStyle(.white)
                                            }
                                    }
                                }

                                if item.0 != .xl {
                                    Divider()
                                }
                            }
                        }
                    }
                }

                // コード例
                SectionCard(title: "コード例") {
                    VStack(alignment: .leading, spacing: spacing.sm) {
                        Text("SwiftUIでの使用方法")
                            .typography(.titleSmall)

                        Text("""
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
                        .typography(.bodySmall)
                        .fontDesign(.monospaced)
                        .padding()
                        .background(colorPalette.surfaceVariant.opacity(0.5))
                        .cornerRadius(8)
                    }
                }

                // デザイン仕様
                SectionCard(title: "デザイン仕様") {
                    VStack(alignment: .leading, spacing: spacing.md) {
                        VStack(alignment: .leading, spacing: spacing.xs) {
                            Text("パラメータ")
                                .typography(.labelLarge)
                                .foregroundStyle(colorPalette.primary)

                            SpecItem(label: "minItemWidth", value: "CGFloat", description: "アイテムの最小幅（通常80-160pt）")
                            SpecItem(label: "maxItemWidth", value: "CGFloat", description: "アイテムの最大幅（通常200-300pt）")
                            SpecItem(label: "itemAspectRatio", value: "CGFloat（必須）", description: "アイテムのアスペクト比（幅/高さ）")
                            SpecItem(label: "spacing", value: "GridSpacing", description: "デフォルト: .md (16pt)")
                            SpecItem(label: "alignment", value: "HorizontalAlignment", description: "デフォルト: .center")
                        }

                        Divider()

                        VStack(alignment: .leading, spacing: spacing.xs) {
                            Text("推奨アスペクト比")
                                .typography(.labelLarge)
                                .foregroundStyle(colorPalette.primary)

                            SpecItem(label: "1:1 (1.0)", value: "商品サムネイル、プロフィール画像、アイコン")
                            SpecItem(label: "3:4 (0.75)", value: "写真、ポートレート")
                            SpecItem(label: "16:9 (1.78)", value: "動画サムネイル、ワイドコンテンツ")
                        }

                        Divider()

                        VStack(alignment: .leading, spacing: spacing.xs) {
                            Text("デザインガイドライン")
                                .typography(.labelLarge)
                                .foregroundStyle(colorPalette.primary)

                            SpecItem(label: "Material Design 3", value: "16-24dp gutters")
                            SpecItem(label: "Fluent 2", value: "8-16px gutters")
                            SpecItem(label: "Apple HIG", value: "8-20pt spacing")
                        }
                    }
                }

                // 使用ガイド
                SectionCard(title: "使用ガイド") {
                    VStack(alignment: .leading, spacing: spacing.md) {
                        BestPracticeItem(
                            icon: "checkmark.circle.fill",
                            title: "統一されたアスペクト比",
                            description: "すべてのアイテムに同じアスペクト比を適用することで、美しく整理されたグリッドを実現",
                            isGood: true
                        )

                        BestPracticeItem(
                            icon: "checkmark.circle.fill",
                            title: "大画面での最適化",
                            description: "maxItemWidthを設定してiPad等の大画面でアイテムが不自然に大きくなるのを防ぐ",
                            isGood: true
                        )

                        BestPracticeItem(
                            icon: "checkmark.circle.fill",
                            title: "適切な間隔の選択",
                            description: "コンテンツの種類に応じてspacing(.xs〜.xl)を選択し、視認性を向上",
                            isGood: true
                        )
                    }
                }
            }
            .padding(.bottom, spacing.xl)
        }
        .background(colorPalette.background)
        .navigationTitle("AspectGrid")
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
    }
}

#Preview {
    NavigationStack {
        AspectGridCatalogView()
            .theme(ThemeProvider())
    }
}
