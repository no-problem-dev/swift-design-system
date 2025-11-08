import SwiftUI

/// 角丸値のデモコンポーネント
/// 実際の角丸を視覚的にプレビュー
struct RadiusDemoView: View {
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

                Text(value.isInfinite ? "∞" : "\(Int(value))pt")
                    .font(.caption)
                    .fontDesign(.monospaced)
                    .foregroundStyle(colors.onSurfaceVariant)
            }

            // 視覚的表現
            RoundedRectangle(cornerRadius: value.isInfinite ? 32 : value)
                .fill(colors.primary.opacity(0.2))
                .stroke(colors.primary, lineWidth: 2)
                .frame(height: 64)
        }
        .padding(.vertical, spacing.xs)
    }
}

#Preview {
    List {
        RadiusDemoView(name: "none", value: 0)
        RadiusDemoView(name: "xs", value: 2)
        RadiusDemoView(name: "sm", value: 4)
        RadiusDemoView(name: "md", value: 8)
        RadiusDemoView(name: "lg", value: 12)
        RadiusDemoView(name: "xl", value: 16)
        RadiusDemoView(name: "full", value: .infinity)
    }
}
