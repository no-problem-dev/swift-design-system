import SwiftUI
import DesignSystem

// MARK: - テスト用カスタムテーマ: 青テーマ

struct SimpleBlueTheme: Theme {
    var id: String { "test-blue" }
    var name: String { "テストブルー" }
    var description: String { "テスト用のシンプルな青いテーマ" }
    var category: ThemeCategory { .custom }
    var previewColors: [Color] { [.blue, .cyan, .indigo] }

    func colorPalette(for mode: ThemeMode) -> any ColorPalette {
        SimpleBlueColorPalette()
    }
}

struct SimpleBlueColorPalette: ColorPalette {
    var primary: Color { .blue }
    var onPrimary: Color { .white }
    var primaryContainer: Color { Color.blue.opacity(0.1) }
    var onPrimaryContainer: Color { .blue }

    var secondary: Color { .cyan }
    var onSecondary: Color { .white }
    var secondaryContainer: Color { Color.cyan.opacity(0.1) }
    var onSecondaryContainer: Color { .cyan }

    var tertiary: Color { .indigo }
    var onTertiary: Color { .white }

    var background: Color { .white }
    var onBackground: Color { .black }
    var surface: Color { Color(white: 0.98) }
    var onSurface: Color { Color(white: 0.1) }
    var surfaceVariant: Color { Color(white: 0.95) }
    var onSurfaceVariant: Color { Color(white: 0.3) }

    var error: Color { .red }
    var warning: Color { .orange }
    var success: Color { .green }
    var info: Color { .blue }

    var outline: Color { Color(white: 0.8) }
    var outlineVariant: Color { Color(white: 0.9) }
}

// MARK: - テスト用カスタムテーマ: 赤テーマ

struct SimpleRedTheme: Theme {
    var id: String { "test-red" }
    var name: String { "テストレッド" }
    var description: String { "テスト用のシンプルな赤いテーマ" }
    var category: ThemeCategory { .custom }
    var previewColors: [Color] { [.red, .pink, .orange] }

    func colorPalette(for mode: ThemeMode) -> any ColorPalette {
        SimpleRedColorPalette()
    }
}

struct SimpleRedColorPalette: ColorPalette {
    var primary: Color { .red }
    var onPrimary: Color { .white }
    var primaryContainer: Color { Color.red.opacity(0.1) }
    var onPrimaryContainer: Color { .red }

    var secondary: Color { .pink }
    var onSecondary: Color { .white }
    var secondaryContainer: Color { Color.pink.opacity(0.1) }
    var onSecondaryContainer: Color { .pink }

    var tertiary: Color { .orange }
    var onTertiary: Color { .white }

    var background: Color { .white }
    var onBackground: Color { .black }
    var surface: Color { Color(white: 0.98) }
    var onSurface: Color { Color(white: 0.1) }
    var surfaceVariant: Color { Color(white: 0.95) }
    var onSurfaceVariant: Color { Color(white: 0.3) }

    var error: Color { Color(red: 0.8, green: 0.2, blue: 0.2) }
    var warning: Color { .orange }
    var success: Color { .green }
    var info: Color { .blue }

    var outline: Color { Color(white: 0.8) }
    var outlineVariant: Color { Color(white: 0.9) }
}

// MARK: - アプリエントリーポイント

@main
struct DesignSystemCatalogApp: App {
    @State private var themeProvider = ThemeProvider(
        initialTheme: SimpleRedTheme(),
        additionalThemes: [
            SimpleBlueTheme()
            // SimpleRedTheme は initialTheme として既に設定済み
        ]
    )

    var body: some Scene {
        WindowGroup {
            DesignSystemCatalogView()
                .theme(themeProvider)
        }
    }
}
