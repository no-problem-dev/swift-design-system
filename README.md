# DesignSystem

SwiftUI向けの型安全で拡張可能なデザインシステム

![Swift](https://img.shields.io/badge/Swift-6.0-orange.svg)
![Platforms](https://img.shields.io/badge/Platforms-iOS%2017.0+%20%7C%20macOS%2014.0+-blue.svg)
![License](https://img.shields.io/badge/License-MIT-yellow.svg)

📚 **[完全なドキュメント](https://no-problem-dev.github.io/swift-design-system/documentation/designsystem/)**

## 特徴

```swift
// テーマの適用
ContentView()
    .theme(themeProvider)

// カラーパレット
@Environment(\.colorPalette) var colors
Text("Hello").foregroundColor(colors.primary)

// スペーシング
@Environment(\.spacingScale) var spacing
VStack(spacing: spacing.lg) { /* ... */ }

// タイポグラフィ
Text("見出し").typography(.headlineLarge)
```

- **3層トークンシステム** - Primitive → Semantic → Component の明確な階層
- **型安全** - プロトコルベース設計により拡張性が高い
- **7種類のビルトインテーマ** - デフォルト、Ocean、Forest、Sunset、PurpleHaze、Monochrome、HighContrast
- **ライト/ダークモード対応** - 全テーマでシームレスなモード切り替え
- **すぐ使える** - ボタン、カード、テキストフィールドなどの基本コンポーネント
- **ドキュメント完備** - 全てのパブリックAPIに実践的なコード例

## インストール

```swift
// Package.swift
dependencies: [
    .package(url: "https://github.com/no-problem-dev/swift-design-system.git", .upToNextMajor(from: "1.0.0"))
]
```

または Xcode: File > Add Package Dependencies > URL入力

## 基本的な使い方

### 1. テーマのセットアップ

```swift
@main
struct MyApp: App {
    @State private var themeProvider = ThemeProvider()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .theme(themeProvider)
        }
    }
}
```

### 2. デザイントークンの使用

#### カラーパレット

```swift
struct MyView: View {
    @Environment(\.colorPalette) var colors

    var body: some View {
        VStack {
            Text("見出し")
                .foregroundColor(colors.primary)
            Text("本文")
                .foregroundColor(colors.onSurface)
        }
        .background(colors.surface)
    }
}
```

#### スペーシングとレイアウト

```swift
struct MyView: View {
    @Environment(\.spacingScale) var spacing

    var body: some View {
        VStack(spacing: spacing.lg) {  // 16pt
            Text("項目1")
            Text("項目2")
        }
        .padding(spacing.xl)  // 24pt
    }
}
```

#### タイポグラフィ

```swift
Text("大見出し")
    .typography(.headlineLarge)

Text("本文")
    .typography(.bodyMedium)

Text("ラベル")
    .typography(.labelSmall)
```

### 3. コンポーネントの使用

#### ボタン

```swift
Button("保存") { save() }
    .buttonStyle(.primary)
    .buttonSize(.large)

Button("キャンセル") { cancel() }
    .buttonStyle(.secondary)
    .buttonSize(.medium)

Button("削除") { delete() }
    .buttonStyle(.tertiary)
```

#### カード

```swift
Card(elevation: .level2) {
    VStack(alignment: .leading, spacing: spacing.md) {
        Text("カードタイトル")
            .typography(.titleMedium)
        Text("カードの内容")
            .typography(.bodyMedium)
    }
}
```

#### セクションカード

```swift
ScrollView {
    VStack(spacing: spacing.xl) {
        SectionCard(title: "基本設定") {
            // コンテンツ
        }

        SectionCard(title: "プロフィール", elevation: .level2) {
            // コンテンツ
        }
    }
}
```

### 4. ビルトインテーマの使用

7種類のテーマから選択できます：

```swift
// テーマを切り替え
themeProvider.switchToTheme(id: "ocean")      // Ocean（深い青）
themeProvider.switchToTheme(id: "forest")     // Forest（自然な緑）
themeProvider.switchToTheme(id: "sunset")     // Sunset（温かいオレンジ）
themeProvider.switchToTheme(id: "purpleHaze") // PurpleHaze（創造的な紫）
themeProvider.switchToTheme(id: "monochrome") // Monochrome（ミニマルなグレー）
themeProvider.switchToTheme(id: "highContrast") // HighContrast（WCAG AAA準拠）

// ライト/ダークモードを切り替え
themeProvider.toggleMode()

// 特定のモードに設定
themeProvider.themeMode = .dark
```

#### テーマ一覧

| カテゴリ | テーマ | 説明 | プライマリカラー |
|---------|-------|------|----------------|
| 標準 | Default | 基本的なライト/ダークテーマ | Blue #3B82F6 |
| ブランド | Ocean | プロフェッショナルで落ち着いた雰囲気 | Ocean Blue #0077BE |
| ブランド | Forest | 自然で安定感のある印象 | Forest Green #2D5016 |
| ブランド | Sunset | 温かくエネルギッシュな印象 | Coral Orange #FF6B35 |
| ブランド | PurpleHaze | 創造的でイノベーティブな印象 | Royal Purple #7209B7 |
| ブランド | Monochrome | ミニマルでエレガントな印象 | Charcoal #2D3748 |
| アクセシビリティ | HighContrast | 最大限のコントラスト（WCAG AAA） | Pure Black #000000 |

### 5. テーマの動的切り替え

```swift
struct ThemePickerView: View {
    @Environment(ThemeProvider.self) private var themeProvider

    var body: some View {
        VStack(spacing: 16) {
            // テーマピッカー
            Picker("テーマ", selection: Binding(
                get: { themeProvider.currentTheme.id },
                set: { themeProvider.switchToTheme(id: $0) }
            )) {
                ForEach(themeProvider.availableThemes, id: \.id) { theme in
                    Text(theme.name).tag(theme.id)
                }
            }
            .pickerStyle(.menu)

            // モード切り替え
            Toggle("ダークモード", isOn: Binding(
                get: { themeProvider.themeMode == .dark },
                set: { _ in themeProvider.toggleMode() }
            ))

            // アニメーション付き切り替え
            Button("Oceanテーマに切り替え") {
                withAnimation {
                    themeProvider.switchToTheme(id: "ocean")
                }
            }
        }
        .padding()
    }
}
```

### 6. カスタムテーマの作成

独自のテーマを作成できます：

```swift
// カスタムカラーパレット（ライトモード）
struct MyBrandLightPalette: ColorPalette {
    var primary: Color { Color(hex: "#007AFF") }
    var onPrimary: Color { .white }
    var secondary: Color { Color(hex: "#5856D6") }
    var onSecondary: Color { .white }
    var background: Color { Color(hex: "#F5F5F7") }
    var onBackground: Color { Color(hex: "#1D1D1F") }
    // ... 全27色を定義
}

// カスタムカラーパレット（ダークモード）
struct MyBrandDarkPalette: ColorPalette {
    var primary: Color { Color(hex: "#0A84FF") }
    var onPrimary: Color { .white }
    // ... 全27色を定義
}

// カスタムテーマ
struct MyBrandTheme: Theme {
    let id = "myBrand"
    let name = "マイブランド"
    let description = "当社ブランドカラーのテーマ"
    let category: ThemeCategory = .brandPersonality
    let previewColors = [
        Color(hex: "#007AFF"),
        Color(hex: "#5856D6"),
        Color(hex: "#FF9500")
    ]

    func colorPalette(for mode: ThemeMode) -> any ColorPalette {
        switch mode {
        case .light: return MyBrandLightPalette()
        case .dark: return MyBrandDarkPalette()
        }
    }
}

// カスタムテーマを登録
@main
struct MyApp: App {
    @State private var themeProvider = ThemeProvider(
        additionalThemes: [MyBrandTheme()]
    )

    var body: some Scene {
        WindowGroup {
            ContentView()
                .theme(themeProvider)
        }
    }
}
```

## アーキテクチャ

### 3層トークンシステム

```
Primitive Tokens (基本値)
    ↓ 参照
Semantic Tokens (意味的なトークン)
    ↓ 参照
Component Tokens (コンポーネント固有の値)
```

#### 1. Primitive Tokens

生の値を定義（色のHEXコード、スペーシングのpt値など）。**直接使用は避けてください。**

```swift
PrimitiveColors.blue500  // ❌ 直接使用しない
PrimitiveSpacing.space16 // ❌ 直接使用しない
```

#### 2. Semantic Tokens

意味のあるトークン（primary, surface, onSurfaceなど）をプロトコルで定義。

```swift
@Environment(\.colorPalette) var colors  // ✅
@Environment(\.spacingScale) var spacing // ✅
```

#### 3. Component Tokens

コンポーネント固有の値（ButtonSize, Elevationなど）。

```swift
.buttonSize(.large)    // ✅
Card(elevation: .level2) { ... }  // ✅
```

## API リファレンス

### Tokens

#### Semantic Tokens
- `ColorPalette` - カラーパレットプロトコル
- `SpacingScale` - スペーシングスケールプロトコル
- `RadiusScale` - 角丸スケールプロトコル
- `Typography` - タイポグラフィトークン

#### Component Tokens
- `ButtonSize` - ボタンサイズバリアント
- `Elevation` - 影のレベル定義

#### Primitive Tokens (内部使用)
- `PrimitiveColors` - 基本的な色パレット
- `PrimitiveSpacing` - 基本的なスペーシング値
- `PrimitiveRadius` - 基本的な角丸値

### Theme System

#### Core
- `ThemeProvider` - テーマとモードの管理（@Observable対応）
- `Theme` - テーマプロトコル
- `ThemeMode` - ライト/ダークモードの列挙型
- `ThemeCategory` - テーマカテゴリ（標準/ブランド/アクセシビリティ）
- `ThemeRegistry` - ビルトインテーマのレジストリ

#### Built-in Themes (7種類)
- `DefaultTheme` - 標準テーマ
- `OceanTheme` - Ocean（深い青）
- `ForestTheme` - Forest（自然な緑）
- `SunsetTheme` - Sunset（温かいオレンジ）
- `PurpleHazeTheme` - PurpleHaze（創造的な紫）
- `MonochromeTheme` - Monochrome（ミニマルなグレー）
- `HighContrastTheme` - HighContrast（WCAG AAA準拠）

#### Color Palettes
- 各テーマに対応するLight/Darkパレット（14種類）
- `DefaultSpacingScale` / `DefaultRadiusScale` - デフォルトスケール

### Components

- Button Styles: `PrimaryButtonStyle`, `SecondaryButtonStyle`, `TertiaryButtonStyle`, `TextButtonStyle`
- `Card` - 汎用カードコンポーネント
- `IconButton` - アイコンボタン
- `FloatingActionButton` - フローティングアクションボタン
- `DSTextField` - デザインシステム対応テキストフィールド

### Layout Patterns

- `SectionCard` - タイトル付きカードセクション

### View Modifiers

- `.theme(_:)` - テーマ適用
- `.buttonSize(_:)` - ボタンサイズ指定
- `.typography(_:)` - タイポグラフィ適用

## 使用例

詳細な使用例は[完全なドキュメント](https://no-problem-dev.github.io/swift-design-system/documentation/designsystem/)を参照してください。

### ログイン画面

```swift
struct LoginView: View {
    @Environment(\.colorPalette) var colors
    @Environment(\.spacingScale) var spacing
    @State private var email = ""
    @State private var password = ""

    var body: some View {
        VStack(spacing: spacing.xl) {
            Text("ログイン")
                .typography(.headlineLarge)
                .foregroundColor(colors.onBackground)

            VStack(spacing: spacing.md) {
                DSTextField(
                    text: $email,
                    placeholder: "メールアドレス",
                    keyboardType: .emailAddress
                )

                DSTextField(
                    text: $password,
                    placeholder: "パスワード",
                    isSecure: true
                )
            }

            Button("ログイン") { login() }
                .buttonStyle(.primary)
                .buttonSize(.large)

            Button("パスワードを忘れた場合") { resetPassword() }
                .buttonStyle(.text)
        }
        .padding(spacing.xl)
        .background(colors.background)
    }
}
```

### 設定画面

```swift
struct SettingsView: View {
    @Environment(\.spacingScale) var spacing

    var body: some View {
        ScrollView {
            VStack(spacing: spacing.xl) {
                SectionCard(title: "アカウント") {
                    VStack(spacing: spacing.md) {
                        SettingRow(title: "プロフィール編集", icon: "person")
                        SettingRow(title: "通知設定", icon: "bell")
                    }
                }

                SectionCard(title: "一般") {
                    VStack(spacing: spacing.md) {
                        SettingRow(title: "言語", icon: "globe")
                        SettingRow(title: "テーマ", icon: "paintbrush")
                    }
                }
            }
            .padding(.vertical, spacing.xl)
        }
    }
}
```

## 要件

- iOS 17.0+ / macOS 14.0+
- Swift 6.0+
- Xcode 16.0+

## ライセンス

MIT License - 詳細は [LICENSE](LICENSE) を参照

## 開発者向け情報

- 🚀 **リリース作業**: [リリースプロセス](RELEASE_PROCESS.md) - 新バージョンをリリースする手順

## サポート

- 📚 [完全なドキュメント](https://no-problem-dev.github.io/swift-design-system/documentation/designsystem/)
- 🐛 [Issue報告](https://github.com/no-problem-dev/swift-design-system/issues)
- 💬 [ディスカッション](https://github.com/no-problem-dev/swift-design-system/discussions)

---

Made with ❤️ by [NOPROBLEM](https://github.com/no-problem-dev)
