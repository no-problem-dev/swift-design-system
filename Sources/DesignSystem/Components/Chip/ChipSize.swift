import SwiftUI

/// Chipコンポーネントのサイズバリアント
///
/// Chipのサイズを定義するトークンです。ステータス表示、カテゴリタグ、フィルターなど
/// 用途に応じて適切なサイズを選択できます。
///
/// ## 使用例
/// ```swift
/// Chip("Active", systemImage: "circle.fill")
///     .chipSize(.medium)  // デフォルト
///
/// Chip("New", systemImage: "bell.fill")
///     .chipSize(.small)   // コンパクトな表示
/// ```
///
/// ## サイズの使い分け
/// - **Small**: 密集したレイアウト、補助的な情報（24pt）
/// - **Medium**: 標準的な用途、読みやすさ重視（32pt）
public enum ChipSize: Sendable {
    /// 小さいサイズ（24pt）- コンパクトなレイアウト
    case small

    /// 中程度のサイズ（32pt）- 標準的なチップ
    case medium

    /// Chipの高さ
    var height: CGFloat {
        switch self {
        case .small: return 24
        case .medium: return 32
        }
    }

    /// 水平パディング
    var horizontalPadding: CGFloat {
        switch self {
        case .small: return 6
        case .medium: return 8
        }
    }

    /// 垂直パディング
    var verticalPadding: CGFloat {
        switch self {
        case .small: return 2
        case .medium: return 4
        }
    }

    /// アイコンサイズ
    var iconSize: CGFloat {
        switch self {
        case .small: return 14
        case .medium: return 18
        }
    }

    /// タイポグラフィトークン
    var typography: Typography {
        switch self {
        case .small: return .labelSmall
        case .medium: return .labelMedium
        }
    }
}

/// ChipSize用のEnvironmentKey
private struct ChipSizeKey: EnvironmentKey {
    static let defaultValue: ChipSize = .medium
}

public extension EnvironmentValues {
    /// 環境から取得するChipSize
    var chipSize: ChipSize {
        get { self[ChipSizeKey.self] }
        set { self[ChipSizeKey.self] = newValue }
    }
}
