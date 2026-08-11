import XCTest
import SwiftUI
@testable import DesignSystem

/// `.outlined` が実際に線を描いていることを、描画結果の画素で押さえる。
///
/// スタイルの列挙が増えても背景色の分岐しか無ければ `.outlined` は `.standard` と同じ絵になる
/// （それが元の不具合）。ここは「別の絵になる」ことだけを見る単体の砦で、線の太さ・色・位置は
/// `ComponentSnapshotTests` の IconButton スイート（参照画像）が押さえる。
@MainActor
final class IconButtonOutlineTests: XCTestCase {

    // MARK: - Helpers

    /// テーマを当てた IconButton を実際に描画し、画素を取り出す。
    ///
    /// `@Environment(\.colorPalette)` は body 評価中にしか解決されないため、
    /// プロパティを直接読むのではなく描かせて比べる。
    private func pixels(
        _ style: IconButtonStyle,
        file: StaticString = #filePath,
        line: UInt = #line
    ) throws -> [UInt8] {
        let provider = ThemeProvider(initialMode: .light)
        let view = IconButton(icon: "square.and.arrow.up", style: style) {}
            .theme(provider)
            .frame(width: 60, height: 60)
            .background(provider.colorPalette(for: .light).background)

        let renderer = ImageRenderer(content: view)
        renderer.scale = 2
        let image = try XCTUnwrap(renderer.cgImage, "描画に失敗した", file: file, line: line)

        let width = image.width
        let height = image.height
        var buffer = [UInt8](repeating: 0, count: width * height * 4)
        let context = try XCTUnwrap(
            CGContext(
                data: &buffer,
                width: width,
                height: height,
                bitsPerComponent: 8,
                bytesPerRow: width * 4,
                space: CGColorSpaceCreateDeviceRGB(),
                bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
            ),
            "CGContext を作れない", file: file, line: line
        )
        context.draw(image, in: CGRect(x: 0, y: 0, width: width, height: height))
        return buffer
    }

    /// 2 つのスタイルで色が変わった成分の数。失敗時に画素列そのものを吐かせないため数で持つ
    private func differingComponents(
        _ lhs: IconButtonStyle, _ rhs: IconButtonStyle,
        file: StaticString = #filePath, line: UInt = #line
    ) throws -> (count: Int, total: Int) {
        let a = try pixels(lhs, file: file, line: line)
        let b = try pixels(rhs, file: file, line: line)
        XCTAssertEqual(a.count, b.count, "同じ大きさで描かれていない", file: file, line: line)
        return (zip(a, b).reduce(0) { $0 + ($1.0 == $1.1 ? 0 : 1) }, a.count)
    }

    // MARK: - Tests

    func testOutlinedDoesNotRenderIdenticallyToStandard() throws {
        let (differing, _) = try differingComponents(.standard, .outlined)

        XCTAssertGreaterThan(
            differing, 0,
            "outlined が standard と同じ絵になっている（線が描かれていない）"
        )
    }

    func testTheDifferenceIsARingAndNotAFill() throws {
        // 差分が輪郭の帯に閉じていることを見る。
        // 面の大半が変わっていたら線ではなく塗りになっている
        let (differing, total) = try differingComponents(.standard, .outlined)

        XCTAssertLessThan(
            differing, total / 2,
            "差分が広すぎる。線ではなく塗りになっていないか"
        )
    }

    func testFilledAndTonalKeepTheirOwnAppearance() throws {
        // 線を足したことで他のスタイルが巻き添えになっていないこと
        for pair in [(IconButtonStyle.standard, IconButtonStyle.filled),
                     (.standard, .tonal),
                     (.filled, .tonal),
                     (.outlined, .filled)] {
            let (differing, _) = try differingComponents(pair.0, pair.1)
            XCTAssertGreaterThan(differing, 0, "\(pair.0) と \(pair.1) が同じ絵になっている")
        }
    }
}
