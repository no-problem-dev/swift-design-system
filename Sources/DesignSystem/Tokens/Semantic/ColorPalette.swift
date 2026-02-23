import SwiftUI

/// カラーパレットプロトコル
///
/// テーマごとに異なる色実装を提供し、アプリ全体で一貫した色の使用を保証します。
/// Light/Darkテーマ、カスタムブランドカラーなど、様々なテーマに対応できます。
///
/// ## 使用例
/// ```swift
/// @Environment(\.colorPalette) var colors
///
/// VStack {
///     Text("見出し")
///         .foregroundColor(colors.primary)
///     Text("本文")
///         .foregroundColor(colors.onSurface)
/// }
/// .background(colors.surface)
/// ```
///
/// ## カスタムテーマの作成
/// ```swift
/// struct MyBrandPalette: ColorPalette {
///     var primary: Color { Color(hex: "#007AFF") }
///     var background: Color { .white }
///     var surface: Color { Color(hex: "#F2F2F7") }
///     // ... 他の必須プロパティを実装
/// }
///
/// // Themeプロトコルでパレットを使用
/// struct MyBrandTheme: Theme {
///     var id: String { "myBrand" }
///     var name: String { "My Brand" }
///     var description: String { "ブランドカラーテーマ" }
///     var category: ThemeCategory { .brandPersonality }
///     var previewColors: [Color] { [Color(hex: "#007AFF")] }
///
///     func colorPalette(for mode: ThemeMode) -> any ColorPalette {
///         switch mode {
///         case .system, .light: MyBrandPalette()
///         case .dark: MyBrandDarkPalette()
///         }
///     }
/// }
///
/// // ThemeProviderに登録
/// ThemeProvider(initialTheme: MyBrandTheme())
/// ```
public protocol ColorPalette: Sendable {
    // MARK: - Primary Colors

    /// 主要なアクションやブランド要素に使用
    var primary: Color { get }

    /// Primary背景上のテキスト/アイコン色
    var onPrimary: Color { get }

    /// Primaryの薄いバリエーション（コンテナ背景用）
    var primaryContainer: Color { get }

    /// PrimaryContainer背景上のテキスト色
    var onPrimaryContainer: Color { get }

    // MARK: - Secondary Colors

    /// 補助的なアクセントカラー
    var secondary: Color { get }

    /// Secondary背景上のテキスト/アイコン色
    var onSecondary: Color { get }

    /// Secondaryの薄いバリエーション（コンテナ背景用）
    var secondaryContainer: Color { get }

    /// SecondaryContainer背景上のテキスト色
    var onSecondaryContainer: Color { get }

    // MARK: - Tertiary Colors

    /// 第3のアクセントカラー（追加の強調表示用）
    var tertiary: Color { get }

    /// Tertiary背景上のテキスト/アイコン色
    var onTertiary: Color { get }

    // MARK: - Background & Surface

    /// アプリ全体の背景色
    var background: Color { get }

    /// Background上のテキスト色
    var onBackground: Color { get }

    /// カード、シート、ダイアログなどの表面色
    var surface: Color { get }

    /// Surface上のテキスト色
    var onSurface: Color { get }

    /// Surfaceの代替色（微妙な差分をつける場合）
    var surfaceVariant: Color { get }

    /// SurfaceVariant上のテキスト色
    var onSurfaceVariant: Color { get }

    // MARK: - Semantic State Colors

    /// エラー状態の表示に使用
    var error: Color { get }

    /// Error背景上のテキスト色
    var onError: Color { get }

    /// エラーの薄いバリエーション（コンテナ背景用）
    var errorContainer: Color { get }

    /// ErrorContainer背景上のテキスト色
    var onErrorContainer: Color { get }

    /// 警告状態の表示に使用
    var warning: Color { get }

    /// Warning背景上のテキスト色
    var onWarning: Color { get }

    /// 成功状態の表示に使用
    var success: Color { get }

    /// Success背景上のテキスト色
    var onSuccess: Color { get }

    /// 情報表示に使用
    var info: Color { get }

    /// Info背景上のテキスト色
    var onInfo: Color { get }

    // MARK: - Outline & Border

    /// ボーダー、区切り線、アウトラインに使用
    var outline: Color { get }

    /// Outlineの薄いバリエーション
    var outlineVariant: Color { get }
}

// MARK: - Default Implementations

public extension ColorPalette {
    // 派生色にデフォルト実装を提供
    var primaryContainer: Color { primary.opacity(0.12) }
    var onPrimaryContainer: Color { primary }
    var secondaryContainer: Color { secondary.opacity(0.12) }
    var onSecondaryContainer: Color { secondary }

    var errorContainer: Color { error.opacity(0.12) }
    var onErrorContainer: Color { error }

    // on〜色のデフォルト
    var onPrimary: Color { .white }
    var onSecondary: Color { .white }
    var onTertiary: Color { .white }
    var onError: Color { .white }
    var onWarning: Color { .black }
    var onSuccess: Color { .white }
    var onInfo: Color { .white }

    var outlineVariant: Color { outline.opacity(0.5) }
}
