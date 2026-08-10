import SwiftUI

/// A label above a piece of content, for showcasing size or style variations.
struct LabeledVariant<Content: View>: View {
    @Environment(\.colorPalette) private var colors
    @Environment(\.spacingScale) private var spacing

    let label: String
    @ViewBuilder let content: () -> Content

    var body: some View {
        VStack(alignment: .leading, spacing: spacing.xs) {
            Text(label)
                .typography(.labelSmall)
                .foregroundStyle(colors.onSurfaceVariant)
            content()
        }
    }
}
