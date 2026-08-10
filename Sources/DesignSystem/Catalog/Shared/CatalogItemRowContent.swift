import SwiftUI

/// Row content shared by the iPhone list view and the iPad content view.
struct CatalogItemRowContent: View {
    @Environment(\.colorPalette) private var colors
    @Environment(\.spacingScale) private var spacing
    @Environment(\.radiusScale) private var radius

    let icon: String
    let title: String
    let description: String
    let isSelected: Bool
    let showChevron: Bool

    init(
        icon: String,
        title: String,
        description: String,
        isSelected: Bool = false,
        showChevron: Bool = true
    ) {
        self.icon = icon
        self.title = title
        self.description = description
        self.isSelected = isSelected
        self.showChevron = showChevron
    }

    var body: some View {
        HStack(spacing: spacing.md) {
            Image(systemName: icon)
                .typography(.titleSmall)
                .foregroundStyle(colors.primary)
                .frame(width: 32)

            VStack(alignment: .leading, spacing: spacing.xs) {
                Text(title)
                    .typography(.bodyLarge)
                    .foregroundStyle(colors.onSurface)

                Text(description)
                    .typography(.bodySmall)
                    .foregroundStyle(colors.onSurfaceVariant)
            }

            Spacer()

            if isSelected {
                Image(systemName: "checkmark")
                    .typography(.labelMedium)
                    .foregroundStyle(colors.primary)
            } else if showChevron {
                Image(systemName: "chevron.right")
                    .typography(.labelSmall)
                    .foregroundStyle(colors.onSurfaceVariant)
            }
        }
        .padding(.horizontal, spacing.md)
        .padding(.vertical, spacing.md)
        .background(isSelected ? colors.primaryContainer : colors.surface)
        .clipShape(RoundedRectangle(cornerRadius: radius.md))
    }
}
