import XCTest
import SwiftUI
@testable import DesignSystem

/// G2 の検証: Theme が spacing/radius を運べるようになり、ThemeModifier の
/// DefaultSpacingScale ハードコード注入（壁W2）が解消されたことを確かめる。
final class ThemeBundleTests: XCTestCase {

    /// SmartHR 流の char-relative 余白（XS=16, S=24 ...）を持つテーマ
    struct BrandSpacing: SpacingScale {
        var none: CGFloat { 0 }
        var xxs: CGFloat { 8 }
        var xs: CGFloat { 16 }
        var sm: CGFloat { 24 }
        var md: CGFloat { 32 }
        var lg: CGFloat { 40 }
        var xl: CGFloat { 48 }
        var xxl: CGFloat { 56 }
        var xxxl: CGFloat { 64 }
        var xxxxl: CGFloat { 80 }
    }

    struct BrandRadius: RadiusScale {
        var none: CGFloat { 0 }
        var xs: CGFloat { 2 }
        var sm: CGFloat { 4 }
        var md: CGFloat { 6 }   // SmartHR: m=6
        var lg: CGFloat { 8 }   // SmartHR: l=8
        var xl: CGFloat { 8 }
        var xxl: CGFloat { 8 }
        var card: CGFloat { 8 }
        var full: CGFloat { 10000 }
    }

    struct BrandTheme: Theme {
        var id: String { "brand" }
        var name: String { "Brand" }
        var description: String { "" }
        var category: ThemeCategory { .brandPersonality }
        var previewColors: [Color] { [.blue] }
        func colorPalette(for mode: ThemeMode) -> any ColorPalette { LightColorPalette() }
        var spacingScale: any SpacingScale { BrandSpacing() }
        var radiusScale: any RadiusScale { BrandRadius() }
    }

    func testExistingThemesKeepDefaultScales() {
        // 非破壊: 既存テーマは default を返す（視覚不変）
        XCTAssertTrue(DefaultTheme().spacingScale is DefaultSpacingScale)
        XCTAssertTrue(DefaultTheme().radiusScale is DefaultRadiusScale)
    }

    func testBrandThemeSuppliesItsOwnScales() {
        let theme = BrandTheme()
        // char-relative 余白が実際に運ばれる（壁W2解消の核心）
        XCTAssertEqual(theme.spacingScale.xs, 16)
        XCTAssertEqual(theme.spacingScale.sm, 24)
        // SmartHR の角丸 m=6 / l=8
        XCTAssertEqual(theme.radiusScale.md, 6)
        XCTAssertEqual(theme.radiusScale.lg, 8)
    }

    @MainActor
    func testThemeProviderExposesBrandScales() {
        // ThemeProvider 経由でブランドの scale が currentTheme から取れる
        let provider = ThemeProvider(initialTheme: BrandTheme())
        XCTAssertEqual(provider.currentTheme.spacingScale.xs, 16)
        XCTAssertEqual(provider.currentTheme.radiusScale.lg, 8)
    }
}
