import Foundation

/// フルスクリーンメディアビューアで表示するメディア 1 件
///
/// `mediaViewable(_:enabled:)` モディファイアに渡して、
/// タップでフルスクリーン表示するメディアを指定する。
///
/// ## 使用例
/// ```swift
/// AsyncImage(url: imageURL) { image in
///     image.resizable().scaledToFit()
/// } placeholder: {
///     ProgressView()
/// }
/// .mediaViewable(.image(imageURL))
/// ```
public enum MediaViewerItem: Hashable, Identifiable, Sendable {
    /// 画像（リモート http/https または file URL。AsyncImage で解決）
    case image(URL)
    /// 動画（AVPlayer で再生）
    case video(URL)
    /// オーディオ（AVPlayer で再生）
    case audio(URL)

    public var id: URL { url }

    /// メディアの URL
    public var url: URL {
        switch self {
        case .image(let url), .video(let url), .audio(let url):
            return url
        }
    }
}
