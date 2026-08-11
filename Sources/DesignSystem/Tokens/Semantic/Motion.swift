import SwiftUI

/// The animation timings a theme supplies.
///
/// The predefined timings keep animation consistent across the design system. The values
/// follow the industry standards set by Material Design 3, the IBM Carbon Design System,
/// and the Apple Human Interface Guidelines.
///
/// ## Example
/// ```swift
/// @Environment(\.motion) var motion
///
/// Button("Tap") { }
///     .scaleEffect(isPressed ? 0.98 : 1.0)
///     .animate(motion.tap, value: isPressed)
/// ```
///
/// ## Categories
/// - **Micro-interactions**: `quick`, `tap` - instant feedback (70-110ms)
/// - **State changes**: `toggle`, `fadeIn`, `fadeOut` - switching a UI element (150ms)
/// - **Transitions**: `slide`, `slow`, `slower` - moving content (240-375ms)
/// - **Springs**: `spring`, `bounce` - natural, physics-based movement
///
/// ## Accessibility
/// The `.animate()` modifier minimizes animation automatically when the setting to reduce
/// motion is turned on, which meets WCAG 2.1.
public protocol Motion: Sendable {
    // MARK: - Micro-interactions

    /// The fastest animation, for micro-interactions.
    ///
    /// Best for an instant visual response such as a hover effect or cursor feedback.
    /// - Duration: 70ms
    /// - Easing: Ease-out
    var quick: Animation { get }

    /// The animation for a tap or a press.
    ///
    /// Gives immediate feedback for direct interaction, such as pressing a button or
    /// flipping a switch.
    /// - Duration: 110ms
    /// - Easing: Ease-out
    var tap: Animation { get }

    // MARK: - State Changes

    /// The animation for toggling a state.
    ///
    /// Used for checkboxes, selection, and switching between active and inactive.
    /// - Duration: 150ms
    /// - Easing: Ease-in-out
    var toggle: Animation { get }

    /// The animation for an element appearing.
    ///
    /// Used when new content, a modal, or an alert appears.
    /// - Duration: 150ms
    /// - Easing: Ease-out
    var fadeIn: Animation { get }

    /// The animation for an element disappearing.
    ///
    /// Used when content is hidden, a modal closes, or a notification clears.
    /// - Duration: 150ms
    /// - Easing: Ease-in
    var fadeOut: Animation { get }

    // MARK: - Transitions

    /// The animation for moving content into a new position.
    ///
    /// Used for tab switches, pagination, and carousels, where content moves smoothly.
    /// - Duration: 240ms
    /// - Easing: Ease-in-out
    var slide: Animation { get }

    /// A slow animation, for a change of context.
    ///
    /// Used when a section expands, a layout changes substantially, or a full-screen
    /// transition runs.
    /// - Duration: 300ms
    /// - Easing: Ease-in-out
    var slow: Animation { get }

    /// An even slower animation, for complex transitions.
    ///
    /// Used for navigation transitions, large layout shifts, and several elements moving
    /// together.
    /// - Duration: 375ms
    /// - Easing: Ease-in-out
    var slower: Animation { get }

    // MARK: - Spring Animations

    /// A natural spring animation.
    ///
    /// Used when a drag and drop is released, when scrolling settles, and for elastic
    /// movement.
    /// - Response: 0.3s
    /// - Damping: 0.6 (moderate bounce)
    var spring: Animation { get }

    /// A spring animation with a pronounced bounce.
    ///
    /// Used where a moment should feel playful, for success feedback, and to draw attention.
    /// - Response: 0.5s
    /// - Damping: 0.5 (larger bounce)
    var bounce: Animation { get }

    /// The appearance animation for content that streams in piece by piece.
    ///
    /// Suits a screen that assembles itself as its parts arrive, such as a streaming LLM
    /// response. One step more relaxed than `slower` at 375ms.
    /// - Duration: 450ms
    /// - Easing: Smooth spring
    var stream: Animation { get }
}

public extension Motion {
    /// The animation used when a theme does not supply its own.
    var stream: Animation { .smooth(duration: 0.45) }
}

// MARK: - Default Implementation

/// The motion timings used when a theme does not supply its own.
///
/// The values follow the recommendations of Material Design 3 and the IBM Carbon Design
/// System.
public struct DefaultMotion: Motion {
    public init() {}

    // MARK: - Micro-interactions

    public var quick: Animation {
        .easeOut(duration: 0.07)
    }

    public var tap: Animation {
        .easeOut(duration: 0.11)
    }

    // MARK: - State Changes

    public var toggle: Animation {
        .easeInOut(duration: 0.15)
    }

    public var fadeIn: Animation {
        .easeOut(duration: 0.15)
    }

    public var fadeOut: Animation {
        .easeIn(duration: 0.15)
    }

    // MARK: - Transitions

    public var slide: Animation {
        .easeInOut(duration: 0.24)
    }

    public var slow: Animation {
        .easeInOut(duration: 0.30)
    }

    public var slower: Animation {
        .easeInOut(duration: 0.375)
    }

    // MARK: - Spring Animations

    public var spring: Animation {
        .spring(response: 0.3, dampingFraction: 0.6)
    }

    public var bounce: Animation {
        .spring(response: 0.5, dampingFraction: 0.5)
    }
}
