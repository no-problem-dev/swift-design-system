import SwiftUI

public extension View {
    /// Sweeps a band of gloss, tilted 45 degrees, across the view.
    ///
    /// It runs once per change of the trigger value. To make it shine a fixed number of times
    /// with a pause between sweeps, use ``shineRepeating(every:times:firstDelay:isActive:duration:clipShape:)``.
    /// When Reduce Motion is on, no band is drawn.
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
    func shine(_ toggle: Bool, duration: CGFloat = 0.5, clipShape: some Shape = .rect, rightToLeft: Bool = false) -> some View {
        modifier(ShineModifier(toggle: toggle, duration: duration, clipShape: AnyShape(clipShape), rightToLeft: rightToLeft))
    }

    /// Shines the view a fixed number of times, with a pause between sweeps, then stops.
    ///
    /// For a purchase button that should catch the eye without moving forever: the first sweep
    /// comes after `firstDelay`, then one every `interval`, `times` in all. Nothing runs while
    /// `isActive` is false (the button is busy, say), while Reduce Motion is on, or while the
    /// scene is not active; the count starts over when it can run again. Stopping after a few
    /// sweeps also means nothing moves on its own for more than five seconds without a way to
    /// stop it (WCAG 2.2.2).
    ///
    /// - Parameters:
    ///   - interval: The time from one sweep to the next.
    ///   - times: How many sweeps in all.
    ///   - firstDelay: The wait before the first sweep.
    ///   - isActive: Whether sweeps may run.
    ///   - duration: How long one sweep takes (see ``shine(_:duration:clipShape:rightToLeft:)``).
    ///   - clipShape: The shape the gloss, the view, and the hit-test region are clipped to.
    func shineRepeating(
        every interval: Duration = .seconds(4),
        times: Int = 3,
        firstDelay: Duration = .milliseconds(1200),
        isActive: Bool = true,
        duration: CGFloat = 0.9,
        clipShape: some Shape = .capsule
    ) -> some View {
        modifier(ShineRepeatingModifier(
            schedule: ShineSchedule(interval: interval, times: times, firstDelay: firstDelay),
            isActive: isActive,
            duration: duration,
            clipShape: AnyShape(clipShape)
        ))
    }
}

/// When the sweeps of ``SwiftUICore/View/shineRepeating(every:times:firstDelay:isActive:duration:clipShape:)`` happen.
struct ShineSchedule: Equatable, Sendable {
    let interval: Duration
    let times: Int
    let firstDelay: Duration

    /// Waits `firstDelay`, then calls `fire` `times` times with `interval` between calls.
    /// Returns early, without firing again, once the task is cancelled or `sleep` throws.
    @MainActor
    func run(sleep: (Duration) async throws -> Void, fire: () -> Void) async {
        guard times > 0 else { return }
        do {
            try await sleep(firstDelay)
            for index in 0..<times {
                try Task.checkCancellation()
                fire()
                if index < times - 1 { try await sleep(interval) }
            }
        } catch {
            return
        }
    }
}

private struct ShineModifier: ViewModifier {
    let toggle: Bool
    let duration: CGFloat
    let clipShape: AnyShape
    let rightToLeft: Bool
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    func body(content: Content) -> some View {
        content
            .overlay {
                if !reduceMotion {
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
            }
            .clipShape(clipShape)
            .contentShape(clipShape)
    }
}

private struct ShineRepeatingModifier: ViewModifier {
    let schedule: ShineSchedule
    let isActive: Bool
    let duration: CGFloat
    let clipShape: AnyShape
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Environment(\.scenePhase) private var scenePhase
    @State private var trigger = false

    private var runs: Bool { isActive && !reduceMotion && scenePhase == .active }

    func body(content: Content) -> some View {
        content
            .shine(trigger, duration: duration, clipShape: clipShape)
            .task(id: runs) {
                guard runs else { return }
                await schedule.run(sleep: { try await Task.sleep(for: $0) }, fire: { trigger.toggle() })
            }
    }
}
