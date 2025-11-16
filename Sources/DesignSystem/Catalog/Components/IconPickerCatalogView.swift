import SwiftUI

/// IconPicker（SF Symbols）のカタログビュー
struct IconPickerCatalogView: View {
    @Environment(\.colorPalette) private var colorPalette
    @Environment(\.spacingScale) private var spacing

    @State private var selectedIcon: String?
    @State private var showIconPicker = false

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
        .navigationTitle("IconPicker")
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
    }

    private var headerSection: some View {
        VStack(spacing: spacing.md) {
            Image(systemName: "square.grid.3x3")
                .font(.system(size: 48))
                .foregroundStyle(colorPalette.primary)

            Text("IconPicker")
                .typography(.headlineLarge)
                .foregroundStyle(colorPalette.onBackground)

            Text("SF Symbolsアイコンを選択")
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

            Text("カテゴリ別に整理されたSF Symbolsピッカー")
                .typography(.bodySmall)
                .foregroundStyle(colorPalette.onSurfaceVariant)

            VStack(spacing: spacing.md) {
                // 選択されたアイコンのプレビュー
                HStack(spacing: spacing.md) {
                    if let icon = selectedIcon {
                        Image(systemName: icon)
                            .font(.system(size: 32))
                            .foregroundStyle(colorPalette.primary)
                            .frame(width: 50, height: 50)
                            .background(colorPalette.primaryContainer)
                            .clipShape(RoundedRectangle(cornerRadius: 8))

                        VStack(alignment: .leading, spacing: 4) {
                            Text("選択中のアイコン")
                                .typography(.bodySmall)
                                .foregroundStyle(colorPalette.onSurfaceVariant)
                            Text(icon)
                                .typography(.bodyMedium)
                                .foregroundStyle(colorPalette.onSurface)
                                .fontDesign(.monospaced)
                        }
                    } else {
                        Text("アイコンを選択してください")
                            .typography(.bodyMedium)
                            .foregroundStyle(colorPalette.onSurfaceVariant)
                    }

                    Spacer()
                }
                .padding(spacing.md)
                .background(colorPalette.surfaceVariant.opacity(0.3))
                .clipShape(RoundedRectangle(cornerRadius: 12))

                // 選択ボタン
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
    }

    private var codeExampleSection: some View {
        VStack(alignment: .leading, spacing: spacing.md) {
            Text("使用例コード")
                .typography(.titleLarge)
                .foregroundStyle(colorPalette.onSurface)

            VStack(alignment: .leading, spacing: spacing.sm) {
                codeBlock("""
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

                Text("カテゴリとアイコン:")
                    .typography(.bodySmall)
                    .foregroundStyle(colorPalette.onSurfaceVariant)
                    .padding(.top, spacing.sm)

                Text("• IconCategory - カテゴリを定義")
                    .typography(.bodySmall)
                    .foregroundStyle(colorPalette.onSurfaceVariant)

                Text("• IconItem - 個別のSF Symbolsを定義")
                    .typography(.bodySmall)
                    .foregroundStyle(colorPalette.onSurfaceVariant)

                Text("• systemName - SF Symbols名（例: \"star.fill\"）")
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

    // サンプルカテゴリ: SF Symbols
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
