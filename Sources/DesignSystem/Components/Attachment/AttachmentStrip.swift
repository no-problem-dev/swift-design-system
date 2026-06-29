import SwiftUI

/// 選択済み添付を横スクロール表示する純レイアウトコンテナ（molecule）。
///
/// 中身（サムネイル列）は呼び出し側が ViewBuilder で渡す。
/// `ForEach` も items も削除ロジックも持たない完全な logic-less レイアウト。
///
/// ```swift
/// AttachmentStrip {
///     ForEach(attachments) { item in
///         AttachmentThumbnail(image: item.image) { remove(item.id) }
///     }
/// }
/// ```
public struct AttachmentStrip<Content: View>: View {
    @Environment(\.spacingScale) private var spacingScale

    private let content: Content

    public init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    public var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: spacingScale.sm) {
                content
            }
            .padding(.horizontal, spacingScale.lg)
            .padding(.vertical, spacingScale.sm)
        }
    }
}

#Preview {
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
    }
    .theme(ThemeProvider())
}
