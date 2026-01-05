import SwiftUI

/// ColorPickerのカタログビュー
struct ColorPickerCatalogView: View {
    @Environment(\.colorPalette) private var colors
    @Environment(\.spacingScale) private var spacing
    @Environment(\.radiusScale) private var radius

    @State private var selectedColor1: String?
    @State private var selectedColor2: String?
    @State private var showColorPicker1 = false
    @State private var showColorPicker2 = false

    var body: some View {
        CatalogPageContainer(title: "ColorPicker") {
            CatalogOverview(description: "プリセットカラーから色を選択")

            SectionCard(title: "tagFriendly") {
                VStack(spacing: spacing.md) {
                    colorPreview(selectedColor: selectedColor1)

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

            SectionCard(title: "allPrimitives") {
                VStack(spacing: spacing.md) {
                    colorPreview(selectedColor: selectedColor2)

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

            SectionCard(title: "使用例") {
                CodeExample(code: """
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
            }
        }
    }

    @ViewBuilder
    private func colorPreview(selectedColor: String?) -> some View {
        HStack(spacing: spacing.md) {
            if let hex = selectedColor {
                Circle()
                    .fill(Color(hex: hex))
                    .frame(width: 40, height: 40)
                    .overlay(
                        Circle()
                            .stroke(colors.outline.opacity(0.2), lineWidth: 1)
                    )

                Text(hex)
                    .typography(.bodyMedium)
                    .foregroundStyle(colors.onSurface)
                    .fontDesign(.monospaced)
            } else {
                Text("色を選択してください")
                    .typography(.bodyMedium)
                    .foregroundStyle(colors.onSurfaceVariant)
            }

            Spacer()
        }
        .padding(spacing.md)
        .background(colors.surfaceVariant.opacity(0.3))
        .clipShape(RoundedRectangle(cornerRadius: radius.lg))
    }
}

#Preview {
    NavigationStack {
        ColorPickerCatalogView()
            .theme(ThemeProvider())
    }
}
