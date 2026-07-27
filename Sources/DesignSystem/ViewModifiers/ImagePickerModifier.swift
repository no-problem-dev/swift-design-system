import SwiftUI

#if canImport(UIKit)
import UIKit
import AVFoundation
import PhotosUI

/// 画像ピッカーを表示する ViewModifier。
///
/// カメラまたは写真ライブラリから画像を選択できるモディファイア。
/// カメラは撮影の許可が要るため、権限を取ってから提示し、拒否されていればアラートで設定へ誘導する。
/// 写真ライブラリは `PHPickerViewController` を使うので権限を必要としない。
///
/// - Note: カメラの使用許可だけが必要。Info.plist に `NSCameraUsageDescription`（カメラ使用の説明）を
///   追加すること。写真ライブラリ側は選択がアプリの外で完結し、アプリがライブラリへ触れないため、
///   `NSPhotoLibraryUsageDescription` は要らない。使っていない権限を宣言すると審査で理由を問われる。
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
                // カメラが利用可能な場合のみ表示
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
                // PHPickerViewController は権限を必要としないので、そのまま提示する
                sourceType = .photoLibrary
            }
        }
    }

    /// カメラの権限を取ってから提示する。撮影は `AVCaptureDevice` の許可が要るため。
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

    /// カメラ権限の確認とリクエスト
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

    /// カメラ権限の状態を取得
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

    /// 設定画面を開く
    private func openSettings() {
        if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(settingsURL)
        }
    }
}

// MARK: - Public Types

/// 画像ピッカーの提示ソース
///
/// - `automatic`: カメラ利用可なら「カメラ / 写真ライブラリ」の選択ダイアログを出し、不可ならライブラリへ直行する。
/// - `camera`: 選択ダイアログを出さずカメラを直接提示する。
/// - `photoLibrary`: 選択ダイアログを出さず写真ライブラリを直接提示する。
public enum ImagePickerSource: Sendable {
    case automatic
    case camera
    case photoLibrary
}

// MARK: - Shared Types

/// メディアソースの種類
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

/// 権限の状態
enum PermissionStatus {
    case notDetermined
    case denied
    case restricted
}

/// 権限アラートの設定
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

/// 変換に失敗したときのエラー。
///
/// - Note: `onCompressionError` に渡る値。既存の呼び出し側が domain / code を見ている可能性があるため、
///   従来と同じ `NSError` のまま保つ。
private func imageConversionError() -> NSError {
    NSError(
        domain: "ImagePickerError",
        code: -1,
        userInfo: [NSLocalizedDescriptionKey: "画像の変換に失敗しました"]
    )
}

// MARK: - Camera

/// カメラ撮影の SwiftUI ラッパー。
///
/// 撮影は `UIImagePickerController` でしか行えないため、ライブラリ側と違ってここは置き換えない。
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
        // 更新不要
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

/// 写真ライブラリ選択の SwiftUI ラッパー。
///
/// `PHPickerViewController` を使うのは、選択がアプリの外（別プロセス）で完結し、アプリが
/// ライブラリ全体に触れないため、写真の権限を要求せずに済むから。`PHPickerConfiguration` を
/// `photoLibrary:` なしで作ることがその条件——ライブラリを渡すと権限が必要な構成になる。
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
        // 更新不要
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
                // 選択せずに閉じた場合もここに来る
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

        /// 読み込みと変換を行う。`loadObject` の完了は main の外で呼ばれるので、12MP の描き直しも
        /// 画面の応答には載らない。
        ///
        /// この関数自体を MainActor に置いているのは、`NSItemProvider` が Sendable ではなく、
        /// 隔離をまたいで渡せないから。完了クロージャが外へ持ち出すのは `Data` だけにしてある。
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
    /// 画像ピッカーモディファイアを適用する。
    ///
    /// カメラまたは写真ライブラリから画像を選択できるモディファイア。
    /// 選択された画像は JPEG 形式の Data として返される。
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
    ///             Button("画像を選択") {
    ///                 showPicker = true
    ///             }
    ///         }
    ///         .imagePicker(
    ///             isPresented: $showPicker,
    ///             selectedImageData: $imageData,
    ///             resize: .square(720),  // アバター用に center-crop
    ///             maxSize: 1.mb          // 1MB
    ///         )
    ///     }
    /// }
    /// ```
    ///
    /// - Parameters:
    ///   - isPresented: ピッカーの表示状態を制御するバインディング
    ///   - selectedImageData: 選択された画像のデータを受け取るバインディング
    ///   - source: 提示ソース。`.camera` / `.photoLibrary` を指定すると選択ダイアログを出さず直接提示する。
    ///   - resize: 保存前に寸法を落とす規則。指定すると向きも `.up` へ正規化される。
    ///   - maxSize: 画像の最大サイズ。指定された場合、`resize` の後に品質を下げて収める。
    ///   - onCompressionError: 画像の圧縮または変換に失敗した場合に呼ばれるコールバック
    /// - Returns: モディファイアが適用されたビュー
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
