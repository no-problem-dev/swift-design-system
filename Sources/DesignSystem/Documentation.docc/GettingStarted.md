# Getting started

Set up a theme, then build screens out of tokens instead of literals.

## Overview

Adopting DesignSystem takes two steps: install a ``ThemeProvider`` at the root of the app,
and read tokens from the environment in every view below it. Everything else in the package
— components, modifiers, pickers — is built on those same tokens, so it inherits whatever
theme is in effect without further wiring.

The package is distributed with Swift Package Manager. The dependency line is in the
README, which is kept in sync with the current release.

## Installing a theme

``ThemeProvider`` owns the active theme and the active ``ThemeMode``. Create one at the app
level and apply it with `.theme(_:)`:

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

`.theme(_:)` publishes every token of the resolved theme into the environment at once, and
puts the provider itself there as well. A view that needs to change the theme can reach it
with `@Environment(ThemeProvider.self)`.

## Reading tokens

### Color

``ColorPalette`` names colors by role rather than by hue, and each role has a matching
`on-` role for content drawn on top of it. Pairing `surface` with `onSurface`, rather than
picking a text color by eye, is what keeps contrast correct after a theme or mode switch:

```swift
struct StatusBanner: View {
    @Environment(\.colorPalette) var colors

    var body: some View {
        Text("Saved")
            .foregroundStyle(colors.onSuccess)
            .background(colors.success)
    }
}
```

### Spacing

``SpacingScale`` replaces ad-hoc padding numbers with ten named steps, so unrelated screens
end up on the same rhythm:

```swift
@Environment(\.spacingScale) var spacing

VStack(spacing: spacing.lg) {
    Text("First item")
    Text("Second item")
}
.padding(spacing.xl)
```

### Typography

The `typography(_:)` modifier applies a role from ``TypographyScale``. Roles scale with
Dynamic Type, which a raw `.font(.system(size:))` does not:

```swift
Text("Large heading").typography(.headlineLarge)
Text("Body copy").typography(.bodyMedium)
Text("Caption").typography(.labelSmall)
```

## Using components

Components take their sizing and styling from tokens, so they need no per-call color work:

```swift
Button("Save") { save() }
    .buttonStyle(.primary)
    .buttonSize(.large)

Button("Cancel") { cancel() }
    .buttonStyle(.secondary)

Card(elevation: .level2) {
    VStack(alignment: .leading, spacing: spacing.md) {
        Text("Title").typography(.titleMedium)
        Text("Supporting copy").typography(.bodyMedium)
    }
}

DSTextField(
    "Email",
    text: $email,
    placeholder: "example@email.com",
    leadingIcon: "envelope"
)
```

## Switching themes at runtime

``ThemeProvider`` can change theme and mode while the app is running; the change propagates
to every view that reads tokens from the environment:

```swift
@Environment(ThemeProvider.self) private var themeProvider

themeProvider.switchToTheme(id: "ocean")

// Cycles system → light → dark → system.
themeProvider.toggleMode()
```

Seven themes are registered out of the box: Default, Ocean, Forest, Sunset, PurpleHaze,
Monochrome, and HighContrast. To add your own, see <doc:CustomTheme>.

## Topics

### Related

- <doc:TokenArchitecture>
- <doc:CustomTheme>
- ``ThemeProvider``
- ``Theme``
- ``ColorPalette``
- ``SpacingScale``
- ``Typography``
