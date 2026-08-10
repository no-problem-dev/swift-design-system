import SwiftUI

public extension View {
    /// Caps body content at a readable width and centers it in the width that is left over.
    ///
    /// SwiftUI has no equivalent of UIKit's `readableContentGuide`, and writing
    /// `.frame(maxWidth:)` by hand on every screen makes the values drift apart. How the cap is
    /// chosen lives in one place here.
    ///
    /// It only takes effect when both size classes are `.regular`. An iPhone in portrait, a narrow
    /// iPad split, and an iPhone in landscape are already narrow enough to read a line of text, so
    /// capping them would only add margins.
    ///
    /// ```swift
    /// ScrollView {
    ///     VStack { ... }
    ///         .readableWidth()
    /// }
    /// ```
    func readableWidth() -> some View {
        modifier(ReadableWidthModifier())
    }
}

/// The readable width for body content.
///
/// The values match measurements of UIKit's `readableContentGuide`: about 672pt at the default
/// size on iPad, and 560 to 896pt at the two ends of the Dynamic Type range. The larger the text,
/// the fewer characters fit on a line, so it is right for the width to grow along with it.
enum ReadableWidth {
    /// The cap at the default Dynamic Type size (`.large`).
    static let base: CGFloat = 672

    static let minimum: CGFloat = 560
    static let maximum: CGFloat = 896

    /// Keeps a Dynamic Type scaled width inside the measured range.
    static func clamped(_ scaled: CGFloat) -> CGFloat {
        min(max(scaled, minimum), maximum)
    }
}

struct ReadableWidthModifier: ViewModifier {
    #if os(iOS) || os(tvOS) || os(visionOS)
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(\.verticalSizeClass) private var verticalSizeClass
    #endif
    @ScaledMetric(relativeTo: .body) private var scaledWidth: CGFloat = ReadableWidth.base

    func body(content: Content) -> some View {
        if isSpacious {
            content
                .frame(maxWidth: ReadableWidth.clamped(scaledWidth))
                .frame(maxWidth: .infinity)
        } else {
            content
        }
    }

    private var isSpacious: Bool {
        #if os(iOS) || os(tvOS) || os(visionOS)
        horizontalSizeClass == .regular && verticalSizeClass == .regular
        #else
        // macOS has no size classes and windows spread out horizontally, so always apply the cap
        true
        #endif
    }
}
