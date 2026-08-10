import SwiftUI

/// The quietest button style, with no background and only a text color.
///
/// Use it for light, link-like actions and for anything that should not be emphasized.
///
/// ## Example
/// ```swift
/// Button("See details") {
///     showDetail()
/// }
/// .buttonStyle(.tertiary)
///
/// Button("Skip") {
///     skip()
/// }
/// .buttonStyle(.tertiary)
/// .buttonSize(.small)
/// ```
///
/// ## When to use it
/// - A link to more detail
/// - A skip button
/// - An optional action
/// - An inline control
public struct TertiaryButtonStyle: ButtonStyle {
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
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 100)
                    .fill(Color.clear)
            )
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .opacity(isEnabled ? 1.0 : 0.6)
            .animate(motion.tap, value: configuration.isPressed)
    }
}

public extension ButtonStyle where Self == TertiaryButtonStyle {
    static var tertiary: TertiaryButtonStyle {
        TertiaryButtonStyle()
    }
}
