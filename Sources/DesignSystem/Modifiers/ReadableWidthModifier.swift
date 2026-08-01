import SwiftUI

public extension View {
    /// 本文の幅を読みやすい上限で頭打ちにして、余った横幅の中央に置く。
    ///
    /// SwiftUI には UIKit の `readableContentGuide` に相当する API が無く、画面ごとに
    /// `.frame(maxWidth:)` を手で書くと値がばらつく。上限の決め方をここに 1 本化する。
    ///
    /// 効くのは横も縦も `.regular` のときだけ。iPhone 縦・iPad の細い分割・横向きの
    /// iPhone はもともと 1 行が読める幅なので、頭打ちにしても余白が増えるだけになる。
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

/// 読みやすい本文幅。
///
/// UIKit の `readableContentGuide` の実測（iPad の既定サイズで約 672pt、Dynamic Type の
/// 両端で 560〜896pt）に合わせる。文字が大きいほど 1 行に入る文字数が減るので、
/// 幅も一緒に広がるのが正しい。
enum ReadableWidth {
    /// Dynamic Type 既定（`.large`）での上限
    static let base: CGFloat = 672

    static let minimum: CGFloat = 560
    static let maximum: CGFloat = 896

    /// Dynamic Type で伸縮した幅を実測の範囲に収める
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
        // macOS にサイズクラスは無く、ウィンドウは横に広がるので常に頭打ちにする
        true
        #endif
    }
}
