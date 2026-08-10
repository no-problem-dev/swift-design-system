import SwiftUI

/// A Liquid Glass button style tinted with the Primary color.
///
/// Use it for floating actions and for actions pinned to the bottom of a screen, where the
/// background should show through but the actions still need to read as one Primary-colored group.
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
            // macOS sizes to the content (in the HIG a full-width fill is a watchOS idiom; macOS fits the width to the content).
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
    /// A Liquid Glass button style tinted with the Primary color.
    static var primaryGlass: PrimaryGlassButtonStyle {
        PrimaryGlassButtonStyle()
    }
}
