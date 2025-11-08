import Foundation

/// テーマのライト/ダークモード
///
/// テーマごとに異なるカラーパレットを提供するためのモード指定です。
///
/// ## モードの種類
/// - **system**: システム設定に従う（デフォルト）
/// - **light**: 常にライトモード
/// - **dark**: 常にダークモード
///
/// ## 使用例
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
public enum ThemeMode: String, Sendable, CaseIterable {
    /// システム設定に従う
    case system = "System"

    /// ライトモード固定
    case light = "Light"

    /// ダークモード固定
    case dark = "Dark"
}
