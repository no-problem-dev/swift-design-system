import SwiftUI

struct MediaViewerCatalogView: View {
    @Environment(\.colorPalette) private var colors
    @Environment(\.spacingScale) private var spacing
    @Environment(\.radiusScale) private var radius

    private let sampleImageURLs: [URL] = [
        URL(string: "https://images.pexels.com/photos/9002742/pexels-photo-9002742.jpeg?cs=srgb&fm=jpg&w=640&h=405")!,
        URL(string: "https://images.pexels.com/photos/7135121/pexels-photo-7135121.jpeg?cs=srgb&fm=jpg&w=640&h=427")!,
        URL(string: "https://images.pexels.com/photos/18873058/pexels-photo-18873058.jpeg?cs=srgb&fm=jpg&w=640&h=450")!
    ]

    private let sampleVideoURL = URL(string: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4")!

    var body: some View {
        CatalogPageContainer(title: "MediaViewer") {
            CatalogOverview(description: "タップでメディアをフルスクリーン表示するビューア。ヒーロー展開・ピンチズーム・下方向ドラッグで閉じる操作に対応（iOS 18+）")

            SectionCard(title: "画像デモ") {
                HStack(spacing: spacing.sm) {
                    ForEach(sampleImageURLs, id: \.self) { url in
                        AsyncImage(url: url) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        } placeholder: {
                            Rectangle()
                                .fill(colors.surfaceVariant)
                                .overlay {
                                    ProgressView()
                                }
                        }
                        .frame(height: 100)
                        .clipShape(RoundedRectangle(cornerRadius: radius.md))
                        .mediaViewable(.image(url))
                    }
                }
            }

            SectionCard(title: "動画デモ") {
                RoundedRectangle(cornerRadius: radius.md)
                    .fill(colors.surfaceVariant)
                    .frame(height: 120)
                    .overlay {
                        VStack(spacing: spacing.sm) {
                            Image(systemName: "play.rectangle.fill")
                                .font(.system(size: 36))
                                .foregroundStyle(colors.onSurfaceVariant)
                            Text("タップしてフルスクリーン再生")
                                .typography(.bodySmall)
                                .foregroundStyle(colors.onSurfaceVariant)
                        }
                    }
                    .mediaViewable(.video(sampleVideoURL))
            }

            SectionCard(title: "機能") {
                VStack(alignment: .leading, spacing: spacing.md) {
                    FeatureRow(icon: "rectangle.expand.vertical", title: "サムネイル位置からのヒーロー展開")
                    FeatureRow(icon: "arrow.up.left.and.arrow.down.right", title: "2本指ピンチズーム")
                    FeatureRow(icon: "chevron.down", title: "下方向ドラッグで閉じる（背景フェード連動）")
                    FeatureRow(icon: "play.rectangle", title: "動画・オーディオの AVPlayer 再生")
                    FeatureRow(icon: "iphone", title: "iOS 18+ のみ。その他の環境では従来挙動")
                }
            }

            SectionCard(title: "使用例") {
                CodeExample(code: """
                    // 画像をタップでフルスクリーン表示
                    AsyncImage(url: imageURL) { image in
                        image.resizable().scaledToFit()
                    } placeholder: {
                        ProgressView()
                    }
                    .mediaViewable(.image(imageURL))

                    // 動画サムネイルをタップでアプリ内再生
                    thumbnailView
                        .mediaViewable(.video(videoURL))

                    // 無効化（条件付き）
                    imageView
                        .mediaViewable(.image(url), enabled: isViewerEnabled)
                    """)
            }
        }
    }
}

#Preview {
    MediaViewerCatalogView()
        .theme(ThemeProvider())
}
