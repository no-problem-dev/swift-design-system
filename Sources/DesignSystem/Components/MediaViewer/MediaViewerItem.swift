import Foundation

/// フルスクリーンメディアビューアで表示するメディア 1 件
///
/// `mediaViewable(_:enabled:)` モディファイアに渡して、
/// タップでフルスクリーン表示するメディアを指定する。
///
/// ## 取得はここの仕事ではない
///
/// このビューアの仕事は**見せ方**で、取り方ではない。URL しか受けられなかった頃は
/// 「まだ手元に無い」ことが前提に焼き付いていて、**すでにバイト列を持っているアプリが使えなかった**
/// —— 認証付きの API から取ってキャッシュに載せる層（`swift-cached-remote-image`）を持つアプリでは、
/// 画像は URL ではなく解決済みのバイト列としてビューに届く。
///
/// `imageData` はその口。取得とキャッシュは呼ぶ側の層に置いたまま、見せ方だけをここに借りられる。
///
/// ## 使用例
/// ```swift
/// // まだ取っていない画像（このビューアが AsyncImage で取る）
/// AsyncImage(url: imageURL) { $0.resizable().scaledToFit() } placeholder: { ProgressView() }
///     .mediaViewable(.image(imageURL))
///
/// // すでに手元にあるバイト列（取得は呼ぶ側が済ませている）
/// Image(uiImage: uiImage)
///     .mediaViewable(.imageData(bytes, id: imageID))
/// ```
public enum MediaViewerItem: Hashable, Identifiable, Sendable {
    /// 画像（リモート http/https または file URL。AsyncImage で解決）
    case image(URL)
    /// すでに手元にある画像のバイト列。
    ///
    /// - Parameter id: このメディアの同一性。**バイト列そのものでは比べない** ——
    ///   ページの選択（`TabView` のタグ）で毎回数 MB を突き合わせることになる。
    ///   呼ぶ側は画像 ID のような安定した文字列を渡す。
    case imageData(Data, id: String)
    /// 動画（AVPlayer で再生）
    case video(URL)
    /// オーディオ（AVPlayer で再生）
    case audio(URL)

    public var id: String {
        switch self {
        case .image(let url), .video(let url), .audio(let url):
            return url.absoluteString
        case .imageData(_, let id):
            return id
        }
    }

    /// メディアの URL。**手元のバイト列には無い**ので nil。
    public var url: URL? {
        switch self {
        case .image(let url), .video(let url), .audio(let url):
            return url
        case .imageData:
            return nil
        }
    }

    /// 同一性の材料。**種別と `id` の組**で、バイト列そのものは使わない。
    ///
    /// 種別を落とせない: 同じ URL の `.image` と `.video` は別物として扱う約束になっている
    /// （`id` は URL 由来なので衝突する。そちらは `Identifiable` の都合で、同一性とは別の話）。
    /// バイト列を入れられない: ページの選択で毎回数 MB を突き合わせることになる。
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
