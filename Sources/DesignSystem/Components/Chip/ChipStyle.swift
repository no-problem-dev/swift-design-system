import SwiftUI

/// A type that defines the appearance of a chip.
///
/// Adopt it to build a reusable style, the same way `ButtonStyle` works in SwiftUI, then apply
/// it with the `chipStyle(_:)` modifier.
///
/// ## Creating a custom style
/// ```swift
/// struct CustomChipStyle: ChipStyle {
///     func makeBody(configuration: ChipStyleConfiguration) -> some View {
///         HStack(spacing: 4) {
///             if let icon = configuration.icon {
///                 icon
///             }
///             configuration.label
///             if let onDelete = configuration.onDelete {
///                 Button(action: onDelete) {
///                     Image(systemName: "xmark.circle.fill")
///                 }
///             }
///         }
///         .padding(.horizontal, 12)
///         .padding(.vertical, 6)
///         .background(Color.blue.opacity(0.2))
///         .cornerRadius(16)
///     }
/// }
/// ```
public protocol ChipStyle: Sendable {
    associatedtype Body: View

    /// Creates the view that represents the body of a chip.
    /// - Parameter configuration: The content and the state of the chip being styled.
    @MainActor
    func makeBody(configuration: ChipStyleConfiguration) -> Body
}

/// The content and the state a style uses to build the body of a chip.
///
/// It carries the label, the icon, the delete handler, the interaction state, and the design
/// tokens already resolved from the environment.
public struct ChipStyleConfiguration {
    public let label: AnyView

    /// The icon shown ahead of the label, if there is one.
    public let icon: AnyView?

    /// The handler called when the delete button is tapped.
    ///
    /// When it is not `nil`, draw a delete button: the chip acts as a deletable input chip.
    public let onDelete: (() -> Void)?

    /// Whether the chip is selected, as in a filter chip.
    public let isSelected: Bool

    /// Whether the chip is being pressed. Use it to show tap feedback.
    public let isPressed: Bool

    public let size: ChipSize

    public let colorPalette: any ColorPalette

    public let spacingScale: any SpacingScale

    public let radiusScale: any RadiusScale

    public let motion: any Motion
}

private struct ChipStyleKey: EnvironmentKey {
    static let defaultValue: AnyChipStyle = AnyChipStyle(FilledChipStyle())
}

public extension EnvironmentValues {
    /// The style applied to the chips in this environment.
    ///
    /// Set it with the `chipStyle(_:)` modifier. The default is ``FilledChipStyle``.
    var chipStyle: AnyChipStyle {
        get { self[ChipStyleKey.self] }
        set { self[ChipStyleKey.self] = newValue }
    }
}

/// A type-erased chip style.
///
/// Use it to hold a style whose concrete type is not known, such as the one carried in the
/// environment.
public struct AnyChipStyle: ChipStyle {
    private let _makeBody: @MainActor @Sendable (ChipStyleConfiguration) -> AnyView

    init<S: ChipStyle>(_ style: S) where S: Sendable {
        _makeBody = { @MainActor @Sendable configuration in
            AnyView(style.makeBody(configuration: configuration))
        }
    }

    @MainActor
    public func makeBody(configuration: ChipStyleConfiguration) -> some View {
        _makeBody(configuration)
    }
}
