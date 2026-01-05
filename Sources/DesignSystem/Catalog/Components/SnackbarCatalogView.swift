import SwiftUI

/// Snackbarコンポーネントのカタログビュー
struct SnackbarCatalogView: View {
    @Environment(\.colorPalette) private var colors
    @Environment(\.spacingScale) private var spacing
    @State private var snackbarState = SnackbarState()

    var body: some View {
        ZStack {
            ScrollView {
                VStack(spacing: spacing.xl) {
                    CatalogOverview(description: "画面下部から表示される一時的な通知UI")

                    SectionCard(title: "基本") {
                        VariantShowcase(title: "シンプル", description: "メッセージのみ") {
                            Button("表示") {
                                snackbarState.show(message: "保存しました", duration: 3.0)
                            }
                            .buttonStyle(.primary)
                        }
                    }

                    SectionCard(title: "アクション付き") {
                        VStack(alignment: .leading, spacing: spacing.md) {
                            VariantShowcase(title: "単一アクション") {
                                Button("表示") {
                                    snackbarState.show(
                                        message: "削除しました",
                                        primaryAction: SnackbarAction(title: "元に戻す") {},
                                        duration: 5.0
                                    )
                                }
                                .buttonStyle(.primary)
                            }

                            Divider()

                            VariantShowcase(title: "複数アクション") {
                                Button("表示") {
                                    snackbarState.show(
                                        message: "ファイルを削除しますか？",
                                        primaryAction: SnackbarAction(title: "削除") {},
                                        secondaryAction: SnackbarAction(title: "キャンセル") {},
                                        duration: 7.0
                                    )
                                }
                                .buttonStyle(.primary)
                            }
                        }
                    }

                    SectionCard(title: "表示時間") {
                        HStack(spacing: spacing.md) {
                            Button("3秒") {
                                snackbarState.show(message: "3秒で消えます", duration: 3.0)
                            }
                            .buttonStyle(.secondary)

                            Button("5秒") {
                                snackbarState.show(message: "5秒で消えます", duration: 5.0)
                            }
                            .buttonStyle(.secondary)

                            Button("10秒") {
                                snackbarState.show(message: "10秒で消えます", duration: 10.0)
                            }
                            .buttonStyle(.secondary)
                        }
                    }

                    SectionCard(title: "ベストプラクティス") {
                        VStack(alignment: .leading, spacing: spacing.md) {
                            BestPracticeItem(icon: "checkmark.circle.fill", title: "簡潔なメッセージ", description: "1-2行で収まるように", isGood: true)
                            BestPracticeItem(icon: "checkmark.circle.fill", title: "アクションは最大2つ", description: "多すぎると判断が難しくなる", isGood: true)
                            BestPracticeItem(icon: "checkmark.circle.fill", title: "表示時間3-7秒", description: "重要な操作には十分な時間を確保", isGood: true)
                        }
                    }
                }
                .padding(.bottom, 100)
            }
            .background(colors.background)

            Snackbar(state: snackbarState)
        }
        .navigationTitle("Snackbar")
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
    }
}

#Preview {
    NavigationStack {
        SnackbarCatalogView()
            .theme(ThemeProvider())
    }
}
