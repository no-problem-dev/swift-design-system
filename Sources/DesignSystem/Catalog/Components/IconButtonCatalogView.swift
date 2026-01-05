import SwiftUI

/// IconButtonコンポーネントのカタログビュー
struct IconButtonCatalogView: View {
    @Environment(\.colorPalette) private var colors
    @Environment(\.spacingScale) private var spacing
    @State private var tapCount = 0

    var body: some View {
        CatalogPageContainer(title: "IconButton") {
            VStack(alignment: .leading, spacing: spacing.sm) {
                CatalogOverview(description: "アイコンのみで構成される、コンパクトなアクションボタン")

                if tapCount > 0 {
                    Text("タップ: \(tapCount)")
                        .typography(.bodySmall)
                        .foregroundStyle(colors.primary)
                        .padding(.horizontal, spacing.lg)
                }
            }

            SectionCard(title: "スタイル") {
                VStack(spacing: spacing.lg) {
                    HStack {
                        Text("Standard").typography(.bodyMedium).frame(width: 100, alignment: .leading)
                        IconButton(icon: "heart", style: .standard) { tapCount += 1 }
                        Text("背景なし").typography(.labelSmall).foregroundStyle(colors.onSurfaceVariant)
                    }
                    HStack {
                        Text("Filled").typography(.bodyMedium).frame(width: 100, alignment: .leading)
                        IconButton(icon: "heart.fill", style: .filled) { tapCount += 1 }
                        Text("プライマリ背景").typography(.labelSmall).foregroundStyle(colors.onSurfaceVariant)
                    }
                    HStack {
                        Text("Tonal").typography(.bodyMedium).frame(width: 100, alignment: .leading)
                        IconButton(icon: "heart.fill", style: .tonal) { tapCount += 1 }
                        Text("トーン背景").typography(.labelSmall).foregroundStyle(colors.onSurfaceVariant)
                    }
                    HStack {
                        Text("Outlined").typography(.bodyMedium).frame(width: 100, alignment: .leading)
                        IconButton(icon: "heart", style: .outlined) { tapCount += 1 }
                        Text("枠線のみ").typography(.labelSmall).foregroundStyle(colors.onSurfaceVariant)
                    }
                }
            }

            SectionCard(title: "サイズ") {
                VStack(spacing: spacing.lg) {
                    HStack {
                        Text("Small (32pt)").typography(.bodyMedium).frame(maxWidth: .infinity, alignment: .leading)
                        IconButton(icon: "star.fill", style: .filled, size: .small) { tapCount += 1 }
                    }
                    HStack {
                        Text("Medium (40pt)").typography(.bodyMedium).frame(maxWidth: .infinity, alignment: .leading)
                        IconButton(icon: "star.fill", style: .filled, size: .medium) { tapCount += 1 }
                    }
                    HStack {
                        Text("Large (48pt)").typography(.bodyMedium).frame(maxWidth: .infinity, alignment: .leading)
                        IconButton(icon: "star.fill", style: .filled, size: .large) { tapCount += 1 }
                    }
                }
            }

            SectionCard(title: "アイコン例") {
                HStack(spacing: spacing.lg) {
                    IconButton(icon: "heart", style: .tonal) { tapCount += 1 }
                    IconButton(icon: "star", style: .tonal) { tapCount += 1 }
                    IconButton(icon: "bookmark", style: .tonal) { tapCount += 1 }
                    IconButton(icon: "square.and.arrow.up", style: .tonal) { tapCount += 1 }
                    IconButton(icon: "ellipsis", style: .tonal) { tapCount += 1 }
                }
            }

            SectionCard(title: "使用例") {
                CodeExample(code: """
                    IconButton(
                        icon: "heart",
                        style: .filled,
                        size: .medium
                    ) {
                        // アクション
                    }
                    """)
            }

            SectionCard(title: "実用例") {
                VariantShowcase(title: "ツールバー") {
                    Card {
                        VStack(spacing: spacing.md) {
                            HStack {
                                Text("記事のタイトル").typography(.titleMedium)
                                Spacer()
                            }
                            Text("本文のプレビューテキスト。")
                                .typography(.bodySmall)
                                .foregroundStyle(colors.onSurfaceVariant)
                            HStack {
                                IconButton(icon: "heart", style: .tonal) { tapCount += 1 }
                                IconButton(icon: "bookmark", style: .tonal) {}
                                IconButton(icon: "square.and.arrow.up", style: .tonal) {}
                                Spacer()
                                IconButton(icon: "ellipsis", style: .tonal) {}
                            }
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        IconButtonCatalogView()
            .theme(ThemeProvider())
    }
}
