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

// MARK: - IconSizeScale

private struct IconSizeScaleKey: EnvironmentKey {
    static let defaultValue: any IconSizeScale = DefaultIconSizeScale()
}

extension EnvironmentValues {
    /// アイコンサイズスケール。
    ///
    /// Image / Text emoji の表示サイズを token 化するためのスケール。
    /// `.iconSize(.sm/.md/.lg/...)` モディファイアが内部で参照する。
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
    /// モーションタイミング設定
    ///
    /// 一貫したアニメーションタイミングを提供します。
    /// `.animate()` モディファイアと組み合わせて使用します。
    ///
    /// ## 使用例
    /// ```swift
    /// @Environment(\.motion) var motion
    ///
    /// Button("タップ") { }
    ///     .scaleEffect(isPressed ? 0.98 : 1.0)
    ///     .animate(motion.tap, value: isPressed)
    /// ```
    public var motion: any Motion {
        get { self[MotionKey.self] }
        set { self[MotionKey.self] = newValue }
    }
}
