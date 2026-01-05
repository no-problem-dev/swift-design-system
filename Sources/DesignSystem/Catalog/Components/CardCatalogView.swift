import SwiftUI

/// カードコンポーネントのカタログビュー
struct CardCatalogView: View {
    @Environment(\.colorPalette) private var colors
    @Environment(\.spacingScale) private var spacing

    var body: some View {
        CatalogPageContainer(title: "Card") {
            CatalogOverview(description: "関連情報をグループ化する汎用コンテナ")

            SectionCard(title: "基本") {
                VariantShowcase(
                    title: "デフォルト設定",
                    description: "Elevation Level 1、パディング 16pt"
                ) {
                    Card {
                        VStack(alignment: .leading, spacing: spacing.sm) {
                            Text("カードタイトル")
                                .typography(.titleMedium)
                            Text("カードの本文テキスト")
                                .typography(.bodyMedium)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
            }

            SectionCard(title: "Elevation") {
                VariantShowcase(
                    title: "深さバリエーション",
                    description: "視覚的な階層を表現"
                ) {
                    VStack(spacing: spacing.md) {
                        ForEach([Elevation.level0, .level1, .level2, .level3, .level4, .level5], id: \.self) { elevation in
                            Card(elevation: elevation) {
                                HStack {
                                    Text("Level \(elevationNumber(elevation))")
                                        .typography(.bodyMedium)
                                    Spacer()
                                    Text("Elevation")
                                        .typography(.labelSmall)
                                        .foregroundStyle(colors.onSurfaceVariant)
                                }
                            }
                        }
                    }
                }
            }

            SectionCard(title: "パディング") {
                VariantShowcase(
                    title: "パディングバリエーション",
                    description: "内容に応じて調整"
                ) {
                    VStack(spacing: spacing.md) {
                        Card(allSides: 8) {
                            Text("Compact (8pt)")
                                .typography(.bodySmall)
                        }
                        Card(allSides: 16) {
                            Text("Default (16pt)")
                                .typography(.bodyMedium)
                        }
                        Card(allSides: 24) {
                            Text("Comfortable (24pt)")
                                .typography(.bodyLarge)
                        }
                    }
                }
            }

            SectionCard(title: "使用例") {
                CodeExample(code: """
                    Card(elevation: .level2) {
                        VStack(alignment: .leading) {
                            Text("タイトル")
                            Text("本文")
                        }
                    }
                    """)
            }
        }
    }

    private func elevationNumber(_ elevation: Elevation) -> Int {
        switch elevation {
        case .level0: return 0
        case .level1: return 1
        case .level2: return 2
        case .level3: return 3
        case .level4: return 4
        case .level5: return 5
        }
    }
}

#Preview {
    NavigationStack {
        CardCatalogView()
            .theme(ThemeProvider())
    }
}
