import SwiftUI

#if canImport(UIKit)
import UIKit
import AVFoundation
import AVKit
import Photos
import PhotosUI
import UniformTypeIdentifiers

/// 動画ピッカーを表示するViewModifier
///
/// カメラまたは写真ライブラリから動画を選択できるモディファイア。
/// 適切な権限管理を行い、権限がない場合はアラートで通知します。
///
/// - Note: カメラとフォトライブラリの使用許可が必要です。
///   Info.plistに以下のキーを追加してください：
///   - `NSCameraUsageDescription`: カメラ使用の説明
///   - `NSPhotoLibraryUsageDescription`: フォトライブラリアクセスの説明
///   - `NSMicrophoneUsageDescription`: マイク使用の説明（動画撮影時に必要）
public struct VideoPickerModifier: ViewModifier {
    @Environment(\.colorPalette) private var colorPalette

    @Binding var isPresented: Bool
    @Binding var selectedVideoData: Data?

    @State private var sourceType: MediaSourceType?
    @State private var showPermissionAlert = false
    @State private var permissionAlertConfig: PermissionAlertConfig?

    let maxSize: ByteSize?
    let maxDuration: TimeInterval?
    let onError: ((VideoPickerError) -> Void)?

    public init(
        isPresented: Binding<Bool>,
        selectedVideoData: Binding<Data?>,
        maxSize: ByteSize? = nil,
        maxDuration: TimeInterval? = nil,
        onError: ((VideoPickerError) -> Void)? = nil
    ) {
        self._isPresented = isPresented
        self._selectedVideoData = selectedVideoData
        self.maxSize = maxSize
        self.maxDuration = maxDuration
        self.onError = onError
    }

    public func body(content: Content) -> some View {
        content
            .confirmationDialog(
                "動画を選択",
                isPresented: $isPresented,
                titleVisibility: .visible
            ) {
                // カメラが利用可能な場合のみ表示
                if UIImagePickerController.isSourceTypeAvailable(.camera) {
                    Button("動画を撮影") {
                        requestPermissionAndShowPicker(for: .camera)
                    }
                    .tint(Color(colorPalette.primary))
                }

                Button("動画ライブラリから選択") {
                    requestPermissionAndShowPicker(for: .photoLibrary)
                }
                .tint(Color(colorPalette.primary))

                Button("キャンセル", role: .cancel) {
                    isPresented = false
                }
            }
            // ライブラリからの選択はシートで表示
            .sheet(item: Binding(
                get: { sourceType == .photoLibrary ? sourceType : nil },
                set: { sourceType = $0 }
            )) { source in
                VideoPickerViewController(
                    sourceType: source.uiImagePickerSourceType,
                    selectedVideoData: $selectedVideoData,
                    isPresented: $sourceType,
                    maxSize: maxSize,
                    maxDuration: maxDuration,
                    onError: onError
                )
                .ignoresSafeArea()
            }
            // カメラはフルスクリーンで表示（iPadでの画質問題を回避）
            .fullScreenCover(item: Binding(
                get: { sourceType == .camera ? sourceType : nil },
                set: { sourceType = $0 }
            )) { source in
                VideoPickerViewController(
                    sourceType: source.uiImagePickerSourceType,
                    selectedVideoData: $selectedVideoData,
                    isPresented: $sourceType,
                    maxSize: maxSize,
                    maxDuration: maxDuration,
                    onError: onError
                )
                .ignoresSafeArea()
            }
            .alert(
                permissionAlertConfig?.title ?? "",
                isPresented: $showPermissionAlert,
                presenting: permissionAlertConfig
            ) { config in
                if config.canOpenSettings {
                    Button("設定を開く") {
                        openSettings()
                    }
                }
                Button("キャンセル", role: .cancel) {
                    isPresented = false
                }
            } message: { config in
                Text(config.message)
            }
    }

    /// 権限をリクエストしてピッカーを表示
    private func requestPermissionAndShowPicker(for source: MediaSourceType) {
        Task { @MainActor in
            let hasPermission = await checkPermission(for: source)

            if hasPermission {
                sourceType = source
            } else {
                // 権限がない場合はアラートを表示
                permissionAlertConfig = PermissionAlertConfig(
                    sourceType: source,
                    status: await getPermissionStatus(for: source)
                )
                showPermissionAlert = true
            }
        }
    }

    /// 権限状態を確認してリクエスト
    private func checkPermission(for source: MediaSourceType) async -> Bool {
        switch source {
        case .camera:
            // カメラと音声の両方の権限が必要
            let cameraPermission = await checkCameraPermission()
            let audioPermission = await checkAudioPermission()
            return cameraPermission && audioPermission
        case .photoLibrary:
            return await checkPhotoLibraryPermission()
        }
    }

    /// カメラ権限の確認とリクエスト
    private func checkCameraPermission() async -> Bool {
        let status = AVCaptureDevice.authorizationStatus(for: .video)

        switch status {
        case .authorized:
            return true
        case .notDetermined:
            return await AVCaptureDevice.requestAccess(for: .video)
        case .denied:
            return false
        case .restricted:
            return false
        @unknown default:
            return false
        }
    }

    /// マイク権限の確認とリクエスト
    private func checkAudioPermission() async -> Bool {
        let status = AVCaptureDevice.authorizationStatus(for: .audio)

        switch status {
        case .authorized:
            return true
        case .notDetermined:
            return await AVCaptureDevice.requestAccess(for: .audio)
        case .denied:
            return false
        case .restricted:
            return false
        @unknown default:
            return false
        }
    }

    /// フォトライブラリ権限の確認とリクエスト
    private func checkPhotoLibraryPermission() async -> Bool {
        let status = PHPhotoLibrary.authorizationStatus(for: .readWrite)

        switch status {
        case .authorized, .limited:
            return true
        case .notDetermined:
            let newStatus = await PHPhotoLibrary.requestAuthorization(for: .readWrite)
            return newStatus == .authorized || newStatus == .limited
        case .denied:
            return false
        case .restricted:
            return false
        @unknown default:
            return false
        }
    }

    /// 権限状態を取得
    private func getPermissionStatus(for source: MediaSourceType) async -> PermissionStatus {
        switch source {
        case .camera:
            let cameraStatus = AVCaptureDevice.authorizationStatus(for: .video)
            let audioStatus = AVCaptureDevice.authorizationStatus(for: .audio)

            if cameraStatus == .denied || audioStatus == .denied {
                return .denied
            }
            if cameraStatus == .restricted || audioStatus == .restricted {
                return .restricted
            }
            return .notDetermined
        case .photoLibrary:
            let status = PHPhotoLibrary.authorizationStatus(for: .readWrite)
            switch status {
            case .denied:
                return .denied
            case .restricted:
                return .restricted
            default:
                return .notDetermined
            }
        }
    }

    /// 設定画面を開く
    private func openSettings() {
        if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(settingsURL)
        }
    }
}

// MARK: - Video Picker Error

/// 動画ピッカーのエラー
public enum VideoPickerError: LocalizedError, Sendable {
    /// 動画の読み込みに失敗
    case loadFailed(String)
    /// 動画が長すぎる
    case durationExceeded(actual: TimeInterval, max: TimeInterval)
    /// ファイルサイズが大きすぎる
    case sizeExceeded(actual: ByteSize, max: ByteSize)

    public var errorDescription: String? {
        switch self {
        case .loadFailed(let message):
            return "動画の読み込みに失敗しました: \(message)"
        case .durationExceeded(let actual, let max):
            return String(format: "動画が長すぎます（%.0f秒）。最大%.0f秒までです。", actual, max)
        case .sizeExceeded(let actual, let max):
            return "ファイルサイズが大きすぎます（\(actual.formatted)）。最大\(max.formatted)までです。"
        }
    }
}

// MARK: - Video Picker View Controller

/// UIImagePickerControllerのSwiftUIラッパー（動画用）
struct VideoPickerViewController: UIViewControllerRepresentable {
    let sourceType: UIImagePickerController.SourceType
    @Binding var selectedVideoData: Data?
    @Binding var isPresented: MediaSourceType?
    let maxSize: ByteSize?
    let maxDuration: TimeInterval?
    let onError: ((VideoPickerError) -> Void)?

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = sourceType
        picker.mediaTypes = [UTType.movie.identifier]
        picker.delegate = context.coordinator

        // 高画質設定
        picker.videoQuality = .typeHigh
        picker.videoExportPreset = AVAssetExportPreset1920x1080

        // カメラの場合は動画撮影モード
        if sourceType == .camera {
            picker.cameraCaptureMode = .video
            // 背面カメラをデフォルトに
            if UIImagePickerController.isCameraDeviceAvailable(.rear) {
                picker.cameraDevice = .rear
            }

            // 最大録画時間を設定
            if let maxDuration = maxDuration {
                picker.videoMaximumDuration = maxDuration
            }
        }

        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
        // 更新不要
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: VideoPickerViewController

        init(_ parent: VideoPickerViewController) {
            self.parent = parent
        }

        func imagePickerController(
            _ picker: UIImagePickerController,
            didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
        ) {
            guard let videoURL = info[.mediaURL] as? URL else {
                parent.onError?(.loadFailed("動画URLの取得に失敗しました"))
                parent.isPresented = nil
                return
            }

            Task { @MainActor in
                do {
                    // 動画の長さを確認
                    let asset = AVURLAsset(url: videoURL)
                    let duration = try await asset.load(.duration)
                    let durationSeconds = CMTimeGetSeconds(duration)

                    if let maxDuration = parent.maxDuration, durationSeconds > maxDuration {
                        parent.onError?(.durationExceeded(actual: durationSeconds, max: maxDuration))
                        parent.isPresented = nil
                        return
                    }

                    // 動画データを読み込み
                    let videoData = try Data(contentsOf: videoURL)

                    // サイズを確認
                    if let maxSize = parent.maxSize, videoData.count > maxSize.bytes {
                        parent.onError?(.sizeExceeded(
                            actual: ByteSize(bytes: videoData.count),
                            max: maxSize
                        ))
                        parent.isPresented = nil
                        return
                    }

                    parent.selectedVideoData = videoData
                    parent.isPresented = nil

                } catch {
                    parent.onError?(.loadFailed(error.localizedDescription))
                    parent.isPresented = nil
                }
            }
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.isPresented = nil
        }
    }
}

// MARK: - Public Extension

public extension View {
    /// 動画ピッカーモディファイアを適用
    ///
    /// カメラまたは写真ライブラリから動画を選択できるモディファイア。
    /// 選択された動画はDataとして返されます。
    ///
    /// ```swift
    /// struct ContentView: View {
    ///     @State private var showPicker = false
    ///     @State private var videoData: Data?
    ///
    ///     var body: some View {
    ///         VStack {
    ///             if let videoData {
    ///                 Text("動画サイズ: \(videoData.count) bytes")
    ///             }
    ///
    ///             Button("動画を選択") {
    ///                 showPicker = true
    ///             }
    ///         }
    ///         .videoPicker(
    ///             isPresented: $showPicker,
    ///             selectedVideoData: $videoData,
    ///             maxSize: 50.mb,    // 50MB
    ///             maxDuration: 60    // 60秒
    ///         )
    ///     }
    /// }
    /// ```
    ///
    /// - Parameters:
    ///   - isPresented: ピッカーの表示状態を制御するバインディング
    ///   - selectedVideoData: 選択された動画のデータを受け取るバインディング
    ///   - maxSize: 動画の最大サイズ。指定された場合、超過するとエラーが発生します。
    ///   - maxDuration: 動画の最大長（秒）。カメラ撮影時は録画時間を制限します。
    ///   - onError: エラー発生時に呼ばれるコールバック
    /// - Returns: モディファイアが適用されたビュー
    func videoPicker(
        isPresented: Binding<Bool>,
        selectedVideoData: Binding<Data?>,
        maxSize: ByteSize? = nil,
        maxDuration: TimeInterval? = nil,
        onError: ((VideoPickerError) -> Void)? = nil
    ) -> some View {
        modifier(VideoPickerModifier(
            isPresented: isPresented,
            selectedVideoData: selectedVideoData,
            maxSize: maxSize,
            maxDuration: maxDuration,
            onError: onError
        ))
    }
}

#endif
