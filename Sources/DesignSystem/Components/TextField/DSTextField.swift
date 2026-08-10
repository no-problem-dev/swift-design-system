import SwiftUI

/// An input field with a label, placeholder, icons, supporting text, and error display.
///
/// Pick between the outlined and filled styles.
///
/// ## Example
/// ```swift
/// @State private var email = ""
/// @State private var password = ""
/// @State private var errorMessage: String?
///
/// VStack {
///     // Basic usage
///     DSTextField(
///         "Email address",
///         text: $email,
///         placeholder: "example@email.com",
///         leadingIcon: "envelope"
///     )
///
///     // Showing an error
///     DSTextField(
///         "Password",
///         text: $password,
///         placeholder: "8 characters or more",
///         style: .filled,
///         error: errorMessage,
///         leadingIcon: "lock"
///     )
///
///     // With supporting text
///     DSTextField(
///         "User name",
///         text: $username,
///         supportingText: "Letters and numbers only"
///     )
///
///     // Multiline input
///     DSTextField(
///         "Comment",
///         text: $comment,
///         placeholder: "Enter a comment...",
///         axis: .vertical
///     )
/// }
/// ```
///
/// ## Styles
/// - **Outlined**: A border and nothing else, the default. The cleaner look.
/// - **Filled**: A filled background, which makes the input area obvious.
public struct DSTextField: View {
    @Environment(\.colorPalette) private var colorPalette
    @Environment(\.spacingScale) private var spacing
    @Environment(\.radiusScale) private var radiusScale
    @FocusState private var isFocused: Bool

    private let title: String
    private let text: Binding<String>
    private let placeholder: String
    private let axis: Axis
    private let style: DSTextFieldStyle
    private let supportingText: String?
    private let error: String?
    private let leadingIcon: String?
    private let trailingIcon: String?
    private let focus: FocusState<Bool>.Binding?

    /// Creates a text field.
    ///
    /// - Parameters:
    ///   - title: The label text shown above the field. An empty string hides the label.
    ///   - text: A binding to the text being edited.
    ///   - placeholder: The text shown while the field is empty.
    ///   - axis: The direction the input grows in. Pass `.vertical` for multiline input.
    ///   - style: The outlined or filled style.
    ///   - supportingText: The text shown below the field. An error message takes its place.
    ///   - error: The error message. Passing one turns the label, icons, and border to the error
    ///     color.
    ///   - leadingIcon: The name of an SF Symbol shown at the leading edge.
    ///   - trailingIcon: The name of an SF Symbol shown at the trailing edge.
    ///   - focus: Pass a binding when the caller drives focus from its own `@FocusState`, such as
    ///     moving focus to a name field on returning from a scanner. When omitted, focus is managed
    ///     internally.
    public init(
        _ title: String = "",
        text: Binding<String>,
        placeholder: String = "",
        axis: Axis = .horizontal,
        style: DSTextFieldStyle = .outlined,
        supportingText: String? = nil,
        error: String? = nil,
        leadingIcon: String? = nil,
        trailingIcon: String? = nil,
        focus: FocusState<Bool>.Binding? = nil
    ) {
        self.title = title
        self.text = text
        self.placeholder = placeholder
        self.axis = axis
        self.style = style
        self.supportingText = supportingText
        self.error = error
        self.leadingIcon = leadingIcon
        self.trailingIcon = trailingIcon
        self.focus = focus
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: spacing.xs) {
            // Label
            if !title.isEmpty {
                Text(title)
                    .typography(.bodySmall)
                    .foregroundStyle(labelColor)
            }

            // Input Field
            HStack(spacing: spacing.md) {
                if let leadingIcon {
                    Image(systemName: leadingIcon)
                        .font(.system(size: 20))
                        .foregroundStyle(iconColor)
                }

                TextField(placeholder, text: text, axis: axis)
                    .typography(.bodyLarge)
                    .foregroundStyle(colorPalette.onSurface)
                    // The internal isFocused drives the border and label colors. Binding it
                    // alongside the external focus does not conflict: both simply receive the
                    // focus changes
                    .focused($isFocused)
                    .externalFocus(focus)

                if let trailingIcon {
                    Image(systemName: trailingIcon)
                        .font(.system(size: 20))
                        .foregroundStyle(iconColor)
                }
            }
            // macOS assumes pointer input, so the field height is brought closer to the standard
            // controls by shrinking the vertical padding.
            #if os(macOS)
            .padding(.horizontal, spacing.md)
            .padding(.vertical, spacing.xs)
            #else
            .padding(.horizontal, spacing.lg)
            .padding(.vertical, spacing.md)
            #endif
            .background(backgroundColor)
            .overlay(border)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))

            // Supporting/Error Text
            if let error = error {
                Text(error)
                    .typography(.bodySmall)
                    .foregroundStyle(colorPalette.error)
            } else if let supportingText = supportingText {
                Text(supportingText)
                    .typography(.bodySmall)
                    .foregroundStyle(colorPalette.onSurfaceVariant)
            }
        }
    }

    private var labelColor: Color {
        if error != nil {
            return colorPalette.error
        }
        return isFocused ? colorPalette.primary : colorPalette.onSurfaceVariant
    }

    private var iconColor: Color {
        if error != nil {
            return colorPalette.error
        }
        return isFocused ? colorPalette.primary : colorPalette.onSurfaceVariant
    }

    private var backgroundColor: Color {
        switch style {
        case .filled:
            return colorPalette.surfaceVariant
        case .outlined:
            return .clear
        }
    }

    @ViewBuilder
    private var border: some View {
        switch style {
        case .filled:
            EmptyView()
        case .outlined:
            RoundedRectangle(cornerRadius: cornerRadius)
                .stroke(borderColor, lineWidth: borderWidth)
        }
    }

    private var borderColor: Color {
        if error != nil {
            return colorPalette.error
        }
        return isFocused ? colorPalette.primary : colorPalette.outline
    }

    private var borderWidth: CGFloat {
        isFocused ? 2 : 1
    }

    private var cornerRadius: CGFloat {
        switch style {
        case .filled: return radiusScale.sm
        case .outlined: return radiusScale.sm
        }
    }
}

public enum DSTextFieldStyle {
    case filled
    case outlined
}

struct DSTextFieldPreview: View {
    @Environment(\.spacingScale) private var spacing

    var body: some View {
        VStack(spacing: spacing.xl) {
            DSTextField(
                "メールアドレス",
                text: .constant(""),
                placeholder: "example@email.com",
                style: .outlined,
                leadingIcon: "envelope"
            )

            DSTextField(
                "パスワード",
                text: .constant(""),
                placeholder: "パスワードを入力",
                style: .filled,
                supportingText: "8文字以上で入力してください",
                leadingIcon: "lock"
            )

            DSTextField(
                "ユーザー名",
                text: .constant("invalid"),
                placeholder: "ユーザー名",
                style: .outlined,
                error: "このユーザー名は既に使用されています"
            )
        }
        .padding()
    }
}

#Preview {
    DSTextFieldPreview()
        .theme(ThemeProvider())
}

private extension View {
    /// Applies `.focused` only when the caller passes a `@FocusState` binding.
    ///
    /// `.focused` changes the view type across the branch, so the optional is absorbed here.
    @ViewBuilder
    func externalFocus(_ focus: FocusState<Bool>.Binding?) -> some View {
        if let focus {
            focused(focus)
        } else {
            self
        }
    }
}
