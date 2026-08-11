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
            return "The basic light and dark themes"
        case .brandPersonality:
            return "A range of themes that express a brand's personality"
        case .accessibility:
            return "High contrast themes built for accessibility"
        case .custom:
            return "Custom themes defined by the app"
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
