# Changelog

All notable changes to this project are recorded in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

**This breaks the public API.** `Typography.font` / `Typography.font(design:)` are removed, and
`ThemeProvider.colorPalette` changed from a property to a method.

### Fixed

- **`IconButton`'s `.outlined` now draws a border.** It only branched on background color, so it
  produced an image not one pixel different from `.standard`. The name was there but the outline
  was not. The outline is `ColorPalette.outline` drawn at `BorderScale.regular` (1pt), matching the
  token combination used by the other outlined parts (`OutlinedChipStyle` / `GlassButtonStyle`).

- **`ByteSize.formatted` now counts in base 1,024, the same as the type.** The factories and the
  unit conversions were base 1,024, but only `ByteCountFormatter` counted in base 1,000 (`.file`),
  so `ByteSize.megabytes(100)` displayed as `"104.9 MB"`. With `.binary` it reads `"100 MB"`.

- **`ThemeProvider` palette resolution now follows the device appearance.** While `themeMode` was
  `.system`, it returned the light palette even when the device was dark. The resolution existed
  only inside `.theme(_:)`, so asking the provider directly always returned light — the two
  disagreed.

### Removed

- **`Typography.font` and `Typography.font(design:)`.** They only returned a fixed-pt
  `.system(size:)` and did not follow Dynamic Type. The only thing that follows it is the
  `.typography(_:)` modifier (which resolves through the environment's `TypographyScale` and then
  passes through `@ScaledMetric`), so `font` looked like the same thing but was a trap where text
  stopped growing. Text now goes through `.typography(_:)` alone.

### Changed

- **`ThemeProvider.colorPalette` is now a method.** `colorPalette(for:)` takes a `ColorScheme` and
  resolves `.system` against that appearance. The resolution rule itself is exposed as
  `resolvedMode(for:)`. `.theme(_:)` passes the environment's `colorScheme` and calls it, so
  resolution lives in one place.

- **The UI strings shipped with the package are now in English.** The pickers (icon / emoji / color
  / image / video), the video player, the permission alerts,
  `VideoPickerError.errorDescription`, the accessibility labels of `StatusIndicator` and
  `StepIndicator`, and the descriptions of `ThemeCategory` and each theme.
  The catalog and previews are not shipped, so they are out of scope.

### What you need to do

- If you used `Typography.font`, replace it with `.typography(_:)`
- If you read `provider.colorPalette`, use `provider.colorPalette(for: colorScheme)`.
  Inside a view, reading `@Environment(\.colorPalette)` is the intended path

## [3.0.0] - 2026-08-06

**This breaks the public API.** `MediaViewerItem.id` changed from `URL` to `String`, and
`MediaViewerItem.url` changed from `URL` to `URL?`.

### Added

- **`MediaViewer` can show bytes you already hold.** It accepted only URLs, so "not in hand yet"
  was baked in as a premise, and an app with a layer that fetches from an authenticated API and
  caches the result — where resolved bytes are what reaches the view — could not use the viewer at
  all. A viewer's job is presentation, not fetching. `MediaViewerItem.imageData(Data, id:)` takes
  the buffer directly, and because there is no wait, no placeholder is interposed.

### Changed

- **Identity is the pair of case and `id`, and the byte buffer takes no part in it.** Using the
  buffer for equality or hashing would mean comparing several megabytes on every page change. This
  is why `id` widened from `URL` to `String`, and why `url` became optional — an item created from
  bytes has no URL.

### What you need to do

- If you compared `item.id` as a `URL`, compare the `String` instead
- If you read `item.url`, unwrap it. It is `nil` for items created with `.imageData(_:id:)`

## [2.4.0] - 2026-08-02

**Apps using `DefaultTheme` will see their light mode appearance change.**
Apps that implement their own `ColorPalette` are unaffected.

### Changed

- **Light-mode surface steps are now made with color.** The background and the card surface were
  nearly the same lightness (1.045:1), leaving a card's outline effectively to its shadow alone.
  A shadow expresses how light falls, so it disappears in a dark place, in a screenshot, or with
  contrast turned up. Leaving the outline to it means cards dissolve into the background under
  those conditions.

  | Token | Before | After |
  |---|---|---|
  | `background` | `.white` | `gray100` |
  | `surface` | `gray50` | `.white` |
  | `surfaceVariant` | `gray100` | `gray200` |

  **The background was sunk and the surface moved to white.** The reverse (white background, gray
  card) inverts the depth relationship, making the nearer thing the darker one. Apple's grouped
  lists also use a gray background with white surfaces.

  | | Surface / background |
  |---|---|
  | Before | 1.045 |
  | **After** | **1.101** |
  | Reference: Apple iOS light | 1.116 |
  | Reference: this package's dark | 1.209 |

  Dark is unchanged (1.209 was already enough). No new colors were added — only existing
  primitives were rearranged.

### What changes visually

Parts that use `surfaceVariant` as their base now read clearly against white.
Six showed snapshot diffs (all light mode only):

- The `Snackbar` panel
- The fill of `DSTextField`'s `.filled`
- The unfilled part of `ProgressBar`'s track
- `SegmentedControl`'s track
- The icon circle in `EmptyState`
- `AttachmentThumbnail`'s tile

In every case the change is "something too faint to make out has become visible"; placement and
dimensions did not move.

### What you need to do

- **Apps using `DefaultTheme`**: light mode appearance changes the moment you raise the dependency.
  If you keep snapshots you will get diffs, so look at them once before re-recording
- **Apps with their own `ColorPalette`**: unaffected. Still worth checking whether your own palette
  has the same flaw. If the background-to-surface ratio is below 1.10, the outline is relying on
  the shadow
- `SurfaceStepContrastTests` checks the lower bound of the surface step (1.10). Useful as a
  yardstick when swapping palettes

### Deferred

- The dark palette was left alone. Background to surface is 1.209 and surface to `surfaceVariant`
  is 1.424; checked by capturing on a device, they separate well enough

## [2.3.0] - 2026-08-01

The release that makes row layout and text dimensions line up without the screen having to patch
them. Until now, "the icon shifts a few pt from row to row", "body text stretches all the way
across on iPad", and "raising the text size does not enlarge body text" were all defects that came
back even when fixed at the call site. The cause is in the library, so the library closes them.

### Added

- **`SectionRowLabel`** — a label with an icon column, placed at the head of a `SectionRow`.
  It reserves the column even on rows without an icon, so labels line up on the left across rows
  with and without icons. It can carry a subtitle
  (`SectionRowLabel("Email", subtitle: "user@example.com")`).
  The column width is `IconSizeScale.lg` (32pt), the same as the leading `IconBadge(.small)` in
  `LinkCard`. Combined with the row's padding, the label's left edge lands at 56pt — the same
  position as the rows in the Settings app.
- **`.readableWidth()`** — caps body width at a readable maximum and centers it.
  SwiftUI has no API equivalent to UIKit's `readableContentGuide`, and writing
  `.frame(maxWidth:)` by hand per screen makes the values drift, so the decision is centralized
  here. The cap is 672pt at the default Dynamic Type size, flexing between 560 and 896pt with the
  text size (matched to measurements of `readableContentGuide`). It applies only when both the
  horizontal and vertical size classes are `.regular`; on iPhone portrait or narrow iPad splits it
  does nothing, since capping there would only add margin.
- `Typography.relativeTextStyle` — the Dynamic Type style each role scales relative to.
  Larger iOS text styles scale by a smaller factor, so relating larger roles to larger styles keeps
  display alone from filling the screen when text is raised to the maximum.

### Changed

- **`SectionRow` now owns the row's skeleton.** It used to only add padding to an HStack, defining
  neither the minimum row height nor the width of the leading icon column. Icon dimensions
  (`IconSizeScale`) and text dimensions (`TypographyScale`) are decided separately, so differences
  in glyph width became shifts in the label's left edge.
  - The row's minimum height no longer falls below the minimum tap target (44pt). Rows with a
    single line of body text were about 41pt, under Apple's floor
  - The leading icon column now has a fixed width. **Existing code** written as
    `SectionRow { Label(...) }` gets the column too (the row distributes a `LabelStyle` to its own
    content, so the API did not change)
  - The skeleton follows Dynamic Type via `@ScaledMetric`. Both the column and the row height grow
    along with the text
- **`.typography(_:)` now follows Dynamic Type.** It used to pass the resolved size straight to
  `Font.system(size:)`, so raising the text size in accessibility settings did not enlarge body
  text. The scale factor applies to both `.system` and `.named` (brand typefaces). Line height and
  letter spacing are recomputed from the scaled size, so text does not grow while the lines stay
  cramped.
- `SectionNavigationLabel` now uses `SectionRowLabel` internally.
  It reserves the icon column even when `systemImage` is omitted, so it lines up on the left with
  icon-bearing rows in the same section. It can now take `subtitle:`.

### Deferred

- **The `if #available(iOS 26.0)` branches for glass (`glassSurface` / `frostedSurface` / the
  `.glass` button) stay.** Apps still depend on this with a deployment target of iOS 17, and
  removing the branches would break them. On apps targeting 26 the glass path is always taken at
  runtime, so it is correct as is.

### What you need to do

- **Nothing is required.** Every existing call site still compiles
- Screens using `SectionRow` grow up to about 3pt taller per row. Worth a look if you had packed
  the layout tightly
- On screens that mix rows with and without icons in one section, replacing `Text(...)` /
  `Label(...)` with `SectionRowLabel(...)` lines up the left edge
- Layout at larger text sizes is untested, since the sizes used to be fixed. Worth checking once
  around `.dynamicTypeSize(.accessibility3)`
- On iPad-capable screens, adding `.readableWidth()` to the level that wraps body text keeps lines
  from getting too long

## [2.2.0] - 2026-07-27

### Added
- Added `resize: ImageResizeRule?` to `imagePicker` (`.square(N)` = a center-cropped square /
  `.longestEdge(N)` = fit the longest edge to N). The order is resize → JPEG encode →
  quality (if `maxSize` is set). Carrying pixels you will not display is the biggest waste, so
  dimensions are cut before quality. Defaults to nil, preserving the previous behavior
  (non-breaking).
- Made `UIImage.resized(by:)` public. It resolves EXIF orientation before redrawing, so the return
  value is always `.up` at scale 1. A photo taken in portrait never comes back landscape. Neither
  rule ever enlarges beyond the original.

### Changed
- **Replaced photo library selection with `PHPickerViewController`** (`imagePicker` only).
  Selection completes outside the app and never touches the whole library, so the photo permission
  is no longer needed. `NSPhotoLibraryUsageDescription` in Info.plist and the library's permission
  request and denial alert were removed. The camera legitimately needs capture permission, so it
  stays on `UIImagePickerController` and `NSCameraUsageDescription`.
  Note that `videoPicker` still uses `UIImagePickerController`, so apps handling video still need
  `NSPhotoLibraryUsageDescription`.

## [2.1.0] - 2026-07-23

### Added

- **`DSTextField` takes an external `FocusState` binding through `focus:`.** Callers had no way to
  move focus programmatically — returning from a scanner into a name field, for example — which
  was a standing reason to drop back to a plain `TextField`. The new binding is optional and
  coexists with the internal `isFocused` that drives border and label color. It defaults to nil,
  so existing calls are unchanged.

## [2.0.1] - 2026-07-19

### Fixed

- **`HighContrastTheme` now reaches the WCAG AAA ratio it claimed.** It was described as AAA
  compliant while several pairs sat under the 7.0 threshold. In light, `tertiary` (6.49), `error`
  (6.57) and `warning` (5.54) were short, and the fills were darkened. `warning` alone could not
  reach AAA with its default `.black` foreground, so `onWarning` was overridden to the dark fill
  and white text the other semantic colors use. In dark, `onError`, `onSuccess` and `onInfo` were
  never overridden, so the default `.white` sat on bright fills and was unreadable (3.19 / 1.43 /
  2.17); each was overridden to a dark color. `error` at `#FF5252` has a relative luminance of
  0.279 and caps at 6.58 even against pure black, so the fill itself was lightened to `#FF8A80`.
  Every pair now falls between 7.12 and 14.88.

### Added

- Tests measuring the semantic colors against the background as well, for themes that place them
  there directly, and a regression test that catches an `on` color reverting to the default white.
- Coverage for `ByteSize`, `SnackbarState`, the component size enums and `StatusKind`, none of
  which had any.

### Changed

- **Replaced tautological tests with real value checks.** About 35% of the existing tests were
  `XCTAssertNotNil` or self-referential, and would still have passed with the implementation
  replaced by a constant. `ColorPalette` now checks real values and the light/dark branch,
  `Elevation` and `Typography` pin concrete values for every level and case, and `ThemeProvider`
  and `ThemeRegistry` check the id set and palette resolution instead of counting entries — which
  also covered `.system` mode and in-place updates for the first time. `TokenDiff`'s unreached
  `num()` branches and `DesignSpec`'s Codable round-trip for enums with associated values are
  covered too.
- Snapshot coverage went from 7 to 19 components, 128 reference images, restricted to components
  whose rendering does not depend on time.

## [2.0.0] - 2026-07-19

**The 2.x series starts here.** The commits in this range remove no public API and change no
signature; the major number marks the split from 1.x, which is no longer developed.

### Changed

- Doc comments and DocC were rewritten throughout, and the README became a two-file English and
  Japanese pair (`README.md` and `README.ja.md`).
- DocC builds as one combined document across all libraries, with an expanded `DesignSystem`
  landing page and new `.docc` catalogs for `DesignCatalogKit` and `DesignSpec`.
- `TokenArchitecture`'s `Chip` example was corrected to the real modifier-chain API, and
  `.foregroundColor` was replaced with `.foregroundStyle` throughout the documentation.

### Added

- Real-value assertions for HEX parsing. `ColorHexTests` asserted only non-nil; it now resolves
  through `Color.resolve` and compares sRGB components for 3-digit, 6-digit and 8-digit ARGB
  input, and for invalid input.
- Light and dark snapshot references for Button, Card, Chip, FAB, Snackbar, ProgressBar and
  EmptyState.
- Doc comments on `StaggeredConfig`'s public properties, which had none.

## [1.7.0] - 2026-06-14

### Added
- Added `source: ImagePickerSource` (`.automatic` / `.camera` / `.photoLibrary`) to `imagePicker`.
  Specifying `.camera` presents the camera directly without the chooser (for camera-only buttons).
  Defaults to `.automatic`, preserving the previous behavior (non-breaking).

## [1.6.0] - 2026-06-14

### Added
- **Attachment UI atoms**: `AttachmentThumbnail` (an image/file thumbnail + a ✕ delete control) and
  `AttachmentStrip` (a horizontally scrolling, purely layout container that takes only a
  ViewBuilder — logic-less). They hold no domain types, no IO, and no state; deletion is a
  callback. Added Attachment to the Catalog.

## [1.3.2] - 2026-06-07

### Added
- **StatusIndicator component** - an indicator that expresses async work state in a single glyph
  - Maps `StatusKind` (pending / running / success / failure / canceled) to semantic colors
  - `StatusKind.color(in:)` lets surrounding elements (badges, etc.) match the indicator's color
  - Uses the system `ProgressView` while running; adds an accessibilityLabel automatically for
    each state
- **StepIndicator component** - a row of dots showing the current position across N steps
  - Current = primary, passed = faded primary, upcoming = outlineVariant
  - `currentIndex: nil` = all steps finished. Auto-generates the accessibility label "Step N / M"
- **TimelineRow component** - one row of a chronological feed (activity log)
  - A marker plus a vertical connector on the left, arbitrary content on the right.
    `VStack(spacing: 0)` for a continuous timeline
  - The marker is a `StatusIndicator` (via `status:`) or any view (via the `marker:` closure)
- **LinkCard component** - a card for a URL reference (a source or a related link)
  - Title + domain + optional accessory (a Chip, etc.). Tappable when given an action
  - Fetching metadata is the caller's responsibility (no dependency on LinkPresentation)
- **EmptyState component** - an explicit state for empty lists and empty search results
  - Icon + heading + optional description. accessibilityElement(children: .combine)
- Added catalog app sections for the five components above

## [1.0.24] - 2026-04-14

### Added
- **Section components** - surface cards for settings and hub screens (ADR-014)
  - `SectionCard(_ header:, footer:)` - a small uppercase header + a rounded surface + a footer
    description
  - `SectionRow` - an HStack row with uniform padding. `contentShape(Rectangle())` makes the
    padding tappable too
  - `SectionRowDivider` - a 0.5pt hairline divider in the `outlineVariant` color
  - `SectionNavigationLabel` - a label for NavigationLink with a chevron
  - All four are built only from DS tokens (spacing / radius / typography / colorPalette)
  - Supports surface material expression equivalent to iOS 26 Liquid Glass

### Changed
- **SectionCard** - the existing `SectionCard(title:, elevation:)` initializer remains for
  compatibility. New code should use the Surface Section style of
  `SectionCard(_ header:, footer:)`
- Merged `Sources/DesignSystem/Layout/Patterns/SectionCard.swift` into
  `Sources/DesignSystem/Components/Section/SectionCard.swift` (to avoid a duplicate type)

## [1.0.22] - 2026-01-06

### Added
- **IconBadge component** - a badge showing an SF Symbol on a circular background (#36)
  - 4 sizes: small (24pt), medium (32pt), large (48pt), extraLarge (64pt)
  - Customizable foreground and background colors
  - Ideal for status display, feature highlights, and category icons
  - Added an "IconBadge" section to the catalog app

- **ProgressBar component** - a horizontal progress indicator (#36)
  - Progress display with a spring animation
  - Customizable height and color
  - Support for the indeterminate state
  - Ideal for loading progress, completion status, and goal tracking
  - Added a "ProgressBar" section to the catalog app

- **StatDisplay component** - a metrics display component (#36)
  - Shows a label, a value, and an optional unit
  - Choice of vertical or horizontal layout
  - Support for a trend indicator (up/down arrow)
  - Ideal for dashboard stats, metric cards, and KPI displays
  - Added a "StatDisplay" section to the catalog app

### Changed
- **Large-scale refactoring of the catalog app**
  - Introduced shared components: CatalogPageContainer, CatalogOverview, VariantShowcase,
    CodeExample
  - Migrated 22 catalog detail views to a unified structure
  - Unified the navigation structure: Foundation, Components, and Patterns now use the same list
    view pattern
  - Shared row rendering via CatalogItemRowContent

- **Complete migration to design tokens**
  - Replaced hardcoded spacing values (1, 2, 4, 6) with spacing tokens (xxs, xs, sm, md)
  - Replaced hardcoded corner radius values (4, 6, 8, 12) with radius tokens (xs, sm, md, lg)
  - Replaced hardcoded colors (Color.green, Color.red, etc.) with semantic colors
    (colors.success, colors.error, etc.)
  - Replaced hardcoded fonts with typography tokens
  - Replaced hardcoded animations with motion tokens

- **Simplified the Card component** (#36)
  - Changed to a simple implementation using @ViewBuilder
  - Removed redundant internal state management

### Removed
- **CatalogItem.swift** - removed a redundant intermediate layer
- **PatternType.swift** - removed as unused
- The `CatalogCategory.items` property - merged into a direct property of CatalogCategory
- The `item` parameter of `CatalogRouter.destination(for:item:)` - removed as unused

## [1.0.21] - 2025-12-21

### Added
- **VideoPicker component** - a modifier for picking a video from the camera or the video library
  (#34)
  - A simple API via the `.videoPicker()` ViewModifier
  - Unified UI for camera capture and video library selection
  - Comprehensive permission handling (camera, microphone, photo library)
  - High-quality capture settings (1920x1080, typeHigh)
  - Full-screen camera presentation on iPad
  - File size limit (`maxSize: ByteSize`)
  - Recording duration limit (`maxDuration: TimeInterval`)
  - Error handling (`onError` callback)
  - Added a "VideoPicker" section to the catalog app

- **VideoPlayerView component** - a video playback player (#34)
  - Plays video from `Data` or a `URL`
  - Native full-screen support via AVPlayerViewController
  - Metadata display (duration, resolution, file size)
  - Action UI via action Chips (play/pause, share, save)
  - Save to the camera roll (permission handling, Snackbar feedback)
  - Automatic audio session configuration
  - Automatic cleanup of temporary files
  - Added a "VideoPlayer" section to the catalog app

- **ByteSize type** - a type-safe utility for handling file sizes (#34)
  - Intuitive size specification via the `Int.kb`, `Int.mb`, `Int.gb` extensions
  - Human-readable formatted output (the `formatted` property)
  - Comparison operator support

- **Action Chip** - a Chip variant with a tap action (#34)
  - The `Chip(label, systemImage:, action:)` initializer
  - Clearly distinct from a deletable Chip

### Changed
- **ImagePicker API improvement** (#34)
  - Changed `maxSizeInBytes: Int` to `maxSize: ByteSize` (breaking change)
  - More intuitive file size specification (e.g. `50.mb`)

### Fixed
- **Improved video capture quality on iPad** (#34)
  - Set `videoQuality = .typeHigh` and
    `videoExportPreset = AVAssetExportPreset1920x1080`
  - Switched to full-screen camera presentation (changed from sheet presentation)

- **Fixed a crash when saving video** (#34)
  - Resolved a MainActor isolation problem (using a `@Sendable` closure)
  - Added a file existence check
  - Prevented deletion of the temporary file while saving

## [1.0.20] - 2025-11-17

### Added
- **IconPicker, EmojiPicker, and ColorPicker components** - three picker modifiers for selection UI
  (#32)
  - **IconPicker (SF Symbols only)**
    - A simple API via the `.iconPicker()` ViewModifier
    - Correct SF Symbols rendering via `Image(systemName:)`
    - Category-based organization (IconCategory/IconItem)
    - Half-modal presentation (`.medium` and `.large` detents)
    - Search and category filtering
    - Visual feedback for the selected state
  - **EmojiPicker (emoji only)**
    - A simple API via the `.emojiPicker()` ViewModifier
    - Displays emoji at a larger font size (32pt)
    - Category-based organization (EmojiCategory/EmojiItem)
    - Half-modal presentation (`.medium` and `.large` detents)
    - Search and category filtering
    - Categories such as smileys & emotion, animals & nature, food, and activities
  - **ColorPicker (preset colors)**
    - A simple API via the `.colorPicker()` ViewModifier
    - A preset color system (ColorPreset)
    - `.tagFriendly`: 10 colors suited to tags and categories
    - `.allPrimitives`: the whole primitive color set
    - Half-modal presentation (`.medium` and `.large` detents)
    - Search and category filtering
  - Common to all pickers
    - A consistent API via the ViewModifier pattern
    - Half-modal sheets (using `.presentationDetents`)
    - Tab navigation by category
    - Filtering via a search field
    - Select/Cancel button placement
    - Full integration with design system tokens
  - Added three new sections to the catalog app
    - ColorPickerCatalogView: demo and usage examples for the color picker
    - EmojiPickerCatalogView: demo and usage examples for the emoji picker
    - IconPickerCatalogView: demo and usage examples for the icon picker

## [1.0.19] - 2025-11-17

### Added
- **ImagePicker component** - a modifier for picking an image from the camera or the photo library
  (#28)
  - A simple API via the `.imagePicker()` ViewModifier
  - Unified UI for camera capture and photo library selection
  - Comprehensive permission handling (camera and photo library)
  - Least-privilege access via the `.addOnly` permission level
  - Camera availability check (for devices without one, such as some iPads)
  - Image compression strategy (the `maxSizeInBytes` parameter)
    - Optimizes toward the target size by recursive quality adjustment
    - Skips compression when already under the limit
  - Error handling (the `onCompressionError` callback)
  - Explicit handling of the `.restricted` state (MDM / parental controls)
  - Returns image data in JPEG format
  - Added an "ImagePicker" section to the catalog app

- **Snackbar component** - transient notification UI following Material Design (#26)
  - Transient notification UI presented from the bottom of the screen
  - `@Observable`-based state management via `SnackbarState`
  - Auto-dismiss (5 seconds by default, customizable)
  - Support for up to two action buttons (primary, secondary)
  - Show/hide transitions with a spring animation
  - Accessibility support (accessibilityLabel)
  - Full integration with design system tokens (color, spacing, corner radius)
  - Added a "Snackbar" section to the catalog app

## [1.0.18] - 2025-11-16

### Added
- **Snackbar component** - transient notification UI following Material Design (#26)
  - Transient notification UI presented from the bottom of the screen
  - `@Observable`-based state management via `SnackbarState`
  - Auto-dismiss (5 seconds by default, customizable)
  - Support for up to two action buttons (primary, secondary)
  - Show/hide transitions with a spring animation
  - Accessibility support (accessibilityLabel)
  - Full integration with design system tokens (color, spacing, corner radius)
  - Added a "Snackbar" section to the catalog app

## [1.0.17] - 2025-11-09

### Added
- **Implemented the typography token system** (#23)
  - Flexible font management via the `Typography.Font.Design` protocol
  - Japanese font switching
    - `JapaneseRoundedFontDesign`: an SF Rounded (rounded gothic) style
    - `JapaneseSerifFontDesign`: a Yu Mincho (serif) style
  - Dynamic font switching via `FontDesignProvider`
  - Added a "Typography" section to the catalog app
  - Implemented font style previews and font design switching UI

- **Implemented iPad Split View support** (#24)
  - Adaptive layout via comprehensive refactoring
  - Screen size awareness via `AdaptiveLayoutProvider`
  - Dynamic layout adjustment via `LayoutContext`
  - Updated every catalog app view for iPad Split View
  - Optimized spacing and layout for compact and regular widths

## [1.0.16] - 2025-11-09

### Added
- **Motion system** - a unified animation timing system (#20)
  - 10 optimized animation timings
  - Micro-interactions: `quick` (70ms), `tap` (110ms)
  - State changes: `toggle`, `fadeIn`, `fadeOut` (150ms)
  - Transitions: `slide` (240ms), `slow` (300ms), `slower` (375ms)
  - Springs: `spring`, `bounce`
  - Follows the industry standards of Material Design 3, IBM Carbon, and Apple HIG
  - Easy application via the `.animate()` modifier
  - Automatic Reduce Motion support (per WCAG 2.1 SC 2.3.3)
  - Sendable-conforming and concurrency-safe

- **Motion catalog view** - a comprehensive animation catalog (#20)
  - Overview section: system description and key features
  - Interactive demos: animations you can try, in 4 categories
  - Spec table: detailed specs for all 10 motions
  - Usage: 3 code examples
  - Accessibility notes: automatic Reduce Motion support
  - Best practices: recommended patterns and anti-patterns
  - MotionDemoCard: responsive design with the AspectGrid pattern

### Changed
- **Catalog UI improvements** (#21)
  - Increased spacing between sections from 24pt to 32pt (per 2025 design system best practices)
  - Introduced card-style section design (a subtle elevation effect)
  - No corner radius for full-bleed sections (edge to edge), matching the iOS standard pattern
  - Corner radius for informational sections (a floating card look)
  - Researched and applied the 2025 best practices of Material Design 3, Fluent 2, and Carbon
    Design System

- **Migrated existing components to the Motion system** (#20)
  - Button styles (Primary, Secondary, Tertiary) → use motion tokens
  - Chip styles (Filled, Outlined, LiquidGlass) → use motion tokens
  - ThemeGalleryView → uses motion tokens

- **Dark mode support for custom themes** (#21)
  - Added full dark mode support to `SimpleBlueTheme` and `SimpleRedTheme`
  - Handles every `ThemeMode` case (`.system`, `.light`, `.dark`) properly
  - Adjusted to lighter tones in dark mode to secure contrast

### Fixed
- **Updated the Xcode environment in GitHub Actions** (#19)
  - macOS 15 → macOS 26 (arm64)
  - Xcode 16.1 → Xcode 26.0.1
  - iOS 26 SDK support (needed for the `.glassEffect()` API)
  - Resolved compile errors in the DocC deployment

### Documentation
- **Major improvements to the custom theme documentation** (#21)
  - Added detailed DocC comments to `SimpleBlueTheme` and `SimpleRedTheme`
  - Overhauled the "Creating custom themes" section of README.md
    - Step 1: implementing ColorPalette (a complete example with all 27 colors)
    - Step 2: implementing the Theme protocol
    - Step 3: registering with ThemeProvider (3 patterns)
    - Step 4: an example of theme switching
  - Added documentation to the entry point

## [1.0.15] - 2025-11-09

### Added
- **Chip component** - following Material Design 3 and the Liquid Glass design language (#15)
  - A protocol-based ChipStyle system (like ButtonStyle)
  - Size variants: Small (24pt), Medium (32pt)
  - 4 initialization patterns: static, with icon, deletable, selectable
  - Interactive states: pressed, selected
  - Full accessibility support
  - 3 style variants:
    - **Filled**: a 10-20% opacity background (for status and category labels)
    - **Outlined**: a 1.5pt border (for filters and secondary categories)
    - **Liquid Glass**: the native iOS 26+ `.glassEffect()` API (with interactive support)
  - Swift 6 concurrency ready (all styles conform to `Sendable`, with `@MainActor` methods)
  - Integrated with the token system (built on the 3-layer token architecture)

- **AspectGrid layout pattern** - a grid layout with a fixed aspect ratio (#16)
  - **GridSpacing tokens**: 5 spacing steps — xs, sm, md, lg, xl
  - **Adaptive sizing**: automatic adjustment to the screen size (minItemWidth, maxItemWidth)
  - **Common use cases**: product lists, photo galleries, video thumbnails
  - **Supported aspect ratios**:
    - 1:1 - product thumbnails, profile images, icons
    - 3:4 - photos, portraits
    - 16:9 - video thumbnails, wide content
  - Efficient rendering based on LazyVGrid
  - Automatic column adjustment via GridItem.adaptive
  - Complete documentation comments and code examples

- **Custom theme category** - an extension to theme classification (#17)
  - Added a new `.custom` category
    - Name: "Custom"
    - Description: "App-specific custom themes"
    - Icon: `wand.and.stars` ✨
  - Clearly separates built-in and custom themes in the theme gallery
  - Sample custom theme implementations (SimpleBlueTheme, SimpleRedTheme)

### Fixed
- **Improved dynamic theme switching** (#17)
  - Fixed reactive updates in `ThemeEnvironmentView`
    - Problem: the color palette was evaluated statically and did not update when the theme changed
    - Solution: added a `resolvedColorPalette` computed property, making use of `@Observable`
      change tracking
  - Improved dynamic theme display in `ThemeGalleryView`
    - Problem: it used `ThemeRegistry.themesByCategory` (built-in themes only)
    - Solution: uses `themeProvider.availableThemes` to show built-in plus custom themes
      dynamically
  - Reactive system: automatic updates via `@Observable` and computed properties
  - Extensibility: a design that makes adding custom themes easy
  - Initial theme selection: the `initialTheme` parameter controls the theme at launch

## [1.0.14] - 2025-11-08

### Fixed
- **Making automatic PR creation reliable (final)** - added a timestamp comment
  - Appends an auto-generated timestamp comment to the end of CHANGELOG.md
  - Guarantees a change even when the comparison links already hold the right values
  - A commit is reliably created, so PR creation succeeds

## [1.0.13] - 2025-11-08

### Fixed
- **Improved release note generation** - the version in the install example is now set dynamically
  - Changed the hardcoded "1.0.0" to the actual release version
  - Provides more accurate, clearer install instructions
- **Making automatic PR creation reliable** - added logic to update the CHANGELOG comparison links
  - Always updates the comparison links to the latest version after a release
  - A commit is reliably created even when an "Unreleased" section already exists
  - Ensures the draft PR for the next release is created

## [1.0.12] - 2025-11-08

### Fixed
- **Consolidated the release workflow** - merged GitHub Release creation into
  auto-release-on-merge.yml
  - The GitHub Release is now created at the same time as the tag
  - Removed the release.yml workflow (its function was merged in)
  - No Personal Access Token (PAT) configuration required
  - Fully automated, with everything done through GITHUB_TOKEN

### Documentation
- **Greatly simplified RELEASE_PROCESS.md** - narrowed to the essentials
  - Removed redundant sections
  - Simplified the release procedure to 6 steps
  - Trimmed troubleshooting to the minimum necessary

## [1.0.11] - 2025-11-08

### Changed
- **Complete revision of the release workflow** - a simpler, more intuitive flow
  - Merging a PR from a release branch (`release/vX.Y.Z`) into main now triggers a release
  - Tags are created automatically, so no manual tagging
  - The next release branch and its draft PR are also created automatically
  - Workflows: added `auto-release-on-merge.yml`, removed `prepare-next-release.yml`

### Documentation
- **Fully updated RELEASE_PROCESS.md for the new workflow**
  - Added an overview of the new development flow
  - Organized the detailed procedure into 6 steps
  - Overhauled the automation section (a detailed explanation of `auto-release-on-merge.yml`)
  - Updated troubleshooting for the new workflow

## [1.0.10] - 2025-11-08

### Documentation
- **Comprehensive update to the release process guide**
  - Documented the release philosophy and concepts in detail (why the hybrid approach, semantic
    versioning, Keep a Changelog)
  - Added a detailed procedure and an overview of the whole workflow
  - Best practices for writing CHANGELOG.md (good vs. bad examples)
  - A technical explanation of the automation (release.yml, prepare-next-release.yml)
  - Expanded the troubleshooting guide
  - Added a developer information section to README.md
  - Removed the old docs directory (its content has been merged in)

## [1.0.9] - 2025-11-08

### Added
- **Automatic comparison link updates** - an improvement to the prepare-next-release workflow
  - Extracts the version from the tag automatically
  - Updates the [Unreleased] comparison link to the latest version automatically
  - No manual link updating after a release

## [1.0.8] - 2025-11-08

### Fixed
- **Verification of the prepare-next-release workflow** - confirmed automatic draft PR creation
  - Verified the PR creation flow when no "Unreleased" section exists

## [1.0.7] - 2025-11-08

### Changed
- **Release workflow improvement** - added boilerplate and metadata to the GitHub Release
  - Generates the release title, install instructions, and links automatically
  - Changed to a clearer release note format

### Fixed
- **prepare-next-release workflow** - implemented automatic draft PR creation
  - Switched to a tag push trigger (the release:published event does not fire)
  - Fully automated through to draft PR creation

## [1.0.6] - 2025-11-08

### Added
- Documentation improvements and release flow verification

## [1.0.5] - 2025-11-08

### Added
- **Automation workflow** - automates post-release preparation
  - Added `.github/workflows/prepare-next-release.yml`
  - Automatically drafts the next release preparation PR after a GitHub Release is published
  - Inserts the "Unreleased" section into CHANGELOG.md automatically
  - Implemented per Keep a Changelog best practices

## [1.0.4] - 2025-11-08

### Changed
- **Release process improvement** - adopted a hybrid approach
  - CHANGELOG.md is maintained by hand (keeping the Keep a Changelog format)
  - GitHub Releases are generated from tags
  - Changed to a correct design based on best practices

### Removed
- Removed the incorrect automation workflow `prepare-next-version.yml`
- Removed the unnecessary script `prepare_next_version.sh`
- Removed the outdated document `RELEASE_AUTOMATION.md`

### Added
- A new release workflow, `.github/workflows/release.yml`
  - Extracts the matching version from CHANGELOG.md on tag push
  - Creates the GitHub Release automatically
- A comprehensive release process guide, `docs/RELEASE_PROCESS.md`

## [1.0.3] - 2025-11-08

### Documentation
- Changed the install instructions in README.md to `upToNextMajor`, following semantic versioning
  best practice

## [1.0.2] - 2025-11-08

### Added
- **Multi-theme system** - added 7 built-in themes
  - Default - the default theme, following Material Design 3
  - Ocean - a calm theme based on ocean blue
  - Forest - a natural theme based on forest green
  - Sunset - a warm theme based on sunset orange
  - Purple Haze - a creative theme based on vivid purple
  - Monochrome - a minimal grayscale theme
  - High Contrast - a high-contrast theme meeting WCAG AAA
- **Theme architecture**
  - The `Theme` protocol - an extensible theme system through protocol-oriented design
  - `ThemeMode` - 3 modes: follow the system, always light, always dark
  - `ThemeCategory` - logical classification of themes (Standard, Brand Personality, Accessibility)
  - `ThemeRegistry` - central management of all themes
  - Light/dark palettes implemented for every theme (14 palettes in total)
- **Catalog app UI**
  - `ThemeGalleryView` - a theme list by category
  - `ThemeDetailView` - theme details with an interactive preview
  - `ThemeCardView` - a theme selection card
  - `ThemeColorPreview` - shows the full 27-color palette
  - `AppearanceModeSection` - appearance mode switching UI
- **DesignSystemCatalogApp** - the catalog application as an Xcode project

### Changed
- **Complete rewrite of ThemeProvider** (breaking change)
  - Migrated to the `@Observable` macro
  - Changed the initialization parameters:
    - Old: `ThemeProvider(colorScheme:lightPalette:darkPalette:)`
    - New: `ThemeProvider(initialTheme:initialMode:additionalThemes:)`
  - Changed how it is injected into the environment:
    - Old: `.environment(\.themeProvider, provider)`
    - New: `.environment(provider)`
  - Changed the default mode to `.system` (follows the system setting)
- **ThemeModifier improvements**
  - Implemented ColorScheme resolution for `ThemeMode.system`
  - Works with `@Environment(\.colorScheme)` to pick the right palette
- **DesignSystemCatalogView improvements**
  - Removed the redundant header section
  - Changed the navigation title to "Design System Catalog"
  - Added links to the repository and the documentation in the information section
  - Removed the version and design system description (to reduce maintenance load)

### Fixed
- **Unified hardcoded colors in the catalog views onto the theme system**
  - Unified the header icon color in PatternsCatalogView/ComponentsCatalogView to
    `colorPalette.primary`
  - Made the FeatureRow component theme-aware (removed the `color` parameter)
  - Made the visual demos in RadiusDemoView/SpacingDemoView theme-color aware
  - Unified the description text and background color in ButtonCatalogView onto ColorPalette tokens
  - Unified `.primary`/`.secondary`/`.tertiary` in ColorSwatchView onto `colorPalette` tokens
  - Eliminated SwiftUI native semantic colors across all catalog views, unifying on
    Material Design 3

### Removed
- `ThemeProviderKey` - unnecessary after the move to @Observable
- The pattern of injecting ThemeProvider through a custom EnvironmentKey

### Documentation
- Added comprehensive documentation of the multi-theme system to README.md
  - A table describing the character and use of the 7 themes
  - Usage examples for theme switching and mode selection
  - A custom theme creation guide
- Added detailed documentation comments to every theme file
- Added practical code examples to ThemeProtocol/ThemeRegistry/ThemeMode/ThemeCategory

## [1.0.1] - 2025-01-08

### Fixed
- Removed the explicit setting, since Swift 6 enables StrictConcurrency by default
- Removed the unnecessary swiftSettings configuration from Package.swift, resolving a build error

## [1.0.0] - 2025-01-08

### Added
- A 3-layer design token system (Primitive, Semantic, Component)
- A protocol-based color palette (`ColorPalette`)
  - Default implementations for light and dark themes
  - Primary, Secondary, and Tertiary color schemes
  - Semantic state colors (Error, Warning, Success, Info)
- A spacing scale (`SpacingScale`)
  - T-shirt size naming (xs, sm, md, lg, xl, etc.)
  - 11 steps from none (0pt) to xxxxl (96pt)
- A corner radius scale (`RadiusScale`)
  - 7 steps from xs (2pt) to xxl (24pt)
  - Support for full (a complete circle)
- A typography system (`Typography`)
  - 5 categories: Display, Headline, Title, Body, Label
  - 14 predefined text styles
  - Easy application via the `.typography()` modifier
- Dynamic theme switching through ThemeProvider
  - Light/dark/custom theme support
  - Reactive updates via `@Observable`
  - Follows the system theme
- Button components
  - PrimaryButtonStyle - for primary actions
  - SecondaryButtonStyle - for supporting actions
  - TertiaryButtonStyle - for understated actions
  - TextButtonStyle - a text-only button
  - Uniform sizing via ButtonSize (Large, Medium, Small)
- Card component
  - Card - a general-purpose card container
  - Shadow management through elevation levels (Level0-3)
- IconButton - an icon-based button
- FloatingActionButton (FAB) - a button for the primary action
- DSTextField - a text field integrated with the design system
  - Error and focus state support
  - Placeholder and keyboard type configuration
  - Secure text entry support
- Layout patterns
  - SectionCard - a card section with a title
- View modifiers
  - `.theme(_:)` - applies a ThemeProvider
  - `.buttonSize(_:)` - specifies a button size
  - `.typography(_:)` - applies typography
- Support for creating custom themes
  - Your own color palette implementation
  - Custom spacing and corner radius scales
- Color initialization from a HEX string (`Color(hex:)`)
  - Supports 3, 6, and 8 digits (with alpha)
- Complete documentation comments
  - Practical code examples on every public API
  - A usage guide written from the user's point of view

### Documentation
- A comprehensive README.md
  - Quick start guide
  - Design token usage examples
  - Custom theme creation examples
  - Implementation examples for a login screen and a settings screen
- API reference
- An architecture guide (the 3-layer token system)
- DocC support
  - Automatic documentation publishing on GitHub Pages

[Unreleased]: https://github.com/no-problem-dev/swift-design-system/compare/v1.0.22...HEAD
[1.0.22]: https://github.com/no-problem-dev/swift-design-system/compare/v1.0.21...v1.0.22
[1.0.21]: https://github.com/no-problem-dev/swift-design-system/compare/v1.0.20...v1.0.21
[1.0.20]: https://github.com/no-problem-dev/swift-design-system/compare/v1.0.19...v1.0.20
[1.0.19]: https://github.com/no-problem-dev/swift-design-system/compare/v1.0.18...v1.0.19
[1.0.18]: https://github.com/no-problem-dev/swift-design-system/compare/v1.0.17...v1.0.18
[1.0.17]: https://github.com/no-problem-dev/swift-design-system/compare/v1.0.16...v1.0.17
[1.0.16]: https://github.com/no-problem-dev/swift-design-system/compare/v1.0.15...v1.0.16
[1.0.15]: https://github.com/no-problem-dev/swift-design-system/compare/v1.0.14...v1.0.15
[1.0.14]: https://github.com/no-problem-dev/swift-design-system/compare/v1.0.13...v1.0.14
[1.0.13]: https://github.com/no-problem-dev/swift-design-system/compare/v1.0.12...v1.0.13
[1.0.12]: https://github.com/no-problem-dev/swift-design-system/compare/v1.0.11...v1.0.12
[1.0.11]: https://github.com/no-problem-dev/swift-design-system/compare/v1.0.10...v1.0.11
[1.0.10]: https://github.com/no-problem-dev/swift-design-system/compare/v1.0.9...v1.0.10
[1.0.9]: https://github.com/no-problem-dev/swift-design-system/compare/v1.0.8...v1.0.9
[1.0.8]: https://github.com/no-problem-dev/swift-design-system/compare/v1.0.7...v1.0.8
[1.0.7]: https://github.com/no-problem-dev/swift-design-system/compare/v1.0.6...v1.0.7
[1.0.6]: https://github.com/no-problem-dev/swift-design-system/compare/v1.0.5...v1.0.6
[1.0.5]: https://github.com/no-problem-dev/swift-design-system/compare/v1.0.4...v1.0.5
[1.0.4]: https://github.com/no-problem-dev/swift-design-system/compare/v1.0.3...v1.0.4
[1.0.3]: https://github.com/no-problem-dev/swift-design-system/compare/v1.0.2...v1.0.3
[1.0.2]: https://github.com/no-problem-dev/swift-design-system/compare/v1.0.1...v1.0.2
[1.0.1]: https://github.com/no-problem-dev/swift-design-system/compare/v1.0.0...v1.0.1
[1.0.0]: https://github.com/no-problem-dev/swift-design-system/releases/tag/v1.0.0

<!-- Auto-generated on 2025-11-08T11:54:43Z by release workflow -->

<!-- Auto-generated on 2025-11-09T00:21:22Z by release workflow -->

<!-- Auto-generated on 2025-11-09T08:30:33Z by release workflow -->

<!-- Auto-generated on 2025-11-09T13:28:30Z by release workflow -->

<!-- Auto-generated on 2025-11-16T09:24:46Z by release workflow -->

<!-- Auto-generated on 2025-11-16T22:16:30Z by release workflow -->

<!-- Auto-generated on 2025-11-16T23:22:19Z by release workflow -->

<!-- Auto-generated on 2025-12-21T03:25:36Z by release workflow -->
