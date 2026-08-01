import XCTest
import SwiftUI
@testable import DesignSystem

/// `.readableWidth()` の上限が UIKit の `readableContentGuide` の実測に収まることを見る。
final class ReadableWidthTests: XCTestCase {
    func testBaseIsTheMeasuredDefault() {
        // Dynamic Type 既定での実測値
        XCTAssertEqual(ReadableWidth.base, 672)
        XCTAssertEqual(ReadableWidth.clamped(ReadableWidth.base), 672)
    }

    func testStaysInsideTheMeasuredRange() {
        XCTAssertEqual(ReadableWidth.minimum, 560)
        XCTAssertEqual(ReadableWidth.maximum, 896)
        // 文字を最小にしても細くなりすぎない
        XCTAssertEqual(ReadableWidth.clamped(400), 560)
        // アクセシビリティ最大では倍率が 3 倍を超えるが、実測の上限で止める
        XCTAssertEqual(ReadableWidth.clamped(ReadableWidth.base * 3.1), 896)
    }

    func testWidensWithDynamicTypeInsideTheRange() {
        // 文字が大きいほど 1 行に入る字数が減るので、範囲内では幅も広がる
        XCTAssertEqual(ReadableWidth.clamped(750), 750)
        XCTAssertLessThan(ReadableWidth.clamped(600), ReadableWidth.clamped(700))
    }
}
