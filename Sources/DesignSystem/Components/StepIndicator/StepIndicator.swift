import SwiftUI

/// A row of dots showing where you are in a sequence of steps that only moves forward.
///
/// The current step is filled with `primary`, the steps already passed with a faded
/// `primary`, and the steps still ahead with `outlineVariant`.
///
/// ## Example
/// ```swift
/// // The second of three steps (index 1) is in progress
/// StepIndicator(stepCount: 3, currentIndex: 1)
///
/// // Every step is finished (nil = no step in progress)
/// StepIndicator(stepCount: 3, currentIndex: nil)
/// ```
///
/// The accessibility label is generated automatically as "Step N of M". Pass
/// `accessibilityText` to override it, both when the steps have names of their own and
/// whenever the app is not in English.
public struct StepIndicator: View {
    @Environment(\.colorPalette) private var colors
    @Environment(\.spacingScale) private var spacing
    @Environment(\.motion) private var motion

    private let stepCount: Int
    private let currentIndex: Int?
    private let accessibilityText: String?
    private let dotDiameter: CGFloat

    /// Creates a step indicator.
    /// - Parameters:
    ///   - stepCount: The total number of steps.
    ///   - currentIndex: The current step, counting from 0. Pass nil once every step is finished.
    ///   - accessibilityText: Overrides the accessibility label. When nil, a
    ///     "Step N of M" phrase is generated.
    ///   - dotDiameter: The diameter of a dot. Defaults to 6pt.
    public init(
        stepCount: Int,
        currentIndex: Int?,
        accessibilityText: String? = nil,
        dotDiameter: CGFloat = 6
    ) {
        self.stepCount = stepCount
        self.currentIndex = currentIndex
        self.accessibilityText = accessibilityText
        self.dotDiameter = dotDiameter
    }

    public var body: some View {
        HStack(spacing: spacing.xs) {
            ForEach(0..<stepCount, id: \.self) { index in
                Circle()
                    .fill(color(for: index))
                    .frame(width: dotDiameter, height: dotDiameter)
            }
        }
        .animate(motion.toggle, value: currentIndex)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(accessibilityText ?? defaultAccessibilityText)
    }

    private func color(for index: Int) -> Color {
        guard let currentIndex else { return colors.outlineVariant }
        if index < currentIndex { return colors.primary.opacity(0.35) }
        if index == currentIndex { return colors.primary }
        return colors.outlineVariant
    }

    private var defaultAccessibilityText: String {
        guard let currentIndex else { return "Completed" }
        return "Step \(currentIndex + 1) of \(stepCount)"
    }
}

// MARK: - Previews

#Preview("Step Indicator") {
    VStack(spacing: 24) {
        StepIndicator(stepCount: 3, currentIndex: 0)
        StepIndicator(stepCount: 3, currentIndex: 1)
        StepIndicator(stepCount: 3, currentIndex: 2)
        StepIndicator(stepCount: 3, currentIndex: nil)
        StepIndicator(stepCount: 5, currentIndex: 2, dotDiameter: 8)
    }
    .padding()
    .theme(ThemeProvider())
}
