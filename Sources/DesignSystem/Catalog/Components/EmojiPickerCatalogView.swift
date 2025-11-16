import SwiftUI

/// EmojiPickerのカタログビュー
struct EmojiPickerCatalogView: View {
    @Environment(\.colorPalette) private var colorPalette
    @Environment(\.spacingScale) private var spacing

    @State private var selectedEmoji: String?
    @State private var showEmojiPicker = false

    var body: some View {
        ScrollView {
            VStack(spacing: spacing.xl) {
                // ヘッダー
                headerSection

                // 基本的な使用例
                basicUsageSection

                // 使用例コード
                codeExampleSection
            }
            .padding(spacing.lg)
        }
        .background(colorPalette.background)
        .navigationTitle("EmojiPicker")
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
    }

    private var headerSection: some View {
        VStack(spacing: spacing.md) {
            Image(systemName: "face.smiling")
                .font(.system(size: 48))
                .foregroundStyle(colorPalette.primary)

            Text("EmojiPicker")
                .typography(.headlineLarge)
                .foregroundStyle(colorPalette.onBackground)

            Text("カテゴリ別の絵文字を選択")
                .typography(.bodyMedium)
                .foregroundStyle(colorPalette.onSurfaceVariant)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
    }

    private var basicUsageSection: some View {
        VStack(alignment: .leading, spacing: spacing.md) {
            Text("基本的な使用例")
                .typography(.titleLarge)
                .foregroundStyle(colorPalette.onSurface)

            Text("カテゴリ別に整理された絵文字ピッカー")
                .typography(.bodySmall)
                .foregroundStyle(colorPalette.onSurfaceVariant)

            VStack(spacing: spacing.md) {
                // 選択された絵文字のプレビュー
                HStack(spacing: spacing.md) {
                    if let emoji = selectedEmoji {
                        Text(emoji)
                            .font(.system(size: 48))
                            .frame(width: 60, height: 60)
                            .background(colorPalette.primaryContainer)
                            .clipShape(RoundedRectangle(cornerRadius: 12))

                        VStack(alignment: .leading, spacing: 4) {
                            Text("選択中の絵文字")
                                .typography(.bodySmall)
                                .foregroundStyle(colorPalette.onSurfaceVariant)
                            Text(emoji)
                                .typography(.headlineMedium)
                                .foregroundStyle(colorPalette.onSurface)
                        }
                    } else {
                        Text("絵文字を選択してください")
                            .typography(.bodyMedium)
                            .foregroundStyle(colorPalette.onSurfaceVariant)
                    }

                    Spacer()
                }
                .padding(spacing.md)
                .background(colorPalette.surfaceVariant.opacity(0.3))
                .clipShape(RoundedRectangle(cornerRadius: 12))

                // 選択ボタン
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
    }

    private var codeExampleSection: some View {
        VStack(alignment: .leading, spacing: spacing.md) {
            Text("使用例コード")
                .typography(.titleLarge)
                .foregroundStyle(colorPalette.onSurface)

            VStack(alignment: .leading, spacing: spacing.sm) {
                codeBlock("""
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

                Text("カテゴリと絵文字:")
                    .typography(.bodySmall)
                    .foregroundStyle(colorPalette.onSurfaceVariant)
                    .padding(.top, spacing.sm)

                Text("• EmojiCategory - カテゴリを定義")
                    .typography(.bodySmall)
                    .foregroundStyle(colorPalette.onSurfaceVariant)

                Text("• EmojiItem - 個別の絵文字を定義")
                    .typography(.bodySmall)
                    .foregroundStyle(colorPalette.onSurfaceVariant)

                Text("• emoji - 絵文字文字列（例: \"😊\"）")
                    .typography(.bodySmall)
                    .foregroundStyle(colorPalette.onSurfaceVariant)
            }
        }
    }

    private func codeBlock(_ code: String) -> some View {
        Text(code)
            .typography(.bodySmall)
            .fontDesign(.monospaced)
            .foregroundStyle(colorPalette.onSurface)
            .padding(spacing.md)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(colorPalette.surfaceVariant.opacity(0.5))
            .clipShape(RoundedRectangle(cornerRadius: 8))
    }

    // サンプルカテゴリ: 絵文字
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
