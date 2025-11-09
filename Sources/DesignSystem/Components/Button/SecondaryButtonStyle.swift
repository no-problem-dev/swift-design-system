import SwiftUI

/// セカンダリボタンスタイル
///
/// 補助的なアクションに使用するボタンスタイル。
/// SecondaryContainer色の背景でPrimaryより控えめに強調し、画面内に複数配置できます。
///
/// ## 使用例
/// ```swift
/// HStack {
///     Button("キャンセル") {
///         cancel()
///     }
///     .buttonStyle(.secondary)
///
///     Button("保存") {
///         save()
///     }
///     .buttonStyle(.primary)
/// }
/// ```
///
/// ## 使用シーン
/// - キャンセルボタン
/// - 代替アクション
/// - フォームのリセットボタン
public struct SecondaryButtonStyle: ButtonStyle {
    @Environment(\.colorPalette) private var colorPalette
    @Environment(\.buttonSize) private var buttonSize
    @Environment(\.isEnabled) private var isEnabled
    @Environment(\.motion) private var motion

    public init() {}

    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .typography(buttonSize.typography)
            .foregroundStyle(colorPalette.onSecondaryContainer)
            .padding(.horizontal, buttonSize.horizontalPadding)
            .frame(height: buttonSize.height)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 100)
                    .fill(colorPalette.secondaryContainer)
                    .opacity(isEnabled ? 1.0 : 0.6)
            )
            .elevation(.level1)
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .opacity(isEnabled ? 1.0 : 0.6)
            .animate(motion.tap, value: configuration.isPressed)
    }
}

public extension ButtonStyle where Self == SecondaryButtonStyle {
    /// セカンダリボタンスタイル
    static var secondary: SecondaryButtonStyle {
        SecondaryButtonStyle()
    }
}
