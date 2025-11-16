import SwiftUI

/// ColorPickerのカタログビュー
struct ColorPickerCatalogView: View {
    @Environment(\.colorPalette) private var colorPalette
    @Environment(\.spacingScale) private var spacing

    @State private var selectedColor1: String?
    @State private var selectedColor2: String?
    @State private var showColorPicker1 = false
    @State private var showColorPicker2 = false

    var body: some View {
        ScrollView {
            VStack(spacing: spacing.xl) {
                // ヘッダー
                headerSection

                // 基本的な使用例
                basicUsageSection

                // プリセットバリエーション
                presetVariationsSection

                // 使用例コード
                codeExampleSection
            }
            .padding(spacing.lg)
        }
        .background(colorPalette.background)
        .navigationTitle("ColorPicker")
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
    }

    private var headerSection: some View {
        VStack(spacing: spacing.md) {
            Image(systemName: "paintpalette.fill")
                .font(.system(size: 48))
                .foregroundStyle(colorPalette.primary)

            Text("ColorPicker")
                .typography(.headlineLarge)
                .foregroundStyle(colorPalette.onBackground)

            Text("プリセットカラーから色を選択")
                .typography(.bodyMedium)
                .foregroundStyle(colorPalette.onSurfaceVariant)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
    }

    private var basicUsageSection: some View {
        VStack(alignment: .leading, spacing: spacing.md) {
            Text("基本的な使用例")
                .typography(.titleLarge)
                .foregroundStyle(colorPalette.onSurface)

            Text("タグやカテゴリに適したカラーセット（tagFriendly）")
                .typography(.bodySmall)
                .foregroundStyle(colorPalette.onSurfaceVariant)

            VStack(spacing: spacing.md) {
                // 選択された色のプレビュー
                HStack(spacing: spacing.md) {
                    if let hex = selectedColor1 {
                        Circle()
                            .fill(Color(hex: hex))
                            .frame(width: 40, height: 40)
                            .overlay(
                                Circle()
                                    .stroke(colorPalette.outline.opacity(0.2), lineWidth: 1)
                            )

                        VStack(alignment: .leading, spacing: 4) {
                            Text("選択中の色")
                                .typography(.bodySmall)
                                .foregroundStyle(colorPalette.onSurfaceVariant)
                            Text(hex)
                                .typography(.bodyMedium)
                                .foregroundStyle(colorPalette.onSurface)
                                .fontDesign(.monospaced)
                        }
                    } else {
                        Text("色を選択してください")
                            .typography(.bodyMedium)
                            .foregroundStyle(colorPalette.onSurfaceVariant)
                    }

                    Spacer()
                }
                .padding(spacing.md)
                .background(colorPalette.surfaceVariant.opacity(0.3))
                .clipShape(RoundedRectangle(cornerRadius: 12))

                // 選択ボタン
                Button(selectedColor1 == nil ? "色を選択" : "色を変更") {
                    showColorPicker1 = true
                }
                .buttonStyle(.primary)
                .buttonSize(.medium)
                .colorPicker(
                    preset: .tagFriendly,
                    selectedColor: $selectedColor1,
                    isPresented: $showColorPicker1
                )
            }
        }
    }

    private var presetVariationsSection: some View {
        VStack(alignment: .leading, spacing: spacing.md) {
            Text("プリセットバリエーション")
                .typography(.titleLarge)
                .foregroundStyle(colorPalette.onSurface)

            Text("全プリミティブカラー（allPrimitives）")
                .typography(.bodySmall)
                .foregroundStyle(colorPalette.onSurfaceVariant)

            VStack(spacing: spacing.md) {
                // 選択された色のプレビュー
                HStack(spacing: spacing.md) {
                    if let hex = selectedColor2 {
                        Circle()
                            .fill(Color(hex: hex))
                            .frame(width: 40, height: 40)
                            .overlay(
                                Circle()
                                    .stroke(colorPalette.outline.opacity(0.2), lineWidth: 1)
                            )

                        VStack(alignment: .leading, spacing: 4) {
                            Text("選択中の色")
                                .typography(.bodySmall)
                                .foregroundStyle(colorPalette.onSurfaceVariant)
                            Text(hex)
                                .typography(.bodyMedium)
                                .foregroundStyle(colorPalette.onSurface)
                                .fontDesign(.monospaced)
                        }
                    } else {
                        Text("色を選択してください")
                            .typography(.bodyMedium)
                            .foregroundStyle(colorPalette.onSurfaceVariant)
                    }

                    Spacer()
                }
                .padding(spacing.md)
                .background(colorPalette.surfaceVariant.opacity(0.3))
                .clipShape(RoundedRectangle(cornerRadius: 12))

                // 選択ボタン
                Button(selectedColor2 == nil ? "色を選択" : "色を変更") {
                    showColorPicker2 = true
                }
                .buttonStyle(.secondary)
                .buttonSize(.medium)
                .colorPicker(
                    preset: .allPrimitives,
                    selectedColor: $selectedColor2,
                    isPresented: $showColorPicker2
                )
            }
        }
    }

    private var codeExampleSection: some View {
        VStack(alignment: .leading, spacing: spacing.md) {
            Text("使用例コード")
                .typography(.titleLarge)
                .foregroundStyle(colorPalette.onSurface)

            VStack(alignment: .leading, spacing: spacing.sm) {
                codeBlock("""
                    @State private var selectedColor: String?
                    @State private var showColorPicker = false

                    Button("色を選択") {
                        showColorPicker = true
                    }
                    .colorPicker(
                        preset: .tagFriendly,
                        selectedColor: $selectedColor,
                        isPresented: $showColorPicker
                    )
                    """)

                Text("プリセット:")
                    .typography(.bodySmall)
                    .foregroundStyle(colorPalette.onSurfaceVariant)

                Text("• .tagFriendly - タグやカテゴリ用の10色")
                    .typography(.bodySmall)
                    .foregroundStyle(colorPalette.onSurfaceVariant)

                Text("• .allPrimitives - 全プリミティブカラー（11色）")
                    .typography(.bodySmall)
                    .foregroundStyle(colorPalette.onSurfaceVariant)
            }
        }
    }

    private func codeBlock(_ code: String) -> some View {
        Text(code)
            .typography(.bodySmall)
            .fontDesign(.monospaced)
            .foregroundStyle(colorPalette.onSurface)
            .padding(spacing.md)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(colorPalette.surfaceVariant.opacity(0.5))
            .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

#Preview {
    NavigationStack {
        ColorPickerCatalogView()
            .theme(ThemeProvider())
    }
}
