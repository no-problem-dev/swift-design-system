import SwiftUI

#if canImport(UIKit)

/// 画像ピッカーモディファイアのカタログビュー
struct ImagePickerCatalogView: View {
    @Environment(\.colorPalette) private var colors
    @Environment(\.spacingScale) private var spacing
    @Environment(\.radiusScale) private var radius

    @State private var showPicker = false
    @State private var selectedImageData: Data?

    var body: some View {
        CatalogPageContainer(title: "ImagePicker") {
            CatalogOverview(description: "カメラまたは写真ライブラリから画像を選択するモディファイア")

            SectionCard(title: "デモ") {
                VStack(spacing: spacing.lg) {
                    if let imageData = selectedImageData,
                       let uiImage = UIImage(data: imageData) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFit()
                            .frame(maxHeight: 200)
                            .clipShape(RoundedRectangle(cornerRadius: radius.md))
                    } else {
                        RoundedRectangle(cornerRadius: radius.md)
                            .fill(colors.surfaceVariant)
                            .frame(height: 200)
                            .overlay {
                                VStack(spacing: spacing.sm) {
                                    Image(systemName: "photo")
                                        .font(.system(size: 48))
                                        .foregroundStyle(colors.onSurfaceVariant)
                                    Text("画像を選択してください")
                                        .typography(.bodySmall)
                                        .foregroundStyle(colors.onSurfaceVariant)
                                }
                            }
                    }

                    Button {
                        showPicker = true
                    } label: {
                        Label(
                            selectedImageData == nil ? "画像を選択" : "画像を変更",
                            systemImage: "photo"
                        )
                    }
                    .buttonStyle(.primary)

                    if selectedImageData != nil {
                        Button {
                            selectedImageData = nil
                        } label: {
                            Label("クリア", systemImage: "trash")
                        }
                        .buttonStyle(.secondary)
                    }
                }
                .imagePicker(
                    isPresented: $showPicker,
                    selectedImageData: $selectedImageData
                )
            }

            SectionCard(title: "機能") {
                VStack(alignment: .leading, spacing: spacing.md) {
                    FeatureRow(icon: "camera.fill", title: "カメラで新しい写真を撮影")
                    FeatureRow(icon: "photo.fill", title: "既存の写真から選択")
                    FeatureRow(icon: "lock.shield.fill", title: "適切な権限リクエストとエラーハンドリング")
                    FeatureRow(icon: "gearshape.fill", title: "権限拒否時は設定画面へ誘導")
                }
            }

            SectionCard(title: "使用例") {
                CodeExample(code: """
                    @State private var showPicker = false
                    @State private var imageData: Data?

                    Button("画像を選択") {
                        showPicker = true
                    }
                    .imagePicker(
                        isPresented: $showPicker,
                        selectedImageData: $imageData,
                        maxSize: 1.mb
                    )
                    """)
            }

            SectionCard(title: "Info.plist設定") {
                VStack(alignment: .leading, spacing: spacing.sm) {
                    InfoRow(label: "NSCameraUsageDescription", value: "カメラへのアクセス理由")
                    InfoRow(label: "NSPhotoLibraryUsageDescription", value: "写真ライブラリへのアクセス理由")
                }
            }

            SectionCard(title: "仕様") {
                VStack(alignment: .leading, spacing: spacing.sm) {
                    SpecItem(label: "戻り値", value: "Data? (JPEG形式)")
                    SpecItem(label: "JPEG品質", value: "80%")
                    SpecItem(label: "必要な権限", value: "カメラ、写真ライブラリ")
                    SpecItem(label: "対応プラットフォーム", value: "iOS 17.0+")
                }
            }
        }
    }
}

#Preview {
    ImagePickerCatalogView()
        .theme(ThemeProvider())
}

#endif
