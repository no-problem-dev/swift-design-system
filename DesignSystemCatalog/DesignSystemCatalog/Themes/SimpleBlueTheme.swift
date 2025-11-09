import SwiftUI
import DesignSystem

// MARK: - テスト用カスタムテーマ: 青テーマ

/// カスタムテーマの実装例：青を基調としたテーマ
///
/// ## 使い方
///
/// ### 1. ThemeProviderに登録
/// ```swift
/// @main
/// struct MyApp: App {
///     @State private var themeProvider = ThemeProvider(
///         initialTheme: SimpleBlueTheme(),  // 初期テーマとして設定
///         additionalThemes: [SimpleRedTheme()]  // 追加テーマ
///     )
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
/// ### 2. テーマの切り替え
/// ```swift
/// // テーマIDで切り替え
/// themeProvider.switchToTheme(id: "test-blue")
///
/// // ライト/ダークモードの切り替え
/// themeProvider.toggleMode()
/// ```
///
/// ## カスタムテーマの作成ポイント
///
/// 1. **Themeプロトコルに準拠**
///    - `id`: 一意な識別子（例: "myBrand"）
///    - `name`: 表示名（例: "マイブランド"）
///    - `description`: 説明文
///    - `category`: テーマカテゴリ（.custom, .brandPersonality など）
///    - `previewColors`: プレビュー用の色（3色程度）
///
/// 2. **ライト/ダークモード対応**
///    - `colorPalette(for:)` メソッドで `.system`, `.light`, `.dark` の3ケースに対応
///    - `.system` と `.light` は同じパレットを返すのが一般的
///
/// 3. **ColorPaletteの実装**
///    - 全27色のプロパティを定義
///    - ライトモード用とダークモード用で異なる色を設定
///    - ダークモードでは、明るい色調に調整してコントラストを確保
struct SimpleBlueTheme: Theme {
    var id: String { "test-blue" }
    var name: String { "テストブルー" }
    var description: String { "テスト用のシンプルな青いテーマ" }
    var category: ThemeCategory { .custom }
    var previewColors: [Color] { [.blue, .cyan, .indigo] }

    func colorPalette(for mode: ThemeMode) -> any ColorPalette {
        switch mode {
        case .system, .light:
            SimpleBlueColorPalette.light
        case .dark:
            SimpleBlueColorPalette.dark
        }
    }
}

// MARK: - Color Palettes

struct SimpleBlueColorPalette: ColorPalette {
    let primary: Color
    let onPrimary: Color
    let primaryContainer: Color
    let onPrimaryContainer: Color

    let secondary: Color
    let onSecondary: Color
    let secondaryContainer: Color
    let onSecondaryContainer: Color

    let tertiary: Color
    let onTertiary: Color

    let background: Color
    let onBackground: Color
    let surface: Color
    let onSurface: Color
    let surfaceVariant: Color
    let onSurfaceVariant: Color

    let error: Color
    let warning: Color
    let success: Color
    let info: Color

    let outline: Color
    let outlineVariant: Color

    // MARK: - Light Mode Palette

    static let light = SimpleBlueColorPalette(
        primary: .blue,
        onPrimary: .white,
        primaryContainer: Color.blue.opacity(0.1),
        onPrimaryContainer: .blue,

        secondary: .cyan,
        onSecondary: .white,
        secondaryContainer: Color.cyan.opacity(0.1),
        onSecondaryContainer: .cyan,

        tertiary: .indigo,
        onTertiary: .white,

        background: .white,
        onBackground: .black,
        surface: Color(white: 0.98),
        onSurface: Color(white: 0.1),
        surfaceVariant: Color(white: 0.95),
        onSurfaceVariant: Color(white: 0.3),

        error: .red,
        warning: .orange,
        success: .green,
        info: .blue,

        outline: Color(white: 0.8),
        outlineVariant: Color(white: 0.9)
    )

    // MARK: - Dark Mode Palette

    static let dark = SimpleBlueColorPalette(
        primary: Color(red: 0.5, green: 0.7, blue: 1.0), // Lighter blue for dark mode
        onPrimary: Color(white: 0.1),
        primaryContainer: Color.blue.opacity(0.2),
        onPrimaryContainer: Color(red: 0.7, green: 0.85, blue: 1.0),

        secondary: Color(red: 0.4, green: 0.9, blue: 0.9), // Lighter cyan
        onSecondary: Color(white: 0.1),
        secondaryContainer: Color.cyan.opacity(0.2),
        onSecondaryContainer: Color(red: 0.6, green: 0.95, blue: 0.95),

        tertiary: Color(red: 0.6, green: 0.65, blue: 0.95), // Lighter indigo
        onTertiary: Color(white: 0.1),

        background: Color(white: 0.05),
        onBackground: Color(white: 0.95),
        surface: Color(white: 0.12),
        onSurface: Color(white: 0.9),
        surfaceVariant: Color(white: 0.18),
        onSurfaceVariant: Color(white: 0.7),

        error: Color(red: 1.0, green: 0.4, blue: 0.4), // Lighter red
        warning: Color(red: 1.0, green: 0.7, blue: 0.3), // Lighter orange
        success: Color(red: 0.4, green: 0.9, blue: 0.4), // Lighter green
        info: Color(red: 0.5, green: 0.7, blue: 1.0), // Lighter blue

        outline: Color(white: 0.3),
        outlineVariant: Color(white: 0.2)
    )
}
