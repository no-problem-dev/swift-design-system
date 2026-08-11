import SwiftUI

/// A card that stands for a reference to a URL, such as a source, a related link or a citation.
///
/// It shows a title, the domain, and an accessory of your choice such as a status chip, and
/// runs any action you give it on tap, for example opening an in-app browser.
///
/// Fetching metadata, with LinkPresentation or anything else, is the caller's job. This
/// component only displays the data it is handed.
///
/// ## Basic example
/// ```swift
/// // A plain link card
/// LinkCard(title: "Swift.org - Concurrency", url: url) {
///     openInBrowser(url)
/// }
///
/// // With a status, for example the result of verifying a source
/// LinkCard(title: "WWDC25 session notes", url: url) {
///     openInBrowser(url)
/// } accessory: {
///     Chip("Fetched", systemImage: "checkmark")
///         .chipStyle(.filled)
///         .chipSize(.small)
/// }
/// ```
public struct LinkCard<Accessory: View>: View {
    @Environment(\.colorPalette) private var colors
    @Environment(\.spacingScale) private var spacing
    @Environment(\.radiusScale) private var radius

    private let title: String?
    private let url: URL
    private let systemImage: String
    private let action: (() -> Void)?
    private let accessory: Accessory

    /// Creates a link card.
    /// - Parameters:
    ///   - title: The title to show. When `nil`, the host name is used instead.
    ///   - url: The URL being referenced. Its host name is shown as the subtitle.
    ///   - systemImage: The name of the symbol shown in the leading badge.
    ///   - action: What to run when the card is tapped. When `nil`, the card is not tappable.
    ///   - accessory: The view placed at the trailing edge, such as a status chip.
    public init(
        title: String?,
        url: URL,
        systemImage: String = "globe",
        action: (() -> Void)? = nil,
        @ViewBuilder accessory: () -> Accessory
    ) {
        self.title = title
        self.url = url
        self.systemImage = systemImage
        self.action = action
        self.accessory = accessory()
    }

    public var body: some View {
        if let action {
            Button(action: action) { cardBody }
                .buttonStyle(.plain)
                .accessibilityLabel(displayTitle)
                .accessibilityHint("Opens the link")
        } else {
            cardBody
        }
    }

    private var cardBody: some View {
        HStack(spacing: spacing.sm) {
            IconBadge(
                systemName: systemImage,
                size: .small,
                foregroundColor: colors.primary,
                backgroundColor: colors.primary.opacity(0.12)
            )
            VStack(alignment: .leading, spacing: spacing.xxs) {
                Text(displayTitle)
                    .typography(.labelLarge)
                    .foregroundStyle(colors.onSurface)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                if let host = url.host() {
                    Text(host)
                        .typography(.labelSmall)
                        .foregroundStyle(colors.onSurfaceVariant)
                        .lineLimit(1)
                }
            }
            Spacer(minLength: spacing.xs)
            accessory
            if action != nil {
                Image(systemName: "arrow.up.right")
                    .typography(.labelMedium)
                    .foregroundStyle(colors.onSurfaceVariant)
            }
        }
        .padding(spacing.md)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(colors.elevatedSurface, in: RoundedRectangle(cornerRadius: radius.lg, style: .continuous))
        .contentShape(RoundedRectangle(cornerRadius: radius.lg, style: .continuous))
    }

    private var displayTitle: String {
        if let title, !title.isEmpty { return title }
        return url.host() ?? url.absoluteString
    }
}

public extension LinkCard where Accessory == EmptyView {
    /// Creates a link card with no accessory.
    /// - Parameters:
    ///   - title: The title to show. When `nil`, the host name is used instead.
    ///   - url: The URL being referenced.
    ///   - systemImage: The name of the symbol shown in the leading badge.
    ///   - action: What to run when the card is tapped. When `nil`, the card is not tappable.
    init(
        title: String?,
        url: URL,
        systemImage: String = "globe",
        action: (() -> Void)? = nil
    ) {
        self.init(title: title, url: url, systemImage: systemImage, action: action) {
            EmptyView()
        }
    }
}

// MARK: - Previews

#Preview("Link Cards") {
    VStack(spacing: 12) {
        LinkCard(
            title: "Swift Concurrency - The Swift Programming Language",
            url: URL(string: "https://docs.swift.org/swift-book/")!
        ) {}

        LinkCard(
            title: nil,
            url: URL(string: "https://developer.apple.com/videos/")!
        ) {}

        LinkCard(
            title: "Verified Source",
            url: URL(string: "https://swift.org/blog/")!,
            action: {}
        ) {
            Chip("Fetched", systemImage: "checkmark")
                .chipStyle(.filled)
                .chipSize(.small)
                .foregroundColor(.green)
        }
    }
    .padding()
    .theme(ThemeProvider())
}
