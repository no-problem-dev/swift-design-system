import SwiftUI

/// ボタンコンポーネントのカタログビュー
struct ButtonCatalogView: View {
    @Environment(\.colorPalette) private var colorPalette
    @Environment(\.spacingScale) private var spacing
    @State private var isButtonEnabled = true

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // 概要
                VStack(alignment: .leading, spacing: 12) {
                    Text("ボタンのバリエーションとサイズを確認できます")
                        .typography(.bodyMedium)
                        .foregroundStyle(colorPalette.onSurfaceVariant)
                        .padding(.horizontal, spacing.lg)

                    Toggle("ボタンを有効化", isOn: $isButtonEnabled)
                        .padding(.horizontal, spacing.lg)
                }

                // Primary Button
                SectionCard(title: "Primary Button") {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("最も強調されるボタン。主要なアクションに使用。")
                            .typography(.bodySmall)
                            .foregroundStyle(colorPalette.onSurfaceVariant)

                        VStack(spacing: spacing.md) {
                            Button("Large (デフォルト)") { }
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

                // Secondary Button
                SectionCard(title: "Secondary Button") {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("副次的なアクションに使用。プライマリより控えめな強調。")
                            .typography(.bodySmall)
                            .foregroundStyle(colorPalette.onSurfaceVariant)

                        VStack(spacing: spacing.md) {
                            Button("Large (デフォルト)") { }
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

                // Tertiary Button
                SectionCard(title: "Tertiary Button") {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("最も控えめなボタン。テキストのみのスタイル。")
                            .typography(.bodySmall)
                            .foregroundStyle(colorPalette.onSurfaceVariant)

                        VStack(spacing: spacing.md) {
                            Button("Large (デフォルト)") { }
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

                // 使用例
                SectionCard(title: "使用例") {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("SwiftUI での使用方法")
                            .typography(.titleSmall)

                        Text("""
                        Button("ログイン") {
                            login()
                        }
                        .buttonStyle(.primary)
                        .buttonSize(.large)
                        """)
                        .typography(.bodySmall)
                        .fontDesign(.monospaced)
                        .padding()
                        .background(colorPalette.surfaceVariant)
                        .cornerRadius(8)
                    }
                }
            }
            .padding(.bottom, spacing.xl)
        }
        .background(colorPalette.background)
        .navigationTitle("Button")
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
    }
}

#Preview {
    NavigationStack {
        ButtonCatalogView()
            .theme(ThemeProvider())
    }
}
