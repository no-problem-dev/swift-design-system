import XCTest
@testable import DesignSystem

/// `MediaViewerItem` が型として提供するもの——
/// 各ケースからの URL 取り出し、`id` の決まり方、種別を含む同一性——を検証する。
final class MediaViewerItemTests: XCTestCase {

    private let url = URL(string: "https://example.com/media")!

    // MARK: - URL の取り出し

    func testURLReturnsAssociatedValueForEveryCase() {
        let image = URL(string: "https://example.com/photo.jpg")!
        let video = URL(string: "https://example.com/movie.mp4")!
        let audio = URL(string: "https://example.com/track.m4a")!

        XCTAssertEqual(MediaViewerItem.image(image).url, image)
        XCTAssertEqual(MediaViewerItem.video(video).url, video)
        XCTAssertEqual(MediaViewerItem.audio(audio).url, audio)
    }

    func testURLPreservesFileURLsUnchanged() {
        // Markdown のローカル画像対応。file URL をそのまま保持する
        let fileURL = URL(fileURLWithPath: "/tmp/sample.png")

        XCTAssertEqual(MediaViewerItem.image(fileURL).url, fileURL)
    }

    // MARK: - Identifiable

    func testIdDelegatesToURLForEveryCase() {
        XCTAssertEqual(MediaViewerItem.image(url).id, url.absoluteString)
        XCTAssertEqual(MediaViewerItem.video(url).id, url.absoluteString)
        XCTAssertEqual(MediaViewerItem.audio(url).id, url.absoluteString)
    }

    func testIdIsSharedAcrossCasesWithTheSameURL() {
        // id は URL そのもの。種別が違っても同一 URL なら id は衝突する
        XCTAssertEqual(MediaViewerItem.image(url).id, MediaViewerItem.video(url).id)
    }

    // MARK: - Equatable / Hashable

    func testEqualityRequiresBothCaseAndURLToMatch() {
        let other = URL(string: "https://example.com/other")!

        XCTAssertEqual(MediaViewerItem.image(url), MediaViewerItem.image(url))
        XCTAssertNotEqual(MediaViewerItem.image(url), MediaViewerItem.video(url))
        XCTAssertNotEqual(MediaViewerItem.video(url), MediaViewerItem.audio(url))
        XCTAssertNotEqual(MediaViewerItem.image(url), MediaViewerItem.image(other))
    }

    // MARK: - 手元のバイト列

    /// **取得の手段を持たないケース。** URL は無く、同一性は渡された id が決める。
    func testImageDataHasNoURLAndUsesGivenID() {
        let item = MediaViewerItem.imageData(Data([0x01, 0x02]), id: "image-42")

        XCTAssertNil(item.url)
        XCTAssertEqual(item.id, "image-42")
    }

    /// **バイト列では比べない。** 同じ id なら中身が違っても同じ 1 件として扱う——
    /// ページの選択で毎回数 MB を突き合わせないための約束。
    func testImageDataComparesByIDNotBytes() {
        let a = MediaViewerItem.imageData(Data([0x01]), id: "same")
        let b = MediaViewerItem.imageData(Data(repeating: 0xFF, count: 4096), id: "same")
        let c = MediaViewerItem.imageData(Data([0x01]), id: "other")

        XCTAssertEqual(a, b)
        XCTAssertNotEqual(a, c)
        XCTAssertEqual(Set([a, b, c]).count, 2)
    }

    /// 種別が違えば別物、は URL のケースと同じ約束。
    func testImageDataIsDistinctFromURLImageWithSameID() {
        let urlItem = MediaViewerItem.image(url)
        let dataItem = MediaViewerItem.imageData(Data([0x01]), id: url.absoluteString)

        XCTAssertEqual(urlItem.id, dataItem.id)
        XCTAssertNotEqual(urlItem, dataItem)
    }

    func testHashingKeepsDifferentCasesAsSeparateSetMembers() {
        let items: Set<MediaViewerItem> = [
            .image(url),
            .video(url),
            .audio(url),
            .image(url)
        ]

        XCTAssertEqual(items.count, 3)
        XCTAssertTrue(items.contains(.video(url)))
    }
}
