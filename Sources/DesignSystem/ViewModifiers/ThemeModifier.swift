import SwiftUI

/// テーマを適用するView Modifier
public struct ThemeModifier: ViewModifier {
    @Bindable var provider: ThemeProvider

    public init(provider: ThemeProvider) {
        self.provider = provider
    }

    public func body(content: Content) -> some View {
        ThemeEnvironmentView(provider: provider, content: content)
    }
}

/// テーマ環境値を提供する内部ビュー
/// @Bindableによる変更追跡を確実に行うための専用ビュー
private struct ThemeEnvironmentView<Content: View>: View {
    @Bindable var provider: ThemeProvider
    @Environment(\.colorScheme) private var systemColorScheme
    let content: Content

    /// 実際に使用するモードを解決
    /// - `.system`: システムのColorSchemeに従う
    /// - `.light`/`.dark`: ユーザーの手動選択を尊重
    private var resolvedMode: ThemeMode {
        switch provider.themeMode {
        case .system:
            return systemColorScheme == .dark ? .dark : .light
        case .light, .dark:
            return provider.themeMode
        }
    }

    /// 実際に適用するSwiftUIのColorScheme
    private var resolvedColorScheme: ColorScheme {
        resolvedMode == .dark ? .dark : .light
    }

    /// 実際に適用するカラーパレット（リアクティブ）
    /// provider.currentThemeが変更されると自動的に再計算される
    private var resolvedColorPalette: any ColorPalette {
        provider.currentTheme.colorPalette(for: resolvedMode)
    }

    var body: some View {
        content
            .environment(provider)
            .environment(\.colorPalette, resolvedColorPalette)
            .environment(\.spacingScale, DefaultSpacingScale())
            .environment(\.radiusScale, DefaultRadiusScale())
            .colorScheme(resolvedColorScheme)
    }
}
