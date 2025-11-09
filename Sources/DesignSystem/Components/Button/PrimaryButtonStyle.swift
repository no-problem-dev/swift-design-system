import SwiftUI

/// プライマリボタンスタイル
///
/// 最も強調されるボタンスタイル。画面内の主要なアクション（ログイン、送信、保存など）に使用します。
/// Primary色の背景に白色のテキストを配置し、押下時にスケールアニメーションが適用されます。
///
/// ## 使用例
/// ```swift
/// Button("ログイン") {
///     login()
/// }
/// .buttonStyle(.primary)
/// .buttonSize(.large)  // サイズ指定（オプション）
///
/// Button("保存") {
///     save()
/// }
/// .buttonStyle(.primary)
/// .buttonSize(.medium)
/// ```
///
/// ## スタイルの使い分け
/// - **Primary**: 最重要アクション（1画面に1つ推奨）
/// - **Secondary**: 補助的なアクション
/// - **Tertiary**: 控えめなアクション
public struct PrimaryButtonStyle: ButtonStyle {
    @Environment(\.colorPalette) private var colorPalette
    @Environment(\.buttonSize) private var buttonSize
    @Environment(\.isEnabled) private var isEnabled
    @Environment(\.motion) private var motion

    public init() {}

    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .typography(buttonSize.typography)
            .foregroundStyle(colorPalette.onPrimary)
            .padding(.horizontal, buttonSize.horizontalPadding)
            .frame(height: buttonSize.height)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 100)
                    .fill(colorPalette.primary)
                    .opacity(isEnabled ? 1.0 : 0.6)
            )
            .elevation(.level2)
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .opacity(isEnabled ? 1.0 : 0.6)
            .animate(motion.tap, value: configuration.isPressed)
    }
}

public extension ButtonStyle where Self == PrimaryButtonStyle {
    /// プライマリボタンスタイル
    static var primary: PrimaryButtonStyle {
        PrimaryButtonStyle()
    }
}
