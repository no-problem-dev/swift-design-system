# Swift Design System - Comprehensive Catalog

## 1. COLOR SYSTEM

### Primitive Colors (Base Palette)
Located in: `Sources/DesignSystem/Tokens/Primitive/PrimitiveColors.swift`

#### Blue Scale
- `blue50`: #EFF6FF
- `blue100`: #DBEAFE
- `blue200`: #BFDBFE
- `blue300`: #93C5FD
- `blue400`: #60A5FA
- `blue500`: #3B82F6 (Primary Light)
- `blue600`: #2563EB
- `blue700`: #1D4ED8
- `blue800`: #1E40AF
- `blue900`: #1E3A8A
- `blue950`: #172554

#### Gray Scale
- `gray50`: #F9FAFB
- `gray100`: #F3F4F6
- `gray200`: #E5E7EB
- `gray300`: #D1D5DB
- `gray400`: #9CA3AF
- `gray500`: #6B7280
- `gray600`: #4B5563
- `gray700`: #374151
- `gray800`: #1F2937
- `gray900`: #111827
- `gray950`: #030712

#### Purple Scale
- `purple50`: #FAF5FF
- `purple100`: #F3E8FF
- `purple200`: #E9D5FF
- `purple300`: #D8B4FE
- `purple400`: #C084FC
- `purple500`: #A855F7 (Secondary)
- `purple600`: #9333EA
- `purple700`: #7E22CE
- `purple800`: #6B21A8
- `purple900`: #581C87
- `purple950`: #3B0764

#### Cyan Scale
- `cyan50`: #ECFEFF
- `cyan100`: #CFFAFE
- `cyan200`: #A5F3FC
- `cyan300`: #67E8F9
- `cyan400`: #22D3EE
- `cyan500`: #06B6D4 (Tertiary)
- `cyan600`: #0891B2
- `cyan700`: #0E7490
- `cyan800`: #155E75
- `cyan900`: #164E63
- `cyan950`: #083344

#### Red Scale
- `red50`: #FEF2F2
- `red100`: #FEE2E2
- `red200`: #FECACA
- `red300`: #FCA5A5
- `red400`: #F87171
- `red500`: #EF4444 (Error)
- `red600`: #DC2626
- `red700`: #B91C1C
- `red800`: #991B1B
- `red900`: #7F1D1D
- `red950`: #450A0A

#### Orange Scale
- `orange50`: #FFF7ED
- `orange100`: #FFEDD5
- `orange200`: #FED7AA
- `orange300`: #FDBA74
- `orange400`: #FB923C
- `orange500`: #F97316 (Warning)
- `orange600`: #EA580C
- `orange700`: #C2410C
- `orange800`: #9A3412
- `orange900`: #7C2D12
- `orange950`: #431407

#### Green Scale
- `green50`: #F0FDF4
- `green100`: #DCFCE7
- `green200`: #BBF7D0
- `green300`: #86EFAC
- `green400`: #4ADE80
- `green500`: #10B981 (Success)
- `green600`: #059669
- `green700`: #047857
- `green800`: #065F46
- `green900`: #064E3B
- `green950`: #022C22

### Semantic Color Palette
Accessed via: `@Environment(\.colorPalette) var colors`

#### Protocol: `ColorPalette`
File: `Sources/DesignSystem/Tokens/Semantic/ColorPalette.swift`

##### Primary Colors
- `primary`: Main brand color
- `onPrimary`: Text/icons on primary background
- `primaryContainer`: Light variant for container backgrounds
- `onPrimaryContainer`: Text on primary container

##### Secondary Colors
- `secondary`: Supporting accent color
- `onSecondary`: Text/icons on secondary background
- `secondaryContainer`: Light variant for container backgrounds
- `onSecondaryContainer`: Text on secondary container

##### Tertiary Colors
- `tertiary`: Additional accent color
- `onTertiary`: Text/icons on tertiary background

##### Background & Surface
- `background`: App-wide background color
- `onBackground`: Text on background
- `surface`: Cards, sheets, dialogs surface color
- `onSurface`: Text on surface
- `surfaceVariant`: Subtle surface variation
- `onSurfaceVariant`: Text on surface variant

##### Semantic State Colors
- `error`: Error state display
- `onError`: Text on error background
- `errorContainer`: Light error variant
- `onErrorContainer`: Text on error container
- `warning`: Warning state display
- `onWarning`: Text on warning
- `success`: Success state display
- `onSuccess`: Text on success
- `info`: Information display
- `onInfo`: Text on info

##### Outline & Border
- `outline`: Borders, dividers, outlines
- `outlineVariant`: Light outline variant

#### Light Theme Implementation
File: `Sources/DesignSystem/Themes/Light/LightColorPalette.swift`
- primary: `blue500` (#3B82F6)
- secondary: `purple500` (#A855F7)
- tertiary: `cyan500` (#06B6D4)
- background: white
- surface: `gray50` (#F9FAFB)
- error: `red500` (#EF4444)
- warning: `orange500` (#F97316)
- success: `green500` (#10B981)
- info: `blue500` (#3B82F6)

#### Dark Theme Implementation
File: `Sources/DesignSystem/Themes/Dark/DarkColorPalette.swift`
- primary: `blue400` (#60A5FA)
- secondary: `purple500` (#A855F7)
- tertiary: `cyan500` (#06B6D4)
- background: `gray900` (#111827)
- surface: `gray800` (#1F2937)
- error: `red500` (#EF4444)
- warning: `orange500` (#F97316)
- success: `green500` (#10B981)
- info: `blue400` (#60A5FA)

---

## 2. TYPOGRAPHY SYSTEM

File: `Sources/DesignSystem/Tokens/Semantic/Typography.swift`

### Typography Enum Cases
Accessed via: `.typography(.case)`

#### Display (Largest Text)
- `.displayLarge`: 57pt, Bold, line height: 64pt
- `.displayMedium`: 45pt, Bold, line height: 52pt
- `.displaySmall`: 36pt, Bold, line height: 44pt

#### Headline (Section Headers)
- `.headlineLarge`: 32pt, Semibold, line height: 40pt
- `.headlineMedium`: 28pt, Semibold, line height: 36pt
- `.headlineSmall`: 24pt, Semibold, line height: 32pt

#### Title (Subtitles & Card Titles)
- `.titleLarge`: 22pt, Semibold, line height: 28pt
- `.titleMedium`: 16pt, Semibold, line height: 24pt
- `.titleSmall`: 14pt, Semibold, line height: 20pt

#### Body (Main Content)
- `.bodyLarge`: 16pt, Regular, line height: 24pt
- `.bodyMedium`: 14pt, Regular, line height: 20pt
- `.bodySmall`: 12pt, Regular, line height: 16pt

#### Label (Buttons, Tags, Forms)
- `.labelLarge`: 14pt, Medium, line height: 20pt
- `.labelMedium`: 12pt, Medium, line height: 16pt
- `.labelSmall`: 11pt, Medium, line height: 16pt

### Font Sizes (Primitive)
File: `Sources/DesignSystem/Tokens/Primitive/PrimitiveTypography.swift`
- `size11`: 11pt
- `size12`: 12pt
- `size14`: 14pt
- `size16`: 16pt
- `size22`: 22pt
- `size24`: 24pt
- `size28`: 28pt
- `size32`: 32pt
- `size36`: 36pt
- `size45`: 45pt
- `size57`: 57pt

### Line Heights (Primitive)
- `lineHeight16`: 16pt (Small text)
- `lineHeight20`: 20pt (Small-Medium)
- `lineHeight24`: 24pt (Body/Title)
- `lineHeight28`: 28pt (Title Large)
- `lineHeight32`: 32pt (Headline Small)
- `lineHeight36`: 36pt (Headline Medium)
- `lineHeight40`: 40pt (Headline Large)
- `lineHeight44`: 44pt (Display Small)
- `lineHeight52`: 52pt (Display Medium)
- `lineHeight64`: 64pt (Display Large)

---

## 3. SPACING SYSTEM

File: `Sources/DesignSystem/Tokens/Semantic/SpacingScale.swift`

Accessed via: `@Environment(\.spacingScale) var spacing`

### Spacing Scale (T-Shirt Sizing)
- `none`: 0pt - No spacing
- `xxs`: 2pt - Minimal spacing
- `xs`: 4pt - Very small
- `sm`: 8pt - Small
- `md`: 12pt - Medium
- `lg`: 16pt - Standard (default recommended)
- `xl`: 24pt - Large
- `xxl`: 32pt - Very large
- `xxxl`: 48pt - Extra large
- `xxxxl`: 64pt - Maximum

### Primitive Spacing Values
File: `Sources/DesignSystem/Tokens/Primitive/PrimitiveSpacing.swift`
- `space0`: 0pt
- `space2`: 2pt
- `space4`: 4pt
- `space8`: 8pt
- `space12`: 12pt
- `space16`: 16pt
- `space20`: 20pt
- `space24`: 24pt
- `space32`: 32pt
- `space40`: 40pt
- `space48`: 48pt
- `space64`: 64pt
- `space80`: 80pt
- `space96`: 96pt

### Default Spacing Scale Implementation
File: `Sources/DesignSystem/Themes/Default/DefaultSpacingScale.swift`
Maps T-shirt sizes to primitive values (e.g., `lg` → 16pt)

---

## 4. CORNER RADIUS SYSTEM

File: `Sources/DesignSystem/Tokens/Semantic/RadiusScale.swift`

Accessed via: `@Environment(\.radiusScale) var radius`

### Radius Scale
- `none`: 0pt - No rounding (square)
- `xs`: 2pt - Minimal rounding
- `sm`: 4pt - Small rounding
- `md`: 8pt - Medium (recommended for cards)
- `lg`: 12pt - Large rounding
- `xl`: 16pt - Very large
- `xxl`: 20pt - Extra large
- `full`: 9999pt - Complete circle (buttons, avatars)

### Primitive Radius Values
File: `Sources/DesignSystem/Tokens/Primitive/PrimitiveRadius.swift`
- `radius0`: 0pt
- `radius2`: 2pt
- `radius4`: 4pt
- `radius6`: 6pt
- `radius8`: 8pt
- `radius12`: 12pt
- `radius16`: 16pt
- `radius20`: 20pt
- `radius24`: 24pt
- `radiusFull`: .infinity

### Default Radius Scale Implementation
File: `Sources/DesignSystem/Themes/Default/DefaultRadiusScale.swift`
Maps scale sizes to primitive values

---

## 5. ELEVATION & SHADOW SYSTEM

File: `Sources/DesignSystem/Tokens/Component/Elevation.swift`

### Elevation Levels
Used for depth and hierarchy through shadows

#### Elevation Enum Cases
- `.level0`: No shadow - Embedded elements
  - Blur radius: 0pt
  - Offset: 0pt
  - Opacity: 0%

- `.level1`: Light shadow - List items, light cards
  - Blur radius: 3pt
  - Offset: 0pt, 1pt
  - Opacity: 12%

- `.level2`: Standard shadow - Cards, panels (recommended)
  - Blur radius: 6pt
  - Offset: 0pt, 2pt
  - Opacity: 14%

- `.level3`: Medium shadow - Elevated cards
  - Blur radius: 8pt
  - Offset: 0pt, 4pt
  - Opacity: 16%

- `.level4`: Strong shadow - Modals, popups
  - Blur radius: 10pt
  - Offset: 0pt, 6pt
  - Opacity: 18%

- `.level5`: Maximum shadow - Drawers, important dialogs
  - Blur radius: 12pt
  - Offset: 0pt, 8pt
  - Opacity: 20%

**Note**: Dark mode multiplies opacity by 1.5× for visibility

---

## 6. COMPONENT LIBRARY

### 6.1 BUTTONS

#### Button Styles
Location: `Sources/DesignSystem/Components/Button/`

##### Primary Button Style
File: `PrimaryButtonStyle.swift`
- **Usage**: Main actions (login, submit, save)
- **Styling**: Primary color background, white text, scale animation on press
- **Accessibility**: Disabled state opacity 60%
- **Usage Pattern**: `Button("Label") { }.buttonStyle(.primary)`

##### Secondary Button Style
File: `SecondaryButtonStyle.swift`
- **Usage**: Supporting actions
- **Styling**: Secondary color variant styling

##### Tertiary Button Style
File: `TertiaryButtonStyle.swift`
- **Usage**: Subtle, low-emphasis actions

#### Button Sizes
File: `ButtonSize.swift`

```swift
public enum ButtonSize: Sendable {
    case large   // 56pt height, 24pt horizontal padding
    case medium  // 48pt height, 20pt horizontal padding
    case small   // 40pt height, 16pt horizontal padding
}
```

**Usage**: `Button("Label") { }.buttonSize(.large)`

**Typography Mapping**:
- Large: `.labelLarge`
- Medium: `.labelMedium`
- Small: `.labelSmall`

### 6.2 TEXT FIELD

File: `Sources/DesignSystem/Components/TextField/DSTextField.swift`

#### DSTextField Component
A comprehensive text input with:
- Label (optional)
- Placeholder text
- Leading/trailing icons (SF Symbols)
- Supporting text (helper)
- Error state display
- Two style options: `.outlined` (default), `.filled`

**Usage Example**:
```swift
DSTextField(
    "Email",
    text: $email,
    placeholder: "example@email.com",
    style: .outlined,
    error: errorMessage,
    leadingIcon: "envelope"
)
```

### 6.3 CARD

File: `Sources/DesignSystem/Components/Card/Card.swift`

#### Card Component
Generic container for grouping content

**Features**:
- Surface color background
- Corner radius: 12pt (fixed)
- Elevation support (level0-level5)
- Default padding: 16pt all sides (spacing.lg)
- Custom padding support

**Usage Example**:
```swift
Card(elevation: .level2) {
    VStack(alignment: .leading, spacing: spacing.md) {
        Text("Title").typography(.titleMedium)
        Text("Description").typography(.bodyMedium)
    }
}
```

### 6.4 CHIP

File: `Sources/DesignSystem/Components/Chip/Chip.swift`

#### Chip Component
Compact label for status, categories, filters, tags

**Features**:
- Text-only, icon support, deletable (input chip)
- Three style options:
  - `.filled` (default)
  - `.outlined`
  - `.liquidGlass` (semi-transparent)
- Two size options:
  - `.small` (24pt height)
  - `.medium` (32pt height, default)
- Selection support with @Binding

**Usage Example**:
```swift
Chip("Active")
    .chipStyle(.filled)

Chip("Complete", systemImage: "checkmark.circle.fill")
    .chipStyle(.filled)

Chip("Remove", systemImage: "xmark") {
    removeItem()
}
```

### 6.5 ICON BUTTON

File: `Sources/DesignSystem/Components/IconButton/IconButton.swift`

Icon-only button component with consistent sizing

### 6.6 FLOATING ACTION BUTTON

File: `Sources/DesignSystem/Components/FloatingActionButton/FloatingActionButton.swift`

FAB component for primary actions

---

## 7. MOTION & ANIMATION

File: `Sources/DesignSystem/Tokens/Semantic/Motion.swift`

Motion spec configurations for UI animations

---

## 8. THEME SYSTEM

File: `Sources/DesignSystem/Themes/`

### Theme Protocol
File: `ThemeProtocol.swift`
- `id`: Unique identifier
- `name`: Display name
- `description`: Theme description
- `category`: Theme category (standard, brand personality, accessibility)
- `previewColors`: Array of colors for preview
- `colorPalette(for mode:)`: Returns color palette for light/dark mode

### Available Themes

#### Default Theme
File: `Default/DefaultTheme.swift`
- Blue-based standard theme
- Uses LightColorPalette and DarkColorPalette

#### Brand Personality Themes
Location: `Sources/DesignSystem/Themes/BrandPersonality/`
- **Ocean Theme**: Cyan/blue ocean aesthetic
- **Forest Theme**: Green forest aesthetic
- **Sunset Theme**: Orange/red sunset aesthetic
- **PurpleHaze Theme**: Purple mystical aesthetic
- **Monochrome Theme**: Gray neutral aesthetic

Each theme has:
- Light palette variant
- Dark palette variant
- Theme implementation file

#### Accessibility Theme
Location: `Sources/DesignSystem/Themes/Accessibility/`
- **HighContrastTheme**: Enhanced contrast for accessibility
  - HighContrastLightPalette
  - HighContrastDarkPalette

### Theme Mode
File: `ThemeMode.swift`
```swift
enum ThemeMode {
    case system  // Follow system settings
    case light   // Force light theme
    case dark    // Force dark theme
}
```

---

## 9. ENVIRONMENT KEYS & INTEGRATION

Location: `Sources/DesignSystem/Environment/EnvironmentKeys.swift`

Accessed via @Environment(\.keyName):
- `colorPalette`: Current ColorPalette
- `spacingScale`: Current SpacingScale
- `radiusScale`: Current RadiusScale
- `motion`: Current Motion settings
- `buttonSize`: Current ButtonSize
- `chipStyle`: Current ChipStyle
- `chipSize`: Current ChipSize
- `textFieldStyle`: Current TextFieldStyle

---

## 10. EXTENSIONS & MODIFIERS

### Typography Modifier
File: `Sources/DesignSystem/Modifiers/TypographyModifier.swift`
- `Text("Label").typography(.labelLarge)`

### Elevation Modifier
File: `Sources/DesignSystem/Modifiers/ElevationModifier.swift`
- `.elevation(.level2)`

### View Extensions
File: `Sources/DesignSystem/Extensions/View+Theme.swift`
- Theme-related view modifiers

### Color Extensions
File: `Sources/DesignSystem/Extensions/Color+Hex.swift`
- Hex color initialization: `Color(hex: "#3B82F6")`

---

## 11. QUICK REFERENCE FOR AUTHENTICATION UI

### Color Usage
- **Primary Action**: `colors.primary`
- **Text**: `colors.onSurface` (normal), `colors.onBackground` (headers)
- **Background**: `colors.background`
- **Card/Input Background**: `colors.surface`
- **Borders**: `colors.outline`
- **Error**: `colors.error` & `colors.onError`
- **Success**: `colors.success` & `colors.onSuccess`

### Spacing Usage
- **Form Vertical Spacing**: `spacing.lg` (16pt)
- **Component Padding**: `spacing.lg` (16pt)
- **Card Inner Padding**: Default 16pt (spacing.lg)
- **Section Spacing**: `spacing.xl` (24pt)
- **Tight Spacing**: `spacing.sm` (8pt)

### Typography Usage
- **Screen Title**: `.headlineSmall` or `.titleLarge`
- **Section Header**: `.titleMedium`
- **Form Label**: `.bodySmall` or `.labelLarge`
- **Input Text**: `.bodyLarge`
- **Helper/Error Text**: `.bodySmall`
- **Button Text**: `.labelLarge` (built into button style)

### Radius Usage
- **Input Fields**: `radius.md` (8pt)
- **Cards**: Default 12pt (built-in)
- **Buttons**: Full circle via `cornerRadius(radius.full)`
- **General Containers**: `radius.md` or `radius.lg`

### Button Configuration
- **Primary Action Button**: `.buttonStyle(.primary).buttonSize(.large)` or `.medium`
- **Text Fields**: `DSTextField(...)` with appropriate icons and error handling
- **Cards**: Wrap content with `Card(elevation: .level1)`

### Elevation Guidelines
- **Input Fields**: `.level1`
- **Cards**: `.level2` (standard)
- **Modal/Dialog**: `.level4` or `.level5`
- **No Shadow**: `.level0`
