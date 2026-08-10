import SwiftUI

/// A text renderer that reveals text slice by slice, resolving blur, opacity and a vertical
/// offset as it goes.
///
/// Animate `progress` from 0 to 1 to run the effect.
///
/// ```swift
/// Text("Building the UI…")
///     .textRenderer(TitleTextRenderer(progress: progress))
///     .onAppear { withAnimation(.smooth(duration: 1.2)) { progress = 1 } }
/// ```
///
/// Source: CustomTextEffect.swift from Kavsoft "Apple Invites App OnBoarding UI" (2025-02)
@available(iOS 18.0, macOS 15.0, *)
public struct TitleTextRenderer: TextRenderer, Animatable {
    public var progress: CGFloat

    public init(progress: CGFloat) {
        self.progress = progress
    }

    public var animatableData: CGFloat {
        get { progress }
        set { progress = newValue }
    }

    public func draw(layout: Text.Layout, in ctx: inout GraphicsContext) {
        let slices = layout.flatMap({ $0 }).flatMap({ $0 })

        for (index, slice) in slices.enumerated() {
            let sliceProgressIndex = CGFloat(slices.count) * progress
            let sliceProgress = max(min(sliceProgressIndex / CGFloat(index + 1), 1), 0)

            // The context is meant to accumulate across iterations, as in the source
            ctx.addFilter(.blur(radius: 5 - (5 * sliceProgress)))
            ctx.opacity = sliceProgress
            ctx.translateBy(x: 0, y: 5 - (5 * sliceProgress))
            ctx.draw(slice, options: .disablesSubpixelQuantization)
        }
    }
}
