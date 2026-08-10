import SwiftUI

/// A single row inside a `SectionCard`.
///
/// An HStack that supplies uniform horizontal and vertical padding together with the skeleton of
/// the row: its minimum height and the width of the leading icon column. Use it as the label of a
/// Button or NavigationLink to keep card style list rows looking alike. `contentShape(Rectangle())`
/// is applied, so taps on the padding register too.
///
/// ## Example
/// ```swift
/// SectionRow {
///     SectionRowLabel("Notifications", systemImage: "bell")
///     Spacer(minLength: 0)
///     Toggle("", isOn: $isOn).labelsHidden()
/// }
/// ```
///
/// ## Aligning across rows
/// Putting a ``SectionRowLabel`` first keeps the leading edge of every label on the same vertical
/// line whether or not the row has an icon. Placing a `Label` directly still fixes the width of the
/// icon column, but rows without an icon leave the column out, so their leading edges do not line
/// up. Use ``SectionRowLabel`` for rows that need to align.
public struct SectionRow<Content: View>: View {
    @Environment(\.iconSizeScale) private var iconSize
    @Environment(\.spacingScale) private var spacing
    @ScaledMetric(relativeTo: .body) private var typeScale: CGFloat = 1

    private let content: () -> Content

    /// Creates a single row inside a section.
    ///
    /// - Parameter content: The contents of the row. They are laid out from the leading edge like
    ///   an HStack.
    public init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }

    public var body: some View {
        let metrics = SectionRowMetrics(iconSize: iconSize, spacing: spacing, typeScale: typeScale)
        HStack(spacing: spacing.md) {
            content()
        }
        .labelStyle(SectionRowLabelStyle(metrics: metrics))
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, spacing.lg)
        .padding(.vertical, spacing.md)
        // Apply the minimum height outside the padding. Inside, the row grows by the padding on top
        .frame(minHeight: metrics.minHeight)
        .contentShape(Rectangle())
    }
}
