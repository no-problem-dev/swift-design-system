import SwiftUI

/// The text roles the design system provides.
///
/// Each role carries a font size, a weight, and a line height, which keeps text styling
/// consistent. Apply a role with the `.typography()` modifier.
///
/// ## Example
/// ```swift
/// Text("Large heading")
///     .typography(.headlineLarge)
///
/// Text("Body text")
///     .typography(.bodyMedium)
///
/// Button("Button label") { }
///     .typography(.labelLarge)
/// ```
///
/// ## Categories
/// - **Display**: the largest sizes (57pt to 36pt) - heroes and landing pages
/// - **Headline**: headings (32pt to 24pt) - section headings
/// - **Title**: titles (22pt to 14pt) - card titles and dialogs
/// - **Body**: body text (16pt to 12pt) - paragraphs and descriptions
/// - **Label**: labels (14pt to 11pt) - buttons, tabs, and forms
public enum Typography: CaseIterable, Sendable {
    // MARK: - Display

    /// Display Large - the largest and most prominent text.
    /// Size: 57pt, weight: Bold
    case displayLarge

    /// Display Medium
    /// Size: 45pt, weight: Bold
    case displayMedium

    /// Display Small
    /// Size: 36pt, weight: Bold
    case displaySmall

    // MARK: - Headline

    /// Headline Large - a large heading.
    /// Size: 32pt, weight: Semibold
    case headlineLarge

    /// Headline Medium - a medium heading.
    /// Size: 28pt, weight: Semibold
    case headlineMedium

    /// Headline Small - a small heading.
    /// Size: 24pt, weight: Semibold
    case headlineSmall

    // MARK: - Title

    /// Title Large - a large title.
    /// Size: 22pt, weight: Semibold
    case titleLarge

    /// Title Medium - a medium title.
    /// Size: 16pt, weight: Semibold
    case titleMedium

    /// Title Small - a small title.
    /// Size: 14pt, weight: Semibold
    case titleSmall

    // MARK: - Body

    /// Body Large - large body text.
    /// Size: 16pt, weight: Regular
    case bodyLarge

    /// Body Medium - the standard body text.
    /// Size: 14pt, weight: Regular
    case bodyMedium

    /// Body Small - small body text.
    /// Size: 12pt, weight: Regular
    case bodySmall

    // MARK: - Label

    /// Label Large - a large label, for buttons and tabs.
    /// Size: 14pt, weight: Medium
    case labelLarge

    /// Label Medium - the standard label.
    /// Size: 12pt, weight: Medium
    case labelMedium

    /// Label Small - a small label.
    /// Size: 11pt, weight: Medium
    case labelSmall

    // MARK: - Properties

    public var size: CGFloat {
        switch self {
        // Display
        case .displayLarge: return PrimitiveTypography.size57
        case .displayMedium: return PrimitiveTypography.size45
        case .displaySmall: return PrimitiveTypography.size36

        // Headline
        case .headlineLarge: return PrimitiveTypography.size32
        case .headlineMedium: return PrimitiveTypography.size28
        case .headlineSmall: return PrimitiveTypography.size24

        // Title
        case .titleLarge: return PrimitiveTypography.size22
        case .titleMedium: return PrimitiveTypography.size16
        case .titleSmall: return PrimitiveTypography.size14

        // Body
        case .bodyLarge: return PrimitiveTypography.size16
        case .bodyMedium: return PrimitiveTypography.size14
        case .bodySmall: return PrimitiveTypography.size12

        // Label
        case .labelLarge: return PrimitiveTypography.size14
        case .labelMedium: return PrimitiveTypography.size12
        case .labelSmall: return PrimitiveTypography.size11
        }
    }

    public var weight: Font.Weight {
        switch self {
        // Display
        case .displayLarge, .displayMedium, .displaySmall:
            return .bold

        // Headline
        case .headlineLarge, .headlineMedium, .headlineSmall:
            return .semibold

        // Title
        case .titleLarge, .titleMedium, .titleSmall:
            return .semibold

        // Body
        case .bodyLarge, .bodyMedium, .bodySmall:
            return .regular

        // Label
        case .labelLarge, .labelMedium, .labelSmall:
            return .medium
        }
    }

    /// A SwiftUI font at the fixed size of this role.
    ///
    /// The size does not scale with Dynamic Type. Apply the role with the `.typography()`
    /// modifier instead when the text should scale.
    public var font: Font {
        .system(size: size, weight: weight, design: .default)
    }

    /// Creates a SwiftUI font with the given design.
    ///
    /// The size does not scale with Dynamic Type.
    /// - Parameter design: The font design, such as .default, .serif, .rounded, or .monospaced.
    public func font(design: Font.Design) -> Font {
        .system(size: size, weight: weight, design: design)
    }

    /// The text style this role scales against under Dynamic Type.
    ///
    /// The style is chosen by what the role means. Larger iOS text styles grow by less than
    /// smaller ones: at the largest accessibility size, body grows about 3.1x while
    /// largeTitle grows about 1.9x. Relating a large role to a large text style keeps the
    /// difference between a heading and body text intact at the largest sizes, so headings
    /// do not fill the screen on their own.
    public var relativeTextStyle: Font.TextStyle {
        switch self {
        case .displayLarge, .displayMedium, .displaySmall: return .largeTitle
        case .headlineLarge, .headlineMedium: return .title
        case .headlineSmall: return .title2
        case .titleLarge: return .title3
        case .titleMedium, .titleSmall: return .headline
        case .bodyLarge, .bodyMedium: return .body
        case .bodySmall: return .footnote
        case .labelLarge: return .subheadline
        case .labelMedium: return .footnote
        case .labelSmall: return .caption
        }
    }

    /// The line height, as specified by Material Design 3.
    public var lineHeight: CGFloat {
        switch self {
        // Display
        case .displayLarge: return PrimitiveTypography.lineHeight64
        case .displayMedium: return PrimitiveTypography.lineHeight52
        case .displaySmall: return PrimitiveTypography.lineHeight44

        // Headline
        case .headlineLarge: return PrimitiveTypography.lineHeight40
        case .headlineMedium: return PrimitiveTypography.lineHeight36
        case .headlineSmall: return PrimitiveTypography.lineHeight32

        // Title
        case .titleLarge: return PrimitiveTypography.lineHeight28
        case .titleMedium: return PrimitiveTypography.lineHeight24
        case .titleSmall: return PrimitiveTypography.lineHeight20

        // Body
        case .bodyLarge: return PrimitiveTypography.lineHeight24
        case .bodyMedium: return PrimitiveTypography.lineHeight20
        case .bodySmall: return PrimitiveTypography.lineHeight16

        // Label
        case .labelLarge: return PrimitiveTypography.lineHeight20
        case .labelMedium: return PrimitiveTypography.lineHeight16
        case .labelSmall: return PrimitiveTypography.lineHeight16
        }
    }
}
