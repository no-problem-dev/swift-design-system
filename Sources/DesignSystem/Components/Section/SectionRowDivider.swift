import SwiftUI

/// `SectionCard` 内の行と行のあいだに挿入する 0.5pt のヘアライン区切り。
///
/// `outlineVariant` カラー（outline の半透明）を使い、カードの surface 上で
/// 控えめに行を分割する。左側に `spacing.lg` の inset を持ち、List の
/// セパレータと同じ視覚バランスになる。
///
/// ## 使用例
/// ```swift
/// SectionCard("設定") {
///     SectionRow { Text("項目 1") }
///     SectionRowDivider()
///     SectionRow { Text("項目 2") }
/// }
/// ```
public struct SectionRowDivider: View {
    @Environment(\.colorPalette) private var colors
    @Environment(\.spacingScale) private var spacing

    public init() {}

    public var body: some View {
        Rectangle()
            .fill(colors.outlineVariant)
            .frame(height: 0.5)
            .padding(.leading, spacing.lg)
    }
}
