import SwiftUI

/// アスペクト比固定グリッド
///
/// すべてのアイテムに統一されたアスペクト比を適用するグリッドレイアウトコンポーネントです。
/// 写真ギャラリー、商品一覧、メディアライブラリなど、一貫したアスペクト比が求められる
/// コンテンツの表示に最適です。
///
/// ## 特徴
/// - **固定アスペクト比**: すべてのアイテムに統一された比率を適用
/// - **レスポンシブ幅**: 画面サイズに応じてアイテム幅を自動調整
/// - **最大幅制御**: iPad等の大画面でのオーバーサイズを防止
/// - **遅延読み込み**: LazyVGridベースの効率的なレンダリング
///
/// ## 使用例
///
/// ### 商品一覧グリッド
/// ```swift
/// AspectGrid(
///     minItemWidth: 140,
///     maxItemWidth: 180,
///     itemAspectRatio: 1,  // 正方形
///     spacing: .md
/// ) {
///     ForEach(products) { product in
///         ProductCardView(product)
///     }
/// }
/// ```
///
/// ### 写真ギャラリー
/// ```swift
/// AspectGrid(
///     minItemWidth: 160,
///     maxItemWidth: 200,
///     itemAspectRatio: 3/4,  // 写真の一般的な比率
///     spacing: .sm
/// ) {
///     ForEach(photos) { photo in
///         PhotoView(photo)
///     }
/// }
/// ```
///
/// ### 動画サムネイルグリッド
/// ```swift
/// AspectGrid(
///     minItemWidth: 200,
///     maxItemWidth: 280,
///     itemAspectRatio: 16/9,  // 動画の標準比率
///     spacing: .lg
/// ) {
///     ForEach(videos) { video in
///         VideoThumbnailView(video)
///     }
/// }
/// ```
///
/// ## デザインガイドライン
///
/// ### アスペクト比の選択
/// - **1:1 (1.0)**: 商品サムネイル、プロフィール画像、アイコン
/// - **3:4 (0.75)**: 写真、ポートレート
/// - **16:9 (1.78)**: 動画サムネイル、ワイドコンテンツ
///
/// ### アイテム幅の設定
/// - **minItemWidth**: コンパクト表示時の最小幅（通常80-160pt）
/// - **maxItemWidth**: 大画面での最大幅（通常200-300pt）
///
/// ### 間隔の選択
/// - **.xs (8pt)**: 密集したアイコングリッド
/// - **.sm (12pt)**: コンパクトなサムネイル
/// - **.md (16pt)**: 標準的なグリッド（デフォルト）
/// - **.lg (20pt)**: ゆとりのあるレイアウト
/// - **.xl (24pt)**: プレミアムコンテンツ
public struct AspectGrid<Content: View>: View {
    private let minItemWidth: CGFloat
    private let maxItemWidth: CGFloat
    private let itemAspectRatio: CGFloat
    private let spacing: GridSpacing
    private let alignment: HorizontalAlignment
    private let content: () -> Content

    /// アスペクト比固定グリッドを作成します
    ///
    /// - Parameters:
    ///   - minItemWidth: アイテムの最小幅（pt）
    ///   - maxItemWidth: アイテムの最大幅（pt）
    ///   - itemAspectRatio: アイテムのアスペクト比（幅/高さ）
    ///   - spacing: グリッドアイテム間の間隔（デフォルト: .md）
    ///   - alignment: グリッド内でのアイテムの水平配置（デフォルト: .center）
    ///   - content: グリッドに表示するコンテンツ
    ///
    /// ## 例
    /// ```swift
    /// AspectGrid(
    ///     minItemWidth: 160,
    ///     maxItemWidth: 200,
    ///     itemAspectRatio: 2/3
    /// ) {
    ///     ForEach(items) { item in
    ///         ItemView(item)
    ///     }
    /// }
    /// ```
    public init(
        minItemWidth: CGFloat,
        maxItemWidth: CGFloat,
        itemAspectRatio: CGFloat,
        spacing: GridSpacing = .md,
        alignment: HorizontalAlignment = .center,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.minItemWidth = minItemWidth
        self.maxItemWidth = maxItemWidth
        self.itemAspectRatio = itemAspectRatio
        self.spacing = spacing
        self.alignment = alignment
        self.content = content
    }

    public var body: some View {
        LazyVGrid(
            columns: [
                GridItem(
                    .adaptive(
                        minimum: minItemWidth,
                        maximum: maxItemWidth
                    ),
                    spacing: spacing.value
                )
            ],
            alignment: alignment,
            spacing: spacing.value
        ) {
            content()
                .aspectRatio(itemAspectRatio, contentMode: .fit)
        }
    }
}

// MARK: - Previews

#Preview("Book Covers") {
    ScrollView {
        AspectGrid(
            minItemWidth: 120,
            maxItemWidth: 160,
            itemAspectRatio: 2/3,
            spacing: .md
        ) {
            ForEach(0..<12, id: \.self) { index in
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.blue.opacity(0.3))
                    .overlay {
                        Text("\(index + 1)")
                            .font(.title)
                            .foregroundColor(.white)
                    }
            }
        }
        .padding()
    }
}

#Preview("Square Icons") {
    ScrollView {
        AspectGrid(
            minItemWidth: 60,
            maxItemWidth: 80,
            itemAspectRatio: 1,
            spacing: .xs
        ) {
            ForEach(0..<20, id: \.self) { index in
                Circle()
                    .fill(Color.green.opacity(0.3))
                    .overlay {
                        Image(systemName: "star.fill")
                            .foregroundColor(.white)
                    }
            }
        }
        .padding()
    }
}

#Preview("Movie Posters") {
    ScrollView {
        AspectGrid(
            minItemWidth: 140,
            maxItemWidth: 200,
            itemAspectRatio: 3/4,
            spacing: .lg
        ) {
            ForEach(0..<8, id: \.self) { index in
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.purple.opacity(0.3))
                    .overlay {
                        VStack {
                            Image(systemName: "film")
                                .font(.largeTitle)
                            Text("Movie \(index + 1)")
                        }
                        .foregroundColor(.white)
                    }
            }
        }
        .padding()
    }
}
