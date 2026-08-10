import SwiftUI

/// How surface components such as cards paint themselves: opaque, or as glass over the background.
///
/// The style travels through the environment, so a whole subtree can be switched at once. That
/// makes it possible to give a dynamically generated view tree the app's design language without
/// touching the code that builds the tree.
///
/// ## Example
/// ```swift
/// // Every card below this point becomes a glass surface
/// A2UISurfaceView(surface)
///     .surfaceStyle(.glass)
/// ```
///
/// ## Nested cards step down automatically
/// Stacked glass turns muddy and costs legibility, so a card tracks its own nesting depth and
/// paints any card at depth 1 or deeper as a thin tinted surface instead. Grouping by proximity
/// survives, and the transparency stays where it reads: the top level.
public enum SurfaceStyle: Sendable, Equatable {
    /// An opaque surface drawn from the elevation tokens. The right choice for dense, text-heavy
    /// screens and for anything that has to stay legible over an unknown background.
    case solid
    /// Glass that lets the background through, edged with a gradient border. Suits screens with
    /// artwork or color behind the content, where the depth is worth the contrast it costs.
    case glass
    /// Glass with a primary tint and a brighter border, for the one surface on screen that leads.
    /// Using it for more than a single surface flattens the hierarchy it exists to create.
    case glassProminent
}

// MARK: - Environment

private struct SurfaceStyleKey: EnvironmentKey {
    static let defaultValue: SurfaceStyle = .solid
}

private struct CardNestingLevelKey: EnvironmentKey {
    static let defaultValue: Int = 0
}

extension EnvironmentValues {
    /// How surface components paint themselves. Opaque unless something sets it.
    public var surfaceStyle: SurfaceStyle {
        get { self[SurfaceStyleKey.self] }
        set { self[SurfaceStyleKey.self] = newValue }
    }

    /// How deep the current card is inside other cards.
    ///
    /// A card raises this by one for its own content, and under a glass style any card at depth 1
    /// or deeper paints as a tinted surface rather than glass. Set it by hand only to lie to a
    /// card about where it sits.
    public var cardNestingLevel: Int {
        get { self[CardNestingLevelKey.self] }
        set { self[CardNestingLevelKey.self] = newValue }
    }
}

public extension View {
    /// Sets how surface components in this subtree paint themselves.
    ///
    /// Applies to ``Card`` and every other surface component below it.
    ///
    /// - Parameter style: The style to apply.
    func surfaceStyle(_ style: SurfaceStyle) -> some View {
        environment(\.surfaceStyle, style)
    }
}
