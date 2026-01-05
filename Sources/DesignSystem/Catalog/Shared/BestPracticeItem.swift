import SwiftUI

/// ベストプラクティス項目を表示するビュー
struct BestPracticeItem: View {
    @Environment(\.colorPalette) private var colors
    @Environment(\.spacingScale) private var spacing

    let icon: String
    let title: String
    let description: String
    let isGood: Bool

    var body: some View {
        HStack(alignment: .top, spacing: spacing.md) {
            Image(systemName: icon)
                .foregroundStyle(isGood ? colors.success : colors.error)
                .typography(.titleSmall)

            VStack(alignment: .leading, spacing: spacing.xs) {
                Text(title)
                    .typography(.bodyMedium)
                    .foregroundStyle(colors.onSurface)

                Text(description)
                    .typography(.bodySmall)
                    .foregroundStyle(colors.onSurfaceVariant)
            }
        }
    }
}
