import XCTest
import SwiftUI
@testable import DesignSystem

/// border / elevation の override がテーマ経由で運べることを確かめる。
///
/// 既定値は「実装から導出した式」ではなく具体値で固定する（elevation ランプ全体の
/// 網羅は ``ElevationTests`` が持つ）。
///
/// ここが押さえるのは「表の値」だけで、それが画面に届くかは別物である。
/// borderScale が実際に線として描かれることは ``RenderedTokenTests`` が持つ。
final class NewTokenTests: XCTestCase {

    // MARK: - Border の既定値

    func testDefaultBorderScalePinsEveryWidth() {
        let scale = DefaultBorderScale()
        XCTAssertEqual(scale.none, 0)
        XCTAssertEqual(scale.thin, 0.5)
        XCTAssertEqual(scale.regular, 1)
        XCTAssertEqual(scale.thick, 2)
        XCTAssertEqual(scale.heavy, 4)
    }

    func testDefaultElevationScalePinsConcreteNumbers() {
        let scale = DefaultElevationScale()
        XCTAssertEqual(scale.style(for: .level2).radius, 6)
        XCTAssertEqual(scale.style(for: .level2).offset, CGSize(width: 0, height: 2))
        XCTAssertEqual(scale.style(for: .level2).opacity, 0.10, accuracy: 0.0001)
    }

    // MARK: - Theme 経由の既定値

    func testExistingThemesCarryTheDefaultTokenValues() {
        let theme = DefaultTheme()

        XCTAssertEqual(theme.borderScale.regular, 1)
        XCTAssertEqual(theme.borderScale.thin, 0.5)
        XCTAssertEqual(theme.elevationScale.style(for: .level3).radius, 8)
        XCTAssertEqual(theme.elevationScale.style(for: .level3).opacity, 0.12, accuracy: 0.0001)
    }

    func testBrandCanOverrideNewTokens() {
        struct FlatElevation: ElevationScale {
            // フラットデザイン: 影を全て無効化
            func style(for level: Elevation) -> ElevationStyle {
                ElevationStyle(radius: 0, offset: .zero, opacity: 0)
            }
        }
        struct ThickBorder: BorderScale {
            var none: CGFloat { 0 }
            var thin: CGFloat { 1 }
            var regular: CGFloat { 2 }
            var thick: CGFloat { 4 }
            var heavy: CGFloat { 8 }
        }
        struct BrandTheme: Theme {
            var id: String { "brand" }
            var name: String { "Brand" }
            var description: String { "" }
            var category: ThemeCategory { .brandPersonality }
            var previewColors: [Color] { [.blue] }
            func colorPalette(for mode: ThemeMode) -> any ColorPalette { LightColorPalette() }
            var elevationScale: any ElevationScale { FlatElevation() }
            var borderScale: any BorderScale { ThickBorder() }
        }
        let theme = BrandTheme()

        // フラット化が運ばれる（既存 enum は固定だった = 上書き可能化の核心）
        XCTAssertEqual(theme.elevationScale.style(for: .level5).radius, 0)
        XCTAssertEqual(theme.elevationScale.style(for: .level5).opacity, 0, accuracy: 0.0001)
        XCTAssertEqual(theme.borderScale.regular, 2)
        XCTAssertEqual(theme.borderScale.thin, 1)

        // override しなかった token は既定のまま
        XCTAssertEqual(theme.radiusScale.md, 8)
    }
}
