import SwiftUI

/// カタログの情報セクションビュー
struct InfoSectionView: View {
    @Environment(\.colorPalette) private var colors
    @Environment(\.spacingScale) private var spacing

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("情報")
                .typography(.titleMedium)
                .foregroundStyle(colors.onSurface)
                .padding(.horizontal, spacing.lg)

            VStack(spacing: 0) {
                InfoRow(label: "プラットフォーム", value: "iOS 17+, macOS 14+")
                Divider().padding(.leading, 16)
                InfoLinkRow(
                    label: "リポジトリ",
                    value: "GitHub",
                    url: "https://github.com/no-problem-dev/swift-design-system"
                )
                Divider().padding(.leading, 16)
                InfoLinkRow(
                    label: "ドキュメント",
                    value: "DocC",
                    url: "https://no-problem-dev.github.io/swift-design-system/documentation/designsystem/"
                )
            }
            .background(colors.surface)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .shadow(color: .black.opacity(0.03), radius: 4, y: 2)
            .padding(.horizontal, spacing.lg)
        }
    }
}
