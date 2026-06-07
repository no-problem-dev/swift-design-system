import SwiftUI

/// TimelineRowコンポーネント
///
/// 時系列フィード（アクティビティログ、進行ステップ、変更履歴など）の 1 行。
/// 左にマーカー（ステータスや任意のアイコン）と縦のコネクタ線、右に任意のコンテンツを置きます。
/// 行を `VStack(spacing: 0)` に並べるとコネクタ線が連続したタイムラインになります。
///
/// ## 基本的な使用例
/// ```swift
/// VStack(spacing: 0) {
///     TimelineRow(status: .success, isFirst: true) {
///         Text("Web を検索").typography(.bodyMedium)
///     }
///     TimelineRow(status: .running) {
///         Text("ページを取得中…").typography(.bodyMedium)
///     }
///     TimelineRow(status: .pending, isLast: true) {
///         Text("要約").typography(.bodyMedium)
///     }
/// }
/// ```
///
/// マーカーを任意のビューに差し替えることもできます:
/// ```swift
/// TimelineRow(isFirst: true) {
///     IconBadge(systemName: "magnifyingglass", size: .small)
/// } content: {
///     Text("調査エージェントが検索しました")
/// }
/// ```
public struct TimelineRow<Marker: View, Content: View>: View {
    @Environment(\.colorPalette) private var colors
    @Environment(\.spacingScale) private var spacing

    private let isFirst: Bool
    private let isLast: Bool
    private let markerColumnWidth: CGFloat
    private let marker: Marker
    private let content: Content

    /// 任意マーカーのタイムライン行を作成
    /// - Parameters:
    ///   - isFirst: 先頭行（上のコネクタ線を描かない）
    ///   - isLast: 末尾行（下のコネクタ線を描かない）
    ///   - markerColumnWidth: マーカー列の幅（デフォルト 32pt）。連続する行で揃えること
    ///   - marker: 左列に置くマーカービュー
    ///   - content: 行の本文
    public init(
        isFirst: Bool = false,
        isLast: Bool = false,
        markerColumnWidth: CGFloat = 32,
        @ViewBuilder marker: () -> Marker,
        @ViewBuilder content: () -> Content
    ) {
        self.isFirst = isFirst
        self.isLast = isLast
        self.markerColumnWidth = markerColumnWidth
        self.marker = marker()
        self.content = content()
    }

    public var body: some View {
        HStack(alignment: .top, spacing: spacing.sm) {
            markerColumn
            content
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom, isLast ? 0 : spacing.md)
        }
        // コネクタ線（maxHeight: .infinity）が行の自然な高さを超えて伸びないようにする
        .fixedSize(horizontal: false, vertical: true)
    }

    private var markerColumn: some View {
        VStack(spacing: spacing.xxs) {
            connector(hidden: isFirst)
                .frame(height: spacing.xs)
            marker
            connector(hidden: isLast)
                .frame(maxHeight: .infinity)
        }
        .frame(width: markerColumnWidth)
    }

    @ViewBuilder
    private func connector(hidden: Bool) -> some View {
        RoundedRectangle(cornerRadius: connectorWidth / 2)
            .fill(colors.outlineVariant)
            .frame(width: connectorWidth)
            .opacity(hidden ? 0 : 1)
    }

    private var connectorWidth: CGFloat { 2 }
}

public extension TimelineRow where Marker == StatusIndicator {
    /// ステータスをマーカーにしたタイムライン行を作成
    /// - Parameters:
    ///   - status: 行の作業状態（マーカーとして `StatusIndicator` を表示）
    ///   - isFirst: 先頭行（上のコネクタ線を描かない）
    ///   - isLast: 末尾行（下のコネクタ線を描かない）
    ///   - markerColumnWidth: マーカー列の幅（デフォルト 32pt）
    ///   - content: 行の本文
    init(
        status: StatusKind,
        isFirst: Bool = false,
        isLast: Bool = false,
        markerColumnWidth: CGFloat = 32,
        @ViewBuilder content: () -> Content
    ) {
        self.init(
            isFirst: isFirst,
            isLast: isLast,
            markerColumnWidth: markerColumnWidth,
            marker: { StatusIndicator(status) },
            content: content
        )
    }
}

// MARK: - Previews

#Preview("Status Timeline") {
    ScrollView {
        VStack(spacing: 0) {
            TimelineRow(status: .success, isFirst: true) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Web を検索").font(.subheadline)
                    Text("query: SwiftUI 状態管理").font(.caption).foregroundStyle(.secondary)
                }
            }
            TimelineRow(status: .success) {
                Text("3 件のページを取得").font(.subheadline)
            }
            TimelineRow(status: .running) {
                Text("要約を生成中…").font(.subheadline)
            }
            TimelineRow(status: .pending, isLast: true) {
                Text("回答をまとめる").font(.subheadline)
            }
        }
        .padding()
    }
    .theme(ThemeProvider())
}

#Preview("Custom Marker Timeline") {
    VStack(spacing: 0) {
        TimelineRow(isFirst: true) {
            IconBadge(systemName: "magnifyingglass", size: .small)
        } content: {
            Text("調査エージェント").font(.subheadline)
        }
        TimelineRow(isLast: true) {
            IconBadge(systemName: "paintbrush", size: .small)
        } content: {
            Text("ビジュアライザー").font(.subheadline)
        }
    }
    .padding()
    .theme(ThemeProvider())
}
