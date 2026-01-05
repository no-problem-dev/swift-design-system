import SwiftUI

/// コード例表示コンポーネント
struct CodeExample: View {
    @Environment(\.colorPalette) private var colors
    @Environment(\.spacingScale) private var spacing
    @Environment(\.radiusScale) private var radius

    let code: String

    var body: some View {
        Text(code)
            .typography(.bodySmall)
            .fontDesign(.monospaced)
            .padding(spacing.md)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(colors.surfaceVariant.opacity(0.5))
            .clipShape(RoundedRectangle(cornerRadius: radius.md))
    }
}
