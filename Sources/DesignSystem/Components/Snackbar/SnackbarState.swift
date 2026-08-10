import SwiftUI

/// The presentation state of a snackbar.
///
/// Holds whether the snackbar is on screen, the message and actions it shows, and the timer that
/// dismisses it on its own.
///
/// ## Example
/// ```swift
/// @State private var snackbarState = SnackbarState()
///
/// // Show a snackbar
/// snackbarState.show(
///     message: "Saved",
///     duration: 3.0
/// )
///
/// // Show one with an action
/// snackbarState.show(
///     message: "Deleted",
///     primaryAction: SnackbarAction(title: "Undo") {
///         // Undo the deletion
///     },
///     duration: 5.0
/// )
/// ```
@MainActor
@Observable
public final class SnackbarState {
    public private(set) var isVisible: Bool = false

    public private(set) var message: String = ""

    public private(set) var primaryAction: SnackbarAction?

    public private(set) var secondaryAction: SnackbarAction?

    private var dismissTask: Task<Void, Never>?

    public init() {}

    /// Shows the snackbar, replacing whatever it is showing and restarting the dismiss timer.
    ///
    /// - Parameters:
    ///   - message: The message to show.
    ///   - primaryAction: The main action button.
    ///   - secondaryAction: The supporting action button.
    ///   - duration: The number of seconds before the snackbar dismisses itself.
    public func show(
        message: String,
        primaryAction: SnackbarAction? = nil,
        secondaryAction: SnackbarAction? = nil,
        duration: TimeInterval = 5.0
    ) {
        // Cancel the existing timer
        dismissTask?.cancel()

        // Update the state
        self.message = message
        self.primaryAction = primaryAction
        self.secondaryAction = secondaryAction
        self.isVisible = true

        // Set the auto dismiss timer
        dismissTask = Task {
            try? await Task.sleep(nanoseconds: UInt64(duration * 1_000_000_000))
            if !Task.isCancelled {
                self.dismiss()
            }
        }
    }

    /// Hides the snackbar and cancels the auto dismiss timer.
    public func dismiss() {
        dismissTask?.cancel()
        isVisible = false
    }
}

public struct SnackbarAction {
    public let title: String

    /// The work performed when the button is tapped.
    ///
    /// The snackbar dismisses itself as soon as this starts, without waiting for it to finish.
    public let action: @MainActor () async -> Void

    public init(title: String, action: @escaping @MainActor () async -> Void) {
        self.title = title
        self.action = action
    }
}
