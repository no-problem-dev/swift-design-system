import Foundation

/// The group a theme belongs to when themes are listed by purpose.
///
/// ## Categories
/// - **standard**: The basic light and dark theme.
/// - **brandPersonality**: Themes that carry a brand personality, such as Ocean, Forest, and Sunset.
/// - **accessibility**: High contrast themes that meet WCAG.
/// - **custom**: Themes an app defines for itself.
public enum ThemeCategory: String, Sendable, CaseIterable, Identifiable {
    case standard = "Standard"

    case custom = "Custom"

    case brandPersonality = "Brand Personality"

    case accessibility = "Accessibility"

    public var id: String { rawValue }

    /// A sentence describing the category, for display below its name.
    public var description: String {
        switch self {
        case .standard:
            return String(localized: "The basic light and dark themes", bundle: .module)
        case .brandPersonality:
            return String(localized: "A range of themes that express a brand's personality", bundle: .module)
        case .accessibility:
            return String(localized: "High contrast themes built for accessibility", bundle: .module)
        case .custom:
            return String(localized: "Custom themes defined by the app", bundle: .module)
        }
    }

    /// The name of the SF Symbol that stands for the category.
    public var icon: String {
        switch self {
        case .standard:
            return "circle.lefthalf.filled"
        case .brandPersonality:
            return "paintpalette.fill"
        case .accessibility:
            return "eye.fill"
        case .custom:
            return "wand.and.stars"
        }
    }
}
