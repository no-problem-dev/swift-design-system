import SwiftUI

/// `SectionCard` 内の 1 行。
///
/// 統一された horizontal / vertical padding を提供する HStack。
/// Button / NavigationLink のラベルとして使うことで、カード型 List 行の
/// 一貫した見た目を保つ。`contentShape(Rectangle())` が適用されているため、
/// 余白部分のタップも反応する。
///
/// ## 使用例
/// ```swift
/// SectionRow {
///     Label("通知", systemImage: "bell")
///     Spacer(minLength: 0)
///     Toggle("", isOn: $isOn).labelsHidden()
/// }
/// ```
public struct SectionRow<Content: View>: View {
    @Environment(\.spacingScale) private var spacing

    private let content: () -> Content

    /// セクション内の 1 行を生成する
    /// - Parameter content: 行の中身。HStack のように左から並ぶ
    public init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }

    public var body: some View {
        HStack(spacing: spacing.md) {
            content()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, spacing.lg)
        .padding(.vertical, spacing.md)
        .contentShape(Rectangle())
    }
}
