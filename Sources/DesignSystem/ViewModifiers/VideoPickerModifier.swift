import SwiftUI

#if canImport(UIKit)
import UIKit
import AVFoundation
import AVKit
import Photos
import PhotosUI
import UniformTypeIdentifiers

/// Presents a video picker backed by the camera or the photo library.
///
/// Permissions are resolved before the picker is presented, and an alert explains the situation
/// when access has not been granted.
///
/// - Note: Both camera and photo library access are required.
///   Add the following keys to Info.plist:
///   - `NSCameraUsageDescription`: the reason for using the camera.
///   - `NSPhotoLibraryUsageDescription`: the reason for accessing the photo library.
///   - `NSMicrophoneUsageDescription`: the reason for using the microphone, needed when recording.
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
                // Shown only when a camera is available
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
            // Picking from the library is presented in a sheet
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
            // The camera is presented full screen, which avoids a quality problem on iPad
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

    private func requestPermissionAndShowPicker(for source: MediaSourceType) {
        Task { @MainActor in
            let hasPermission = await checkPermission(for: source)

            if hasPermission {
                sourceType = source
            } else {
                // Show the alert when permission has not been granted
                permissionAlertConfig = PermissionAlertConfig(
                    sourceType: source,
                    status: await getPermissionStatus(for: source)
                )
                showPermissionAlert = true
            }
        }
    }

    private func checkPermission(for source: MediaSourceType) async -> Bool {
        switch source {
        case .camera:
            // Recording needs both camera and microphone permission
            let cameraPermission = await checkCameraPermission()
            let audioPermission = await checkAudioPermission()
            return cameraPermission && audioPermission
        case .photoLibrary:
            return await checkPhotoLibraryPermission()
        }
    }

    /// Returns whether camera capture is authorized, asking the user when the status is undetermined.
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

    /// Returns whether audio capture is authorized, asking the user when the status is undetermined.
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

    /// Returns whether the photo library can be read, counting limited access as granted.
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

    /// The status shown in the alert. For the camera it is the stricter of camera and microphone.
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

    private func openSettings() {
        if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(settingsURL)
        }
    }
}

// MARK: - Video Picker Error

public enum VideoPickerError: LocalizedError, Sendable {
    /// Reading the picked video failed. The associated value describes the failure.
    case loadFailed(String)
    case durationExceeded(actual: TimeInterval, max: TimeInterval)
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

/// A SwiftUI wrapper around the system picker, configured for video.
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

        // High quality settings
        picker.videoQuality = .typeHigh
        picker.videoExportPreset = AVAssetExportPreset1920x1080

        // The camera opens in video capture mode
        if sourceType == .camera {
            picker.cameraCaptureMode = .video
            // Default to the rear camera
            if UIImagePickerController.isCameraDeviceAvailable(.rear) {
                picker.cameraDevice = .rear
            }

            // Set the longest allowed recording
            if let maxDuration = maxDuration {
                picker.videoMaximumDuration = maxDuration
            }
        }

        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
        // Nothing to update
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
                    // Check the duration
                    let asset = AVURLAsset(url: videoURL)
                    let duration = try await asset.load(.duration)
                    let durationSeconds = CMTimeGetSeconds(duration)

                    if let maxDuration = parent.maxDuration, durationSeconds > maxDuration {
                        parent.onError?(.durationExceeded(actual: durationSeconds, max: maxDuration))
                        parent.isPresented = nil
                        return
                    }

                    // Read the video data
                    let videoData = try Data(contentsOf: videoURL)

                    // Check the size
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
    /// Presents a video picker backed by the camera or the photo library.
    ///
    /// The picked video is returned as data.
    ///
    /// ```swift
    /// struct ContentView: View {
    ///     @State private var showPicker = false
    ///     @State private var videoData: Data?
    ///
    ///     var body: some View {
    ///         VStack {
    ///             if let videoData {
    ///                 Text("Video size: \(videoData.count) bytes")
    ///             }
    ///
    ///             Button("Select Video") {
    ///                 showPicker = true
    ///             }
    ///         }
    ///         .videoPicker(
    ///             isPresented: $showPicker,
    ///             selectedVideoData: $videoData,
    ///             maxSize: 50.mb,    // 50MB
    ///             maxDuration: 60    // 60 seconds
    ///         )
    ///     }
    /// }
    /// ```
    ///
    /// - Parameters:
    ///   - isPresented: A binding that controls whether the picker is shown.
    ///   - selectedVideoData: A binding that receives the data of the picked video.
    ///   - maxSize: The largest allowed size of the video. When given, exceeding it raises an error.
    ///   - maxDuration: The longest allowed video, in seconds. It also limits the recording length
    ///     when shooting with the camera.
    ///   - onError: A callback invoked when an error occurs.
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
