import SwiftUI

/// StatDisplayコンポーネントのカタログビュー
struct StatDisplayCatalogView: View {
    @Environment(\.colorPalette) private var colors
    @Environment(\.spacingScale) private var spacing

    var body: some View {
        CatalogPageContainer(title: "StatDisplay") {
            CatalogOverview(description: "数値と単位を表示する統計表示コンポーネント")

            SectionCard(title: "サイズ") {
                VStack(alignment: .leading, spacing: spacing.lg) {
                    LabeledVariant(label: "Small") { StatDisplay(value: "42.5", unit: "kg", size: .small) }
                    LabeledVariant(label: "Medium") { StatDisplay(value: "42.5", unit: "kg", size: .medium) }
                    LabeledVariant(label: "Large") { StatDisplay(value: "42.5", unit: "kg", size: .large) }
                    LabeledVariant(label: "Extra Large") { StatDisplay(value: "42.5", unit: "kg", size: .extraLarge) }
                }
            }

            SectionCard(title: "カラー") {
                VStack(alignment: .leading, spacing: spacing.md) {
                    StatDisplay(value: "5.43", unit: "kg", size: .large, valueColor: colors.primary)
                    StatDisplay(value: "1,234", unit: "kcal", size: .large, valueColor: colors.secondary)
                    StatDisplay(value: "8.5", unit: "km", size: .large, valueColor: colors.tertiary)
                }
            }

            SectionCard(title: "単位なし") {
                VStack(alignment: .leading, spacing: spacing.md) {
                    StatDisplay(value: "42", size: .medium)
                    StatDisplay(value: "1,234,567", size: .large)
                }
            }

            SectionCard(title: "配置") {
                VStack(spacing: spacing.md) {
                    LabeledVariant(label: "Leading") {
                        StatDisplay(value: "100", unit: "pts", alignment: .leading)
                            .padding(spacing.sm)
                            .background(colors.surfaceVariant.opacity(0.5))
                    }
                    LabeledVariant(label: "Center") {
                        StatDisplay(value: "100", unit: "pts", alignment: .center)
                            .frame(maxWidth: .infinity)
                            .padding(spacing.sm)
                            .background(colors.surfaceVariant.opacity(0.5))
                    }
                }
            }

            SectionCard(title: "実用例") {
                VariantShowcase(title: "ダッシュボード") {
                    HStack(spacing: spacing.xl) {
                        VStack(alignment: .leading, spacing: spacing.xs) {
                            Text("筋肉量").typography(.labelMedium).foregroundStyle(colors.onSurfaceVariant)
                            StatDisplay(value: "5.43", unit: "kg", valueColor: colors.secondary)
                        }
                        VStack(alignment: .leading, spacing: spacing.xs) {
                            Text("消費カロリー").typography(.labelMedium).foregroundStyle(colors.onSurfaceVariant)
                            StatDisplay(value: "1,234", unit: "kcal", valueColor: colors.tertiary)
                        }
                    }
                }
            }

            SectionCard(title: "使用例") {
                CodeExample(code: """
                    StatDisplay(
                        value: "1,234",
                        unit: "steps",
                        size: .large,
                        valueColor: .purple
                    )
                    """)
            }
        }
    }
}

#Preview {
    NavigationStack {
        StatDisplayCatalogView()
            .theme(ThemeProvider())
    }
}
