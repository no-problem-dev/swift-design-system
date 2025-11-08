import SwiftUI

/// テーマ詳細ビュー
///
/// 選択したテーマの詳細情報を表示し、プレビューと適用が可能です。
public struct ThemeDetailView: View {
    @Environment(ThemeProvider.self) private var themeProvider
    @Environment(\.colorPalette) private var colors
    @Environment(\.spacingScale) private var spacing

    let theme: any Theme

    public init(theme: any Theme) {
        self.theme = theme
    }

    public var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: spacing.xl) {
                // ヘッダー
                VStack(alignment: .leading, spacing: spacing.sm) {
                    HStack {
                        Text(theme.name)
                            .typography(.headlineLarge)
                            .foregroundStyle(colors.onBackground)

                        Spacer()

                        // カテゴリバッジ
                        Text(theme.category.rawValue)
                            .typography(.labelSmall)
                            .foregroundStyle(colors.onPrimaryContainer)
                            .padding(.horizontal, spacing.sm)
                            .padding(.vertical, 4)
                            .background(colors.primaryContainer)
                            .clipShape(Capsule())
                    }

                    Text(theme.description)
                        .typography(.bodyMedium)
                        .foregroundStyle(colors.onSurfaceVariant)
                }
                .padding(.horizontal, spacing.lg)

                // モード切り替え
                VStack(alignment: .leading, spacing: spacing.md) {
                    Text("モード")
                        .typography(.titleMedium)
                        .foregroundStyle(colors.onSurface)
                        .padding(.horizontal, spacing.lg)

                    HStack(spacing: spacing.md) {
                        ForEach(ThemeMode.allCases, id: \.self) { mode in
                            Button {
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    themeProvider.themeMode = mode
                                }
                            } label: {
                                Text(mode.rawValue)
                                    .typography(.bodyMedium)
                                    .foregroundStyle(
                                        themeProvider.themeMode == mode ? colors.onPrimary : colors.onSurface
                                    )
                                    .padding(.horizontal, spacing.lg)
                                    .padding(.vertical, spacing.sm)
                                    .background(
                                        themeProvider.themeMode == mode ? colors.primary : colors.surfaceVariant
                                    )
                                    .clipShape(Capsule())
                            }
                        }
                    }
                    .padding(.horizontal, spacing.lg)
                }

                // カラーパレット
                ThemeColorPreview(theme: theme)

                // コンポーネントプレビュー
                ComponentPreview()

                // 適用ボタン
                Button {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        themeProvider.applyTheme(theme)
                    }
                } label: {
                    Text("このテーマを適用")
                        .typography(.titleMedium)
                        .foregroundStyle(colors.onPrimary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, spacing.md)
                        .background(colors.primary)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .disabled(themeProvider.currentTheme.id == theme.id)
                .opacity(themeProvider.currentTheme.id == theme.id ? 0.5 : 1.0)
                .padding(.horizontal, spacing.lg)
            }
            .padding(.vertical, spacing.xl)
        }
        .background(colors.background)
        .navigationTitle(theme.name)
        #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
        #endif
    }
}

// MARK: - Component Preview

private struct ComponentPreview: View {
    @Environment(\.colorPalette) private var colors
    @Environment(\.spacingScale) private var spacing

    var body: some View {
        VStack(alignment: .leading, spacing: spacing.md) {
            Text("コンポーネントプレビュー")
                .typography(.titleMedium)
                .foregroundStyle(colors.onSurface)
                .padding(.horizontal, spacing.lg)

            VStack(spacing: spacing.md) {
                // ボタン
                HStack(spacing: spacing.sm) {
                    Button("Primary") {}
                        .buttonStyle(.primary)
                        .buttonSize(.medium)

                    Button("Secondary") {}
                        .buttonStyle(.secondary)
                        .buttonSize(.medium)

                    Button("Tertiary") {}
                        .buttonStyle(.tertiary)
                        .buttonSize(.medium)
                }

                // カード
                Card(elevation: .level2) {
                    VStack(alignment: .leading, spacing: spacing.sm) {
                        Text("カードコンポーネント")
                            .typography(.titleSmall)
                            .foregroundStyle(colors.onSurface)

                        Text("このテーマが適用された場合のカードの見た目を確認できます。")
                            .typography(.bodySmall)
                            .foregroundStyle(colors.onSurfaceVariant)
                    }
                }
            }
            .padding(.horizontal, spacing.lg)
        }
    }
}

#Preview {
    @Previewable @State var themeProvider = ThemeProvider()

    NavigationStack {
        ThemeDetailView(theme: OceanTheme())
            .environment(themeProvider)
    }
    .theme(themeProvider)
}
