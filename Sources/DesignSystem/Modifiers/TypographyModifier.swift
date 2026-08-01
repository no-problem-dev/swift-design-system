import SwiftUI

public extension View {
    /// タイポグラフィトークンを適用する。
    ///
    /// 役割（``Typography``）を渡すと、Environment の ``TypographyScale`` で解決された
    /// サイズ・ウェイト・行間・書体が適用される。テーマが scale を差し替えればブランド固有の
    /// 型に切り替わり、未適用時は ``DefaultTypographyScale``（既存値由来）で従来と同じ見た目になる。
    ///
    /// サイズは ``Typography/relativeTextStyle`` を基準に Dynamic Type で伸縮する。
    /// 行間・字間もそのサイズから引き直すため、文字だけが大きくなって行が詰まることはない。
    ///
    /// 解決には Environment 参照が要るため軽量 View ``TypographyStyledView`` でラップする。
    /// `ViewModifier` を使わないのは、その `body(content:)` が `@MainActor` isolated になり
    /// Sendable closure（PhotosPicker 等）からの呼び出しで "non-Sendable result" エラーを
    /// 起こすため。View の構築自体は nonisolated なので Sendable closure でも安全。
    ///
    /// ```swift
    /// Text("見出し").typography(.headlineLarge)
    /// Text("見出し").typography(.headlineLarge, design: .serif)
    /// ```
    func typography(_ token: Typography, design: Font.Design? = nil) -> some View {
        TypographyStyledView(role: token, design: design, content: self)
    }
}

/// `.typography(_:)` の解決を担う内部 View。Environment の scale を読んで適用する。
private struct TypographyStyledView<Content: View>: View {
    let role: Typography
    let design: Font.Design?
    let content: Content
    @Environment(\.typographyScale) private var scale

    var body: some View {
        ScaledTypographyView(
            style: scale.style(for: role),
            textStyle: role.relativeTextStyle,
            design: design,
            content: content
        )
    }
}

/// 解決済みスタイルに Dynamic Type の倍率を掛ける内部 View。
///
/// `@ScaledMetric` は基準値と相対先を init で受け取るが、基準値は Environment の
/// ``TypographyScale`` から解決するので親でしか読めない。そのため解決とスケールを
/// 親子に分ける。
///
/// 倍率は `.system` と `.named`（ブランド書体）で共通に掛ける。`Font.custom` の
/// `relativeTo:` に任せると `.system` 側に同じ手段が無く、行間・字間を引き直すための
/// 実サイズも手元に残らない。
private struct ScaledTypographyView<Content: View>: View {
    private let style: TypeStyle
    private let design: Font.Design?
    private let content: Content
    @ScaledMetric private var size: CGFloat

    init(style: TypeStyle, textStyle: Font.TextStyle, design: Font.Design?, content: Content) {
        self.style = style
        self.design = design
        self.content = content
        _size = ScaledMetric(wrappedValue: style.size, relativeTo: textStyle)
    }

    var body: some View {
        content
            .font(style.fontResource.font(size: size, weight: style.weight, design: design))
            .lineSpacing(max(0, size * style.leadingMultiplier - size))
            .tracking((style.trackingEm ?? 0) * size)
    }
}
