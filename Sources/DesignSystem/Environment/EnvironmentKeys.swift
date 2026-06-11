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
    /// 型ランプ（役割 → スタイルの写像）。
    ///
    /// `.typography(.bodyMedium)` モディファイアが内部で参照する。テーマが供給し、
    /// 未適用時は ``DefaultTypographyScale``（既存 enum 由来）が使われるため見た目は不変。
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
    /// 線幅スケール。`@Environment(\.borderScale)` で参照する。
    public var borderScale: any BorderScale {
        get { self[BorderScaleKey.self] }
        set { self[BorderScaleKey.self] = newValue }
    }
}

// MARK: - StateLayer

private struct StateLayerKey: EnvironmentKey {
    static let defaultValue: any StateLayer = DefaultStateLayer()
}

extension EnvironmentValues {
    /// 状態レイヤー不透明度。hover/pressed/focus 等のオーバーレイ濃度。
    public var stateLayer: any StateLayer {
        get { self[StateLayerKey.self] }
        set { self[StateLayerKey.self] = newValue }
    }
}

// MARK: - GradientTokens

private struct GradientTokensKey: EnvironmentKey {
    static let defaultValue: any GradientTokens = DefaultGradientTokens()
}

extension EnvironmentValues {
    /// 意味的グラデーション。`@Environment(\.gradients)` で参照する。
    public var gradients: any GradientTokens {
        get { self[GradientTokensKey.self] }
        set { self[GradientTokensKey.self] = newValue }
    }
}

// MARK: - ElevationScale

private struct ElevationScaleKey: EnvironmentKey {
    static let defaultValue: any ElevationScale = DefaultElevationScale()
}

extension EnvironmentValues {
    /// 影ランプ。`.elevation(.levelN)` が内部で参照する。テーマが影の重さを差し替えられる。
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
