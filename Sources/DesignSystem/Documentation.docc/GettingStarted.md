# はじめに

DesignSystem のセットアップと基本的な使い方。

## Overview

DesignSystem の導入は 3 ステップで完了する:
パッケージの追加、テーマのセットアップ、デザイントークンの利用開始。

## インストール

### Swift Package Manager

`Package.swift` に依存を追加する:

```swift
dependencies: [
    .package(url: "https://github.com/no-problem-dev/swift-design-system.git", from: "1.7.0")
]
```

または、Xcode の File > Add Package Dependencies から URL を入力する。

## セットアップ

アプリのルートに ``ThemeProvider`` を設定し、`.theme()` モディファイアで適用する:

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

これにより、全ての子 View でデザイントークンが利用可能になる。

## デザイントークンの利用

### カラーパレット

``ColorPalette`` は Environment から取得する:

```swift
struct MyView: View {
    @Environment(\.colorPalette) var colors

    var body: some View {
        Text("Hello")
            .foregroundStyle(colors.primary)
            .background(colors.surface)
    }
}
```

### スペーシング

``SpacingScale`` で一貫したスペーシングを適用する:

```swift
@Environment(\.spacingScale) var spacing

VStack(spacing: spacing.lg) {  // 16pt
    Text("項目1")
    Text("項目2")
}
.padding(spacing.xl)  // 24pt
```

### タイポグラフィ

``Typography`` モディファイアでテキストスタイルを適用する:

```swift
Text("大見出し").typography(.headlineLarge)
Text("本文").typography(.bodyMedium)
Text("ラベル").typography(.labelSmall)
```

## コンポーネントの利用

### ボタン

```swift
Button("保存") { save() }
    .buttonStyle(.primary)
    .buttonSize(.large)

Button("キャンセル") { cancel() }
    .buttonStyle(.secondary)
```

### カード

```swift
Card(elevation: .level2) {
    VStack(alignment: .leading, spacing: spacing.md) {
        Text("タイトル").typography(.titleMedium)
        Text("内容").typography(.bodyMedium)
    }
}
```

### テキストフィールド

```swift
DSTextField(
    "メールアドレス",
    text: $email,
    placeholder: "example@email.com",
    leadingIcon: "envelope"
)
```

## テーマの切り替え

``ThemeProvider`` を使ってテーマやモードを動的に切り替えられる:

```swift
@Environment(ThemeProvider.self) private var themeProvider

// テーマ切り替え
themeProvider.switchToTheme(id: "ocean")

// モード切り替え（system → light → dark → system の順で循環）
themeProvider.toggleMode()
```

7 種類のビルトインテーマが用意されている:
Default, Ocean, Forest, Sunset, PurpleHaze, Monochrome, HighContrast

## Topics

### 関連

- ``ThemeProvider``
- ``Theme``
- ``ColorPalette``
- ``SpacingScale``
- ``Typography``
