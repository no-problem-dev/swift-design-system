English | [日本語](./README.ja.md)

# DesignSystem

A complete set of SwiftUI components that already agree on color, spacing and type, so an app looks consistent without building that layer, and one theme switch restyles all of it.

![Swift](https://img.shields.io/badge/Swift-6.2-orange.svg)
![Platforms](https://img.shields.io/badge/Platforms-iOS%2017.0+%20%7C%20macOS%2014.0+-blue.svg)
![License](https://img.shields.io/badge/License-MIT-yellow.svg)

## Features

- **Three-layer token system** — Primitive → Semantic → Component, with a clear rule about which layer a view may touch
- **Protocol-based** — a theme supplies values by conforming, so a theme that forgets a token fails to compile
- **Seven built-in themes** — Default, Ocean, Forest, Sunset, PurpleHaze, Monochrome, HighContrast, each with a separate light and dark palette
- **Components on tokens** — Button, Card, Chip, TextField, FAB, Snackbar, ProgressBar and more, all restyled by a theme switch without per-call work
- **Glass surfaces** — components adapt to `SurfaceStyle`, reinterpreting elevation as border luminance instead of shadow depth

Every component has a rendered reference checked into the repo:
[`Tests/DesignSystemTests/__Snapshots__/`](Tests/DesignSystemTests/__Snapshots__) holds
148 images covering 22 components in both light and dark, verified by the snapshot suite
on an iOS simulator.

## Quick Start

Install a theme once at the root, then read tokens from the environment anywhere below it:

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
                Text("Weekly report").typography(.titleMedium)
                Chip("Ready").chipStyle(.filled)
            }
        }
        .padding(spacing.xl)
    }
}
```

Switching theme or mode at runtime restyles everything at once:

```swift
themeProvider.switchToTheme(id: "ocean")
themeProvider.toggleMode()   // system → light → dark → system
```

## Documentation

[**API reference and guides**](https://no-problem-dev.github.io/swift-design-system/documentation/designsystem/) —
including [Getting Started](https://no-problem-dev.github.io/swift-design-system/documentation/designsystem/gettingstarted/),
[Token Architecture](https://no-problem-dev.github.io/swift-design-system/documentation/designsystem/tokenarchitecture/),
and [Custom Theme](https://no-problem-dev.github.io/swift-design-system/documentation/designsystem/customtheme/).

## Installation

```swift
// Package.swift
dependencies: [
    .package(url: "https://github.com/no-problem-dev/swift-design-system.git", from: "3.0.0")
]
```

The package vends three libraries: `DesignSystem` (the SwiftUI system), `DesignSpec`
(a brand's design specification as pure data), and `DesignCatalogKit` (cross-brand
gallery and token diffing).

## Requirements

- iOS 17.0+ / macOS 14.0+
- Swift 6.2+
- Xcode 16.0+

## License

MIT License — see [LICENSE](LICENSE)
