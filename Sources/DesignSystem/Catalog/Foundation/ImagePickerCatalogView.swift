import SwiftUI

#if canImport(UIKit)

/// 画像ピッカーモディファイアのカタログビュー
struct ImagePickerCatalogView: View {
    @Environment(\.colorPalette) private var colorPalette
    @Environment(\.spacingScale) private var spacing

    @State private var showPicker = false
    @State private var selectedImageData: Data?

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // 概要
                VStack(alignment: .leading, spacing: 12) {
                    Text("カメラまたは写真ライブラリから画像を選択できるモディファイア")
                        .typography(.bodyMedium)
                        .foregroundStyle(colorPalette.onSurfaceVariant)
                        .padding(.horizontal, spacing.lg)

                    Text("適切な権限管理を行い、権限がない場合はアラートで通知します。")
                        .typography(.bodySmall)
                        .foregroundStyle(colorPalette.onSurfaceVariant)
                        .padding(.horizontal, spacing.lg)
                }

                // デモ
                SectionCard(title: "デモ") {
                    VStack(spacing: spacing.lg) {
                        // 選択された画像の表示
                        if let imageData = selectedImageData,
                           let uiImage = UIImage(data: imageData) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFit()
                                .frame(maxHeight: 200)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                        } else {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(colorPalette.surfaceVariant)
                                .frame(height: 200)
                                .overlay {
                                    VStack(spacing: spacing.sm) {
                                        Image(systemName: "photo")
                                            .font(.system(size: 48))
                                            .foregroundStyle(colorPalette.onSurfaceVariant)
                                        Text("画像が選択されていません")
                                            .typography(.bodySmall)
                                            .foregroundStyle(colorPalette.onSurfaceVariant)
                                    }
                                }
                        }

                        // 画像選択ボタン
                        Button {
                            showPicker = true
                        } label: {
                            Label(
                                selectedImageData == nil ? "画像を選択" : "画像を変更",
                                systemImage: "photo"
                            )
                        }
                        .buttonStyle(.primary)

                        // クリアボタン（画像が選択されている場合のみ）
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

                // 機能説明
                SectionCard(title: "機能") {
                    VStack(alignment: .leading, spacing: spacing.md) {
                        FeatureRow(
                            icon: "camera.fill",
                            title: "カメラで新しい写真を撮影"
                        )
                        FeatureRow(
                            icon: "photo.fill",
                            title: "既存の写真から選択"
                        )
                        FeatureRow(
                            icon: "lock.shield.fill",
                            title: "適切な権限リクエストとエラーハンドリング"
                        )
                        FeatureRow(
                            icon: "gearshape.fill",
                            title: "権限拒否時は設定画面へ誘導"
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
                            @State private var imageData: Data?

                            var body: some View {
                                VStack {
                                    if let imageData,
                                       let uiImage = UIImage(data: imageData) {
                                        Image(uiImage: uiImage)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(height: 200)
                                    }

                                    Button("画像を選択") {
                                        showPicker = true
                                    }
                                }
                                .imagePicker(
                                    isPresented: $showPicker,
                                    selectedImageData: $imageData
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
                            title: "画像形式",
                            description: "選択された画像はJPEG形式のDataとして返されます（品質80%）",
                            isGood: true
                        )
                        BestPracticeItem(
                            icon: "exclamationmark.triangle.fill",
                            title: "シミュレーター制限",
                            description: "シミュレーターではカメラが利用できないため、実機でのテストが推奨されます",
                            isGood: true
                        )
                        BestPracticeItem(
                            icon: "checkmark.circle.fill",
                            title: "権限リクエスト",
                            description: "権限リクエストは一度のみ表示されます。拒否後はアラートで設定画面への誘導を行います",
                            isGood: true
                        )
                        BestPracticeItem(
                            icon: "exclamationmark.triangle.fill",
                            title: "メモリ管理",
                            description: "画像データはメモリに保持されるため、大きな画像を扱う場合は適切な圧縮やリサイズを検討してください",
                            isGood: true
                        )
                    }
                }

                // 仕様
                SectionCard(title: "仕様") {
                    VStack(alignment: .leading, spacing: spacing.sm) {
                        SpecItem(label: "戻り値", value: "Data? (JPEG形式)")
                        SpecItem(label: "JPEG品質", value: "80%")
                        SpecItem(label: "必要な権限", value: "カメラ、写真ライブラリ")
                        SpecItem(label: "対応プラットフォーム", value: "iOS 17.0+")
                    }
                }
            }
            .padding(.vertical, spacing.lg)
        }
    }
}

#Preview {
    ImagePickerCatalogView()
        .theme(ThemeProvider())
}

#endif
