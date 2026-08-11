import SwiftUI

/// A segmented control whose Liquid Glass selection indicator slides between segments.
///
/// Where `SegmentedControl` swaps flat colors, this moves the selected segment as a single glass
/// capsule with `matchedGeometryEffect`. The indicator follows the finger during a drag as well.
/// Below iOS 26 it falls back to `ultraThinMaterial`.
public struct GlassSegmentedControl<Selection: Hashable, Content: View>: View {
    @Environment(\.colorPalette) private var colorPalette
    @Environment(\.spacingScale) private var spacingScale
    @Environment(\.motion) private var motion
    @Environment(\.borderScale) private var borderScale
    @Namespace private var indicatorNamespace

    private let selection: Binding<Selection>
    private let options: [Selection]
    private let content: (Selection) -> Content

    @State private var trackWidth: CGFloat = 0

    public init(
        selection: Binding<Selection>,
        options: [Selection],
        @ViewBuilder content: @escaping (Selection) -> Content
    ) {
        self.selection = selection
        self.options = options
        self.content = content
    }

    public var body: some View {
        HStack(spacing: 0) {
            ForEach(options, id: \.self) { option in
                segment(for: option)
            }
        }
        .padding(spacingScale.xs)
        .background(colorPalette.surfaceVariant.opacity(0.6), in: Capsule())
        .overlay {
            Capsule().stroke(colorPalette.outlineVariant, lineWidth: borderScale.regular)
        }
        .contentShape(Capsule())
        .onGeometryChange(for: CGFloat.self) {
            $0.size.width
        } action: { newValue in
            trackWidth = newValue
        }
        .gesture(
            DragGesture(minimumDistance: 0)
                .onChanged { select(at: $0.location.x) }
                .onEnded { select(at: $0.location.x) }
        )
        .sensoryFeedback(.selection, trigger: selection.wrappedValue)
        .accessibilityRepresentation {
            Picker("", selection: selection) {
                ForEach(options, id: \.self) { option in
                    content(option).tag(option)
                }
            }
        }
    }

    private func segment(for option: Selection) -> some View {
        let isSelected = selection.wrappedValue == option
        return content(option)
            .typography(.labelMedium)
            .fontWeight(isSelected ? .semibold : .regular)
            .foregroundStyle(isSelected ? colorPalette.primary : colorPalette.onSurfaceVariant)
            .frame(maxWidth: .infinity)
            .frame(height: 36)
            .background {
                if isSelected {
                    indicator
                        .matchedGeometryEffect(id: "indicator", in: indicatorNamespace)
                }
            }
    }

    @ViewBuilder private var indicator: some View {
        if #available(iOS 26.0, macOS 26.0, *) {
            Capsule()
                .fill(colorPalette.primary.opacity(0.05))
                .glassEffect(.regular.tint(colorPalette.primary.opacity(0.18)).interactive(true), in: Capsule())
        } else {
            Capsule()
                .fill(colorPalette.primary.opacity(0.06))
                .background(.ultraThinMaterial, in: Capsule())
        }
    }

    /// Selects the option whose equal width segment contains the given tap or drag position.
    private func select(at x: CGFloat) {
        guard trackWidth > 0, !options.isEmpty else { return }
        let segmentWidth = trackWidth / CGFloat(options.count)
        let index = min(options.count - 1, max(0, Int(x / segmentWidth)))
        let option = options[index]
        guard selection.wrappedValue != option else { return }
        withAnimation(motion.spring) {
            selection.wrappedValue = option
        }
    }
}

#Preview {
    @Previewable @State var selection = "Single"

    VStack(spacing: 24) {
        GlassSegmentedControl(selection: $selection, options: ["Single", "Paged", "Chat"]) { option in
            Text(option)
        }
    }
    .padding()
    .theme(ThemeProvider())
}
