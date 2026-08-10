# ``DesignSpec``

A brand's design specification as pure, machine-readable data.

## Overview

DesignSpec models the nine sections of a `DESIGN.md` document — brand metadata, visual
theme, color, typography, spacing, radius, elevation, layout, and components — as `Codable`
Swift types.

It deliberately imports nothing but Foundation. No SwiftUI, no UIKit, no AppKit. That is
what lets a command line tool generate, validate, diff, and ingest a spec without a UI
process, and what lets the same spec be consumed on a platform this package was never built
for.

The model is designed to keep what makes a brand *different* rather than flattening every
brand into the same shape. Whether it can express char-relative spacing, a harmonic type
ramp, and a double focus ring is the test of whether it is adequate.

```swift
let spec = DesignSpec(
    meta: BrandMeta(id: "my-brand", name: "My Brand"),
    theme: VisualTheme(
        atmosphere: ["modern", "trustworthy"],
        summary: "Clean and accessible"
    ),
    color: ColorSpec(primitives: [], roles: [], states: []),
    typography: TypographySpec(
        fontStack: FontStack(system: true),
        scaleModel: .modular(base: 16, ratio: 1.25),
        ramp: [],
        leading: []
    ),
    spacing: SpacingSpec(model: .absolutePt, steps: []),
    radius: RadiusSpec(steps: []),
    elevation: ElevationSpec(layers: []),
    layout: LayoutSpec(),
    components: [],
    guidance: Guidance(dos: [], donts: [])
)

let encoder = JSONEncoder()
encoder.outputFormatting = .prettyPrinted
let data = try encoder.encode(spec)
```

Turning a spec into runnable tokens is a separate concern and lives in the layer above.

## Topics

### Root model

- ``DesignSpec``
- ``BrandMeta``
- ``VisualTheme``

### Color

- ``ColorSpec``
- ``ColorToken``
- ``ColorRole``
- ``ColorState``
- ``ColorTransform``

### Typography

- ``TypographySpec``
- ``FontStack``
- ``TypeStyle``
- ``ScaleModel``
- ``FontWeightToken``
- ``LeadingToken``

### Spacing and radius

- ``SpacingSpec``
- ``SpacingModel``
- ``SpacingStep``
- ``RadiusSpec``
- ``RadiusStep``

### Elevation and layout

- ``ElevationSpec``
- ``ElevationLayer``
- ``FocusRing``
- ``LayoutSpec``
- ``Breakpoint``

### Components and guidance

- ``ComponentSpec``
- ``Guidance``
