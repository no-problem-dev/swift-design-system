// UIKit ベースのため iOS でのみ実行される（macOS の `swift test` ではコンパイル対象外）。
// 実行方法:
//   xcodebuild test -scheme DesignSystem-Package -destination 'platform=iOS Simulator,name=<simulator>'
#if canImport(UIKit)
import UIKit
import XCTest
@testable import DesignSystem

/// `UIImage.resized(by:)` と `jpegData(resize:maxSize:)` を、実際に画像を通して検証する。
///
/// 寸法だけでなくピクセルまで見るのは、center-crop がどこを残したか・向きを正規化したかが
/// 寸法だけでは区別できないため。
final class UIImageResizeTests: XCTestCase {

    // MARK: - square: center-crop

    func testSquareProducesSquareOutput() {
        let source = stripedImage(width: 400, height: 200, colors: [.red, .green, .blue, .yellow])

        let resized = source.resized(by: .square(100))

        XCTAssertEqual(resized.size, CGSize(width: 100, height: 100))
        XCTAssertEqual(resized.scale, 1)
    }

    func testSquareKeepsTheCenterOfTheSource() {
        // 横 3 等分の縞。中央だけを残せば全面が緑になる
        let source = stripedImage(width: 300, height: 100, colors: [.red, .green, .blue])

        let resized = source.resized(by: .square(50))

        XCTAssertEqual(resized.size, CGSize(width: 50, height: 50))
        assertPixel(resized, x: 1, y: 1, isCloseTo: .green)
        assertPixel(resized, x: 25, y: 25, isCloseTo: .green)
        assertPixel(resized, x: 48, y: 48, isCloseTo: .green)
    }

    func testSquareDoesNotUpscale() {
        let source = stripedImage(width: 40, height: 20, colors: [.red, .green])

        let resized = source.resized(by: .square(100))

        XCTAssertEqual(resized.size, CGSize(width: 20, height: 20))
    }

    // MARK: - longestEdge: アスペクト比の維持

    func testLongestEdgeKeepsAspectRatio() {
        let landscape = stripedImage(width: 400, height: 200, colors: [.red])
        let portrait = stripedImage(width: 200, height: 400, colors: [.red])

        XCTAssertEqual(landscape.resized(by: .longestEdge(100)).size, CGSize(width: 100, height: 50))
        XCTAssertEqual(portrait.resized(by: .longestEdge(100)).size, CGSize(width: 50, height: 100))
    }

    func testLongestEdgeKeepsBothEdgesOfTheSource() {
        // 縮小しても左端は赤・右端は青のまま。切り取っていないことの確認
        let source = stripedImage(width: 400, height: 200, colors: [.red, .blue])

        let resized = source.resized(by: .longestEdge(100))

        assertPixel(resized, x: 1, y: 25, isCloseTo: .red)
        assertPixel(resized, x: 98, y: 25, isCloseTo: .blue)
    }

    func testLongestEdgeDoesNotUpscale() {
        let source = stripedImage(width: 40, height: 20, colors: [.red])

        XCTAssertEqual(source.resized(by: .longestEdge(100)).size, CGSize(width: 40, height: 20))
    }

    // MARK: - 向きの正規化

    func testResizeNormalizesOrientationToUp() {
        // 左半分が赤・右半分が青の横長ピクセルを、90 度回して表示する縦長画像として渡す
        let source = rotatedImage(width: 200, height: 100, colors: [.red, .blue], orientation: .right)
        XCTAssertEqual(source.size, CGSize(width: 100, height: 200), "前提: 向きを解決した寸法は縦長")

        let resized = source.resized(by: .longestEdge(200))

        XCTAssertEqual(resized.imageOrientation, .up)
        XCTAssertEqual(resized.size, CGSize(width: 100, height: 200), "見たままの向きで出力されること")
    }

    func testResizeAppliesOrientationToPixels() {
        // .right は元のピクセルを時計回りに 90 度回して表示する。左端の赤が上へ来る
        let source = rotatedImage(width: 200, height: 100, colors: [.red, .blue], orientation: .right)

        let resized = source.resized(by: .longestEdge(200))

        assertPixel(resized, x: 50, y: 10, isCloseTo: .red)
        assertPixel(resized, x: 50, y: 190, isCloseTo: .blue)
    }

    func testSquareCropOnRotatedImageCropsInDisplayOrientation() {
        // 表示上は 100 × 200 の縦長。中央を切ると、赤と青の境目をまたぐ正方形になる
        let source = rotatedImage(width: 200, height: 100, colors: [.red, .blue], orientation: .right)

        let resized = source.resized(by: .square(100))

        XCTAssertEqual(resized.size, CGSize(width: 100, height: 100))
        assertPixel(resized, x: 50, y: 5, isCloseTo: .red)
        assertPixel(resized, x: 50, y: 95, isCloseTo: .blue)
    }

    // MARK: - scale の扱い

    func testResizeCountsPixelsNotPoints() {
        // @2x の画像。size は 200 × 100 でもピクセルは 400 × 200 ある
        let base = stripedImage(width: 400, height: 200, colors: [.red])
        let retina = UIImage(cgImage: base.cgImage!, scale: 2, orientation: .up)
        XCTAssertEqual(retina.size, CGSize(width: 200, height: 100), "前提: size は点で 200 × 100")

        let resized = retina.resized(by: .longestEdge(100))

        // 長辺 400px を 100px に収める。scale 1 なので size がそのままピクセル数になる
        XCTAssertEqual(resized.scale, 1)
        XCTAssertEqual(resized.size, CGSize(width: 100, height: 50))
    }

    // MARK: - JPEG 化

    func testJPEGDataResizesBeforeEncoding() throws {
        let source = stripedImage(width: 400, height: 200, colors: [.red, .green])

        let data = try XCTUnwrap(source.jpegData(resize: .square(50), maxSize: nil))

        let decoded = try XCTUnwrap(UIImage(data: data))
        XCTAssertEqual(decoded.size, CGSize(width: 50, height: 50))
    }

    func testJPEGDataWithoutResizeKeepsSourceDimensions() throws {
        let source = stripedImage(width: 400, height: 200, colors: [.red, .green])

        let data = try XCTUnwrap(source.jpegData(resize: nil, maxSize: nil))

        let decoded = try XCTUnwrap(UIImage(data: data))
        XCTAssertEqual(decoded.size, CGSize(width: 400, height: 200))
    }

    func testJPEGDataFitsInMaxSizeAfterResize() throws {
        let source = noisyImage(width: 1_200, height: 1_200)

        let data = try XCTUnwrap(source.jpegData(resize: .longestEdge(400), maxSize: 30.kb))

        XCTAssertLessThanOrEqual(data.count, 30.kb.bytes)
        XCTAssertEqual(try XCTUnwrap(UIImage(data: data)).size, CGSize(width: 400, height: 400))
    }

    func testResizeShrinksDataMoreThanQualityAlone() throws {
        let source = noisyImage(width: 1_200, height: 1_200)

        let qualityOnly = try XCTUnwrap(source.jpegData(resize: nil, maxSize: 30.kb))
        let resized = try XCTUnwrap(source.jpegData(resize: .longestEdge(400), maxSize: 30.kb))

        // 品質を下限まで下げても届かない上限に、寸法を落とせば届く
        XCTAssertGreaterThan(qualityOnly.count, 30.kb.bytes)
        XCTAssertLessThanOrEqual(resized.count, 30.kb.bytes)
    }

    func testJPEGDataReturnsSmallestDataWhenMaxSizeIsUnreachable() throws {
        let source = noisyImage(width: 1_200, height: 1_200)

        // 下限品質でも収まらないときは nil ではなく、そこで得たいちばん小さいデータを返す
        let data = try XCTUnwrap(source.jpegData(resize: nil, maxSize: 1.kb))

        XCTAssertGreaterThan(data.count, 1.kb.bytes)
    }

    // MARK: - 画像の生成

    /// 縦縞の画像を作る。scale は 1、向きは `.up`
    private func stripedImage(width: Int, height: Int, colors: [UIColor]) -> UIImage {
        let format = UIGraphicsImageRendererFormat()
        format.scale = 1
        format.opaque = true

        let size = CGSize(width: width, height: height)
        return UIGraphicsImageRenderer(size: size, format: format).image { context in
            let stripe = CGFloat(width) / CGFloat(colors.count)
            for (index, color) in colors.enumerated() {
                color.setFill()
                context.fill(CGRect(x: CGFloat(index) * stripe, y: 0, width: stripe, height: CGFloat(height)))
            }
        }
    }

    /// 縦縞のピクセルに向きを付けた画像を作る（EXIF 付き写真の再現）
    private func rotatedImage(
        width: Int,
        height: Int,
        colors: [UIColor],
        orientation: UIImage.Orientation
    ) -> UIImage {
        let base = stripedImage(width: width, height: height, colors: colors)
        return UIImage(cgImage: base.cgImage!, scale: 1, orientation: orientation)
    }

    /// JPEG が縮みにくい画像を作る。2 × 2 の色ブロックを敷き詰めて、品質を下げても
    /// バイト数が落ちきらない状況を作る。決定論的な擬似乱数なので毎回同じ絵になる。
    ///
    /// 描画ではなくピクセルバッファを直に埋めるのは、100 万回の塗りつぶし呼び出しが
    /// テスト 1 本あたり 10 秒以上かかるため
    private func noisyImage(width: Int, height: Int) -> UIImage {
        var seed: UInt64 = 0x2545_F491_4F6C_DD1D
        func nextColor() -> (UInt8, UInt8, UInt8) {
            seed = seed &* 6_364_136_223_846_793_005 &+ 1_442_695_040_888_963_407
            let value = seed >> 33
            return (UInt8(value & 0xFF), UInt8((value >> 8) & 0xFF), UInt8((value >> 16) & 0xFF))
        }

        var bytes = [UInt8](repeating: 255, count: width * height * 4)
        bytes.withUnsafeMutableBufferPointer { buffer in
            for blockY in stride(from: 0, to: height, by: 2) {
                for blockX in stride(from: 0, to: width, by: 2) {
                    let (red, green, blue) = nextColor()
                    for y in blockY..<min(blockY + 2, height) {
                        for x in blockX..<min(blockX + 2, width) {
                            let offset = (y * width + x) * 4
                            buffer[offset] = red
                            buffer[offset + 1] = green
                            buffer[offset + 2] = blue
                        }
                    }
                }
            }
        }

        let cgImage = bytes.withUnsafeMutableBytes { raw -> CGImage? in
            CGContext(
                data: raw.baseAddress,
                width: width,
                height: height,
                bitsPerComponent: 8,
                bytesPerRow: width * 4,
                space: CGColorSpace(name: CGColorSpace.sRGB)!,
                bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
            )?.makeImage()
        }
        return UIImage(cgImage: cgImage!, scale: 1, orientation: .up)
    }

    // MARK: - ピクセルの読み出し

    /// 指定座標のピクセルが期待した色かを確かめる。
    ///
    /// 描画先の色空間は環境で変わりうるので、必ず 8bit sRGB の文脈へ描き直してから読む。
    /// 変換の丸めが乗るため、チャンネルごとに許容差を持たせる。
    private func assertPixel(
        _ image: UIImage,
        x: Int,
        y: Int,
        isCloseTo expected: UIColor,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        guard let actual = pixel(of: image, x: x, y: y) else {
            XCTFail("ピクセルを読み出せなかった", file: file, line: line)
            return
        }

        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
        expected.getRed(&red, green: &green, blue: &blue, alpha: &alpha)

        let tolerance: Double = 12
        XCTAssertEqual(actual.red, Double(red * 255), accuracy: tolerance, "R at (\(x), \(y))", file: file, line: line)
        XCTAssertEqual(actual.green, Double(green * 255), accuracy: tolerance, "G at (\(x), \(y))", file: file, line: line)
        XCTAssertEqual(actual.blue, Double(blue * 255), accuracy: tolerance, "B at (\(x), \(y))", file: file, line: line)
    }

    private func pixel(of image: UIImage, x: Int, y: Int) -> (red: Double, green: Double, blue: Double)? {
        guard let cgImage = image.cgImage else { return nil }

        var bytes = [UInt8](repeating: 0, count: 4)
        guard let context = CGContext(
            data: &bytes,
            width: 1,
            height: 1,
            bitsPerComponent: 8,
            bytesPerRow: 4,
            space: CGColorSpace(name: CGColorSpace.sRGB)!,
            bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
        ) else {
            return nil
        }

        // CGContext の原点は左下。読みたい 1 画素が 1 × 1 の文脈に入るよう、画像全体をずらして描く
        context.draw(
            cgImage,
            in: CGRect(
                x: CGFloat(-x),
                y: CGFloat(-(cgImage.height - 1 - y)),
                width: CGFloat(cgImage.width),
                height: CGFloat(cgImage.height)
            )
        )

        return (Double(bytes[0]), Double(bytes[1]), Double(bytes[2]))
    }
}

#endif
