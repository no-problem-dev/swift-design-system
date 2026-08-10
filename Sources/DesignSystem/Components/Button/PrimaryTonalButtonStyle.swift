import SwiftUI

/// A quieter button style that keeps the hue of Primary.
///
/// Use it for supporting actions that belong to the main flow: actions that should feel
/// related to Primary, but should not carry as much weight as the filled Primary button.
public struct PrimaryTonalButtonStyle: ButtonStyle {
    @Environment(\.colorPalette) private var colorPalette
    @Environment(\.buttonSize) private var buttonSize
    @Environment(\.isEnabled) private var isEnabled
    @Environment(\.motion) private var motion

    public init() {}

    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .typography(buttonSize.typography)
            .foregroundStyle(colorPalette.onPrimaryContainer)
            .padding(.horizontal, buttonSize.horizontalPadding)
            .frame(height: buttonSize.height)
            .frame(maxWidth: .infinity)
            .background {
                RoundedRectangle(cornerRadius: 100)
                    .fill(colorPalette.primaryContainer)
                    .overlay {
                        RoundedRectangle(cornerRadius: 100)
                            .stroke(colorPalette.primary.opacity(0.18), lineWidth: 1)
                    }
                    .opacity(isEnabled ? 1.0 : 0.6)
            }
            .elevation(.level1)
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .opacity(isEnabled ? 1.0 : 0.6)
            .animate(motion.tap, value: configuration.isPressed)
    }
}

public extension ButtonStyle where Self == PrimaryTonalButtonStyle {
    /// A quieter button style that keeps the hue of Primary.
    static var primaryTonal: PrimaryTonalButtonStyle {
        PrimaryTonalButtonStyle()
    }
}
