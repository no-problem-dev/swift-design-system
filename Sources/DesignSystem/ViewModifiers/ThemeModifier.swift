import SwiftUI

/// Publishes a theme's tokens into the environment and applies its color scheme.
///
/// Apply it once near the root of the hierarchy. Views below read the resolved palette and the
/// token scales from the environment, and the color scheme follows the provider's theme mode.
public struct ThemeModifier: ViewModifier {
    @Bindable var provider: ThemeProvider

    public init(provider: ThemeProvider) {
        self.provider = provider
    }

    public func body(content: Content) -> some View {
        ThemeEnvironmentView(provider: provider, content: content)
    }
}

/// Supplies the theme environment values to its content.
///
/// A dedicated view so that change tracking through `@Bindable` is picked up reliably.
private struct ThemeEnvironmentView<Content: View>: View {
    @Bindable var provider: ThemeProvider
    @Environment(\.colorScheme) private var systemColorScheme
    let content: Content

    /// The theme mode that is actually in effect, with `.system` resolved against the environment.
    private var resolvedMode: ThemeMode {
        provider.resolvedMode(for: systemColorScheme)
    }

    private var resolvedColorScheme: ColorScheme {
        resolvedMode == .dark ? .dark : .light
    }

    /// The color palette in effect. It is recomputed whenever the provider's current theme changes.
    private var resolvedColorPalette: any ColorPalette {
        provider.colorPalette(for: systemColorScheme)
    }

    var body: some View {
        content
            .environment(provider)
            .environment(\.colorPalette, resolvedColorPalette)
            .environment(\.typographyScale, provider.currentTheme.typographyScale)
            .environment(\.spacingScale, provider.currentTheme.spacingScale)
            .environment(\.radiusScale, provider.currentTheme.radiusScale)
            .environment(\.borderScale, provider.currentTheme.borderScale)
            .environment(\.stateLayer, provider.currentTheme.stateLayer)
            .environment(\.gradients, provider.currentTheme.gradients)
            .environment(\.elevationScale, provider.currentTheme.elevationScale)
            .environment(\.iconSizeScale, provider.currentTheme.iconSizeScale)
            .environment(\.motion, provider.currentTheme.motion)
            .colorScheme(resolvedColorScheme)
    }
}
