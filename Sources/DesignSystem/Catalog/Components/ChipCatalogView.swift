import SwiftUI

/// Chipコンポーネントのカタログビュー
struct ChipCatalogView: View {
    @Environment(\.colorPalette) private var colors
    @Environment(\.spacingScale) private var spacing

    @State private var isFilter1Selected = false
    @State private var isFilter2Selected = true
    @State private var isFilter3Selected = false

    var body: some View {
        CatalogPageContainer(title: "Chip") {
            CatalogOverview(description: "コンパクトなラベルコンポーネント。ステータス、カテゴリ、フィルターなど様々な用途に使用。")

            SectionCard(title: "スタイル") {
                VStack(alignment: .leading, spacing: spacing.lg) {
                    VariantShowcase(title: "Filled", description: "ステータス、カテゴリラベルに最適") {
                        HStack(spacing: spacing.sm) {
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
                    }

                    Divider()

                    VariantShowcase(title: "Outlined", description: "フィルター選択、セカンダリカテゴリに最適") {
                        HStack(spacing: spacing.sm) {
                            Chip("Filter 1", systemImage: "line.3.horizontal.decrease", isSelected: $isFilter1Selected)
                                .chipStyle(.outlined)
                            Chip("Filter 2", systemImage: "tag", isSelected: $isFilter2Selected)
                                .chipStyle(.outlined)
                            Chip("Filter 3", systemImage: "star", isSelected: $isFilter3Selected)
                                .chipStyle(.outlined)
                        }
                    }

                    if #available(iOS 26.0, macOS 26.0, *) {
                        Divider()

                        VariantShowcase(title: "Liquid Glass", description: "プレミアム感のある表現（iOS 26+）") {
                            HStack(spacing: spacing.sm) {
                                Chip("Premium", systemImage: "star.fill")
                                    .chipStyle(.liquidGlass)
                                    .foregroundColor(.yellow)
                                Chip("Featured", systemImage: "sparkles")
                                    .chipStyle(.liquidGlass)
                                    .foregroundColor(.purple)
                            }
                        }
                    }
                }
            }

            SectionCard(title: "サイズ") {
                VStack(alignment: .leading, spacing: spacing.md) {
                    VariantShowcase(title: "Medium", description: "32pt高さ、標準的な用途") {
                        Chip("Medium", systemImage: "tag.fill")
                            .chipStyle(.filled)
                            .chipSize(.medium)
                            .foregroundColor(.blue)
                    }

                    Divider()

                    VariantShowcase(title: "Small", description: "24pt高さ、密集レイアウト向け") {
                        Chip("Small", systemImage: "tag.fill")
                            .chipStyle(.filled)
                            .chipSize(.small)
                            .foregroundColor(.blue)
                    }
                }
            }

            SectionCard(title: "削除可能") {
                VariantShowcase(title: "Input Chip", description: "ユーザー入力されたタグの表示") {
                    FlowLayout(spacing: spacing.sm) {
                        Chip("SwiftUI", systemImage: "tag.fill", onDelete: {})
                            .chipStyle(.filled)
                            .foregroundColor(.blue)
                        Chip("iOS Development", onDelete: {})
                            .chipStyle(.filled)
                            .foregroundColor(.purple)
                        Chip("Design System", systemImage: "paintbrush.fill", onDelete: {})
                            .chipStyle(.filled)
                            .foregroundColor(.pink)
                    }
                }
            }

            SectionCard(title: "ユースケース") {
                VStack(alignment: .leading, spacing: spacing.lg) {
                    VariantShowcase(title: "ステータス表示") {
                        HStack(spacing: spacing.sm) {
                            Chip("Active", systemImage: "circle.fill")
                                .chipStyle(.filled).chipSize(.small).foregroundColor(.green)
                            Chip("In Progress", systemImage: "arrow.circlepath")
                                .chipStyle(.filled).chipSize(.small).foregroundColor(.blue)
                            Chip("Completed", systemImage: "checkmark.circle.fill")
                                .chipStyle(.filled).chipSize(.small).foregroundColor(.gray)
                        }
                    }

                    Divider()

                    VariantShowcase(title: "カテゴリタグ") {
                        FlowLayout(spacing: spacing.xs) {
                            Chip("Technology", systemImage: "laptopcomputer").chipStyle(.outlined).chipSize(.small)
                            Chip("Design", systemImage: "paintpalette").chipStyle(.outlined).chipSize(.small)
                            Chip("Business", systemImage: "briefcase").chipStyle(.outlined).chipSize(.small)
                        }
                    }

                    Divider()

                    VariantShowcase(title: "フィルター") {
                        FlowLayout(spacing: spacing.sm) {
                            Chip("All Items", systemImage: "square.grid.2x2", isSelected: .constant(true)).chipStyle(.outlined)
                            Chip("Favorites", systemImage: "star", isSelected: .constant(false)).chipStyle(.outlined)
                            Chip("Recent", systemImage: "clock", isSelected: .constant(false)).chipStyle(.outlined)
                        }
                    }
                }
            }

            SectionCard(title: "ベストプラクティス") {
                VStack(alignment: .leading, spacing: spacing.md) {
                    BestPracticeItem(
                        icon: "checkmark.circle.fill",
                        title: "簡潔なラベル",
                        description: "1-2語の短く明確なラベルを使用",
                        isGood: true
                    )
                    BestPracticeItem(
                        icon: "checkmark.circle.fill",
                        title: "スタイルの一貫性",
                        description: "同じコンテキストでは同じスタイルを使用",
                        isGood: true
                    )
                    BestPracticeItem(
                        icon: "xmark.circle.fill",
                        title: "過度な使用を避ける",
                        description: "画面内のChipが多すぎると視覚的ノイズに",
                        isGood: false
                    )
                }
            }
        }
    }
}

/// チップを水平に並べ、折り返すレイアウト
private struct FlowLayout: Layout {
    var spacing: CGFloat = 8

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let result = FlowResult(in: proposal.replacingUnspecifiedDimensions().width, subviews: subviews, spacing: spacing)
        return result.size
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let result = FlowResult(in: bounds.width, subviews: subviews, spacing: spacing)
        for (index, subview) in subviews.enumerated() {
            subview.place(
                at: CGPoint(x: bounds.minX + result.frames[index].minX, y: bounds.minY + result.frames[index].minY),
                proposal: .unspecified
            )
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

#Preview {
    ChipCatalogView()
        .theme(ThemeProvider())
}
