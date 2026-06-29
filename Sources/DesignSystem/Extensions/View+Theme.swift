import SwiftUI

extension View {
    /// View 階層全体にテーマを適用する。
    ///
    /// アプリのルートビューに適用することで、全ての子 View でデザイントークンが利用可能になる。
    ///
    /// - Parameter provider: ThemeProvider インスタンス
    /// - Returns: テーマが適用された View
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
