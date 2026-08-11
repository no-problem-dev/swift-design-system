[English](./README.md) | 日本語

# DesignSystem

SwiftUI アプリのための、型安全でテーマを差し替えられるデザインシステム。

![Swift](https://img.shields.io/badge/Swift-6.2-orange.svg)
![Platforms](https://img.shields.io/badge/Platforms-iOS%2017.0+%20%7C%20macOS%2014.0+-blue.svg)
![License](https://img.shields.io/badge/License-MIT-yellow.svg)

## 特徴

- **3 層トークンシステム** — Primitive → Semantic → Component。View がどの層に触れてよいかの規則が明確
- **プロトコルベース** — テーマは準拠して値を与える。トークンを実装し忘れたテーマはコンパイルが通らない
- **7 種類のビルトインテーマ** — Default、Ocean、Forest、Sunset、PurpleHaze、Monochrome、HighContrast。それぞれライトとダークで別のパレットを持つ
- **トークンの上に立つコンポーネント** — Button、Card、Chip、TextField、FAB、Snackbar、ProgressBar など。テーマを切り替えれば呼び出し側を触らずに一斉に見た目が変わる
- **ガラス面** — `SurfaceStyle` に応じて描画が変わる。Elevation は影の濃さではなくボーダーの輝度として解釈し直される

各コンポーネントの描画結果はリポジトリに入っている。
[`Tests/DesignSystemTests/__Snapshots__/`](Tests/DesignSystemTests/__Snapshots__)
に 22 コンポーネント × ライト/ダークの 148 枚があり、iOS シミュレータ上のスナップショットスイートが照合する。

## クイックスタート

ルートで一度テーマを差し込み、以降はどの View でも Environment からトークンを読む:

```swift
@main
struct MyApp: App {
    @State private var themeProvider = ThemeProvider()

    var body: some Scene {
        WindowGroup {
            ContentView().theme(themeProvider)
        }
    }
}

struct ContentView: View {
    @Environment(\.spacingScale) var spacing

    var body: some View {
        Card(elevation: .level2) {
            VStack(alignment: .leading, spacing: spacing.md) {
                Text("週次レポート").typography(.titleMedium)
                Chip("準備完了").chipStyle(.filled)
            }
        }
        .padding(spacing.xl)
    }
}
```

実行中にテーマやモードを切り替えると、全体が一斉に追従する:

```swift
themeProvider.switchToTheme(id: "ocean")
themeProvider.toggleMode()   // system → light → dark → system
```

## ドキュメント

[**API リファレンスとガイド**](https://no-problem-dev.github.io/swift-design-system/documentation/designsystem/) —
[Getting Started](https://no-problem-dev.github.io/swift-design-system/documentation/designsystem/gettingstarted/)、
[Token Architecture](https://no-problem-dev.github.io/swift-design-system/documentation/designsystem/tokenarchitecture/)、
[Custom Theme](https://no-problem-dev.github.io/swift-design-system/documentation/designsystem/customtheme/) を含む。

## インストール

```swift
// Package.swift
dependencies: [
    .package(url: "https://github.com/no-problem-dev/swift-design-system.git", from: "4.0.0")
]
```

3 つのライブラリを提供する: `DesignSystem`（SwiftUI のデザインシステム本体）、
`DesignSpec`（ブランドのデザイン仕様を表す純データ）、
`DesignCatalogKit`（ブランド横断のギャラリーとトークン差分）。

## 要件

- iOS 17.0+ / macOS 14.0+
- Swift 6.2+
- Xcode 16.0+

## ライセンス

MIT License — 詳細は [LICENSE](LICENSE) を参照
