import SwiftUI

/// タイポグラフィを適用するViewModifier
struct TypographyModifier: ViewModifier {
    let token: Typography
    let design: Font.Design?

    func body(content: Content) -> some View {
        content
            .font(design.map { token.font(design: $0) } ?? token.font)
            .lineSpacing(token.lineHeight - token.size)
    }
}

public extension View {
    /// タイポグラフィトークンを適用
    ///
    /// ```swift
    /// Text("見出し")
    ///     .typography(.headlineLarge)
    ///
    /// Text("見出し")
    ///     .typography(.headlineLarge, design: .serif)
    /// ```
    func typography(_ token: Typography, design: Font.Design? = nil) -> some View {
        modifier(TypographyModifier(token: token, design: design))
    }
}
