import SwiftUI

/// FABコンポーネントのカタログビュー
struct FloatingActionButtonCatalogView: View {
    @Environment(\.colorPalette) private var colorPalette
    @Environment(\.spacingScale) private var spacing
    @State private var tapCount = 0

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // 概要
                VStack(alignment: .leading, spacing: 12) {
                    Text("Floating Action Button (FAB) は画面上で最も重要なアクションを表すボタンです")
                        .typography(.bodyMedium)
                        .foregroundStyle(colorPalette.onSurfaceVariant)

                    if tapCount > 0 {
                        Text("タップ回数: \(tapCount)")
                            .typography(.bodySmall)
                            .foregroundStyle(colorPalette.primary)
                    }
                }
                .padding(.horizontal, spacing.lg)
                .padding(.top, spacing.lg)

                // サイズバリエーション
                SectionCard(title: "サイズバリエーション") {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("3つのサイズが利用可能")
                            .typography(.bodySmall)
                            .foregroundStyle(colorPalette.onSurfaceVariant)

                        VStack(spacing: spacing.lg) {
                            HStack {
                                Text("Small (40pt)")
                                    .typography(.bodyMedium)
                                    .frame(maxWidth: .infinity, alignment: .leading)

                                FloatingActionButton(icon: "plus", size: .small) {
                                    tapCount += 1
                                }
                            }

                            HStack {
                                Text("Regular (56pt)")
                                    .typography(.bodyMedium)
                                    .frame(maxWidth: .infinity, alignment: .leading)

                                FloatingActionButton(icon: "plus", size: .regular) {
                                    tapCount += 1
                                }
                            }

                            HStack {
                                Text("Large (96pt)")
                                    .typography(.bodyMedium)
                                    .frame(maxWidth: .infinity, alignment: .leading)

                                FloatingActionButton(icon: "plus", size: .large) {
                                    tapCount += 1
                                }
                            }
                        }
                    }
                }

                // アイコンバリエーション
                SectionCard(title: "アイコンバリエーション") {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("SF Symbolsのアイコンが使用可能")
                            .typography(.bodySmall)
                            .foregroundStyle(colorPalette.onSurfaceVariant)

                        HStack(spacing: spacing.lg) {
                            FloatingActionButton(icon: "plus") {
                                tapCount += 1
                            }

                            FloatingActionButton(icon: "pencil") {
                                tapCount += 1
                            }

                            FloatingActionButton(icon: "camera") {
                                tapCount += 1
                            }

                            FloatingActionButton(icon: "trash") {
                                tapCount += 1
                            }
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
                        FloatingActionButton(
                            icon: "plus",
                            size: .regular
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

                // レイアウト例
                SectionCard(title: "レイアウト例") {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("画面右下に配置する典型的な使用パターン")
                            .typography(.bodySmall)
                            .foregroundStyle(colorPalette.onSurfaceVariant)

                        ZStack(alignment: .bottomTrailing) {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(colorPalette.surfaceVariant.opacity(0.3))
                                .frame(height: 200)

                            FloatingActionButton(icon: "plus") {
                                tapCount += 1
                            }
                            .padding(16)
                        }
                    }
                }
            }
            .padding(.bottom, spacing.xl)
        }
        .background(colorPalette.background)
        .navigationTitle("FloatingActionButton")
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
    }
}

#Preview {
    NavigationStack {
        FloatingActionButtonCatalogView()
            .theme(ThemeProvider())
    }
}
