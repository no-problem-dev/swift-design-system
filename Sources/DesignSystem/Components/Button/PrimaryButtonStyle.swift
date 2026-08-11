import SwiftUI

/// The most prominent button style, for the main action on a screen such as signing in, submitting, or saving.
///
/// Places onPrimary text on a Primary-colored background, and scales down while pressed.
///
/// ## Example
/// ```swift
/// Button("Sign in") {
///     login()
/// }
/// .buttonStyle(.primary)
/// .buttonSize(.large)  // size is optional
///
/// Button("Save") {
///     save()
/// }
/// .buttonStyle(.primary)
/// .buttonSize(.medium)
/// ```
///
/// ## Choosing a style
/// - **Primary**: the most important action. One per screen.
/// - **Secondary**: a supporting action.
/// - **Tertiary**: a quiet action.
public struct PrimaryButtonStyle: ButtonStyle {
    @Environment(\.colorPalette) private var colorPalette
    @Environment(\.buttonSize) private var buttonSize
    @Environment(\.isEnabled) private var isEnabled
    @Environment(\.motion) private var motion

    public init() {}

    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .typography(buttonSize.typography)
            .foregroundStyle(colorPalette.onPrimary)
            .padding(.horizontal, buttonSize.horizontalPadding)
            .frame(height: buttonSize.height)
            // macOS sizes to the content (in the HIG a full-width fill is a watchOS idiom; macOS fits the width to the content).
            #if os(iOS)
            .frame(maxWidth: .infinity)
            #endif
            .background(
                RoundedRectangle(cornerRadius: 100)
                    .fill(colorPalette.primary)
            )
            .elevation(.level2)
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .opacity(isEnabled ? 1 : ControlTokens.disabledOpacity)
            .animate(motion.tap, value: configuration.isPressed)
    }
}

public extension ButtonStyle where Self == PrimaryButtonStyle {
    static var primary: PrimaryButtonStyle {
        PrimaryButtonStyle()
    }
}
