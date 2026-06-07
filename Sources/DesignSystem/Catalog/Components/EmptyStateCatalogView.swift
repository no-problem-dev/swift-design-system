import SwiftUI

/// EmptyStateコンポーネントのカタログビュー
struct EmptyStateCatalogView: View {
    @Environment(\.spacingScale) private var spacing

    var body: some View {
        CatalogPageContainer(title: "EmptyState") {
            CatalogOverview(description: "リスト・グリッド・検索結果が空のときの明示ステート。「何が無いのか」と「どうすれば現れるのか」を伝える。")

            SectionCard(title: "バリエーション") {
                VStack(alignment: .leading, spacing: spacing.lg) {
                    VariantShowcase(title: "説明付き") {
                        EmptyState(
                            systemImage: "link",
                            title: "出典はありません",
                            description: "Web 調査を行ったセッションでは、参照した URL がここに並びます。"
                        )
                    }

                    Divider()

                    VariantShowcase(title: "見出しのみ") {
                        EmptyState(
                            systemImage: "photo.on.rectangle.angled",
                            title: "メディアはありません"
                        )
                    }
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        EmptyStateCatalogView()
            .theme(ThemeProvider())
    }
}
