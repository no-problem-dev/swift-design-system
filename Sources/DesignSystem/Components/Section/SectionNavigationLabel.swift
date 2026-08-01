import SwiftUI

/// 末尾に chevron を持つナビゲーション行のラベル。
///
/// `NavigationLink { ... } label: { SectionNavigationLabel("title") }` の形で使う。
/// 内部で `SectionRow` を生成するため、`SectionCard` 内で直接配置できる。
///
/// ## 使用例
/// ```swift
/// SectionCard("設定") {
///     NavigationLink {
///         NotificationSettingsView()
///     } label: {
///         SectionNavigationLabel("通知の詳細設定", systemImage: "bell.badge")
///     }
/// }
/// ```
public struct SectionNavigationLabel: View {
    @Environment(\.colorPalette) private var colors

    private let title: String
    private let systemImage: String?
    private let subtitle: String?

    /// chevron 付きナビゲーションラベルを生成する
    /// - Parameters:
    ///   - title: ラベル文字列
    ///   - systemImage: 左側に表示する SF Symbols 名（省略可）
    ///   - subtitle: タイトルの下に置く補足（省略可）
    public init(_ title: String, systemImage: String? = nil, subtitle: String? = nil) {
        self.title = title
        self.systemImage = systemImage
        self.subtitle = subtitle
    }

    public var body: some View {
        SectionRow {
            SectionRowLabel(title, systemImage: systemImage, subtitle: subtitle)
            Spacer(minLength: 0)
            Image(systemName: "chevron.right")
                .typography(.labelSmall)
                .foregroundStyle(colors.onSurfaceVariant)
        }
    }
}
