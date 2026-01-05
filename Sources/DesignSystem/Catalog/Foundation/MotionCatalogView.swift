import SwiftUI

/// モーションカタログビュー
struct MotionCatalogView: View {
    @Environment(\.colorPalette) private var colors
    @Environment(\.spacingScale) private var spacing
    @Environment(\.motion) private var motion

    var body: some View {
        CatalogPageContainer(title: "モーション") {
            CatalogOverview(description: "デザインシステム全体で一貫したアニメーションタイミングを提供")

            SectionCard(title: "主な機能") {
                VStack(alignment: .leading, spacing: spacing.sm) {
                    FeatureRow(icon: "accessibility", title: "自動アクセシビリティ対応（WCAG 2.1準拠）")
                    FeatureRow(icon: "chart.line.uptrend.xyaxis", title: "業界標準準拠（Material Design 3, IBM Carbon）")
                    FeatureRow(icon: "swift", title: "SwiftUIネイティブAPI")
                    FeatureRow(icon: "wand.and.stars", title: "10種類の最適化されたタイミング")
                }
            }

            // カテゴリ別デモ
            ForEach(MotionSpec.MotionCategory.allCases, id: \.self) { category in
                categoryDemoSection(category: category)
            }

            SectionCard(title: "仕様表") {
                VStack(spacing: 0) {
                    HStack(spacing: spacing.sm) {
                        Text("名前").frame(minWidth: 70, alignment: .leading)
                        Text("Duration").frame(minWidth: 80, alignment: .leading)
                        Text("Easing").frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .typography(.labelMedium)
                    .foregroundStyle(colors.onSurfaceVariant)
                    .padding(spacing.sm)
                    .background(colors.surfaceVariant.opacity(0.5))

                    ForEach(MotionSpec.all) { spec in
                        VStack(spacing: 0) {
                            HStack(spacing: spacing.sm) {
                                Text(spec.name)
                                    .typography(.bodyMedium)
                                    .foregroundStyle(colors.primary)
                                    .frame(minWidth: 70, alignment: .leading)

                                Text(spec.duration)
                                    .typography(.bodySmall)
                                    .foregroundStyle(colors.onSurface)
                                    .frame(minWidth: 80, alignment: .leading)

                                Text(spec.easing)
                                    .typography(.bodySmall)
                                    .foregroundStyle(colors.onSurfaceVariant)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            .padding(spacing.sm)

                            if spec.id != MotionSpec.all.last?.id {
                                Divider()
                            }
                        }
                    }
                }
            }

            SectionCard(title: "使用例") {
                CodeExample(code: """
                    @Environment(\\.motion) var motion

                    Button("タップ") { }
                        .scaleEffect(isPressed ? 0.98 : 1.0)
                        .animate(motion.tap, value: isPressed)

                    // 複数のアニメーション
                    Chip("フィルター", isSelected: $selected)
                        .animate(motion.toggle, value: selected)

                    // withAnimationでの使用
                    withAnimation(motion.slow) {
                        themeProvider.applyTheme(newTheme)
                    }
                    """)
            }

            SectionCard(title: "ベストプラクティス") {
                VStack(alignment: .leading, spacing: spacing.md) {
                    BestPracticeItem(
                        icon: "checkmark.circle.fill",
                        title: "適切なモーションを選択",
                        description: "タップには tap、状態変化には toggle を使用",
                        isGood: true
                    )
                    Divider()
                    BestPracticeItem(
                        icon: "checkmark.circle.fill",
                        title: ".animate() modifierを使用",
                        description: "Reduce Motion自動対応のため必ず使用",
                        isGood: true
                    )
                    Divider()
                    BestPracticeItem(
                        icon: "xmark.circle.fill",
                        title: "ハードコード値の使用",
                        description: ".animation(.easeInOut(duration: 0.15)) は避ける",
                        isGood: false
                    )
                }
            }
        }
    }

    private func categoryDemoSection(category: MotionSpec.MotionCategory) -> some View {
        let specs = MotionSpec.all.filter { $0.category == category }

        return SectionCard(title: category.rawValue) {
            VStack(alignment: .leading, spacing: spacing.md) {
                Text(category.description)
                    .typography(.bodySmall)
                    .foregroundStyle(colors.onSurfaceVariant)

                AspectGrid(
                    minItemWidth: 160,
                    maxItemWidth: 240,
                    itemAspectRatio: 0.85,
                    spacing: .md
                ) {
                    ForEach(specs) { spec in
                        MotionDemoCard(spec: spec)
                    }
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        MotionCatalogView()
            .theme(ThemeProvider())
    }
}
