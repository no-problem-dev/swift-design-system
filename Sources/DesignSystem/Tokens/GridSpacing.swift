import Foundation

/// The gutter between the items of a grid layout.
///
/// Keeps the spacing between grid items consistent across the app. The steps follow the
/// Material Design 3 and Fluent 2 guidelines, so each one suits a different screen size
/// or context.
///
/// ## Example
/// ```swift
/// AspectGrid(
///     minItemWidth: 160,
///     maxItemWidth: 200,
///     itemAspectRatio: 2/3,
///     spacing: .md  // The default gutter
/// ) {
///     // Content
/// }
/// ```
///
/// ## Design guidelines
/// - Material Design 3: 16-24dp gutters
/// - Fluent 2: 8-16px gutters
/// - Apple HIG: 8-20pt spacing
/// - Follows an 8pt grid system
public enum GridSpacing: CGFloat, Sendable {
    /// The smallest gutter (8pt).
    ///
    /// Suits a dense layout or small items.
    ///
    /// ## Example
    /// - Icon grids
    /// - Tag lists
    /// - Compact thumbnails
    case xs = 8

    /// A small gutter (12pt).
    ///
    /// Suits a compact layout.
    ///
    /// ## Example
    /// - Compact card grids
    /// - Thumbnail lists
    /// - Dense galleries
    case sm = 12

    /// The standard gutter (16pt).
    ///
    /// The default, and the right choice for most grid layouts.
    ///
    /// ## Example
    /// - Book covers
    /// - Product lists
    /// - Photo grids
    case md = 16

    /// A large gutter (20pt).
    ///
    /// Suits a roomier layout.
    ///
    /// ## Example
    /// - Regular card grids
    /// - Media galleries
    /// - Featured content
    case lg = 20

    /// The largest gutter (24pt).
    ///
    /// Suits a very roomy layout or large items.
    ///
    /// ## Example
    /// - Hero cards
    /// - Feature grids
    /// - Premium content
    case xl = 24

    public var value: CGFloat {
        self.rawValue
    }
}
