import SwiftUI

/// The size of a button: its height, horizontal padding, and label typography.
///
/// ## Example
/// ```swift
/// Button("Sign in") {
///     login()
/// }
/// .buttonStyle(.primary)
/// .buttonSize(.large)  // 56pt tall (default)
///
/// Button("Cancel") {
///     cancel()
/// }
/// .buttonStyle(.secondary)
/// .buttonSize(.small)  // 40pt tall
/// ```
///
/// ## Sizes
/// - **Large**: 56pt tall. For the main action (default).
/// - **Medium**: 48pt tall. For a standard button.
/// - **Small**: 40pt tall. For compact layouts.
public enum ButtonSize: Sendable {
    /// 56pt tall. For the main action on a screen.
    case large

    /// 48pt tall. For a standard button.
    case medium

    /// 40pt tall. For compact layouts.
    case small

    /// The height of the button, which differs by platform.
    ///
    /// macOS assumes pointer input, so the touch-sized heights (56/48/40) shrink to
    /// dimensions closer to those of standard controls. In the HIG, 44pt is the minimum
    /// hit region rather than the size of the button itself. iOS keeps its own dimensions.
    var height: CGFloat {
        #if os(macOS)
        switch self {
        case .large: return 32
        case .medium: return 28
        case .small: return 22
        }
        #else
        switch self {
        case .large: return 56
        case .medium: return 48
        case .small: return 40
        }
        #endif
    }

    var horizontalPadding: CGFloat {
        #if os(macOS)
        switch self {
        case .large: return 16
        case .medium: return 12
        case .small: return 10
        }
        #else
        switch self {
        case .large: return 24
        case .medium: return 20
        case .small: return 16
        }
        #endif
    }

    var typography: Typography {
        switch self {
        case .large: return .labelLarge
        case .medium: return .labelMedium
        case .small: return .labelSmall
        }
    }
}

// MARK: - Environment Key

private struct ButtonSizeKey: EnvironmentKey {
    static let defaultValue: ButtonSize = .large
}

public extension EnvironmentValues {
    var buttonSize: ButtonSize {
        get { self[ButtonSizeKey.self] }
        set { self[ButtonSizeKey.self] = newValue }
    }
}

public extension View {
    /// Sets the size of a button.
    ///
    /// Changes the height, padding, and text size of the button together.
    ///
    /// - Parameter size: The button size (`.large`, `.medium`, or `.small`).
    ///
    /// ## Example
    /// ```swift
    /// Button("Sign in") { }
    ///     .buttonStyle(.primary)
    ///     .buttonSize(.medium)
    ///
    /// Button("Small button") { }
    ///     .buttonStyle(.secondary)
    ///     .buttonSize(.small)
    /// ```
    func buttonSize(_ size: ButtonSize) -> some View {
        environment(\.buttonSize, size)
    }
}
