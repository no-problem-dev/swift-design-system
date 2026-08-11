import SwiftUI

/// A label with a leading icon column, for the start of a section row.
///
/// Rows without an icon still reserve the column, so labels keep their leading edge on the same
/// vertical line whether or not the row has an icon. The width of the column, the glyph size, and
/// the minimum height of the row are derived from tokens by `SectionRowMetrics` and follow
/// Dynamic Type.
///
/// ## Example
/// ```swift
/// SectionCard("Notifications") {
///     SectionRow {
///         SectionRowLabel("Morning reminder", systemImage: "bell")
///         Spacer(minLength: 0)
///         Toggle("", isOn: $isOn).labelsHidden()
///     }
///     SectionRowDivider()
///     SectionRow {
///         SectionRowLabel("Email", subtitle: "user@example.com")
///     }
/// }
/// ```
public struct SectionRowLabel: View {
    @Environment(\.colorPalette) private var colors
    @Environment(\.iconSizeScale) private var iconSize
    @Environment(\.spacingScale) private var spacing
    @ScaledMetric(relativeTo: .body) private var typeScale: CGFloat = 1

    private let title: String
    private let systemImage: String?
    private let subtitle: String?

    /// Creates the label of a section row.
    ///
    /// - Parameters:
    ///   - title: The primary label text.
    ///   - systemImage: The name of an SF Symbol placed at the leading edge. The column keeps its
    ///     width even when this is omitted.
    ///   - subtitle: Supplementary text placed below the title.
    public init(_ title: String, systemImage: String? = nil, subtitle: String? = nil) {
        self.title = title
        self.systemImage = systemImage
        self.subtitle = subtitle
    }

    public var body: some View {
        let metrics = SectionRowMetrics(iconSize: iconSize, spacing: spacing, typeScale: typeScale)
        HStack(spacing: metrics.iconGap) {
            iconColumn(metrics)
            VStack(alignment: .leading, spacing: spacing.xxs) {
                Text(title)
                    .typography(.bodyLarge)
                    .foregroundStyle(colors.onSurface)
                    .multilineTextAlignment(.leading)
                if let subtitle {
                    Text(subtitle)
                        .typography(.labelSmall)
                        .foregroundStyle(colors.onSurfaceVariant)
                        .multilineTextAlignment(.leading)
                }
            }
        }
    }

    private func iconColumn(_ metrics: SectionRowMetrics) -> some View {
        Group {
            if let systemImage {
                Image(systemName: systemImage)
                    .font(.system(size: metrics.iconGlyphSize))
                    .foregroundStyle(colors.onSurface)
            } else {
                // Rows without an icon reserve the column too. Without it, the leading edge of the
                // label moves from row to row. The height is closed to the glyph size because Color
                // otherwise stretches vertically and makes this row alone taller
                Color.clear.frame(height: metrics.iconGlyphSize)
            }
        }
        .frame(width: metrics.iconColumnWidth)
    }
}

#Preview("Section Row Labels") {
    @Previewable @Environment(\.spacingScale) var spacing

    ScrollView {
        VStack(spacing: spacing.xl) {
            SectionCard("Account", footer: "Labels keep the same left edge with or without an icon") {
                SectionRow { SectionRowLabel("Profile", systemImage: "person.crop.circle") }
                SectionRowDivider()
                SectionRow { SectionRowLabel("Password", systemImage: "lock") }
                SectionRowDivider()
                SectionRow { SectionRowLabel("Connected Services", systemImage: "rectangle.3.group") }
                SectionRowDivider()
                SectionRow { SectionRowLabel("Email", subtitle: "user@example.com") }
            }
        }
        .padding(spacing.lg)
    }
    .theme(ThemeProvider())
}
