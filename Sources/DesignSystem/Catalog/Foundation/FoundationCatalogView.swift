import SwiftUI

/// Entry point for the design token catalog.
struct FoundationCatalogView: View {
    @Environment(\.colorPalette) private var colors
    @Environment(\.spacingScale) private var spacing

    var body: some View {
        ScrollView {
            VStack(spacing: spacing.xl) {
                // Header
                VStack(spacing: spacing.sm) {
                    Image(systemName: "slider.horizontal.3")
                        .font(.system(size: 48))
                        .foregroundStyle(colors.primary)

                    Text("デザイントークン")
                        .typography(.headlineLarge)
                        .foregroundStyle(colors.onBackground)

                    Text("Color, Typography, Spacing, Radius, Motion")
                        .typography(.bodySmall)
                        .foregroundStyle(colors.onSurfaceVariant)
                }
                .frame(maxWidth: .infinity)
                .padding(.top, spacing.xl)

                // Token list
                VStack(alignment: .leading, spacing: spacing.md) {
                    Text("トークン")
                        .typography(.titleMedium)
                        .foregroundStyle(colors.onSurface)
                        .padding(.horizontal, spacing.lg)

                    VStack(spacing: spacing.sm) {
                        ForEach(FoundationItem.allCases) { item in
                            NavigationLink {
                                destinationView(for: item)
                            } label: {
                                CatalogItemRowContent(
                                    icon: item.icon,
                                    title: item.rawValue,
                                    description: item.description
                                )
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.horizontal, spacing.lg)
                }
            }
            .padding(.bottom, spacing.xl)
        }
        .background(colors.background)
        .navigationTitle("デザイントークン")
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
    }

    @ViewBuilder
    private func destinationView(for item: FoundationItem) -> some View {
        switch item {
        case .colors:
            ColorsCatalogView()
        case .typography:
            TypographyCatalogView()
        case .spacing:
            SpacingCatalogView()
        case .radius:
            RadiusCatalogView()
        case .motion:
            MotionCatalogView()
        }
    }
}

#Preview {
    NavigationStack {
        FoundationCatalogView()
            .theme(ThemeProvider())
    }
}
