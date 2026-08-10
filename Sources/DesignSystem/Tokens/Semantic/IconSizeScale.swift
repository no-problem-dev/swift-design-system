import Foundation

/// The display sizes for SF Symbols, emoji, and images.
///
/// This is a separate scale from `Typography` (text) and `SpacingScale` (padding) on
/// purpose: an icon size measures a visual element, so it follows neither a line height
/// nor a margin.
///
/// ## Example
/// ```swift
/// @Environment(\.iconSizeScale) var iconSize
///
/// Image(systemName: "checkmark")
///     .iconSize(.sm)          // An inline icon alongside body text
///
/// Image(systemName: "star.fill")
///     .iconSize(.lg)          // A section header icon
///
/// Image(systemName: "sparkles")
///     .iconSize(.xl)          // A hero icon (onboarding, empty state)
/// ```
///
/// ## The scale
/// - `xxs`: 8pt - a very small badge
/// - `xs`: 12pt - badge indicator / decoration
/// - `sm`: 16pt - an inline icon alongside body text
/// - `md`: 24pt - the standard icon (recommended default)
/// - `lg`: 32pt - subheadings and category icons
/// - `xl`: 48pt - a hero icon (section header / empty state)
/// - `xxl`: 64pt - a display icon (onboarding welcome and the like)
public protocol IconSizeScale: Sendable {
    /// An extra small icon (8pt).
    var xxs: CGFloat { get }

    /// A very small icon (12pt).
    var xs: CGFloat { get }

    /// A small icon (16pt), sized to sit inline with body text.
    var sm: CGFloat { get }

    /// A medium icon (24pt), the standard size.
    var md: CGFloat { get }

    /// A large icon (32pt).
    var lg: CGFloat { get }

    /// An extra large icon (48pt), for hero use.
    var xl: CGFloat { get }

    /// The largest icon (64pt), for display use.
    var xxl: CGFloat { get }
}
