import SwiftUI

extension View {
    /// デザインシステムのテーマを適用
    ///
    /// ThemeProviderを使用してView階層全体にテーマを適用します。
    /// アプリのルートビューに適用することで、全ての子ビューでデザイントークンが利用可能になります。
    ///
    /// - Parameter provider: ThemeProvider インスタンス
    /// - Returns: テーマが適用されたView
    ///
    /// ## 使用例
    /// ```swift
    /// @main
    /// struct MyApp: App {
    ///     @State private var themeProvider = ThemeProvider()
    ///
    ///     var body: some Scene {
    ///         WindowGroup {
    ///             ContentView()
    ///                 .theme(themeProvider)  // ここで適用
    ///         }
    ///     }
    /// }
    /// ```
    ///
    /// テーマ適用後、子ビューでデザイントークンが使用可能：
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
