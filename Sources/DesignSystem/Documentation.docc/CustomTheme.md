# Creating a custom theme

Put a brand's colors into the system by conforming, not by editing the library.

## Overview

A theme is two protocol conformances: a ``ColorPalette`` per appearance, and a ``Theme``
that hands back the right palette for a given ``ThemeMode``. Nothing in the package needs to
be modified, and a theme defined in your app sits alongside the built-in seven.

Everything except color has a default implementation on ``Theme``, so a brand theme that
only changes color is short. Override `spacingScale`, `radiusScale`, `typographyScale`, or
`motion` only when the brand actually differs there — overriding them to restate the
defaults is how a theme drifts out of sync with the package.

## Step 1: implement a palette

``ColorPalette`` has fourteen requirements without defaults: `primary`, `secondary`,
`tertiary`, `background`, `onBackground`, `surface`, `onSurface`, `surfaceVariant`,
`onSurfaceVariant`, `error`, `warning`, `success`, `info`, and `outline`.

The rest are derived for you — the `on-` colors default to white or black, the `-Container`
colors to a 12% tint of their base, `outlineVariant` to a half-strength `outline`, and the
elevated surfaces to `surface`. Define one of those only when the derived value is wrong for
the brand.

```swift
struct MyBrandLightPalette: ColorPalette {
    let primary = Color(hex: "#007AFF")
    let secondary = Color(hex: "#5856D6")
    let tertiary = Color(hex: "#FF9500")

    let background = Color.white
    let onBackground = Color.black
    let surface = Color(white: 0.98)
    let onSurface = Color(white: 0.1)
    let surfaceVariant = Color(white: 0.95)
    let onSurfaceVariant = Color(white: 0.3)

    let error = Color.red
    let warning = Color.orange
    let success = Color.green
    let info = Color.blue

    let outline = Color(white: 0.8)

    // The default elevated surfaces are flat `surface`; lift them so cards
    // read as raised on a white background.
    let elevatedSurface = Color.white
    let elevatedSurfaceHigh = Color.white
}
```

`Color(hex:)` accepts three-, six-, and eight-digit hex, with or without a leading `#`.

Write a second palette for dark. Do not reuse the light one with adjusted opacity: contrast
against a dark background is a different problem, and the `on-` colors have to be
recalculated rather than dimmed.

## Step 2: implement the theme

``Theme`` requires an identifier, display metadata, a ``ThemeCategory``, preview colors for
theme pickers, and the palette lookup:

```swift
struct MyBrandTheme: Theme {
    var id: String { "myBrand" }
    var name: String { "My Brand" }
    var description: String { "Corporate brand colors" }
    var category: ThemeCategory { .brandPersonality }
    var previewColors: [Color] {
        [Color(hex: "#007AFF"), Color(hex: "#5856D6"), Color(hex: "#FF9500")]
    }

    func colorPalette(for mode: ThemeMode) -> any ColorPalette {
        switch mode {
        case .system, .light:
            MyBrandLightPalette()
        case .dark:
            MyBrandDarkPalette()
        }
    }
}
```

`id` is the key `switchToTheme(id:)` looks up and the key registration deduplicates on, so
it has to be unique and stable. Changing it later orphans any stored preference that
referred to the old value.

Note that `.system` is resolved to the light palette here. The environment's color scheme
still drives which one is used at runtime; the `.system` case only decides what to return
when asked directly.

## Step 3: register it

As the starting theme:

```swift
@State private var themeProvider = ThemeProvider(
    initialTheme: MyBrandTheme()
)
```

Alongside the built-in themes, so the user can pick it:

```swift
@State private var themeProvider = ThemeProvider(
    additionalThemes: [MyBrandTheme()]
)
```

Both at once:

```swift
@State private var themeProvider = ThemeProvider(
    initialTheme: MyBrandTheme(),
    additionalThemes: [SeasonalTheme(), CampaignTheme()]
)
```

The initializer skips any theme whose `id` is already registered, so passing the same theme
through both parameters is harmless. `registerTheme(_:)` behaves differently on purpose: it
*replaces* an existing entry with the same `id`, which is what you want for swapping a
theme in at runtime.

## Topics

### Related

- ``Theme``
- ``ThemeProvider``
- ``ColorPalette``
- ``ThemeMode``
- ``ThemeCategory``
