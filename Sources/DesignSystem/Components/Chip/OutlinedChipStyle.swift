import SwiftUI

/// A chip style drawn with a border and no fill.
///
/// It suits filter selection, secondary categories, and information that should stay quiet.
///
/// ## Example
/// ```swift
/// Chip("Filter", systemImage: "line.3.horizontal.decrease", isSelected: $isFiltered)
///     .chipStyle(.outlined)
///
/// Chip("Category", systemImage: "tag")
///     .chipStyle(.outlined)
///     .foregroundColor(.blue)
/// ```
///
/// ## Appearance
/// - Background: clear, or the primary color at 10% opacity when selected
/// - Border: 1.5pt in the outline color
/// - Label: the inherited foreground color
/// - Shape: a capsule
/// - When selected: both the background and the border take the primary color
public struct OutlinedChipStyle: ChipStyle, Sendable {
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
            configuration.isSelected
                ? Color.primary.opacity(0.1)
                : Color.clear
        )
        .clipShape(Capsule())
        .overlay(
            Capsule()
                .strokeBorder(
                    configuration.isSelected
                        ? Color.primary
                        : configuration.colorPalette.outline,
                    lineWidth: 1.5
                )
        )
        .scaleEffect(configuration.isPressed ? 0.96 : 1.0)
        .animate(configuration.motion.tap, value: configuration.isPressed)
        .animate(configuration.motion.toggle, value: configuration.isSelected)
    }
}

public extension ChipStyle where Self == OutlinedChipStyle {
    static var outlined: OutlinedChipStyle {
        OutlinedChipStyle()
    }
}
