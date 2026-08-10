import SwiftUI

/// Shows a spacing token next to a bar drawn at that width.
struct SpacingDemoView: View {
    @Environment(\.colorPalette) private var colors
    @Environment(\.spacingScale) private var spacing

    let name: String
    let value: CGFloat

    var body: some View {
        VStack(alignment: .leading, spacing: spacing.sm) {
            HStack {
                Text(name)
                    .typography(.bodyMedium)
                    .foregroundStyle(colors.onSurface)

                Spacer()

                Text("\(Int(value))pt")
                    .typography(.labelMedium)
                    .fontDesign(.monospaced)
                    .foregroundStyle(colors.onSurfaceVariant)
            }

            // Visual representation
            HStack(spacing: 0) {
                Rectangle()
                    .fill(colors.primary.opacity(0.2))
                    .frame(width: value, height: 32)
                    .overlay(alignment: .leading) {
                        Rectangle()
                            .fill(colors.primary)
                            .frame(width: 2)
                    }
                    .overlay(alignment: .trailing) {
                        Rectangle()
                            .fill(colors.primary)
                            .frame(width: 2)
                    }

                Spacer()
            }
        }
        .padding(.vertical, spacing.xs)
    }
}

#Preview {
    List {
        SpacingDemoView(name: "none", value: 0)
        SpacingDemoView(name: "xs", value: 4)
        SpacingDemoView(name: "sm", value: 8)
        SpacingDemoView(name: "md", value: 12)
        SpacingDemoView(name: "lg", value: 16)
        SpacingDemoView(name: "xl", value: 24)
    }
}
