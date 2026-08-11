# Token architecture

Three layers, and the rule for which one a view is allowed to touch.

## Overview

Design values in this package live in three layers: **Primitive**, **Semantic**, and
**Component**. The split exists so that a value can be changed in one place and take effect
everywhere, and so that switching theme or color scheme does not require touching a single
view.

The one rule that makes it work: **views read from the Semantic layer, never from the
Primitive layer.** A view that reaches for a primitive has opted itself out of theming, and
will stay the wrong color forever after a theme switch.

## Layer 1: primitives

Primitives are the raw values — hex codes, point sizes, radii. They exist so that semantic
tokens have something to be defined in terms of.

> Warning: Primitives are an implementation detail. Do not use them directly in a view.

```swift
// Do not do this in a view.
PrimitiveColors.blue500
PrimitiveSpacing.space16
PrimitiveRadius.radius8
```

They are public because a custom theme needs them: a palette that wants the same blue the
default theme uses should refer to `PrimitiveColors.blue500` rather than retyping the hex.

## Layer 2: semantic tokens

Semantic tokens name a value by the job it does, not by what it looks like — `primary`, not
`blue500`; `lg`, not `16`. Each is a protocol, so a theme supplies the values by conforming,
and a theme that forgets one fails to compile.

Views reach them through the environment:

```swift
@Environment(\.colorPalette) var colors
@Environment(\.spacingScale) var spacing
@Environment(\.radiusScale) var radius
@Environment(\.motion) var motion

Text("Hello")
    .foregroundStyle(colors.primary)
    .padding(spacing.lg)
```

| Protocol | Environment key | What it covers |
|---|---|---|
| ``ColorPalette`` | `\.colorPalette` | Roles such as `primary`, `surface`, and `error`, each paired with an `on-` role for content drawn on top |
| ``SpacingScale`` | `\.spacingScale` | Ten steps, `none` through `xxxxl` |
| ``RadiusScale`` | `\.radiusScale` | Eight steps, `none` through `full` |
| ``TypographyScale`` | `\.typographyScale` | Text roles that scale with Dynamic Type |
| ``Motion`` | `\.motion` | Animation durations and curves |
| ``IconSizeScale`` | `\.iconSizeScale` | Icon dimensions matched to the type scale |
| ``BorderScale`` | `\.borderScale` | Stroke widths |
| ``ElevationScale`` | `\.elevationScale` | Shadow parameters per elevation level |

The `on-` pairing in ``ColorPalette`` is the part most easily lost: picking a text color by
eye works in the mode you happened to be looking at and breaks in the other one. Pairing
`success` with `onSuccess` keeps contrast correct in both.

## Layer 3: component tokens

Component tokens are the fixed set of variants a component accepts. They are enumerations
rather than free numbers, which is what stops a codebase from accumulating eleven slightly
different button heights.

```swift
Button("Save") { save() }
    .buttonStyle(.primary)
    .buttonSize(.large)

Card(elevation: .level2) {
    // ...
}

Chip("Tag")
    .chipStyle(.filled)
    .chipSize(.small)
```

| Token | Values |
|---|---|
| ``ButtonSize`` | `small`, `medium`, `large` |
| ``ChipSize`` | `small`, `medium` |
| ``Elevation`` | `level0` through `level5` |

``Elevation`` is worth a note: under a glass ``SurfaceStyle`` it no longer maps to shadow
depth. The same level is reinterpreted as border luminance and tint strength, because a
shadow under a translucent surface reads as dirt rather than as height.

## Topics

### Semantic token protocols

- ``ColorPalette``
- ``SpacingScale``
- ``RadiusScale``
- ``Typography``
- ``TypographyScale``
- ``Motion``

### Component tokens

- ``ButtonSize``
- ``ChipSize``
- ``Elevation``

### Primitives

- ``PrimitiveColors``
- ``PrimitiveSpacing``
- ``PrimitiveRadius``
- ``PrimitiveTypography``
