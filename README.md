# DesignSystem

SwiftUI向けの型安全で拡張可能なデザインシステム

![Swift](https://img.shields.io/badge/Swift-6.2-orange.svg)
![Platforms](https://img.shields.io/badge/Platforms-iOS%2017.0+%20%7C%20macOS%2014.0+-blue.svg)
![License](https://img.shields.io/badge/License-MIT-yellow.svg)

## 特徴

- **3層トークンシステム** - Primitive → Semantic → Component の明確な階層
- **型安全** - プロトコルベース設計により拡張性が高い
- **7種類のビルトインテーマ** - Default、Ocean、Forest、Sunset、PurpleHaze、Monochrome、HighContrast
- **ライト/ダークモード対応** - 全テーマでシームレスなモード切り替え
- **豊富なコンポーネント** - Button、Card、Chip、TextField、FAB、Snackbar、ProgressBar など

## インストール

```swift
// Package.swift
dependencies: [
    .package(url: "https://github.com/no-problem-dev/swift-design-system.git", .upToNextMajor(from: "1.0.0"))
]
```

## クイックスタート

### テーマの適用

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

### デザイントークンの使用

```swift
struct MyView: View {
    @Environment(\.colorPalette) var colors
    @Environment(\.spacingScale) var spacing

    var body: some View {
        VStack(spacing: spacing.lg) {
            Text("見出し")
                .typography(.headlineLarge)
                .foregroundColor(colors.primary)
            Text("本文")
                .typography(.bodyMedium)
                .foregroundColor(colors.onSurface)
        }
        .padding(spacing.xl)
        .background(colors.surface)
    }
}
```

### コンポーネント

```swift
// ボタン
Button("保存") { save() }
    .buttonStyle(.primary)
    .buttonSize(.large)

// カード
Card(elevation: .level2) {
    Text("カードの内容").typography(.bodyMedium)
}

// テキストフィールド
DSTextField("メールアドレス", text: $email, placeholder: "example@email.com", leadingIcon: "envelope")
```

### テーマの切り替え

```swift
// ビルトインテーマに切り替え
themeProvider.switchToTheme(id: "ocean")

// モードを切り替え（system → light → dark → system）
themeProvider.toggleMode()
```

## ドキュメント

詳細なガイドと API リファレンスは DocC ドキュメントを参照してください。

| ガイド | 内容 |
|-------|------|
| [Getting Started](https://no-problem-dev.github.io/swift-design-system/documentation/designsystem/gettingstarted) | セットアップと基本的な使い方 |
| [Token Architecture](https://no-problem-dev.github.io/swift-design-system/documentation/designsystem/tokenarchitecture) | 3層トークンシステムの設計思想 |
| [Custom Theme](https://no-problem-dev.github.io/swift-design-system/documentation/designsystem/customtheme) | カスタムテーマの作成方法 |
| [API Reference](https://no-problem-dev.github.io/swift-design-system/documentation/designsystem/) | 全パブリック API |

## 要件

- iOS 17.0+ / macOS 14.0+
- Swift 6.2+
- Xcode 16.0+

## ライセンス

MIT License - 詳細は [LICENSE](LICENSE) を参照

## リンク

- [完全なドキュメント](https://no-problem-dev.github.io/swift-design-system/documentation/designsystem/)
- [Issue報告](https://github.com/no-problem-dev/swift-design-system/issues)
- [ディスカッション](https://github.com/no-problem-dev/swift-design-system/discussions)
- [リリースプロセス](RELEASE_PROCESS.md)
