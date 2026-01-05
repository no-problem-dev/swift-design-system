import SwiftUI

/// FABコンポーネントのカタログビュー
struct FloatingActionButtonCatalogView: View {
    @Environment(\.colorPalette) private var colors
    @Environment(\.spacingScale) private var spacing
    @State private var tapCount = 0

    var body: some View {
        CatalogPageContainer(title: "FAB") {
            VStack(alignment: .leading, spacing: spacing.sm) {
                CatalogOverview(description: "画面上で最も重要なアクションを表すボタン")

                if tapCount > 0 {
                    Text("タップ回数: \(tapCount)")
                        .typography(.bodySmall)
                        .foregroundStyle(colors.primary)
                        .padding(.horizontal, spacing.lg)
                }
            }

            SectionCard(title: "サイズ") {
                VStack(spacing: spacing.lg) {
                    HStack {
                        Text("Small (40pt)")
                            .typography(.bodyMedium)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        FloatingActionButton(icon: "plus", size: .small) { tapCount += 1 }
                    }
                    HStack {
                        Text("Regular (56pt)")
                            .typography(.bodyMedium)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        FloatingActionButton(icon: "plus", size: .regular) { tapCount += 1 }
                    }
                    HStack {
                        Text("Large (96pt)")
                            .typography(.bodyMedium)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        FloatingActionButton(icon: "plus", size: .large) { tapCount += 1 }
                    }
                }
            }

            SectionCard(title: "アイコン") {
                VariantShowcase(title: "SF Symbols", description: "任意のアイコンが使用可能") {
                    HStack(spacing: spacing.lg) {
                        FloatingActionButton(icon: "plus") { tapCount += 1 }
                        FloatingActionButton(icon: "pencil") { tapCount += 1 }
                        FloatingActionButton(icon: "camera") { tapCount += 1 }
                        FloatingActionButton(icon: "trash") { tapCount += 1 }
                    }
                }
            }

            SectionCard(title: "使用例") {
                CodeExample(code: """
                    FloatingActionButton(
                        icon: "plus",
                        size: .regular
                    ) {
                        // アクション
                    }
                    """)
            }

            SectionCard(title: "レイアウト例") {
                VariantShowcase(title: "右下配置", description: "典型的な使用パターン") {
                    ZStack(alignment: .bottomTrailing) {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(colors.surfaceVariant.opacity(0.3))
                            .frame(height: 200)

                        FloatingActionButton(icon: "plus") { tapCount += 1 }
                            .padding(spacing.lg)
                    }
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        FloatingActionButtonCatalogView()
            .theme(ThemeProvider())
    }
}
