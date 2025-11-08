# Multi-Theme System Implementation Strategy

## Project Understanding

This Swift Package provides a design system for SwiftUI with:
- 3-layer token system (Primitive → Semantic → Component)
- Material Design 3 inspired ColorPalette protocol (27 semantic colors)
- Current themes: Light and Dark only
- Existing catalog app for showcasing components

**Goal**: Create multiple default themes and a catalog app for theme selection with dynamic switching.

## Research Summary

### Color Theory & Design Systems (2024 Best Practices)

1. **Color Generation Methodologies**:
   - Numeric Scale (50-900): Industry standard from Tailwind/Material
   - Color Space: OKHSL recommended for perceptual uniformity
   - Material 3's HCT (Hue, Chroma, Tone): Allows independent manipulation
   - Tonal Palettes: 13 tones per key color ensures accessibility

2. **Naming Conventions**:
   - Structure: `{namespace}-{category}-{role}-{modifier}-{theme}`
   - Semantic over Visual: "button-primary-background" NOT "blue-button"
   - Token Hierarchy: Primitive → Semantic → Component
   - Multi-theme: Include theme identifier in naming

3. **Accessibility Standards**:
   - WCAG 2.0 AA compliance mandatory
   - WCAG AAA for high-contrast themes
   - Built-in contrast testing in color generation

## Architecture Design

### Core Protocols

```swift
/// Theme protocol with metadata and mode-aware palettes
protocol Theme: Sendable, Identifiable, Equatable {
    var id: String { get }
    var name: String { get }
    var description: String { get }
    var category: ThemeCategory { get }
    var previewColors: [Color] { get }
    
    /// Returns appropriate color palette for light/dark mode
    func colorPalette(for mode: ThemeMode) -> any ColorPalette
}

/// Theme mode enum
enum ThemeMode {
    case light
    case dark
}

/// Theme categories for organization
enum ThemeCategory: String, CaseIterable {
    case standard = "Standard"
    case brandPersonality = "Brand Personality"
    case accessibility = "Accessibility"
    case purposeBased = "Purpose-Based"
}
```

### Enhanced ThemeProvider

```swift
@Observable
@MainActor
public final class ThemeProvider {
    /// Current selected theme
    public var currentTheme: any Theme
    
    /// Current mode (light/dark)
    public var themeMode: ThemeMode
    
    /// Registry of available themes
    public private(set) var availableThemes: [any Theme]
    
    /// Computed color palette based on theme + mode
    public var colorPalette: any ColorPalette {
        currentTheme.colorPalette(for: themeMode)
    }
    
    /// Switch to theme by ID
    public func switchToTheme(id: String)
    
    /// Apply theme object
    public func applyTheme(_ theme: any Theme)
    
    /// Toggle between light/dark mode
    public func toggleMode()
    
    /// Register custom theme
    public func registerTheme(_ theme: any Theme)
    
    // Backward compatibility methods
    public func switchToLight() // Maps to default-light
    public func switchToDark()  // Maps to default-dark
}
```

## Theme Library Design

### Planned Themes (6-8 total)

**1. Standard Category (2)**:
- Default Light (existing LightColorPalette wrapped)
- Default Dark (existing DarkColorPalette wrapped)

**2. Brand Personality Category (5)**:

**Ocean Theme** (Professional, Calm):
- Primary: #0077BE (Deep Ocean Blue)
- Secondary: #00A8CC (Cyan Blue)
- Tertiary: #4ECDC4 (Turquoise)
- Character: Professional, trustworthy, calm
- Use case: Corporate, productivity apps

**Forest Theme** (Natural, Grounded):
- Primary: #2D5016 (Forest Green)
- Secondary: #52B788 (Emerald)
- Tertiary: #74C69D (Mint)
- Character: Eco-friendly, health, nature
- Use case: Health, outdoor, sustainability apps

**Sunset Theme** (Warm, Energetic):
- Primary: #FF6B35 (Coral Orange)
- Secondary: #F77F00 (Pumpkin)
- Tertiary: #FCBF49 (Golden Yellow)
- Character: Energetic, warm, creative
- Use case: Creative, social, entertainment apps

**Purple Haze Theme** (Creative, Innovative):
- Primary: #7209B7 (Royal Purple)
- Secondary: #B5179E (Magenta)
- Tertiary: #F72585 (Hot Pink)
- Character: Innovative, bold, modern
- Use case: Tech, design, creative tools

**Monochrome Theme** (Minimalist, Elegant):
- Primary: #2D3748 (Charcoal)
- Secondary: #4A5568 (Slate)
- Tertiary: #718096 (Gray)
- Character: Minimalist, professional, elegant
- Use case: Business, editorial, premium apps

**3. Accessibility Category (1)**:

**High Contrast Theme**:
- Enhanced contrast ratios (AAA compliance)
- Bold colors with maximum readability
- Use case: Accessibility, low vision users

### Color Derivation Methodology

For each theme, systematically derive all 27 ColorPalette properties:

**Primary Colors** (from seed):
- primary: Seed color
- onPrimary: High contrast (white/black based on luminance)
- primaryContainer: Tinted version (~12% opacity for light, darker for dark mode)
- onPrimaryContainer: Readable text on container

**Secondary/Tertiary** (from color relationships):
- Use analogous, complementary, or triadic relationships
- Maintain consistent luminance relationships

**Background & Surface** (mode-dependent):
- Light mode: background=#FFFFFF, surface=#F7F7F7 (slight tint)
- Dark mode: background=#0F1419, surface=#1A1F24 (elevated)
- onBackground/onSurface: Inverted with proper contrast

**Semantic States** (universal across themes):
- error: Red spectrum (#DC2626)
- warning: Orange/Amber (#F59E0B)
- success: Green (#10B981)
- info: Blue or match primary if blue theme

**Outline** (derived):
- outline: 20-30% opacity of onSurface
- outlineVariant: 10-15% opacity

## Catalog App Architecture

### New Views Structure

```
Sources/DesignSystem/Catalog/
├── Themes/ (NEW)
│   ├── ThemeGalleryView.swift          // Main themes section
│   ├── ThemeCardView.swift             // Individual theme card
│   ├── ThemeDetailView.swift           // Full theme exploration
│   ├── ThemeColorPreview.swift         // Color palette visualization
│   ├── ThemeCategorySection.swift      // Category grouping
│   └── ThemeComparisonView.swift       // Side-by-side comparison
```

### Theme Gallery UX

**Layout**:
- Sections grouped by category
- Grid of theme cards (2 columns on phone, 3-4 on iPad)
- Each card shows: name, description, 3-5 preview colors
- Active theme indicated with checkmark
- Search/filter bar at top

**Theme Card**:
```swift
struct ThemeCardView: View {
    let theme: any Theme
    let isActive: Bool
    let onTap: () -> Void
    
    // Shows:
    // - Theme name
    // - 3-5 color dots preview
    // - Description snippet
    // - Checkmark if active
}
```

**Theme Detail View**:
```swift
struct ThemeDetailView: View {
    let theme: any Theme
    @Environment(\.themeProvider) var provider
    
    // Shows:
    // - Full color palette grid (27 colors)
    // - Color names and hex codes
    // - Component showcase (buttons, cards, etc with this theme)
    // - Accessibility metrics (contrast ratios)
    // - Light/Dark mode toggle preview
    // - "Apply Theme" button
}
```

### Navigation Flow

```
DesignSystemCatalogView (enhanced)
├── Themes Section (NEW)
│   └── NavigationLink to ThemeGalleryView
│       ├── Theme Cards Grid
│       └── Tap card → ThemeDetailView
│           └── Apply button → Updates entire app
├── Foundations (existing)
├── Components (existing)
└── Patterns (existing)
```

### Dynamic Switching Implementation

```swift
// In ThemeGalleryView
Button("Apply") {
    withAnimation(.easeInOut(duration: 0.3)) {
        themeProvider.switchToTheme(id: selectedTheme.id)
    }
}
```

SwiftUI automatically animates all color changes across the entire catalog.

## File Organization

```
Sources/DesignSystem/
├── Themes/
│   ├── ThemeProtocol.swift (NEW)
│   ├── ThemeMode.swift (NEW)
│   ├── ThemeCategory.swift (NEW)
│   ├── Default/
│   │   ├── DefaultLightTheme.swift (REFACTOR)
│   │   ├── DefaultDarkTheme.swift (REFACTOR)
│   │   ├── DefaultLightPalette.swift
│   │   └── DefaultDarkPalette.swift
│   ├── BrandPersonality/ (NEW)
│   │   ├── OceanTheme.swift
│   │   ├── OceanLightPalette.swift
│   │   ├── OceanDarkPalette.swift
│   │   ├── ForestTheme.swift
│   │   ├── ForestLightPalette.swift
│   │   ├── ForestDarkPalette.swift
│   │   ├── SunsetTheme.swift
│   │   ├── SunsetLightPalette.swift
│   │   ├── SunsetDarkPalette.swift
│   │   ├── PurpleHazeTheme.swift
│   │   ├── PurpleHazeLightPalette.swift
│   │   ├── PurpleHazeDarkPalette.swift
│   │   ├── MonochromeTheme.swift
│   │   ├── MonochromeLightPalette.swift
│   │   └── MonochromeDarkPalette.swift
│   ├── Accessibility/ (NEW)
│   │   ├── HighContrastTheme.swift
│   │   ├── HighContrastLightPalette.swift
│   │   └── HighContrastDarkPalette.swift
│   └── ThemeRegistry.swift (NEW)
│
├── ThemeProvider/
│   ├── ThemeProvider.swift (ENHANCE)
│   └── ThemeColorScheme.swift (DEPRECATE or keep for compatibility)
│
└── Catalog/
    ├── Themes/ (NEW)
    │   ├── ThemeGalleryView.swift
    │   ├── ThemeCardView.swift
    │   ├── ThemeDetailView.swift
    │   ├── ThemeColorPreview.swift
    │   └── ThemeCategorySection.swift
    └── DesignSystemCatalogView.swift (ENHANCE)
```

## Implementation Phases

### Phase 1: Foundation (Core Architecture)
**Duration**: 1-2 days

1. Create `Theme` protocol with metadata
2. Create `ThemeMode` and `ThemeCategory` enums
3. Refactor `ThemeProvider` to support theme registry
4. Wrap existing Light/Dark palettes as Default themes
5. Add backward compatibility layer
6. Write unit tests for theme switching
7. Update environment injection

**Deliverable**: Working multi-theme infrastructure with backward compatibility

### Phase 2: Theme Library (Content Creation)
**Duration**: 2-3 days

1. Design and implement Ocean theme (light + dark)
2. Design and implement Forest theme (light + dark)
3. Design and implement Sunset theme (light + dark)
4. Design and implement Purple Haze theme (light + dark)
5. Design and implement Monochrome theme (light + dark)
6. Design and implement High Contrast theme (light + dark)
7. Create ThemeRegistry with all built-in themes
8. Document color derivation methodology
9. Validate WCAG compliance for all themes

**Deliverable**: 6-8 production-ready themes with documentation

### Phase 3: Catalog Integration (UI Development)
**Duration**: 2-3 days

1. Create ThemeGalleryView with category sections
2. Create ThemeCardView component
3. Create ThemeDetailView with full palette display
4. Create ThemeColorPreview component
5. Add theme section to DesignSystemCatalogView
6. Implement smooth theme switching animations
7. Add search/filter functionality
8. Create theme comparison view (optional)

**Deliverable**: Beautiful, functional theme catalog

### Phase 4: Polish & Documentation
**Duration**: 1-2 days

1. Add accessibility auditing to theme detail view
2. Create theme creation guide documentation
3. Add comprehensive SwiftUI previews
4. Performance optimization (lazy loading, caching)
5. Add theme export/import capability (optional)
6. Update README with multi-theme examples
7. Create demo video/screenshots
8. Final testing and bug fixes

**Deliverable**: Production-ready, documented system

## Technical Considerations

### Swift 6 Concurrency
- All themes conform to `Sendable`
- `ThemeProvider` is `@MainActor`
- Thread-safe theme registry

### Performance
- Precomputed color values (no runtime calculations)
- Lazy theme instantiation
- Efficient SwiftUI updates via `@Observable`
- Target: <16ms theme switch for 60fps

### Animation
```swift
withAnimation(.easeInOut(duration: 0.3)) {
    themeProvider.switchToTheme(id: "ocean")
}
```
All color changes animate smoothly automatically.

### Backward Compatibility
```swift
// Old API still works:
themeProvider.switchToLight() 
themeProvider.switchToDark()
themeProvider.applyCustomTheme(colorPalette: palette)

// New API:
themeProvider.switchToTheme(id: "ocean")
themeProvider.toggleMode()
```

## API Usage Examples

### Basic Usage (Unchanged)
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

### Theme Selection
```swift
struct SettingsView: View {
    @Environment(\.themeProvider) var themeProvider
    
    var body: some View {
        List(themeProvider.availableThemes, id: \.id) { theme in
            Button(theme.name) {
                withAnimation {
                    themeProvider.switchToTheme(id: theme.id)
                }
            }
        }
    }
}
```

### Custom Theme Creation
```swift
struct MyBrandTheme: Theme {
    var id: String { "my-brand" }
    var name: String { "My Brand" }
    var description: String { "Custom brand colors" }
    var category: ThemeCategory { .brandPersonality }
    var previewColors: [Color] { [.blue, .green, .purple] }
    
    func colorPalette(for mode: ThemeMode) -> any ColorPalette {
        switch mode {
        case .light: return MyBrandLightPalette()
        case .dark: return MyBrandDarkPalette()
        }
    }
}

// Register and use
themeProvider.registerTheme(MyBrandTheme())
themeProvider.switchToTheme(id: "my-brand")
```

## Success Metrics

1. **Functionality**: 6-8 themes with light/dark variants working smoothly
2. **Performance**: Theme switching <16ms (60fps maintained)
3. **Accessibility**: All themes meet WCAG 2.0 AA minimum
4. **Usability**: Catalog app provides intuitive theme browsing and switching
5. **Extensibility**: Clear documentation for creating custom themes
6. **Compatibility**: Existing code works without changes

## Next Steps

1. Review and approve this strategy
2. Begin Phase 1 implementation (core architecture)
3. Iterate on theme designs with user feedback
4. Implement catalog UI with emphasis on UX
5. Polish and document thoroughly
6. Release as major version update
