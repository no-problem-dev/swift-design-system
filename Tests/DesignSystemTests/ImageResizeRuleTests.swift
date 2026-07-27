import XCTest
@testable import DesignSystem

/// `ImageResizeRule` が元の寸法から立てる計画——出力の大きさと、そこへ元画像をどう置くか——の検証。
///
/// UIKit を使わない純粋な計算なので macOS の `swift test` でも走る。実際に描いた結果の
/// ピクセルは `UIImageResizeTests`（iOS のみ）で確かめる。
final class ImageResizeRuleTests: XCTestCase {

    // MARK: - square: center-crop

    func testSquareCropsToShorterEdgeAndScalesToRequestedSide() {
        let plan = ImageResizeRule.square(100).plan(for: CGSize(width: 400, height: 200))

        XCTAssertEqual(plan?.outputSize, CGSize(width: 100, height: 100))
        // 短辺 200 → 100 なので倍率 0.5。幅 400 は 200 になり、出力 100 に対して左右 50 ずつはみ出す
        XCTAssertEqual(plan?.drawRect, CGRect(x: -50, y: 0, width: 200, height: 100))
    }

    func testSquareCentersTheCropOnTheLongerAxis() {
        let landscape = ImageResizeRule.square(50).plan(for: CGSize(width: 300, height: 100))
        let portrait = ImageResizeRule.square(50).plan(for: CGSize(width: 100, height: 300))

        // はみ出しが上下・左右で等しい = 中央を残している
        XCTAssertEqual(landscape?.drawRect.minX, -(landscape!.drawRect.width - 50) / 2)
        XCTAssertEqual(landscape?.drawRect.minY, 0)
        XCTAssertEqual(portrait?.drawRect.minY, -(portrait!.drawRect.height - 50) / 2)
        XCTAssertEqual(portrait?.drawRect.minX, 0)
    }

    func testSquareKeepsSourceSizeWhenAlreadySmaller() {
        // 拡大はしない。引き伸ばしても情報は増えずバイト数だけ増える
        let plan = ImageResizeRule.square(100).plan(for: CGSize(width: 40, height: 20))

        XCTAssertEqual(plan?.outputSize, CGSize(width: 20, height: 20))
        XCTAssertEqual(plan?.drawRect, CGRect(x: -10, y: 0, width: 40, height: 20))
    }

    func testSquareOfExactlyTheSourceSizeDoesNotChangeDimensions() {
        let plan = ImageResizeRule.square(64).plan(for: CGSize(width: 64, height: 64))

        XCTAssertEqual(plan?.outputSize, CGSize(width: 64, height: 64))
        XCTAssertEqual(plan?.drawRect, CGRect(x: 0, y: 0, width: 64, height: 64))
    }

    // MARK: - longestEdge: アスペクト比の維持

    func testLongestEdgeScalesLongerSideToLimitAndKeepsAspectRatio() {
        let landscape = ImageResizeRule.longestEdge(100).plan(for: CGSize(width: 400, height: 200))
        let portrait = ImageResizeRule.longestEdge(100).plan(for: CGSize(width: 200, height: 400))

        XCTAssertEqual(landscape?.outputSize, CGSize(width: 100, height: 50))
        XCTAssertEqual(portrait?.outputSize, CGSize(width: 50, height: 100))
    }

    func testLongestEdgePreservesAspectRatioOnUnevenDivision() {
        // 4032 × 3024（4:3 の 12MP）を長辺 1024 に収める
        let plan = ImageResizeRule.longestEdge(1024).plan(for: CGSize(width: 4032, height: 3024))

        XCTAssertEqual(plan?.outputSize, CGSize(width: 1024, height: 768))
    }

    func testLongestEdgeKeepsSourceSizeWhenAlreadySmaller() {
        let plan = ImageResizeRule.longestEdge(100).plan(for: CGSize(width: 40, height: 20))

        XCTAssertEqual(plan?.outputSize, CGSize(width: 40, height: 20))
    }

    func testLongestEdgeDrawsWholeImageWithoutCropping() {
        let plan = ImageResizeRule.longestEdge(100).plan(for: CGSize(width: 400, height: 200))

        // 描画矩形が出力矩形と一致する = はみ出しがない = 切り取っていない
        XCTAssertEqual(plan?.drawRect, CGRect(origin: .zero, size: plan!.outputSize))
    }

    // MARK: - 退化した入力

    func testZeroSizedSourceHasNoPlan() {
        XCTAssertNil(ImageResizeRule.square(100).plan(for: CGSize(width: 0, height: 100)))
        XCTAssertNil(ImageResizeRule.longestEdge(100).plan(for: CGSize(width: 100, height: 0)))
        XCTAssertNil(ImageResizeRule.longestEdge(100).plan(for: .zero))
    }

    func testNonPositiveLimitStillProducesADrawableOutput() {
        // 0 や負の指定でも描ける大きさに丸める。レンダラは 0 サイズを受け付けない
        XCTAssertEqual(
            ImageResizeRule.square(0).plan(for: CGSize(width: 100, height: 100))?.outputSize,
            CGSize(width: 1, height: 1)
        )
        XCTAssertEqual(
            ImageResizeRule.longestEdge(-10).plan(for: CGSize(width: 100, height: 100))?.outputSize,
            CGSize(width: 1, height: 1)
        )
    }
}
