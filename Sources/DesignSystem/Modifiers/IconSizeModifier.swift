import SwiftUI

public extension View {
    /// アイコン (Image / Text emoji) のサイズをトークンで指定する。
    ///
    /// `Typography` と分離された責務: icon は視覚要素のサイズであり、
    /// テキストの line-height / letter-spacing とは独立した scale を持つ。
    /// `SF Symbol` / `Emoji` のいずれにも適用可能。
    ///
    /// Swift 6 strict concurrency 下で Sendable closure (PhotosPicker 等) 内の
    /// Image にも適用できるよう、`ViewModifier` 経由ではなく SwiftUI 標準 modifier を
    /// 直接チェーンする実装にしている (typography() と同じ理由)。
    ///
    /// ```swift
    /// Image(systemName: "checkmark")
    ///     .iconSize(.sm)      // 16pt、body テキスト並び
    ///
    /// Text(emoji).iconSize(.lg)   // 32pt、カテゴリ表示
    /// ```
    func iconSize(_ size: IconSizeToken) -> some View {
        // resolveSize を inline 化して pure computation のみに保つ
        // (typography() と同じ shape を意図的に揃える、@MainActor 継承を回避)。
        let scale = DefaultIconSizeScale()
        let pt: CGFloat
        switch size {
        case .xxs: pt = scale.xxs
        case .xs: pt = scale.xs
        case .sm: pt = scale.sm
        case .md: pt = scale.md
        case .lg: pt = scale.lg
        case .xl: pt = scale.xl
        case .xxl: pt = scale.xxl
        }
        return self.font(.system(size: pt))
    }
}

/// `.iconSize(.xs/.sm/.md/.lg/.xl/.xxl)` で指定するトークン値。
public enum IconSizeToken: Sendable {
    case xxs, xs, sm, md, lg, xl, xxl
}
