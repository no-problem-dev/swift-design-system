import SwiftUI

public extension View {
    /// タイポグラフィトークンを適用する。
    ///
    /// 役割（``Typography``）を渡すと、Environment の ``TypographyScale`` で解決された
    /// サイズ・ウェイト・行間・書体が適用される。テーマが scale を差し替えればブランド固有の
    /// 型に切り替わり、未適用時は ``DefaultTypographyScale``（既存値由来）で従来と同じ見た目になる。
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
        let style = scale.style(for: role)
        return content
            .font(style.font(design: design))
            .lineSpacing(max(0, style.lineHeight - style.size))
            .tracking((style.trackingEm ?? 0) * style.size)
    }
}
