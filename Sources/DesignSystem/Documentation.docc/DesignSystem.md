# ``DesignSystem``

SwiftUI 向けの型安全で拡張可能なデザインシステム。

## Overview

DesignSystem は、Primitive → Semantic → Component の 3 層トークンアーキテクチャに基づいた
SwiftUI 用デザインシステムライブラリ。
プロトコルベース設計により、型安全性と拡張性を両立する。

テーマの適用はシンプル:

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

View 内では Environment からデザイントークンを取得して使用する:

```swift
struct MyView: View {
    @Environment(\.colorPalette) var colors
    @Environment(\.spacingScale) var spacing

    var body: some View {
        VStack(spacing: spacing.lg) {
            Text("見出し")
                .typography(.headlineLarge)
                .foregroundStyle(colors.primary)
        }
        .padding(spacing.xl)
    }
}
```

### iOS 専用コンポーネント

以下のコンポーネントは iOS 専用（`#if canImport(UIKit)` で条件コンパイル）:

- `VideoPlayerView` - 動画再生プレーヤー
- `ImagePickerModifier` - 画像ピッカー（`.imagePicker()`）
- `VideoPickerModifier` - 動画ピッカー（`.videoPicker()`）

## Topics

### エッセンシャル

- <doc:GettingStarted>
- <doc:TokenArchitecture>
- <doc:CustomTheme>
- ``ThemeProvider``
- ``Theme``
- ``ThemeMode``

### デザイントークン

- ``ColorPalette``
- ``SpacingScale``
- ``RadiusScale``
- ``Typography``
- ``Motion``
- ``Elevation``

### テーマシステム

- ``ThemeCategory``
- ``ThemeRegistry``
- ``DefaultTheme``
- ``OceanTheme``
- ``ForestTheme``
- ``SunsetTheme``
- ``PurpleHazeTheme``
- ``MonochromeTheme``
- ``HighContrastTheme``

### トークンデフォルト

- ``DefaultSpacingScale``
- ``DefaultRadiusScale``
- ``DefaultMotion``

### コンポーネント - ボタン

- ``PrimaryButtonStyle``
- ``SecondaryButtonStyle``
- ``TertiaryButtonStyle``
- ``GlassButtonStyle``
- ``PrimaryGlassButtonStyle``
- ``PrimaryTonalButtonStyle``
- ``ButtonSize``

### コンポーネント - 入力

- ``DSTextField``
- ``DSTextFieldStyle``
- ``Chip``
- ``ParameterChip``
- ``ChipStyle``
- ``ChipStyleConfiguration``
- ``AnyChipStyle``
- ``ChipSize``
- ``FilledChipStyle``
- ``OutlinedChipStyle``
- ``LiquidGlassChipStyle``

### コンポーネント - 表示

- ``Card``
- ``LinkCard``
- ``IconBadge``
- ``IconBadgeSize``
- ``StatDisplay``
- ``StatDisplaySize``
- ``ProgressBar``
- ``Spinner``
- ``StatusIndicator``
- ``StatusKind``
- ``StepIndicator``
- ``Snackbar``
- ``SnackbarState``
- ``SnackbarAction``
- ``AttachmentStrip``
- ``AttachmentThumbnail``
- ``MediaViewerItem``
- ``TimelineRow``

### コンポーネント - アクション

- ``IconButton``
- ``IconButtonStyle``
- ``IconButtonSize``
- ``FloatingActionButton``
- ``FABSize``
- ``FABStyle``

### セグメントコントロール

- ``SegmentedControl``
- ``GlassSegmentedControl``

### レイアウトパターン

- ``SectionCard``
- ``SectionRow``
- ``SectionRowDivider``
- ``SectionNavigationLabel``
- ``AspectGrid``
- ``StaggeredView``
- ``StaggeredConfig``
- ``LoopingScrollView``

### ピッカー

- ``EmojiPickerModifier``
- ``IconPickerModifier``
- ``ColorPickerModifier``

### トークンプロトコル

- ``TypographyScale``
- ``BorderScale``
- ``ElevationScale``
- ``GradientTokens``
- ``StateLayer``
- ``IconSizeScale``

### トークンデフォルト

- ``DefaultSpacingScale``
- ``DefaultRadiusScale``
- ``DefaultMotion``
- ``DefaultIconSizeScale``
- ``DefaultBorderScale``
- ``DefaultElevationScale``
- ``DefaultGradientTokens``
- ``DefaultStateLayer``
- ``DefaultTypographyScale``

### ユーティリティ

- ``SurfaceStyle``
- ``ThemeColorScheme``
- ``IconSizeToken``
- ``ByteSize``
- ``TitleTextRenderer``
