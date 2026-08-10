#if canImport(UIKit)
import UIKit

/// The JPEG quality used when no size limit is given, in which case nothing lowers it further.
private let defaultJPEGQuality: CGFloat = 0.8

/// The qualities tried in turn to meet a size limit. If even the lowest overshoots, the smallest
/// result is returned anyway.
private let jpegQualitySteps: [CGFloat] = [0.8, 0.7, 0.6, 0.5, 0.4, 0.3, 0.2, 0.1]

public extension UIImage {
    /// Returns the image cut down to the size the rule asks for.
    ///
    /// The result always has an orientation of `.up` and a scale of 1. A `UIImage` carries an
    /// `imageOrientation` that comes from EXIF; `jpegData(compressionQuality:)` honors it, but
    /// drawing by hand does not, so drawing without normalizing turns a portrait photo sideways.
    /// Because `draw(in:)` resolves the orientation and draws upright, redrawing is itself the
    /// normalization, which is why a rule always redraws even when no downscale is needed.
    ///
    /// - Parameter rule: How far to cut the dimensions down.
    /// - Returns: The resized, upright image. An image with no area is returned unchanged.
    func resized(by rule: ImageResizeRule) -> UIImage {
        // size is already orientation-resolved, so a portrait photo has its width and height
        // swapped here. Multiplying by scale gives the pixel count as the image is seen.
        let sourcePixels = CGSize(width: size.width * scale, height: size.height * scale)
        guard let plan = rule.plan(for: sourcePixels) else { return self }

        let format = UIGraphicsImageRendererFormat.preferred()
        // Pin a point to a pixel so every size from here on can stay in pixels
        format.scale = 1
        format.opaque = false

        return UIGraphicsImageRenderer(size: plan.outputSize, format: format).image { _ in
            // The renderer clips to the output rect, so the overflow is the center crop
            draw(in: plan.drawRect)
        }
    }

    /// Encodes the image as the JPEG data a picker hands back.
    ///
    /// Dimensions come down first, then the encode, then quality if it is still needed. Cutting
    /// dimensions before quality matters because carrying pixels that are never displayed is the
    /// most wasteful thing here. Quality drops step by step only when the resized image still
    /// exceeds the limit.
    ///
    /// - Parameters:
    ///   - resize: How far to cut the dimensions down. Pass nil to keep the original size.
    ///   - maxSize: An upper bound on the encoded bytes. Pass nil for a single encode at 0.8.
    /// - Returns: The JPEG data, or nil if the image cannot be encoded.
    func jpegData(resize: ImageResizeRule?, maxSize: ByteSize?) -> Data? {
        let source = resize.map { resized(by: $0) } ?? self

        guard let maxSize else {
            return source.jpegData(compressionQuality: defaultJPEGQuality)
        }
        return source.jpegData(fittingIn: maxSize)
    }

    /// Lowers quality step by step until the encoded data fits the limit.
    ///
    /// When even the lowest quality overshoots, the smallest data produced along the way is
    /// returned. Returning nil instead would leave the caller unable to tell "could not encode"
    /// apart from "too large".
    private func jpegData(fittingIn maxSize: ByteSize) -> Data? {
        var smallest: Data?

        for quality in jpegQualitySteps {
            guard let data = jpegData(compressionQuality: quality) else { return smallest }
            if data.count <= maxSize.bytes { return data }
            smallest = data
        }
        return smallest
    }
}

#endif
