import SwiftUI

/// A container that groups content and gives it a visual hierarchy.
///
/// The card draws a rounded surface with an elevation, a corner radius, and a background color.
///
/// Rendering follows the ``SurfaceStyle`` in the environment:
/// - `.solid` (the default): an opaque surface with an elevation shadow.
/// - `.glass` / `.glassProminent`: Liquid Glass. The background shows through and a gradient
///   border carries the light along the edge. Elevation is reinterpreted as border brightness
///   and tint strength instead of shadow depth. A nested card (depth 1 or deeper) drops down
///   to a light tint surface, because overlapping panes of glass turn muddy.
///
/// ## Example
/// ```swift
/// @Environment(\.spacingScale) var spacing
///
/// // Basic use
/// Card {
///     Text("Default card")
///         .typography(.bodyMedium)
/// }
///
/// // Turn every card below this point into a glass surface
/// // (for dynamic trees such as an A2UI surface)
/// A2UISurfaceView(surface)
///     .surfaceStyle(.glass)
///
/// // Customizing the elevation and the spacing
/// Card(elevation: .level2) {
///     VStack(alignment: .leading, spacing: spacing.md) {
///         Text("Card title")
///             .typography(.titleMedium)
///         Text("The description of the card goes here.")
///             .typography(.bodyMedium)
///     }
/// }
///
/// // Customizing the corner radius and the background color
/// Card(elevation: .level3, cornerRadius: 20, backgroundColor: colors.primaryContainer) {
///     Text("Custom card")
/// }
///
/// // Uniform padding
/// Card(elevation: .level1, allSides: 24) {
///     Text("Uniform padding")
/// }
/// ```
///
/// ## Design guidelines
/// - **level0 to level1**: list rows and flat cards
/// - **level2**: the standard card, and the recommended choice
/// - **level3 to level5**: emphasis and modal-like uses
public struct Card<Content: View>: View {
    @Environment(\.colorPalette) private var colorPalette
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.radiusScale) private var radiusScale
    @Environment(\.spacingScale) private var spacingScale
    @Environment(\.surfaceStyle) private var surfaceStyle
    @Environment(\.cardNestingLevel) private var nestingLevel

    private let content: Content
    private let elevation: Elevation
    private let padding: EdgeInsets?
    private let cornerRadius: CGFloat?
    private let backgroundColor: Color?

    /// Creates a card.
    ///
    /// - Parameters:
    ///   - elevation: The shadow level.
    ///   - padding: The inset around the content. When `nil`, `SpacingScale.lg` is applied on
    ///     all four sides.
    ///   - cornerRadius: The corner radius. When `nil`, `RadiusScale.lg` is used.
    ///   - backgroundColor: The background color. When `nil`, the surface token for the
    ///     elevation is used. Passing a color forces solid rendering, even under a glass
    ///     surface style.
    ///   - content: The content shown inside the card.
    public init(
        elevation: Elevation = .level1,
        padding: EdgeInsets? = nil,
        cornerRadius: CGFloat? = nil,
        backgroundColor: Color? = nil,
        @ViewBuilder content: () -> Content
    ) {
        self.elevation = elevation
        self.padding = padding
        self.cornerRadius = cornerRadius
        self.backgroundColor = backgroundColor
        self.content = content()
    }

    public var body: some View {
        let resolvedPadding = padding ?? EdgeInsets(
            top: spacingScale.lg,
            leading: spacingScale.lg,
            bottom: spacingScale.lg,
            trailing: spacingScale.lg
        )
        // An explicit backgroundColor always renders solid: the caller's intent comes first.
        let renderMode: RenderMode = if backgroundColor != nil || surfaceStyle == .solid {
            .solid
        } else if nestingLevel >= 1 {
            .nestedTint
        } else {
            .glass
        }

        styledCard(renderMode: renderMode) {
            content
                .environment(\.cardNestingLevel, nestingLevel + 1)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(resolvedPadding)
        }
    }

    /// How the card is drawn.
    ///
    /// Resolved at the top of `body` from the surface style and the nesting depth.
    private enum RenderMode {
        case solid
        case glass
        case nestedTint
    }

    @ViewBuilder
    private func styledCard(renderMode: RenderMode, @ViewBuilder _ padded: () -> some View) -> some View {
        switch renderMode {
        case .solid:
            padded()
                .background {
                    solidBackground
                }
                .overlay {
                    RoundedRectangle(cornerRadius: cornerRadius ?? radiusScale.lg)
                        .stroke(colorPalette.outlineVariant, lineWidth: 1)
                }
                .clipShape(RoundedRectangle(cornerRadius: cornerRadius ?? radiusScale.lg))
                .elevation(elevation)

        case .glass:
            let shape = RoundedRectangle(cornerRadius: cornerRadius ?? radiusScale.lg, style: .continuous)
            padded()
                .background {
                    glassBackground(in: shape)
                }
                .overlay {
                    // Edge light: a gradient that runs along the border as if lit from the
                    // top leading corner. A higher elevation raises the brightness, which is
                    // how a deeper shadow is expressed on glass.
                    shape.strokeBorder(glassBorderGradient, lineWidth: 1)
                }
                .clipShape(shape)
                .elevation(elevation)

        case .nestedTint:
            // Nested card: overlapping panes of glass turn muddy, so it drops to a light tint
            // surface that only groups nearby content (no shadow, hairline border).
            let shape = RoundedRectangle(cornerRadius: cornerRadius ?? radiusScale.lg, style: .continuous)
            padded()
                .background {
                    shape.fill(colorPalette.onSurface.opacity(colorScheme == .dark ? 0.06 : 0.04))
                }
                .overlay {
                    shape.strokeBorder(colorPalette.outlineVariant.opacity(0.6), lineWidth: 1)
                }
                .clipShape(shape)
        }
    }

    // MARK: - Solid

    @ViewBuilder
    private var solidBackground: some View {
        let shape = RoundedRectangle(cornerRadius: cornerRadius ?? radiusScale.lg)

        if let backgroundColor {
            shape.fill(backgroundColor)
        } else {
            let baseColor = elevatedSurfaceColor
            shape
                .fill(baseColor)
                .overlay {
                    shape.fill(colorPalette.primary.opacity(elevation.surfaceTintOpacity(for: colorScheme)))
                }
        }
    }

    private var elevatedSurfaceColor: Color {
        switch elevation {
        case .level0:
            colorPalette.surface
        case .level1, .level2, .level3:
            colorPalette.elevatedSurface
        case .level4, .level5:
            colorPalette.elevatedSurfaceHigh
        }
    }

    // MARK: - Glass

    @ViewBuilder
    private func glassBackground(in shape: RoundedRectangle) -> some View {
        if #available(iOS 26.0, macOS 26.0, *) {
            Color.clear.glassEffect(glassMaterial, in: shape)
        } else {
            shape
                .fill(.ultraThinMaterial)
                .overlay {
                    if surfaceStyle == .glassProminent {
                        shape.fill(colorPalette.primary.opacity(0.06))
                    }
                }
        }
    }

    @available(iOS 26.0, macOS 26.0, *)
    private var glassMaterial: Glass {
        var glass: Glass = .regular
        if surfaceStyle == .glassProminent {
            glass = glass.tint(colorPalette.primary.opacity(0.18))
        }
        return glass
    }

    /// The gradient border that lights the edge of the glass.
    ///
    /// The brightness rises step by step from elevation level0 to level5.
    private var glassBorderGradient: LinearGradient {
        let highlight = glassBorderHighlightOpacity
        return LinearGradient(
            colors: [
                .white.opacity(highlight),
                .white.opacity(highlight * 0.12),
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    private var glassBorderHighlightOpacity: Double {
        let base: Double = switch elevation {
        case .level0: 0.22
        case .level1: 0.32
        case .level2: 0.40
        case .level3: 0.48
        case .level4: 0.56
        case .level5: 0.64
        }
        let prominentBoost: Double = surfaceStyle == .glassProminent ? 0.12 : 0
        // A white border sinks into a light background, so lift it a little.
        let schemeBoost: Double = colorScheme == .light ? 0.08 : 0
        return min(base + prominentBoost + schemeBoost, 0.85)
    }
}

public extension Card {
    /// Creates a card with the same padding on every side.
    ///
    /// - Parameters:
    ///   - elevation: The shadow level.
    ///   - padding: The padding applied to all four sides.
    ///   - cornerRadius: The corner radius. When `nil`, `RadiusScale.lg` is used.
    ///   - backgroundColor: The background color. When `nil`, the surface token for the
    ///     elevation is used.
    ///   - content: The content shown inside the card.
    init(
        elevation: Elevation = .level1,
        allSides padding: CGFloat,
        cornerRadius: CGFloat? = nil,
        backgroundColor: Color? = nil,
        @ViewBuilder content: () -> Content
    ) {
        self.init(
            elevation: elevation,
            padding: EdgeInsets(top: padding, leading: padding, bottom: padding, trailing: padding),
            cornerRadius: cornerRadius,
            backgroundColor: backgroundColor,
            content: content
        )
    }
}

#Preview("Solid") {
    VStack(spacing: 16) {
        Card {
            Text("Default Card")
        }
        Card(elevation: .level3, cornerRadius: 20) {
            Text("Custom Corner Radius")
        }
    }
    .padding()
    .theme(ThemeProvider())
}

#Preview("Glass") {
    ZStack {
        LinearGradient(
            colors: [.purple, .blue, .cyan],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()

        VStack(spacing: 16) {
            Card(elevation: .level2) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Glass Card")
                    // A nested card drops to a tint surface on its own
                    Card(elevation: .level1) {
                        Text("Nested Card (auto-demoted)")
                    }
                }
            }
            Card(elevation: .level3, cornerRadius: 24) {
                Text("Prominent Glass")
            }
            .surfaceStyle(.glassProminent)
        }
        .padding()
        .surfaceStyle(.glass)
    }
    .theme(ThemeProvider())
}
