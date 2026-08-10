import SwiftUI

/// A button style for supporting actions.
///
/// Draws on a SecondaryContainer background, so it reads as less prominent than Primary.
/// A screen can hold several of them.
///
/// ## Example
/// ```swift
/// HStack {
///     Button("Cancel") {
///         cancel()
///     }
///     .buttonStyle(.secondary)
///
///     Button("Save") {
///         save()
///     }
///     .buttonStyle(.primary)
/// }
/// ```
///
/// ## When to use it
/// - A cancel button
/// - An alternative action
/// - A form reset button
public struct SecondaryButtonStyle: ButtonStyle {
    @Environment(\.colorPalette) private var colorPalette
    @Environment(\.buttonSize) private var buttonSize
    @Environment(\.isEnabled) private var isEnabled
    @Environment(\.motion) private var motion

    public init() {}

    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .typography(buttonSize.typography)
            .foregroundStyle(colorPalette.onSecondaryContainer)
            .padding(.horizontal, buttonSize.horizontalPadding)
            .frame(height: buttonSize.height)
            // macOS sizes to the content (in the HIG a full-width fill is a watchOS idiom; macOS fits the width to the content).
            #if os(iOS)
            .frame(maxWidth: .infinity)
            #endif
            .background(
                RoundedRectangle(cornerRadius: 100)
                    .fill(colorPalette.secondaryContainer)
                    .opacity(isEnabled ? 1.0 : 0.6)
            )
            .elevation(.level1)
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .opacity(isEnabled ? 1.0 : 0.6)
            .animate(motion.tap, value: configuration.isPressed)
    }
}

public extension ButtonStyle where Self == SecondaryButtonStyle {
    static var secondary: SecondaryButtonStyle {
        SecondaryButtonStyle()
    }
}
