import SwiftUI

/// カードコンポーネント
///
/// Elevation（影）、角丸、背景色を備えた汎用コンテナ。
/// コンテンツをグルーピングし、視覚的な階層を表現するために使用します。
///
/// ## 使用例
/// ```swift
/// @Environment(\.spacingScale) var spacing
///
/// // 基本的な使い方
/// Card {
///     Text("デフォルトカード")
///         .typography(.bodyMedium)
/// }
///
/// // Elevationとスペーシングのカスタマイズ
/// Card(elevation: .level2) {
///     VStack(alignment: .leading, spacing: spacing.md) {
///         Text("カードタイトル")
///             .typography(.titleMedium)
///         Text("カードの説明文がここに入ります。")
///             .typography(.bodyMedium)
///     }
/// }
///
/// // 角丸・背景色のカスタマイズ
/// Card(elevation: .level3, cornerRadius: 20, backgroundColor: colors.primaryContainer) {
///     Text("カスタムカード")
/// }
///
/// // パディングの均一指定
/// Card(elevation: .level1, allSides: 24) {
///     Text("均一パディング")
/// }
/// ```
///
/// ## デザインガイドライン
/// - **level0〜level1**: リスト項目やフラットなカード
/// - **level2**: 標準的なカード（推奨）
/// - **level3〜level5**: 強調・モーダル的な用途
public struct Card<Content: View>: View {
    @Environment(\.colorPalette) private var colorPalette
    @Environment(\.radiusScale) private var radiusScale

    private let content: Content
    private let elevation: Elevation
    private let padding: EdgeInsets
    private let cornerRadius: CGFloat?
    private let backgroundColor: Color?

    /// カードを作成します
    ///
    /// - Parameters:
    ///   - elevation: 影のレベル（デフォルト: `.level1`）
    ///   - padding: コンテンツの内側余白（デフォルト: 上下左右16pt）
    ///   - cornerRadius: 角丸の半径（`nil`の場合は`RadiusScale.lg`を使用）
    ///   - backgroundColor: 背景色（`nil`の場合は`ColorPalette.surface`を使用）
    ///   - content: カード内に表示するコンテンツ
    public init(
        elevation: Elevation = .level1,
        padding: EdgeInsets = EdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16),
        cornerRadius: CGFloat? = nil,
        backgroundColor: Color? = nil,
        @ViewBuilder content: () -> Content
    ) {
        self.elevation = elevation
        self.padding = padding
        self.cornerRadius = cornerRadius
        self.backgroundColor = backgroundColor
        self.content = content()
    }

    public var body: some View {
        content
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(padding)
            .background(backgroundColor ?? colorPalette.surface)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius ?? radiusScale.lg))
            .elevation(elevation)
    }
}

public extension Card {
    /// 均一なパディングでカードを作成します
    ///
    /// - Parameters:
    ///   - elevation: 影のレベル（デフォルト: `.level1`）
    ///   - padding: 上下左右に均一に適用するパディング値
    ///   - cornerRadius: 角丸の半径（`nil`の場合は`RadiusScale.lg`を使用）
    ///   - backgroundColor: 背景色（`nil`の場合は`ColorPalette.surface`を使用）
    ///   - content: カード内に表示するコンテンツ
    init(
        elevation: Elevation = .level1,
        allSides padding: CGFloat,
        cornerRadius: CGFloat? = nil,
        backgroundColor: Color? = nil,
        @ViewBuilder content: () -> Content
    ) {
        self.init(
            elevation: elevation,
            padding: EdgeInsets(top: padding, leading: padding, bottom: padding, trailing: padding),
            cornerRadius: cornerRadius,
            backgroundColor: backgroundColor,
            content: content
        )
    }
}

#Preview {
    VStack(spacing: 16) {
        Card {
            Text("Default Card")
        }
        Card(elevation: .level3, cornerRadius: 20) {
            Text("Custom Corner Radius")
        }
    }
    .padding()
    .theme(ThemeProvider())
}
