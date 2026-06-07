import SwiftUI

/// LinkCardコンポーネント
///
/// URL への参照（出典、関連リンク、引用元など）を 1 枚のカードで表すコンポーネント。
/// タイトル・ドメイン・任意のアクセサリ（ステータスチップ等）を表示し、
/// タップで任意のアクション（アプリ内ブラウザ表示など）を実行します。
///
/// メタデータの取得（LinkPresentation 等）は呼び出し側の責務です —
/// このコンポーネントは渡されたデータの表示だけを行います。
///
/// ## 基本的な使用例
/// ```swift
/// // シンプルなリンクカード
/// LinkCard(title: "Swift.org - Concurrency", url: url) {
///     openInBrowser(url)
/// }
///
/// // ステータス付き（出典の検証結果など）
/// LinkCard(title: "WWDC25 セッションノート", url: url) {
///     openInBrowser(url)
/// } accessory: {
///     Chip("取得済み", systemImage: "checkmark")
///         .chipStyle(.filled)
///         .chipSize(.small)
/// }
/// ```
public struct LinkCard<Accessory: View>: View {
    @Environment(\.colorPalette) private var colors
    @Environment(\.spacingScale) private var spacing
    @Environment(\.radiusScale) private var radius

    private let title: String?
    private let url: URL
    private let systemImage: String
    private let action: (() -> Void)?
    private let accessory: Accessory

    /// リンクカードを作成
    /// - Parameters:
    ///   - title: 表示タイトル。nil ならホスト名を使う
    ///   - url: 参照先 URL（ホスト名をサブタイトルとして表示）
    ///   - systemImage: 先頭アイコン（デフォルト "globe"）
    ///   - action: タップ時のアクション。nil なら静的表示
    ///   - accessory: 末尾のアクセサリビュー（ステータスチップ等）
    public init(
        title: String?,
        url: URL,
        systemImage: String = "globe",
        action: (() -> Void)? = nil,
        @ViewBuilder accessory: () -> Accessory
    ) {
        self.title = title
        self.url = url
        self.systemImage = systemImage
        self.action = action
        self.accessory = accessory()
    }

    public var body: some View {
        if let action {
            Button(action: action) { cardBody }
                .buttonStyle(.plain)
                .accessibilityLabel(displayTitle)
                .accessibilityHint("リンクを開く")
        } else {
            cardBody
        }
    }

    private var cardBody: some View {
        HStack(spacing: spacing.sm) {
            IconBadge(
                systemName: systemImage,
                size: .small,
                foregroundColor: colors.primary,
                backgroundColor: colors.primary.opacity(0.12)
            )
            VStack(alignment: .leading, spacing: spacing.xxs) {
                Text(displayTitle)
                    .typography(.labelLarge)
                    .foregroundStyle(colors.onSurface)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                if let host = url.host() {
                    Text(host)
                        .typography(.labelSmall)
                        .foregroundStyle(colors.onSurfaceVariant)
                        .lineLimit(1)
                }
            }
            Spacer(minLength: spacing.xs)
            accessory
            if action != nil {
                Image(systemName: "arrow.up.right")
                    .typography(.labelMedium)
                    .foregroundStyle(colors.onSurfaceVariant)
            }
        }
        .padding(spacing.md)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(colors.elevatedSurface, in: RoundedRectangle(cornerRadius: radius.lg, style: .continuous))
        .contentShape(RoundedRectangle(cornerRadius: radius.lg, style: .continuous))
    }

    private var displayTitle: String {
        if let title, !title.isEmpty { return title }
        return url.host() ?? url.absoluteString
    }
}

public extension LinkCard where Accessory == EmptyView {
    /// アクセサリなしのリンクカードを作成
    /// - Parameters:
    ///   - title: 表示タイトル。nil ならホスト名を使う
    ///   - url: 参照先 URL
    ///   - systemImage: 先頭アイコン（デフォルト "globe"）
    ///   - action: タップ時のアクション。nil なら静的表示
    init(
        title: String?,
        url: URL,
        systemImage: String = "globe",
        action: (() -> Void)? = nil
    ) {
        self.init(title: title, url: url, systemImage: systemImage, action: action) {
            EmptyView()
        }
    }
}

// MARK: - Previews

#Preview("Link Cards") {
    VStack(spacing: 12) {
        LinkCard(
            title: "Swift Concurrency - The Swift Programming Language",
            url: URL(string: "https://docs.swift.org/swift-book/")!
        ) {}

        LinkCard(
            title: nil,
            url: URL(string: "https://developer.apple.com/videos/")!
        ) {}

        LinkCard(
            title: "検証済みの出典",
            url: URL(string: "https://swift.org/blog/")!,
            action: {}
        ) {
            Chip("取得済み", systemImage: "checkmark")
                .chipStyle(.filled)
                .chipSize(.small)
                .foregroundColor(.green)
        }
    }
    .padding()
    .theme(ThemeProvider())
}
