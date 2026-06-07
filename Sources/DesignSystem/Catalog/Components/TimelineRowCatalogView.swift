import SwiftUI

/// TimelineRowコンポーネントのカタログビュー
struct TimelineRowCatalogView: View {
    @Environment(\.colorPalette) private var colors
    @Environment(\.spacingScale) private var spacing

    var body: some View {
        CatalogPageContainer(title: "TimelineRow") {
            CatalogOverview(description: "時系列フィード（アクティビティログ・進行ステップ・変更履歴）の 1 行。VStack(spacing: 0) に並べるとコネクタ線が連続したタイムラインになる。")

            SectionCard(title: "ステータスマーカー") {
                VStack(spacing: 0) {
                    TimelineRow(status: .success, isFirst: true) {
                        entry(title: "Web を検索", detail: "query: SwiftUI 状態管理")
                    }
                    TimelineRow(status: .success) {
                        entry(title: "3 件のページを取得", detail: "docs.swift.org ほか")
                    }
                    TimelineRow(status: .running) {
                        entry(title: "要約を生成中…", detail: nil)
                    }
                    TimelineRow(status: .pending, isLast: true) {
                        entry(title: "回答をまとめる", detail: nil)
                    }
                }
            }

            SectionCard(title: "カスタムマーカー") {
                VStack(spacing: 0) {
                    TimelineRow(isFirst: true) {
                        IconBadge(systemName: "magnifyingglass", size: .small)
                    } content: {
                        entry(title: "調査エージェント", detail: "出典 5 件を収集")
                    }
                    TimelineRow {
                        IconBadge(systemName: "photo.on.rectangle.angled", size: .small)
                    } content: {
                        entry(title: "ビジュアライザー", detail: "チャート画像を生成")
                    }
                    TimelineRow(isLast: true) {
                        IconBadge(systemName: "paintbrush", size: .small)
                    } content: {
                        entry(title: "A2UI エージェント", detail: "サーフェスを描画")
                    }
                }
            }

            SectionCard(title: "リッチコンテンツ") {
                VStack(spacing: 0) {
                    TimelineRow(status: .success, isFirst: true) {
                        VStack(alignment: .leading, spacing: spacing.xs) {
                            entry(title: "出典を検証", detail: nil)
                            HStack(spacing: spacing.xs) {
                                Chip("取得済み 4", systemImage: "checkmark")
                                    .chipStyle(.filled)
                                    .chipSize(.small)
                                    .foregroundColor(.green)
                                Chip("失敗 1", systemImage: "xmark")
                                    .chipStyle(.filled)
                                    .chipSize(.small)
                                    .foregroundColor(.red)
                            }
                        }
                    }
                    TimelineRow(status: .success, isLast: true) {
                        entry(title: "完了", detail: nil)
                    }
                }
            }
        }
    }

    private func entry(title: String, detail: String?) -> some View {
        VStack(alignment: .leading, spacing: spacing.xxs) {
            Text(title).typography(.bodyMedium).foregroundStyle(colors.onSurface)
            if let detail {
                Text(detail).typography(.labelSmall).foregroundStyle(colors.onSurfaceVariant)
            }
        }
    }
}

#Preview {
    NavigationStack {
        TimelineRowCatalogView()
            .theme(ThemeProvider())
    }
}
