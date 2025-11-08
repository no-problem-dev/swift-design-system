import SwiftUI

/// TextFieldコンポーネントのカタログビュー
struct TextFieldCatalogView: View {
    @Environment(\.colorPalette) private var colorPalette
    @Environment(\.spacingScale) private var spacing
    @State private var email = ""
    @State private var password = ""
    @State private var username = ""
    @State private var search = ""
    @State private var message = ""

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // 概要
                Text("テキストフィールドはユーザーからテキスト入力を受け取るコンポーネントです")
                    .typography(.bodyMedium)
                    .foregroundStyle(colorPalette.onSurfaceVariant)
                    .padding(.horizontal, spacing.lg)
                    .padding(.top, spacing.lg)

                // スタイルバリエーション
                SectionCard(title: "スタイルバリエーション") {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("2つのスタイルが利用可能")
                            .typography(.bodySmall)
                            .foregroundStyle(colorPalette.onSurfaceVariant)

                        VStack(spacing: spacing.lg) {
                            DSTextField(
                                "Outlined",
                                text: $email,
                                placeholder: "メールアドレス",
                                style: .outlined
                            )

                            DSTextField(
                                "Filled",
                                text: $password,
                                placeholder: "パスワード",
                                style: .filled
                            )
                        }
                    }
                }

                // アイコン付き
                SectionCard(title: "アイコン付き") {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("先頭または末尾にアイコンを配置可能")
                            .typography(.bodySmall)
                            .foregroundStyle(colorPalette.onSurfaceVariant)

                        VStack(spacing: spacing.lg) {
                            DSTextField(
                                "Leading Icon",
                                text: $email,
                                placeholder: "example@email.com",
                                style: .outlined,
                                leadingIcon: "envelope"
                            )

                            DSTextField(
                                "Trailing Icon",
                                text: $search,
                                placeholder: "検索",
                                style: .outlined,
                                trailingIcon: "magnifyingglass"
                            )

                            DSTextField(
                                "Both Icons",
                                text: $password,
                                placeholder: "パスワード",
                                style: .outlined,
                                leadingIcon: "lock",
                                trailingIcon: "eye"
                            )
                        }
                    }
                }

                // サポートテキスト
                SectionCard(title: "サポートテキスト") {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("補助的な情報を表示")
                            .typography(.bodySmall)
                            .foregroundStyle(colorPalette.onSurfaceVariant)

                        DSTextField(
                            "ユーザー名",
                            text: $username,
                            placeholder: "ユーザー名を入力",
                            style: .outlined,
                            supportingText: "3文字以上20文字以内で入力してください"
                        )
                    }
                }

                // エラー状態
                SectionCard(title: "エラー状態") {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("バリデーションエラーの表示")
                            .typography(.bodySmall)
                            .foregroundStyle(colorPalette.onSurfaceVariant)

                        DSTextField(
                            "メールアドレス",
                            text: $email,
                            placeholder: "example@email.com",
                            style: .outlined,
                            error: "メールアドレスの形式が正しくありません",
                            leadingIcon: "envelope"
                        )
                    }
                }

                // 複数行テキスト
                SectionCard(title: "複数行テキスト") {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("長いテキスト入力用")
                            .typography(.bodySmall)
                            .foregroundStyle(colorPalette.onSurfaceVariant)

                        VStack(alignment: .leading, spacing: 4) {
                            Text("メッセージ")
                                .typography(.bodySmall)
                                .foregroundStyle(colorPalette.onSurface.opacity(0.7))

                            TextEditor(text: $message)
                                .typography(.bodyLarge)
                                .scrollContentBackground(.hidden)
                                .frame(height: 100)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 8)
                                .background(colorPalette.surfaceVariant.opacity(0.5))
                                .clipShape(RoundedRectangle(cornerRadius: 4))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 4)
                                        .stroke(colorPalette.outline, lineWidth: 1)
                                )

                            Text("メッセージを入力してください")
                                .typography(.bodySmall)
                                .foregroundStyle(colorPalette.onSurfaceVariant)
                        }
                    }
                }

                // 使用例
                SectionCard(title: "使用例") {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("SwiftUI での使用方法")
                            .typography(.titleSmall)

                        Text("""
                        @State private var email = ""

                        DSTextField(
                            "メールアドレス",
                            text: $email,
                            placeholder: "example@email.com",
                            style: .outlined,
                            leadingIcon: "envelope"
                        )
                        """)
                        .typography(.bodySmall)
                        .fontDesign(.monospaced)
                        .padding()
                        .background(colorPalette.surfaceVariant.opacity(0.5))
                        .cornerRadius(8)
                    }
                }

                // フォーム例
                SectionCard(title: "フォーム例") {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("実際のフォームでの使用例")
                            .typography(.bodySmall)
                            .foregroundStyle(colorPalette.onSurfaceVariant)

                        Card {
                            VStack(spacing: spacing.lg) {
                                Text("アカウント登録")
                                    .typography(.titleLarge)
                                    .frame(maxWidth: .infinity, alignment: .leading)

                                DSTextField(
                                    "メールアドレス",
                                    text: $email,
                                    placeholder: "example@email.com",
                                    style: .outlined,
                                    leadingIcon: "envelope"
                                )

                                DSTextField(
                                    "パスワード",
                                    text: $password,
                                    placeholder: "パスワード",
                                    style: .outlined,
                                    supportingText: "8文字以上で入力してください",
                                    leadingIcon: "lock"
                                )

                                DSTextField(
                                    "ユーザー名",
                                    text: $username,
                                    placeholder: "ユーザー名",
                                    style: .outlined,
                                    leadingIcon: "person"
                                )

                                Button("登録") {}
                                    .buttonStyle(.primary)
                                    .buttonSize(.large)
                            }
                        }
                    }
                }
            }
            .padding(.bottom, spacing.xl)
        }
        .background(colorPalette.background)
        .navigationTitle("TextField")
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
    }
}

#Preview {
    NavigationStack {
        TextFieldCatalogView()
            .theme(ThemeProvider())
    }
}
