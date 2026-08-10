import SwiftUI

/// A container that brings its subviews in one after another, delayed by their index.
///
/// Toggling the content in and out inside an animated transaction makes each subview cascade
/// in with its own opacity, blur, scale and offset.
///
/// ```swift
/// StaggeredView {
///     if show {
///         RowA(); RowB(); RowC()
///     }
/// }
/// .animation(.snappy, value: show)
/// ```
///
/// Source: Kavsoft "Staggered Animated View Using SwiftUI" (2025-03)
@available(iOS 18.0, macOS 15.0, *)
public struct StaggeredView<Content: View>: View {
    public var config: StaggeredConfig
    @ViewBuilder public var content: Content

    public init(config: StaggeredConfig = .init(), @ViewBuilder content: () -> Content) {
        self.config = config
        self.content = content()
    }

    public var body: some View {
        Group(subviews: content) { collection in
            ForEach(collection.indices, id: \.self) { index in
                collection[index]
                    .transition(CustomStaggeredTransition(index: index, config: config))
            }
        }
    }
}

@available(iOS 18.0, macOS 15.0, *)
private struct CustomStaggeredTransition: Transition {
    var index: Int
    var config: StaggeredConfig

    func body(content: Content, phase: TransitionPhase) -> some View {
        let animationDelay: Double = min(Double(index) * config.delay, config.maxDelay)

        let isIdentity: Bool = phase == .identity
        let didDisappear: Bool = phase == .didDisappear
        let x: CGFloat = config.offset.width
        let y: CGFloat = config.offset.height

        let reverseX: CGFloat = config.disappearInSameDirection ? x : -x
        let disappearCheckX: CGFloat = config.noOffsetDisappearAnimation ? 0 : reverseX

        let reverseY: CGFloat = config.disappearInSameDirection ? y : -y
        let disappearCheckY: CGFloat = config.noOffsetDisappearAnimation ? 0 : reverseY

        let offsetX = isIdentity ? 0 : didDisappear ? disappearCheckX : x
        let offsetY = isIdentity ? 0 : didDisappear ? disappearCheckY : y

        return content
            .opacity(isIdentity ? 1 : 0)
            .blur(radius: isIdentity ? 0 : config.blurRadius)
            .compositingGroup()
            .scaleEffect(isIdentity ? 1 : config.scale, anchor: config.scaleAnchor)
            .offset(x: offsetX, y: offsetY)
            .animation(config.animation.delay(animationDelay), value: phase)
    }
}

/// The settings for the cascade that `StaggeredView` applies to its subviews.
public struct StaggeredConfig {
    public var delay: Double
    public var maxDelay: Double
    public var blurRadius: CGFloat
    public var offset: CGSize
    public var scale: CGFloat
    public var scaleAnchor: UnitPoint
    /// The animation applied to each subview, with the stagger added on top as a delay.
    public var animation: Animation
    /// When `true`, subviews leave in the same direction they arrived from. The default is
    /// `false`, which sends them back the other way.
    public var disappearInSameDirection: Bool
    /// When `true`, the leaving transition skips the offset animation.
    public var noOffsetDisappearAnimation: Bool

    public init(
        delay: Double = 0.05,
        maxDelay: Double = 0.4,
        blurRadius: CGFloat = 6,
        offset: CGSize = .init(width: 0, height: 100),
        scale: CGFloat = 0.95,
        scaleAnchor: UnitPoint = .center,
        animation: Animation = .interpolatingSpring,
        disappearInSameDirection: Bool = false,
        noOffsetDisappearAnimation: Bool = false
    ) {
        self.delay = delay
        self.maxDelay = maxDelay
        self.blurRadius = blurRadius
        self.offset = offset
        self.scale = scale
        self.scaleAnchor = scaleAnchor
        self.animation = animation
        self.disappearInSameDirection = disappearInSameDirection
        self.noOffsetDisappearAnimation = noOffsetDisappearAnimation
    }
}
