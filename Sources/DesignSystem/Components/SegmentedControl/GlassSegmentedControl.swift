import SwiftUI

/// Liquid Glass の選択インジケーターがスライドするセグメンテッドコントロール。
///
/// `SegmentedControl` のフラットな配色切替に対し、選択中セグメントを 1 枚のガラスカプセルとして
/// `matchedGeometryEffect` で滑らかに動かす。ドラッグ中もインジケーターが指に追従する。
/// iOS 26 未満では ultraThinMaterial にフォールバックする。
public struct GlassSegmentedControl<Selection: Hashable, Content: View>: View {
    @Environment(\.colorPalette) private var colorPalette
    @Environment(\.spacingScale) private var spacingScale
    @Environment(\.motion) private var motion
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
            Capsule().stroke(colorPalette.outlineVariant, lineWidth: 1)
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

    /// タップ / ドラッグ位置から等幅セグメントの index を引いて選択する。
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
    @Previewable @State var selection = "単一"

    VStack(spacing: 24) {
        GlassSegmentedControl(selection: $selection, options: ["単一", "ページング", "チャット"]) { option in
            Text(option)
        }
    }
    .padding()
    .theme(ThemeProvider())
}
