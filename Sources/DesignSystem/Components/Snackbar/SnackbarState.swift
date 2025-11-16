import SwiftUI

/// Snackbarの表示状態を管理するObservableオブジェクト
///
/// Snackbarの表示・非表示、自動消滅タイマーなどの状態を一元管理します。
///
/// ## 使用例
/// ```swift
/// @State private var snackbarState = SnackbarState()
///
/// // Snackbarを表示
/// snackbarState.show(
///     message: "保存しました",
///     duration: 3.0
/// )
///
/// // アクション付きで表示
/// snackbarState.show(
///     message: "削除しました",
///     primaryAction: SnackbarAction(title: "元に戻す") {
///         // 元に戻す処理
///     },
///     duration: 5.0
/// )
/// ```
@MainActor
@Observable
public final class SnackbarState {
    /// Snackbarが表示されているかどうか
    public private(set) var isVisible: Bool = false

    /// 表示するメッセージ
    public private(set) var message: String = ""

    /// プライマリアクション（メインアクションボタン）
    public private(set) var primaryAction: SnackbarAction?

    /// セカンダリアクション（補助アクションボタン）
    public private(set) var secondaryAction: SnackbarAction?

    /// 自動消滅タイマー
    private var dismissTask: Task<Void, Never>?

    public init() {}

    /// Snackbarを表示する
    ///
    /// - Parameters:
    ///   - message: 表示するメッセージ
    ///   - primaryAction: プライマリアクション（オプション）
    ///   - secondaryAction: セカンダリアクション（オプション）
    ///   - duration: 自動消滅までの秒数（デフォルト: 5秒）
    public func show(
        message: String,
        primaryAction: SnackbarAction? = nil,
        secondaryAction: SnackbarAction? = nil,
        duration: TimeInterval = 5.0
    ) {
        // 既存のタイマーをキャンセル
        dismissTask?.cancel()

        // 状態を更新
        self.message = message
        self.primaryAction = primaryAction
        self.secondaryAction = secondaryAction
        self.isVisible = true

        // 自動消滅タイマーをセット
        dismissTask = Task {
            try? await Task.sleep(nanoseconds: UInt64(duration * 1_000_000_000))
            if !Task.isCancelled {
                self.dismiss()
            }
        }
    }

    /// Snackbarを非表示にする
    public func dismiss() {
        dismissTask?.cancel()
        isVisible = false
    }
}

/// Snackbarのアクションボタン
public struct SnackbarAction {
    /// アクションボタンのタイトル
    public let title: String

    /// アクションが実行されたときのハンドラ
    public let action: @MainActor () async -> Void

    public init(title: String, action: @escaping @MainActor () async -> Void) {
        self.title = title
        self.action = action
    }
}
