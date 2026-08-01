import SwiftUI

/// セクション行の骨格。
///
/// アイコンの寸法（``IconSizeScale``）とテキストの寸法（``TypographyScale``）は
/// 別々に決まるため、行が中身の合成結果に任せていると記号の字幅の違いがそのまま
/// ラベルの左端のずれになる。骨格をここで導出し、``SectionRow`` と
/// ``SectionRowLabel`` が同じ値を使うことで行をまたいで縦に揃う。
struct SectionRowMetrics {
    /// 先頭アイコン列の幅。
    ///
    /// SF Symbol の字幅は記号ごとに違うので、列の幅を固定してアイコンを中央に置く。
    /// 値は ``LinkCard`` の先頭 ``IconBadge``（`.small` = 32pt）と揃えてあり、
    /// 行の horizontal padding と合わせるとラベルの左端が 56pt になる。
    let iconColumnWidth: CGFloat

    /// アイコン列とラベルのあいだ。``LinkCard`` と同じ。
    let iconGap: CGFloat

    /// 先頭アイコンの字面サイズ。列より一回り小さく取り、字幅の広い記号でも列に収まる。
    let iconGlyphSize: CGFloat

    /// 行の最小高。小さい文字だけの行でも最小タップ領域を割らない。
    let minHeight: CGFloat

    /// - Parameter typeScale: 本文の Dynamic Type 倍率。Environment 由来のトークンは
    ///   `@ScaledMetric` の基準値にできないため、倍率だけを受け取って掛ける
    init(iconSize: any IconSizeScale, spacing: any SpacingScale, typeScale: CGFloat) {
        iconColumnWidth = iconSize.lg * typeScale
        iconGap = spacing.sm
        iconGlyphSize = iconSize.sm * typeScale
        // 文字を縮めた設定でも 44pt は割らせない
        minHeight = ControlTokens.minTouchTarget * max(1, typeScale)
    }
}

/// ``SectionRow`` が中身の `Label` に配る、先頭アイコン列を固定するスタイル。
///
/// `SectionRow { Label(...) }` と書かれた既存のコードを書き換えずに骨格を効かせるため、
/// 行が自分の subtree へこのスタイルを流す。
struct SectionRowLabelStyle: LabelStyle {
    let metrics: SectionRowMetrics

    func makeBody(configuration: Configuration) -> some View {
        HStack(spacing: metrics.iconGap) {
            configuration.icon
                .frame(width: metrics.iconColumnWidth)
            configuration.title
        }
    }
}
