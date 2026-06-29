import SwiftUI

/// 選択済み添付を 1 件だけ表す角丸サムネイル（atom）。
///
/// 画像プレビューと「ファイル（アイコン + 名前）」の両方を表現できる。
/// 右上の ✕ で削除を要求する。ドメイン型は受けず、内部 state も持たない。
/// 削除という副作用は呼び出し側の `onRemove` に委譲する。
///
/// ```swift
/// AttachmentThumbnail(image: Image("photo")) { remove(id) }
/// AttachmentThumbnail(systemImage: "doc.text", fileName: "report.pdf") { remove(id) }
/// ```
public struct AttachmentThumbnail: View {
    @Environment(\.colorPalette) private var colorPalette
    @Environment(\.radiusScale) private var radiusScale
    @Environment(\.spacingScale) private var spacingScale

    private enum Content {
        case image(Image)
        case file(systemImage: String, fileName: String?)
    }

    private let content: Content
    private let onRemove: () -> Void

    /// 画像添付用。プレビュー画像をそのまま塗りつぶし表示する。
    /// - Parameters:
    ///   - image: 表示するプレビュー画像。
    ///   - onRemove: ✕ タップ時に呼ばれる削除要求。
    public init(image: Image, onRemove: @escaping () -> Void) {
        self.content = .image(image)
        self.onRemove = onRemove
    }

    /// ファイル/ドキュメント添付用。プレビュー画像がないものをアイコン + 名前で表す。
    /// - Parameters:
    ///   - systemImage: ファイル種別を表す SF Symbols 名。
    ///   - fileName: ファイル名（1〜2 行で省略表示）。
    ///   - onRemove: ✕ タップ時に呼ばれる削除要求。
    public init(systemImage: String, fileName: String?, onRemove: @escaping () -> Void) {
        self.content = .file(systemImage: systemImage, fileName: fileName)
        self.onRemove = onRemove
    }

    private var side: CGFloat { ControlTokens.minTouchTarget + spacingScale.xl }

    public var body: some View {
        body(for: content)
            .frame(width: side, height: side)
            .clipShape(RoundedRectangle(cornerRadius: radiusScale.lg, style: .continuous))
            .overlay(alignment: .topTrailing) { removeButton }
    }

    @ViewBuilder
    private func body(for content: Content) -> some View {
        switch content {
        case let .image(image):
            image
                .resizable()
                .scaledToFill()
        case let .file(systemImage, fileName):
            VStack(spacing: spacingScale.xs) {
                Image(systemName: systemImage)
                    .font(.system(size: 20, weight: .regular))
                    .foregroundStyle(colorPalette.onSurfaceVariant)
                if let fileName {
                    Text(fileName)
                        .typography(.labelSmall)
                        .foregroundStyle(colorPalette.onSurfaceVariant)
                        .lineLimit(2)
                        .multilineTextAlignment(.center)
                }
            }
            .padding(spacingScale.xs)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(colorPalette.surfaceVariant)
        }
    }

    private var removeButton: some View {
        Button(action: onRemove) {
            Image(systemName: "xmark.circle.fill")
                .font(.system(size: 18, weight: .bold))
                .symbolRenderingMode(.palette)
                .foregroundStyle(colorPalette.onSurface, colorPalette.surface)
                .padding(spacingScale.xs)
                .contentShape(Rectangle())
                .frame(
                    width: ControlTokens.minTouchTarget,
                    height: ControlTokens.minTouchTarget,
                    alignment: .topTrailing
                )
        }
        .buttonStyle(.plain)
        .accessibilityLabel("添付を削除")
    }
}

#Preview {
    HStack {
        AttachmentThumbnail(
            image: Image(systemName: "photo"),
            onRemove: {}
        )
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
    .padding()
    .theme(ThemeProvider())
}
