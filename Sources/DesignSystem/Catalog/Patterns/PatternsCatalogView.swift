import SwiftUI

/// パターンカタログのエントリポイント
/// レイアウトパターンやデザインパターンを表示
struct PatternsCatalogView: View {
    @Environment(\.colorPalette) private var colors
    @Environment(\.spacingScale) private var spacing
    @Environment(\.radiusScale) private var radius

    var body: some View {
        ScrollView {
            VStack(spacing: spacing.xl) {
                // ヘッダー
                VStack(spacing: spacing.sm) {
                    Image(systemName: "square.grid.3x3.fill")
                        .font(.system(size: 48))
                        .foregroundStyle(colors.primary)

                    Text("パターンカタログ")
                        .typography(.headlineLarge)
                        .foregroundStyle(colors.onBackground)

                    Text("レイアウトパターンやデザインパターン")
                        .typography(.bodySmall)
                        .foregroundStyle(colors.onSurfaceVariant)
                }
                .frame(maxWidth: .infinity)
                .padding(.top, spacing.xl)

                // パターンリスト
                VStack(alignment: .leading, spacing: spacing.md) {
                    Text("レイアウトパターン")
                        .typography(.titleMedium)
                        .foregroundStyle(colors.onSurface)
                        .padding(.horizontal, spacing.lg)

                    VStack(spacing: spacing.sm) {
                        patternLink(
                            destination: AspectGridCatalogView(),
                            icon: "square.grid.2x2.fill",
                            title: "AspectGrid",
                            description: "アスペクト比固定グリッドレイアウト"
                        )

                        patternLink(
                            destination: SectionCardCatalogView(),
                            icon: "rectangle.fill.on.rectangle.fill",
                            title: "SectionCard",
                            description: "タイトル付きセクションコンテナ"
                        )
                    }
                    .padding(.horizontal, spacing.lg)
                }
            }
            .padding(.bottom, spacing.xl)
        }
        .background(colors.background)
        .navigationTitle("パターン")
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
    }

    @ViewBuilder
    private func patternLink<Destination: View>(
        destination: Destination,
        icon: String,
        title: String,
        description: String
    ) -> some View {
        NavigationLink {
            destination
        } label: {
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

                Image(systemName: "chevron.right")
                    .typography(.labelSmall)
                    .foregroundStyle(colors.onSurfaceVariant)
            }
            .padding(.horizontal, spacing.lg)
            .padding(.vertical, spacing.md)
            .background(colors.surface)
            .clipShape(RoundedRectangle(cornerRadius: radius.md))
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    NavigationStack {
        PatternsCatalogView()
            .theme(ThemeProvider())
    }
}
