import SwiftUI

/// How far a surface sits above what is behind it, expressed as a shadow.
///
/// Consistent shadows convey the hierarchy and the importance of the elements on screen.
/// The higher the level, the further forward the element appears.
///
/// ## Example
/// ```swift
/// Card {
///     Text("Card content")
/// }
/// .elevation(.level2)  // The standard shadow
///
/// RoundedRectangle(cornerRadius: 12)
///     .fill(Color.white)
///     .frame(width: 200, height: 100)
///     .elevation(.level3)  // A medium shadow
/// ```
///
/// ## Choosing a level
/// - **Level 0**: no shadow - inset elements
/// - **Level 1**: a light shadow - list rows and light cards
/// - **Level 2**: the standard shadow - cards and panels (recommended)
/// - **Level 3**: a medium shadow - a raised card
/// - **Level 4**: a strong shadow - modals and popovers
/// - **Level 5**: the strongest shadow - drawers and important dialogs
public enum Elevation {
    /// No shadow.
    case level0

    /// A light shadow, for list rows and light cards.
    case level1

    /// The standard shadow, for cards and panels.
    case level2

    /// A medium shadow, for a raised card.
    case level3

    /// A strong shadow, for modals and popovers.
    case level4

    /// The strongest shadow, for drawers and important dialogs.
    case level5

    // MARK: - Shadow Properties

    /// The blur radius of the shadow.
    public var radius: CGFloat {
        switch self {
        case .level0: return 0
        case .level1: return 3
        case .level2: return 6
        case .level3: return 8
        case .level4: return 10
        case .level5: return 12
        }
    }

    public var offset: CGSize {
        switch self {
        case .level0: return .zero
        case .level1: return CGSize(width: 0, height: 1)
        case .level2: return CGSize(width: 0, height: 2)
        case .level3: return CGSize(width: 0, height: 4)
        case .level4: return CGSize(width: 0, height: 6)
        case .level5: return CGSize(width: 0, height: 8)
        }
    }

    /// The opacity of the shadow in light mode.
    public var opacity: Double {
        switch self {
        case .level0: return 0
        case .level1: return 0.08
        case .level2: return 0.10
        case .level3: return 0.12
        case .level4: return 0.14
        case .level5: return 0.16
        }
    }

    /// The shadow opacity adjusted for the given color scheme.
    ///
    /// Dark mode conveys depth through the difference in surface brightness rather than
    /// through a black shadow, so the shadow is held back there.
    public func opacity(for colorScheme: ColorScheme) -> Double {
        colorScheme == .dark ? opacity * 0.55 : opacity
    }

    /// The opacity of the tint laid over an elevated surface.
    public func surfaceTintOpacity(for colorScheme: ColorScheme) -> Double {
        switch self {
        case .level0:
            return 0
        case .level1:
            return colorScheme == .dark ? 0.03 : 0.015
        case .level2:
            return colorScheme == .dark ? 0.04 : 0.02
        case .level3:
            return colorScheme == .dark ? 0.05 : 0.025
        case .level4:
            return colorScheme == .dark ? 0.06 : 0.03
        case .level5:
            return colorScheme == .dark ? 0.07 : 0.035
        }
    }
}
