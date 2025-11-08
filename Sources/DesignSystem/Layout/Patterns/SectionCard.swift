import SwiftUI

/// タイトル付きカードセクション
///
/// タイトルとカード化されたコンテンツを組み合わせたレイアウトパターン。
/// 設定画面、カタログビュー、ダッシュボードなど、情報をグループ化して表示する場面で使用します。
///
/// ## 使用例
/// ```swift
/// @Environment(\.spacingScale) var spacing
///
/// ScrollView {
///     VStack(spacing: spacing.xl) {  // セクション間隔: 24pt
///         SectionCard(title: "基本設定") {
///             VStack(spacing: spacing.md) {
///                 Toggle("通知を有効化", isOn: $isNotificationEnabled)
///                 Toggle("ダークモード", isOn: $isDarkMode)
///             }
///         }
///
///         SectionCard(title: "プロフィール", elevation: .level2) {
///             VStack(alignment: .leading) {
///                 Text("名前: 山田太郎")
///                 Text("メール: yamada@example.com")
///             }
///         }
///     }
///     // .padding(.horizontal) は不要 - SectionCardが管理
/// }
/// ```
///
/// ## スペーシング
/// - タイトル-コンテンツ間: `spacing.md` (12pt)
/// - 左右パディング: `spacing.lg` (16pt) - 自動適用
///
/// ## 使用シーン
/// - 設定画面のセクション分け
/// - ダッシュボードのウィジェット配置
/// - フォームのグループ化
/// - カタログビューの項目表示
public struct SectionCard<Content: View>: View {
    @Environment(\.colorPalette) private var colorPalette
    @Environment(\.spacingScale) private var spacing

    private let title: String
    private let content: Content
    private let elevation: Elevation

    /// タイトル付きカードセクションを作成
    /// - Parameters:
    ///   - title: セクションタイトル
    ///   - elevation: カードの elevation レベル（デフォルト: .level1）
    ///   - content: カード内に表示するコンテンツ
    public init(
        title: String,
        elevation: Elevation = .level1,
        @ViewBuilder content: () -> Content
    ) {
        self.title = title
        self.elevation = elevation
        self.content = content()
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: spacing.md) {
            Text(title)
                .typography(.titleMedium)
                .foregroundStyle(colorPalette.onSurface)

            Card(elevation: elevation) {
                content
            }
        }
        .padding(.horizontal, spacing.lg)
    }
}

#Preview {
    @Previewable @Environment(\.spacingScale) var spacing

    ScrollView {
        VStack(spacing: spacing.xl) {
            SectionCard(title: "基本情報") {
                VStack(alignment: .leading, spacing: spacing.md) {
                    Text("名前: 山田太郎")
                        .typography(.bodyMedium)
                    Text("メール: yamada@example.com")
                        .typography(.bodyMedium)
                }
            }

            SectionCard(title: "設定", elevation: .level2) {
                VStack(spacing: spacing.lg) {
                    HStack {
                        Text("通知")
                        Spacer()
                        Text("ON")
                            .foregroundStyle(.secondary)
                    }
                    .typography(.bodyMedium)

                    HStack {
                        Text("ダークモード")
                        Spacer()
                        Text("OFF")
                            .foregroundStyle(.secondary)
                    }
                    .typography(.bodyMedium)
                }
            }
        }
        .padding(.vertical, spacing.xl)
    }
    .theme(ThemeProvider())
}
