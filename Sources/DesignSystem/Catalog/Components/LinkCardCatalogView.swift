import SwiftUI

/// LinkCardコンポーネントのカタログビュー
struct LinkCardCatalogView: View {
    @Environment(\.colorPalette) private var colors
    @Environment(\.spacingScale) private var spacing

    private let sampleURL = URL(string: "https://docs.swift.org/swift-book/")!
    private let blogURL = URL(string: "https://swift.org/blog/")!

    var body: some View {
        CatalogPageContainer(title: "LinkCard") {
            CatalogOverview(description: "URL 参照（出典・関連リンク・引用元）を 1 枚のカードで表す。メタデータの取得は呼び出し側の責務 — このコンポーネントは表示だけを行う。")

            SectionCard(title: "バリエーション") {
                VStack(alignment: .leading, spacing: spacing.lg) {
                    VariantShowcase(title: "基本", description: "タイトル + ドメイン。action 付きはトレーリングに矢印") {
                        LinkCard(
                            title: "Swift Concurrency - The Swift Programming Language",
                            url: sampleURL,
                            action: {}
                        )
                    }

                    Divider()

                    VariantShowcase(title: "タイトルなし", description: "title が nil ならホスト名を見出しに使う") {
                        LinkCard(title: nil, url: blogURL, action: {})
                    }

                    Divider()

                    VariantShowcase(title: "アクセサリ付き", description: "出典の検証ステータスなどを Chip で添える") {
                        VStack(spacing: spacing.sm) {
                            LinkCard(title: "検証済みの出典", url: blogURL, action: {}) {
                                Chip("取得済み", systemImage: "checkmark")
                                    .chipStyle(.filled)
                                    .chipSize(.small)
                                    .foregroundColor(.green)
                            }
                            LinkCard(title: "未検証の出典", url: sampleURL, action: {}) {
                                Chip("未検証", systemImage: "questionmark")
                                    .chipStyle(.filled)
                                    .chipSize(.small)
                                    .foregroundColor(.orange)
                            }
                        }
                    }

                    Divider()

                    VariantShowcase(title: "静的表示", description: "action なし（タップ不可、矢印なし）") {
                        LinkCard(title: "参照のみのリンク", url: sampleURL)
                    }
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        LinkCardCatalogView()
            .theme(ThemeProvider())
    }
}
