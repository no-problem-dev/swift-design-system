import SwiftUI

/// モーションカタログビュー
///
/// アニメーションタイミングとモーションシステムの包括的なカタログ
struct MotionCatalogView: View {
    @Environment(\.colorPalette) private var colorPalette
    @Environment(\.spacingScale) private var spacing
    @Environment(\.motion) private var motion

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: spacing.xl) {
                // 1. 概要セクション
                overviewSection

                // 2. インタラクティブデモセクション
                interactiveDemosSection

                // 3. 仕様表セクション
                specificationsSection

                // 4. 使用例セクション
                usageExamplesSection

                // 5. アクセシビリティセクション
                accessibilitySection

                // 6. ベストプラクティスセクション
                bestPracticesSection
            }
            .padding(.bottom, spacing.xl)
        }
        .background(colorPalette.background)
        .navigationTitle("モーション")
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
    }

    // MARK: - 1. 概要セクション

    private var overviewSection: some View {
        VStack(alignment: .leading, spacing: spacing.lg) {
            VStack(alignment: .leading, spacing: spacing.sm) {
                Text("Motionシステム")
                    .typography(.headlineMedium)
                    .foregroundStyle(colorPalette.onSurface)

                Text("デザインシステム全体で一貫したアニメーションタイミングを提供します。Material Design 3、IBM Carbon Design System、Apple Human Interface Guidelinesの業界標準に基づいた、最適化されたアニメーション値を提供します。")
                    .typography(.bodyMedium)
                    .foregroundStyle(colorPalette.onSurfaceVariant)
            }
            .padding(.horizontal, spacing.lg)
            .padding(.top, spacing.lg)

            // 主な機能
            VStack(alignment: .leading, spacing: spacing.md) {
                Text("主な機能")
                    .typography(.titleMedium)
                    .foregroundStyle(colorPalette.onSurface)

                VStack(alignment: .leading, spacing: spacing.sm) {
                    FeatureRow(icon: "accessibility", title: "自動アクセシビリティ対応（WCAG 2.1準拠）")
                    FeatureRow(icon: "chart.line.uptrend.xyaxis", title: "業界標準準拠（Material Design 3, IBM Carbon）")
                    FeatureRow(icon: "swift", title: "SwiftUIネイティブAPI")
                    FeatureRow(icon: "wand.and.stars", title: "10種類の最適化されたタイミング")
                }
            }
            .padding(.horizontal, spacing.lg)
        }
    }

    // MARK: - 2. インタラクティブデモセクション

    private var interactiveDemosSection: some View {
        VStack(alignment: .leading, spacing: spacing.lg) {
            Text("インタラクティブデモ")
                .typography(.titleLarge)
                .foregroundStyle(colorPalette.onSurface)
                .padding(.horizontal, spacing.lg)

            Text("各モーションの動きを実際に体験できます。「アニメーション実行」ボタンをタップして違いを確認してください。")
                .typography(.bodyMedium)
                .foregroundStyle(colorPalette.onSurfaceVariant)
                .padding(.horizontal, spacing.lg)

            // カテゴリ別デモ
            ForEach(MotionSpec.MotionCategory.allCases, id: \.self) { category in
                categoryDemoSection(category: category)
            }
        }
    }

    private func categoryDemoSection(category: MotionSpec.MotionCategory) -> some View {
        let specs = MotionSpec.all.filter { $0.category == category }

        return VStack(alignment: .leading, spacing: spacing.md) {
            HStack(spacing: spacing.sm) {
                Image(systemName: category.icon)
                    .font(.title3)
                    .foregroundStyle(colorPalette.primary)

                VStack(alignment: .leading, spacing: 2) {
                    Text(category.rawValue)
                        .typography(.titleMedium)
                        .foregroundStyle(colorPalette.onSurface)

                    Text(category.description)
                        .typography(.bodySmall)
                        .foregroundStyle(colorPalette.onSurfaceVariant)
                }

                Spacer()
            }
            .padding(.horizontal, spacing.lg)

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
            .padding(.horizontal, spacing.lg)
        }
    }

    // MARK: - 3. 仕様表セクション

    private var specificationsSection: some View {
        VStack(alignment: .leading, spacing: spacing.lg) {
            Text("仕様表")
                .typography(.titleLarge)
                .foregroundStyle(colorPalette.onSurface)
                .padding(.horizontal, spacing.lg)

            Text("全10モーションの詳細スペック")
                .typography(.bodyMedium)
                .foregroundStyle(colorPalette.onSurfaceVariant)
                .padding(.horizontal, spacing.lg)

            SectionCard(title: "全モーション仕様") {
                VStack(spacing: 0) {
                    // ヘッダー
                    HStack(spacing: spacing.sm) {
                        Text("名前")
                            .frame(minWidth: 70, alignment: .leading)
                        Text("Duration")
                            .frame(minWidth: 80, alignment: .leading)
                        Text("Easing")
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .typography(.labelMedium)
                    .foregroundStyle(colorPalette.onSurfaceVariant)
                    .padding(spacing.sm)
                    .background(colorPalette.surfaceVariant.opacity(0.5))

                    // 各行
                    ForEach(MotionSpec.all) { spec in
                        VStack(spacing: 0) {
                            HStack(spacing: spacing.sm) {
                                Text(spec.name)
                                    .typography(.bodyMedium)
                                    .foregroundStyle(colorPalette.primary)
                                    .frame(minWidth: 70, alignment: .leading)

                                Text(spec.duration)
                                    .typography(.bodySmall)
                                    .foregroundStyle(colorPalette.onSurface)
                                    .frame(minWidth: 80, alignment: .leading)

                                Text(spec.easing)
                                    .typography(.bodySmall)
                                    .foregroundStyle(colorPalette.onSurfaceVariant)
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
        }
    }

    // MARK: - 4. 使用例セクション

    private var usageExamplesSection: some View {
        VStack(alignment: .leading, spacing: spacing.lg) {
            Text("使用例")
                .typography(.titleLarge)
                .foregroundStyle(colorPalette.onSurface)
                .padding(.horizontal, spacing.lg)

            // 基本的な使い方
            SectionCard(title: "1. 基本的な使い方") {
                VStack(alignment: .leading, spacing: spacing.sm) {
                    Text("@Environment(\\.motion) でMotionにアクセスし、.animate() modifierで適用します。")
                        .typography(.bodyMedium)
                        .foregroundStyle(colorPalette.onSurfaceVariant)

                    codeBlock("""
                    @Environment(\\.motion) var motion

                    Button("タップ") { }
                        .scaleEffect(isPressed ? 0.98 : 1.0)
                        .animate(motion.tap, value: isPressed)
                    """)
                }
            }

            // 複数のアニメーション
            SectionCard(title: "2. 複数のアニメーション") {
                VStack(alignment: .leading, spacing: spacing.sm) {
                    Text("一つのビューに複数の .animate() を適用できます。")
                        .typography(.bodyMedium)
                        .foregroundStyle(colorPalette.onSurfaceVariant)

                    codeBlock("""
                    Chip("フィルター", isSelected: $selected)
                        .scaleEffect(isPressed ? 0.96 : 1.0)
                        .animate(motion.tap, value: isPressed)
                        .animate(motion.toggle, value: selected)
                    """)
                }
            }

            // withAnimationでの使用
            SectionCard(title: "3. withAnimationでの使用") {
                VStack(alignment: .leading, spacing: spacing.sm) {
                    Text("withAnimation内でMotionを使用することもできます。")
                        .typography(.bodyMedium)
                        .foregroundStyle(colorPalette.onSurfaceVariant)

                    codeBlock("""
                    withAnimation(motion.slow) {
                        themeProvider.applyTheme(newTheme)
                    }
                    """)
                }
            }
        }
    }

    // MARK: - 5. アクセシビリティセクション

    private var accessibilitySection: some View {
        VStack(alignment: .leading, spacing: spacing.lg) {
            Text("アクセシビリティ")
                .typography(.titleLarge)
                .foregroundStyle(colorPalette.onSurface)
                .padding(.horizontal, spacing.lg)

            SectionCard(title: "Reduce Motion自動対応") {
                VStack(alignment: .leading, spacing: spacing.md) {
                    Text("`.animate()` modifierは、システムの「視差効果を減らす」設定を自動的に検出し、有効時はアニメーションを最小化します（WCAG 2.1 Success Criterion 2.3.3準拠）。")
                        .typography(.bodyMedium)
                        .foregroundStyle(colorPalette.onSurface)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    VStack(alignment: .leading, spacing: spacing.sm) {
                        FeatureRow(icon: "checkmark.circle.fill", title: "手動設定不要で自動対応")
                        FeatureRow(icon: "checkmark.circle.fill", title: "WCAG 2.1完全準拠")
                        FeatureRow(icon: "checkmark.circle.fill", title: "全モーションで一貫した動作")
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)

                    Text("実装例：")
                        .typography(.labelLarge)
                        .foregroundStyle(colorPalette.onSurface)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    codeBlock("""
                    // 自動的にReduce Motionに対応
                    .animate(motion.tap, value: isPressed)

                    // 通常モード: 指定されたアニメーション
                    // Reduce Motion有効時: 10msの瞬時変化
                    """)
                }
            }
        }
    }

    // MARK: - 6. ベストプラクティスセクション

    private var bestPracticesSection: some View {
        VStack(alignment: .leading, spacing: spacing.lg) {
            Text("ベストプラクティス")
                .typography(.titleLarge)
                .foregroundStyle(colorPalette.onSurface)
                .padding(.horizontal, spacing.lg)

            // 推奨パターン
            SectionCard(title: "✓ 推奨パターン") {
                VStack(alignment: .leading, spacing: spacing.md) {
                    BestPracticeItem(
                        icon: "checkmark.circle.fill",
                        title: "適切なモーションを選択",
                        description: "タップには tap、状態変化には toggle を使用",
                        isGood: true
                    )
                    .frame(maxWidth: .infinity, alignment: .leading)

                    Divider()

                    BestPracticeItem(
                        icon: "checkmark.circle.fill",
                        title: ".animate() modifierを使用",
                        description: "Reduce Motion自動対応のため必ず使用",
                        isGood: true
                    )
                    .frame(maxWidth: .infinity, alignment: .leading)

                    Divider()

                    BestPracticeItem(
                        icon: "checkmark.circle.fill",
                        title: "一貫性を保つ",
                        description: "同じインタラクションには同じモーションを適用",
                        isGood: true
                    )
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }

            // アンチパターン
            SectionCard(title: "✗ 避けるべきパターン") {
                VStack(alignment: .leading, spacing: spacing.md) {
                    BestPracticeItem(
                        icon: "xmark.circle.fill",
                        title: "ハードコード値の使用",
                        description: ".animation(.easeInOut(duration: 0.15)) は避ける",
                        isGood: false
                    )
                    .frame(maxWidth: .infinity, alignment: .leading)

                    Divider()

                    BestPracticeItem(
                        icon: "xmark.circle.fill",
                        title: "過度なアニメーション",
                        description: "全ての要素にアニメーションは不要",
                        isGood: false
                    )
                    .frame(maxWidth: .infinity, alignment: .leading)

                    Divider()

                    BestPracticeItem(
                        icon: "xmark.circle.fill",
                        title: "不適切なモーション選択",
                        description: "ボタンに slow や slower は遅すぎて不適切",
                        isGood: false
                    )
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
        }
    }

    // MARK: - Helper Views

    private func codeBlock(_ code: String) -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            Text(code)
                .typography(.bodySmall)
                .fontDesign(.monospaced)
                .padding(spacing.md)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(colorPalette.surfaceVariant)
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

#Preview {
    NavigationStack {
        MotionCatalogView()
            .theme(ThemeProvider())
    }
}
