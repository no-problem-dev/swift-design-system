import SwiftUI

/// タイポグラフィカタログビュー
/// 全タイプスケールを視覚的に表示
struct TypographyCatalogView: View {
    @Environment(\.colorPalette) private var colorPalette
    @Environment(\.spacingScale) private var spacing

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: spacing.xl) {
                // 概要
                overviewSection

                // Display
                displaySection

                // Headline
                headlineSection

                // Title
                titleSection

                // Body
                bodySection

                // Label
                labelSection

                // Font Design
                fontDesignSection

                // 使用例
                usageSection
            }
            .padding(.bottom, spacing.xl)
        }
        .background(colorPalette.background)
        .navigationTitle("タイポグラフィ")
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
    }

    // MARK: - Overview

    @ViewBuilder
    private var overviewSection: some View {
        VStack(alignment: .leading, spacing: spacing.md) {
            Text("15種類の定義済みタイポグラフィトークンを提供します。")
                .typography(.bodyMedium)
                .foregroundStyle(colorPalette.onSurfaceVariant)

            Text("Material Design 3のタイプスケールに基づいており、Display、Headline、Title、Body、Labelの5つのカテゴリに分類されています。")
                .typography(.bodySmall)
                .foregroundStyle(colorPalette.onSurfaceVariant)
        }
        .padding(.horizontal, spacing.lg)
        .padding(.top, spacing.lg)
    }

    // MARK: - Display Section

    @ViewBuilder
    private var displaySection: some View {
        SectionCard(title: "Display") {
            VStack(alignment: .leading, spacing: spacing.lg) {
                Text("最も大きく目立つテキスト。ヒーローセクションやランディングページで使用。")
                    .typography(.bodySmall)
                    .foregroundStyle(colorPalette.onSurfaceVariant)

                VStack(spacing: spacing.lg) {
                    TypographyDemoView(style: .displayLarge, text: "Display Large")
                    TypographyDemoView(style: .displayMedium, text: "Display Medium")
                    TypographyDemoView(style: .displaySmall, text: "Display Small")
                }
            }
        }
    }

    // MARK: - Headline Section

    @ViewBuilder
    private var headlineSection: some View {
        SectionCard(title: "Headline") {
            VStack(alignment: .leading, spacing: spacing.lg) {
                Text("セクション見出しや重要なタイトルに使用。")
                    .typography(.bodySmall)
                    .foregroundStyle(colorPalette.onSurfaceVariant)

                VStack(spacing: spacing.lg) {
                    TypographyDemoView(style: .headlineLarge, text: "Headline Large")
                    TypographyDemoView(style: .headlineMedium, text: "Headline Medium")
                    TypographyDemoView(style: .headlineSmall, text: "Headline Small")
                }
            }
        }
    }

    // MARK: - Title Section

    @ViewBuilder
    private var titleSection: some View {
        SectionCard(title: "Title") {
            VStack(alignment: .leading, spacing: spacing.lg) {
                Text("カードタイトル、ダイアログタイトル、リスト項目の見出しに使用。")
                    .typography(.bodySmall)
                    .foregroundStyle(colorPalette.onSurfaceVariant)

                VStack(spacing: spacing.lg) {
                    TypographyDemoView(style: .titleLarge, text: "Title Large")
                    TypographyDemoView(style: .titleMedium, text: "Title Medium")
                    TypographyDemoView(style: .titleSmall, text: "Title Small")
                }
            }
        }
    }

    // MARK: - Body Section

    @ViewBuilder
    private var bodySection: some View {
        SectionCard(title: "Body") {
            VStack(alignment: .leading, spacing: spacing.lg) {
                Text("本文テキスト、段落、説明文に使用。最も頻繁に使用されるスタイル。")
                    .typography(.bodySmall)
                    .foregroundStyle(colorPalette.onSurfaceVariant)

                VStack(spacing: spacing.lg) {
                    TypographyDemoView(style: .bodyLarge, text: "Body Large - 標準的な本文テキストに使用します。読みやすさを重視したサイズです。")
                    TypographyDemoView(style: .bodyMedium, text: "Body Medium - よりコンパクトな本文テキストに使用します。情報密度が高い場合に適しています。")
                    TypographyDemoView(style: .bodySmall, text: "Body Small - 補足説明や注釈など、小さめの本文テキストに使用します。")
                }
            }
        }
    }

    // MARK: - Label Section

    @ViewBuilder
    private var labelSection: some View {
        SectionCard(title: "Label") {
            VStack(alignment: .leading, spacing: spacing.lg) {
                Text("ボタン、タブ、フォームのラベルなど、UIコンポーネントのテキストに使用。")
                    .typography(.bodySmall)
                    .foregroundStyle(colorPalette.onSurfaceVariant)

                VStack(spacing: spacing.lg) {
                    TypographyDemoView(style: .labelLarge, text: "Label Large")
                    TypographyDemoView(style: .labelMedium, text: "Label Medium")
                    TypographyDemoView(style: .labelSmall, text: "Label Small")
                }
            }
        }
    }

    // MARK: - Font Design Section

    @ViewBuilder
    private var fontDesignSection: some View {
        SectionCard(title: "フォントデザイン") {
            VStack(alignment: .leading, spacing: spacing.lg) {
                Text("4種類のフォントデザインが利用可能です。iOS/macOSのシステムフォントに対応しています。")
                    .typography(.bodySmall)
                    .foregroundStyle(colorPalette.onSurfaceVariant)

                VStack(spacing: spacing.lg) {
                    FontDesignDemoView(design: .default, name: "Default (ゴシック)", sampleText: "こんにちは世界 Hello World 123")
                    FontDesignDemoView(design: .serif, name: "Serif (明朝)", sampleText: "こんにちは世界 Hello World 123")
                    FontDesignDemoView(design: .rounded, name: "Rounded (丸ゴシック)", sampleText: "こんにちは世界 Hello World 123")
                    FontDesignDemoView(design: .monospaced, name: "Monospaced (等幅)", sampleText: "こんにちは世界 Hello World 123")
                }
            }
        }
    }

    // MARK: - Usage Section

    @ViewBuilder
    private var usageSection: some View {
        SectionCard(title: "使用例") {
            VStack(alignment: .leading, spacing: spacing.md) {
                Text("SwiftUIでの使用方法")
                    .typography(.titleSmall)

                Text("""
                Text("見出し")
                    .typography(.headlineLarge)

                Text("本文テキスト")
                    .typography(.bodyMedium)

                Text("明朝体で表示")
                    .typography(.bodyMedium, design: .serif)

                Text("ラベル")
                    .typography(.labelSmall)
                """)
                .typography(.bodySmall)
                .fontDesign(.monospaced)
                .padding(spacing.md)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(colorPalette.surfaceVariant)
                .cornerRadius(8)
            }
        }
    }
}

// MARK: - Typography Demo View

/// タイポグラフィスタイルのデモ表示コンポーネント
private struct TypographyDemoView: View {
    @Environment(\.colorPalette) private var colorPalette
    @Environment(\.spacingScale) private var spacing

    let style: Typography
    let text: String

    var body: some View {
        VStack(alignment: .leading, spacing: spacing.sm) {
            // サンプルテキスト
            Text(text)
                .typography(style)
                .foregroundStyle(colorPalette.onSurface)

            // スペック情報
            HStack(spacing: spacing.md) {
                SpecLabel(label: "Size", value: "\(Int(style.size))pt")
                SpecLabel(label: "Weight", value: weightName(style.weight))
                SpecLabel(label: "Line Height", value: "\(Int(style.lineHeight))pt")
            }
            .opacity(0.7)
        }
        .padding(.vertical, spacing.sm)
    }

    private func weightName(_ weight: Font.Weight) -> String {
        switch weight {
        case .bold: return "Bold"
        case .semibold: return "Semibold"
        case .medium: return "Medium"
        case .regular: return "Regular"
        default: return "Regular"
        }
    }
}

/// スペックラベル表示コンポーネント
private struct SpecLabel: View {
    @Environment(\.colorPalette) private var colorPalette

    let label: String
    let value: String

    var body: some View {
        HStack(spacing: 4) {
            Text(label)
                .typography(.labelSmall)
                .foregroundStyle(colorPalette.onSurfaceVariant)
            Text(value)
                .typography(.labelSmall)
                .fontDesign(.monospaced)
                .foregroundStyle(colorPalette.onSurfaceVariant)
        }
    }
}

/// フォントデザインのデモ表示コンポーネント
private struct FontDesignDemoView: View {
    @Environment(\.colorPalette) private var colorPalette
    @Environment(\.spacingScale) private var spacing

    let design: Font.Design
    let name: String
    let sampleText: String

    var body: some View {
        VStack(alignment: .leading, spacing: spacing.sm) {
            // デザイン名
            Text(name)
                .typography(.titleSmall)
                .foregroundStyle(colorPalette.onSurface)

            // サンプルテキスト
            Text(sampleText)
                .typography(.bodyLarge, design: design)
                .foregroundStyle(colorPalette.onSurface)
                .padding(.vertical, spacing.xs)
        }
        .padding(.vertical, spacing.xs)
    }
}

#Preview {
    NavigationStack {
        TypographyCatalogView()
            .theme(ThemeProvider())
    }
}
