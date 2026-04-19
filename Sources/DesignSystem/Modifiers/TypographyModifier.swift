import SwiftUI

public extension View {
    /// タイポグラフィトークンを適用する。
    ///
    /// Swift 6 strict concurrency 下で Sendable closure (PhotosPicker 等) 内の
    /// Image / Text にも適用できるよう、`ViewModifier` 経由ではなく SwiftUI 標準
    /// modifier を直接チェーンする実装にしている。ViewModifier protocol は `body` が
    /// `@MainActor` isolated になるため、Sendable closure からの呼び出しで
    /// "non-Sendable 'some View'-typed result" エラーを起こす。標準 modifier 経由なら
    /// そのまま通る。
    ///
    /// ```swift
    /// Text("見出し")
    ///     .typography(.headlineLarge)
    ///
    /// Text("見出し")
    ///     .typography(.headlineLarge, design: .serif)
    /// ```
    func typography(_ token: Typography, design: Font.Design? = nil) -> some View {
        self
            .font(design.map { token.font(design: $0) } ?? token.font)
            .lineSpacing(token.lineHeight - token.size)
    }
}
