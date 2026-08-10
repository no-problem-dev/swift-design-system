import SwiftUI

/// A token that sets the height, the padding, the icon size, and the typography of a chip.
///
/// Pick the size that fits the context: a status label, a category tag, a filter, and so on.
///
/// ## Example
/// ```swift
/// Chip("Active", systemImage: "circle.fill")
///     .chipSize(.medium)  // the default
///
/// Chip("New", systemImage: "bell.fill")
///     .chipSize(.small)   // a compact display
/// ```
///
/// ## Choosing a size
/// - **Small**: dense layouts and supporting information (24pt)
/// - **Medium**: standard use, where readability comes first (32pt)
public enum ChipSize: Sendable {
    /// A 24pt chip for compact layouts.
    case small

    /// A 32pt chip, which is the standard size.
    case medium

    var height: CGFloat {
        switch self {
        case .small: return 24
        case .medium: return 32
        }
    }

    var horizontalPadding: CGFloat {
        switch self {
        case .small: return 6
        case .medium: return 8
        }
    }

    var verticalPadding: CGFloat {
        switch self {
        case .small: return 2
        case .medium: return 4
        }
    }

    var iconSize: CGFloat {
        switch self {
        case .small: return 14
        case .medium: return 18
        }
    }

    var typography: Typography {
        switch self {
        case .small: return .labelSmall
        case .medium: return .labelMedium
        }
    }
}

private struct ChipSizeKey: EnvironmentKey {
    static let defaultValue: ChipSize = .medium
}

public extension EnvironmentValues {
    /// The size applied to the chips in this environment.
    ///
    /// Set it with the `chipSize(_:)` modifier. The default is `.medium`.
    var chipSize: ChipSize {
        get { self[ChipSizeKey.self] }
        set { self[ChipSizeKey.self] = newValue }
    }
}
