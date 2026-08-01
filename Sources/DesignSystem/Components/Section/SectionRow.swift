import SwiftUI

/// `SectionCard` 内の 1 行。
///
/// 統一された horizontal / vertical padding と、行の骨格（最小高・先頭アイコン列の幅）を
/// 提供する HStack。Button / NavigationLink のラベルとして使うことで、カード型 List 行の
/// 一貫した見た目を保つ。`contentShape(Rectangle())` が適用されているため、
/// 余白部分のタップも反応する。
///
/// ## 使用例
/// ```swift
/// SectionRow {
///     SectionRowLabel("通知", systemImage: "bell")
///     Spacer(minLength: 0)
///     Toggle("", isOn: $isOn).labelsHidden()
/// }
/// ```
///
/// ## 行をまたいで揃える
/// 先頭に ``SectionRowLabel`` を置くと、アイコンの有無にかかわらずラベルの左端が縦に揃う。
/// `Label` を直接置いた場合もアイコン列の幅は固定されるが、アイコンの無い行は
/// 列を空けないため左端が揃わない。揃えたい行は ``SectionRowLabel`` にする。
public struct SectionRow<Content: View>: View {
    @Environment(\.iconSizeScale) private var iconSize
    @Environment(\.spacingScale) private var spacing
    @ScaledMetric(relativeTo: .body) private var typeScale: CGFloat = 1

    private let content: () -> Content

    /// セクション内の 1 行を生成する
    /// - Parameter content: 行の中身。HStack のように左から並ぶ
    public init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }

    public var body: some View {
        let metrics = SectionRowMetrics(iconSize: iconSize, spacing: spacing, typeScale: typeScale)
        HStack(spacing: spacing.md) {
            content()
        }
        .labelStyle(SectionRowLabelStyle(metrics: metrics))
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, spacing.lg)
        .padding(.vertical, spacing.md)
        // 最小高は padding の外に掛ける。内側だと padding のぶんだけ行が余分に伸びる
        .frame(minHeight: metrics.minHeight)
        .contentShape(Rectangle())
    }
}
