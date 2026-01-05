import SwiftUI

#if canImport(UIKit)

/// VideoPlayerViewのカタログビュー
struct VideoPlayerCatalogView: View {
    @Environment(\.colorPalette) private var colors
    @Environment(\.spacingScale) private var spacing
    @Environment(\.radiusScale) private var radius

    @State private var showPicker = false
    @State private var selectedVideoData: Data?

    var body: some View {
        CatalogPageContainer(title: "VideoPlayer") {
            CatalogOverview(description: "動画データまたはURLから動画を再生するコンポーネント")

            SectionCard(title: "デモ") {
                VStack(spacing: spacing.lg) {
                    if let videoData = selectedVideoData {
                        VideoPlayerView(data: videoData)
                            .showMetadata(true)
                            .showActions([.play, .share, .saveToPhotos])
                    } else {
                        RoundedRectangle(cornerRadius: radius.md)
                            .fill(colors.surfaceVariant)
                            .frame(height: 200)
                            .overlay {
                                VStack(spacing: spacing.sm) {
                                    Image(systemName: "play.rectangle")
                                        .font(.system(size: 48))
                                        .foregroundStyle(colors.onSurfaceVariant)
                                    Text("動画を選択してください")
                                        .typography(.bodySmall)
                                        .foregroundStyle(colors.onSurfaceVariant)
                                }
                            }
                    }

                    Button {
                        showPicker = true
                    } label: {
                        Label(
                            selectedVideoData == nil ? "動画を選択" : "動画を変更",
                            systemImage: "video.badge.plus"
                        )
                    }
                    .buttonStyle(.primary)

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

            SectionCard(title: "機能") {
                VStack(alignment: .leading, spacing: spacing.md) {
                    FeatureRow(icon: "play.fill", title: "AVPlayerによる高品質な動画再生")
                    FeatureRow(icon: "info.circle", title: "メタデータ表示（長さ、解像度、サイズ）")
                    FeatureRow(icon: "square.and.arrow.up", title: "共有機能")
                    FeatureRow(icon: "square.and.arrow.down", title: "カメラロールへの保存")
                    FeatureRow(icon: "doc", title: "DataまたはURLから初期化可能")
                }
            }

            SectionCard(title: "使用例") {
                CodeExample(code: """
                    // 基本的な使い方
                    VideoPlayerView(data: videoData)

                    // メタデータ表示付き
                    VideoPlayerView(data: videoData)
                        .showMetadata(true)

                    // アクションボタン付き
                    VideoPlayerView(data: videoData)
                        .showActions([.play, .share, .saveToPhotos])

                    // URLから再生
                    VideoPlayerView(url: fileURL)
                    """)
            }
        }
    }
}

#Preview {
    VideoPlayerCatalogView()
        .theme(ThemeProvider())
}

#endif
