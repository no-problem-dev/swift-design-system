import SwiftUI

/// The type ramp a theme supplies.
///
/// It maps a role, ``Typography``, to a resolved style, ``TypeStyle``. Putting the values
/// on the theme is what lets a brand substitute its own type: a call such as
/// `.typography(.bodyMedium)` stays as it is, and the resolution happens through the
/// environment.
///
/// The ``Typography`` enum remains the role selector, so existing call sites do not change.
public protocol TypographyScale: Sendable {
    func style(for role: Typography) -> TypeStyle
}

/// A type style resolved from a role.
///
/// Size and leading are kept apart so that a CJK-oriented ramp, such as 16pt body text at a
/// leading of 1.5, can be expressed.
public struct TypeStyle: Sendable, Equatable {
    /// The font size, in points.
    public var size: CGFloat
    public var weight: Font.Weight
    /// The leading, as a multiple of the font size.
    ///
    /// Line height divided by size. 1.5 is the usual value for Japanese text.
    public var leadingMultiplier: CGFloat
    /// The tracking, in em. Usually nil for Japanese text.
    public var trackingEm: CGFloat?
    /// Where the typeface comes from. Defaults to the system font.
    public var fontResource: FontResource

    public init(
        size: CGFloat,
        weight: Font.Weight,
        leadingMultiplier: CGFloat,
        trackingEm: CGFloat? = nil,
        fontResource: FontResource = .system
    ) {
        self.size = size
        self.weight = weight
        self.leadingMultiplier = leadingMultiplier
        self.trackingEm = trackingEm
        self.fontResource = fontResource
    }

    /// The effective line height, in points.
    public var lineHeight: CGFloat { size * leadingMultiplier }

    public func font(design: Font.Design? = nil) -> Font {
        fontResource.font(size: size, weight: weight, design: design)
    }
}

/// Where a typeface comes from.
///
/// A typeface can be named without being bundled, which keeps font licensing out of the way
/// when the package is distributed.
public enum FontResource: Sendable, Equatable {
    /// Defers to the system font. No typeface is bundled, and this is the default.
    case system
    /// A typeface referred to by name.
    ///
    /// **This package does not bundle any font files.** The named typeface is used if the
    /// host app has it, and the system font is used if it does not.
    case named(String)

    public func font(size: CGFloat, weight: Font.Weight, design: Font.Design?) -> Font {
        switch self {
        case .system:
            return .system(size: size, weight: weight, design: design ?? .default)
        case let .named(name):
            return .custom(name, size: size).weight(weight)
        }
    }
}

/// The type ramp used when a theme does not supply its own.
///
/// The values are derived from the ``Typography`` enum, so text looks the same whether or
/// not a theme is applied.
public struct DefaultTypographyScale: TypographyScale {
    public init() {}

    public func style(for role: Typography) -> TypeStyle {
        TypeStyle(
            size: role.size,
            weight: role.weight,
            leadingMultiplier: role.size > 0 ? role.lineHeight / role.size : 1,
            fontResource: .system
        )
    }
}
