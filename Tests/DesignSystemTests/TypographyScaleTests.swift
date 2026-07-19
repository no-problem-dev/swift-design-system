import XCTest
import SwiftUI
@testable import DesignSystem

/// G1 の検証: Typography が enum 固定だった壁(W1)が解消され、
/// ブランドが型ランプを差し替えられる（size と leading を分離できる）ことを確かめる。
///
/// `DefaultTypographyScale` は `Typography` enum から導出する実装なので、enum 側の
/// pt 値を独立の期待表で固定してから scale がそれを写していることを見る。
final class TypographyScaleTests: XCTestCase {

    /// Material Design 3 タイプスケール由来の期待値（役割, size, weight, lineHeight）
    private let expected: [(role: Typography, size: CGFloat, weight: Font.Weight, lineHeight: CGFloat)] = [
        (.displayLarge, 57, .bold, 64),
        (.displayMedium, 45, .bold, 52),
        (.displaySmall, 36, .bold, 44),
        (.headlineLarge, 32, .semibold, 40),
        (.headlineMedium, 28, .semibold, 36),
        (.headlineSmall, 24, .semibold, 32),
        (.titleLarge, 22, .semibold, 28),
        (.titleMedium, 16, .semibold, 24),
        (.titleSmall, 14, .semibold, 20),
        (.bodyLarge, 16, .regular, 24),
        (.bodyMedium, 14, .regular, 20),
        (.bodySmall, 12, .regular, 16),
        (.labelLarge, 14, .medium, 20),
        (.labelMedium, 12, .medium, 16),
        (.labelSmall, 11, .medium, 16),
    ]

    func testEveryTypographyRoleIsCovered() {
        // 役割を追加したら期待表も更新させる
        XCTAssertEqual(Typography.allCases.count, 15)
        XCTAssertEqual(expected.count, Typography.allCases.count)
        for (index, role) in Typography.allCases.enumerated() {
            XCTAssertEqual(role, expected[index].role, "allCases の並びが期待表とずれている")
        }
    }

    func testEveryRolePinsItsSizeWeightAndLineHeight() {
        for row in expected {
            XCTAssertEqual(row.role.size, row.size, "\(row.role) size")
            XCTAssertEqual(row.role.weight, row.weight, "\(row.role) weight")
            XCTAssertEqual(row.role.lineHeight, row.lineHeight, "\(row.role) lineHeight")
        }
    }

    func testDefaultScaleReproducesEveryEnumRole() {
        let scale = DefaultTypographyScale()
        for row in expected {
            let style = scale.style(for: row.role)
            XCTAssertEqual(style.size, row.size, "\(row.role) size")
            XCTAssertEqual(style.weight, row.weight, "\(row.role) weight")
            // leadingMultiplier = lineHeight / size に分解されるが実効行高は保たれる
            XCTAssertEqual(style.leadingMultiplier, row.lineHeight / row.size, accuracy: 0.0001, "\(row.role) leading")
            XCTAssertEqual(style.lineHeight, row.lineHeight, accuracy: 0.01, "\(row.role) lineHeight")
            XCTAssertEqual(style.fontResource, .system, "\(row.role) fontResource")
            XCTAssertNil(style.trackingEm, "\(row.role) trackingEm は和文既定で nil")
        }
    }

    func testDisplayIsBoldAndBodyIsRegular() {
        // カテゴリごとのウェイト方針。1 つの定数に潰れた実装では成立しない
        XCTAssertEqual(Typography.displayLarge.weight, .bold)
        XCTAssertEqual(Typography.headlineLarge.weight, .semibold)
        XCTAssertEqual(Typography.titleLarge.weight, .semibold)
        XCTAssertEqual(Typography.bodyLarge.weight, .regular)
        XCTAssertEqual(Typography.labelLarge.weight, .medium)
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
        let scale = SmartHRLikeScale()
        let style = scale.style(for: .bodyMedium)
        XCTAssertEqual(style.size, 16)
        XCTAssertEqual(style.leadingMultiplier, 1.5)
        XCTAssertEqual(style.lineHeight, 24, accuracy: 0.01) // 16 * 1.5

        // 差し替えていない役割は既定のまま
        XCTAssertEqual(scale.style(for: .titleLarge).size, 22)
    }

    func testThemeSuppliesTypographyScaleWithDefault() {
        // 既存テーマは override 不要で既定値を運ぶ（非破壊）
        let defaultStyle = DefaultTheme().typographyScale.style(for: .bodyMedium)
        XCTAssertEqual(defaultStyle.size, 14)
        XCTAssertEqual(defaultStyle.weight, .regular)
        XCTAssertEqual(defaultStyle.lineHeight, 20, accuracy: 0.01)

        // ブランドテーマは typographyScale を override して固有の型を差し込める
        struct BrandScale: TypographyScale {
            func style(for role: Typography) -> TypeStyle {
                TypeStyle(size: 99, weight: .bold, leadingMultiplier: 1.5, trackingEm: 0.02, fontResource: .named("Brand"))
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
        let brandStyle = BrandTheme().typographyScale.style(for: .bodyMedium)
        XCTAssertEqual(brandStyle.size, 99)
        XCTAssertEqual(brandStyle.weight, .bold)
        XCTAssertEqual(brandStyle.lineHeight, 148.5, accuracy: 0.01)
        XCTAssertEqual(brandStyle.trackingEm, 0.02)
        XCTAssertEqual(brandStyle.fontResource, .named("Brand"))
    }

    func testFontResourceSystemIsDefault() {
        // specified-but-not-bundled の既定は system 委譲
        let style = TypeStyle(size: 16, weight: .regular, leadingMultiplier: 1.5)
        XCTAssertEqual(style.fontResource, .system)
        XCTAssertNotEqual(style.fontResource, .named("Hiragino Sans"))
    }
}
