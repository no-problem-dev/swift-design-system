import SwiftUI

/// A 0.5pt hairline inserted between rows inside a `SectionCard`.
///
/// It uses the `outlineVariant` color, a translucent form of `outline`, to divide rows quietly
/// on the surface of the card. A `spacing.lg` inset on the leading side gives it the same visual
/// balance as a List separator.
///
/// ## Example
/// ```swift
/// SectionCard("Settings") {
///     SectionRow { Text("Item 1") }
///     SectionRowDivider()
///     SectionRow { Text("Item 2") }
/// }
/// ```
public struct SectionRowDivider: View {
    @Environment(\.colorPalette) private var colors
    @Environment(\.spacingScale) private var spacing

    public init() {}

    public var body: some View {
        Rectangle()
            .fill(colors.outlineVariant)
            .frame(height: 0.5)
            .padding(.leading, spacing.lg)
    }
}
