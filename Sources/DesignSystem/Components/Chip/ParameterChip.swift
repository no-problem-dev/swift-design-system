import SwiftUI

/// A chip that summarizes the current value of a parameter.
///
/// The value itself is the label, so the selection stays readable while the control is
/// collapsed. The chip carries no action of its own. Use it as the label of a `Button` or a
/// `Menu`.
///
/// ```swift
/// Menu {
///     Picker("", selection: $format) { ... }
/// } label: {
///     ParameterChip("A2UI", systemImage: "sparkles")
/// }
/// ```
public struct ParameterChip: View {
    @Environment(\.colorPalette) private var colorPalette
    @Environment(\.spacingScale) private var spacingScale

    private let value: String
    private let systemImage: String?
    private let prominent: Bool

    /// - Parameters:
    ///   - value: The short label that stands for the current value.
    ///   - systemImage: The SF Symbols name of the leading icon.
    ///   - prominent: Whether to emphasize the chip with the primary tint.
    public init(_ value: String, systemImage: String? = nil, prominent: Bool = false) {
        self.value = value
        self.systemImage = systemImage
        self.prominent = prominent
    }

    public var body: some View {
        HStack(spacing: spacingScale.xxs) {
            if let systemImage {
                Image(systemName: systemImage)
                    .font(.system(size: 11, weight: .semibold))
            }
            Text(value)
                .typography(.labelMedium)
            Image(systemName: "chevron.down")
                .font(.system(size: 8, weight: .bold))
                .foregroundStyle(colorPalette.onSurfaceVariant)
        }
        .foregroundStyle(prominent ? colorPalette.primary : colorPalette.onSurface)
        .padding(.horizontal, spacingScale.sm)
        .frame(height: 30)
        .background { background }
        .contentShape(Capsule())
    }

    @ViewBuilder private var background: some View {
        if #available(iOS 26.0, macOS 26.0, *) {
            Capsule()
                .fill(.clear)
                .glassEffect(
                    prominent
                        ? .regular.tint(colorPalette.primary.opacity(0.15)).interactive(true)
                        : .regular.interactive(true),
                    in: Capsule()
                )
        } else {
            Capsule()
                .fill(colorPalette.surfaceVariant.opacity(0.8))
                .background(.ultraThinMaterial, in: Capsule())
        }
    }
}

#Preview {
    HStack {
        ParameterChip("A2UI", systemImage: "sparkles", prominent: true)
        ParameterChip("Single")
        ParameterChip("3 Agents", systemImage: "person.3.fill")
    }
    .padding()
    .theme(ThemeProvider())
}
