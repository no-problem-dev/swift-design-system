import SwiftUI

/// テーマギャラリービュー
///
/// 全テーマをカテゴリ別に表示し、テーマの選択と切り替えを可能にします。
public struct ThemeGalleryView: View {
    @Environment(ThemeProvider.self) private var themeProvider
    @Environment(\.colorPalette) private var colors
    @Environment(\.spacingScale) private var spacing

    public init() {}

    public var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: spacing.xl) {
                // ヘッダー
                VStack(alignment: .leading, spacing: spacing.sm) {
                    HStack(spacing: spacing.sm) {
                        Image(systemName: "paintpalette.fill")
                            .font(.system(size: 48))
                            .foregroundStyle(colors.primary)

                        Spacer()
                    }
                    .padding(.horizontal, spacing.lg)

                    Text("テーマギャラリー")
                        .typography(.headlineLarge)
                        .foregroundStyle(colors.onBackground)
                        .padding(.horizontal, spacing.lg)

                    Text("お好みのテーマを選んで、デザインシステムの外観をカスタマイズできます")
                        .typography(.bodyMedium)
                        .foregroundStyle(colors.onSurfaceVariant)
                        .padding(.horizontal, spacing.lg)
                }
                .padding(.top, spacing.lg)

                // 外観モード設定
                AppearanceModeSection()

                // カテゴリ別テーマリスト
                ForEach(ThemeCategory.allCases) { category in
                    let categoryThemes = themeProvider.availableThemes.filter { $0.category == category }
                    if !categoryThemes.isEmpty {
                        ThemeCategorySection(
                            category: category,
                            themes: categoryThemes
                        )
                    }
                }

                // 情報セクション
                InfoSection()
            }
            .padding(.bottom, spacing.xl)
        }
        .background(colors.background)
        .navigationTitle("テーマ")
        #if os(iOS)
            .navigationBarTitleDisplayMode(.large)
        #endif
    }
}

// MARK: - Theme Category Section

private struct ThemeCategorySection: View {
    @Environment(ThemeProvider.self) private var themeProvider
    @Environment(\.colorPalette) private var colors
    @Environment(\.spacingScale) private var spacing
    @Environment(\.motion) private var motion

    let category: ThemeCategory
    let themes: [any Theme]

    var body: some View {
        VStack(alignment: .leading, spacing: spacing.md) {
            // カテゴリヘッダー
            HStack(spacing: spacing.sm) {
                Image(systemName: category.icon)
                    .font(.title3)
                    .foregroundStyle(colors.primary)

                VStack(alignment: .leading, spacing: spacing.xxs) {
                    Text(category.rawValue)
                        .typography(.titleMedium)
                        .foregroundStyle(colors.onSurface)

                    Text(category.description)
                        .typography(.bodySmall)
                        .foregroundStyle(colors.onSurfaceVariant)
                }
            }
            .padding(.horizontal, spacing.lg)

            // テーマカードグリッド
            LazyVGrid(
                columns: [
                    GridItem(.flexible(), spacing: spacing.md),
                    GridItem(.flexible(), spacing: spacing.md),
                ],
                spacing: spacing.md
            ) {
                ForEach(themes, id: \.id) { theme in
                    NavigationLink {
                        ThemeDetailView(theme: theme)
                            .environment(themeProvider)
                    } label: {
                        ThemeCardView(
                            theme: theme,
                            isActive: themeProvider.currentTheme.id == theme.id,
                            onTap: {
                                withAnimation(motion.slow) {
                                    themeProvider.applyTheme(theme)
                                }
                            }
                        )
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, spacing.lg)
        }
    }
}

// MARK: - Info Section

// MARK: - Appearance Mode Section

private struct AppearanceModeSection: View {
    @Environment(ThemeProvider.self) private var themeProvider
    @Environment(\.colorPalette) private var colors
    @Environment(\.spacingScale) private var spacing
    @Environment(\.radiusScale) private var radius
    @Environment(\.motion) private var motion

    var body: some View {
        VStack(alignment: .leading, spacing: spacing.md) {
            HStack(spacing: spacing.sm) {
                Image(systemName: "circle.lefthalf.filled")
                    .font(.title3)
                    .foregroundStyle(colors.primary)

                Text("外観モード")
                    .typography(.titleMedium)
                    .foregroundStyle(colors.onSurface)
            }
            .padding(.horizontal, spacing.lg)

            Picker("外観モード", selection: Binding(
                get: { themeProvider.themeMode },
                set: { newMode in
                    withAnimation(motion.slow) {
                        themeProvider.themeMode = newMode
                    }
                }
            )) {
                ForEach(ThemeMode.allCases, id: \.self) { mode in
                    Text(modeLabel(for: mode)).tag(mode)
                }
            }
            .pickerStyle(.segmented)
            .padding(.horizontal, spacing.lg)

            Text(modeDescription(for: themeProvider.themeMode))
                .typography(.bodySmall)
                .foregroundStyle(colors.onSurfaceVariant)
                .padding(.horizontal, spacing.lg)
        }
        .padding(.vertical, spacing.md)
        .background(colors.surface)
        .clipShape(RoundedRectangle(cornerRadius: radius.lg))
        .padding(.horizontal, spacing.lg)
    }
    
    private func modeLabel(for mode: ThemeMode) -> String {
        switch mode {
        case .system: return "システム"
        case .light: return "ライト"
        case .dark: return "ダーク"
        }
    }
    
    private func modeDescription(for mode: ThemeMode) -> String {
        switch mode {
        case .system: return "デバイスの設定に従って外観を自動的に切り替えます"
        case .light: return "常にライトモードで表示します"
        case .dark: return "常にダークモードで表示します"
        }
    }
}

private struct InfoSection: View {
    @Environment(ThemeProvider.self) private var themeProvider
    @Environment(\.colorPalette) private var colors
    @Environment(\.spacingScale) private var spacing
    @Environment(\.radiusScale) private var radius

    var body: some View {
        VStack(alignment: .leading, spacing: spacing.md) {
            Text("現在の設定")
                .typography(.titleMedium)
                .foregroundStyle(colors.onSurface)
                .padding(.horizontal, spacing.lg)

            VStack {
                InfoRow(label: "テーマ", value: themeProvider.currentTheme.name)
                Divider().padding(.leading, spacing.lg)
                InfoRow(label: "モード", value: themeProvider.themeMode.rawValue)
                Divider().padding(.leading, spacing.lg)
                InfoRow(
                    label: "利用可能なテーマ",
                    value: "\(themeProvider.availableThemes.count)個"
                )
            }
            .background(colors.surface)
            .clipShape(RoundedRectangle(cornerRadius: radius.lg))
            .padding(.horizontal, spacing.lg)
        }
    }
}

// Now using shared InfoRow from Catalog/Shared/

#Preview {
    @Previewable @State var themeProvider = ThemeProvider()

    NavigationStack {
        ThemeGalleryView()
            .environment(themeProvider)
    }
    .theme(themeProvider)
}
