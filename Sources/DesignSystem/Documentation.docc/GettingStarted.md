# Getting Started

DesignSystemのセットアップと基本的な使い方。

## Overview

DesignSystemの導入は3ステップで完了します:
パッケージの追加、テーマのセットアップ、デザイントークンの利用開始です。

## Installation

### Swift Package Manager

`Package.swift`に依存を追加します:

```swift
dependencies: [
    .package(url: "https://github.com/no-problem-dev/swift-design-system.git", .upToNextMajor(from: "1.0.0"))
]
```

または、Xcode の File > Add Package Dependencies からURLを入力してください。

## Setup

アプリのルートに``ThemeProvider``を設定し、`.theme()`モディファイアで適用します:

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

これにより、全ての子Viewでデザイントークンが利用可能になります。

## Using Design Tokens

### Color Palette

``ColorPalette``はEnvironmentから取得します:

```swift
struct MyView: View {
    @Environment(\.colorPalette) var colors

    var body: some View {
        Text("Hello")
            .foregroundColor(colors.primary)
            .background(colors.surface)
    }
}
```

### Spacing

``SpacingScale``で一貫したスペーシングを適用します:

```swift
@Environment(\.spacingScale) var spacing

VStack(spacing: spacing.lg) {  // 16pt
    Text("項目1")
    Text("項目2")
}
.padding(spacing.xl)  // 24pt
```

### Typography

``Typography``モディファイアでテキストスタイルを適用します:

```swift
Text("大見出し").typography(.headlineLarge)
Text("本文").typography(.bodyMedium)
Text("ラベル").typography(.labelSmall)
```

## Using Components

### Buttons

```swift
Button("保存") { save() }
    .buttonStyle(.primary)
    .buttonSize(.large)

Button("キャンセル") { cancel() }
    .buttonStyle(.secondary)
```

### Cards

```swift
Card(elevation: .level2) {
    VStack(alignment: .leading, spacing: spacing.md) {
        Text("タイトル").typography(.titleMedium)
        Text("内容").typography(.bodyMedium)
    }
}
```

### Text Fields

```swift
DSTextField(
    "メールアドレス",
    text: $email,
    placeholder: "example@email.com",
    leadingIcon: "envelope"
)
```

## Switching Themes

``ThemeProvider``を使ってテーマやモードを動的に切り替えられます:

```swift
@Environment(ThemeProvider.self) private var themeProvider

// テーマ切り替え
themeProvider.switchToTheme(id: "ocean")

// モード切り替え（system → light → dark → system の順で循環）
themeProvider.toggleMode()
```

7種類のビルトインテーマが用意されています:
Default, Ocean, Forest, Sunset, PurpleHaze, Monochrome, HighContrast

## Topics

### Related

- ``ThemeProvider``
- ``Theme``
- ``ColorPalette``
- ``SpacingScale``
- ``Typography``
