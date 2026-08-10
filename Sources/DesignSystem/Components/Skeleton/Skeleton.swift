import SwiftUI

public extension View {
    /// Shows skeleton loading: the content is redacted and a soft-light band of light sweeps across it.
    ///
    /// Apply it to the real content as `.skeleton(isRedacted: isLoading)`, or to a group of
    /// placeholder shapes.
    /// The sweep is guarded internally so that an animation transaction from a parent view
    /// cannot override it.
    ///
    /// Source: Kavsoft "SwiftUI Skeleton View - Skeleton Loading Animations" (2025-04)
    /// - Parameters:
    ///   - isRedacted: Whether the skeleton is showing.
    ///   - tint: The color of the band of light. When nil, it is white or black depending on the color scheme.
    func skeleton(isRedacted: Bool, tint: Color? = nil) -> some View {
        modifier(SkeletonModifier(isRedacted: isRedacted, tint: tint))
    }
}

struct SkeletonModifier: ViewModifier {
    var isRedacted: Bool
    var tint: Color?
    @Environment(\.colorScheme) private var scheme

    func body(content: Content) -> some View {
        content
            .redacted(reason: isRedacted ? .placeholder : [])
            .overlay {
                if isRedacted {
                    // Driven by the clock (TimelineView): @State plus withAnimation(.repeatForever)
                    // is fragile, because a redraw of an ancestor or an insertion transition kills
                    // the animation. Deriving the position from the clock on every frame keeps it
                    // running no matter what causes a redraw.
                    TimelineView(.animation) { timeline in
                        GeometryReader {
                            let size = $0.size
                            let skeletonWidth = size.width / 2
                            // Keep the blur radius at 30 or above
                            let blurRadius = max(skeletonWidth / 2, 30)
                            let blurDiameter = blurRadius * 2
                            // The endpoints of the travel
                            let minX = -(skeletonWidth + blurDiameter)
                            let maxX = size.width + skeletonWidth + blurDiameter
                            let progress = Self.easeInOut(
                                timeline.date.timeIntervalSinceReferenceDate
                                    .truncatingRemainder(dividingBy: period) / period
                            )

                            Rectangle()
                                .fill(tint ?? (scheme == .dark ? .white : .black))
                                .frame(width: skeletonWidth, height: size.height * 2)
                                .frame(height: size.height)
                                .blur(radius: blurRadius)
                                .rotationEffect(.degrees(rotation))
                                // Sweep from left to right, forever
                                .offset(x: minX + (maxX - minX) * progress)
                        }
                    }
                    .mask {
                        content
                            .redacted(reason: .placeholder)
                    }
                    .blendMode(.softLight)
                }
            }
    }

    var rotation: Double { 5 }
    var period: Double { 1.5 }

    /// The same easing curve as .easeInOut(duration: 1.5).
    private static func easeInOut(_ t: Double) -> Double {
        t < 0.5 ? 2 * t * t : 1 - pow(-2 * t + 2, 2) / 2
    }
}

#Preview {
    VStack(alignment: .leading, spacing: 12) {
        HStack(spacing: 12) {
            Circle().frame(width: 44, height: 44)
            VStack(alignment: .leading, spacing: 6) {
                RoundedRectangle(cornerRadius: 4).frame(width: 140, height: 12)
                RoundedRectangle(cornerRadius: 4).frame(width: 90, height: 10)
            }
        }
        RoundedRectangle(cornerRadius: 12).frame(height: 120)
    }
    .foregroundStyle(.gray.opacity(0.3))
    .skeleton(isRedacted: true)
    .padding()
}
