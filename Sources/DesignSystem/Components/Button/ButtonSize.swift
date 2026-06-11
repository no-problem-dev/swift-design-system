import SwiftUI

/// ボタンのサイズバリアント
///
/// ボタンの高さ、パディング、フォントサイズを統一的に管理します。
///
/// ## 使用例
/// ```swift
/// Button("ログイン") {
///     login()
/// }
/// .buttonStyle(.primary)
/// .buttonSize(.large)  // 56pt高さ（デフォルト）
///
/// Button("キャンセル") {
///     cancel()
/// }
/// .buttonStyle(.secondary)
/// .buttonSize(.small)  // 40pt高さ
/// ```
///
/// ## サイズ一覧
/// - **Large**: 56pt高さ - 主要なアクション（デフォルト）
/// - **Medium**: 48pt高さ - 標準的なボタン
/// - **Small**: 40pt高さ - コンパクトなレイアウト
public enum ButtonSize: Sendable {
    /// 大きいサイズ（56pt）- 主要なアクション
    case large

    /// 中程度のサイズ（48pt）- 標準的なボタン
    case medium

    /// 小さいサイズ（40pt）- コンパクトなレイアウト
    case small

    /// ボタンの高さ
    ///
    /// macOS はポインタ操作前提のため、タッチ用の大きな高さ（56/48/40）ではなく
    /// 標準コントロールに近い寸法へ縮める（HIG: 44pt は hit region の最小値であって
    /// ボタン本体サイズではない）。iOS の寸法は従来どおり維持する。
    var height: CGFloat {
        #if os(macOS)
        switch self {
        case .large: return 32
        case .medium: return 28
        case .small: return 22
        }
        #else
        switch self {
        case .large: return 56
        case .medium: return 48
        case .small: return 40
        }
        #endif
    }

    /// 水平パディング
    var horizontalPadding: CGFloat {
        #if os(macOS)
        switch self {
        case .large: return 16
        case .medium: return 12
        case .small: return 10
        }
        #else
        switch self {
        case .large: return 24
        case .medium: return 20
        case .small: return 16
        }
        #endif
    }

    /// タイポグラフィトークン
    var typography: Typography {
        switch self {
        case .large: return .labelLarge
        case .medium: return .labelMedium
        case .small: return .labelSmall
        }
    }
}

// MARK: - Environment Key

private struct ButtonSizeKey: EnvironmentKey {
    static let defaultValue: ButtonSize = .large
}

public extension EnvironmentValues {
    var buttonSize: ButtonSize {
        get { self[ButtonSizeKey.self] }
        set { self[ButtonSizeKey.self] = newValue }
    }
}

public extension View {
    /// ボタンのサイズを設定
    ///
    /// ボタンの高さ、パディング、テキストサイズを一括で変更します。
    ///
    /// - Parameter size: ボタンサイズ（`.large`, `.medium`, `.small`）
    ///
    /// ## 使用例
    /// ```swift
    /// Button("ログイン") { }
    ///     .buttonStyle(.primary)
    ///     .buttonSize(.medium)
    ///
    /// Button("小さいボタン") { }
    ///     .buttonStyle(.secondary)
    ///     .buttonSize(.small)
    /// ```
    func buttonSize(_ size: ButtonSize) -> some View {
        environment(\.buttonSize, size)
    }
}
