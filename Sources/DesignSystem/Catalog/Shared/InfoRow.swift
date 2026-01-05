import SwiftUI

/// 情報行を表示するビュー
struct InfoRow: View {
    @Environment(\.colorPalette) private var colors
    @Environment(\.spacingScale) private var spacing

    let label: String
    let value: String

    var body: some View {
        HStack {
            Text(label)
                .typography(.bodyMedium)
                .foregroundStyle(colors.onSurface)
            Spacer()
            Text(value)
                .typography(.bodyMedium)
                .foregroundStyle(colors.onSurfaceVariant)
        }
        .padding(.horizontal, spacing.lg)
        .padding(.vertical, spacing.md)
    }
}
