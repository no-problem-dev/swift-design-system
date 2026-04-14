import SwiftUI

/// 設定画面・ハブ画面の Section 相当の角丸 surface カード。
///
/// `List { Section { ... } }` と同等の視覚階層を、DS トークン
/// （surface / spacing / typography / radius）だけで構成する。
///
/// ## 2 種類の使い方
///
/// ### 1. Surface Section（推奨、新 API）
/// 小さな uppercase ヘッダー + 角丸 surface カード + footer 説明文。
/// 内部は `SectionRow` を縦に並べ、必要に応じて `SectionRowDivider` を挟む。
///
/// ```swift
/// SectionCard("通知", footer: "通知センターの設定はシステム設定から") {
///     SectionRow {
///         Text("朝のリマインド")
///         Spacer(minLength: 0)
///         Toggle("", isOn: $isOn).labelsHidden()
///     }
///     SectionRowDivider()
///     NavigationLink(destination: DetailView()) {
///         SectionNavigationLabel("詳細", systemImage: "gear")
///     }
/// }
/// ```
///
/// ### 2. Titled Card（従来 API、互換維持）
/// タイトル + `Card` でラップされた汎用コンテナ。フォーム・ダッシュボードなど
/// 自由配置のレイアウトに。
///
/// ```swift
/// SectionCard(title: "プロフィール", elevation: .level2) {
///     VStack(alignment: .leading) {
///         Text("名前: 山田太郎")
///         Text("メール: yamada@example.com")
///     }
/// }
/// ```
public struct SectionCard<Content: View>: View {
    @Environment(\.colorPalette) private var colors
    @Environment(\.spacingScale) private var spacing
    @Environment(\.radiusScale) private var radius

    private let style: Style
    private let content: () -> Content

    private enum Style {
        case surface(header: String?, footer: String?)
        case titled(title: String, elevation: Elevation)
    }

    /// Surface Section スタイル（新 API）。
    ///
    /// - Parameters:
    ///   - header: カード外側のヘッダーラベル（大文字化、`nil` 指定で非表示）
    ///   - footer: カード外側の説明文
    ///   - content: カード内部のコンテンツ。通常は `SectionRow` を縦に並べる
    public init(
        _ header: String? = nil,
        footer: String? = nil,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.style = .surface(header: header, footer: footer)
        self.content = content
    }

    /// Titled Card スタイル（従来 API、互換維持用）。
    ///
    /// - Parameters:
    ///   - title: セクションタイトル
    ///   - elevation: カードの elevation レベル（デフォルト `.level1`）
    ///   - content: カード内に表示するコンテンツ
    public init(
        title: String,
        elevation: Elevation = .level1,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.style = .titled(title: title, elevation: elevation)
        self.content = content
    }

    public var body: some View {
        switch style {
        case let .surface(header, footer):
            VStack(alignment: .leading, spacing: spacing.xs) {
                if let header {
                    Text(header)
                        .typography(.labelSmall)
                        .foregroundStyle(colors.onSurfaceVariant)
                        .textCase(.uppercase)
                        .padding(.horizontal, spacing.md)
                }

                VStack(spacing: 0) {
                    content()
                }
                .background(colors.surface)
                .clipShape(RoundedRectangle(cornerRadius: radius.lg))

                if let footer {
                    Text(footer)
                        .typography(.labelSmall)
                        .foregroundStyle(colors.onSurfaceVariant)
                        .padding(.horizontal, spacing.md)
                }
            }

        case let .titled(title, elevation):
            VStack(alignment: .leading, spacing: spacing.md) {
                Text(title)
                    .typography(.titleMedium)
                    .foregroundStyle(colors.onSurface)

                Card(elevation: elevation) {
                    content()
                }
            }
            .padding(.horizontal, spacing.lg)
        }
    }
}

#Preview("Surface Section") {
    @Previewable @Environment(\.spacingScale) var spacing

    ScrollView {
        VStack(spacing: spacing.xl) {
            SectionCard("通知", footer: "通知センターの設定はシステム設定から") {
                SectionRow {
                    Text("朝のリマインド")
                    Spacer(minLength: 0)
                    Text("ON").foregroundStyle(.secondary)
                }
                SectionRowDivider()
                SectionRow {
                    SectionNavigationLabel("通知の詳細設定", systemImage: "gear")
                }
            }

            SectionCard("アカウント") {
                SectionRow {
                    Text("メール")
                    Spacer(minLength: 0)
                    Text("user@example.com").foregroundStyle(.secondary)
                }
            }
        }
        .padding(.vertical, spacing.xl)
    }
    .theme(ThemeProvider())
}

#Preview("Titled Card") {
    @Previewable @Environment(\.spacingScale) var spacing

    ScrollView {
        VStack(spacing: spacing.xl) {
            SectionCard(title: "基本情報") {
                VStack(alignment: .leading, spacing: spacing.md) {
                    Text("名前: 山田太郎").typography(.bodyMedium)
                    Text("メール: yamada@example.com").typography(.bodyMedium)
                }
            }
        }
        .padding(.vertical, spacing.xl)
    }
    .theme(ThemeProvider())
}
