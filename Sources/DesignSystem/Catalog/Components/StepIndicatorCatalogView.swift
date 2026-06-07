import SwiftUI

/// StepIndicatorコンポーネントのカタログビュー
struct StepIndicatorCatalogView: View {
    @Environment(\.colorPalette) private var colors
    @Environment(\.spacingScale) private var spacing

    @State private var demoIndex: Int? = 0

    var body: some View {
        CatalogPageContainer(title: "StepIndicator") {
            CatalogOverview(description: "一方向に進む N ステップの現在位置をドット列で表すミニインジケーター。フェーズ進行（計画 → 作業 → 組み上げ）などに使用。")

            SectionCard(title: "状態") {
                VStack(alignment: .leading, spacing: spacing.lg) {
                    VariantShowcase(title: "進行中", description: "現在 = primary、通過 = 薄い primary、未来 = outlineVariant") {
                        VStack(alignment: .leading, spacing: spacing.md) {
                            StepIndicator(stepCount: 3, currentIndex: 0)
                            StepIndicator(stepCount: 3, currentIndex: 1)
                            StepIndicator(stepCount: 3, currentIndex: 2)
                        }
                    }

                    Divider()

                    VariantShowcase(title: "完了（currentIndex: nil）") {
                        StepIndicator(stepCount: 3, currentIndex: nil)
                    }

                    Divider()

                    VariantShowcase(title: "ステップ数・ドット径のバリエーション") {
                        VStack(alignment: .leading, spacing: spacing.md) {
                            StepIndicator(stepCount: 5, currentIndex: 2)
                            StepIndicator(stepCount: 4, currentIndex: 1, dotDiameter: 8)
                        }
                    }
                }
            }

            SectionCard(title: "インタラクティブデモ") {
                VStack(spacing: spacing.lg) {
                    StepIndicator(stepCount: 4, currentIndex: demoIndex, dotDiameter: 8)
                    Button("次のステップへ") {
                        switch demoIndex {
                        case .some(let index) where index < 3: demoIndex = index + 1
                        case .some: demoIndex = nil
                        case nil: demoIndex = 0
                        }
                    }
                    .buttonStyle(.secondary)
                }
                .frame(maxWidth: .infinity)
            }
        }
    }
}

#Preview {
    NavigationStack {
        StepIndicatorCatalogView()
            .theme(ThemeProvider())
    }
}
