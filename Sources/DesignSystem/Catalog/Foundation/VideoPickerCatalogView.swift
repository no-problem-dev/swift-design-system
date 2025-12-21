import SwiftUI

#if canImport(UIKit)

/// 動画ピッカーモディファイアのカタログビュー
struct VideoPickerCatalogView: View {
    @Environment(\.colorPalette) private var colorPalette
    @Environment(\.spacingScale) private var spacing

    @State private var showPicker = false
    @State private var selectedVideoData: Data?
    @State private var errorMessage: String?

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // 概要
                VStack(alignment: .leading, spacing: 12) {
                    Text("カメラまたは動画ライブラリから動画を選択できるモディファイア")
                        .typography(.bodyMedium)
                        .foregroundStyle(colorPalette.onSurfaceVariant)
                        .padding(.horizontal, spacing.lg)

                    Text("適切な権限管理を行い、サイズや時間の制限をかけることができます。")
                        .typography(.bodySmall)
                        .foregroundStyle(colorPalette.onSurfaceVariant)
                        .padding(.horizontal, spacing.lg)
                }

                // デモ
                SectionCard(title: "デモ") {
                    VStack(spacing: spacing.lg) {
                        // 選択された動画の表示
                        if let videoData = selectedVideoData {
                            VideoPlayerView(data: videoData)
                                .showMetadata(true)
                                .showActions([.play])
                                .frame(height: 250)
                        } else {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(colorPalette.surfaceVariant)
                                .frame(height: 200)
                                .overlay {
                                    VStack(spacing: spacing.sm) {
                                        Image(systemName: "video")
                                            .font(.system(size: 48))
                                            .foregroundStyle(colorPalette.onSurfaceVariant)
                                        Text("動画が選択されていません")
                                            .typography(.bodySmall)
                                            .foregroundStyle(colorPalette.onSurfaceVariant)
                                    }
                                }
                        }

                        // エラーメッセージ
                        if let error = errorMessage {
                            Text(error)
                                .typography(.bodySmall)
                                .foregroundStyle(.red)
                                .padding(spacing.sm)
                                .background(Color.red.opacity(0.1))
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        }

                        // 動画選択ボタン
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

                        // クリアボタン（動画が選択されている場合のみ）
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

                // 機能説明
                SectionCard(title: "機能") {
                    VStack(alignment: .leading, spacing: spacing.md) {
                        FeatureRow(
                            icon: "video.fill",
                            title: "カメラで新しい動画を撮影"
                        )
                        FeatureRow(
                            icon: "photo.on.rectangle",
                            title: "既存の動画から選択"
                        )
                        FeatureRow(
                            icon: "timer",
                            title: "最大録画時間の制限"
                        )
                        FeatureRow(
                            icon: "doc.fill",
                            title: "ファイルサイズの制限"
                        )
                        FeatureRow(
                            icon: "lock.shield.fill",
                            title: "適切な権限リクエストとエラーハンドリング"
                        )
                    }
                }

                // 使用例
                SectionCard(title: "使用例") {
                    VStack(alignment: .leading, spacing: spacing.md) {
                        Text("基本的な使い方")
                            .typography(.titleSmall)

                        Text("""
                        struct ContentView: View {
                            @State private var showPicker = false
                            @State private var videoData: Data?

                            var body: some View {
                                VStack {
                                    if let videoData {
                                        VideoPlayerView(data: videoData)
                                    }

                                    Button("動画を選択") {
                                        showPicker = true
                                    }
                                }
                                .videoPicker(
                                    isPresented: $showPicker,
                                    selectedVideoData: $videoData,
                                    maxSize: 50.mb,
                                    maxDuration: 60
                                )
                            }
                        }
                        """)
                        .typography(.bodySmall)
                        .foregroundStyle(colorPalette.onSurfaceVariant)
                        .padding(spacing.md)
                        .background(colorPalette.surfaceVariant)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                }

                // Info.plist設定
                SectionCard(title: "Info.plist設定") {
                    VStack(alignment: .leading, spacing: spacing.md) {
                        Text("以下のキーを Info.plist に追加する必要があります：")
                            .typography(.bodyMedium)

                        VStack(alignment: .leading, spacing: spacing.sm) {
                            InfoRow(
                                label: "NSCameraUsageDescription",
                                value: "カメラへのアクセス理由を記述"
                            )
                            InfoRow(
                                label: "NSPhotoLibraryUsageDescription",
                                value: "写真ライブラリへのアクセス理由を記述"
                            )
                            InfoRow(
                                label: "NSMicrophoneUsageDescription",
                                value: "マイクへのアクセス理由を記述（動画撮影時に必要）"
                            )
                        }
                        .padding(spacing.md)
                        .background(colorPalette.surfaceVariant)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                }

                // ベストプラクティス
                SectionCard(title: "ベストプラクティス") {
                    VStack(alignment: .leading, spacing: spacing.sm) {
                        BestPracticeItem(
                            icon: "checkmark.circle.fill",
                            title: "ByteSize型",
                            description: "ファイルサイズの指定には直感的なByteSize型を使用（例: 50.mb）",
                            isGood: true
                        )
                        BestPracticeItem(
                            icon: "checkmark.circle.fill",
                            title: "時間制限",
                            description: "maxDurationでカメラ撮影時の最大録画時間を制限できます",
                            isGood: true
                        )
                        BestPracticeItem(
                            icon: "exclamationmark.triangle.fill",
                            title: "メモリ管理",
                            description: "動画ファイルは大きくなりがちなため、適切なサイズ制限を設けてください",
                            isGood: true
                        )
                        BestPracticeItem(
                            icon: "exclamationmark.triangle.fill",
                            title: "シミュレーター制限",
                            description: "シミュレーターではカメラが利用できないため、実機でのテストが推奨されます",
                            isGood: true
                        )
                    }
                }

                // 仕様
                SectionCard(title: "仕様") {
                    VStack(alignment: .leading, spacing: spacing.sm) {
                        SpecItem(label: "戻り値", value: "Data?")
                        SpecItem(label: "必要な権限", value: "カメラ、マイク、写真ライブラリ")
                        SpecItem(label: "対応プラットフォーム", value: "iOS 17.0+")
                        SpecItem(label: "サイズ制限", value: "ByteSize型で指定可能")
                        SpecItem(label: "時間制限", value: "TimeInterval（秒）で指定可能")
                    }
                }
            }
            .padding(.vertical, spacing.lg)
        }
    }
}

#Preview {
    VideoPickerCatalogView()
        .theme(ThemeProvider())
}

#endif
