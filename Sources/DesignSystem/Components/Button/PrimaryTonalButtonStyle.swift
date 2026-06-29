import SwiftUI

/// Primaryの色相を保った控えめなボタンスタイル。
///
/// 主要導線に関連する補助アクションなど、Primaryと親和性を持たせたいが
/// 塗りの Primary ほど強くしたくない操作に使う。
public struct PrimaryTonalButtonStyle: ButtonStyle {
    @Environment(\.colorPalette) private var colorPalette
    @Environment(\.buttonSize) private var buttonSize
    @Environment(\.isEnabled) private var isEnabled
    @Environment(\.motion) private var motion

    public init() {}

    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .typography(buttonSize.typography)
            .foregroundStyle(colorPalette.onPrimaryContainer)
            .padding(.horizontal, buttonSize.horizontalPadding)
            .frame(height: buttonSize.height)
            .frame(maxWidth: .infinity)
            .background {
                RoundedRectangle(cornerRadius: 100)
                    .fill(colorPalette.primaryContainer)
                    .overlay {
                        RoundedRectangle(cornerRadius: 100)
                            .stroke(colorPalette.primary.opacity(0.18), lineWidth: 1)
                    }
                    .opacity(isEnabled ? 1.0 : 0.6)
            }
            .elevation(.level1)
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .opacity(isEnabled ? 1.0 : 0.6)
            .animate(motion.tap, value: configuration.isPressed)
    }
}

public extension ButtonStyle where Self == PrimaryTonalButtonStyle {
    /// Primaryの色相を保った控えめなボタンスタイル。
    static var primaryTonal: PrimaryTonalButtonStyle {
        PrimaryTonalButtonStyle()
    }
}
