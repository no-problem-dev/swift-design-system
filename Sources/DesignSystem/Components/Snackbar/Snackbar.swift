import SwiftUI

/// Snackbar（一時的な通知UI）
///
/// 画面下部から表示される一時的な通知UI。
/// ユーザーのアクションに対するフィードバックや、簡単な通知を表示します。
///
/// ## 基本的な使い方
/// ```swift
/// @State private var snackbarState = SnackbarState()
///
/// var body: some View {
///     ZStack {
///         ContentView()
///
///         Snackbar(state: snackbarState)
///     }
///     .onAppear {
///         snackbarState.show(message: "保存しました")
///     }
/// }
/// ```
///
/// ## アクション付きSnackbar
/// ```swift
/// snackbarState.show(
///     message: "削除しました",
///     primaryAction: SnackbarAction(title: "元に戻す") {
///         // 元に戻す処理
///     },
///     secondaryAction: SnackbarAction(title: "閉じる") {
///         snackbarState.dismiss()
///     }
/// )
/// ```
///
/// ## デザインガイドライン
/// - メッセージは簡潔に（1-2行）
/// - アクションは最大2つまで
/// - 自動消滅時間は3-7秒が推奨
/// - 重要な操作には十分な時間を確保
public struct Snackbar: View {
    @Bindable public var state: SnackbarState
    @Environment(\.colorPalette) private var colors
    @Environment(\.spacingScale) private var spacing
    @Environment(\.radiusScale) private var radius

    public init(state: SnackbarState) {
        self._state = Bindable(state)
    }

    public var body: some View {
        VStack {
            Spacer()

            if state.isVisible {
                HStack(spacing: spacing.md) {
                    // メッセージ
                    Text(state.message)
                        .typography(.bodyLarge)
                        .foregroundStyle(colors.onSurface)
                        .lineLimit(2)
                        .fixedSize(horizontal: false, vertical: true)

                    Spacer(minLength: spacing.sm)

                    // アクションボタン
                    HStack(spacing: spacing.sm) {
                        if let primary = state.primaryAction {
                            Button {
                                Task {
                                    await primary.action()
                                }
                                state.dismiss()
                            } label: {
                                Text(primary.title)
                                    .typography(.labelLarge)
                                    .foregroundStyle(colors.primary)
                            }
                            .buttonStyle(.borderless)
                        }

                        if let secondary = state.secondaryAction {
                            Button {
                                Task {
                                    await secondary.action()
                                }
                                state.dismiss()
                            } label: {
                                Text(secondary.title)
                                    .typography(.labelLarge)
                                    .foregroundStyle(colors.error)
                            }
                            .buttonStyle(.borderless)
                        }
                    }
                }
                .padding(.horizontal, spacing.lg)
                .padding(.vertical, spacing.md)
                .background(colors.surfaceVariant)
                .clipShape(RoundedRectangle(cornerRadius: radius.md))
                .elevation(.level2)
                .padding(.horizontal, spacing.lg)
                .padding(.bottom, spacing.lg)
                .transition(.asymmetric(
                    insertion: .move(edge: .bottom).combined(with: .opacity),
                    removal: .move(edge: .bottom).combined(with: .opacity)
                ))
                .accessibilityElement(children: .contain)
                .accessibilityLabel(state.message)
            }
        }
        .animation(.spring(response: 0.3, dampingFraction: 0.8), value: state.isVisible)
    }
}
