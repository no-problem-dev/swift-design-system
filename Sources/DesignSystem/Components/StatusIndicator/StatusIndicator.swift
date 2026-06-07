import SwiftUI

/// 非同期の作業状態を表す意味的なステータス。
///
/// エージェント実行、アップロード、同期など「待機 → 実行 → 終端」の
/// ライフサイクルを持つあらゆる処理の状態表現に使えます。
public enum StatusKind: Sendable, Equatable, CaseIterable {
    /// 開始待ち
    case pending
    /// 実行中
    case running
    /// 正常終了
    case success
    /// 失敗
    case failure
    /// 中断
    case canceled
}

/// StatusIndicatorコンポーネント
///
/// `StatusKind` をアイコン + セマンティックカラーの 1 グリフで表すインジケーター。
/// 実行中はシステムの `ProgressView` を表示します。
///
/// ## 基本的な使用例
/// ```swift
/// StatusIndicator(.running)
/// StatusIndicator(.success)
///
/// // リスト行のトレーリングに
/// HStack {
///     Text("調査エージェント")
///     Spacer()
///     StatusIndicator(.running)
/// }
/// ```
public struct StatusIndicator: View {
    @Environment(\.colorPalette) private var colors

    private let kind: StatusKind

    /// ステータスインジケーターを作成
    /// - Parameter kind: 表示するステータス
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

// MARK: - StatusKind のセマンティックカラー

public extension StatusKind {
    /// ステータスに対応するセマンティックカラー。
    /// 周辺要素（アイコンバッジの色等）をインジケーターと揃えるために公開する。
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
