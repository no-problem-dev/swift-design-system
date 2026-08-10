import SwiftUI

/// An explicit state for when a list, a grid, or a set of search results is empty.
///
/// Shows an icon, a heading, and an optional description, centered.
///
/// ## Example
/// ```swift
/// EmptyState(
///     systemImage: "link",
///     title: "No sources",
///     description: "Sessions that ran a web search list the URLs they referenced here."
/// )
/// ```
public struct EmptyState: View {
    @Environment(\.colorPalette) private var colors
    @Environment(\.spacingScale) private var spacing

    private let systemImage: String
    private let title: String
    private let description: String?

    /// Creates an empty state.
    /// - Parameters:
    ///   - systemImage: The SF Symbols icon name.
    ///   - title: The heading, saying what is missing.
    ///   - description: Supporting text, saying how the missing content would appear.
    public init(systemImage: String, title: String, description: String? = nil) {
        self.systemImage = systemImage
        self.title = title
        self.description = description
    }

    public var body: some View {
        VStack(spacing: spacing.sm) {
            IconBadge(
                systemName: systemImage,
                size: .medium,
                foregroundColor: colors.onSurfaceVariant,
                backgroundColor: colors.surfaceVariant
            )
            Text(title)
                .typography(.titleMedium)
                .foregroundStyle(colors.onSurface)
                .multilineTextAlignment(.center)
            if let description {
                Text(description)
                    .typography(.bodySmall)
                    .foregroundStyle(colors.onSurfaceVariant)
                    .multilineTextAlignment(.center)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(spacing.xl)
        .accessibilityElement(children: .combine)
    }
}

// MARK: - Previews

#Preview("Empty States") {
    VStack(spacing: 32) {
        EmptyState(
            systemImage: "link",
            title: "出典はありません",
            description: "Web 調査を行ったセッションでは、参照した URL がここに並びます。"
        )
        EmptyState(
            systemImage: "photo.on.rectangle.angled",
            title: "メディアはありません"
        )
    }
    .padding()
    .theme(ThemeProvider())
}
