import SwiftUI

/// カードコンポーネントのカタログビュー
struct CardCatalogView: View {
    @Environment(\.colorPalette) private var colorPalette
    @Environment(\.spacingScale) private var spacing

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // 概要
                Text("カードは関連情報をグループ化する汎用コンテナです")
                    .typography(.bodyMedium)
                    .foregroundStyle(colorPalette.onSurfaceVariant)
                    .padding(.horizontal, spacing.lg)
                    .padding(.top, spacing.lg)

                // 基本カード
                SectionCard(title: "基本カード") {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("デフォルトの設定（Elevation Level 1、パディング 16pt）")
                            .typography(.bodySmall)
                            .foregroundStyle(colorPalette.onSurfaceVariant)

                        Card {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("カードタイトル")
                                    .typography(.titleMedium)

                                Text("カードの本文テキストです。関連する情報をグループ化して表示します。")
                                    .typography(.bodyMedium)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                }

                // Elevation バリエーション
                SectionCard(title: "Elevation バリエーション") {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("異なる深さで視覚的な階層を表現")
                            .typography(.bodySmall)
                            .foregroundStyle(colorPalette.onSurfaceVariant)

                        VStack(spacing: spacing.md) {
                            ForEach([Elevation.level0, .level1, .level2, .level3, .level4, .level5], id: \.self) { elevation in
                                Card(elevation: elevation) {
                                    HStack {
                                        Text("Level \(elevationNumber(elevation))")
                                            .typography(.bodyMedium)
                                        Spacer()
                                        Text("Elevation")
                                            .typography(.labelSmall)
                                            .foregroundStyle(colorPalette.onSurfaceVariant)
                                    }
                                }
                            }
                        }
                    }
                }

                // パディングバリエーション
                SectionCard(title: "パディングバリエーション") {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("内容に応じてパディングを調整")
                            .typography(.bodySmall)
                            .foregroundStyle(colorPalette.onSurfaceVariant)

                        VStack(spacing: spacing.md) {
                            Card(allSides: 8) {
                                Text("Compact (8pt)")
                                    .typography(.bodySmall)
                            }

                            Card(allSides: 16) {
                                Text("Default (16pt)")
                                    .typography(.bodyMedium)
                            }

                            Card(allSides: 24) {
                                Text("Comfortable (24pt)")
                                    .typography(.bodyLarge)
                            }
                        }
                    }
                }

                // 使用例
                SectionCard(title: "使用例") {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("SwiftUI での使用方法")
                            .typography(.titleSmall)

                        Text("""
                        Card(elevation: .level2) {
                            VStack(alignment: .leading) {
                                Text("タイトル")
                                    .typography(.titleMedium)
                                Text("本文")
                                    .typography(.bodyMedium)
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
            }
            .padding(.bottom, spacing.xl)
        }
        .background(colorPalette.background)
        .navigationTitle("Card")
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
    }

    private func elevationNumber(_ elevation: Elevation) -> Int {
        switch elevation {
        case .level0: return 0
        case .level1: return 1
        case .level2: return 2
        case .level3: return 3
        case .level4: return 4
        case .level5: return 5
        }
    }
}

#Preview {
    NavigationStack {
        CardCatalogView()
            .theme(ThemeProvider())
    }
}
