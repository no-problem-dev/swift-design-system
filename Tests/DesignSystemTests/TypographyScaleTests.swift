import XCTest
import SwiftUI
@testable import DesignSystem

/// G1 の検証: Typography が enum 固定だった壁(W1)が解消され、
/// ブランドが型ランプを差し替えられる（size と leading を分離できる）ことを確かめる。
final class TypographyScaleTests: XCTestCase {

    func testDefaultScaleReproducesEnumValues() {
        let scale = DefaultTypographyScale()
        // 既存 enum 値から導出するので視覚パリティが保たれる
        let style = scale.style(for: .bodyMedium)
        XCTAssertEqual(style.size, Typography.bodyMedium.size)
        XCTAssertEqual(style.weight, Typography.bodyMedium.weight)
        XCTAssertEqual(style.lineHeight, Typography.bodyMedium.lineHeight, accuracy: 0.01)
    }

    func testCustomScaleSeparatesSizeAndLeading() {
        // SmartHR 流: 本文 16pt × leading 1.5（既存 enum では表現不能だった）
        struct SmartHRLikeScale: TypographyScale {
            func style(for role: Typography) -> TypeStyle {
                switch role {
                case .bodyMedium:
                    return TypeStyle(size: 16, weight: .regular, leadingMultiplier: 1.5)
                default:
                    return DefaultTypographyScale().style(for: role)
                }
            }
        }
        let style = SmartHRLikeScale().style(for: .bodyMedium)
        XCTAssertEqual(style.size, 16)
        XCTAssertEqual(style.leadingMultiplier, 1.5)
        XCTAssertEqual(style.lineHeight, 24, accuracy: 0.01) // 16 * 1.5
    }

    func testThemeSuppliesTypographyScaleWithDefault() {
        // 既存テーマは override 不要で default を返す（非破壊）
        XCTAssertTrue(DefaultTheme().typographyScale is DefaultTypographyScale)

        // ブランドテーマは typographyScale を override して固有の型を差し込める
        struct BrandScale: TypographyScale {
            func style(for role: Typography) -> TypeStyle {
                TypeStyle(size: 99, weight: .bold, leadingMultiplier: 1.5)
            }
        }
        struct BrandTheme: Theme {
            var id: String { "brand" }
            var name: String { "Brand" }
            var description: String { "" }
            var category: ThemeCategory { .brandPersonality }
            var previewColors: [Color] { [.blue] }
            func colorPalette(for mode: ThemeMode) -> any ColorPalette { LightColorPalette() }
            var typographyScale: any TypographyScale { BrandScale() }
        }
        XCTAssertEqual(BrandTheme().typographyScale.style(for: .bodyMedium).size, 99)
    }

    func testFontResourceSystemIsDefault() {
        // specified-but-not-bundled の既定は system 委譲
        let style = TypeStyle(size: 16, weight: .regular, leadingMultiplier: 1.5)
        XCTAssertEqual(style.fontResource, .system)
    }
}
