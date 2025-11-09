import SwiftUI

/// Filled Chipスタイル
///
/// 塗りつぶし背景を持つChipスタイルです。ステータス表示、カテゴリラベル、
/// 固定的な情報表示に適しています。
///
/// ## 使用例
/// ```swift
/// Chip("Active", systemImage: "circle.fill")
///     .chipStyle(.filled)
///     .foregroundColor(.green)
///
/// Chip("Premium", systemImage: "star.fill")
///     .chipStyle(.filled)
///     .foregroundColor(.orange)
/// ```
///
/// ## 視覚的特徴
/// - 背景: セマンティックカラーの10%不透明度
/// - テキスト: セマンティックカラー（フル不透明度）
/// - 角丸: デザインシステムのradiusScale.xs
/// - 選択時: 背景不透明度が20%に増加
public struct FilledChipStyle: ChipStyle, Sendable {
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
            backgroundOpacity(for: configuration)
        )
        .clipShape(Capsule())
        .scaleEffect(configuration.isPressed ? 0.96 : 1.0)
        .animate(configuration.motion.tap, value: configuration.isPressed)
        .animate(configuration.motion.toggle, value: configuration.isSelected)
    }

    private func backgroundOpacity(for configuration: ChipStyleConfiguration) -> some ShapeStyle {
        configuration.colorPalette.primary.opacity(configuration.isSelected ? 0.2 : 0.1)
    }
}

public extension ChipStyle where Self == FilledChipStyle {
    /// Filled Chipスタイル
    static var filled: FilledChipStyle {
        FilledChipStyle()
    }
}
