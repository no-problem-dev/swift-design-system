import SwiftUI

/// Outlined Chipスタイル
///
/// 境界線のみを持つChipスタイルです。フィルター選択、セカンダリカテゴリ、
/// 控えめな情報表示に適しています。
///
/// ## 使用例
/// ```swift
/// Chip("Filter", systemImage: "line.3.horizontal.decrease", isSelected: $isFiltered)
///     .chipStyle(.outlined)
///
/// Chip("Category", systemImage: "tag")
///     .chipStyle(.outlined)
///     .foregroundColor(.blue)
/// ```
///
/// ## 視覚的特徴
/// - 背景: 透明（選択時は10%不透明度）
/// - 境界線: 1.5pt、outline color
/// - テキスト: セマンティックカラー
/// - 角丸: デザインシステムのradiusScale.xs
/// - 選択時: 背景と境界線の色が強調される
public struct OutlinedChipStyle: ChipStyle, Sendable {
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
                .fontWeight(.medium)

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
        .background(
            configuration.isSelected
                ? Color.primary.opacity(0.1)
                : Color.clear
        )
        .clipShape(Capsule())
        .overlay(
            Capsule()
                .strokeBorder(
                    configuration.isSelected
                        ? Color.primary
                        : configuration.colorPalette.outline,
                    lineWidth: 1.5
                )
        )
        .scaleEffect(configuration.isPressed ? 0.96 : 1.0)
        .animate(configuration.motion.tap, value: configuration.isPressed)
        .animate(configuration.motion.toggle, value: configuration.isSelected)
    }
}

public extension ChipStyle where Self == OutlinedChipStyle {
    /// Outlined Chipスタイル
    static var outlined: OutlinedChipStyle {
        OutlinedChipStyle()
    }
}
