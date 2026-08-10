import SwiftUI

public extension View {
    /// Applies a typography token.
    ///
    /// Passing a role (``Typography``) applies the size, weight, line height, and typeface
    /// resolved by the ``TypographyScale`` in the environment. A theme can swap the scale to move
    /// to a brand specific type set; with no theme applied, ``DefaultTypographyScale`` keeps the
    /// built-in appearance.
    ///
    /// The size grows and shrinks with Dynamic Type, relative to ``Typography/relativeTextStyle``.
    /// Line spacing and tracking are derived from that same size, so the glyphs never grow while
    /// the lines stay cramped.
    ///
    /// Resolving the scale requires an environment lookup, so the content is wrapped in the
    /// lightweight view `TypographyStyledView`. A `ViewModifier` is not used because its
    /// `body(content:)` becomes `@MainActor` isolated, which raises a "non-Sendable result" error
    /// when called from a Sendable closure such as `PhotosPicker`. Building a view is itself
    /// nonisolated, so it is safe inside a Sendable closure.
    ///
    /// ```swift
    /// Text("Heading").typography(.headlineLarge)
    /// Text("Heading").typography(.headlineLarge, design: .serif)
    /// ```
    func typography(_ token: Typography, design: Font.Design? = nil) -> some View {
        TypographyStyledView(role: token, design: design, content: self)
    }
}

/// Resolves a typography role against the scale in the environment and applies it to the content.
private struct TypographyStyledView<Content: View>: View {
    let role: Typography
    let design: Font.Design?
    let content: Content
    @Environment(\.typographyScale) private var scale

    var body: some View {
        ScaledTypographyView(
            style: scale.style(for: role),
            textStyle: role.relativeTextStyle,
            design: design,
            content: content
        )
    }
}

/// Applies the Dynamic Type multiplier to an already resolved type style.
///
/// `@ScaledMetric` takes its base value and its relative text style in `init`, but the base value
/// is resolved from the ``TypographyScale`` in the environment, which only the parent can read.
/// That is why resolution and scaling are split between a parent and a child.
///
/// The multiplier is applied the same way for `.system` and for `.named` (brand typefaces).
/// Leaving it to `relativeTo:` on `Font.custom` is not an option: `.system` has no equivalent, and
/// the actual size needed to recompute line spacing and tracking would not be available here.
private struct ScaledTypographyView<Content: View>: View {
    private let style: TypeStyle
    private let design: Font.Design?
    private let content: Content
    @ScaledMetric private var size: CGFloat

    init(style: TypeStyle, textStyle: Font.TextStyle, design: Font.Design?, content: Content) {
        self.style = style
        self.design = design
        self.content = content
        _size = ScaledMetric(wrappedValue: style.size, relativeTo: textStyle)
    }

    var body: some View {
        content
            .font(style.fontResource.font(size: size, weight: style.weight, design: design))
            .lineSpacing(max(0, size * style.leadingMultiplier - size))
            .tracking((style.trackingEm ?? 0) * size)
    }
}
