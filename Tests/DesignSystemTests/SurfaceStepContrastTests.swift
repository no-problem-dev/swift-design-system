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
/// | ``LightColorPalette``（本パッケージ） | 1.101 |
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

    // MARK: - ライト

    func testLightPaletteSeparatesItsSurfaces() {
        let palette = LightColorPalette()
        assertStep(palette.surface, palette.background, "light surface/background")
        assertStep(palette.surfaceVariant, palette.surface, "light surfaceVariant/surface")
    }

    /// 実値を固定する。地とカード面は Apple のグループ化リスト（1.116）とほぼ同じところに置いた。
    /// 下限 1.10 に対する余裕が 0.001 しかないので、地か面を少しでも動かすとここが落ちる。
    func testLightPaletteStepsAreRecordedAtTheirValues() {
        let palette = LightColorPalette()
        XCTAssertEqual(contrastRatio(palette.surface, palette.background), 1.101, accuracy: 0.005)
        XCTAssertEqual(contrastRatio(palette.surfaceVariant, palette.surface), 1.238, accuracy: 0.005)
    }

    /// 面の上下関係。手前にあるものほど明るい側に置く。
    /// 逆にすると（地が白・カードが灰）、奥にあるはずの地が一番手前に見える。
    func testLightSurfacesGetLighterTowardTheViewer() {
        let palette = LightColorPalette()
        XCTAssertGreaterThan(
            relativeLuminance(palette.surface), relativeLuminance(palette.background),
            "カード面が地より暗い。地を沈めて面を白へ置く"
        )
    }

    // MARK: - Snackbar が重なる先

    /// Snackbar は `surfaceVariant` の板で、カードの上にも地の上にも出る。
    /// どちらに重なっても板として読めないと、「取り消す」が押せるものだと分からない。
    func testSnackbarSurfaceSeparatesFromBothLayers() {
        for (name, palette) in [
            ("light", LightColorPalette() as any ColorPalette),
            ("dark", DarkColorPalette() as any ColorPalette),
        ] {
            assertStep(palette.surfaceVariant, palette.surface, "\(name) snackbar/card")
            assertStep(palette.surfaceVariant, palette.background, "\(name) snackbar/page")
        }
    }
}
