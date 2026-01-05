import SwiftUI

/// TextFieldコンポーネントのカタログビュー
struct TextFieldCatalogView: View {
    @Environment(\.colorPalette) private var colors
    @Environment(\.spacingScale) private var spacing
    @Environment(\.radiusScale) private var radius
    @State private var email = ""
    @State private var password = ""
    @State private var username = ""
    @State private var search = ""
    @State private var message = ""

    var body: some View {
        CatalogPageContainer(title: "TextField") {
            CatalogOverview(description: "ユーザーからテキスト入力を受け取るコンポーネント")

            SectionCard(title: "スタイル") {
                VariantShowcase(title: "スタイルバリエーション", description: "2つのスタイルが利用可能") {
                    VStack(spacing: spacing.lg) {
                        DSTextField("Outlined", text: $email, placeholder: "メールアドレス", style: .outlined)
                        DSTextField("Filled", text: $password, placeholder: "パスワード", style: .filled)
                    }
                }
            }

            SectionCard(title: "アイコン") {
                VariantShowcase(title: "アイコン付き", description: "先頭または末尾にアイコンを配置") {
                    VStack(spacing: spacing.lg) {
                        DSTextField("Leading", text: $email, placeholder: "example@email.com", style: .outlined, leadingIcon: "envelope")
                        DSTextField("Trailing", text: $search, placeholder: "検索", style: .outlined, trailingIcon: "magnifyingglass")
                        DSTextField("Both", text: $password, placeholder: "パスワード", style: .outlined, leadingIcon: "lock", trailingIcon: "eye")
                    }
                }
            }

            SectionCard(title: "サポートテキスト") {
                DSTextField("ユーザー名", text: $username, placeholder: "ユーザー名を入力", style: .outlined, supportingText: "3文字以上20文字以内")
            }

            SectionCard(title: "エラー状態") {
                DSTextField("メールアドレス", text: $email, placeholder: "example@email.com", style: .outlined, error: "形式が正しくありません", leadingIcon: "envelope")
            }

            SectionCard(title: "複数行") {
                VStack(alignment: .leading, spacing: spacing.xs) {
                    Text("メッセージ")
                        .typography(.bodySmall)
                        .foregroundStyle(colors.onSurface.opacity(0.7))

                    TextEditor(text: $message)
                        .typography(.bodyLarge)
                        .scrollContentBackground(.hidden)
                        .frame(height: 100)
                        .padding(.horizontal, spacing.md)
                        .padding(.vertical, spacing.sm)
                        .background(colors.surfaceVariant.opacity(0.5))
                        .clipShape(RoundedRectangle(cornerRadius: radius.xs))
                        .overlay(RoundedRectangle(cornerRadius: radius.xs).stroke(colors.outline, lineWidth: 1))
                }
            }

            SectionCard(title: "使用例") {
                CodeExample(code: """
                    DSTextField(
                        "メールアドレス",
                        text: $email,
                        placeholder: "example@email.com",
                        style: .outlined,
                        leadingIcon: "envelope"
                    )
                    """)
            }

            SectionCard(title: "フォーム例") {
                Card {
                    VStack(spacing: spacing.lg) {
                        Text("アカウント登録")
                            .typography(.titleLarge)
                            .frame(maxWidth: .infinity, alignment: .leading)

                        DSTextField("メールアドレス", text: $email, placeholder: "example@email.com", style: .outlined, leadingIcon: "envelope")
                        DSTextField("パスワード", text: $password, placeholder: "パスワード", style: .outlined, supportingText: "8文字以上", leadingIcon: "lock")
                        DSTextField("ユーザー名", text: $username, placeholder: "ユーザー名", style: .outlined, leadingIcon: "person")

                        Button("登録") {}
                            .buttonStyle(.primary)
                            .buttonSize(.large)
                    }
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        TextFieldCatalogView()
            .theme(ThemeProvider())
    }
}
