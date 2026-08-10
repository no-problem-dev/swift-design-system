import CoreGraphics

/// How far to cut an image's dimensions down before saving it.
///
/// Dimensions come down before quality does, because carrying pixels that are never displayed is
/// the most wasteful thing in the pipeline.
///
/// ## Example
/// ```swift
/// // An avatar. A 240pt circle needs only 720 pixels, even at 3x
/// .imagePicker(isPresented: $show, selectedImageData: $data, resize: .square(720))
///
/// // A photo in the body of a document. Cap the long edge and keep the proportions
/// .imagePicker(isPresented: $show, selectedImageData: $data, resize: .longestEdge(2048))
/// ```
public enum ImageResizeRule: Sendable, Equatable {
    /// Center-crops to a square of the given side, for avatars and icons.
    case square(CGFloat)
    /// Fits the longest edge within the given length, keeping the aspect ratio.
    case longestEdge(CGFloat)
}

/// The result of applying a rule to a particular source size.
///
/// Cropping is expressed as drawing larger than the output and letting the overflow fall away.
/// That way the crop and the downscale happen in a single draw, with no intermediate image.
struct ImageResizePlan: Equatable {
    /// The pixel dimensions of the output.
    let outputSize: CGSize
    /// Where the whole source image goes in the output's coordinate space. A negative origin is the
    /// part that hangs outside the output and gets discarded.
    let drawRect: CGRect
}

extension ImageResizeRule {
    /// Works out the output plan for a source of the given pixel size, or nil if that size is empty.
    ///
    /// Neither rule ever enlarges. Stretching adds no information, only bytes.
    func plan(for source: CGSize) -> ImageResizePlan? {
        guard source.width > 0, source.height > 0 else { return nil }

        switch self {
        case .square(let side):
            // Take the largest square the short edge allows, then shrink it to the requested side
            let cropSide = min(source.width, source.height)
            let outputSide = max(1, min(side, cropSide).rounded())
            let scale = outputSide / cropSide
            let drawSize = CGSize(width: source.width * scale, height: source.height * scale)

            return ImageResizePlan(
                outputSize: CGSize(width: outputSide, height: outputSide),
                drawRect: CGRect(
                    x: (outputSide - drawSize.width) / 2,
                    y: (outputSide - drawSize.height) / 2,
                    width: drawSize.width,
                    height: drawSize.height
                )
            )

        case .longestEdge(let limit):
            let scale = min(1, limit / max(source.width, source.height))
            let outputSize = CGSize(
                width: max(1, (source.width * scale).rounded()),
                height: max(1, (source.height * scale).rounded())
            )

            return ImageResizePlan(
                outputSize: outputSize,
                drawRect: CGRect(origin: .zero, size: outputSize)
            )
        }
    }
}
