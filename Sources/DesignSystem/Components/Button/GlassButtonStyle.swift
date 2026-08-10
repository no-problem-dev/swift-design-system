import SwiftUI

/// A neutral, untinted Liquid Glass button style.
///
/// Use it for the secondary action that pairs with `.primaryGlass`, when a group of actions
/// should let the background show through and share the same glass language.
/// It is the standard form for a secondary button on a glass surface (`surfaceStyle(.glass)`).
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
            // macOS sizes to the content (in the HIG a full-width fill is a watchOS idiom; macOS fits the width to the content).
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
    /// A neutral, untinted Liquid Glass button style.
    static var glass: GlassButtonStyle {
        GlassButtonStyle()
    }
}
