import SwiftUI

/// テキストフィールドコンポーネント
///
/// ラベル、プレースホルダー、アイコン、補助テキスト、エラー表示を備えた高機能な入力フィールド。
/// Outlined / Filled の 2 スタイルから選択できる。
///
/// ## 使用例
/// ```swift
/// @State private var email = ""
/// @State private var password = ""
/// @State private var errorMessage: String?
///
/// VStack {
///     // 基本的な使い方
///     DSTextField(
///         "メールアドレス",
///         text: $email,
///         placeholder: "example@email.com",
///         leadingIcon: "envelope"
///     )
///
///     // エラー表示
///     DSTextField(
///         "パスワード",
///         text: $password,
///         placeholder: "8文字以上",
///         style: .filled,
///         error: errorMessage,
///         leadingIcon: "lock"
///     )
///
///     // サポートテキスト付き
///     DSTextField(
///         "ユーザー名",
///         text: $username,
///         supportingText: "英数字のみ使用可能"
///     )
///
///     // 複数行入力
///     DSTextField(
///         "コメント",
///         text: $comment,
///         placeholder: "コメントを入力...",
///         axis: .vertical
///     )
/// }
/// ```
///
/// ## スタイル
/// - **Outlined**: 枠線のみ（デフォルト）- クリーンな印象
/// - **Filled**: 背景色あり - 入力欄が明確
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

    /// DSTextField を作成
    ///
    /// - Parameters:
    ///   - title: ラベルテキスト
    ///   - text: テキストのバインディング
    ///   - placeholder: プレースホルダー
    ///   - axis: 入力の展開方向。`.vertical` で複数行入力に対応（デフォルト: `.horizontal`）
    ///   - style: Outlined / Filled
    ///   - supportingText: 補助テキスト
    ///   - error: エラーメッセージ
    ///   - leadingIcon: 先頭アイコン（SF Symbols）
    ///   - trailingIcon: 末尾アイコン（SF Symbols）
    ///   - focus: 呼び出し側の `@FocusState` でフォーカスを制御したいときに渡す
    ///     （スキャナからの復帰で名前欄へフォーカスを移す等）。省略時は内部管理のみ
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
                    // 内部の isFocused は枠線・ラベル色の描画用。外部 focus と二重に
                    // バインドしても両方がフォーカス変化を受け取るだけで競合しない
                    .focused($isFocused)
                    .externalFocus(focus)

                if let trailingIcon {
                    Image(systemName: trailingIcon)
                        .font(.system(size: 20))
                        .foregroundStyle(iconColor)
                }
            }
            // macOS はポインタ操作前提でフィールド高を標準コントロールに寄せる（縦余白を縮小）。
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

/// DSTextFieldのスタイル
public enum DSTextFieldStyle {
    /// 塗りつぶしスタイル
    case filled
    /// アウトラインスタイル
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
    /// 呼び出し側の `@FocusState` バインディングが渡されたときだけ `.focused` を重ねる。
    /// `.focused` は条件分岐で型が変わるため、optional を吸収するここに閉じ込める。
    @ViewBuilder
    func externalFocus(_ focus: FocusState<Bool>.Binding?) -> some View {
        if let focus {
            focused(focus)
        } else {
            self
        }
    }
}
