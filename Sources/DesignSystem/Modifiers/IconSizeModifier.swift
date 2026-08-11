import SwiftUI

public extension View {
    /// Sets the size of an icon, either an image or an emoji in a text view, from a token.
    ///
    /// This responsibility is kept separate from `Typography`: an icon is a visual element whose
    /// size follows its own scale, independent of the line height and letter spacing of text.
    /// It applies to both SF Symbols and emoji.
    ///
    /// The size comes from the ``IconSizeScale`` in the environment, so a theme can move every
    /// icon in the app at once. With no theme applied, ``DefaultIconSizeScale`` keeps the
    /// built-in sizes.
    ///
    /// Resolving the scale requires an environment lookup, so the content is wrapped in the
    /// lightweight view `IconSizedView`. A `ViewModifier` is not used because its
    /// `body(content:)` becomes `@MainActor` isolated, which raises a "non-Sendable result" error
    /// when called from a Sendable closure such as `PhotosPicker`. Building a view is itself
    /// nonisolated, so it is safe inside a Sendable closure. This is the same shape as
    /// `typography()`.
    ///
    /// ```swift
    /// Image(systemName: "checkmark")
    ///     .iconSize(.sm)      // 16pt, matches body text
    ///
    /// Text(emoji).iconSize(.lg)   // 32pt, for category display
    /// ```
    func iconSize(_ size: IconSizeToken) -> some View {
        IconSizedView(token: size, content: self)
    }
}

/// Resolves an icon size token against the scale in the environment and applies it to the content.
private struct IconSizedView<Content: View>: View {
    let token: IconSizeToken
    let content: Content
    @Environment(\.iconSizeScale) private var scale

    var body: some View {
        content.font(.system(size: scale.size(for: token)))
    }
}

/// The token values accepted by the icon size modifier.
public enum IconSizeToken: Sendable {
    case xxs, xs, sm, md, lg, xl, xxl
}
