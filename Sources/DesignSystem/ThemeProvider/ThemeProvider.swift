import SwiftUI

/// テーマ管理クラス
///
/// アプリケーション全体のテーマとモード（ライト/ダーク/システム）を管理します。
/// `@Observable`により、テーマやモードの変更は自動的にUIに反映されます。
///
/// ## 基本的な使い方
/// ```swift
/// @main
/// struct MyApp: App {
///     @State private var themeProvider = ThemeProvider()
///
///     var body: some Scene {
///         WindowGroup {
///             ContentView()
///                 .theme(themeProvider)
///         }
///     }
/// }
/// ```
///
/// ## モードの設定
/// ```swift
/// // システム設定に従う（デフォルト）
/// themeProvider.themeMode = .system
///
/// // ライトモード固定
/// themeProvider.themeMode = .light
///
/// // ダークモード固定
/// themeProvider.themeMode = .dark
/// ```
///
/// ## テーマの切り替え
/// ```swift
/// // テーマを切り替え
/// themeProvider.switchToTheme(id: "ocean")
/// ```
@Observable
@MainActor
public final class ThemeProvider {
    /// 現在選択されているテーマ
    public var currentTheme: any Theme

    /// 現在のモード（システム/ライト/ダーク）
    ///
    /// - `.system`: システム設定に従う（デフォルト）
    /// - `.light`: 常にライトモード
    /// - `.dark`: 常にダークモード
    public var themeMode: ThemeMode

    /// 利用可能な全テーマ
    public private(set) var availableThemes: [any Theme]

    /// 現在のテーマとモードに基づくカラーパレット
    public var colorPalette: any ColorPalette {
        currentTheme.colorPalette(for: themeMode)
    }

    /// ThemeProviderを初期化
    ///
    /// - Parameters:
    ///   - initialTheme: 初期テーマ（デフォルト: DefaultTheme）
    ///   - initialMode: 初期モード（デフォルト: .system - システム設定に従う）
    ///   - additionalThemes: 追加で登録するカスタムテーマ
    public init(
        initialTheme: (any Theme)? = nil,
        initialMode: ThemeMode = .system,
        additionalThemes: [any Theme] = []
    ) {
        // ビルトインテーマを登録
        let themes = ThemeRegistry.builtInThemes + additionalThemes
        self.availableThemes = themes

        // 初期テーマを設定
        if let initialTheme {
            self.currentTheme = initialTheme
        } else if let defaultTheme = themes.first(where: { $0.id == "default" }) {
            self.currentTheme = defaultTheme
        } else {
            self.currentTheme = themes[0]
        }

        self.themeMode = initialMode
    }

    /// テーマIDでテーマを切り替え
    ///
    /// - Parameter id: 切り替え先のテーマID
    ///
    /// ## 使用例
    /// ```swift
    /// withAnimation {
    ///     themeProvider.switchToTheme(id: "ocean")
    /// }
    /// ```
    public func switchToTheme(id: String) {
        guard let theme = availableThemes.first(where: { $0.id == id }) else {
            print("⚠️ Theme with id '\(id)' not found")
            return
        }
        currentTheme = theme
    }

    /// テーマオブジェクトを直接適用
    ///
    /// - Parameter theme: 適用するテーマ
    public func applyTheme(_ theme: any Theme) {
        currentTheme = theme
    }

    /// モードを切り替え
    ///
    /// システム → ライト → ダーク → システム の順で循環します。
    public func toggleMode() {
        switch themeMode {
        case .system:
            themeMode = .light
        case .light:
            themeMode = .dark
        case .dark:
            themeMode = .system
        }
    }

    /// カスタムテーマを登録
    ///
    /// - Parameter theme: 登録するテーマ
    ///
    /// ## 使用例
    /// ```swift
    /// struct MyCustomTheme: Theme {
    ///     var id: String { "my-theme" }
    ///     // ... その他の実装
    /// }
    ///
    /// themeProvider.registerTheme(MyCustomTheme())
    /// ```
    public func registerTheme(_ theme: any Theme) {
        // 既存のテーマを更新または追加
        if let index = availableThemes.firstIndex(where: { $0.id == theme.id }) {
            availableThemes[index] = theme
        } else {
            availableThemes.append(theme)
        }
    }

    /// 複数のカスタムテーマを登録
    ///
    /// - Parameter themes: 登録するテーマの配列
    public func registerThemes(_ themes: [any Theme]) {
        themes.forEach { registerTheme($0) }
    }
}
