import Foundation

/// The spacing values a theme supplies for padding and for gaps between elements.
///
/// The steps are named after T-shirt sizes (xs, sm, md, lg, xl, and so on) so that they
/// read at a glance.
///
/// ## Example
/// ```swift
/// @Environment(\.spacingScale) var spacing
///
/// VStack(spacing: spacing.lg) {  // A 16pt gap
///     Text("Title")
///     Text("Subtitle")
/// }
/// .padding(spacing.xl)  // 24pt of padding
/// ```
///
/// ## The scale
/// - `none`: 0pt - no gap
/// - `xxs`: 2pt - the smallest gap
/// - `xs`: 4pt - a very small gap
/// - `sm`: 8pt - a small gap
/// - `md`: 12pt - a medium gap
/// - `lg`: 16pt - the standard gap (recommended default)
/// - `xl`: 24pt - a large gap
/// - `xxl`: 32pt - a very large gap
/// - `xxxl`: 48pt - an extra large gap
/// - `xxxxl`: 64pt - the largest gap
public protocol SpacingScale: Sendable {
    /// No gap (0pt).
    var none: CGFloat { get }

    /// The smallest gap (2pt).
    var xxs: CGFloat { get }

    /// A very small gap (4pt).
    var xs: CGFloat { get }

    /// A small gap (8pt).
    var sm: CGFloat { get }

    /// A medium gap (12pt).
    var md: CGFloat { get }

    /// The standard gap (16pt), the recommended default.
    var lg: CGFloat { get }

    /// A large gap (24pt).
    var xl: CGFloat { get }

    /// A very large gap (32pt).
    var xxl: CGFloat { get }

    /// An extra large gap (48pt).
    var xxxl: CGFloat { get }

    /// The largest gap (64pt).
    var xxxxl: CGFloat { get }
}
