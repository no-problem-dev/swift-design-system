import SwiftUI

#if canImport(UIKit)
import UIKit
import AVKit
import Photos

/// 動画プレイヤービュー
///
/// 動画データまたはURLから動画を再生するコンポーネント。
/// 再生コントロール・メタデータ表示・共有/保存アクションを提供する。
///
/// ## 使用例
/// ```swift
/// // Dataから再生
/// VideoPlayerView(data: videoData)
///
/// // URLから再生
/// VideoPlayerView(url: videoURL)
///
/// // メタデータとアクション付き
/// VideoPlayerView(data: videoData)
///     .showMetadata(true)
///     .showActions([.share, .saveToPhotos])
/// ```
public struct VideoPlayerView: View {
    @Environment(\.colorPalette) private var colorPalette
    @Environment(\.spacingScale) private var spacing
    @Environment(\.radiusScale) private var radius

    private let source: VideoSource
    private var showMetadata: Bool = false
    private var actions: [VideoPlayerAction] = []

    @State private var player: AVPlayer?
    @State private var isPlaying = false
    @State private var tempFileURL: URL?
    @State private var videoMetadata: VideoMetadata?
    @State private var loadError: Error?
    @State private var showingShareSheet = false
    @State private var snackbarState = SnackbarState()
    @State private var isSaving = false

    // MARK: - Initializers

    /// Dataから初期化
    ///
    /// - Parameter data: 動画データ
    public init(data: Data) {
        self.source = .data(data)
    }

    /// URLから初期化
    ///
    /// - Parameter url: 動画のURL（ローカルまたはリモート）
    public init(url: URL) {
        self.source = .url(url)
    }

    // MARK: - Modifiers

    /// メタデータ表示を設定
    ///
    /// - Parameter show: メタデータを表示するかどうか
    /// - Returns: 設定が適用されたビュー
    public func showMetadata(_ show: Bool) -> VideoPlayerView {
        var view = self
        view.showMetadata = show
        return view
    }

    /// アクションボタンを設定
    ///
    /// - Parameter actions: 表示するアクション
    /// - Returns: 設定が適用されたビュー
    public func showActions(_ actions: [VideoPlayerAction]) -> VideoPlayerView {
        var view = self
        view.actions = actions
        return view
    }

    // MARK: - Body

    public var body: some View {
        VStack(alignment: .leading, spacing: spacing.md) {
            // 動画プレイヤー
            playerSection

            // メタデータ
            if showMetadata, let metadata = videoMetadata {
                metadataSection(metadata)
            }

            // アクションボタン
            if !actions.isEmpty && player != nil {
                actionsSection
            }
        }
        .padding(spacing.md)
        .onAppear {
            setupAudioSession()
            loadVideo()
        }
        .onDisappear {
            player?.pause()
            if !isSaving {
                cleanupTempFile()
            }
        }
        .sheet(isPresented: $showingShareSheet) {
            if let url = tempFileURL ?? source.localURL {
                ShareSheet(items: [url])
            }
        }
        .overlay(alignment: .bottom) {
            Snackbar(state: snackbarState)
        }
    }

    // MARK: - Sections

    @ViewBuilder
    private var playerSection: some View {
        Group {
            if let player = player {
                AVPlayerViewControllerRepresentable(player: player)
                    .frame(minHeight: 200)
            } else if let error = loadError {
                ContentUnavailableView(
                    "動画を読み込めません",
                    systemImage: "video.slash",
                    description: Text(error.localizedDescription)
                )
                .frame(minHeight: 200)
            } else {
                ProgressView("動画を読み込み中...")
                    .frame(maxWidth: .infinity, minHeight: 200)
            }
        }
        .frame(maxWidth: .infinity)
        .background(Color(colorPalette.surfaceVariant))
        .clipShape(RoundedRectangle(cornerRadius: radius.md))
    }

    private func metadataSection(_ metadata: VideoMetadata) -> some View {
        VStack(alignment: .leading, spacing: spacing.xs) {
            Text("動画情報")
                .font(.caption.bold())
                .foregroundStyle(Color(colorPalette.onSurfaceVariant))

            HStack(spacing: spacing.md) {
                if let duration = metadata.duration {
                    Label(formatDuration(duration), systemImage: "clock")
                }
                if let resolution = metadata.resolution {
                    Label(resolution, systemImage: "rectangle")
                }
                Label(metadata.size.formatted, systemImage: "doc")
            }
            .font(.caption)
            .foregroundStyle(Color(colorPalette.onSurfaceVariant))
        }
        .padding(spacing.sm)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(colorPalette.surfaceVariant).opacity(0.5))
        .clipShape(RoundedRectangle(cornerRadius: radius.sm))
    }

    private var actionsSection: some View {
        HStack(spacing: spacing.sm) {
            if actions.contains(.play) {
                Chip(
                    isPlaying ? "一時停止" : "再生",
                    systemImage: isPlaying ? "pause.fill" : "play.fill",
                    action: togglePlayback
                )
                .chipStyle(.outlined)
            }

            if actions.contains(.share) {
                Chip("共有", systemImage: "square.and.arrow.up", action: {
                    showingShareSheet = true
                })
                .chipStyle(.outlined)
            }

            if actions.contains(.saveToPhotos) {
                if isSaving {
                    HStack(spacing: spacing.xs) {
                        ProgressView()
                            .controlSize(.small)
                        Text("保存中...")
                            .typography(.labelMedium)
                            .foregroundStyle(Color(colorPalette.onSurfaceVariant))
                    }
                    .padding(.horizontal, spacing.md)
                    .padding(.vertical, spacing.xs)
                } else {
                    Chip("保存", systemImage: "square.and.arrow.down", action: saveToPhotos)
                        .chipStyle(.filled)
                }
            }
        }
    }

    // MARK: - Private Methods

    private func setupAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .moviePlayback)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Failed to setup audio session: \(error)")
        }
    }

    private func loadVideo() {
        Task { @MainActor in
            do {
                let url: URL

                switch source {
                case .data(let data):
                    // 一時ファイルに保存
                    let tempDir = FileManager.default.temporaryDirectory
                    let fileURL = tempDir.appendingPathComponent("\(UUID().uuidString).mp4")
                    try data.write(to: fileURL)
                    tempFileURL = fileURL
                    url = fileURL

                    // メタデータを取得
                    videoMetadata = await extractMetadata(from: url, dataSize: data.count)

                case .url(let sourceURL):
                    url = sourceURL

                    // メタデータを取得
                    if sourceURL.isFileURL {
                        let data = try Data(contentsOf: sourceURL)
                        videoMetadata = await extractMetadata(from: url, dataSize: data.count)
                    } else {
                        videoMetadata = await extractMetadata(from: url, dataSize: nil)
                    }
                }

                player = AVPlayer(url: url)

            } catch {
                loadError = error
            }
        }
    }

    private func extractMetadata(from url: URL, dataSize: Int?) async -> VideoMetadata {
        let asset = AVURLAsset(url: url)

        var duration: TimeInterval?
        var resolution: String?

        // 動画の長さを取得
        if let cmDuration = try? await asset.load(.duration) {
            duration = CMTimeGetSeconds(cmDuration)
        }

        // 解像度を取得
        if let tracks = try? await asset.loadTracks(withMediaType: .video),
           let track = tracks.first,
           let size = try? await track.load(.naturalSize) {
            let width = Int(size.width)
            let height = Int(size.height)
            resolution = "\(width)×\(height)"
        }

        let size = dataSize.map { ByteSize(bytes: $0) } ?? ByteSize(bytes: 0)

        return VideoMetadata(duration: duration, resolution: resolution, size: size)
    }

    private func cleanupTempFile() {
        if let url = tempFileURL {
            try? FileManager.default.removeItem(at: url)
        }
    }

    private func togglePlayback() {
        guard let player = player else { return }

        if isPlaying {
            player.pause()
        } else {
            player.seek(to: .zero)
            player.play()
        }
        isPlaying.toggle()
    }

    private func saveToPhotos() {
        guard let url = tempFileURL ?? source.localURL else {
            snackbarState.show(message: "保存する動画がありません")
            return
        }

        guard FileManager.default.fileExists(atPath: url.path) else {
            snackbarState.show(message: "動画ファイルが見つかりません")
            return
        }

        isSaving = true

        Task { @MainActor in
            defer { isSaving = false }

            do {
                let status = await PHPhotoLibrary.requestAuthorization(for: .addOnly)

                guard status == .authorized || status == .limited else {
                    snackbarState.show(
                        message: "写真ライブラリへのアクセスが許可されていません",
                        primaryAction: SnackbarAction(title: "設定を開く") {
                            if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                                await UIApplication.shared.open(settingsURL)
                            }
                        },
                        duration: 5.0
                    )
                    return
                }

                let fileURL = url
                try await PHPhotoLibrary.shared().performChanges { @Sendable in
                    PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: fileURL)
                }

                snackbarState.show(message: "カメラロールに保存しました ✓", duration: 3.0)
            } catch {
                snackbarState.show(
                    message: "保存に失敗しました: \(error.localizedDescription)",
                    duration: 5.0
                )
            }
        }
    }

    private func formatDuration(_ seconds: TimeInterval) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = seconds >= 3600 ? [.hour, .minute, .second] : [.minute, .second]
        formatter.zeroFormattingBehavior = .pad
        return formatter.string(from: seconds) ?? "\(Int(seconds))秒"
    }
}

// MARK: - Supporting Types

/// 動画プレイヤーのアクション
public enum VideoPlayerAction: Sendable, Hashable {
    /// 再生/一時停止ボタン
    case play
    /// 共有ボタン
    case share
    /// カメラロールに保存
    case saveToPhotos
}

/// 動画ソース
private enum VideoSource {
    case data(Data)
    case url(URL)

    var localURL: URL? {
        switch self {
        case .url(let url) where url.isFileURL:
            return url
        default:
            return nil
        }
    }
}

/// 動画メタデータ
private struct VideoMetadata {
    let duration: TimeInterval?
    let resolution: String?
    let size: ByteSize
}

// MARK: - Share Sheet

private struct ShareSheet: UIViewControllerRepresentable {
    let items: [Any]

    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: items, applicationActivities: nil)
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

private struct AVPlayerViewControllerRepresentable: UIViewControllerRepresentable {
    let player: AVPlayer

    func makeUIViewController(context: Context) -> AVPlayerViewController {
        let controller = AVPlayerViewController()
        controller.player = player
        controller.allowsVideoFrameAnalysis = false
        return controller
    }

    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {
        uiViewController.player = player
    }
}

#endif
