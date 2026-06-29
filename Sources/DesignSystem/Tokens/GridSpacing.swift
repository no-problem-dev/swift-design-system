import Foundation

/// グリッドレイアウトの間隔（gutter）を定義するトークン
///
/// グリッドアイテム間の間隔を統一的に管理する。
/// Material Design 3 や Fluent 2 のガイドラインに基づき、
/// 異なる画面サイズやコンテキストに適した間隔を提供する。
///
/// ## 使用例
/// ```swift
/// AspectGrid(
///     minItemWidth: 160,
///     maxItemWidth: 200,
///     itemAspectRatio: 2/3,
///     spacing: .md  // デフォルトの間隔
/// ) {
///     // コンテンツ
/// }
/// ```
///
/// ## デザインガイドライン
/// - Material Design 3: 16-24dp gutters
/// - Fluent 2: 8-16px gutters
/// - Apple HIG: 8-20pt spacing
/// - 8pt grid systemに準拠
public enum GridSpacing: CGFloat, Sendable {
    /// 最小間隔（8pt）
    ///
    /// 密集したレイアウトや小さなアイテムに適する。
    ///
    /// ## 使用例
    /// - アイコングリッド
    /// - タグ一覧
    /// - コンパクトなサムネイル
    case xs = 8

    /// 小さい間隔（12pt）
    ///
    /// コンパクトなレイアウトに適する。
    ///
    /// ## 使用例
    /// - カードグリッド（compact）
    /// - サムネイル一覧
    /// - 密度の高いギャラリー
    case sm = 12

    /// 標準間隔（16pt）
    ///
    /// デフォルトの間隔。ほとんどのグリッドレイアウトに適する。
    ///
    /// ## 使用例
    /// - 書籍カバー
    /// - 商品一覧
    /// - 写真グリッド
    case md = 16

    /// 大きい間隔（20pt）
    ///
    /// ゆとりのあるレイアウトに適する。
    ///
    /// ## 使用例
    /// - カードグリッド（regular）
    /// - メディアギャラリー
    /// - フィーチャーコンテンツ
    case lg = 20

    /// 最大間隔（24pt）
    ///
    /// 非常にゆとりのあるレイアウトや大きなアイテムに適する。
    ///
    /// ## 使用例
    /// - ヒーローカード
    /// - フィーチャーグリッド
    /// - プレミアムコンテンツ
    case xl = 24

    /// CGFloat値を取得
    public var value: CGFloat {
        self.rawValue
    }
}
