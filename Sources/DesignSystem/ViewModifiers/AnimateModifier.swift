import SwiftUI

// MARK: - Animate Modifier

/// Applies an animation that follows the system Reduce Motion setting.
///
/// The animation runs whenever the observed value changes. When Reduce Motion is turned on,
/// the animation is reduced to an almost instant change.
///
/// ## Accessibility
/// - Follows WCAG 2.1 Success Criterion 2.3.3 (Animation from Interactions).
/// - When `accessibilityReduceMotion` is on, the animation becomes an instant change (10ms).
/// - Call sites do not need to check the setting themselves.
///
/// ## Example
/// ```swift
/// @Environment(\.motion) var motion
/// @State private var isPressed = false
///
/// Button("Tap") {
///     isPressed.toggle()
/// }
/// .scaleEffect(isPressed ? 0.98 : 1.0)
/// .animate(motion.tap, value: isPressed)
/// ```
///
/// ## Combining with Motion
/// ```swift
/// // Fade in and out
/// Text("Message")
///     .opacity(isVisible ? 1 : 0)
///     .animate(motion.fadeIn, value: isVisible)
///
/// // Slide
/// SomeView()
///     .offset(x: selectedTab == .home ? 0 : -UIScreen.main.bounds.width)
///     .animate(motion.slide, value: selectedTab)
///
/// // Spring
/// Circle()
///     .offset(y: isDragging ? dragOffset : 0)
///     .animate(motion.spring, value: dragOffset)
/// ```
public struct AnimateModifier<V: Equatable>: ViewModifier {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    let animation: Animation

    /// The value to watch. The animation runs each time it changes.
    let value: V

    /// - Parameters:
    ///   - animation: The animation to apply. Prefer one supplied by the `Motion` protocol.
    ///   - value: The value to watch.
    public init(animation: Animation, value: V) {
        self.animation = animation
        self.value = value
    }

    public func body(content: Content) -> some View {
        content.animation(
            reduceMotion ? .linear(duration: 0.01) : animation,
            value: value
        )
    }
}

// MARK: - View Extension

public extension View {
    /// Applies an animation that follows the system Reduce Motion setting.
    ///
    /// The animation runs whenever the observed value changes. When Reduce Motion is turned on,
    /// the animation is reduced to an almost instant change.
    ///
    /// - Parameters:
    ///   - animation: The animation to apply.
    ///   - value: The value to watch. The animation runs each time it changes.
    ///
    /// ## Recommended usage
    /// ```swift
    /// @Environment(\.motion) var motion
    ///
    /// // Press feedback on a button
    /// Button("Button") { }
    ///     .scaleEffect(isPressed ? 0.98 : 1.0)
    ///     .animate(motion.tap, value: isPressed)
    ///
    /// // Switching state
    /// Toggle("Setting", isOn: $isEnabled)
    ///     .foregroundColor(isEnabled ? .blue : .gray)
    ///     .animate(motion.toggle, value: isEnabled)
    /// ```
    func animate<V: Equatable>(_ animation: Animation, value: V) -> some View {
        modifier(AnimateModifier(animation: animation, value: value))
    }
}
