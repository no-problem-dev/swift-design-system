import XCTest
import SwiftUI
@testable import DesignSystem

/// `StatusKind` の網羅性とセマンティックカラー割り当ての検証。
///
/// 色は `Color.resolve(in:)` で sRGB 成分に落として、対応するパレットトークンと
/// 成分単位で突き合わせる（`Color` 同士の `==` は生成経路の違いで一致しないことがある）。
final class StatusKindTests: XCTestCase {

    // MARK: - Helpers

    private struct RGBA: Equatable {
        let red: Double
        let green: Double
        let blue: Double
        let opacity: Double
    }

    private func rgba(_ color: Color) -> RGBA {
        let resolved = color.resolve(in: EnvironmentValues())
        return RGBA(
            red: Double(resolved.red),
            green: Double(resolved.green),
            blue: Double(resolved.blue),
            opacity: Double(resolved.opacity)
        )
    }

    private func assertSameColor(
        _ actual: Color,
        _ expected: Color,
        file: StaticString = #filePath, line: UInt = #line
    ) {
        let lhs = rgba(actual)
        let rhs = rgba(expected)
        let accuracy = 0.002
        XCTAssertEqual(lhs.red, rhs.red, accuracy: accuracy, "red", file: file, line: line)
        XCTAssertEqual(lhs.green, rhs.green, accuracy: accuracy, "green", file: file, line: line)
        XCTAssertEqual(lhs.blue, rhs.blue, accuracy: accuracy, "blue", file: file, line: line)
        XCTAssertEqual(lhs.opacity, rhs.opacity, accuracy: accuracy, "opacity", file: file, line: line)
    }

    // MARK: - CaseIterable

    func testAllCasesCoversEveryStatus() {
        XCTAssertEqual(
            StatusKind.allCases,
            [.pending, .running, .success, .failure, .canceled]
        )
    }

    // MARK: - セマンティックカラー（Light）

    func testPendingUsesOnSurfaceVariantInLightPalette() {
        let palette = LightColorPalette()
        assertSameColor(StatusKind.pending.color(in: palette), palette.onSurfaceVariant)
    }

    func testRunningUsesInfoInLightPalette() {
        let palette = LightColorPalette()
        assertSameColor(StatusKind.running.color(in: palette), palette.info)
    }

    func testSuccessUsesSuccessInLightPalette() {
        let palette = LightColorPalette()
        assertSameColor(StatusKind.success.color(in: palette), palette.success)
    }

    func testFailureUsesErrorInLightPalette() {
        let palette = LightColorPalette()
        assertSameColor(StatusKind.failure.color(in: palette), palette.error)
    }

    func testCanceledUsesOnSurfaceVariantInLightPalette() {
        let palette = LightColorPalette()
        assertSameColor(StatusKind.canceled.color(in: palette), palette.onSurfaceVariant)
    }

    // MARK: - セマンティックカラー（Dark）

    func testColorsFollowDarkPaletteTokens() {
        let palette = DarkColorPalette()
        assertSameColor(StatusKind.pending.color(in: palette), palette.onSurfaceVariant)
        assertSameColor(StatusKind.running.color(in: palette), palette.info)
        assertSameColor(StatusKind.success.color(in: palette), palette.success)
        assertSameColor(StatusKind.failure.color(in: palette), palette.error)
        assertSameColor(StatusKind.canceled.color(in: palette), palette.onSurfaceVariant)
    }

    func testColorsFollowThePaletteRatherThanFixedValues() {
        // info と onSurfaceVariant は Light / Dark で別トークンなので、
        // 色がパレット引数に追随していれば結果も変わる
        XCTAssertNotEqual(
            rgba(StatusKind.running.color(in: LightColorPalette())),
            rgba(StatusKind.running.color(in: DarkColorPalette()))
        )
        XCTAssertNotEqual(
            rgba(StatusKind.pending.color(in: LightColorPalette())),
            rgba(StatusKind.pending.color(in: DarkColorPalette()))
        )
    }

    func testSuccessAndFailureUseTheSamePrimitiveInBothPalettes() {
        // success / error は Light / Dark とも同じプリミティブを指す（意図した共有）
        assertSameColor(StatusKind.success.color(in: LightColorPalette()), PrimitiveColors.green500)
        assertSameColor(StatusKind.success.color(in: DarkColorPalette()), PrimitiveColors.green500)
        assertSameColor(StatusKind.failure.color(in: LightColorPalette()), PrimitiveColors.red500)
        assertSameColor(StatusKind.failure.color(in: DarkColorPalette()), PrimitiveColors.red500)
    }

    func testEachCaseResolvesToItsPrimitiveInTheLightPalette() {
        assertSameColor(StatusKind.pending.color(in: LightColorPalette()), PrimitiveColors.gray700)
        assertSameColor(StatusKind.canceled.color(in: LightColorPalette()), PrimitiveColors.gray700)
        assertSameColor(StatusKind.running.color(in: LightColorPalette()), PrimitiveColors.blue500)
    }

    func testEachCaseResolvesToItsPrimitiveInTheDarkPalette() {
        assertSameColor(StatusKind.pending.color(in: DarkColorPalette()), PrimitiveColors.gray300)
        assertSameColor(StatusKind.canceled.color(in: DarkColorPalette()), PrimitiveColors.gray300)
        assertSameColor(StatusKind.running.color(in: DarkColorPalette()), PrimitiveColors.blue400)
    }

    // MARK: - ステータス間の区別

    func testTerminalStatusesHaveDistinctColors() {
        let palette = LightColorPalette()
        let success = rgba(StatusKind.success.color(in: palette))
        let failure = rgba(StatusKind.failure.color(in: palette))
        let running = rgba(StatusKind.running.color(in: palette))

        XCTAssertNotEqual(success, failure)
        XCTAssertNotEqual(success, running)
        XCTAssertNotEqual(failure, running)
    }

    func testPendingAndCanceledShareTheNeutralColor() {
        // どちらも「進行していない中立状態」として同じトークンを使う
        let palette = LightColorPalette()
        XCTAssertEqual(
            rgba(StatusKind.pending.color(in: palette)),
            rgba(StatusKind.canceled.color(in: palette))
        )
    }

    func testEveryCaseResolvesToAnOpaqueColor() {
        let palette = LightColorPalette()
        for kind in StatusKind.allCases {
            XCTAssertEqual(rgba(kind.color(in: palette)).opacity, 1.0, accuracy: 0.002, "\(kind)")
        }
    }

    // MARK: - Equatable

    func testEqualityDistinguishesCases() {
        XCTAssertEqual(StatusKind.running, .running)
        XCTAssertNotEqual(StatusKind.success, .failure)
    }
}
