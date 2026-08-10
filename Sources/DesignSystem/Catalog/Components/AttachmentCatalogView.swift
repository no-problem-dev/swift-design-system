import SwiftUI

struct AttachmentCatalogView: View {
    @Environment(\.spacingScale) private var spacing

    var body: some View {
        CatalogPageContainer(title: "Attachment") {
            CatalogOverview(description: "選択済み添付を表す logic-less な atom/molecule。ドメイン型・state・IO を持たず、削除は callback、items は呼び出し側が渡す。")

            SectionCard(title: "サムネイル") {
                VStack(alignment: .leading, spacing: spacing.lg) {
                    VariantShowcase(title: "画像プレビュー") {
                        AttachmentThumbnail(image: Image(systemName: "photo"), onRemove: {})
                    }

                    Divider()

                    VariantShowcase(title: "ファイル（アイコン + 名前）") {
                        HStack(spacing: spacing.sm) {
                            AttachmentThumbnail(
                                systemImage: "doc.text.fill",
                                fileName: "quarterly-report.pdf",
                                onRemove: {}
                            )
                            AttachmentThumbnail(
                                systemImage: "tablecells.fill",
                                fileName: nil,
                                onRemove: {}
                            )
                        }
                    }
                }
            }

            SectionCard(title: "ストリップ（横スクロール）") {
                AttachmentStrip {
                    AttachmentThumbnail(image: Image(systemName: "photo"), onRemove: {})
                    AttachmentThumbnail(
                        systemImage: "doc.text.fill",
                        fileName: "notes.txt",
                        onRemove: {}
                    )
                    AttachmentThumbnail(
                        systemImage: "tablecells.fill",
                        fileName: "data.csv",
                        onRemove: {}
                    )
                    AttachmentThumbnail(image: Image(systemName: "photo.fill"), onRemove: {})
                    AttachmentThumbnail(
                        systemImage: "doc.fill",
                        fileName: "spec.md",
                        onRemove: {}
                    )
                }
            }

            SectionCard(title: "使用例") {
                CodeExample(code: """
                    // 横スクロールのコンテナ。items は呼び出し側が渡す。
                    AttachmentStrip {
                        ForEach(attachments) { item in
                            AttachmentThumbnail(image: item.image) {
                                remove(item.id)
                            }
                        }
                    }

                    // プレビュー画像が無いファイル添付
                    AttachmentThumbnail(
                        systemImage: "doc.text",
                        fileName: "report.pdf"
                    ) {
                        remove(fileID)
                    }
                    """)
            }
        }
    }
}

#Preview {
    NavigationStack {
        AttachmentCatalogView()
            .theme(ThemeProvider())
    }
}
