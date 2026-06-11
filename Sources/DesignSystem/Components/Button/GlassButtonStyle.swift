import SwiftUI

/// 中立（無着色）の Liquid Glass ボタンスタイル。
///
/// `.primaryGlass` の対になるセカンダリアクション用。背景を透過させつつ、
/// 同じガラス言語でアクション群を構成したい場合に使用します。
/// ガラス面（`surfaceStyle(.glass)`）上のセカンダリボタンの標準形。
public struct GlassButtonStyle: ButtonStyle {
    @Environment(\.colorPalette) private var colorPalette
    @Environment(\.buttonSize) private var buttonSize
    @Environment(\.isEnabled) private var isEnabled
    @Environment(\.motion) private var motion

    public init() {}

    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .typography(buttonSize.typography)
            .foregroundStyle(colorPalette.onSurface)
            .padding(.horizontal, buttonSize.horizontalPadding)
            .frame(height: buttonSize.height)
            // macOS は内容幅（HIG: フルワイド塗りは watchOS のイディオム。macOS は幅を内容に合わせる）。
            #if os(iOS)
            .frame(maxWidth: .infinity)
            #endif
            .background {
                backgroundShape
            }
            .elevation(.level2)
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .opacity(isEnabled ? 1.0 : 0.6)
            .animate(motion.tap, value: configuration.isPressed)
    }

    @ViewBuilder
    private var backgroundShape: some View {
        if #available(iOS 26.0, macOS 26.0, *) {
            Capsule()
                .fill(.clear)
                .glassEffect(.regular.interactive(true), in: Capsule())
        } else {
            Capsule()
                .fill(.ultraThinMaterial)
                .overlay {
                    Capsule().strokeBorder(colorPalette.outlineVariant, lineWidth: 1)
                }
        }
    }
}

public extension ButtonStyle where Self == GlassButtonStyle {
    /// 中立（無着色）の Liquid Glass ボタンスタイル。
    static var glass: GlassButtonStyle {
        GlassButtonStyle()
    }
}
