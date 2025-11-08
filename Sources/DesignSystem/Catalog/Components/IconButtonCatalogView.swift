import SwiftUI

/// IconButtonコンポーネントのカタログビュー
struct IconButtonCatalogView: View {
    @Environment(\.colorPalette) private var colorPalette
    @Environment(\.spacingScale) private var spacing
    @State private var favoriteCount = 0
    @State private var likeCount = 0

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // 概要
                VStack(alignment: .leading, spacing: 12) {
                    Text("アイコンボタンはアイコンのみで構成される、コンパクトなアクションボタンです")
                        .typography(.bodyMedium)
                        .foregroundStyle(colorPalette.onSurfaceVariant)

                    if favoriteCount > 0 || likeCount > 0 {
                        VStack(alignment: .leading, spacing: 4) {
                            if favoriteCount > 0 {
                                Text("お気に入り: \(favoriteCount)")
                                    .typography(.bodySmall)
                            }
                            if likeCount > 0 {
                                Text("いいね: \(likeCount)")
                                    .typography(.bodySmall)
                            }
                        }
                        .foregroundStyle(colorPalette.primary)
                    }
                }
                .padding(.horizontal, spacing.lg)
                .padding(.top, spacing.lg)

                // スタイルバリエーション
                SectionCard(title: "スタイルバリエーション") {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("4つのスタイルが利用可能")
                            .typography(.bodySmall)
                            .foregroundStyle(colorPalette.onSurfaceVariant)

                        VStack(spacing: spacing.lg) {
                            HStack {
                                Text("Standard")
                                    .typography(.bodyMedium)
                                    .frame(width: 120, alignment: .leading)

                                IconButton(icon: "heart", style: .standard) {
                                    favoriteCount += 1
                                }

                                Text("背景なし")
                                    .typography(.labelSmall)
                                    .foregroundStyle(colorPalette.onSurfaceVariant)
                            }

                            HStack {
                                Text("Filled")
                                    .typography(.bodyMedium)
                                    .frame(width: 120, alignment: .leading)

                                IconButton(icon: "heart.fill", style: .filled) {
                                    favoriteCount += 1
                                }

                                Text("プライマリ背景")
                                    .typography(.labelSmall)
                                    .foregroundStyle(colorPalette.onSurfaceVariant)
                            }

                            HStack {
                                Text("Tonal")
                                    .typography(.bodyMedium)
                                    .frame(width: 120, alignment: .leading)

                                IconButton(icon: "heart.fill", style: .tonal) {
                                    favoriteCount += 1
                                }

                                Text("トーン背景")
                                    .typography(.labelSmall)
                                    .foregroundStyle(colorPalette.onSurfaceVariant)
                            }

                            HStack {
                                Text("Outlined")
                                    .typography(.bodyMedium)
                                    .frame(width: 120, alignment: .leading)

                                IconButton(icon: "heart", style: .outlined) {
                                    favoriteCount += 1
                                }

                                Text("枠線のみ")
                                    .typography(.labelSmall)
                                    .foregroundStyle(colorPalette.onSurfaceVariant)
                            }
                        }
                    }
                }

                // サイズバリエーション
                SectionCard(title: "サイズバリエーション") {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("3つのサイズが利用可能")
                            .typography(.bodySmall)
                            .foregroundStyle(colorPalette.onSurfaceVariant)

                        VStack(spacing: spacing.lg) {
                            HStack {
                                Text("Small (32pt)")
                                    .typography(.bodyMedium)
                                    .frame(maxWidth: .infinity, alignment: .leading)

                                IconButton(icon: "star.fill", style: .filled, size: .small) {
                                    likeCount += 1
                                }
                            }

                            HStack {
                                Text("Medium (40pt)")
                                    .typography(.bodyMedium)
                                    .frame(maxWidth: .infinity, alignment: .leading)

                                IconButton(icon: "star.fill", style: .filled, size: .medium) {
                                    likeCount += 1
                                }
                            }

                            HStack {
                                Text("Large (48pt)")
                                    .typography(.bodyMedium)
                                    .frame(maxWidth: .infinity, alignment: .leading)

                                IconButton(icon: "star.fill", style: .filled, size: .large) {
                                    likeCount += 1
                                }
                            }
                        }
                    }
                }

                // アイコンバリエーション
                SectionCard(title: "アイコンバリエーション") {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("よく使われるアイコンの例")
                            .typography(.bodySmall)
                            .foregroundStyle(colorPalette.onSurfaceVariant)

                        HStack(spacing: spacing.lg) {
                            IconButton(icon: "heart", style: .tonal) {
                                favoriteCount += 1
                            }

                            IconButton(icon: "star", style: .tonal) {
                                likeCount += 1
                            }

                            IconButton(icon: "bookmark", style: .tonal) {}

                            IconButton(icon: "square.and.arrow.up", style: .tonal) {}

                            IconButton(icon: "ellipsis", style: .tonal) {}
                        }
                        .frame(maxWidth: .infinity)
                    }
                }

                // 使用例
                SectionCard(title: "使用例") {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("SwiftUI での使用方法")
                            .typography(.titleSmall)

                        Text("""
                        IconButton(
                            icon: "heart",
                            style: .filled,
                            size: .medium
                        ) {
                            // アクション
                        }
                        """)
                        .typography(.bodySmall)
                        .fontDesign(.monospaced)
                        .padding()
                        .background(colorPalette.surfaceVariant.opacity(0.5))
                        .cornerRadius(8)
                    }
                }

                // 実用例
                SectionCard(title: "実用例") {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("ツールバーでの使用例")
                            .typography(.bodySmall)
                            .foregroundStyle(colorPalette.onSurfaceVariant)

                        Card {
                            VStack(spacing: spacing.md) {
                                HStack {
                                    Text("記事のタイトル")
                                        .typography(.titleMedium)
                                    Spacer()
                                }

                                Text("本文のプレビューテキスト。アイコンボタンは省スペースで明確なアクションを提供します。")
                                    .typography(.bodySmall)
                                    .foregroundStyle(colorPalette.onSurfaceVariant)

                                HStack {
                                    IconButton(icon: "heart", style: .tonal) {
                                        favoriteCount += 1
                                    }

                                    IconButton(icon: "bookmark", style: .tonal) {}

                                    IconButton(icon: "square.and.arrow.up", style: .tonal) {}

                                    Spacer()

                                    IconButton(icon: "ellipsis", style: .tonal) {}
                                }
                            }
                        }
                    }
                }
            }
            .padding(.bottom, spacing.xl)
        }
        .background(colorPalette.background)
        .navigationTitle("IconButton")
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
    }
}

#Preview {
    NavigationStack {
        IconButtonCatalogView()
            .theme(ThemeProvider())
    }
}
