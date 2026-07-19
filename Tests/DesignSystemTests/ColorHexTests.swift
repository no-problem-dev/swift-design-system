import XCTest
import SwiftUI
@testable import DesignSystem

/// `Color(hex:)` の実値検証。
///
/// `Color.resolve(in:)` で sRGB 成分（red / green / blue / opacity）を抽出し、
/// HEX 文字列のパース結果（3 桁展開・6 桁 RGB・8 桁 ARGB・不正入力フォールバック）を
/// 期待成分値と直接比較する。
final class ColorHexTests: XCTestCase {

    // MARK: - Helpers

    private struct RGBA {
        let red: Double
        let green: Double
        let blue: Double
        let opacity: Double
    }

    /// `Color(hex:)` は `.sRGB` で初期化するため、resolve 結果の成分は入力値と一致する
    private func rgba(_ color: Color) -> RGBA {
        let resolved = color.resolve(in: EnvironmentValues())
        return RGBA(
            red: Double(resolved.red),
            green: Double(resolved.green),
            blue: Double(resolved.blue),
            opacity: Double(resolved.opacity)
        )
    }

    /// 8bit 値 (0-255) を成分値へ変換
    private func component(_ value: Int) -> Double {
        Double(value) / 255.0
    }

    private func assertColor(
        _ color: Color,
        red: Int, green: Int, blue: Int, alpha: Int = 255,
        file: StaticString = #filePath, line: UInt = #line
    ) {
        let actual = rgba(color)
        let accuracy = 0.002 // 1/255 の半分以下
        XCTAssertEqual(actual.red, component(red), accuracy: accuracy, "red", file: file, line: line)
        XCTAssertEqual(actual.green, component(green), accuracy: accuracy, "green", file: file, line: line)
        XCTAssertEqual(actual.blue, component(blue), accuracy: accuracy, "blue", file: file, line: line)
        XCTAssertEqual(actual.opacity, component(alpha), accuracy: accuracy, "opacity", file: file, line: line)
    }

    // MARK: - 6 桁 RGB

    func test6DigitHexParsesEachRGBComponent() {
        assertColor(Color(hex: "#FF5733"), red: 0xFF, green: 0x57, blue: 0x33)
    }

    func test6DigitHexWithoutHashParsesIdentically() {
        assertColor(Color(hex: "3B82F6"), red: 0x3B, green: 0x82, blue: 0xF6)
    }

    func testLowercaseHexParsesIdenticallyToUppercase() {
        let lower = rgba(Color(hex: "ff5733"))
        let upper = rgba(Color(hex: "#FF5733"))
        XCTAssertEqual(lower.red, upper.red, accuracy: 0.0001)
        XCTAssertEqual(lower.green, upper.green, accuracy: 0.0001)
        XCTAssertEqual(lower.blue, upper.blue, accuracy: 0.0001)
        XCTAssertEqual(lower.opacity, upper.opacity, accuracy: 0.0001)
    }

    // MARK: - 3 桁短縮形式（各ニブルを ×17 で 8bit へ展開）

    func test3DigitHexExpandsEachNibbleTimes17() {
        // "#F53" → F*17=0xFF, 5*17=0x55, 3*17=0x33
        assertColor(Color(hex: "#F53"), red: 0xFF, green: 0x55, blue: 0x33)
    }

    func test3DigitHexEqualsExpanded6DigitForm() {
        let short = rgba(Color(hex: "#F53"))
        let full = rgba(Color(hex: "#FF5533"))
        XCTAssertEqual(short.red, full.red, accuracy: 0.0001)
        XCTAssertEqual(short.green, full.green, accuracy: 0.0001)
        XCTAssertEqual(short.blue, full.blue, accuracy: 0.0001)
        XCTAssertEqual(short.opacity, full.opacity, accuracy: 0.0001)
    }

    // MARK: - 8 桁 ARGB（先頭 8bit がアルファ）

    func test8DigitHexParsesAlphaFromLeadingByte() {
        // "80FF5733" → a=0x80（約 50% 透明度）, r=0xFF, g=0x57, b=0x33
        assertColor(Color(hex: "80FF5733"), red: 0xFF, green: 0x57, blue: 0x33, alpha: 0x80)
    }

    func test8DigitHexFullAlphaEqualsOpaque6Digit() {
        let argb = rgba(Color(hex: "#FF3B82F6"))
        let rgb = rgba(Color(hex: "#3B82F6"))
        XCTAssertEqual(argb.red, rgb.red, accuracy: 0.0001)
        XCTAssertEqual(argb.green, rgb.green, accuracy: 0.0001)
        XCTAssertEqual(argb.blue, rgb.blue, accuracy: 0.0001)
        XCTAssertEqual(argb.opacity, 1.0, accuracy: 0.0001)
    }

    // MARK: - 不正入力フォールバック（不透明の黒）

    func testInvalidLengthFallsBackToOpaqueBlack() {
        // 5 桁は 3/6/8 のどれにも該当せず default 分岐 → 黒・alpha 255
        assertColor(Color(hex: "12345"), red: 0, green: 0, blue: 0, alpha: 255)
    }

    func testEmptyStringFallsBackToOpaqueBlack() {
        assertColor(Color(hex: ""), red: 0, green: 0, blue: 0, alpha: 255)
    }

    func testNonHexCharactersFallBackToOpaqueBlack() {
        // Scanner が hex として読めず int=0 のまま → 6 桁分岐でも黒
        assertColor(Color(hex: "ZZZZZZ"), red: 0, green: 0, blue: 0, alpha: 255)
    }

    // MARK: - Primitive Colors（定義 HEX と成分一致）

    func testPrimitiveColorsMatchTheirDefinedHexValues() {
        assertColor(PrimitiveColors.blue500, red: 0x3B, green: 0x82, blue: 0xF6) // #3B82F6
        assertColor(PrimitiveColors.gray900, red: 0x11, green: 0x18, blue: 0x27) // #111827
        assertColor(PrimitiveColors.red500, red: 0xEF, green: 0x44, blue: 0x44) // #EF4444
        assertColor(PrimitiveColors.green500, red: 0x10, green: 0xB9, blue: 0x81) // #10B981
    }
}
