import SwiftUI

/// A transient notice that rises from the bottom of the screen.
///
/// Shows feedback for a user action or a short message.
///
/// ## Basic usage
/// ```swift
/// @State private var snackbarState = SnackbarState()
///
/// var body: some View {
///     ZStack {
///         ContentView()
///
///         Snackbar(state: snackbarState)
///     }
///     .onAppear {
///         snackbarState.show(message: "Saved")
///     }
/// }
/// ```
///
/// ## Snackbar with actions
/// ```swift
/// snackbarState.show(
///     message: "Deleted",
///     primaryAction: SnackbarAction(title: "Undo") {
///         // Undo the deletion
///     },
///     secondaryAction: SnackbarAction(title: "Dismiss") {
///         snackbarState.dismiss()
///     }
/// )
/// ```
///
/// ## Design guidelines
/// - Keep the message short, one or two lines
/// - Use at most two actions
/// - Three to seven seconds works well for the auto dismiss duration
/// - Leave enough time for anything the user needs to act on
public struct Snackbar: View {
    @Bindable public var state: SnackbarState
    @Environment(\.colorPalette) private var colors
    @Environment(\.spacingScale) private var spacing
    @Environment(\.radiusScale) private var radius

    /// Creates a snackbar driven by the given state.
    ///
    /// `SnackbarState` is an `@Observable` class. The snackbar view holds a reference to it, and
    /// calling `state.show(message:)` brings the snackbar on screen.
    ///
    /// - Parameter state: The ``SnackbarState`` instance that holds the presentation state.
    public init(state: SnackbarState) {
        self._state = Bindable(state)
    }

    public var body: some View {
        VStack {
            Spacer()

            if state.isVisible {
                HStack(spacing: spacing.md) {
                    // Message
                    Text(state.message)
                        .typography(.bodyLarge)
                        .foregroundStyle(colors.onSurface)
                        .lineLimit(2)
                        .fixedSize(horizontal: false, vertical: true)

                    Spacer(minLength: spacing.sm)

                    // Action buttons
                    HStack(spacing: spacing.sm) {
                        if let primary = state.primaryAction {
                            Button {
                                Task {
                                    await primary.action()
                                }
                                state.dismiss()
                            } label: {
                                Text(primary.title)
                                    .typography(.labelLarge)
                                    .foregroundStyle(colors.primary)
                            }
                            .buttonStyle(.borderless)
                        }

                        if let secondary = state.secondaryAction {
                            Button {
                                Task {
                                    await secondary.action()
                                }
                                state.dismiss()
                            } label: {
                                Text(secondary.title)
                                    .typography(.labelLarge)
                                    .foregroundStyle(colors.error)
                            }
                            .buttonStyle(.borderless)
                        }
                    }
                }
                .padding(.horizontal, spacing.lg)
                .padding(.vertical, spacing.md)
                .background(colors.surfaceVariant)
                .clipShape(RoundedRectangle(cornerRadius: radius.md))
                .elevation(.level2)
                .padding(.horizontal, spacing.lg)
                .padding(.bottom, spacing.lg)
                .transition(.asymmetric(
                    insertion: .move(edge: .bottom).combined(with: .opacity),
                    removal: .move(edge: .bottom).combined(with: .opacity)
                ))
                .accessibilityElement(children: .contain)
                .accessibilityLabel(state.message)
            }
        }
        .animation(.spring(response: 0.3, dampingFraction: 0.8), value: state.isVisible)
    }
}
