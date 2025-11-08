import SwiftUI

/// パターンカタログのエントリポイント
/// レイアウトパターンやデザインパターンを表示
struct PatternsCatalogView: View {
    @Environment(\.colorPalette) private var colorPalette
    @Environment(\.spacingScale) private var spacing

    var body: some View {
        ScrollView {
            VStack(spacing: spacing.xl) {
                // ヘッダー
                VStack(spacing: spacing.sm) {
                    Image(systemName: "square.grid.3x3.fill")
                        .font(.system(size: 48))
                        .foregroundStyle(colorPalette.primary)

                    Text("パターンカタログ")
                        .typography(.headlineLarge)
                        .foregroundStyle(colorPalette.onBackground)

                    Text("レイアウトパターンやデザインパターン")
                        .typography(.bodySmall)
                        .foregroundStyle(colorPalette.onSurfaceVariant)
                }
                .frame(maxWidth: .infinity)
                .padding(.top, spacing.xl)

                // パターンリスト
                VStack(alignment: .leading, spacing: spacing.md) {
                    Text("レイアウトパターン")
                        .typography(.titleMedium)
                        .foregroundStyle(colorPalette.onSurface)
                        .padding(.horizontal, spacing.lg)

                    VStack(spacing: spacing.sm) {
                        NavigationLink {
                            SectionCardCatalogView()
                        } label: {
                            HStack(spacing: spacing.md) {
                                Image(systemName: "rectangle.fill.on.rectangle.fill")
                                    .font(.title3)
                                    .foregroundStyle(colorPalette.primary)
                                    .frame(width: 32)

                                VStack(alignment: .leading, spacing: 2) {
                                    Text("SectionCard")
                                        .typography(.bodyLarge)
                                        .foregroundStyle(colorPalette.onSurface)

                                    Text("タイトル付きセクションコンテナ")
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
                    .padding(.horizontal, spacing.lg)
                }
            }
            .padding(.bottom, spacing.xl)
        }
        .background(colorPalette.background)
        .navigationTitle("パターン")
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
    }
}

#Preview {
    NavigationStack {
        PatternsCatalogView()
            .theme(ThemeProvider())
    }
}
