# ``DesignSystem``

A type-safe, extensible design system for SwiftUI.

## Overview

DesignSystem is built on a three-layer token architecture — Primitive, Semantic, and
Component. Every token layer is expressed as a protocol, so a theme supplies values by
conforming rather than by editing the library, and the compiler catches a token that a
theme forgot to define.

Install a theme once at the root of the app:

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

Every view below that point reads tokens out of the environment. Reading them this way,
rather than hard-coding values, is what makes a theme switch take effect everywhere at once:

```swift
struct ProfileHeader: View {
    @Environment(\.colorPalette) var colors
    @Environment(\.spacingScale) var spacing

    var body: some View {
        VStack(alignment: .leading, spacing: spacing.sm) {
            Text("Ada Lovelace")
                .typography(.headlineLarge)
                .foregroundStyle(colors.onSurface)
            Text("Mathematician")
                .typography(.bodyMedium)
                .foregroundStyle(colors.onSurfaceVariant)
        }
        .padding(spacing.xl)
        .background(colors.surface)
    }
}
```

Seven themes ship with the package — Default, Ocean, Forest, Sunset, PurpleHaze,
Monochrome, and HighContrast — and each resolves a separate palette for light and dark.

### Platform availability

Most of the package builds for both iOS and macOS. The media pieces wrap UIKit and are
therefore iOS-only, compiled behind `#if canImport(UIKit)`: `VideoPlayerView`,
`ImagePickerModifier` (the `.imagePicker()` modifier), and `VideoPickerModifier`
(the `.videoPicker()` modifier).

This documentation is generated on macOS, so those three do not appear in the symbol
reference below. Build the docs for an iOS destination to see them.

## Topics

### Essentials

- <doc:GettingStarted>
- <doc:TokenArchitecture>
- <doc:CustomTheme>
- ``ThemeProvider``
- ``Theme``
- ``ThemeMode``

### Semantic tokens

- ``ColorPalette``
- ``SpacingScale``
- ``RadiusScale``
- ``Typography``
- ``TypographyScale``
- ``Motion``
- ``BorderScale``
- ``IconSizeScale``
- ``IconSizeToken``

### Component tokens

- ``Elevation``
- ``ElevationScale``
- ``GridSpacing``

### Themes

- ``ThemeCategory``
- ``ThemeRegistry``
- ``DefaultTheme``
- ``OceanTheme``
- ``ForestTheme``
- ``SunsetTheme``
- ``PurpleHazeTheme``
- ``MonochromeTheme``
- ``HighContrastTheme``

### Default token implementations

- ``DefaultSpacingScale``
- ``DefaultRadiusScale``
- ``DefaultMotion``
- ``DefaultIconSizeScale``
- ``DefaultBorderScale``
- ``DefaultElevationScale``
- ``DefaultTypographyScale``

### Buttons

- ``PrimaryButtonStyle``
- ``SecondaryButtonStyle``
- ``TertiaryButtonStyle``
- ``GlassButtonStyle``
- ``PrimaryGlassButtonStyle``
- ``PrimaryTonalButtonStyle``
- ``ButtonSize``
- ``IconButton``
- ``IconButtonStyle``
- ``IconButtonSize``
- ``FloatingActionButton``
- ``FABSize``
- ``FABStyle``

### Input

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
- ``SegmentedControl``
- ``GlassSegmentedControl``

### Display

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
- ``EmptyState``
- ``Snackbar``
- ``SnackbarState``
- ``SnackbarAction``
- ``AttachmentStrip``
- ``AttachmentThumbnail``
- ``MediaViewerItem``
- ``TimelineRow``
- ``TitleTextRenderer``

### Layout patterns

- ``SectionCard``
- ``SectionRow``
- ``SectionRowLabel``
- ``SectionRowDivider``
- ``SectionNavigationLabel``
- ``AspectGrid``
- ``StaggeredView``
- ``StaggeredConfig``
- ``LoopingScrollView``

### Pickers

- ``EmojiPickerModifier``
- ``IconPickerModifier``
- ``ColorPickerModifier``
- ``ColorPreset``

### Browsing the system at runtime

- ``DesignSystemCatalogView``
- ``DesignSystemCatalogSplitView``
- ``ThemeGalleryView``
- ``ThemeDetailView``

### Utilities

- ``SurfaceStyle``
- ``ThemeColorScheme``
- ``ByteSize``
- ``ImageResizeRule``
