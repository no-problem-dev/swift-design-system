import SwiftUI

/// SectionCardパターンのカタログビュー
/// レイアウトパターンとしてのSectionCardの使い方を詳しく説明
struct SectionCardCatalogView: View {
    @Environment(\.colorPalette) private var colorPalette
    @Environment(\.spacingScale) private var spacing

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: spacing.xl) {
                // 概要
                VStack(alignment: .leading, spacing: spacing.md) {
                    Text("SectionCardは、タイトル付きのセクションを作成するレイアウトパターンです")
                        .typography(.bodyMedium)
                        .foregroundStyle(colorPalette.onSurfaceVariant)

                    Text("Material Design 3のパターン概念に基づき、情報を階層的にグループ化します")
                        .typography(.bodySmall)
                        .foregroundStyle(colorPalette.onSurfaceVariant)
                }
                .padding(.horizontal, spacing.lg)
                .padding(.top, spacing.lg)

                // 構成
                SectionCard(title: "構成") {
                    VStack(alignment: .leading, spacing: spacing.md) {
                        SpecItem(
                            label: "タイトル",
                            value: "Typography.titleMedium",
                            description: "セクションの見出し"
                        )

                        Divider()

                        SpecItem(
                            label: "コンテンツ",
                            value: "Cardコンポーネント",
                            description: "内部でコンテンツをラップ"
                        )

                        Divider()

                        SpecItem(
                            label: "スペーシング",
                            value: "spacing.md (12pt)",
                            description: "タイトルとコンテンツの間隔"
                        )

                        Divider()

                        SpecItem(
                            label: "パディング",
                            value: "spacing.lg (16pt)",
                            description: "水平方向のパディング（自動）"
                        )
                    }
                }

                // 基本的な使用例
                SectionCard(title: "基本的な使用例") {
                    VStack(alignment: .leading, spacing: spacing.md) {
                        Text("シンプルなテキストコンテンツ")
                            .typography(.bodySmall)
                            .foregroundStyle(colorPalette.onSurfaceVariant)

                        // デモ
                        SectionCard(title: "サンプルセクション") {
                            VStack(alignment: .leading, spacing: spacing.sm) {
                                Text("ここにコンテンツが入ります")
                                    .typography(.bodyMedium)

                                Text("SectionCardは自動的にCardコンポーネントでラップします")
                                    .typography(.bodySmall)
                                    .foregroundStyle(colorPalette.onSurfaceVariant)
                            }
                        }
                    }
                }

                // 複雑なコンテンツの例
                SectionCard(title: "複雑なコンテンツの例") {
                    VStack(alignment: .leading, spacing: spacing.md) {
                        Text("リストやグリッドなど複雑なレイアウトも可能")
                            .typography(.bodySmall)
                            .foregroundStyle(colorPalette.onSurfaceVariant)

                        // デモ
                        SectionCard(title: "機能リスト") {
                            VStack(alignment: .leading, spacing: spacing.sm) {
                                FeatureRow(icon: "checkmark.circle.fill", title: "自動パディング管理")
                                FeatureRow(icon: "checkmark.circle.fill", title: "Cardコンポーネント統合")
                                FeatureRow(icon: "checkmark.circle.fill", title: "Spacing tokens対応")
                                FeatureRow(icon: "checkmark.circle.fill", title: "階層的な情報構造")
                            }
                        }
                    }
                }

                // コード例
                SectionCard(title: "コード例") {
                    VStack(alignment: .leading, spacing: spacing.sm) {
                        Text("SwiftUIでの使用方法")
                            .typography(.titleSmall)

                        Text("""
                        SectionCard(title: "セクション名") {
                            VStack(alignment: .leading, spacing: spacing.md) {
                                Text("コンテンツ")
                                Text("複数の要素を配置可能")
                            }
                        }
                        """)
                        .typography(.bodySmall)
                        .fontDesign(.monospaced)
                        .padding()
                        .background(colorPalette.surfaceVariant.opacity(0.5))
                        .cornerRadius(8)
                    }
                }

                // デザイン仕様
                SectionCard(title: "デザイン仕様") {
                    VStack(alignment: .leading, spacing: spacing.md) {
                        VStack(alignment: .leading, spacing: spacing.xs) {
                            Text("スペーシング")
                                .typography(.labelLarge)
                                .foregroundStyle(colorPalette.primary)

                            SpecItem(label: "タイトル-コンテンツ間", value: "spacing.md (12pt)")
                            SpecItem(label: "水平パディング", value: "spacing.lg (16pt)")
                        }

                        Divider()

                        VStack(alignment: .leading, spacing: spacing.xs) {
                            Text("エレベーション")
                                .typography(.labelLarge)
                                .foregroundStyle(colorPalette.primary)

                            SpecItem(label: "Card elevation", value: "level1（デフォルト）")
                        }

                        Divider()

                        VStack(alignment: .leading, spacing: spacing.xs) {
                            Text("タイポグラフィ")
                                .typography(.labelLarge)
                                .foregroundStyle(colorPalette.primary)

                            SpecItem(label: "タイトル", value: "Typography.titleMedium")
                        }
                    }
                }

                // 使用ガイド
                SectionCard(title: "使用ガイド") {
                    VStack(alignment: .leading, spacing: spacing.md) {
                        BestPracticeItem(
                            icon: "checkmark.circle.fill",
                            title: "関連情報のグループ化",
                            description: "設定画面や詳細画面で、関連する項目をセクションごとにまとめる",
                            isGood: true
                        )

                        BestPracticeItem(
                            icon: "checkmark.circle.fill",
                            title: "階層的な情報構造",
                            description: "複数のSectionCardを使って情報を段階的に整理し、視認性を向上",
                            isGood: true
                        )

                        BestPracticeItem(
                            icon: "checkmark.circle.fill",
                            title: "明確なタイトル",
                            description: "各セクションの内容を端的に表すタイトルを設定",
                            isGood: true
                        )

                        BestPracticeItem(
                            icon: "xmark.circle.fill",
                            title: "過度なネストは避ける",
                            description: "SectionCard内にSectionCardを何重にもネストすると読みづらくなる",
                            isGood: false
                        )
                    }
                }
            }
            .padding(.bottom, spacing.xl)
        }
        .background(colorPalette.background)
        .navigationTitle("SectionCard")
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
    }
}

#Preview {
    NavigationStack {
        SectionCardCatalogView()
            .theme(ThemeProvider())
    }
}
