import SwiftUI

public extension View {
    /// Lays a Liquid Glass surface behind the content, for cards, rows, and composers.
    ///
    /// Below iOS 26 it falls back to an ultra thin material with an outline.
    ///
    /// Note: for several surfaces lined up inside a `ScrollView` (carousels, chip rows, marquees),
    /// use ``frostedSurface(cornerRadius:tint:)`` instead. There, the glass effect leaves an
    /// artifact: a pane of glass spanning the full width of the scrolling area, which reads as a
    /// band the height of the row.
    /// - Parameters:
    ///   - cornerRadius: The corner radius.
    ///   - tint: A tint color laid over the glass.
    ///   - interactive: Whether the glass responds to touch.
    func glassSurface(cornerRadius: CGFloat = 16, tint: Color? = nil, interactive: Bool = false) -> some View {
        modifier(GlassSurfaceModifier(cornerRadius: cornerRadius, tint: tint, interactive: interactive))
    }

    /// Lays a material based frosted surface behind content that is lined up inside a scrolling area.
    ///
    /// When several of them sit inside a `ScrollView`, `glassEffect` draws a pane of glass spanning
    /// the full width of the scrolling area, which reads as a band the height of the row. Use this
    /// for elements that flow past, such as carousels, chip rows, and marquees. It carries a
    /// gradient hairline edge highlight so that it looks the same as a glass surface.
    /// - Parameters:
    ///   - cornerRadius: The corner radius.
    ///   - tint: A tint color laid over the material.
    func frostedSurface(cornerRadius: CGFloat = 16, tint: Color? = nil) -> some View {
        modifier(FrostedSurfaceModifier(cornerRadius: cornerRadius, tint: tint))
    }
}

struct FrostedSurfaceModifier: ViewModifier {
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.borderScale) private var borderScale
    let cornerRadius: CGFloat
    let tint: Color?

    func body(content: Content) -> some View {
        let shape = RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
        content
            .background {
                shape.fill(.ultraThinMaterial)
                    .overlay {
                        if let tint { shape.fill(tint.opacity(0.08)) }
                    }
            }
            .overlay {
                shape.strokeBorder(
                    LinearGradient(
                        colors: [
                            .white.opacity(colorScheme == .light ? 0.45 : 0.35),
                            .white.opacity(0.05),
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: borderScale.regular
                )
            }
    }
}

struct GlassSurfaceModifier: ViewModifier {
    @Environment(\.colorPalette) private var colorPalette
    @Environment(\.borderScale) private var borderScale
    let cornerRadius: CGFloat
    let tint: Color?
    let interactive: Bool

    func body(content: Content) -> some View {
        if #available(iOS 26.0, macOS 26.0, *) {
            content.glassEffect(glass, in: RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
        } else {
            content
                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
                .overlay {
                    RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                        .stroke(colorPalette.outlineVariant, lineWidth: borderScale.regular)
                }
        }
    }

    @available(iOS 26.0, macOS 26.0, *)
    private var glass: Glass {
        var glass: Glass = .regular
        if let tint { glass = glass.tint(tint) }
        if interactive { glass = glass.interactive() }
        return glass
    }
}
