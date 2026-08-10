import SwiftUI

public extension View {
    /// Sets the size of an icon, either an image or an emoji in a text view, from a token.
    ///
    /// This responsibility is kept separate from `Typography`: an icon is a visual element whose
    /// size follows its own scale, independent of the line height and letter spacing of text.
    /// It applies to both SF Symbols and emoji.
    ///
    /// Under Swift 6 strict concurrency, the size is applied by chaining the standard SwiftUI
    /// modifiers rather than going through a `ViewModifier`, so it can also be applied to an image
    /// inside a Sendable closure such as `PhotosPicker`. This is the same reason as `typography()`.
    ///
    /// ```swift
    /// Image(systemName: "checkmark")
    ///     .iconSize(.sm)      // 16pt, matches body text
    ///
    /// Text(emoji).iconSize(.lg)   // 32pt, for category display
    /// ```
    func iconSize(_ size: IconSizeToken) -> some View {
        // Size resolution is inlined here to keep this a pure computation
        // (deliberately the same shape as typography(), which avoids inheriting @MainActor).
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

/// The token values accepted by the icon size modifier.
public enum IconSizeToken: Sendable {
    case xxs, xs, sm, md, lg, xl, xxl
}
