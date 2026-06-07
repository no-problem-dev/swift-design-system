import SwiftUI

/// EmptyStateコンポーネント
///
/// リスト・グリッド・検索結果などが空のときの明示ステート。
/// アイコン + 見出し + 任意の説明文を中央寄せで表示します。
///
/// ## 基本的な使用例
/// ```swift
/// EmptyState(
///     systemImage: "link",
///     title: "出典はありません",
///     description: "Web 調査を行ったセッションでは、参照した URL がここに並びます。"
/// )
/// ```
public struct EmptyState: View {
    @Environment(\.colorPalette) private var colors
    @Environment(\.spacingScale) private var spacing

    private let systemImage: String
    private let title: String
    private let description: String?

    /// 空ステートを作成
    /// - Parameters:
    ///   - systemImage: SF Symbols のアイコン名
    ///   - title: 見出し（何が無いのか）
    ///   - description: 補足説明（どうすれば現れるのか）
    public init(systemImage: String, title: String, description: String? = nil) {
        self.systemImage = systemImage
        self.title = title
        self.description = description
    }

    public var body: some View {
        VStack(spacing: spacing.sm) {
            IconBadge(
                systemName: systemImage,
                size: .medium,
                foregroundColor: colors.onSurfaceVariant,
                backgroundColor: colors.surfaceVariant
            )
            Text(title)
                .typography(.titleMedium)
                .foregroundStyle(colors.onSurface)
                .multilineTextAlignment(.center)
            if let description {
                Text(description)
                    .typography(.bodySmall)
                    .foregroundStyle(colors.onSurfaceVariant)
                    .multilineTextAlignment(.center)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(spacing.xl)
        .accessibilityElement(children: .combine)
    }
}

// MARK: - Previews

#Preview("Empty States") {
    VStack(spacing: 32) {
        EmptyState(
            systemImage: "link",
            title: "出典はありません",
            description: "Web 調査を行ったセッションでは、参照した URL がここに並びます。"
        )
        EmptyState(
            systemImage: "photo.on.rectangle.angled",
            title: "メディアはありません"
        )
    }
    .padding()
    .theme(ThemeProvider())
}
