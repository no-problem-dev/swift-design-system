import SwiftUI

#if canImport(UIKit)

/// 動画ピッカーモディファイアのカタログビュー
struct VideoPickerCatalogView: View {
    @Environment(\.colorPalette) private var colors
    @Environment(\.spacingScale) private var spacing
    @Environment(\.radiusScale) private var radius

    @State private var showPicker = false
    @State private var selectedVideoData: Data?
    @State private var errorMessage: String?

    var body: some View {
        CatalogPageContainer(title: "VideoPicker") {
            CatalogOverview(description: "カメラまたは動画ライブラリから動画を選択するモディファイア")

            SectionCard(title: "デモ") {
                VStack(spacing: spacing.lg) {
                    if let videoData = selectedVideoData {
                        VideoPlayerView(data: videoData)
                            .showMetadata(true)
                            .showActions([.share, .saveToPhotos])
                            .frame(height: 280)
                    } else {
                        RoundedRectangle(cornerRadius: radius.md)
                            .fill(colors.surfaceVariant)
                            .frame(height: 200)
                            .overlay {
                                VStack(spacing: spacing.sm) {
                                    Image(systemName: "video")
                                        .font(.system(size: 48))
                                        .foregroundStyle(colors.onSurfaceVariant)
                                    Text("動画を選択してください")
                                        .typography(.bodySmall)
                                        .foregroundStyle(colors.onSurfaceVariant)
                                }
                            }
                    }

                    if let error = errorMessage {
                        Text(error)
                            .typography(.bodySmall)
                            .foregroundStyle(colors.error)
                            .padding(spacing.sm)
                            .background(colors.errorContainer)
                            .clipShape(RoundedRectangle(cornerRadius: radius.sm))
                    }

                    Button {
                        showPicker = true
                        errorMessage = nil
                    } label: {
                        Label(
                            selectedVideoData == nil ? "動画を選択" : "動画を変更",
                            systemImage: "video"
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
                    maxSize: 50.mb,
                    maxDuration: 60
                ) { error in
                    errorMessage = error.localizedDescription
                }
            }

            SectionCard(title: "機能") {
                VStack(alignment: .leading, spacing: spacing.md) {
                    FeatureRow(icon: "video.fill", title: "カメラで新しい動画を撮影")
                    FeatureRow(icon: "photo.on.rectangle", title: "既存の動画から選択")
                    FeatureRow(icon: "timer", title: "最大録画時間の制限")
                    FeatureRow(icon: "doc.fill", title: "ファイルサイズの制限")
                    FeatureRow(icon: "lock.shield.fill", title: "適切な権限リクエスト")
                }
            }

            SectionCard(title: "使用例") {
                CodeExample(code: """
                    @State private var showPicker = false
                    @State private var videoData: Data?

                    Button("動画を選択") {
                        showPicker = true
                    }
                    .videoPicker(
                        isPresented: $showPicker,
                        selectedVideoData: $videoData,
                        maxSize: 50.mb,
                        maxDuration: 60
                    )
                    """)
            }

            SectionCard(title: "Info.plist設定") {
                VStack(alignment: .leading, spacing: spacing.sm) {
                    InfoRow(label: "NSCameraUsageDescription", value: "カメラへのアクセス理由")
                    InfoRow(label: "NSPhotoLibraryUsageDescription", value: "写真ライブラリへのアクセス理由")
                    InfoRow(label: "NSMicrophoneUsageDescription", value: "マイクへのアクセス理由")
                }
            }

            SectionCard(title: "仕様") {
                VStack(alignment: .leading, spacing: spacing.sm) {
                    SpecItem(label: "戻り値", value: "Data?")
                    SpecItem(label: "必要な権限", value: "カメラ、マイク、写真ライブラリ")
                    SpecItem(label: "対応プラットフォーム", value: "iOS 17.0+")
                    SpecItem(label: "サイズ制限", value: "ByteSize型で指定")
                    SpecItem(label: "時間制限", value: "TimeInterval（秒）")
                }
            }
        }
    }
}

#Preview {
    VideoPickerCatalogView()
        .theme(ThemeProvider())
}

#endif
