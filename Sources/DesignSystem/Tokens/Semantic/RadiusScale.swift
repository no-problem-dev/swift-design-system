import Foundation

/// The corner radii a theme supplies.
///
/// Keeps the corners of cards, buttons, and input fields consistent with one another.
///
/// ## Example
/// ```swift
/// @Environment(\.radiusScale) var radius
///
/// RoundedRectangle(cornerRadius: radius.md)
///     .fill(Color.blue)
///     .frame(width: 100, height: 100)
///
/// // Or
/// Text("Button")
///     .padding()
///     .background(Color.blue)
///     .cornerRadius(radius.lg)
/// ```
///
/// ## The scale
/// - `none`: 0pt - square corners
/// - `xs`: 2pt - the smallest rounding
/// - `sm`: 4pt - a small rounding
/// - `md`: 8pt - a medium rounding (recommended for cards)
/// - `lg`: 12pt - a large rounding
/// - `xl`: 16pt - a very large rounding
/// - `xxl`: 20pt - an extra large rounding
/// - `full`: 9999pt - fully rounded (buttons, avatars)
public protocol RadiusScale: Sendable {
    /// Square corners (0pt).
    var none: CGFloat { get }

    /// The smallest rounding (2pt).
    var xs: CGFloat { get }

    /// A small rounding (4pt).
    var sm: CGFloat { get }

    /// A medium rounding (8pt), recommended for cards.
    var md: CGFloat { get }

    /// A large rounding (12pt).
    var lg: CGFloat { get }

    /// A very large rounding (16pt).
    var xl: CGFloat { get }

    /// An extra large rounding (20pt).
    var xxl: CGFloat { get }

    /// Fully rounded (9999pt), for buttons and avatars.
    var full: CGFloat { get }
}
