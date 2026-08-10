import SwiftUI

/// A circular spinner built from two overlaid rotations, for showing inline that work is running.
///
/// Source: Kavsoft "Animated Async Button With Custom Spinner" (2025-03)
public struct Spinner: View {
    public var tint: Color
    public var lineWidth: CGFloat

    @State private var rotation: Double = 0
    @State private var extraRotation: Double = 0
    @State private var isAnimatedTriggered: Bool = false

    public init(tint: Color, lineWidth: CGFloat = 4) {
        self.tint = tint
        self.lineWidth = lineWidth
    }

    public var body: some View {
        ZStack {
            Circle()
                .stroke(tint.opacity(0.3), style: .init(lineWidth: lineWidth, lineCap: .round, lineJoin: .round))

            Circle()
                .trim(from: 0, to: 0.3)
                .stroke(tint, style: .init(lineWidth: lineWidth, lineCap: .round, lineJoin: .round))
                .rotationEffect(.init(degrees: rotation))
                .rotationEffect(.init(degrees: extraRotation))
        }
        .compositingGroup()
        .onAppear(perform: animate)
    }

    private func animate() {
        guard !isAnimatedTriggered else { return }
        isAnimatedTriggered = true

        withAnimation(.linear(duration: 0.7).speed(1.2).repeatForever(autoreverses: false)) {
            rotation += 360
        }

        withAnimation(.linear(duration: 1).speed(1.2).delay(1).repeatForever(autoreverses: false)) {
            extraRotation += 360
        }
    }
}

#Preview {
    Spinner(tint: .green, lineWidth: 4)
        .frame(width: 30, height: 30)
}
