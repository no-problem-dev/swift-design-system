import SwiftUI

/// The skeleton of a section row.
///
/// Icon dimensions (``IconSizeScale``) and text dimensions (``TypographyScale``) are decided
/// separately, so a row that leaves its size to whatever its contents happen to compose to turns
/// every difference in symbol glyph width into a shift of the leading edge of the label. The
/// skeleton is derived here, and ``SectionRow`` and ``SectionRowLabel`` use the same values, which
/// is what makes rows line up vertically with each other.
struct SectionRowMetrics {
    /// The width of the leading icon column.
    ///
    /// SF Symbol glyph widths differ from symbol to symbol, so the column has a fixed width and the
    /// icon sits centered in it. The value matches the leading ``IconBadge`` of ``LinkCard``
    /// (`.small`, 32pt), which together with the horizontal padding of the row places the leading
    /// edge of the label at 56pt.
    let iconColumnWidth: CGFloat

    /// The gap between the icon column and the label.
    ///
    /// The same value as ``LinkCard``.
    let iconGap: CGFloat

    /// The glyph size of the leading icon.
    ///
    /// It is one step smaller than the column so that even wide symbols stay inside it.
    let iconGlyphSize: CGFloat

    /// The minimum height of a row.
    ///
    /// It keeps a row that holds only small text from falling below the minimum tap target.
    let minHeight: CGFloat

    /// - Parameter typeScale: The Dynamic Type multiplier of body text. Tokens that come from the
    ///   environment cannot serve as the base value of `@ScaledMetric`, so the metrics take the
    ///   multiplier alone and apply it themselves
    init(iconSize: any IconSizeScale, spacing: any SpacingScale, typeScale: CGFloat) {
        iconColumnWidth = iconSize.lg * typeScale
        iconGap = spacing.sm
        iconGlyphSize = iconSize.sm * typeScale
        // Never let the row fall below 44pt, even at settings that shrink text
        minHeight = ControlTokens.minTouchTarget * max(1, typeScale)
    }
}

/// The style that fixes the leading icon column, handed by a section row to the `Label` values
/// inside it.
///
/// A row pushes this style down its own subtree so that the skeleton takes effect on existing code
/// written as `SectionRow { Label(...) }` without rewriting it.
struct SectionRowLabelStyle: LabelStyle {
    let metrics: SectionRowMetrics

    func makeBody(configuration: Configuration) -> some View {
        HStack(spacing: metrics.iconGap) {
            configuration.icon
                .frame(width: metrics.iconColumnWidth)
            configuration.title
        }
    }
}
