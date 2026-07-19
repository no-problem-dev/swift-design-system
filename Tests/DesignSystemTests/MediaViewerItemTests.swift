import XCTest
@testable import DesignSystem

/// `MediaViewerItem` が型として提供するもの——
/// 3 ケースからの URL 取り出し、`id` の URL への委譲、種別を含む同一性——を検証する。
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
        XCTAssertEqual(MediaViewerItem.image(url).id, MediaViewerItem.image(url).url)
        XCTAssertEqual(MediaViewerItem.video(url).id, MediaViewerItem.video(url).url)
        XCTAssertEqual(MediaViewerItem.audio(url).id, MediaViewerItem.audio(url).url)
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
