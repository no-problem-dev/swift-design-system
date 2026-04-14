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

    /// chevron 付きナビゲーションラベルを生成する
    /// - Parameters:
    ///   - title: ラベル文字列
    ///   - systemImage: 左側に表示する SF Symbols 名（省略可）
    public init(_ title: String, systemImage: String? = nil) {
        self.title = title
        self.systemImage = systemImage
    }

    public var body: some View {
        SectionRow {
            if let systemImage {
                Label(title, systemImage: systemImage)
                    .foregroundStyle(colors.onSurface)
            } else {
                Text(title)
                    .foregroundStyle(colors.onSurface)
            }
            Spacer(minLength: 0)
            Image(systemName: "chevron.right")
                .typography(.labelSmall)
                .foregroundStyle(colors.onSurfaceVariant)
        }
    }
}
