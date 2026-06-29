import SwiftUI

/// Liquid Glass Chip スタイル
///
/// Liquid Glass デザイン言語に基づく半透明の Chip スタイル。
/// iOS 26 以降の `.glassEffect()` API を使い、プレミアム感のある表現を提供する。
///
/// ## 使用例
/// ```swift
/// Chip("Premium", systemImage: "star.fill")
///     .chipStyle(.liquidGlass)
///     .foregroundColor(.yellow)
///
/// Chip("Featured", systemImage: "sparkles")
///     .chipStyle(.liquidGlass)
///     .foregroundColor(.purple)
/// ```
///
/// ## 視覚的特徴
/// - 背景: Liquid Glass effect（`.glassEffect()`）
/// - 動的適応: 周囲のコンテンツに基づいて色が変化
/// - インタラクティブ: タッチに反応する半透明エフェクト
/// - アニメーション: スムーズなタップフィードバック
///
/// ## システム要件
/// - iOS 26.0+
/// - macOS 26.0+
@available(iOS 26.0, macOS 26.0, *)
public struct LiquidGlassChipStyle: ChipStyle, Sendable {
    public init() {}

    public func makeBody(configuration: ChipStyleConfiguration) -> some View {
        HStack(spacing: configuration.spacingScale.xs) {
            // Leading icon
            if let icon = configuration.icon {
                icon
                    .font(.system(size: configuration.size.iconSize))
            }

            // Label
            configuration.label
                .typography(configuration.size.typography)
                .fontWeight(.semibold)

            // Delete button
            if let onDelete = configuration.onDelete {
                Button(action: onDelete) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: configuration.size.iconSize))
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, configuration.size.horizontalPadding)
        .padding(.vertical, configuration.size.verticalPadding)
        .frame(height: configuration.size.height)
        .background {
            Capsule()
                .fill(.clear)
                .glassEffect(.regular.interactive(true))
                .overlay {
                    if configuration.isSelected {
                        Capsule()
                            .fill(Color.primary.opacity(0.15))
                    }
                }
        }
        .scaleEffect(configuration.isPressed ? 0.96 : 1.0)
        .animate(configuration.motion.tap, value: configuration.isPressed)
        .animate(configuration.motion.toggle, value: configuration.isSelected)
    }
}

@available(iOS 26.0, macOS 26.0, *)
public extension ChipStyle where Self == LiquidGlassChipStyle {
    /// Liquid Glass Chipスタイル
    static var liquidGlass: LiquidGlassChipStyle {
        LiquidGlassChipStyle()
    }
}
