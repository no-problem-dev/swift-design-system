import Foundation

/// A single piece of media shown in the full screen media viewer.
///
/// Pass it to the `mediaViewable(_:enabled:)` modifier to declare which media a tap opens
/// full screen.
///
/// ## Loading is not this type's job
///
/// The viewer is responsible for **presentation**, not for loading. Back when it accepted
/// only a URL, the assumption that the bytes were not yet available was baked in, so
/// **an app that already held the bytes could not use it**. In an app with a layer that
/// fetches from an authenticated API and puts the result in a cache
/// (`swift-cached-remote-image`), an image reaches the view as resolved bytes rather than
/// as a URL.
///
/// `imageData` is the way in for that case. Loading and caching stay in the calling layer,
/// and only the presentation is borrowed from here.
///
/// ## Example
/// ```swift
/// // An image that has not been loaded yet (the viewer loads it with AsyncImage)
/// AsyncImage(url: imageURL) { $0.resizable().scaledToFit() } placeholder: { ProgressView() }
///     .mediaViewable(.image(imageURL))
///
/// // Bytes that are already available (the caller has done the loading)
/// Image(uiImage: uiImage)
///     .mediaViewable(.imageData(bytes, id: imageID))
/// ```
public enum MediaViewerItem: Hashable, Identifiable, Sendable {
    /// An image at a remote http or https URL, or at a file URL, resolved with `AsyncImage`.
    case image(URL)
    /// The bytes of an image that is already available.
    ///
    /// - Parameter id: The identity of this media. **The bytes themselves are never
    ///   compared**, because selecting a page (the `TabView` tag) would then diff several
    ///   megabytes every time. Pass a stable string such as an image ID.
    case imageData(Data, id: String)
    /// A video played with `AVPlayer`.
    case video(URL)
    /// Audio played with `AVPlayer`.
    case audio(URL)

    public var id: String {
        switch self {
        case .image(let url), .video(let url), .audio(let url):
            return url.absoluteString
        case .imageData(_, let id):
            return id
        }
    }

    /// The URL of the media, or `nil` for media that is **already held as bytes**.
    public var url: URL? {
        switch self {
        case .image(let url), .video(let url), .audio(let url):
            return url
        case .imageData:
            return nil
        }
    }

    /// What equality is built from: **the pair of kind and `id`**, never the bytes themselves.
    ///
    /// The kind cannot be dropped. `.image` and `.video` at the same URL are meant to be
    /// different things, and their `id` collides because it is derived from the URL (`id`
    /// exists for `Identifiable`, which is a separate concern from equality).
    /// The bytes cannot be included: selecting a page would then diff several megabytes
    /// every time.
    private var identity: (kind: String, id: String) {
        switch self {
        case .image: return ("image", id)
        case .imageData: return ("imageData", id)
        case .video: return ("video", id)
        case .audio: return ("audio", id)
        }
    }

    public static func == (lhs: MediaViewerItem, rhs: MediaViewerItem) -> Bool {
        lhs.identity == rhs.identity
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(identity.kind)
        hasher.combine(identity.id)
    }
}
