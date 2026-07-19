import XCTest
import SwiftUI
@testable import DesignSystem

/// G3 の検証: border / stateLayer / gradient / elevation override の新トークンが
/// 追加され、ブランドが override してテーマ経由で運べることを確かめる。
///
/// 既定値は「実装から導出した式」ではなく具体値で固定する（elevation ランプ全体の
/// 網羅は ``ElevationTests`` が持つ）。
final class NewTokenTests: XCTestCase {

    // MARK: - Helpers

    private func rgb(_ color: Color) -> (red: Double, green: Double, blue: Double) {
        let resolved = color.resolve(in: EnvironmentValues())
        return (Double(resolved.red), Double(resolved.green), Double(resolved.blue))
    }

    private func assertColor(
        _ color: Color, _ label: String,
        red: Int, green: Int, blue: Int,
        file: StaticString = #filePath, line: UInt = #line
    ) {
        let actual = rgb(color)
        let accuracy = 0.002
        XCTAssertEqual(actual.red, Double(red) / 255, accuracy: accuracy, "\(label).red", file: file, line: line)
        XCTAssertEqual(actual.green, Double(green) / 255, accuracy: accuracy, "\(label).green", file: file, line: line)
        XCTAssertEqual(actual.blue, Double(blue) / 255, accuracy: accuracy, "\(label).blue", file: file, line: line)
    }

    // MARK: - Border / StateLayer の既定値

    func testDefaultBorderScalePinsEveryWidth() {
        let scale = DefaultBorderScale()
        XCTAssertEqual(scale.none, 0)
        XCTAssertEqual(scale.thin, 0.5)
        XCTAssertEqual(scale.regular, 1)
        XCTAssertEqual(scale.thick, 2)
        XCTAssertEqual(scale.heavy, 4)
    }

    func testDefaultStateLayerPinsEveryOpacity() {
        let layer = DefaultStateLayer()
        XCTAssertEqual(layer.hover, 0.08, accuracy: 0.0001)
        XCTAssertEqual(layer.focus, 0.10, accuracy: 0.0001)
        XCTAssertEqual(layer.pressed, 0.10, accuracy: 0.0001)
        XCTAssertEqual(layer.dragged, 0.16, accuracy: 0.0001)
        XCTAssertEqual(layer.selected, 0.12, accuracy: 0.0001)
    }

    func testDefaultElevationScalePinsConcreteNumbers() {
        let scale = DefaultElevationScale()
        XCTAssertEqual(scale.style(for: .level2).radius, 6)
        XCTAssertEqual(scale.style(for: .level2).offset, CGSize(width: 0, height: 2))
        XCTAssertEqual(scale.style(for: .level2).opacity, 0.10, accuracy: 0.0001)
    }

    // MARK: - GradientToken

    func testGradientTokenPreservesColorsAndDirection() {
        let token = GradientToken(
            colors: [Color(hex: "#FF5733"), Color(hex: "#3B82F6")],
            startPoint: .top,
            endPoint: .bottom
        )
        XCTAssertEqual(token.startPoint, .top)
        XCTAssertEqual(token.endPoint, .bottom)
        XCTAssertEqual(token.colors.count, 2)
        assertColor(token.colors[0], "colors[0]", red: 0xFF, green: 0x57, blue: 0x33)
        assertColor(token.colors[1], "colors[1]", red: 0x3B, green: 0x82, blue: 0xF6)
    }

    func testGradientTokenDefaultDirectionIsDiagonal() {
        let token = GradientToken(colors: [Color(hex: "#000000")])
        XCTAssertEqual(token.startPoint, .topLeading)
        XCTAssertEqual(token.endPoint, .bottomTrailing)
    }

    func testGradientTokenEqualityDistinguishesDirection() {
        let colors = [Color(hex: "#FF5733"), Color(hex: "#3B82F6")]
        let diagonal = GradientToken(colors: colors)
        XCTAssertEqual(diagonal, GradientToken(colors: colors))
        XCTAssertNotEqual(diagonal, GradientToken(colors: colors, startPoint: .top, endPoint: .bottom))
        XCTAssertNotEqual(diagonal, GradientToken(colors: colors.reversed()))
    }

    func testDefaultGradientTokensPinTheirColorStops() {
        let tokens = DefaultGradientTokens()

        // brand: blue500 → purple500
        XCTAssertEqual(tokens.brand.colors.count, 2)
        assertColor(tokens.brand.colors[0], "brand[0]", red: 0x3B, green: 0x82, blue: 0xF6)
        assertColor(tokens.brand.colors[1], "brand[1]", red: 0xA8, green: 0x55, blue: 0xF7)
        XCTAssertEqual(tokens.brand.startPoint, .topLeading)
        XCTAssertEqual(tokens.brand.endPoint, .bottomTrailing)

        // surface: gray50 → gray100（背景用の控えめな振れ幅）
        assertColor(tokens.surface.colors[0], "surface[0]", red: 0xF9, green: 0xFA, blue: 0xFB)
        assertColor(tokens.surface.colors[1], "surface[1]", red: 0xF3, green: 0xF4, blue: 0xF6)

        // accent: cyan500 → blue500
        assertColor(tokens.accent.colors[0], "accent[0]", red: 0x06, green: 0xB6, blue: 0xD4)
        assertColor(tokens.accent.colors[1], "accent[1]", red: 0x3B, green: 0x82, blue: 0xF6)
    }

    // MARK: - Theme 経由の既定値

    func testExistingThemesCarryTheDefaultTokenValues() {
        let theme = DefaultTheme()

        XCTAssertEqual(theme.borderScale.regular, 1)
        XCTAssertEqual(theme.borderScale.thin, 0.5)
        XCTAssertEqual(theme.stateLayer.hover, 0.08, accuracy: 0.0001)
        XCTAssertEqual(theme.stateLayer.dragged, 0.16, accuracy: 0.0001)

        assertColor(theme.gradients.brand.colors[0], "gradients.brand[0]", red: 0x3B, green: 0x82, blue: 0xF6)
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
        struct BrandGradients: GradientTokens {
            var brand: GradientToken { GradientToken(colors: [Color(hex: "#FF5733"), Color(hex: "#10B981")]) }
            var surface: GradientToken { DefaultGradientTokens().surface }
            var accent: GradientToken { DefaultGradientTokens().accent }
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
            var gradients: any GradientTokens { BrandGradients() }
        }
        let theme = BrandTheme()

        // フラット化が運ばれる（既存 enum は固定だった = 上書き可能化の核心）
        XCTAssertEqual(theme.elevationScale.style(for: .level5).radius, 0)
        XCTAssertEqual(theme.elevationScale.style(for: .level5).opacity, 0, accuracy: 0.0001)
        XCTAssertEqual(theme.borderScale.regular, 2)
        XCTAssertEqual(theme.borderScale.thin, 1)
        assertColor(theme.gradients.brand.colors[0], "brand[0]", red: 0xFF, green: 0x57, blue: 0x33)

        // override しなかった token は既定のまま
        XCTAssertEqual(theme.stateLayer.hover, 0.08, accuracy: 0.0001)
        assertColor(theme.gradients.surface.colors[0], "surface[0]", red: 0xF9, green: 0xFA, blue: 0xFB)
    }
}
