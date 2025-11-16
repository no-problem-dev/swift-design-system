import SwiftUI

/// Snackbarコンポーネントのカタログビュー
struct SnackbarCatalogView: View {
    @Environment(\.colorPalette) private var colorPalette
    @Environment(\.spacingScale) private var spacing

    @State private var snackbarState = SnackbarState()

    var body: some View {
        ZStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // 概要
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Snackbarは画面下部から表示される一時的な通知UIです")
                            .typography(.bodyMedium)
                            .foregroundStyle(colorPalette.onSurfaceVariant)

                        Text("ユーザーのアクションに対するフィードバックや簡単な通知を表示します")
                            .typography(.bodySmall)
                            .foregroundStyle(colorPalette.onSurfaceVariant)
                    }
                    .padding(.horizontal, spacing.lg)
                    .padding(.top, spacing.lg)

                    // 基本的な使い方
                    SectionCard(title: "基本的な使い方") {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("シンプルなメッセージのみ")
                                .typography(.bodySmall)
                                .foregroundStyle(colorPalette.onSurfaceVariant)

                            Button {
                                snackbarState.show(
                                    message: "保存しました",
                                    duration: 3.0
                                )
                            } label: {
                                Text("シンプルなSnackbarを表示")
                                    .typography(.labelLarge)
                            }
                            .buttonStyle(.primary)
                        }
                    }

                    // アクション付き
                    SectionCard(title: "アクション付き") {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("プライマリアクション付き")
                                .typography(.bodySmall)
                                .foregroundStyle(colorPalette.onSurfaceVariant)

                            Button {
                                snackbarState.show(
                                    message: "削除しました",
                                    primaryAction: SnackbarAction(title: "元に戻す") {
                                        // 元に戻す処理のシミュレーション
                                        print("元に戻す")
                                    },
                                    duration: 5.0
                                )
                            } label: {
                                Text("アクション付きSnackbar")
                                    .typography(.labelLarge)
                            }
                            .buttonStyle(.primary)
                        }
                    }

                    // 複数アクション
                    SectionCard(title: "複数アクション") {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("プライマリとセカンダリアクション")
                                .typography(.bodySmall)
                                .foregroundStyle(colorPalette.onSurfaceVariant)

                            Button {
                                snackbarState.show(
                                    message: "ファイルを削除しますか？",
                                    primaryAction: SnackbarAction(title: "削除") {
                                        print("削除実行")
                                    },
                                    secondaryAction: SnackbarAction(title: "キャンセル") {
                                        print("キャンセル")
                                    },
                                    duration: 7.0
                                )
                            } label: {
                                Text("複数アクション付きSnackbar")
                                    .typography(.labelLarge)
                            }
                            .buttonStyle(.primary)
                        }
                    }

                    // 長いメッセージ
                    SectionCard(title: "長いメッセージ") {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("複数行のメッセージ（最大2行）")
                                .typography(.bodySmall)
                                .foregroundStyle(colorPalette.onSurfaceVariant)

                            Button {
                                snackbarState.show(
                                    message: "ネットワークエラーが発生しました。接続を確認してもう一度お試しください。",
                                    primaryAction: SnackbarAction(title: "再試行") {
                                        print("再試行")
                                    },
                                    duration: 5.0
                                )
                            } label: {
                                Text("長いメッセージのSnackbar")
                                    .typography(.labelLarge)
                            }
                            .buttonStyle(.primary)
                        }
                    }

                    // カスタム表示時間
                    SectionCard(title: "カスタム表示時間") {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("表示時間をカスタマイズ")
                                .typography(.bodySmall)
                                .foregroundStyle(colorPalette.onSurfaceVariant)

                            HStack(spacing: spacing.md) {
                                Button {
                                    snackbarState.show(
                                        message: "3秒で消えます",
                                        duration: 3.0
                                    )
                                } label: {
                                    Text("3秒")
                                        .typography(.labelMedium)
                                }
                                .buttonStyle(.secondary)

                                Button {
                                    snackbarState.show(
                                        message: "5秒で消えます",
                                        duration: 5.0
                                    )
                                } label: {
                                    Text("5秒")
                                        .typography(.labelMedium)
                                }
                                .buttonStyle(.secondary)

                                Button {
                                    snackbarState.show(
                                        message: "10秒で消えます",
                                        duration: 10.0
                                    )
                                } label: {
                                    Text("10秒")
                                        .typography(.labelMedium)
                                }
                                .buttonStyle(.secondary)
                            }
                        }
                    }

                    // 使用上の注意
                    SectionCard(title: "使用上の注意") {
                        VStack(alignment: .leading, spacing: 8) {
                            Label("メッセージは簡潔に（1-2行）", systemImage: "checkmark.circle.fill")
                                .typography(.bodySmall)
                                .foregroundStyle(colorPalette.success)

                            Label("アクションは最大2つまで", systemImage: "checkmark.circle.fill")
                                .typography(.bodySmall)
                                .foregroundStyle(colorPalette.success)

                            Label("自動消滅時間は3-7秒が推奨", systemImage: "checkmark.circle.fill")
                                .typography(.bodySmall)
                                .foregroundStyle(colorPalette.success)

                            Label("重要な操作には十分な時間を確保", systemImage: "checkmark.circle.fill")
                                .typography(.bodySmall)
                                .foregroundStyle(colorPalette.success)
                        }
                    }
                }
                .padding(.bottom, 100) // Snackbar表示用のスペース
            }
            .background(colorPalette.background)

            // Snackbar
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
