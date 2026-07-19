import XCTest
import SwiftUI
@testable import DesignSystem

/// WCAG 2.1 コントラスト比の検証。
///
/// `HighContrastTheme` は「WCAG AAA準拠」と宣言しているため、前景/背景ペアの
/// コントラスト比を実際に計算して閾値 7.0（通常テキストの AAA）で検証する。
/// 現状で満たせていないペアは `XCTExpectFailure` で既知の欠陥として可視化し、
/// 閾値そのものは緩めない。
final class ContrastRatioTests: XCTestCase {

    // MARK: - WCAG helpers

    private func components(_ color: Color) -> (red: Double, green: Double, blue: Double) {
        let resolved = color.resolve(in: EnvironmentValues())
        return (Double(resolved.red), Double(resolved.green), Double(resolved.blue))
    }

    /// WCAG 2.1 の相対輝度。sRGB 成分をガンマ展開して輝度係数で重み付けする
    private func relativeLuminance(_ color: Color) -> Double {
        func linearize(_ channel: Double) -> Double {
            channel <= 0.03928 ? channel / 12.92 : pow((channel + 0.055) / 1.055, 2.4)
        }
        let rgb = components(color)
        return 0.2126 * linearize(rgb.red)
            + 0.7152 * linearize(rgb.green)
            + 0.0722 * linearize(rgb.blue)
    }

    /// WCAG 2.1 コントラスト比 (L1 + 0.05) / (L2 + 0.05)。1.0〜21.0
    private func contrastRatio(_ foreground: Color, _ background: Color) -> Double {
        let a = relativeLuminance(foreground)
        let b = relativeLuminance(background)
        return (max(a, b) + 0.05) / (min(a, b) + 0.05)
    }

    private func assertContrastRatio(
        _ foreground: Color,
        _ background: Color,
        min minimum: Double,
        _ label: String,
        file: StaticString = #filePath, line: UInt = #line
    ) {
        let ratio = contrastRatio(foreground, background)
        XCTAssertGreaterThanOrEqual(
            ratio, minimum,
            "\(label): コントラスト比 \(String(format: "%.2f", ratio)) が閾値 \(minimum) 未満",
            file: file, line: line
        )
    }

    /// WCAG 2.1 通常テキストの AAA 閾値
    private let aaa = 7.0
    /// WCAG 2.1 通常テキストの AA 閾値
    private let aa = 4.5

    // MARK: - 計算式そのものの検証

    func testKnownContrastRatiosMatchTheWCAGFormula() {
        // 黒 × 白は理論上の最大値 21:1
        XCTAssertEqual(contrastRatio(.black, .white), 21.0, accuracy: 0.01)
        // 同一色は最小値 1:1
        XCTAssertEqual(contrastRatio(.white, .white), 1.0, accuracy: 0.001)
        // 順序を入れ替えても比は同じ
        XCTAssertEqual(contrastRatio(.white, .black), contrastRatio(.black, .white), accuracy: 0.001)
        // WCAG の参照値: #767676 は白背景でちょうど AA (4.54)
        XCTAssertEqual(contrastRatio(Color(hex: "#767676"), .white), 4.54, accuracy: 0.02)
    }

    // MARK: - HighContrast ライトモード

    func testHighContrastLightMeetsAAAOnTextSurfaces() {
        let palette = HighContrastLightPalette()

        assertContrastRatio(palette.onBackground, palette.background, min: aaa, "light onBackground/background")
        assertContrastRatio(palette.onSurface, palette.surface, min: aaa, "light onSurface/surface")
        assertContrastRatio(palette.onSurfaceVariant, palette.surfaceVariant, min: aaa, "light onSurfaceVariant/surfaceVariant")
        assertContrastRatio(palette.onPrimary, palette.primary, min: aaa, "light onPrimary/primary")
        assertContrastRatio(palette.onSecondary, palette.secondary, min: aaa, "light onSecondary/secondary")
        assertContrastRatio(palette.onPrimaryContainer, palette.primaryContainer, min: aaa, "light onPrimaryContainer/primaryContainer")
        assertContrastRatio(palette.onSecondaryContainer, palette.secondaryContainer, min: aaa, "light onSecondaryContainer/secondaryContainer")
        assertContrastRatio(palette.onSuccess, palette.success, min: aaa, "light onSuccess/success")
        assertContrastRatio(palette.onInfo, palette.info, min: aaa, "light onInfo/info")
    }

    func testHighContrastLightSemanticPairsMeetAAA() {
        let palette = HighContrastLightPalette()

        assertContrastRatio(palette.onTertiary, palette.tertiary, min: aaa, "light onTertiary/tertiary")
        assertContrastRatio(palette.onError, palette.error, min: aaa, "light onError/error")
        assertContrastRatio(palette.onWarning, palette.warning, min: aaa, "light onWarning/warning")
    }

    /// ライトのセマンティック色は白背景に直接置く使い方もある。塗りとしてだけでなく
    /// 文字色として使っても AAA を保つことを押さえる
    func testHighContrastLightSemanticColorsAreReadableOnBackground() {
        let palette = HighContrastLightPalette()

        assertContrastRatio(palette.error, palette.background, min: aaa, "light error/background")
        assertContrastRatio(palette.warning, palette.background, min: aaa, "light warning/background")
        assertContrastRatio(palette.success, palette.background, min: aaa, "light success/background")
        assertContrastRatio(palette.info, palette.background, min: aaa, "light info/background")
        assertContrastRatio(palette.tertiary, palette.background, min: aaa, "light tertiary/background")
    }

    // MARK: - HighContrast ダークモード

    func testHighContrastDarkMeetsAAAOnTextSurfaces() {
        let palette = HighContrastDarkPalette()

        assertContrastRatio(palette.onBackground, palette.background, min: aaa, "dark onBackground/background")
        assertContrastRatio(palette.onSurface, palette.surface, min: aaa, "dark onSurface/surface")
        assertContrastRatio(palette.onSurfaceVariant, palette.surfaceVariant, min: aaa, "dark onSurfaceVariant/surfaceVariant")
        assertContrastRatio(palette.onPrimary, palette.primary, min: aaa, "dark onPrimary/primary")
        assertContrastRatio(palette.onSecondary, palette.secondary, min: aaa, "dark onSecondary/secondary")
        assertContrastRatio(palette.onTertiary, palette.tertiary, min: aaa, "dark onTertiary/tertiary")
        assertContrastRatio(palette.onPrimaryContainer, palette.primaryContainer, min: aaa, "dark onPrimaryContainer/primaryContainer")
        assertContrastRatio(palette.onSecondaryContainer, palette.secondaryContainer, min: aaa, "dark onSecondaryContainer/secondaryContainer")
        assertContrastRatio(palette.onWarning, palette.warning, min: aaa, "dark onWarning/warning")
    }

    func testHighContrastDarkSemanticPairsMeetAAA() {
        let palette = HighContrastDarkPalette()

        assertContrastRatio(palette.onError, palette.error, min: aaa, "dark onError/error")
        assertContrastRatio(palette.onSuccess, palette.success, min: aaa, "dark onSuccess/success")
        assertContrastRatio(palette.onInfo, palette.info, min: aaa, "dark onInfo/info")
    }

    /// ダークのセマンティック色は暗い背景に直接置く使い方もある
    func testHighContrastDarkSemanticColorsAreReadableOnSurface() {
        let palette = HighContrastDarkPalette()

        assertContrastRatio(palette.error, palette.surface, min: aaa, "dark error/surface")
        assertContrastRatio(palette.warning, palette.surface, min: aaa, "dark warning/surface")
        assertContrastRatio(palette.success, palette.surface, min: aaa, "dark success/surface")
        assertContrastRatio(palette.info, palette.surface, min: aaa, "dark info/surface")
    }

    /// 明るい塗りに白文字という読めない組み合わせに戻る回帰を防ぐ。
    /// 既定実装の on 色は .white なので、override が消えるとここが落ちる
    func testHighContrastDarkDoesNotFallBackToWhiteOnBrightFills() {
        let palette = HighContrastDarkPalette()

        for (name, color) in [
            ("onError", palette.onError),
            ("onSuccess", palette.onSuccess),
            ("onInfo", palette.onInfo),
            ("onTertiary", palette.onTertiary),
        ] {
            XCTAssertLessThan(
                relativeLuminance(color), 0.1,
                "\(name) は明るい塗りに載るため暗色でなければならない"
            )
        }
    }

    // MARK: - 既定テーマ（AAA を宣言していないので AA で見る）

    func testDefaultThemeCoreTextPairsMeetAA() {
        let light = LightColorPalette()
        assertContrastRatio(light.onBackground, light.background, min: aa, "light onBackground/background")
        assertContrastRatio(light.onSurface, light.surface, min: aa, "light onSurface/surface")
        assertContrastRatio(light.onSurfaceVariant, light.surfaceVariant, min: aa, "light onSurfaceVariant/surfaceVariant")

        let dark = DarkColorPalette()
        assertContrastRatio(dark.onBackground, dark.background, min: aa, "dark onBackground/background")
        assertContrastRatio(dark.onSurface, dark.surface, min: aa, "dark onSurface/surface")
        assertContrastRatio(dark.onSurfaceVariant, dark.surfaceVariant, min: aa, "dark onSurfaceVariant/surfaceVariant")
    }

    func testHighContrastBeatsTheDefaultThemeOnBodyText() {
        // 「高コントラスト」を名乗る以上、既定テーマより本文コントラストが高くなければならない
        let highContrast = contrastRatio(HighContrastLightPalette().onSurface, HighContrastLightPalette().surface)
        let standard = contrastRatio(LightColorPalette().onSurface, LightColorPalette().surface)
        XCTAssertGreaterThan(highContrast, standard)
    }

    // MARK: - テーマの識別性

    func testAllBuiltInThemesProduceDistinctPalettes() {
        // primary の実成分でテーマを区別する。同じ色に潰れたテーマがあると
        // ピッカーで選び分けられない
        var seen: [String: [Double]] = [:]
        for theme in ThemeRegistry.builtInThemes {
            let rgb = components(theme.colorPalette(for: .light).primary)
            let key = [rgb.red, rgb.green, rgb.blue]
            for (otherID, other) in seen {
                let delta = zip(key, other).reduce(0) { $0 + abs($1.0 - $1.1) }
                XCTAssertGreaterThan(delta, 0.01, "\(theme.id) と \(otherID) の primary が同一色")
            }
            seen[theme.id] = key
        }
        XCTAssertEqual(seen.count, 7)
    }

    func testLightAndDarkPalettesDifferForEveryBuiltInTheme() {
        for theme in ThemeRegistry.builtInThemes {
            let light = components(theme.colorPalette(for: .light).background)
            let dark = components(theme.colorPalette(for: .dark).background)
            let delta = abs(light.red - dark.red) + abs(light.green - dark.green) + abs(light.blue - dark.blue)
            XCTAssertGreaterThan(delta, 0.1, "\(theme.id) の background が light/dark で同じ")
        }
    }
}
