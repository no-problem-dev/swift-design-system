import SwiftUI

/// One row of a chronological feed such as an activity log, a set of steps, or a change history.
///
/// A marker (a status or any icon) and a vertical connector line sit on the left, and any
/// content sits on the right. Stacking rows in a `VStack(spacing: 0)` joins the connector
/// lines into a continuous timeline.
///
/// ## Basic example
/// ```swift
/// VStack(spacing: 0) {
///     TimelineRow(status: .success, isFirst: true) {
///         Text("Search the web").typography(.bodyMedium)
///     }
///     TimelineRow(status: .running) {
///         Text("Fetching pages…").typography(.bodyMedium)
///     }
///     TimelineRow(status: .pending, isLast: true) {
///         Text("Summarize").typography(.bodyMedium)
///     }
/// }
/// ```
///
/// The marker can be any view:
/// ```swift
/// TimelineRow(isFirst: true) {
///     IconBadge(systemName: "magnifyingglass", size: .small)
/// } content: {
///     Text("The research agent ran a search")
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

    /// Creates a timeline row with a marker of your own.
    /// - Parameters:
    ///   - isFirst: Whether this is the first row, which omits the connector line above it.
    ///   - isLast: Whether this is the last row, which omits the connector line below it.
    ///   - markerColumnWidth: The width of the marker column. Keep it the same across rows of
    ///     one timeline so that the connector lines stay aligned.
    ///   - marker: The marker view placed in the left column.
    ///   - content: The body of the row.
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
        // Keeps the connector line (maxHeight: .infinity) from stretching the row beyond its
        // natural height
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
    /// Creates a timeline row whose marker is a status.
    /// - Parameters:
    ///   - status: The state of the work this row stands for, drawn as a `StatusIndicator`.
    ///   - isFirst: Whether this is the first row, which omits the connector line above it.
    ///   - isLast: Whether this is the last row, which omits the connector line below it.
    ///   - markerColumnWidth: The width of the marker column.
    ///   - content: The body of the row.
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
