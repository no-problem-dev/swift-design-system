import SwiftUI

/// デザインシステムカタログのエントリポイント
/// デザインシステムの全要素を階層的に表示
public struct DesignSystemCatalogView: View {
    @Environment(ThemeProvider.self) private var themeProvider
    @Environment(\.colorPalette) private var colorPalette
    @Environment(\.spacingScale) private var spacing

    public init() {}

    public var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: spacing.xl) {
                    // ヘッダー
                    VStack(spacing: spacing.sm) {
                        Image(systemName: "swatchpalette")
                            .font(.system(size: 48))
                            .foregroundStyle(colorPalette.primary)

                        Text("デザインシステムカタログ")
                            .typography(.headlineLarge)
                            .foregroundStyle(colorPalette.onBackground)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.top, spacing.xl)

                    // カテゴリセクション
                    ForEach(CatalogCategory.allCases) { category in
                        VStack(alignment: .leading, spacing: spacing.md) {
                            HStack(spacing: spacing.sm) {
                                Image(systemName: category.icon)
                                    .font(.title3)
                                    .foregroundStyle(colorPalette.primary)

                                Text(category.rawValue)
                                    .typography(.titleMedium)
                                    .foregroundStyle(colorPalette.onSurface)
                            }
                            .padding(.horizontal, spacing.lg)

                            Text(category.description)
                                .typography(.bodySmall)
                                .foregroundStyle(colorPalette.onSurfaceVariant)
                                .padding(.horizontal, spacing.lg)

                            VStack(spacing: spacing.sm) {
                                ForEach(category.items) { item in
                                    NavigationLink {
                                        destinationView(for: category, item: item)
                                    } label: {
                                        HStack(spacing: spacing.md) {
                                            Image(systemName: item.icon)
                                                .font(.title3)
                                                .foregroundStyle(colorPalette.primary)
                                                .frame(width: 32)

                                            VStack(alignment: .leading, spacing: 2) {
                                                Text(item.name)
                                                    .typography(.bodyLarge)
                                                    .foregroundStyle(colorPalette.onSurface)

                                                Text(item.description)
                                                    .typography(.bodySmall)
                                                    .foregroundStyle(colorPalette.onSurfaceVariant)
                                            }

                                            Spacer()

                                            Image(systemName: "chevron.right")
                                                .font(.caption)
                                                .foregroundStyle(colorPalette.onSurfaceVariant)
                                        }
                                        .padding(.horizontal, spacing.lg)
                                        .padding(.vertical, spacing.md)
                                        .background(colorPalette.surface)
                                        .clipShape(RoundedRectangle(cornerRadius: 12))
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                            .padding(.horizontal, spacing.lg)
                        }
                    }

                    // 情報セクション
                    VStack(alignment: .leading, spacing: 12) {
                        Text("情報")
                            .typography(.titleMedium)
                            .foregroundStyle(colorPalette.onSurface)
                            .padding(.horizontal, spacing.lg)

                        VStack(spacing: 0) {
                            InfoRow(label: "バージョン", value: "1.0.0")
                            Divider().padding(.leading, 16)
                            InfoRow(label: "プラットフォーム", value: "iOS 17+, macOS 14+")
                            Divider().padding(.leading, 16)
                            InfoRow(label: "デザインシステム", value: "Material Design 3 + Tailwind CSS")
                        }
                        .background(colorPalette.surface)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .padding(.horizontal, spacing.lg)
                    }
                }
                .padding(.bottom, spacing.xl)
            }
            .background(colorPalette.background)
            .navigationTitle("デザインシステム")
            #if os(iOS)
            .navigationBarTitleDisplayMode(.large)
            #endif
        }
    }

    @ViewBuilder
    private func destinationView(for category: CatalogCategory, item: CatalogItem) -> some View {
        switch category {
        case .themes:
            ThemeGalleryView()
        case .foundations:
            switch item.name {
            case "カラー":
                ColorsCatalogView()
            case "スペーシング":
                SpacingCatalogView()
            case "角丸":
                RadiusCatalogView()
            default:
                EmptyView()
            }
        case .components:
            ComponentsCatalogView()
        case .patterns:
            PatternsCatalogView()
        }
    }
}

// MARK: - Helper Views

private struct InfoRow: View {
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

#Preview {
    DesignSystemCatalogView()
        .theme(ThemeProvider())
}
