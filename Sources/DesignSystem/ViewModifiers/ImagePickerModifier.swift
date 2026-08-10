import SwiftUI

#if canImport(UIKit)
import UIKit
import AVFoundation
import PhotosUI

/// Presents an image picker backed by the camera or the photo library.
///
/// The camera needs permission to capture, so the permission is resolved before the picker is
/// presented; when it has been denied, an alert points the user to Settings.
/// The photo library needs no permission because it uses `PHPickerViewController`.
///
/// - Note: Only camera access is required. Add `NSCameraUsageDescription` (the reason for using
///   the camera) to Info.plist. `NSPhotoLibraryUsageDescription` is not needed, because the
///   selection is completed outside the app and the app never touches the library. Declaring a
///   permission the app does not use invites questions during review.
public struct ImagePickerModifier: ViewModifier {
    @Environment(\.colorPalette) private var colorPalette

    @Binding var isPresented: Bool
    @Binding var selectedImageData: Data?

    @State private var sourceType: MediaSourceType?
    @State private var showPermissionAlert = false
    @State private var permissionAlertConfig: PermissionAlertConfig?

    let source: ImagePickerSource
    let resize: ImageResizeRule?
    let maxSize: ByteSize?
    let onCompressionError: ((Error) -> Void)?

    public init(
        isPresented: Binding<Bool>,
        selectedImageData: Binding<Data?>,
        source: ImagePickerSource = .automatic,
        resize: ImageResizeRule? = nil,
        maxSize: ByteSize? = nil,
        onCompressionError: ((Error) -> Void)? = nil
    ) {
        self._isPresented = isPresented
        self._selectedImageData = selectedImageData
        self.source = source
        self.resize = resize
        self.maxSize = maxSize
        self.onCompressionError = onCompressionError
    }

    public func body(content: Content) -> some View {
        presentation(content)
            .sheet(item: $sourceType) { source in
                picker(for: source)
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

    @ViewBuilder
    private func picker(for source: MediaSourceType) -> some View {
        switch source {
        case .camera:
            CameraImagePicker(
                selectedImageData: $selectedImageData,
                isPresented: $sourceType,
                resize: resize,
                maxSize: maxSize,
                onCompressionError: onCompressionError
            )
        case .photoLibrary:
            PhotoLibraryImagePicker(
                selectedImageData: $selectedImageData,
                isPresented: $sourceType,
                resize: resize,
                maxSize: maxSize,
                onCompressionError: onCompressionError
            )
        }
    }

    @ViewBuilder
    private func presentation(_ content: Content) -> some View {
        switch source {
        case .automatic:
            content.confirmationDialog(
                "画像を選択",
                isPresented: $isPresented,
                titleVisibility: .visible
            ) {
                // Shown only when a camera is available
                if UIImagePickerController.isSourceTypeAvailable(.camera) {
                    Button("カメラで撮影") {
                        showCamera()
                    }
                    .tint(Color(colorPalette.primary))
                }

                Button("写真ライブラリから選択") {
                    sourceType = .photoLibrary
                }
                .tint(Color(colorPalette.primary))

                Button("キャンセル", role: .cancel) {
                    isPresented = false
                }
            }
        case .camera:
            content.onChange(of: isPresented) { _, newValue in
                guard newValue else { return }
                isPresented = false
                showCamera()
            }
        case .photoLibrary:
            content.onChange(of: isPresented) { _, newValue in
                guard newValue else { return }
                isPresented = false
                // PHPickerViewController needs no permission, so present it directly
                sourceType = .photoLibrary
            }
        }
    }

    /// Presents the camera once capture is authorized, and shows the permission alert otherwise.
    ///
    /// Capture requires authorization from `AVCaptureDevice`, so it is resolved first.
    private func showCamera() {
        Task { @MainActor in
            if await requestCameraPermission() {
                sourceType = .camera
            } else {
                permissionAlertConfig = PermissionAlertConfig(
                    sourceType: .camera,
                    status: cameraPermissionStatus()
                )
                showPermissionAlert = true
            }
        }
    }

    /// Returns whether camera capture is authorized, asking the user when the status is undetermined.
    private func requestCameraPermission() async -> Bool {
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

    private func cameraPermissionStatus() -> PermissionStatus {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .denied:
            return .denied
        case .restricted:
            return .restricted
        default:
            return .notDetermined
        }
    }

    private func openSettings() {
        if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(settingsURL)
        }
    }
}

// MARK: - Public Types

/// Which source the picker is presented from.
///
/// - `automatic`: shows a dialog to choose between the camera and the photo library when a camera
///   is available, and goes straight to the library when it is not.
/// - `camera`: presents the camera directly, without the choice dialog.
/// - `photoLibrary`: presents the photo library directly, without the choice dialog.
public enum ImagePickerSource: Sendable {
    case automatic
    case camera
    case photoLibrary
}

// MARK: - Shared Types

enum MediaSourceType: Identifiable {
    case camera
    case photoLibrary

    var id: String {
        switch self {
        case .camera: return "camera"
        case .photoLibrary: return "photoLibrary"
        }
    }

    var uiImagePickerSourceType: UIImagePickerController.SourceType {
        switch self {
        case .camera: return .camera
        case .photoLibrary: return .photoLibrary
        }
    }
}

enum PermissionStatus {
    case notDetermined
    case denied
    case restricted
}

/// The wording of the permission alert, derived from the source and its authorization status.
struct PermissionAlertConfig {
    let title: String
    let message: String
    let canOpenSettings: Bool

    init(sourceType: MediaSourceType, status: PermissionStatus) {
        switch sourceType {
        case .camera:
            self.title = "カメラへのアクセス許可が必要です"
            switch status {
            case .denied:
                self.message = "設定からカメラへのアクセスを許可してください。"
                self.canOpenSettings = true
            case .restricted:
                self.message = "カメラへのアクセスが制限されています。デバイスの設定またはペアレンタルコントロールを確認してください。"
                self.canOpenSettings = false
            case .notDetermined:
                self.message = "カメラを使用するには、アクセス許可が必要です。"
                self.canOpenSettings = false
            }
        case .photoLibrary:
            self.title = "写真へのアクセス許可が必要です"
            switch status {
            case .denied:
                self.message = "設定から写真へのアクセスを許可してください。"
                self.canOpenSettings = true
            case .restricted:
                self.message = "写真へのアクセスが制限されています。デバイスの設定またはペアレンタルコントロールを確認してください。"
                self.canOpenSettings = false
            case .notDetermined:
                self.message = "写真ライブラリを使用するには、アクセス許可が必要です。"
                self.canOpenSettings = false
            }
        }
    }
}

/// The error reported when converting a picked image fails.
///
/// - Note: This is the value handed to `onCompressionError`. It stays an `NSError` with the same
///   domain and code, because call sites may be inspecting them.
private func imageConversionError() -> NSError {
    NSError(
        domain: "ImagePickerError",
        code: -1,
        userInfo: [NSLocalizedDescriptionKey: "画像の変換に失敗しました"]
    )
}

// MARK: - Camera

/// A SwiftUI wrapper around taking a photo with the camera.
///
/// Capture is only possible through `UIImagePickerController`, so unlike the library side this
/// one is not replaced.
struct CameraImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImageData: Data?
    @Binding var isPresented: MediaSourceType?
    let resize: ImageResizeRule?
    let maxSize: ByteSize?
    let onCompressionError: ((Error) -> Void)?

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
        // Nothing to update
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: CameraImagePicker

        init(_ parent: CameraImagePicker) {
            self.parent = parent
        }

        func imagePickerController(
            _ picker: UIImagePickerController,
            didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
        ) {
            if let image = info[.originalImage] as? UIImage {
                let data = image.jpegData(resize: parent.resize, maxSize: parent.maxSize)
                parent.selectedImageData = data

                if data == nil {
                    parent.onCompressionError?(imageConversionError())
                }
            }
            parent.isPresented = nil
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.isPresented = nil
        }
    }
}

// MARK: - Photo Library

/// A SwiftUI wrapper around picking an image from the photo library.
///
/// It uses `PHPickerViewController` because the selection is completed outside the app, in a
/// separate process, so the app never touches the whole library and no photo permission has to be
/// requested. That holds only while `PHPickerConfiguration` is created without `photoLibrary:`;
/// passing a library in turns it into a configuration that does require permission.
struct PhotoLibraryImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImageData: Data?
    @Binding var isPresented: MediaSourceType?
    let resize: ImageResizeRule?
    let maxSize: ByteSize?
    let onCompressionError: ((Error) -> Void)?

    func makeUIViewController(context: Context) -> PHPickerViewController {
        var configuration = PHPickerConfiguration()
        configuration.filter = .images
        configuration.selectionLimit = 1

        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {
        // Nothing to update
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        let parent: PhotoLibraryImagePicker

        init(_ parent: PhotoLibraryImagePicker) {
            self.parent = parent
        }

        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            guard let provider = results.first?.itemProvider,
                  provider.canLoadObject(ofClass: UIImage.self) else {
                // Also reached when the picker is closed without a selection
                parent.isPresented = nil
                return
            }

            let resize = parent.resize
            let maxSize = parent.maxSize

            Task { @MainActor in
                do {
                    parent.selectedImageData = try await Self.imageData(
                        from: provider,
                        resize: resize,
                        maxSize: maxSize
                    )
                } catch {
                    parent.onCompressionError?(error)
                }
                parent.isPresented = nil
            }
        }

        /// Loads the picked image and converts it to data.
        ///
        /// The completion of `loadObject` is called off the main thread, so even redrawing a 12MP
        /// image does not land on the responsiveness of the interface.
        ///
        /// The function itself sits on the main actor because `NSItemProvider` is not `Sendable`
        /// and cannot be passed across isolation. The only thing the completion closure carries
        /// back out is `Data`.
        @MainActor
        private static func imageData(
            from provider: NSItemProvider,
            resize: ImageResizeRule?,
            maxSize: ByteSize?
        ) async throws -> Data {
            try await withCheckedThrowingContinuation { continuation in
                provider.loadObject(ofClass: UIImage.self) { object, error in
                    if let error {
                        continuation.resume(throwing: error)
                        return
                    }
                    guard let image = object as? UIImage,
                          let data = image.jpegData(resize: resize, maxSize: maxSize) else {
                        continuation.resume(throwing: imageConversionError())
                        return
                    }
                    continuation.resume(returning: data)
                }
            }
        }
    }
}

// MARK: - Public Extension

public extension View {
    /// Presents an image picker backed by the camera or the photo library.
    ///
    /// The picked image is returned as JPEG data.
    ///
    /// ```swift
    /// struct ContentView: View {
    ///     @State private var showPicker = false
    ///     @State private var imageData: Data?
    ///
    ///     var body: some View {
    ///         VStack {
    ///             if let imageData, let uiImage = UIImage(data: imageData) {
    ///                 Image(uiImage: uiImage)
    ///                     .resizable()
    ///                     .scaledToFit()
    ///                     .frame(height: 200)
    ///             }
    ///
    ///             Button("Select Image") {
    ///                 showPicker = true
    ///             }
    ///         }
    ///         .imagePicker(
    ///             isPresented: $showPicker,
    ///             selectedImageData: $imageData,
    ///             resize: .square(720),  // center-crop for an avatar
    ///             maxSize: 1.mb          // 1MB
    ///         )
    ///     }
    /// }
    /// ```
    ///
    /// - Parameters:
    ///   - isPresented: A binding that controls whether the picker is shown.
    ///   - selectedImageData: A binding that receives the data of the picked image.
    ///   - source: The source to present from. Passing `.camera` or `.photoLibrary` presents it
    ///     directly, without the choice dialog.
    ///   - resize: A rule for reducing the dimensions before storing. Passing one also normalizes
    ///     the orientation to `.up`.
    ///   - maxSize: The largest allowed size of the image. When given, quality is lowered after
    ///     `resize` until the data fits.
    ///   - onCompressionError: A callback invoked when compressing or converting the image fails.
    func imagePicker(
        isPresented: Binding<Bool>,
        selectedImageData: Binding<Data?>,
        source: ImagePickerSource = .automatic,
        resize: ImageResizeRule? = nil,
        maxSize: ByteSize? = nil,
        onCompressionError: ((Error) -> Void)? = nil
    ) -> some View {
        modifier(ImagePickerModifier(
            isPresented: isPresented,
            selectedImageData: selectedImageData,
            source: source,
            resize: resize,
            maxSize: maxSize,
            onCompressionError: onCompressionError
        ))
    }
}

#endif
