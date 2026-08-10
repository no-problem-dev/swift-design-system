import SwiftUI

/// A rounded surface card that plays the part of a `Section` on settings and hub screens.
///
/// Builds the same visual hierarchy as `List { Section { ... } }` out of design system tokens
/// alone (surface / spacing / typography / radius).
///
/// ## Two ways to use it
///
/// ### 1. Surface section (recommended)
/// A small uppercase header, a rounded surface card, and a footer description.
/// Stack `SectionRow` vertically inside, with `SectionRowDivider` between rows where needed.
///
/// ```swift
/// SectionCard("Notifications", footer: "Notification Center is configured in system settings") {
///     SectionRow {
///         Text("Morning reminder")
///         Spacer(minLength: 0)
///         Toggle("", isOn: $isOn).labelsHidden()
///     }
///     SectionRowDivider()
///     NavigationLink(destination: DetailView()) {
///         SectionNavigationLabel("Details", systemImage: "gear")
///     }
/// }
/// ```
///
/// ### 2. Titled card
/// A title plus a general purpose container wrapped in `Card`. Use it for freely arranged
/// layouts such as forms and dashboards.
///
/// ```swift
/// SectionCard(title: "Profile", elevation: .level2) {
///     VStack(alignment: .leading) {
///         Text("Name: Taro Yamada")
///         Text("Email: yamada@example.com")
///     }
/// }
/// ```
public struct SectionCard<Content: View>: View {
    @Environment(\.colorPalette) private var colors
    @Environment(\.spacingScale) private var spacing
    @Environment(\.radiusScale) private var radius

    private let style: Style
    private let content: () -> Content

    private enum Style {
        case surface(header: String?, footer: String?)
        case titled(title: String, elevation: Elevation)
    }

    /// Creates a card in the surface section style.
    ///
    /// - Parameters:
    ///   - header: The label shown above the card, uppercased. Pass `nil` to hide it.
    ///   - footer: The explanatory text shown below the card.
    ///   - content: The content inside the card, usually a vertical stack of `SectionRow`.
    public init(
        _ header: String? = nil,
        footer: String? = nil,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.style = .surface(header: header, footer: footer)
        self.content = content
    }

    /// Creates a card in the titled card style.
    ///
    /// - Parameters:
    ///   - title: The section title.
    ///   - elevation: The elevation level of the card.
    ///   - content: The content shown inside the card.
    public init(
        title: String,
        elevation: Elevation = .level1,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.style = .titled(title: title, elevation: elevation)
        self.content = content
    }

    public var body: some View {
        switch style {
        case let .surface(header, footer):
            VStack(alignment: .leading, spacing: spacing.xs) {
                if let header {
                    Text(header)
                        .typography(.labelSmall)
                        .foregroundStyle(colors.onSurfaceVariant)
                        .textCase(.uppercase)
                        .padding(.horizontal, spacing.md)
                }

                VStack(spacing: 0) {
                    content()
                }
                .background(colors.surface)
                .clipShape(RoundedRectangle(cornerRadius: radius.lg))

                if let footer {
                    Text(footer)
                        .typography(.labelSmall)
                        .foregroundStyle(colors.onSurfaceVariant)
                        .padding(.horizontal, spacing.md)
                }
            }

        case let .titled(title, elevation):
            VStack(alignment: .leading, spacing: spacing.md) {
                Text(title)
                    .typography(.titleMedium)
                    .foregroundStyle(colors.onSurface)

                Card(elevation: elevation) {
                    content()
                }
            }
            .padding(.horizontal, spacing.lg)
        }
    }
}

#Preview("Surface Section") {
    @Previewable @Environment(\.spacingScale) var spacing

    ScrollView {
        VStack(spacing: spacing.xl) {
            SectionCard("通知", footer: "通知センターの設定はシステム設定から") {
                SectionRow {
                    Text("朝のリマインド")
                    Spacer(minLength: 0)
                    Text("ON").foregroundStyle(.secondary)
                }
                SectionRowDivider()
                SectionRow {
                    SectionNavigationLabel("通知の詳細設定", systemImage: "gear")
                }
            }

            SectionCard("アカウント") {
                SectionRow {
                    Text("メール")
                    Spacer(minLength: 0)
                    Text("user@example.com").foregroundStyle(.secondary)
                }
            }
        }
        .padding(.vertical, spacing.xl)
    }
    .theme(ThemeProvider())
}

#Preview("Titled Card") {
    @Previewable @Environment(\.spacingScale) var spacing

    ScrollView {
        VStack(spacing: spacing.xl) {
            SectionCard(title: "基本情報") {
                VStack(alignment: .leading, spacing: spacing.md) {
                    Text("名前: 山田太郎").typography(.bodyMedium)
                    Text("メール: yamada@example.com").typography(.bodyMedium)
                }
            }
        }
        .padding(.vertical, spacing.xl)
    }
    .theme(ThemeProvider())
}
