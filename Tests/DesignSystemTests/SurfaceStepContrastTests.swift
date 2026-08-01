import XCTest
import SwiftUI
@testable import DesignSystem

/// 面の段差（地 → カード → その上に重なる面）が目で見えるかを比で押さえる。
///
/// 面どうしの段差に WCAG の 3:1 は当てはまらない。あれは UI 部品の輪郭の基準で、
/// Apple 自身のグループ化リスト（地 #F2F2F7 の上に白いカード）でも 1.116:1 しかない。
/// ここで使う下限は WCAG ではなく、**実際に見えている実装から取った経験値**:
///
/// | | 面 / 地 |
/// |---|---|
/// | Apple iOS ライト（白カード / systemGroupedBackground） | 1.116 |
/// | Apple iOS ダーク | 1.234 |
/// | ``DarkColorPalette``（本パッケージ） | 1.209 |
///
/// 既知で見えているものの下限が 1.116 なので、余裕を少しだけ見て 1.10 を床にする。
///
/// 段差を影で作らないこと。影は光の当たり方の表現なので、暗い場所・スクリーンショット・
/// コントラストを上げた設定のどれでも消える。段差は色で作る。
final class SurfaceStepContrastTests: XCTestCase {

    private func components(_ color: Color) -> (red: Double, green: Double, blue: Double) {
        let resolved = color.resolve(in: EnvironmentValues())
        return (Double(resolved.red), Double(resolved.green), Double(resolved.blue))
    }

    private func relativeLuminance(_ color: Color) -> Double {
        func linearize(_ channel: Double) -> Double {
            channel <= 0.03928 ? channel / 12.92 : pow((channel + 0.055) / 1.055, 2.4)
        }
        let rgb = components(color)
        return 0.2126 * linearize(rgb.red)
            + 0.7152 * linearize(rgb.green)
            + 0.0722 * linearize(rgb.blue)
    }

    private func contrastRatio(_ a: Color, _ b: Color) -> Double {
        let la = relativeLuminance(a)
        let lb = relativeLuminance(b)
        return (max(la, lb) + 0.05) / (min(la, lb) + 0.05)
    }

    /// 見えている実装から取った、面の段差の下限
    private let step = 1.10

    private func assertStep(
        _ upper: Color, _ lower: Color, _ label: String,
        file: StaticString = #filePath, line: UInt = #line
    ) {
        let ratio = contrastRatio(upper, lower)
        XCTAssertGreaterThanOrEqual(
            ratio, step,
            "\(label): 面の段差 \(String(format: "%.3f", ratio)) が下限 \(step) 未満。影ではなく色で段を付ける",
            file: file, line: line
        )
    }

    // MARK: - ダーク（満たしている側）

    func testDarkPaletteSeparatesItsSurfaces() {
        let palette = DarkColorPalette()
        assertStep(palette.surface, palette.background, "dark surface/background")
        assertStep(palette.surfaceVariant, palette.surface, "dark surfaceVariant/surface")
    }

    // MARK: - ライト（満たしていない側）

    /// ライトの地とカード面はほぼ同じ明度で、カードの輪郭が実質シャドウだけになっている。
    /// 閾値は緩めず、既知の欠陥として可視化する。
    ///
    /// 直すときは「カードを白へ寄せる」ではなく「地を沈める」。Apple のグループ化リストも
    /// 地を灰にして面を白にしており、地を白のままカードを灰にすると上下関係が逆さになる。
    func testLightPaletteSeparatesItsSurfaces() {
        XCTExpectFailure("既知の欠陥: ライトの面の段差が 1.045 / 1.053 しかない") {
            let palette = LightColorPalette()
            assertStep(palette.surface, palette.background, "light surface/background")
            assertStep(palette.surfaceVariant, palette.surface, "light surfaceVariant/surface")
        }
    }

    /// 欠陥の現在値を数値で固定する。直したときにこのテストが落ちて、
    /// 上の `XCTExpectFailure` を外す必要があることが分かる。
    func testLightPaletteStepsAreRecordedAtTheirCurrentValues() {
        let palette = LightColorPalette()
        XCTAssertEqual(contrastRatio(palette.surface, palette.background), 1.045, accuracy: 0.005)
        XCTAssertEqual(contrastRatio(palette.surfaceVariant, palette.surface), 1.053, accuracy: 0.005)
    }

    // MARK: - Snackbar が重なる先

    /// Snackbar は `surfaceVariant` の板で、カードの上にも地の上にも出る。
    /// どちらに重なっても板として読めないと、「取り消す」が押せるものだと分からない。
    func testSnackbarSurfaceSeparatesFromBothLayers() {
        let dark = DarkColorPalette()
        assertStep(dark.surfaceVariant, dark.surface, "dark snackbar/card")
        assertStep(dark.surfaceVariant, dark.background, "dark snackbar/page")

        XCTExpectFailure("既知の欠陥: ライトでは Snackbar の板がカードの上でほぼ消える") {
            let light = LightColorPalette()
            assertStep(light.surfaceVariant, light.surface, "light snackbar/card")
        }
    }
}
