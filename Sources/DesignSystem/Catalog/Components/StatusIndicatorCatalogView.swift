import SwiftUI

/// StatusIndicatorコンポーネントのカタログビュー
struct StatusIndicatorCatalogView: View {
    @Environment(\.colorPalette) private var colors
    @Environment(\.spacingScale) private var spacing

    var body: some View {
        CatalogPageContainer(title: "StatusIndicator") {
            CatalogOverview(description: "非同期の作業状態（待機・実行中・完了・失敗・中断）を 1 グリフで表すインジケーター。リスト行のトレーリングやタイムラインのマーカーに使用。")

            SectionCard(title: "ステータス") {
                VStack(alignment: .leading, spacing: spacing.lg) {
                    statusRow(.pending, label: "pending", description: "開始待ち")
                    Divider()
                    statusRow(.running, label: "running", description: "実行中（ProgressView）")
                    Divider()
                    statusRow(.success, label: "success", description: "正常終了（success カラー）")
                    Divider()
                    statusRow(.failure, label: "failure", description: "失敗（error カラー）")
                    Divider()
                    statusRow(.canceled, label: "canceled", description: "中断")
                }
            }

            SectionCard(title: "リスト行での使用") {
                VStack(spacing: spacing.sm) {
                    exampleRow(title: "調査エージェント", status: .success)
                    exampleRow(title: "スクリプト実行エージェント", status: .running)
                    exampleRow(title: "ビジュアライザー", status: .pending)
                }
            }
        }
    }

    private func statusRow(_ kind: StatusKind, label: String, description: String) -> some View {
        HStack(spacing: spacing.md) {
            StatusIndicator(kind)
                .frame(width: 28)
            VStack(alignment: .leading, spacing: spacing.xxs) {
                Text(label).typography(.labelLarge).foregroundStyle(colors.onSurface)
                Text(description).typography(.bodySmall).foregroundStyle(colors.onSurfaceVariant)
            }
            Spacer()
        }
    }

    private func exampleRow(title: String, status: StatusKind) -> some View {
        HStack {
            Text(title).typography(.bodyMedium).foregroundStyle(colors.onSurface)
            Spacer()
            StatusIndicator(status)
        }
        .padding(spacing.md)
        .background(colors.elevatedSurface, in: RoundedRectangle(cornerRadius: 12))
    }
}

#Preview {
    NavigationStack {
        StatusIndicatorCatalogView()
            .theme(ThemeProvider())
    }
}
