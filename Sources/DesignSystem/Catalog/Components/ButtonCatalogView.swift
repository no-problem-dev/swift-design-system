import SwiftUI

/// ボタンコンポーネントのカタログビュー
struct ButtonCatalogView: View {
    @Environment(\.spacingScale) private var spacing
    @State private var isButtonEnabled = true

    var body: some View {
        CatalogPageContainer(title: "Button") {
            CatalogOverview(description: "ボタンのバリエーションとサイズを確認できます")

            Toggle("ボタンを有効化", isOn: $isButtonEnabled)
                .padding(.horizontal, spacing.lg)

            SectionCard(title: "Primary") {
                VariantShowcase(
                    title: "Primary Button",
                    description: "主要なアクションに使用"
                ) {
                    VStack(spacing: spacing.md) {
                        Button("Large") { }
                            .buttonStyle(.primary)
                            .buttonSize(.large)

                        Button("Medium") { }
                            .buttonStyle(.primary)
                            .buttonSize(.medium)

                        Button("Small") { }
                            .buttonStyle(.primary)
                            .buttonSize(.small)
                    }
                    .disabled(!isButtonEnabled)
                }
            }

            SectionCard(title: "Secondary") {
                VariantShowcase(
                    title: "Secondary Button",
                    description: "副次的なアクションに使用"
                ) {
                    VStack(spacing: spacing.md) {
                        Button("Large") { }
                            .buttonStyle(.secondary)
                            .buttonSize(.large)

                        Button("Medium") { }
                            .buttonStyle(.secondary)
                            .buttonSize(.medium)

                        Button("Small") { }
                            .buttonStyle(.secondary)
                            .buttonSize(.small)
                    }
                    .disabled(!isButtonEnabled)
                }
            }

            SectionCard(title: "Tertiary") {
                VariantShowcase(
                    title: "Tertiary Button",
                    description: "最も控えめなテキストスタイル"
                ) {
                    VStack(spacing: spacing.md) {
                        Button("Large") { }
                            .buttonStyle(.tertiary)
                            .buttonSize(.large)

                        Button("Medium") { }
                            .buttonStyle(.tertiary)
                            .buttonSize(.medium)

                        Button("Small") { }
                            .buttonStyle(.tertiary)
                            .buttonSize(.small)
                    }
                    .disabled(!isButtonEnabled)
                }
            }

            SectionCard(title: "使用例") {
                CodeExample(code: """
                    Button("ログイン") { login() }
                        .buttonStyle(.primary)
                        .buttonSize(.large)
                    """)
            }
        }
    }
}

#Preview {
    NavigationStack {
        ButtonCatalogView()
            .theme(ThemeProvider())
    }
}
