import SwiftUI

#if canImport(UIKit)
import UIKit
import AVFoundation
import Photos
import PhotosUI

/// 画像ピッカーを表示するViewModifier
///
/// カメラまたは写真ライブラリから画像を選択できるモディファイア。
/// 適切な権限管理を行い、権限がない場合はアラートで通知します。
///
/// - Note: カメラとフォトライブラリの使用許可が必要です。
///   Info.plistに以下のキーを追加してください：
///   - `NSCameraUsageDescription`: カメラ使用の説明
///   - `NSPhotoLibraryUsageDescription`: フォトライブラリアクセスの説明
public struct ImagePickerModifier: ViewModifier {
    @Environment(\.colorPalette) private var colorPalette

    @Binding var isPresented: Bool
    @Binding var selectedImageData: Data?

    @State private var sourceType: ImageSourceType?
    @State private var showPermissionAlert = false
    @State private var permissionAlertConfig: PermissionAlertConfig?

    let maxSizeInBytes: Int?
    let onCompressionError: ((Error) -> Void)?

    public init(
        isPresented: Binding<Bool>,
        selectedImageData: Binding<Data?>,
        maxSizeInBytes: Int? = nil,
        onCompressionError: ((Error) -> Void)? = nil
    ) {
        self._isPresented = isPresented
        self._selectedImageData = selectedImageData
        self.maxSizeInBytes = maxSizeInBytes
        self.onCompressionError = onCompressionError
    }

    public func body(content: Content) -> some View {
        content
            .confirmationDialog(
                "画像を選択",
                isPresented: $isPresented,
                titleVisibility: .visible
            ) {
                // カメラが利用可能な場合のみ表示
                if UIImagePickerController.isSourceTypeAvailable(.camera) {
                    Button("カメラで撮影") {
                        requestPermissionAndShowPicker(for: .camera)
                    }
                    .tint(Color(colorPalette.primary))
                }

                Button("写真ライブラリから選択") {
                    requestPermissionAndShowPicker(for: .photoLibrary)
                }
                .tint(Color(colorPalette.primary))

                Button("キャンセル", role: .cancel) {
                    isPresented = false
                }
            }
            .sheet(item: $sourceType) { source in
                ImagePickerViewController(
                    sourceType: source.uiImagePickerSourceType,
                    selectedImageData: $selectedImageData,
                    isPresented: $sourceType,
                    maxSizeInBytes: maxSizeInBytes,
                    onCompressionError: onCompressionError
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
    private func requestPermissionAndShowPicker(for source: ImageSourceType) {
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
    private func checkPermission(for source: ImageSourceType) async -> Bool {
        switch source {
        case .camera:
            return await checkCameraPermission()
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

    /// フォトライブラリ権限の確認とリクエスト
    private func checkPhotoLibraryPermission() async -> Bool {
        let status = PHPhotoLibrary.authorizationStatus(for: .addOnly)

        switch status {
        case .authorized, .limited:
            return true
        case .notDetermined:
            let newStatus = await PHPhotoLibrary.requestAuthorization(for: .addOnly)
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
    private func getPermissionStatus(for source: ImageSourceType) async -> PermissionStatus {
        switch source {
        case .camera:
            let status = AVCaptureDevice.authorizationStatus(for: .video)
            switch status {
            case .denied:
                return .denied
            case .restricted:
                return .restricted
            default:
                return .notDetermined
            }
        case .photoLibrary:
            let status = PHPhotoLibrary.authorizationStatus(for: .addOnly)
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

/// 画像ソースの種類
enum ImageSourceType: Identifiable {
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

    init(sourceType: ImageSourceType, status: PermissionStatus) {
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

/// UIImagePickerControllerのSwiftUIラッパー
struct ImagePickerViewController: UIViewControllerRepresentable {
    let sourceType: UIImagePickerController.SourceType
    @Binding var selectedImageData: Data?
    @Binding var isPresented: ImageSourceType?
    let maxSizeInBytes: Int?
    let onCompressionError: ((Error) -> Void)?

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = sourceType
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
        let parent: ImagePickerViewController

        init(_ parent: ImagePickerViewController) {
            self.parent = parent
        }

        func imagePickerController(
            _ picker: UIImagePickerController,
            didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
        ) {
            if let image = info[.originalImage] as? UIImage {
                // 画像をJPEGデータに変換
                if let maxSize = parent.maxSizeInBytes {
                    // サイズ制限がある場合は再帰的に圧縮
                    parent.selectedImageData = compressImageData(image, maxSizeInBytes: maxSize)
                } else {
                    // サイズ制限がない場合はデフォルト品質で変換
                    parent.selectedImageData = image.jpegData(compressionQuality: 0.8)
                }

                // エラーチェック
                if parent.selectedImageData == nil {
                    let error = NSError(
                        domain: "ImagePickerError",
                        code: -1,
                        userInfo: [NSLocalizedDescriptionKey: "画像の変換に失敗しました"]
                    )
                    parent.onCompressionError?(error)
                }
            }
            parent.isPresented = nil
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.isPresented = nil
        }

        /// 画像を指定されたサイズ以下に再帰的に圧縮
        /// - Parameters:
        ///   - image: 圧縮する画像
        ///   - maxSizeInBytes: 最大サイズ（バイト）
        ///   - currentQuality: 現在の圧縮品質（0.0〜1.0）
        /// - Returns: 圧縮された画像データ、または変換に失敗した場合はnil
        private func compressImageData(
            _ image: UIImage,
            maxSizeInBytes: Int,
            currentQuality: CGFloat = 0.8
        ) -> Data? {
            guard let data = image.jpegData(compressionQuality: currentQuality) else {
                return nil
            }

            // 既に上限以下なら何もしない
            if data.count <= maxSizeInBytes {
                return data
            }

            // 品質が下限に達したら現在のデータを返す
            if currentQuality <= 0.1 {
                return data
            }

            // 品質を10%下げて再帰的に圧縮
            return compressImageData(image, maxSizeInBytes: maxSizeInBytes, currentQuality: currentQuality - 0.1)
        }
    }
}

// MARK: - Public Extension

public extension View {
    /// 画像ピッカーモディファイアを適用
    ///
    /// カメラまたは写真ライブラリから画像を選択できるモディファイア。
    /// 選択された画像はJPEG形式のDataとして返されます。
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
    ///             maxSizeInBytes: 1_000_000  // 1MB
    ///         )
    ///     }
    /// }
    /// ```
    ///
    /// - Parameters:
    ///   - isPresented: ピッカーの表示状態を制御するバインディング
    ///   - selectedImageData: 選択された画像のデータを受け取るバインディング
    ///   - maxSizeInBytes: 画像の最大サイズ（バイト単位）。指定された場合、画像は自動的に圧縮されます。
    ///   - onCompressionError: 画像の圧縮または変換に失敗した場合に呼ばれるコールバック
    /// - Returns: モディファイアが適用されたビュー
    func imagePicker(
        isPresented: Binding<Bool>,
        selectedImageData: Binding<Data?>,
        maxSizeInBytes: Int? = nil,
        onCompressionError: ((Error) -> Void)? = nil
    ) -> some View {
        modifier(ImagePickerModifier(
            isPresented: isPresented,
            selectedImageData: selectedImageData,
            maxSizeInBytes: maxSizeInBytes,
            onCompressionError: onCompressionError
        ))
    }
}

#endif
