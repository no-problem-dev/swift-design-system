import SwiftUI

#if canImport(UIKit)

struct ImagePickerCatalogView: View {
    @Environment(\.colorPalette) private var colors
    @Environment(\.spacingScale) private var spacing
    @Environment(\.radiusScale) private var radius

    @State private var showPicker = false
    @State private var selectedImageData: Data?
    @State private var resizeChoice: ResizeChoice = .none

    /// The resize rules the demo can switch between, so the resulting dimensions and byte size can be compared.
    private enum ResizeChoice: String, CaseIterable {
        case none = "そのまま"
        case avatar = "square(720)"
        case photo = "longestEdge(1600)"

        var rule: ImageResizeRule? {
            switch self {
            case .none: return nil
            case .avatar: return .square(720)
            case .photo: return .longestEdge(1600)
            }
        }
    }

    var body: some View {
        CatalogPageContainer(title: "ImagePicker") {
            CatalogOverview(description: "カメラまたは写真ライブラリから画像を選択するモディファイア")

            SectionCard(title: "デモ") {
                VStack(spacing: spacing.lg) {
                    SegmentedControl(selection: $resizeChoice, options: ResizeChoice.allCases) { choice in
                        Text(choice.rawValue)
                    }

                    if let imageData = selectedImageData,
                       let uiImage = UIImage(data: imageData) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFit()
                            .frame(maxHeight: 200)
                            .clipShape(RoundedRectangle(cornerRadius: radius.md))

                        Text(result(for: imageData, image: uiImage))
                            .typography(.bodySmall)
                            .foregroundStyle(colors.onSurfaceVariant)
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
                    selectedImageData: $selectedImageData,
                    resize: resizeChoice.rule
                )
            }

            SectionCard(title: "機能") {
                VStack(alignment: .leading, spacing: spacing.md) {
                    FeatureRow(icon: "camera.fill", title: "カメラで新しい写真を撮影")
                    FeatureRow(icon: "photo.fill", title: "既存の写真から選択（権限不要）")
                    FeatureRow(icon: "arrow.down.right.and.arrow.up.left", title: "保存前に寸法を落とす（square / longestEdge）")
                    FeatureRow(icon: "rotate.right.fill", title: "リサイズ時に EXIF の向きを正規化")
                    FeatureRow(icon: "gearshape.fill", title: "カメラの権限拒否時は設定画面へ誘導")
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
                        resize: .square(720),
                        maxSize: 1.mb
                    )
                    """)
            }

            SectionCard(title: "Info.plist設定") {
                VStack(alignment: .leading, spacing: spacing.sm) {
                    InfoRow(label: "NSCameraUsageDescription", value: "カメラへのアクセス理由")

                    Text("写真ライブラリは PHPickerViewController で選ぶため権限が要らない。使わない権限を宣言すると審査で理由を問われる。")
                        .typography(.bodySmall)
                        .foregroundStyle(colors.onSurfaceVariant)
                }
            }

            SectionCard(title: "仕様") {
                VStack(alignment: .leading, spacing: spacing.sm) {
                    SpecItem(label: "戻り値", value: "Data? (JPEG形式)")
                    SpecItem(label: "JPEG品質", value: "80%（maxSize 指定時は 10% ずつ下げる）")
                    SpecItem(label: "処理順序", value: "リサイズ → JPEG化 → 品質")
                    SpecItem(label: "必要な権限", value: "カメラのみ")
                    SpecItem(label: "対応プラットフォーム", value: "iOS 17.0+")
                }
            }
        }
    }

    private func result(for data: Data, image: UIImage) -> String {
        let pixels = CGSize(width: image.size.width * image.scale, height: image.size.height * image.scale)
        return "\(Int(pixels.width)) × \(Int(pixels.height)) px / \(ByteSize(bytes: data.count).formatted)"
    }
}

#Preview {
    ImagePickerCatalogView()
        .theme(ThemeProvider())
}

#endif
