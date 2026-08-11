import SwiftUI

/// A rounded thumbnail that stands for a single selected attachment (atom).
///
/// It can show either an image preview or a file as an icon plus a name. The ✕ in the top
/// trailing corner requests removal. It takes no domain type and holds no internal state:
/// removal is left to the caller through `onRemove`.
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

    /// Creates a thumbnail for an image attachment, filling the frame with the preview image.
    /// - Parameters:
    ///   - image: The preview image to show.
    ///   - onRemove: Called when the ✕ is tapped to request removal.
    public init(image: Image, onRemove: @escaping () -> Void) {
        self.content = .image(image)
        self.onRemove = onRemove
    }

    /// Creates a thumbnail for a file or document attachment, which has no preview image, as an icon plus a name.
    /// - Parameters:
    ///   - systemImage: The SF Symbols name that stands for the file type.
    ///   - fileName: The file name, truncated to one or two lines.
    ///   - onRemove: Called when the ✕ is tapped to request removal.
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
        .accessibilityLabel("Remove Attachment")
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
