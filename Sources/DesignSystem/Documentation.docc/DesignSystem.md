# ``DesignSystem``

SwiftUI向けの型安全で拡張可能なデザインシステム。

## Overview

DesignSystemは、Primitive → Semantic → Component の3層トークンアーキテクチャに基づいた
SwiftUI用デザインシステムライブラリです。
プロトコルベース設計により、型安全性と拡張性を両立しています。

テーマの適用はシンプルです:

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

View内ではEnvironmentからデザイントークンを取得して使用します:

```swift
struct MyView: View {
    @Environment(\.colorPalette) var colors
    @Environment(\.spacingScale) var spacing

    var body: some View {
        VStack(spacing: spacing.lg) {
            Text("見出し")
                .typography(.headlineLarge)
                .foregroundColor(colors.primary)
        }
        .padding(spacing.xl)
    }
}
```

### iOS Only Components

以下のコンポーネントはiOS専用です（`#if canImport(UIKit)` で条件コンパイル）:

- `VideoPlayerView` - 動画再生プレーヤー
- `ImagePickerModifier` - 画像ピッカー（`.imagePicker()`）
- `VideoPickerModifier` - 動画ピッカー（`.videoPicker()`）

## Topics

### Essentials

- <doc:GettingStarted>
- <doc:TokenArchitecture>
- <doc:CustomTheme>
- ``ThemeProvider``
- ``Theme``
- ``ThemeMode``

### Design Tokens

- ``ColorPalette``
- ``SpacingScale``
- ``RadiusScale``
- ``Typography``
- ``Motion``
- ``Elevation``

### Theme System

- ``ThemeCategory``
- ``ThemeRegistry``
- ``DefaultTheme``
- ``OceanTheme``
- ``ForestTheme``
- ``SunsetTheme``
- ``PurpleHazeTheme``
- ``MonochromeTheme``
- ``HighContrastTheme``

### Token Defaults

- ``DefaultSpacingScale``
- ``DefaultRadiusScale``
- ``DefaultMotion``

### Components - Button

- ``PrimaryButtonStyle``
- ``SecondaryButtonStyle``
- ``TertiaryButtonStyle``
- ``ButtonSize``

### Components - Input

- ``DSTextField``
- ``Chip``
- ``ChipStyle``
- ``ChipSize``
- ``FilledChipStyle``
- ``OutlinedChipStyle``
- ``LiquidGlassChipStyle``

### Components - Display

- ``Card``
- ``IconBadge``
- ``IconBadgeSize``
- ``StatDisplay``
- ``StatDisplaySize``
- ``ProgressBar``
- ``Snackbar``
- ``SnackbarState``
- ``SnackbarAction``

### Components - Action

- ``IconButton``
- ``IconButtonStyle``
- ``IconButtonSize``
- ``FloatingActionButton``
- ``FABSize``

### Layout Patterns

- ``SectionCard``
- ``AspectGrid``

### Pickers

- ``EmojiPickerModifier``
- ``IconPickerModifier``
- ``ColorPickerModifier``

### Utilities

- ``ByteSize``
