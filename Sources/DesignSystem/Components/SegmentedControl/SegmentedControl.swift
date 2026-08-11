import SwiftUI

/// A segmented control that follows the design system.
///
/// `Picker` with `.segmented` takes the system tint, so use this on screens that need the semantic
/// colors of the theme to show through.
public struct SegmentedControl<Selection: Hashable, Content: View>: View {
    @Environment(\.colorPalette) private var colorPalette
    @Environment(\.radiusScale) private var radiusScale
    @Environment(\.spacingScale) private var spacingScale

    private let selection: Binding<Selection>
    private let options: [Selection]
    private let content: (Selection) -> Content

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
        HStack(spacing: spacingScale.xs) {
            ForEach(options, id: \.self) { option in
                Button {
                    withAnimation(.easeInOut(duration: 0.18)) {
                        selection.wrappedValue = option
                    }
                } label: {
                    content(option)
                        .typography(.labelMedium)
                        .foregroundStyle(foregroundColor(for: option))
                        .frame(maxWidth: .infinity)
                        .frame(height: 36)
                        .contentShape(RoundedRectangle(cornerRadius: radiusScale.md))
                }
                .buttonStyle(.plain)
                .background(backgroundColor(for: option), in: RoundedRectangle(cornerRadius: radiusScale.md))
                .accessibilityValue(selection.wrappedValue == option ? "Selected" : "")
            }
        }
        .padding(spacingScale.xs)
        .background(colorPalette.surfaceVariant, in: RoundedRectangle(cornerRadius: radiusScale.lg))
        .overlay {
            RoundedRectangle(cornerRadius: radiusScale.lg)
                .stroke(colorPalette.outlineVariant, lineWidth: 1)
        }
    }

    private func foregroundColor(for option: Selection) -> Color {
        selection.wrappedValue == option ? colorPalette.onPrimaryContainer : colorPalette.onSurfaceVariant
    }

    private func backgroundColor(for option: Selection) -> Color {
        selection.wrappedValue == option ? colorPalette.primaryContainer : .clear
    }
}

#Preview {
    @Previewable @State var selection = "Week"

    SegmentedControl(selection: $selection, options: ["Week", "Month"]) { option in
        Text(option)
    }
    .padding()
    .theme(ThemeProvider())
}
