import SwiftUI

/// A chip style with a filled background.
///
/// It suits status indicators, category labels, and other fixed information.
///
/// ## Example
/// ```swift
/// Chip("Active", systemImage: "circle.fill")
///     .chipStyle(.filled)
///     .foregroundColor(.green)
///
/// Chip("Premium", systemImage: "star.fill")
///     .chipStyle(.filled)
///     .foregroundColor(.orange)
/// ```
///
/// ## Appearance
/// - Background: the primary color at 10% opacity
/// - Label: the inherited foreground color at full opacity
/// - Shape: a capsule
/// - When selected: the background opacity rises to 20%
public struct FilledChipStyle: ChipStyle, Sendable {
    public init() {}

    public func makeBody(configuration: ChipStyleConfiguration) -> some View {
        HStack(spacing: configuration.spacingScale.xs) {
            // Leading icon
            if let icon = configuration.icon {
                icon
                    .font(.system(size: configuration.size.iconSize))
            }

            // Label
            configuration.label
                .typography(configuration.size.typography)
                .fontWeight(.medium)

            // Delete button
            if let onDelete = configuration.onDelete {
                Button(action: onDelete) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: configuration.size.iconSize))
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, configuration.size.horizontalPadding)
        .padding(.vertical, configuration.size.verticalPadding)
        .frame(height: configuration.size.height)
        .background(
            backgroundOpacity(for: configuration)
        )
        .clipShape(Capsule())
        .scaleEffect(configuration.isPressed ? 0.96 : 1.0)
        .animate(configuration.motion.tap, value: configuration.isPressed)
        .animate(configuration.motion.toggle, value: configuration.isSelected)
    }

    private func backgroundOpacity(for configuration: ChipStyleConfiguration) -> some ShapeStyle {
        configuration.colorPalette.primary.opacity(configuration.isSelected ? 0.2 : 0.1)
    }
}

public extension ChipStyle where Self == FilledChipStyle {
    static var filled: FilledChipStyle {
        FilledChipStyle()
    }
}
