import SwiftUI

/// Primary色で tint したLiquid Glassボタンスタイル。
///
/// 浮遊アクションや画面下部の固定アクションなど、背景を透過させつつ
/// Primary色で同じアクション群として見せたい場合に使用します。
public struct PrimaryGlassButtonStyle: ButtonStyle {
    @Environment(\.colorPalette) private var colorPalette
    @Environment(\.buttonSize) private var buttonSize
    @Environment(\.isEnabled) private var isEnabled
    @Environment(\.motion) private var motion

    public init() {}

    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .typography(buttonSize.typography)
            .foregroundStyle(colorPalette.primary)
            .padding(.horizontal, buttonSize.horizontalPadding)
            .frame(height: buttonSize.height)
            // macOS は内容幅（HIG: フルワイド塗りは watchOS のイディオム。macOS は幅を内容に合わせる）。
            #if os(iOS)
            .frame(maxWidth: .infinity)
            #endif
            .background {
                backgroundShape
            }
            .elevation(.level3)
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .opacity(isEnabled ? 1.0 : 0.6)
            .animate(motion.tap, value: configuration.isPressed)
    }

    @ViewBuilder
    private var backgroundShape: some View {
        if #available(iOS 26.0, macOS 26.0, *) {
            Capsule()
                .fill(colorPalette.primary.opacity(0.05))
                .glassEffect(.regular.tint(colorPalette.primary.opacity(0.18)).interactive(true), in: Capsule())
        } else {
            Capsule()
                .fill(colorPalette.primary.opacity(0.06))
                .background(.ultraThinMaterial, in: Capsule())
        }
    }
}

public extension ButtonStyle where Self == PrimaryGlassButtonStyle {
    /// Primary色で tint したLiquid Glassボタンスタイル。
    static var primaryGlass: PrimaryGlassButtonStyle {
        PrimaryGlassButtonStyle()
    }
}
