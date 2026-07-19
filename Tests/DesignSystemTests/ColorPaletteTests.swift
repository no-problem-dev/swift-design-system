import XCTest
import SwiftUI
@testable import DesignSystem

/// `ColorPalette` の実値検証。
///
/// Light / Dark の各トークンが参照する primitive を成分値で固定し、
/// 「light と dark で実際に色が分岐しているか」「protocol extension の派生色が
/// documented な係数どおりか」を直接比較で確かめる。
final class ColorPaletteTests: XCTestCase {

    // MARK: - Helpers

    private struct RGBA {
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

    private func component(_ value: Int) -> Double {
        Double(value) / 255.0
    }

    private let accuracy = 0.002 // 1/255 の半分以下

    private func assertColor(
        _ color: Color,
        _ label: String,
        red: Int, green: Int, blue: Int, alpha: Int = 255,
        file: StaticString = #filePath, line: UInt = #line
    ) {
        let actual = rgba(color)
        XCTAssertEqual(actual.red, component(red), accuracy: accuracy, "\(label).red", file: file, line: line)
        XCTAssertEqual(actual.green, component(green), accuracy: accuracy, "\(label).green", file: file, line: line)
        XCTAssertEqual(actual.blue, component(blue), accuracy: accuracy, "\(label).blue", file: file, line: line)
        XCTAssertEqual(actual.opacity, component(alpha), accuracy: accuracy, "\(label).opacity", file: file, line: line)
    }

    /// 不透明度を無視して色相のみ比較する（`.opacity()` 派生色の検証用）
    private func assertRGB(
        _ color: Color,
        _ label: String,
        red: Int, green: Int, blue: Int,
        file: StaticString = #filePath, line: UInt = #line
    ) {
        let actual = rgba(color)
        XCTAssertEqual(actual.red, component(red), accuracy: accuracy, "\(label).red", file: file, line: line)
        XCTAssertEqual(actual.green, component(green), accuracy: accuracy, "\(label).green", file: file, line: line)
        XCTAssertEqual(actual.blue, component(blue), accuracy: accuracy, "\(label).blue", file: file, line: line)
    }

    private func assertSameColor(
        _ lhs: Color, _ rhs: Color, _ label: String,
        file: StaticString = #filePath, line: UInt = #line
    ) {
        let a = rgba(lhs), b = rgba(rhs)
        XCTAssertEqual(a.red, b.red, accuracy: accuracy, "\(label).red", file: file, line: line)
        XCTAssertEqual(a.green, b.green, accuracy: accuracy, "\(label).green", file: file, line: line)
        XCTAssertEqual(a.blue, b.blue, accuracy: accuracy, "\(label).blue", file: file, line: line)
        XCTAssertEqual(a.opacity, b.opacity, accuracy: accuracy, "\(label).opacity", file: file, line: line)
    }

    /// RGB 成分のどれかが有意に異なることを要求する（分岐していない実装を落とす）
    private func assertColorsDiffer(
        _ lhs: Color, _ rhs: Color, _ label: String,
        file: StaticString = #filePath, line: UInt = #line
    ) {
        let a = rgba(lhs), b = rgba(rhs)
        let delta = abs(a.red - b.red) + abs(a.green - b.green) + abs(a.blue - b.blue)
        XCTAssertGreaterThan(delta, 0.01, "\(label) が light/dark で同一色になっている", file: file, line: line)
    }

    // MARK: - Light パレットの実値

    func testLightPalettePinsItsPrimitiveTokens() {
        let palette = LightColorPalette()

        assertColor(palette.primary, "primary", red: 0x3B, green: 0x82, blue: 0xF6) // blue500
        assertColor(palette.onPrimary, "onPrimary", red: 255, green: 255, blue: 255)
        assertColor(palette.secondary, "secondary", red: 0xA8, green: 0x55, blue: 0xF7) // purple500
        assertColor(palette.tertiary, "tertiary", red: 0x06, green: 0xB6, blue: 0xD4) // cyan500

        assertColor(palette.background, "background", red: 255, green: 255, blue: 255)
        assertColor(palette.onBackground, "onBackground", red: 0x11, green: 0x18, blue: 0x27) // gray900
        assertColor(palette.surface, "surface", red: 0xF9, green: 0xFA, blue: 0xFB) // gray50
        assertColor(palette.onSurface, "onSurface", red: 0x11, green: 0x18, blue: 0x27) // gray900
        assertColor(palette.surfaceVariant, "surfaceVariant", red: 0xF3, green: 0xF4, blue: 0xF6) // gray100
        assertColor(palette.onSurfaceVariant, "onSurfaceVariant", red: 0x37, green: 0x41, blue: 0x51) // gray700

        assertColor(palette.error, "error", red: 0xEF, green: 0x44, blue: 0x44) // red500
        assertColor(palette.warning, "warning", red: 0xF9, green: 0x73, blue: 0x16) // orange500
        assertColor(palette.success, "success", red: 0x10, green: 0xB9, blue: 0x81) // green500
        assertColor(palette.info, "info", red: 0x3B, green: 0x82, blue: 0xF6) // blue500

        assertColor(palette.outline, "outline", red: 0xD1, green: 0xD5, blue: 0xDB) // gray300
    }

    // MARK: - Dark パレットの実値

    func testDarkPalettePinsItsPrimitiveTokens() {
        let palette = DarkColorPalette()

        assertColor(palette.primary, "primary", red: 0x60, green: 0xA5, blue: 0xFA) // blue400
        assertColor(palette.onPrimary, "onPrimary", red: 0x11, green: 0x18, blue: 0x27) // gray900
        assertColor(palette.secondary, "secondary", red: 0xA8, green: 0x55, blue: 0xF7) // purple500
        assertColor(palette.tertiary, "tertiary", red: 0x06, green: 0xB6, blue: 0xD4) // cyan500

        assertColor(palette.background, "background", red: 0x11, green: 0x18, blue: 0x27) // gray900
        assertColor(palette.onBackground, "onBackground", red: 255, green: 255, blue: 255)
        assertColor(palette.surface, "surface", red: 0x1F, green: 0x29, blue: 0x37) // gray800
        assertColor(palette.onSurface, "onSurface", red: 255, green: 255, blue: 255)
        assertColor(palette.surfaceVariant, "surfaceVariant", red: 0x37, green: 0x41, blue: 0x51) // gray700
        assertColor(palette.onSurfaceVariant, "onSurfaceVariant", red: 0xD1, green: 0xD5, blue: 0xDB) // gray300

        assertColor(palette.info, "info", red: 0x60, green: 0xA5, blue: 0xFA) // blue400
        assertColor(palette.outline, "outline", red: 0x4B, green: 0x55, blue: 0x63) // gray600
    }

    // MARK: - Light / Dark の分岐

    func testLightAndDarkDivergeOnModeDependentTokens() {
        let light = LightColorPalette()
        let dark = DarkColorPalette()

        // primary は blue500 / blue400 で明度が違う
        assertColorsDiffer(light.primary, dark.primary, "primary")
        assertColorsDiffer(light.info, dark.info, "info")

        // background / onBackground は反転する
        assertColorsDiffer(light.background, dark.background, "background")
        assertColorsDiffer(light.onBackground, dark.onBackground, "onBackground")
        assertSameColor(light.background, dark.onBackground, "light.background ↔ dark.onBackground")
        assertSameColor(light.onBackground, dark.background, "light.onBackground ↔ dark.background")

        assertColorsDiffer(light.onPrimary, dark.onPrimary, "onPrimary")
        assertColorsDiffer(light.surface, dark.surface, "surface")
        assertColorsDiffer(light.onSurface, dark.onSurface, "onSurface")
        assertColorsDiffer(light.surfaceVariant, dark.surfaceVariant, "surfaceVariant")
        assertColorsDiffer(light.onSurfaceVariant, dark.onSurfaceVariant, "onSurfaceVariant")
        assertColorsDiffer(light.outline, dark.outline, "outline")
    }

    func testSemanticStateTokensAreDeliberatelyModeInvariant() {
        // error / warning / success と secondary / tertiary は両モードで同一 primitive を指す。
        // 分岐させたくなった時にこのテストが落ちて意図的変更であることを可視化する。
        let light = LightColorPalette()
        let dark = DarkColorPalette()

        assertSameColor(light.error, dark.error, "error")
        assertSameColor(light.warning, dark.warning, "warning")
        assertSameColor(light.success, dark.success, "success")
        assertSameColor(light.secondary, dark.secondary, "secondary")
        assertSameColor(light.tertiary, dark.tertiary, "tertiary")
    }

    // MARK: - protocol extension のデフォルト実装

    func testContainerDefaultsApplyDocumentedOpacityToBaseToken() {
        let palette = LightColorPalette()

        // primaryContainer = primary.opacity(0.12): 色相はベースのまま、不透明度だけ落ちる
        assertRGB(palette.primaryContainer, "primaryContainer", red: 0x3B, green: 0x82, blue: 0xF6)
        XCTAssertEqual(rgba(palette.primaryContainer).opacity, 0.12, accuracy: 0.001)

        assertRGB(palette.secondaryContainer, "secondaryContainer", red: 0xA8, green: 0x55, blue: 0xF7)
        XCTAssertEqual(rgba(palette.secondaryContainer).opacity, 0.12, accuracy: 0.001)

        assertRGB(palette.errorContainer, "errorContainer", red: 0xEF, green: 0x44, blue: 0x44)
        XCTAssertEqual(rgba(palette.errorContainer).opacity, 0.12, accuracy: 0.001)

        // outlineVariant = outline.opacity(0.5)
        assertRGB(palette.outlineVariant, "outlineVariant", red: 0xD1, green: 0xD5, blue: 0xDB)
        XCTAssertEqual(rgba(palette.outlineVariant).opacity, 0.5, accuracy: 0.001)
    }

    func testOnContainerDefaultsAreTheOpaqueBaseToken() {
        let palette = LightColorPalette()

        assertSameColor(palette.onPrimaryContainer, palette.primary, "onPrimaryContainer")
        assertSameColor(palette.onSecondaryContainer, palette.secondary, "onSecondaryContainer")
        assertSameColor(palette.onErrorContainer, palette.error, "onErrorContainer")
        XCTAssertEqual(rgba(palette.onPrimaryContainer).opacity, 1.0, accuracy: 0.001)
    }

    func testOnWarningDefaultsToBlackWhileOtherOnDefaultsAreWhite() {
        // ColorPalette の extension で onWarning だけが .black。
        // warning が明るいオレンジのため意図的な非対称であり、揃えると可読性が落ちる。
        let palette = LightColorPalette()

        assertColor(palette.onWarning, "onWarning", red: 0, green: 0, blue: 0)
        assertColor(palette.onError, "onError", red: 255, green: 255, blue: 255)
        assertColor(palette.onSuccess, "onSuccess", red: 255, green: 255, blue: 255)
        assertColor(palette.onInfo, "onInfo", red: 255, green: 255, blue: 255)
    }

    func testUnoverriddenOnDefaultsAreWhite() {
        // 必須プロパティだけを実装した最小パレットで、extension 側の既定値そのものを見る
        struct MinimalPalette: ColorPalette {
            var primary: Color { PrimitiveColors.blue500 }
            var secondary: Color { PrimitiveColors.purple500 }
            var tertiary: Color { PrimitiveColors.cyan500 }
            var background: Color { .white }
            var onBackground: Color { PrimitiveColors.gray900 }
            var surface: Color { PrimitiveColors.gray50 }
            var onSurface: Color { PrimitiveColors.gray900 }
            var surfaceVariant: Color { PrimitiveColors.gray100 }
            var onSurfaceVariant: Color { PrimitiveColors.gray700 }
            var error: Color { PrimitiveColors.red500 }
            var warning: Color { PrimitiveColors.orange500 }
            var success: Color { PrimitiveColors.green500 }
            var info: Color { PrimitiveColors.blue500 }
            var outline: Color { PrimitiveColors.gray300 }
        }
        let palette = MinimalPalette()

        assertColor(palette.onPrimary, "onPrimary", red: 255, green: 255, blue: 255)
        assertColor(palette.onSecondary, "onSecondary", red: 255, green: 255, blue: 255)
        assertColor(palette.onTertiary, "onTertiary", red: 255, green: 255, blue: 255)
        assertColor(palette.onWarning, "onWarning", red: 0, green: 0, blue: 0)
    }

    func testElevatedSurfaceDefaultsChainToSurfaceAndShadowIsBlack() {
        let palette = LightColorPalette()

        assertColor(palette.shadow, "shadow", red: 0, green: 0, blue: 0)
        assertSameColor(palette.elevatedSurface, palette.surface, "elevatedSurface")
        assertSameColor(palette.elevatedSurfaceHigh, palette.elevatedSurface, "elevatedSurfaceHigh")
    }
}
