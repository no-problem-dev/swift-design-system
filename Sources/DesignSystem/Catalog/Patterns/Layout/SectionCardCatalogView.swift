import SwiftUI

/// SectionCardパターンのカタログビュー
struct SectionCardCatalogView: View {
    @Environment(\.colorPalette) private var colors
    @Environment(\.spacingScale) private var spacing

    var body: some View {
        CatalogPageContainer(title: "SectionCard") {
            CatalogOverview(description: "タイトル付きのセクションを作成するレイアウトパターン")

            SectionCard(title: "構成") {
                VStack(alignment: .leading, spacing: spacing.md) {
                    SpecItem(
                        label: "タイトル",
                        value: "Typography.titleMedium"
                    )
                    Divider()
                    SpecItem(
                        label: "コンテンツ",
                        value: "Cardコンポーネント"
                    )
                    Divider()
                    SpecItem(
                        label: "スペーシング",
                        value: "spacing.md (12pt)"
                    )
                    Divider()
                    SpecItem(
                        label: "パディング",
                        value: "spacing.lg (16pt)"
                    )
                }
            }

            SectionCard(title: "基本的な使用例") {
                SectionCard(title: "サンプルセクション") {
                    VStack(alignment: .leading, spacing: spacing.sm) {
                        Text("ここにコンテンツが入ります")
                            .typography(.bodyMedium)

                        Text("自動的にCardコンポーネントでラップ")
                            .typography(.bodySmall)
                            .foregroundStyle(colors.onSurfaceVariant)
                    }
                }
            }

            SectionCard(title: "複雑なコンテンツ") {
                SectionCard(title: "機能リスト") {
                    VStack(alignment: .leading, spacing: spacing.sm) {
                        FeatureRow(icon: "checkmark.circle.fill", title: "自動パディング管理")
                        FeatureRow(icon: "checkmark.circle.fill", title: "Cardコンポーネント統合")
                        FeatureRow(icon: "checkmark.circle.fill", title: "Spacing tokens対応")
                        FeatureRow(icon: "checkmark.circle.fill", title: "階層的な情報構造")
                    }
                }
            }

            SectionCard(title: "使用例") {
                CodeExample(code: """
                    SectionCard(title: "セクション名") {
                        VStack(alignment: .leading, spacing: spacing.md) {
                            Text("コンテンツ")
                            Text("複数の要素を配置可能")
                        }
                    }
                    """)
            }

            SectionCard(title: "ベストプラクティス") {
                VStack(alignment: .leading, spacing: spacing.md) {
                    BestPracticeItem(
                        icon: "checkmark.circle.fill",
                        title: "関連情報のグループ化",
                        description: "設定画面や詳細画面で、関連項目をセクションごとにまとめる",
                        isGood: true
                    )
                    Divider()
                    BestPracticeItem(
                        icon: "checkmark.circle.fill",
                        title: "階層的な情報構造",
                        description: "複数のSectionCardで情報を段階的に整理",
                        isGood: true
                    )
                    Divider()
                    BestPracticeItem(
                        icon: "xmark.circle.fill",
                        title: "過度なネストは避ける",
                        description: "SectionCard内に何重にもネストすると読みづらい",
                        isGood: false
                    )
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        SectionCardCatalogView()
            .theme(ThemeProvider())
    }
}
