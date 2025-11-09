import SwiftUI

/// リンク付き情報行を表示するビュー
struct InfoLinkRow: View {
    @Environment(\.colorPalette) private var colorPalette
    @Environment(\.spacingScale) private var spacing

    let label: String
    let value: String
    let url: String

    var body: some View {
        HStack {
            Text(label)
                .typography(.bodyMedium)
                .foregroundStyle(colorPalette.onSurface)
            Spacer()
            Link(destination: URL(string: url)!) {
                HStack(spacing: 4) {
                    Text(value)
                        .typography(.bodyMedium)
                    Image(systemName: "arrow.up.right.square")
                        .typography(.labelMedium)
                }
                .foregroundStyle(colorPalette.primary)
            }
        }
        .padding(.horizontal, spacing.lg)
        .padding(.vertical, 12)
    }
}
