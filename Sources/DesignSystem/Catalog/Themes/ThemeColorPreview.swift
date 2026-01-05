import SwiftUI

/// テーマカラープレビュー
///
/// テーマの全カラーパレットを視覚的に表示します。
struct ThemeColorPreview: View {
    @Environment(ThemeProvider.self) private var themeProvider
    @Environment(\.colorPalette) private var colors
    @Environment(\.spacingScale) private var spacing

    let theme: any Theme

    private var palette: any ColorPalette {
        theme.colorPalette(for: themeProvider.themeMode)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: spacing.md) {
            Text("カラーパレット")
                .typography(.titleMedium)
                .foregroundStyle(colors.onSurface)
                .padding(.horizontal, spacing.lg)

            VStack(spacing: spacing.sm) {
                ColorSection(title: "Primary Colors", colors: [
                    ("primary", palette.primary),
                    ("onPrimary", palette.onPrimary),
                    ("primaryContainer", palette.primaryContainer),
                    ("onPrimaryContainer", palette.onPrimaryContainer),
                ])

                ColorSection(title: "Secondary Colors", colors: [
                    ("secondary", palette.secondary),
                    ("onSecondary", palette.onSecondary),
                    ("secondaryContainer", palette.secondaryContainer),
                    ("onSecondaryContainer", palette.onSecondaryContainer),
                ])

                ColorSection(title: "Tertiary Colors", colors: [
                    ("tertiary", palette.tertiary),
                    ("onTertiary", palette.onTertiary),
                ])

                ColorSection(title: "Background & Surface", colors: [
                    ("background", palette.background),
                    ("onBackground", palette.onBackground),
                    ("surface", palette.surface),
                    ("onSurface", palette.onSurface),
                    ("surfaceVariant", palette.surfaceVariant),
                    ("onSurfaceVariant", palette.onSurfaceVariant),
                ])

                ColorSection(title: "Semantic States", colors: [
                    ("error", palette.error),
                    ("onError", palette.onError),
                    ("warning", palette.warning),
                    ("onWarning", palette.onWarning),
                    ("success", palette.success),
                    ("onSuccess", palette.onSuccess),
                    ("info", palette.info),
                    ("onInfo", palette.onInfo),
                ])

                ColorSection(title: "Outline & Border", colors: [
                    ("outline", palette.outline),
                    ("outlineVariant", palette.outlineVariant),
                ])
            }
            .padding(.horizontal, spacing.lg)
        }
    }
}

// MARK: - Color Section

private struct ColorSection: View {
    @Environment(\.colorPalette) private var palette
    @Environment(\.spacingScale) private var spacing
    @Environment(\.radiusScale) private var radius

    let title: String
    let colors: [(String, Color)]

    var body: some View {
        VStack(alignment: .leading, spacing: spacing.xs) {
            Text(title)
                .typography(.labelMedium)
                .foregroundStyle(palette.onSurfaceVariant)

            VStack(spacing: spacing.xxs) {
                ForEach(colors, id: \.0) { name, color in
                    ColorRow(name: name, color: color)
                }
            }
            .background(palette.surface)
            .clipShape(RoundedRectangle(cornerRadius: radius.md))
        }
    }
}

// MARK: - Color Row

private struct ColorRow: View {
    @Environment(\.colorPalette) private var colors
    @Environment(\.spacingScale) private var spacing
    @Environment(\.radiusScale) private var radius

    let name: String
    let color: Color

    var body: some View {
        HStack(spacing: spacing.md) {
            // カラースウォッチ
            RoundedRectangle(cornerRadius: radius.sm)
                .fill(color)
                .frame(width: 40, height: 40)
                .overlay(
                    RoundedRectangle(cornerRadius: radius.sm)
                        .strokeBorder(colors.outline, lineWidth: 1)
                )

            // カラー名
            Text(name)
                .typography(.bodyMedium)
                .foregroundStyle(colors.onSurface)

            Spacer()

            // HEX値
            if let hex = color.hexString {
                Text(hex)
                    .typography(.bodySmall)
                    .foregroundStyle(colors.onSurfaceVariant)
                    .font(.system(.caption, design: .monospaced))
            }
        }
        .padding(.horizontal, spacing.sm)
        .padding(.vertical, spacing.xs)
        .background(colors.surface)
    }
}

// MARK: - Color Extension for Hex String

private extension Color {
    var hexString: String? {
        #if canImport(UIKit)
            guard let components = UIColor(self).cgColor.components else { return nil }
            let r = Int(components[0] * 255)
            let g = Int(components[1] * 255)
            let b = Int(components[2] * 255)
            return String(format: "#%02X%02X%02X", r, g, b)
        #elseif canImport(AppKit)
            guard let color = NSColor(self).usingColorSpace(.sRGB) else { return nil }
            let r = Int(color.redComponent * 255)
            let g = Int(color.greenComponent * 255)
            let b = Int(color.blueComponent * 255)
            return String(format: "#%02X%02X%02X", r, g, b)
        #else
            return nil
        #endif
    }
}

#Preview {
    @Previewable @State var themeProvider = ThemeProvider()

    ScrollView {
        ThemeColorPreview(theme: OceanTheme())
            .environment(themeProvider)
    }
    .theme(themeProvider)
}
