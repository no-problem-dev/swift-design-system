import SwiftUI

/// 色見本コンポーネント
/// 色 + HEXコード + トークン名を表示し、タップでHEXコードをコピー
struct ColorSwatchView: View {
    @Environment(\.colorPalette) private var colors
    @Environment(\.spacingScale) private var spacing
    @Environment(\.radiusScale) private var radius

    let name: String
    let color: Color
    let hexCode: String?
    let description: String?

    @State private var showCopiedFeedback = false

    init(name: String, color: Color, hexCode: String? = nil, description: String? = nil) {
        self.name = name
        self.color = color
        self.hexCode = hexCode
        self.description = description
    }

    var body: some View {
        Button {
            copyToClipboard()
        } label: {
            HStack(spacing: spacing.md) {
                // 色見本
                RoundedRectangle(cornerRadius: radius.sm)
                    .fill(color)
                    .frame(width: 48, height: 48)
                    .overlay {
                        RoundedRectangle(cornerRadius: radius.sm)
                            .stroke(colors.outline.opacity(0.3), lineWidth: 1)
                    }
                    .overlay {
                        if showCopiedFeedback {
                            Image(systemName: "checkmark")
                                .foregroundStyle(.white)
                                .typography(.titleSmall)
                                .transition(.scale.combined(with: .opacity))
                        }
                    }

                VStack(alignment: .leading, spacing: spacing.xs) {
                    Text(name)
                        .typography(.titleSmall)
                        .foregroundStyle(colors.onSurface)

                    if let hexCode {
                        Text(hexCode)
                            .typography(.labelMedium)
                            .foregroundStyle(colors.onSurfaceVariant)
                            .fontDesign(.monospaced)
                    }

                    if let description {
                        Text(description)
                            .typography(.labelSmall)
                            .foregroundStyle(colors.onSurfaceVariant.opacity(0.7))
                    }
                }

                Spacer()

                Image(systemName: "doc.on.doc")
                    .typography(.labelMedium)
                    .foregroundStyle(colors.onSurfaceVariant)
            }
            .padding(.vertical, spacing.sm)
        }
        .buttonStyle(.plain)
    }

    private func copyToClipboard() {
        guard let hexCode else { return }

        #if os(iOS)
        UIPasteboard.general.string = hexCode
        #elseif os(macOS)
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(hexCode, forType: .string)
        #endif

        withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
            showCopiedFeedback = true
        }

        Task {
            try? await Task.sleep(for: .seconds(1))
            withAnimation {
                showCopiedFeedback = false
            }
        }
    }
}

#Preview {
    List {
        ColorSwatchView(
            name: "primary",
            color: .blue,
            hexCode: "#3B82F6",
            description: "Primary brand color"
        )
        ColorSwatchView(
            name: "error",
            color: .red,
            hexCode: "#EF4444",
            description: "Error state color"
        )
    }
}
