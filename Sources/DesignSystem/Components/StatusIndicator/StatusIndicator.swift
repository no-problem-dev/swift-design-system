import SwiftUI

/// A semantic status for asynchronous work.
///
/// Use it for anything with a waiting, then running, then finished lifecycle: an agent run,
/// an upload, a sync.
public enum StatusKind: Sendable, Equatable, CaseIterable {
    case pending
    case running
    case success
    case failure
    case canceled
}

/// Shows the state of a piece of work as a single glyph: an icon in a semantic color.
///
/// While the work is running it shows the system `ProgressView`.
///
/// ## Example
/// ```swift
/// StatusIndicator(.running)
/// StatusIndicator(.success)
///
/// // At the trailing edge of a list row
/// HStack {
///     Text("Research agent")
///     Spacer()
///     StatusIndicator(.running)
/// }
/// ```
public struct StatusIndicator: View {
    @Environment(\.colorPalette) private var colors

    private let kind: StatusKind

    public init(_ kind: StatusKind) {
        self.kind = kind
    }

    public var body: some View {
        Group {
            switch kind {
            case .pending:
                Image(systemName: "clock")
                    .foregroundStyle(colors.onSurfaceVariant)
            case .running:
                ProgressView()
                    .controlSize(.small)
            case .success:
                Image(systemName: "checkmark.circle.fill")
                    .foregroundStyle(colors.success)
            case .failure:
                Image(systemName: "xmark.circle.fill")
                    .foregroundStyle(colors.error)
            case .canceled:
                Image(systemName: "slash.circle")
                    .foregroundStyle(colors.onSurfaceVariant)
            }
        }
        .accessibilityLabel(accessibilityText)
    }

    private var accessibilityText: String {
        switch kind {
        case .pending: "待機中"
        case .running: "実行中"
        case .success: "完了"
        case .failure: "失敗"
        case .canceled: "中断"
        }
    }
}

// MARK: - Semantic colors for StatusKind

public extension StatusKind {
    /// The semantic color that goes with the status.
    ///
    /// It is public so that surrounding elements, such as the color of an icon badge, can be
    /// kept in step with the indicator.
    func color(in palette: any ColorPalette) -> Color {
        switch self {
        case .pending, .canceled: palette.onSurfaceVariant
        case .running: palette.info
        case .success: palette.success
        case .failure: palette.error
        }
    }
}

// MARK: - Previews

#Preview("Status Indicators") {
    VStack(alignment: .leading, spacing: 16) {
        ForEach(StatusKind.allCases, id: \.self) { kind in
            HStack(spacing: 12) {
                StatusIndicator(kind)
                Text("\(kind)")
            }
        }
    }
    .padding()
    .theme(ThemeProvider())
}
