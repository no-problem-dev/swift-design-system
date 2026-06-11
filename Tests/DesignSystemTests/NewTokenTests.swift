import XCTest
import SwiftUI
@testable import DesignSystem

/// G3 の検証: border / stateLayer / gradient / elevation override の新トークンが
/// 追加され、ブランドが override してテーマ経由で運べることを確かめる。
final class NewTokenTests: XCTestCase {

    func testDefaultsExistAndAreReasonable() {
        XCTAssertEqual(DefaultBorderScale().regular, 1)
        XCTAssertEqual(DefaultStateLayer().hover, 0.08)
        // elevation の既定は既存 enum 由来（視覚パリティ）
        XCTAssertEqual(DefaultElevationScale().style(for: .level2).radius, Elevation.level2.radius)
        XCTAssertEqual(DefaultElevationScale().style(for: .level2).opacity, Elevation.level2.opacity, accuracy: 0.0001)
    }

    func testGradientTokenProducesLinearGradient() {
        let token = GradientToken(colors: [.red, .blue], startPoint: .top, endPoint: .bottom)
        XCTAssertEqual(token.colors.count, 2)
        _ = token.linearGradient // 生成が成立すること
    }

    func testExistingThemesUseNewDefaults() {
        let theme = DefaultTheme()
        XCTAssertTrue(theme.borderScale is DefaultBorderScale)
        XCTAssertTrue(theme.stateLayer is DefaultStateLayer)
        XCTAssertTrue(theme.gradients is DefaultGradientTokens)
        XCTAssertTrue(theme.elevationScale is DefaultElevationScale)
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
        XCTAssertEqual(theme.borderScale.regular, 2)
    }
}
