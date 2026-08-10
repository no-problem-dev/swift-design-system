import SwiftUI

/// A single theme card in the theme gallery.
///
/// Shows the theme name, its description, and a row of preview colors.
struct ThemeCardView: View {
    @Environment(\.colorPalette) private var colors
    @Environment(\.spacingScale) private var spacing
    @Environment(\.radiusScale) private var radius

    let theme: any Theme
    let isActive: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: spacing.sm) {
                // Header (name and active marker)
                HStack {
                    Text(theme.name)
                        .typography(.titleSmall)
                        .foregroundStyle(colors.onSurface)

                    Spacer()

                    if isActive {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundStyle(colors.primary)
                            .font(.title3)
                    }
                }

                // Preview color dots
                HStack(spacing: spacing.sm) {
                    ForEach(0 ..< min(theme.previewColors.count, 5), id: \.self) { index in
                        Circle()
                            .fill(theme.previewColors[index])
                            .frame(width: 24, height: 24)
                            .overlay(
                                Circle()
                                    .strokeBorder(colors.outline, lineWidth: 1)
                            )
                    }
                }

                // Description
                Text(theme.description)
                    .typography(.bodySmall)
                    .foregroundStyle(colors.onSurfaceVariant)
                    .lineLimit(2)
            }
            .padding(spacing.md)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(colors.surface)
            .overlay(
                RoundedRectangle(cornerRadius: radius.lg)
                    .strokeBorder(
                        isActive ? colors.primary : colors.outline,
                        lineWidth: isActive ? 2 : 1
                    )
            )
            .clipShape(RoundedRectangle(cornerRadius: radius.lg))
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    @Previewable @State var themeProvider = ThemeProvider()

    VStack(spacing: 16) {
        ThemeCardView(
            theme: DefaultTheme(),
            isActive: true,
            onTap: {}
        )

        ThemeCardView(
            theme: OceanTheme(),
            isActive: false,
            onTap: {}
        )
    }
    .padding()
    .theme(themeProvider)
}
