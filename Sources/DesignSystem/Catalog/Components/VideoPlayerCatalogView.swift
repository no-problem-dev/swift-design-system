import SwiftUI

#if canImport(UIKit)

/// VideoPlayerViewのカタログビュー
struct VideoPlayerCatalogView: View {
    @Environment(\.colorPalette) private var colorPalette
    @Environment(\.spacingScale) private var spacing

    @State private var showPicker = false
    @State private var selectedVideoData: Data?

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // 概要
                VStack(alignment: .leading, spacing: 12) {
                    Text("動画データまたはURLから動画を再生するコンポーネント")
                        .typography(.bodyMedium)
                        .foregroundStyle(colorPalette.onSurfaceVariant)
                        .padding(.horizontal, spacing.lg)

                    Text("再生コントロール、メタデータ表示、共有・保存アクションを提供します。")
                        .typography(.bodySmall)
                        .foregroundStyle(colorPalette.onSurfaceVariant)
                        .padding(.horizontal, spacing.lg)
                }

                // デモ
                SectionCard(title: "デモ") {
                    VStack(spacing: spacing.lg) {
                        if let videoData = selectedVideoData {
                            // メタデータとアクション付きプレイヤー
                            VideoPlayerView(data: videoData)
                                .showMetadata(true)
                                .showActions([.play, .share, .saveToPhotos])
                        } else {
                            // プレースホルダー
                            RoundedRectangle(cornerRadius: 12)
                                .fill(colorPalette.surfaceVariant)
                                .frame(height: 200)
                                .overlay {
                                    VStack(spacing: spacing.sm) {
                                        Image(systemName: "play.rectangle")
                                            .font(.system(size: 48))
                                            .foregroundStyle(colorPalette.onSurfaceVariant)
                                        Text("動画を選択してください")
                                            .typography(.bodySmall)
                                            .foregroundStyle(colorPalette.onSurfaceVariant)
                                    }
                                }
                        }

                        // 動画選択ボタン
                        Button {
                            showPicker = true
                        } label: {
                            Label(
                                selectedVideoData == nil ? "動画を選択" : "動画を変更",
                                systemImage: "video.badge.plus"
                            )
                        }
                        .buttonStyle(.primary)

                        // クリアボタン
                        if selectedVideoData != nil {
                            Button {
                                selectedVideoData = nil
                            } label: {
                                Label("クリア", systemImage: "trash")
                            }
                            .buttonStyle(.secondary)
                        }
                    }
                    .videoPicker(
                        isPresented: $showPicker,
                        selectedVideoData: $selectedVideoData,
                        maxSize: 100.mb
                    )
                }

                // 機能説明
                SectionCard(title: "機能") {
                    VStack(alignment: .leading, spacing: spacing.md) {
                        FeatureRow(
                            icon: "play.fill",
                            title: "AVPlayerによる高品質な動画再生"
                        )
                        FeatureRow(
                            icon: "info.circle",
                            title: "動画メタデータの表示（長さ、解像度、サイズ）"
                        )
                        FeatureRow(
                            icon: "square.and.arrow.up",
                            title: "共有機能"
                        )
                        FeatureRow(
                            icon: "square.and.arrow.down",
                            title: "カメラロールへの保存"
                        )
                        FeatureRow(
                            icon: "doc",
                            title: "DataまたはURLから初期化可能"
                        )
                    }
                }

                // 使用例
                SectionCard(title: "使用例") {
                    VStack(alignment: .leading, spacing: spacing.md) {
                        Text("Dataから再生")
                            .typography(.titleSmall)

                        Text("""
                        // 基本的な使い方
                        VideoPlayerView(data: videoData)

                        // メタデータ表示付き
                        VideoPlayerView(data: videoData)
                            .showMetadata(true)

                        // アクションボタン付き
                        VideoPlayerView(data: videoData)
                            .showMetadata(true)
                            .showActions([.play, .share, .saveToPhotos])
                        """)
                        .typography(.bodySmall)
                        .foregroundStyle(colorPalette.onSurfaceVariant)
                        .padding(spacing.md)
                        .background(colorPalette.surfaceVariant)
                        .clipShape(RoundedRectangle(cornerRadius: 8))

                        Text("URLから再生")
                            .typography(.titleSmall)
                            .padding(.top, spacing.sm)

                        Text("""
                        // ローカルファイルURL
                        VideoPlayerView(url: fileURL)

                        // リモートURL
                        VideoPlayerView(url: remoteURL)
                            .showMetadata(true)
                        """)
                        .typography(.bodySmall)
                        .foregroundStyle(colorPalette.onSurfaceVariant)
                        .padding(spacing.md)
                        .background(colorPalette.surfaceVariant)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                }

                // アクション
                SectionCard(title: "利用可能なアクション") {
                    VStack(alignment: .leading, spacing: spacing.md) {
                        ActionItem(
                            icon: "play.fill",
                            name: ".play",
                            description: "再生/一時停止ボタンを表示"
                        )
                        ActionItem(
                            icon: "square.and.arrow.up",
                            name: ".share",
                            description: "共有シートを表示するボタン"
                        )
                        ActionItem(
                            icon: "square.and.arrow.down",
                            name: ".saveToPhotos",
                            description: "カメラロールに保存するボタン"
                        )
                    }
                }

                // ベストプラクティス
                SectionCard(title: "ベストプラクティス") {
                    VStack(alignment: .leading, spacing: spacing.sm) {
                        BestPracticeItem(
                            icon: "checkmark.circle.fill",
                            title: "メモリ管理",
                            description: "大きな動画はURLから直接再生することでメモリ使用を抑えられます",
                            isGood: true
                        )
                        BestPracticeItem(
                            icon: "checkmark.circle.fill",
                            title: "一時ファイル",
                            description: "Dataから再生する場合、一時ファイルは自動的にクリーンアップされます",
                            isGood: true
                        )
                        BestPracticeItem(
                            icon: "exclamationmark.triangle.fill",
                            title: "権限",
                            description: "カメラロールへの保存には写真ライブラリへの書き込み権限が必要です",
                            isGood: true
                        )
                    }
                }

                // 仕様
                SectionCard(title: "仕様") {
                    VStack(alignment: .leading, spacing: spacing.sm) {
                        SpecItem(label: "入力形式", value: "Data または URL")
                        SpecItem(label: "再生エンジン", value: "AVPlayer")
                        SpecItem(label: "メタデータ", value: "長さ、解像度、ファイルサイズ")
                        SpecItem(label: "対応プラットフォーム", value: "iOS 17.0+")
                    }
                }
            }
            .padding(.vertical, spacing.lg)
        }
    }
}

// MARK: - Action Item

private struct ActionItem: View {
    @Environment(\.colorPalette) private var colorPalette
    @Environment(\.spacingScale) private var spacing

    let icon: String
    let name: String
    let description: String

    var body: some View {
        HStack(alignment: .top, spacing: spacing.md) {
            Image(systemName: icon)
                .font(.body)
                .foregroundStyle(colorPalette.primary)
                .frame(width: 24)

            VStack(alignment: .leading, spacing: spacing.xxs) {
                Text(name)
                    .typography(.labelMedium)
                    .foregroundStyle(colorPalette.onSurface)

                Text(description)
                    .typography(.bodySmall)
                    .foregroundStyle(colorPalette.onSurfaceVariant)
            }
        }
    }
}

#Preview {
    VideoPlayerCatalogView()
        .theme(ThemeProvider())
}

#endif
