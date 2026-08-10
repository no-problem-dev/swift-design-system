English | [日本語](./README.ja.md)

# DesignSystem

Type-safe and extensible design system for SwiftUI

![Swift](https://img.shields.io/badge/Swift-6.2-orange.svg)
![Platforms](https://img.shields.io/badge/Platforms-iOS%2017.0+%20%7C%20macOS%2014.0+-blue.svg)
![License](https://img.shields.io/badge/License-MIT-yellow.svg)

## Features

- **3-layer token system** — Clear hierarchy: Primitive → Semantic → Component
- **Type-safe** — Protocol-based design for high extensibility
- **7 built-in themes** — Default, Ocean, Forest, Sunset, PurpleHaze, Monochrome, HighContrast
- **Light/Dark mode support** — Seamless mode switching across all themes
- **Rich component library** — Button, Card, Chip, TextField, FAB, Snackbar, ProgressBar, and more

## Installation

```swift
// Package.swift
dependencies: [
    .package(url: "https://github.com/no-problem-dev/swift-design-system.git", from: "3.0.0")
]
```

## Quick Start

### Applying a Theme

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

### Using Design Tokens

```swift
struct MyView: View {
    @Environment(\.colorPalette) var colors
    @Environment(\.spacingScale) var spacing

    var body: some View {
        VStack(spacing: spacing.lg) {
            Text("Heading")
                .typography(.headlineLarge)
                .foregroundStyle(colors.primary)
            Text("Body")
                .typography(.bodyMedium)
                .foregroundStyle(colors.onSurface)
        }
        .padding(spacing.xl)
        .background(colors.surface)
    }
}
```

### Components

```swift
// Button
Button("Save") { save() }
    .buttonStyle(.primary)
    .buttonSize(.large)

// Card
Card(elevation: .level2) {
    Text("Card content").typography(.bodyMedium)
}

// Text Field
DSTextField("Email", text: $email, placeholder: "example@email.com", leadingIcon: "envelope")
```

### Switching Themes

```swift
// Switch to a built-in theme
themeProvider.switchToTheme(id: "ocean")

// Cycle mode (system → light → dark → system)
themeProvider.toggleMode()
```

## Documentation

See the DocC documentation for detailed guides and API reference.

| Guide | Description |
|-------|-------------|
| [Getting Started](https://no-problem-dev.github.io/swift-design-system/documentation/designsystem/gettingstarted/) | Setup and basic usage |
| [Token Architecture](https://no-problem-dev.github.io/swift-design-system/documentation/designsystem/tokenarchitecture/) | 3-layer token system design |
| [Custom Theme](https://no-problem-dev.github.io/swift-design-system/documentation/designsystem/customtheme/) | Creating a custom theme |
| [API Reference](https://no-problem-dev.github.io/swift-design-system/documentation/designsystem/) | Complete public API |

## Requirements

- iOS 17.0+ / macOS 14.0+
- Swift 6.2+
- Xcode 16.0+

## License

MIT License — see [LICENSE](LICENSE)

## Links

- [Full Documentation](https://no-problem-dev.github.io/swift-design-system/documentation/designsystem/)
- [Report Issues](https://github.com/no-problem-dev/swift-design-system/issues)
- [Discussions](https://github.com/no-problem-dev/swift-design-system/discussions)
- [Release Process](RELEASE_PROCESS.md)
