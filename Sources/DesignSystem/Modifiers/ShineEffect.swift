import SwiftUI

public extension View {
    /// Sweeps a band of gloss, tilted 45 degrees, across the view.
    ///
    /// It runs once per change of the trigger value. To make it shine repeatedly, toggle that
    /// value from the call site at a regular interval.
    ///
    /// `clipShape` does more than mask the gloss: the view itself is clipped to that shape, and
    /// the shape also becomes the view's hit-test region. So a call that passes a rounded
    /// rectangle to keep the gloss inside a card's corners also rounds off the card's own
    /// corners, and hands any following gesture that shape to test against. If the view already
    /// carries a content shape that matters — a card with a tap gesture, for instance — restate
    /// it after this modifier, because this one replaces it.
    ///
    /// - Parameters:
    ///   - toggle: Each change of this value runs one sweep.
    ///   - duration: How long a sweep takes. Values below 0.3 seconds are raised to 0.3.
    ///   - clipShape: The shape the gloss, the view, and the hit-test region are clipped to.
    ///   - rightToLeft: Sweeps from the trailing edge instead of the leading edge.
    ///
    /// Source: Kavsoft "SwiftUI Shine Effect - Custom View Modifier" (2023-11)
    @ViewBuilder
    func shine(_ toggle: Bool, duration: CGFloat = 0.5, clipShape: some Shape = .rect, rightToLeft: Bool = false) -> some View {
        self
            .overlay {
                GeometryReader {
                    let size = $0.size
                    // Rule out negative and extremely small durations
                    let moddedDuration = max(0.3, duration)
                    // The 45° rotation and scaleEffect(y: 8) stretch the band along its diagonal,
                    // so the off-screen distance adds the height as well as the width (this keeps
                    // the band from lingering on tall views, and is a fix on top of the source)
                    let travel = size.width + size.height

                    Rectangle()
                        .fill(.linearGradient(
                            colors: [
                                .clear,
                                .clear,
                                .white.opacity(0.1),
                                .white.opacity(0.5),
                                .white.opacity(1),
                                .white.opacity(0.5),
                                .white.opacity(0.1),
                                .clear,
                                .clear,
                            ],
                            startPoint: .leading,
                            endPoint: .trailing
                        ))
                        .scaleEffect(y: 8)
                        .keyframeAnimator(initialValue: 0.0, trigger: toggle, content: { content, progress in
                            content
                                .offset(x: -travel + (progress * (travel * 2)))
                        }, keyframes: { _ in
                            CubicKeyframe(.zero, duration: 0.1)
                            CubicKeyframe(1, duration: moddedDuration)
                        })
                        .rotationEffect(.degrees(45))
                        .scaleEffect(x: rightToLeft ? -1 : 1)
                }
                .allowsHitTesting(false)
            }
            .clipShape(clipShape)
            .contentShape(clipShape)
    }
}
