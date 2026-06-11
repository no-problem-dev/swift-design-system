import SwiftUI

/// Elevationを適用するViewModifier
struct ElevationModifier: ViewModifier {
    let level: Elevation
    @Environment(\.colorPalette) private var colorPalette
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.elevationScale) private var elevationScale

    func body(content: Content) -> some View {
        let style = elevationScale.style(for: level)
        return content.shadow(
            color: colorPalette.shadow.opacity(style.opacity(for: colorScheme)),
            radius: style.radius,
            x: style.offset.width,
            y: style.offset.height
        )
    }
}

public extension View {
    /// Elevationレベルを適用
    ///
    /// ```swift
    /// RoundedRectangle(cornerRadius: 8)
    ///     .fill(.white)
    ///     .elevation(.level2)
    /// ```
    func elevation(_ level: Elevation) -> some View {
        modifier(ElevationModifier(level: level))
    }
}
