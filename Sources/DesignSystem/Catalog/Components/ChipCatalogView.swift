import SwiftUI

/// Chipコンポーネントのカタログビュー
///
/// Chipコンポーネントの全バリエーション（スタイル、サイズ、状態）を
/// 実例とコードで紹介します。
struct ChipCatalogView: View {
    @Environment(\.colorPalette) private var colors
    @Environment(\.spacingScale) private var spacing

    @State private var isFilter1Selected = false
    @State private var isFilter2Selected = true
    @State private var isFilter3Selected = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: spacing.xxl) {
                // Header
                VStack(alignment: .leading, spacing: spacing.sm) {
                    Text("Chip")
                        .typography(.displaySmall)
                        .foregroundColor(colors.onBackground)

                    Text("コンパクトなラベルコンポーネント。ステータス表示、カテゴリ、フィルター、ユーザー入力など様々な用途で使用できます。")
                        .typography(.bodyLarge)
                        .foregroundColor(colors.onSurfaceVariant)
                }
                .padding(.horizontal, spacing.lg)

                // Style Variants
                sectionCard(title: "スタイルバリアント") {
                    VStack(alignment: .leading, spacing: spacing.lg) {
                        styleVariantRow(
                            title: "Filled",
                            description: "塗りつぶし背景。ステータス、カテゴリラベルに最適"
                        ) {
                            Chip("Active", systemImage: "circle.fill")
                                .chipStyle(.filled)
                                .foregroundColor(.green)

                            Chip("Pending", systemImage: "clock.fill")
                                .chipStyle(.filled)
                                .foregroundColor(.orange)

                            Chip("Error", systemImage: "exclamationmark.triangle.fill")
                                .chipStyle(.filled)
                                .foregroundColor(.red)
                        }

                        Divider()

                        styleVariantRow(
                            title: "Outlined",
                            description: "境界線のみ。フィルター選択、セカンダリカテゴリに最適"
                        ) {
                            Chip("Filter 1", systemImage: "line.3.horizontal.decrease", isSelected: $isFilter1Selected)
                                .chipStyle(.outlined)

                            Chip("Filter 2", systemImage: "tag", isSelected: $isFilter2Selected)
                                .chipStyle(.outlined)

                            Chip("Filter 3", systemImage: "star", isSelected: $isFilter3Selected)
                                .chipStyle(.outlined)
                        }

                        Divider()

                        if #available(iOS 26.0, macOS 26.0, *) {
                            styleVariantRow(
                                title: "Liquid Glass",
                                description: "半透明のガラス効果。プレミアム感のある表現に最適（iOS 26+）"
                            ) {
                                Chip("Premium", systemImage: "star.fill")
                                    .chipStyle(.liquidGlass)
                                    .foregroundColor(.yellow)

                                Chip("Featured", systemImage: "sparkles")
                                    .chipStyle(.liquidGlass)
                                    .foregroundColor(.purple)

                                Chip("New", systemImage: "bell.fill")
                                    .chipStyle(.liquidGlass)
                                    .foregroundColor(.blue)
                            }
                        }
                    }
                }

                // Size Variants
                sectionCard(title: "サイズバリアント") {
                    VStack(alignment: .leading, spacing: spacing.md) {
                        HStack(spacing: spacing.md) {
                            VStack(alignment: .leading, spacing: spacing.xs) {
                                Text("Medium (デフォルト)")
                                    .typography(.labelMedium)
                                    .foregroundColor(colors.onSurfaceVariant)

                                Text("32pt高さ、標準的な用途")
                                    .typography(.bodySmall)
                                    .foregroundColor(colors.onSurfaceVariant.opacity(0.7))
                            }

                            Spacer()

                            Chip("Medium", systemImage: "tag.fill")
                                .chipStyle(.filled)
                                .chipSize(.medium)
                                .foregroundColor(.blue)
                        }

                        Divider()

                        HStack(spacing: spacing.md) {
                            VStack(alignment: .leading, spacing: spacing.xs) {
                                Text("Small")
                                    .typography(.labelMedium)
                                    .foregroundColor(colors.onSurfaceVariant)

                                Text("24pt高さ、密集レイアウト向け")
                                    .typography(.bodySmall)
                                    .foregroundColor(colors.onSurfaceVariant.opacity(0.7))
                            }

                            Spacer()

                            Chip("Small", systemImage: "tag.fill")
                                .chipStyle(.filled)
                                .chipSize(.small)
                                .foregroundColor(.blue)
                        }
                    }
                }

                // Input Chips (Deletable)
                sectionCard(title: "Input Chip（削除可能）") {
                    VStack(alignment: .leading, spacing: spacing.md) {
                        Text("ユーザー入力されたタグやトークンの表示に使用")
                            .typography(.bodyMedium)
                            .foregroundColor(colors.onSurfaceVariant)

                        FlowLayout(spacing: spacing.sm) {
                            Chip("SwiftUI", systemImage: "tag.fill") {
                                print("Delete SwiftUI")
                            }
                            .chipStyle(.filled)
                            .foregroundColor(.blue)

                            Chip("iOS Development") {
                                print("Delete iOS Development")
                            }
                            .chipStyle(.filled)
                            .foregroundColor(.purple)

                            Chip("Design System", systemImage: "paintbrush.fill") {
                                print("Delete Design System")
                            }
                            .chipStyle(.filled)
                            .foregroundColor(.pink)
                        }
                    }
                }

                // Use Cases
                sectionCard(title: "ユースケース") {
                    VStack(alignment: .leading, spacing: spacing.lg) {
                        useCaseRow(title: "ステータス表示") {
                            HStack(spacing: spacing.sm) {
                                Chip("Active", systemImage: "circle.fill")
                                    .chipStyle(.filled)
                                    .chipSize(.small)
                                    .foregroundColor(.green)

                                Chip("In Progress", systemImage: "arrow.circlepath")
                                    .chipStyle(.filled)
                                    .chipSize(.small)
                                    .foregroundColor(.blue)

                                Chip("Completed", systemImage: "checkmark.circle.fill")
                                    .chipStyle(.filled)
                                    .chipSize(.small)
                                    .foregroundColor(.gray)
                            }
                        }

                        Divider()

                        useCaseRow(title: "カテゴリタグ") {
                            FlowLayout(spacing: spacing.xs) {
                                Chip("Technology", systemImage: "laptopcomputer")
                                    .chipStyle(.outlined)
                                    .chipSize(.small)

                                Chip("Design", systemImage: "paintpalette")
                                    .chipStyle(.outlined)
                                    .chipSize(.small)

                                Chip("Business", systemImage: "briefcase")
                                    .chipStyle(.outlined)
                                    .chipSize(.small)

                                Chip("Science", systemImage: "atom")
                                    .chipStyle(.outlined)
                                    .chipSize(.small)
                            }
                        }

                        Divider()

                        useCaseRow(title: "フィルター") {
                            FlowLayout(spacing: spacing.sm) {
                                Chip("All Items", systemImage: "square.grid.2x2", isSelected: .constant(true))
                                    .chipStyle(.outlined)

                                Chip("Favorites", systemImage: "star", isSelected: .constant(false))
                                    .chipStyle(.outlined)

                                Chip("Recent", systemImage: "clock", isSelected: .constant(false))
                                    .chipStyle(.outlined)
                            }
                        }
                    }
                }

                // Best Practices
                sectionCard(title: "ベストプラクティス") {
                    VStack(alignment: .leading, spacing: spacing.md) {
                        BestPracticeItem(
                            icon: "checkmark.circle.fill",
                            title: "適切な用途",
                            description: "ステータス、カテゴリ、フィルター、タグなど、簡潔な情報の表示に使用",
                            isGood: true
                        )

                        BestPracticeItem(
                            icon: "checkmark.circle.fill",
                            title: "明確なラベル",
                            description: "1-2語の短く明確なラベルを使用。長文は避ける",
                            isGood: true
                        )

                        BestPracticeItem(
                            icon: "xmark.circle.fill",
                            title: "過度な使用",
                            description: "画面内のChipが多すぎると視覚的ノイズになる。重要な情報のみに限定",
                            isGood: false
                        )

                        BestPracticeItem(
                            icon: "checkmark.circle.fill",
                            title: "スタイルの一貫性",
                            description: "同じコンテキストでは同じスタイルを使用。Filled/Outlinedを混在させない",
                            isGood: true
                        )
                    }
                }
            }
            .padding(.vertical, spacing.xl)
        }
    }

    // MARK: - Helper Views

    private func sectionCard<Content: View>(
        title: String,
        @ViewBuilder content: () -> Content
    ) -> some View {
        SectionCard(title: title, elevation: .level1) {
            content()
        }
        .padding(.horizontal, spacing.lg)
    }

    private func styleVariantRow<Content: View>(
        title: String,
        description: String,
        @ViewBuilder chips: () -> Content
    ) -> some View {
        VStack(alignment: .leading, spacing: spacing.sm) {
            VStack(alignment: .leading, spacing: spacing.xs) {
                Text(title)
                    .typography(.titleMedium)
                    .foregroundColor(colors.onSurface)

                Text(description)
                    .typography(.bodyMedium)
                    .foregroundColor(colors.onSurfaceVariant)
            }

            HStack(spacing: spacing.sm) {
                chips()
            }
        }
    }

    private func useCaseRow<Content: View>(
        title: String,
        @ViewBuilder content: () -> Content
    ) -> some View {
        VStack(alignment: .leading, spacing: spacing.sm) {
            Text(title)
                .typography(.labelLarge)
                .foregroundColor(colors.onSurface)

            content()
        }
    }
}

// MARK: - Flow Layout

/// チップを水平に並べ、スペースがなくなったら次の行に折り返すレイアウト
private struct FlowLayout: Layout {
    var spacing: CGFloat = 8

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let result = FlowResult(
            in: proposal.replacingUnspecifiedDimensions().width,
            subviews: subviews,
            spacing: spacing
        )
        return result.size
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let result = FlowResult(
            in: bounds.width,
            subviews: subviews,
            spacing: spacing
        )
        for (index, subview) in subviews.enumerated() {
            subview.place(at: CGPoint(x: bounds.minX + result.frames[index].minX, y: bounds.minY + result.frames[index].minY), proposal: .unspecified)
        }
    }

    struct FlowResult {
        var size: CGSize = .zero
        var frames: [CGRect] = []

        init(in maxWidth: CGFloat, subviews: Subviews, spacing: CGFloat) {
            var x: CGFloat = 0
            var y: CGFloat = 0
            var lineHeight: CGFloat = 0

            for subview in subviews {
                let size = subview.sizeThatFits(.unspecified)

                if x + size.width > maxWidth && x > 0 {
                    // New line
                    x = 0
                    y += lineHeight + spacing
                    lineHeight = 0
                }

                frames.append(CGRect(origin: CGPoint(x: x, y: y), size: size))
                lineHeight = max(lineHeight, size.height)
                x += size.width + spacing
            }

            self.size = CGSize(width: maxWidth, height: y + lineHeight)
        }
    }
}

// MARK: - Previews

#Preview {
    ChipCatalogView()
}
