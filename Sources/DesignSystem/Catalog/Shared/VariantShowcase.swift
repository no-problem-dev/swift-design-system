import SwiftUI

/// バリエーション展示コンポーネント
struct VariantShowcase<Content: View>: View {
    @Environment(\.colorPalette) private var colors
    @Environment(\.spacingScale) private var spacing

    let title: String
    var description: String? = nil
    @ViewBuilder let content: () -> Content

    var body: some View {
        VStack(alignment: .leading, spacing: spacing.sm) {
            VStack(alignment: .leading, spacing: spacing.xs) {
                Text(title)
                    .typography(.titleSmall)
                    .foregroundStyle(colors.onSurface)

                if let description {
                    Text(description)
                        .typography(.bodySmall)
                        .foregroundStyle(colors.onSurfaceVariant)
                }
            }

            content()
        }
    }
}
