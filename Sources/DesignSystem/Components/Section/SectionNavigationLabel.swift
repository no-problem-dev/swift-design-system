import SwiftUI

/// The label of a navigation row, with a chevron at the trailing edge.
///
/// Use it as `NavigationLink { ... } label: { SectionNavigationLabel("title") }`.
/// It builds a `SectionRow` internally, so it can be placed directly inside a `SectionCard`.
///
/// ## Example
/// ```swift
/// SectionCard("Settings") {
///     NavigationLink {
///         NotificationSettingsView()
///     } label: {
///         SectionNavigationLabel("Notification settings", systemImage: "bell.badge")
///     }
/// }
/// ```
public struct SectionNavigationLabel: View {
    @Environment(\.colorPalette) private var colors

    private let title: String
    private let systemImage: String?
    private let subtitle: String?

    /// Creates a navigation label with a trailing chevron.
    ///
    /// - Parameters:
    ///   - title: The label text.
    ///   - systemImage: The name of an SF Symbol shown at the leading edge.
    ///   - subtitle: Supplementary text placed below the title.
    public init(_ title: String, systemImage: String? = nil, subtitle: String? = nil) {
        self.title = title
        self.systemImage = systemImage
        self.subtitle = subtitle
    }

    public var body: some View {
        SectionRow {
            SectionRowLabel(title, systemImage: systemImage, subtitle: subtitle)
            Spacer(minLength: 0)
            Image(systemName: "chevron.right")
                .typography(.labelSmall)
                .foregroundStyle(colors.onSurfaceVariant)
        }
    }
}
