import SwiftUI

// MARK: - ColorPalette

private struct ColorPaletteKey: EnvironmentKey {
    static let defaultValue: any ColorPalette = LightColorPalette()
}

extension EnvironmentValues {
    public var colorPalette: any ColorPalette {
        get { self[ColorPaletteKey.self] }
        set { self[ColorPaletteKey.self] = newValue }
    }
}

// MARK: - SpacingScale

private struct SpacingScaleKey: EnvironmentKey {
    static let defaultValue: any SpacingScale = DefaultSpacingScale()
}

extension EnvironmentValues {
    public var spacingScale: any SpacingScale {
        get { self[SpacingScaleKey.self] }
        set { self[SpacingScaleKey.self] = newValue }
    }
}

// MARK: - RadiusScale

private struct RadiusScaleKey: EnvironmentKey {
    static let defaultValue: any RadiusScale = DefaultRadiusScale()
}

extension EnvironmentValues {
    public var radiusScale: any RadiusScale {
        get { self[RadiusScaleKey.self] }
        set { self[RadiusScaleKey.self] = newValue }
    }
}

// MARK: - TypographyScale

private struct TypographyScaleKey: EnvironmentKey {
    static let defaultValue: any TypographyScale = DefaultTypographyScale()
}

extension EnvironmentValues {
    /// The type ramp, which maps a text role to a style.
    ///
    /// The `.typography(.bodyMedium)` modifier reads it. A theme supplies it, and
    /// ``DefaultTypographyScale`` is used when no theme has been applied.
    public var typographyScale: any TypographyScale {
        get { self[TypographyScaleKey.self] }
        set { self[TypographyScaleKey.self] = newValue }
    }
}

// MARK: - BorderScale

private struct BorderScaleKey: EnvironmentKey {
    static let defaultValue: any BorderScale = DefaultBorderScale()
}

extension EnvironmentValues {
    /// The line widths used for borders and dividers.
    public var borderScale: any BorderScale {
        get { self[BorderScaleKey.self] }
        set { self[BorderScaleKey.self] = newValue }
    }
}

// MARK: - ElevationScale

private struct ElevationScaleKey: EnvironmentKey {
    static let defaultValue: any ElevationScale = DefaultElevationScale()
}

extension EnvironmentValues {
    /// The shadow ramp that `.elevation(.levelN)` reads, so a theme can set how heavy shadows are.
    public var elevationScale: any ElevationScale {
        get { self[ElevationScaleKey.self] }
        set { self[ElevationScaleKey.self] = newValue }
    }
}

// MARK: - IconSizeScale

private struct IconSizeScaleKey: EnvironmentKey {
    static let defaultValue: any IconSizeScale = DefaultIconSizeScale()
}

extension EnvironmentValues {
    /// The sizes at which icons are drawn.
    ///
    /// Keeps symbol images and emoji text on the same set of sizes. The `.iconSize(.sm)`,
    /// `.iconSize(.md)`, and related modifiers read it.
    public var iconSizeScale: any IconSizeScale {
        get { self[IconSizeScaleKey.self] }
        set { self[IconSizeScaleKey.self] = newValue }
    }
}

// MARK: - Motion

private struct MotionKey: EnvironmentKey {
    static let defaultValue: any Motion = DefaultMotion()
}

extension EnvironmentValues {
    /// The animation timings, so motion stays consistent across the app.
    ///
    /// Pair it with the `.animate()` modifier rather than writing a duration at the call site.
    ///
    /// ## Example
    /// ```swift
    /// @Environment(\.motion) var motion
    ///
    /// Button("Tap") { }
    ///     .scaleEffect(isPressed ? 0.98 : 1.0)
    ///     .animate(motion.tap, value: isPressed)
    /// ```
    public var motion: any Motion {
        get { self[MotionKey.self] }
        set { self[MotionKey.self] = newValue }
    }
}
