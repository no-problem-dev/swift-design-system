import SwiftUI

/// A compact label for a status, a category, a filter, or a piece of user input.
///
/// ## Example
/// ```swift
/// // A plain chip
/// Chip("Active")
///     .chipStyle(.filled)
///     .foregroundColor(.blue)
///
/// // A chip with an icon
/// Chip("Done", systemImage: "checkmark.circle.fill")
///     .chipStyle(.filled)
///     .foregroundColor(.green)
///
/// // A deletable chip (the onDelete: label is required)
/// Chip("Swift", systemImage: "tag.fill", onDelete: {
///     removeTag("Swift")
/// })
/// .chipStyle(.filled)
///
/// // A selectable filter chip
/// Chip("Filter", systemImage: "line.3.horizontal.decrease", isSelected: $isFiltered)
///     .chipStyle(.outlined)
/// ```
///
/// ## Style variants
/// - **Filled**: a filled background, and the default
/// - **Outlined**: a border only
/// - **Liquid Glass**: a translucent glass effect
///
/// ## Size variants
/// - **Small**: 24pt tall, for dense layouts
/// - **Medium**: 32pt tall, for standard use, and the default
public struct Chip: View {
    @Environment(\.chipStyle) private var chipStyle
    @Environment(\.chipSize) private var size
    @Environment(\.colorPalette) private var colorPalette
    @Environment(\.spacingScale) private var spacingScale
    @Environment(\.radiusScale) private var radiusScale
    @Environment(\.motion) private var motion

    private let label: String
    private let systemImage: String?
    private let onDelete: (() -> Void)?
    private let onAction: (() -> Void)?
    private let isSelectable: Bool
    @Binding private var isSelected: Bool
    @State private var isPressed: Bool = false

    // MARK: - Initializers

    /// Creates a chip that shows text only.
    /// - Parameter label: The text to display.
    public init(_ label: String) {
        self.label = label
        self.systemImage = nil
        self.onDelete = nil
        self.onAction = nil
        self.isSelectable = false
        self._isSelected = .constant(false)
    }

    /// Creates a chip with a leading icon.
    /// - Parameters:
    ///   - label: The text to display.
    ///   - systemImage: The SF Symbols name of the icon.
    public init(_ label: String, systemImage: String) {
        self.label = label
        self.systemImage = systemImage
        self.onDelete = nil
        self.onAction = nil
        self.isSelectable = false
        self._isSelected = .constant(false)
    }

    /// Creates an action chip.
    ///
    /// The chip runs the action when it is tapped. It shows no delete button, and the whole
    /// chip is the tap target.
    ///
    /// - Parameters:
    ///   - label: The text to display.
    ///   - systemImage: The SF Symbols name of the icon.
    ///   - action: The action to run when the chip is tapped.
    public init(
        _ label: String,
        systemImage: String? = nil,
        action: @escaping () -> Void
    ) {
        self.label = label
        self.systemImage = systemImage
        self.onDelete = nil
        self.onAction = action
        self.isSelectable = false
        self._isSelected = .constant(false)
    }

    /// Creates a deletable input chip.
    /// - Parameters:
    ///   - label: The text to display.
    ///   - systemImage: The SF Symbols name of the icon.
    ///   - onDelete: The handler called when the delete button is tapped.
    public init(
        _ label: String,
        systemImage: String? = nil,
        onDelete: @escaping () -> Void
    ) {
        self.label = label
        self.systemImage = systemImage
        self.onDelete = onDelete
        self.onAction = nil
        self.isSelectable = false
        self._isSelected = .constant(false)
    }

    /// Creates a selectable filter chip.
    /// - Parameters:
    ///   - label: The text to display.
    ///   - systemImage: The SF Symbols name of the icon.
    ///   - isSelected: A binding to the selection state, which a tap toggles.
    public init(
        _ label: String,
        systemImage: String? = nil,
        isSelected: Binding<Bool>
    ) {
        self.label = label
        self.systemImage = systemImage
        self.onDelete = nil
        self.onAction = nil
        self.isSelectable = true
        self._isSelected = isSelected
    }

    // MARK: - Body

    public var body: some View {
        let configuration = ChipStyleConfiguration(
            label: AnyView(Text(label)),
            icon: systemImage.map { AnyView(Image(systemName: $0)) },
            onDelete: onDelete,
            isSelected: isSelected,
            isPressed: isPressed,
            size: size,
            colorPalette: colorPalette,
            spacingScale: spacingScale,
            radiusScale: radiusScale,
            motion: motion
        )

        Group {
            if onDelete != nil || onAction != nil || isSelectable {
                // A tappable chip: delete, action, or selection
                Button(action: handleTap) {
                    chipStyle.makeBody(configuration: configuration)
                }
                .buttonStyle(ChipButtonStyle(isPressed: $isPressed))
            } else {
                // A static chip
                chipStyle.makeBody(configuration: configuration)
            }
        }
    }

    // MARK: - Private Methods

    private func handleTap() {
        if let onDelete = onDelete {
            // Delete
            onDelete()
        } else if let onAction = onAction {
            // Run the action
            onAction()
        } else {
            // Toggle the selection
            withAnimation(motion.toggle) {
                isSelected.toggle()
            }
        }
    }
}

// MARK: - ChipButtonStyle

/// A button style that mirrors the pressed state into a binding.
///
/// The chip reads that binding to show its own tap feedback.
private struct ChipButtonStyle: ButtonStyle {
    @Binding var isPressed: Bool

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .onChange(of: configuration.isPressed) { _, newValue in
                isPressed = newValue
            }
    }
}

// MARK: - Previews

#Preview("Basic Chips") {
    VStack(spacing: 16) {
        Chip("Active")
            .chipStyle(.filled)
            .foregroundColor(.blue)

        Chip("完了", systemImage: "checkmark.circle.fill")
            .chipStyle(.filled)
            .foregroundColor(.green)

        Chip("New", systemImage: "bell.fill")
            .chipStyle(.filled)
            .chipSize(.small)
            .foregroundColor(.orange)
    }
    .padding()
}

#Preview("Deletable Chips") {
    VStack(spacing: 16) {
        Chip("Swift", systemImage: "tag.fill", onDelete: {
            print("Delete Swift")
        })
        .chipStyle(.filled)
        .foregroundColor(.blue)

        Chip("SwiftUI", onDelete: {
            print("Delete SwiftUI")
        })
        .chipStyle(.filled)
        .chipSize(.small)
        .foregroundColor(.purple)
    }
    .padding()
}

#Preview("Action Chips") {
    VStack(spacing: 16) {
        Chip("再生", systemImage: "play.fill", action: {
            print("Play tapped")
        })
        .chipStyle(.outlined)

        Chip("共有", systemImage: "square.and.arrow.up", action: {
            print("Share tapped")
        })
        .chipStyle(.outlined)

        Chip("保存", systemImage: "square.and.arrow.down", action: {
            print("Save tapped")
        })
        .chipStyle(.filled)
    }
    .padding()
}

#Preview("Selectable Chips") {
    struct SelectableChipExample: View {
        @State private var isSelected1 = false
        @State private var isSelected2 = true

        var body: some View {
            VStack(spacing: 16) {
                Chip("フィルター", systemImage: "line.3.horizontal.decrease", isSelected: $isSelected1)
                    .chipStyle(.outlined)

                Chip("お気に入り", systemImage: "star.fill", isSelected: $isSelected2)
                    .chipStyle(.outlined)
            }
            .padding()
        }
    }

    return SelectableChipExample()
}
