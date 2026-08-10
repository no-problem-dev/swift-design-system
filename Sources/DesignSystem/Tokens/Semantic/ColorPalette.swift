import SwiftUI

/// The set of colors a theme supplies to the rest of the app.
///
/// Each theme provides its own implementation, which keeps color use consistent across the
/// app. A palette can back a light theme, a dark theme, or a custom brand theme.
///
/// ## Example
/// ```swift
/// @Environment(\.colorPalette) var colors
///
/// VStack {
///     Text("Heading")
///         .foregroundStyle(colors.primary)
///     Text("Body")
///         .foregroundStyle(colors.onSurface)
/// }
/// .background(colors.surface)
/// ```
///
/// ## Creating a custom theme
/// ```swift
/// struct MyBrandPalette: ColorPalette {
///     var primary: Color { Color(hex: "#007AFF") }
///     var background: Color { .white }
///     var surface: Color { Color(hex: "#F2F2F7") }
///     // ... implement the remaining required properties
/// }
///
/// // Use the palette from a Theme
/// struct MyBrandTheme: Theme {
///     var id: String { "myBrand" }
///     var name: String { "My Brand" }
///     var description: String { "Brand color theme" }
///     var category: ThemeCategory { .brandPersonality }
///     var previewColors: [Color] { [Color(hex: "#007AFF")] }
///
///     func colorPalette(for mode: ThemeMode) -> any ColorPalette {
///         switch mode {
///         case .system, .light: MyBrandPalette()
///         case .dark: MyBrandDarkPalette()
///         }
///     }
/// }
///
/// // Register it with ThemeProvider
/// ThemeProvider(initialTheme: MyBrandTheme())
/// ```
public protocol ColorPalette: Sendable {
    // MARK: - Primary Colors

    /// The color for primary actions and brand elements.
    var primary: Color { get }

    /// The color for text and icons drawn on a primary background.
    var onPrimary: Color { get }

    /// A lighter variant of the primary color, for container backgrounds.
    var primaryContainer: Color { get }

    /// The color for text drawn on a primary container background.
    var onPrimaryContainer: Color { get }

    // MARK: - Secondary Colors

    /// A supporting accent color.
    var secondary: Color { get }

    /// The color for text and icons drawn on a secondary background.
    var onSecondary: Color { get }

    /// A lighter variant of the secondary color, for container backgrounds.
    var secondaryContainer: Color { get }

    /// The color for text drawn on a secondary container background.
    var onSecondaryContainer: Color { get }

    // MARK: - Tertiary Colors

    /// A third accent color, for further emphasis.
    var tertiary: Color { get }

    /// The color for text and icons drawn on a tertiary background.
    var onTertiary: Color { get }

    // MARK: - Background & Surface

    /// The background color of the app as a whole.
    var background: Color { get }

    /// The color for text drawn on the app background.
    var onBackground: Color { get }

    /// The color of surfaces such as cards, sheets, and dialogs.
    var surface: Color { get }

    /// The color for text drawn on a surface.
    var onSurface: Color { get }

    /// An alternative surface color, for setting one surface subtly apart from another.
    var surfaceVariant: Color { get }

    /// The color for text drawn on a surface variant.
    var onSurfaceVariant: Color { get }

    /// The shadow color that gives cards, floating buttons, and popovers their depth.
    var shadow: Color { get }

    /// The surface color of a container raised slightly to moderately above the background.
    var elevatedSurface: Color { get }

    /// The surface color of a container raised well above the background.
    var elevatedSurfaceHigh: Color { get }

    // MARK: - Semantic State Colors

    /// The color that marks an error state.
    var error: Color { get }

    /// The color for text drawn on an error background.
    var onError: Color { get }

    /// A lighter variant of the error color, for container backgrounds.
    var errorContainer: Color { get }

    /// The color for text drawn on an error container background.
    var onErrorContainer: Color { get }

    /// The color that marks a warning state.
    var warning: Color { get }

    /// The color for text drawn on a warning background.
    var onWarning: Color { get }

    /// The color that marks a success state.
    var success: Color { get }

    /// The color for text drawn on a success background.
    var onSuccess: Color { get }

    /// The color for informational messages.
    var info: Color { get }

    /// The color for text drawn on an info background.
    var onInfo: Color { get }

    // MARK: - Outline & Border

    /// The color for borders, dividers, and outlines.
    var outline: Color { get }

    /// A lighter variant of the outline color.
    var outlineVariant: Color { get }
}

// MARK: - Default Implementations

public extension ColorPalette {
    // Default implementations for the derived colors
    var primaryContainer: Color { primary.opacity(0.12) }
    var onPrimaryContainer: Color { primary }
    var secondaryContainer: Color { secondary.opacity(0.12) }
    var onSecondaryContainer: Color { secondary }

    var errorContainer: Color { error.opacity(0.12) }
    var onErrorContainer: Color { error }

    // Defaults for the "on" colors
    var onPrimary: Color { .white }
    var onSecondary: Color { .white }
    var onTertiary: Color { .white }
    var onError: Color { .white }
    var onWarning: Color { .black }
    var onSuccess: Color { .white }
    var onInfo: Color { .white }

    var outlineVariant: Color { outline.opacity(0.5) }

    var shadow: Color { .black }
    var elevatedSurface: Color { surface }
    var elevatedSurfaceHigh: Color { elevatedSurface }
}
