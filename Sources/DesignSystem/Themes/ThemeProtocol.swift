import SwiftUI

/// A named set of design tokens that an app can switch between at runtime.
///
/// A conforming type supplies identifying metadata and a color palette for each mode.
/// Every other token group has a default implementation, so a theme overrides only the
/// groups it wants to change.
///
/// ## Example
/// ```swift
/// struct CustomTheme: Theme {
///     var id: String { "custom" }
///     var name: String { "Custom" }
///     var description: String { "A color theme of your own" }
///     var category: ThemeCategory { .brandPersonality }
///     var previewColors: [Color] { [.blue, .cyan, .teal] }
///
///     func colorPalette(for mode: ThemeMode) -> any ColorPalette {
///         switch mode {
///         case .system, .light:
///             CustomLightPalette()
///         case .dark:
///             CustomDarkPalette()
///         }
///     }
/// }
/// ```
public protocol Theme: Sendable, Identifiable, Equatable {
    /// An identifier that is unique among the themes an app makes available.
    ///
    /// Themes are compared and looked up by this value, and a theme whose identifier
    /// already exists is dropped when it is registered, so keep it stable across releases.
    var id: String { get }

    /// The name shown to people when they pick a theme.
    var name: String { get }

    /// A short sentence describing the theme, shown next to its name.
    var description: String { get }

    /// The group the theme is listed under.
    var category: ThemeCategory { get }

    /// Three to five representative colors, for previewing the theme before it is applied.
    var previewColors: [Color] { get }

    /// Returns the color palette to use for the given mode.
    ///
    /// Handle all three modes. The system mode is resolved to light or dark before a view asks
    /// for its palette, but it arrives here unresolved when the palette is read straight from
    /// the theme provider, so map it to the light palette unless there is a reason not to.
    /// - Parameter mode: The mode the palette is asked for.
    func colorPalette(for mode: ThemeMode) -> any ColorPalette

    /// The icon sizes the theme uses.
    ///
    /// These are the tokens behind call sites such as `Image(systemName:).iconSize(.sm)`.
    /// The default implementation returns ``DefaultIconSizeScale``, so a theme that does not
    /// change icon sizes has nothing to override here.
    var iconSizeScale: any IconSizeScale { get }

    /// The animation timings the theme uses.
    ///
    /// These are the tokens behind call sites such as `.animate(motion.tap, value:)`.
    /// The default implementation returns ``DefaultMotion``, so a theme that does not change
    /// timings has nothing to override here.
    var motion: any Motion { get }

    /// The type ramp the theme uses.
    ///
    /// These are the tokens behind call sites such as `.typography(.bodyMedium)`.
    /// The default implementation returns ``DefaultTypographyScale``, so a theme that does not
    /// change type has nothing to override and looks the same as before. Override this to give
    /// a brand its own sizes, line heights, and typefaces.
    var typographyScale: any TypographyScale { get }

    /// The spacing steps the theme uses.
    ///
    /// Components read these tokens through `@Environment(\.spacingScale)`.
    /// The default implementation returns ``DefaultSpacingScale``, so a theme that does not
    /// change spacing has nothing to override and looks the same as before. Override this to
    /// give a brand its own spacing, such as a scale derived from character width.
    var spacingScale: any SpacingScale { get }

    /// The corner radii the theme uses.
    ///
    /// Components read these tokens through `@Environment(\.radiusScale)`.
    /// The default implementation returns ``DefaultRadiusScale``, so a theme that does not
    /// change corner radii has nothing to override and looks the same as before.
    var radiusScale: any RadiusScale { get }

    /// The border widths the theme uses.
    ///
    /// The default implementation returns ``DefaultBorderScale``.
    var borderScale: any BorderScale { get }

    /// The overlay opacities the theme uses for interaction states.
    ///
    /// The default implementation returns ``DefaultStateLayer``.
    var stateLayer: any StateLayer { get }

    /// The gradients the theme uses for semantic roles.
    ///
    /// The default implementation returns ``DefaultGradientTokens``. Override this to give a
    /// brand its own gradients.
    var gradients: any GradientTokens { get }

    /// The shadow ramp the theme uses.
    ///
    /// The default implementation returns ``DefaultElevationScale``.
    var elevationScale: any ElevationScale { get }
}

// MARK: - Equatable Default Implementation

public extension Theme {
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }
}

// MARK: - Default Token Implementations

public extension Theme {
    var iconSizeScale: any IconSizeScale {
        DefaultIconSizeScale()
    }

    var motion: any Motion {
        DefaultMotion()
    }

    var typographyScale: any TypographyScale {
        DefaultTypographyScale()
    }

    var spacingScale: any SpacingScale {
        DefaultSpacingScale()
    }

    var radiusScale: any RadiusScale {
        DefaultRadiusScale()
    }

    var borderScale: any BorderScale {
        DefaultBorderScale()
    }

    var stateLayer: any StateLayer {
        DefaultStateLayer()
    }

    var gradients: any GradientTokens {
        DefaultGradientTokens()
    }

    var elevationScale: any ElevationScale {
        DefaultElevationScale()
    }
}
