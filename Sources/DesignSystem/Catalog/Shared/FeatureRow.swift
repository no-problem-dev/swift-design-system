import SwiftUI

/// 機能行を表示するビュー
struct FeatureRow: View {
    @Environment(\.colorPalette) private var colors
    @Environment(\.spacingScale) private var spacing

    let icon: String
    let title: String

    var body: some View {
        HStack(spacing: spacing.sm) {
            Image(systemName: icon)
                .foregroundStyle(colors.primary)

            Text(title)
                .typography(.bodyMedium)
                .foregroundStyle(colors.onSurface)
        }
    }
}
