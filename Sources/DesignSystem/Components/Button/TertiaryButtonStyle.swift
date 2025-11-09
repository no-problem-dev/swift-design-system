import SwiftUI

/// ターシャリボタンスタイル
///
/// 最も控えめなボタンスタイル。背景なしでテキスト色のみのスタイルです。
/// リンクのような軽いアクションや、過度に強調したくない操作に使用します。
///
/// ## 使用例
/// ```swift
/// Button("詳細を見る") {
///     showDetail()
/// }
/// .buttonStyle(.tertiary)
///
/// Button("スキップ") {
///     skip()
/// }
/// .buttonStyle(.tertiary)
/// .buttonSize(.small)
/// ```
///
/// ## 使用シーン
/// - 詳細リンク
/// - スキップボタン
/// - オプショナルなアクション
/// - インライン操作
public struct TertiaryButtonStyle: ButtonStyle {
    @Environment(\.colorPalette) private var colorPalette
    @Environment(\.buttonSize) private var buttonSize
    @Environment(\.isEnabled) private var isEnabled
    @Environment(\.motion) private var motion

    public init() {}

    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .typography(buttonSize.typography)
            .foregroundStyle(colorPalette.primary)
            .padding(.horizontal, buttonSize.horizontalPadding)
            .frame(height: buttonSize.height)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 100)
                    .fill(Color.clear)
            )
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .opacity(isEnabled ? 1.0 : 0.6)
            .animate(motion.tap, value: configuration.isPressed)
    }
}

public extension ButtonStyle where Self == TertiaryButtonStyle {
    /// ターシャリボタンスタイル
    static var tertiary: TertiaryButtonStyle {
        TertiaryButtonStyle()
    }
}
