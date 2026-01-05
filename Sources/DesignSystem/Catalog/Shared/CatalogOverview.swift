import SwiftUI

/// カタログ概要セクション
struct CatalogOverview: View {
    @Environment(\.colorPalette) private var colors
    @Environment(\.spacingScale) private var spacing

    let description: String

    var body: some View {
        Text(description)
            .typography(.bodyMedium)
            .foregroundStyle(colors.onSurfaceVariant)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, spacing.lg)
    }
}
