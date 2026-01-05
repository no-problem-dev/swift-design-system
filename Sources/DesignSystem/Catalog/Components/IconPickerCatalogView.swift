import SwiftUI

/// IconPicker（SF Symbols）のカタログビュー
struct IconPickerCatalogView: View {
    @Environment(\.colorPalette) private var colors
    @Environment(\.spacingScale) private var spacing
    @Environment(\.radiusScale) private var radius

    @State private var selectedIcon: String?
    @State private var showIconPicker = false

    var body: some View {
        CatalogPageContainer(title: "IconPicker") {
            CatalogOverview(description: "SF Symbolsアイコンを選択")

            SectionCard(title: "デモ") {
                VStack(spacing: spacing.md) {
                    iconPreview

                    Button(selectedIcon == nil ? "アイコンを選択" : "アイコンを変更") {
                        showIconPicker = true
                    }
                    .buttonStyle(.primary)
                    .buttonSize(.medium)
                    .iconPicker(
                        categories: sampleSFSymbolsCategories,
                        selectedIcon: $selectedIcon,
                        isPresented: $showIconPicker
                    )
                }
            }

            SectionCard(title: "使用例") {
                CodeExample(code: """
                    @State private var selectedIcon: String?
                    @State private var showIconPicker = false

                    let categories = [
                        IconCategory(
                            id: "general",
                            displayName: "一般",
                            icons: [
                                IconItem(id: "book", systemName: "book.fill"),
                                IconItem(id: "heart", systemName: "heart.fill")
                            ]
                        )
                    ]

                    Button("アイコンを選択") {
                        showIconPicker = true
                    }
                    .iconPicker(
                        categories: categories,
                        selectedIcon: $selectedIcon,
                        isPresented: $showIconPicker
                    )
                    """)
            }
        }
    }

    @ViewBuilder
    private var iconPreview: some View {
        HStack(spacing: spacing.md) {
            if let icon = selectedIcon {
                Image(systemName: icon)
                    .font(.system(size: 32))
                    .foregroundStyle(colors.primary)
                    .frame(width: 50, height: 50)
                    .background(colors.primaryContainer)
                    .clipShape(RoundedRectangle(cornerRadius: radius.md))

                Text(icon)
                    .typography(.bodyMedium)
                    .foregroundStyle(colors.onSurface)
                    .fontDesign(.monospaced)
            } else {
                Text("アイコンを選択してください")
                    .typography(.bodyMedium)
                    .foregroundStyle(colors.onSurfaceVariant)
            }

            Spacer()
        }
        .padding(spacing.md)
        .background(colors.surfaceVariant.opacity(0.3))
        .clipShape(RoundedRectangle(cornerRadius: radius.lg))
    }

    private var sampleSFSymbolsCategories: [IconCategory] {
        [
            IconCategory(
                id: "general",
                displayName: "一般",
                icons: [
                    IconItem(id: "book", systemName: "book.fill", displayName: "本"),
                    IconItem(id: "heart", systemName: "heart.fill", displayName: "ハート"),
                    IconItem(id: "star", systemName: "star.fill", displayName: "星"),
                    IconItem(id: "flag", systemName: "flag.fill", displayName: "旗"),
                    IconItem(id: "tag", systemName: "tag.fill", displayName: "タグ"),
                    IconItem(id: "bookmark", systemName: "bookmark.fill", displayName: "ブックマーク")
                ]
            ),
            IconCategory(
                id: "business",
                displayName: "ビジネス",
                icons: [
                    IconItem(id: "briefcase", systemName: "briefcase.fill", displayName: "ビジネス"),
                    IconItem(id: "folder", systemName: "folder.fill", displayName: "フォルダ"),
                    IconItem(id: "doc", systemName: "doc.fill", displayName: "文書"),
                    IconItem(id: "calendar", systemName: "calendar", displayName: "カレンダー"),
                    IconItem(id: "clock", systemName: "clock.fill", displayName: "時計"),
                    IconItem(id: "chart", systemName: "chart.bar.fill", displayName: "グラフ")
                ]
            ),
            IconCategory(
                id: "communication",
                displayName: "コミュニケーション",
                icons: [
                    IconItem(id: "message", systemName: "message.fill", displayName: "メッセージ"),
                    IconItem(id: "phone", systemName: "phone.fill", displayName: "電話"),
                    IconItem(id: "envelope", systemName: "envelope.fill", displayName: "メール"),
                    IconItem(id: "bubble", systemName: "bubble.left.fill", displayName: "吹き出し"),
                    IconItem(id: "bell", systemName: "bell.fill", displayName: "通知"),
                    IconItem(id: "paperplane", systemName: "paperplane.fill", displayName: "送信")
                ]
            )
        ]
    }
}

#Preview {
    NavigationStack {
        IconPickerCatalogView()
            .theme(ThemeProvider())
    }
}
