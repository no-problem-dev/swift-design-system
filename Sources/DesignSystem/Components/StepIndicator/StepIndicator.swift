import SwiftUI

/// StepIndicatorコンポーネント
///
/// 一方向に進む N ステップの現在位置をドット列で表すミニインジケーター。
/// 現在のステップは `primary`、通過したステップは薄い `primary`、
/// 未来のステップは `outlineVariant` で塗られます。
///
/// ## 基本的な使用例
/// ```swift
/// // 3 ステップ中 2 番目（index 1）が進行中
/// StepIndicator(stepCount: 3, currentIndex: 1)
///
/// // 全ステップ終了（nil = 進行中の位置なし）
/// StepIndicator(stepCount: 3, currentIndex: nil)
/// ```
///
/// アクセシビリティラベルは「ステップ 2 / 3」の形式で自動生成されます。
/// ステップに固有の名前がある場合は `accessibilityText` で上書きしてください。
public struct StepIndicator: View {
    @Environment(\.colorPalette) private var colors
    @Environment(\.spacingScale) private var spacing
    @Environment(\.motion) private var motion

    private let stepCount: Int
    private let currentIndex: Int?
    private let accessibilityText: String?
    private let dotDiameter: CGFloat

    /// ステップインジケーターを作成
    /// - Parameters:
    ///   - stepCount: ステップ総数
    ///   - currentIndex: 現在のステップ（0 始まり）。nil = 全ステップ終了
    ///   - accessibilityText: アクセシビリティラベルの上書き（nil なら「ステップ N / M」）
    ///   - dotDiameter: ドット径（デフォルト 6pt）
    public init(
        stepCount: Int,
        currentIndex: Int?,
        accessibilityText: String? = nil,
        dotDiameter: CGFloat = 6
    ) {
        self.stepCount = stepCount
        self.currentIndex = currentIndex
        self.accessibilityText = accessibilityText
        self.dotDiameter = dotDiameter
    }

    public var body: some View {
        HStack(spacing: spacing.xs) {
            ForEach(0..<stepCount, id: \.self) { index in
                Circle()
                    .fill(color(for: index))
                    .frame(width: dotDiameter, height: dotDiameter)
            }
        }
        .animate(motion.toggle, value: currentIndex)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(accessibilityText ?? defaultAccessibilityText)
    }

    private func color(for index: Int) -> Color {
        guard let currentIndex else { return colors.outlineVariant }
        if index < currentIndex { return colors.primary.opacity(0.35) }
        if index == currentIndex { return colors.primary }
        return colors.outlineVariant
    }

    private var defaultAccessibilityText: String {
        guard let currentIndex else { return "完了" }
        return "ステップ \(currentIndex + 1) / \(stepCount)"
    }
}

// MARK: - Previews

#Preview("Step Indicator") {
    VStack(spacing: 24) {
        StepIndicator(stepCount: 3, currentIndex: 0)
        StepIndicator(stepCount: 3, currentIndex: 1)
        StepIndicator(stepCount: 3, currentIndex: 2)
        StepIndicator(stepCount: 3, currentIndex: nil)
        StepIndicator(stepCount: 5, currentIndex: 2, dotDiameter: 8)
    }
    .padding()
    .theme(ThemeProvider())
}
