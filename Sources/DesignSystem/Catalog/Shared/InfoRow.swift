import SwiftUI

/// 情報行を表示するビュー
struct InfoRow: View {
    @Environment(\.colorPalette) private var colorPalette
    @Environment(\.spacingScale) private var spacing

    let label: String
    let value: String

    var body: some View {
        HStack {
            Text(label)
                .typography(.bodyMedium)
                .foregroundStyle(colorPalette.onSurface)
            Spacer()
            Text(value)
                .typography(.bodyMedium)
                .foregroundStyle(colorPalette.onSurfaceVariant)
        }
        .padding(.horizontal, spacing.lg)
        .padding(.vertical, 12)
    }
}
