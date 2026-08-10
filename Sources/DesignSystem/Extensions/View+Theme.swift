import SwiftUI

extension View {
    /// Puts a theme's design tokens into the environment for this view and everything below it.
    ///
    /// Apply it once at the root of the app. Views that read a token without this modifier fall
    /// back to the default tokens, which is what an unstyled preview shows. When the provider's
    /// mode follows the device, this is where that resolves against the current appearance.
    ///
    /// - Parameter provider: The provider holding the theme and mode to apply.
    ///
    /// ## Example
    /// ```swift
    /// @main
    /// struct MyApp: App {
    ///     @State private var themeProvider = ThemeProvider()
    ///
    ///     var body: some Scene {
    ///         WindowGroup {
    ///             ContentView()
    ///                 .theme(themeProvider)  // applied here
    ///         }
    ///     }
    /// }
    /// ```
    ///
    /// Child views can then read the design tokens:
    /// ```swift
    /// struct ContentView: View {
    ///     @Environment(\.colorPalette) var colors
    ///     @Environment(\.spacingScale) var spacing
    ///
    ///     var body: some View {
    ///         Text("Hello")
    ///             .foregroundStyle(colors.primary)
    ///             .padding(spacing.lg)
    ///     }
    /// }
    /// ```
    public func theme(_ provider: ThemeProvider) -> some View {
        modifier(ThemeModifier(provider: provider))
    }
}
