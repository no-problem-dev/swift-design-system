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
                VStack(spacing: spacing.xxl) {
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

                            Text(category.description)
                                .typography(.bodySmall)
                                .foregroundStyle(colorPalette.onSurfaceVariant)

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
                                        .padding(.horizontal, spacing.md)
                                        .padding(.vertical, spacing.md)
                                        .background(colorPalette.background)
                                        .clipShape(RoundedRectangle(cornerRadius: 8))
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                        }
                        .padding(spacing.lg)
                        .background(colorPalette.surface)
                        .shadow(color: .black.opacity(0.03), radius: 4, y: 2)
                    }

                    // 情報セクション
                    VStack(alignment: .leading, spacing: 12) {
                        Text("情報")
                            .typography(.titleMedium)
                            .foregroundStyle(colorPalette.onSurface)
                            .padding(.horizontal, spacing.lg)

                        VStack(spacing: 0) {
                            InfoRow(label: "プラットフォーム", value: "iOS 17+, macOS 14+")
                            Divider().padding(.leading, 16)
                            InfoLinkRow(
                                label: "リポジトリ",
                                value: "GitHub",
                                url: "https://github.com/no-problem-dev/swift-design-system"
                            )
                            Divider().padding(.leading, 16)
                            InfoLinkRow(
                                label: "ドキュメント",
                                value: "DocC",
                                url: "https://no-problem-dev.github.io/swift-design-system/documentation/designsystem/"
                            )
                        }
                        .background(colorPalette.surface)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .shadow(color: .black.opacity(0.03), radius: 4, y: 2)
                        .padding(.horizontal, spacing.lg)
                    }
                }
                .padding(.top, spacing.lg)
                .padding(.bottom, spacing.xl)
            }
            .background(colorPalette.background)
            .navigationTitle("デザインシステムカタログ")
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
            case "モーション":
                MotionCatalogView()
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

private struct InfoLinkRow: View {
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
                        .font(.caption)
                }
                .foregroundStyle(colorPalette.primary)
            }
        }
        .padding(.horizontal, spacing.lg)
        .padding(.vertical, 12)
    }
}

#Preview {
    DesignSystemCatalogView()
        .theme(ThemeProvider())
}
