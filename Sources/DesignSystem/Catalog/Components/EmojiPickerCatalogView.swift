import SwiftUI

/// EmojiPickerのカタログビュー
struct EmojiPickerCatalogView: View {
    @Environment(\.colorPalette) private var colors
    @Environment(\.spacingScale) private var spacing
    @Environment(\.radiusScale) private var radius

    @State private var selectedEmoji: String?
    @State private var showEmojiPicker = false

    var body: some View {
        CatalogPageContainer(title: "EmojiPicker") {
            CatalogOverview(description: "カテゴリ別の絵文字を選択")

            SectionCard(title: "デモ") {
                VStack(spacing: spacing.md) {
                    emojiPreview

                    Button(selectedEmoji == nil ? "絵文字を選択" : "絵文字を変更") {
                        showEmojiPicker = true
                    }
                    .buttonStyle(.primary)
                    .buttonSize(.medium)
                    .emojiPicker(
                        categories: sampleEmojiCategories,
                        selectedEmoji: $selectedEmoji,
                        isPresented: $showEmojiPicker
                    )
                }
            }

            SectionCard(title: "使用例") {
                CodeExample(code: """
                    @State private var selectedEmoji: String?
                    @State private var showEmojiPicker = false

                    let categories = [
                        EmojiCategory(
                            id: "smileys",
                            displayName: "顔・感情",
                            emojis: [
                                EmojiItem(id: "smile", emoji: "😊"),
                                EmojiItem(id: "laugh", emoji: "😂")
                            ]
                        )
                    ]

                    Button("絵文字を選択") {
                        showEmojiPicker = true
                    }
                    .emojiPicker(
                        categories: categories,
                        selectedEmoji: $selectedEmoji,
                        isPresented: $showEmojiPicker
                    )
                    """)
            }
        }
    }

    @ViewBuilder
    private var emojiPreview: some View {
        HStack(spacing: spacing.md) {
            if let emoji = selectedEmoji {
                Text(emoji)
                    .font(.system(size: 48))
                    .frame(width: 60, height: 60)
                    .background(colors.primaryContainer)
                    .clipShape(RoundedRectangle(cornerRadius: radius.lg))

                Text(emoji)
                    .typography(.headlineMedium)
                    .foregroundStyle(colors.onSurface)
            } else {
                Text("絵文字を選択してください")
                    .typography(.bodyMedium)
                    .foregroundStyle(colors.onSurfaceVariant)
            }

            Spacer()
        }
        .padding(spacing.md)
        .background(colors.surfaceVariant.opacity(0.3))
        .clipShape(RoundedRectangle(cornerRadius: radius.lg))
    }

    private var sampleEmojiCategories: [EmojiCategory] {
        [
            EmojiCategory(
                id: "smileys",
                displayName: "顔・感情",
                emojis: [
                    EmojiItem(id: "smile", emoji: "😊", displayName: "笑顔"),
                    EmojiItem(id: "laugh", emoji: "😂", displayName: "笑い"),
                    EmojiItem(id: "love", emoji: "😍", displayName: "愛"),
                    EmojiItem(id: "cool", emoji: "😎", displayName: "クール"),
                    EmojiItem(id: "thinking", emoji: "🤔", displayName: "考え中"),
                    EmojiItem(id: "party", emoji: "🥳", displayName: "パーティ")
                ]
            ),
            EmojiCategory(
                id: "animals",
                displayName: "動物・自然",
                emojis: [
                    EmojiItem(id: "dog", emoji: "🐕", displayName: "犬"),
                    EmojiItem(id: "cat", emoji: "🐈", displayName: "猫"),
                    EmojiItem(id: "bird", emoji: "🐦", displayName: "鳥"),
                    EmojiItem(id: "tree", emoji: "🌳", displayName: "木"),
                    EmojiItem(id: "flower", emoji: "🌸", displayName: "花"),
                    EmojiItem(id: "sun", emoji: "☀️", displayName: "太陽")
                ]
            ),
            EmojiCategory(
                id: "food",
                displayName: "食べ物・飲み物",
                emojis: [
                    EmojiItem(id: "apple", emoji: "🍎", displayName: "りんご"),
                    EmojiItem(id: "pizza", emoji: "🍕", displayName: "ピザ"),
                    EmojiItem(id: "sushi", emoji: "🍣", displayName: "寿司"),
                    EmojiItem(id: "coffee", emoji: "☕", displayName: "コーヒー"),
                    EmojiItem(id: "cake", emoji: "🍰", displayName: "ケーキ"),
                    EmojiItem(id: "burger", emoji: "🍔", displayName: "ハンバーガー")
                ]
            ),
            EmojiCategory(
                id: "activities",
                displayName: "活動・スポーツ",
                emojis: [
                    EmojiItem(id: "soccer", emoji: "⚽", displayName: "サッカー"),
                    EmojiItem(id: "basketball", emoji: "🏀", displayName: "バスケ"),
                    EmojiItem(id: "tennis", emoji: "🎾", displayName: "テニス"),
                    EmojiItem(id: "running", emoji: "🏃", displayName: "ランニング"),
                    EmojiItem(id: "music", emoji: "🎵", displayName: "音楽"),
                    EmojiItem(id: "art", emoji: "🎨", displayName: "芸術")
                ]
            )
        ]
    }
}

#Preview {
    NavigationStack {
        EmojiPickerCatalogView()
            .theme(ThemeProvider())
    }
}
