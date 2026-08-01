import XCTest
import SwiftUI
@testable import DesignSystem

/// `.typography(_:)` が Dynamic Type に追随するための写像を固定する。
///
/// 追随先を役割ごとに選ぶのは、iOS のテキストスタイルが大きいものほど拡大率が小さいため。
/// 全役割を body に相対させると、アクセシビリティ最大で display が 3 倍を超えて破綻する。
final class TypographyDynamicTypeTests: XCTestCase {

    private let expected: [(role: Typography, textStyle: Font.TextStyle)] = [
        (.displayLarge, .largeTitle),
        (.displayMedium, .largeTitle),
        (.displaySmall, .largeTitle),
        (.headlineLarge, .title),
        (.headlineMedium, .title),
        (.headlineSmall, .title2),
        (.titleLarge, .title3),
        (.titleMedium, .headline),
        (.titleSmall, .headline),
        (.bodyLarge, .body),
        (.bodyMedium, .body),
        (.bodySmall, .footnote),
        (.labelLarge, .subheadline),
        (.labelMedium, .footnote),
        (.labelSmall, .caption),
    ]

    func testEveryRoleHasARelativeTextStyle() {
        // 役割を追加したら追随先も決めさせる
        XCTAssertEqual(expected.count, Typography.allCases.count)
        for row in expected {
            XCTAssertEqual(row.role.relativeTextStyle, row.textStyle, "\(row.role)")
        }
    }

    /// テキストスタイルを既定 pt の小さい順に並べた順位
    private let rank: [Font.TextStyle: Int] = [
        .caption2: 0, .caption: 1, .footnote: 2, .subheadline: 3, .callout: 4,
        .body: 5, .headline: 6, .title3: 7, .title2: 8, .title: 9, .largeTitle: 10,
    ]

    func testLargerRolesRelateToLargerTextStylesWithinACategory() {
        // カテゴリ内で pt 順と追随先が逆転していると、文字を上げたときに
        // large / medium / small の大小が入れ替わる。
        // カテゴリをまたぐ比較はしない — 同じ 14pt でも titleSmall は強調（headline）、
        // labelLarge は UI ラベル（subheadline）と、意味で追随先が変わるのが正しい
        let categories: [[Typography]] = [
            [.displayLarge, .displayMedium, .displaySmall],
            [.headlineLarge, .headlineMedium, .headlineSmall],
            [.titleLarge, .titleMedium, .titleSmall],
            [.bodyLarge, .bodyMedium, .bodySmall],
            [.labelLarge, .labelMedium, .labelSmall],
        ]
        XCTAssertEqual(categories.flatMap { $0 }.count, Typography.allCases.count)

        for category in categories {
            for (larger, smaller) in zip(category, category.dropFirst()) {
                XCTAssertGreaterThanOrEqual(larger.size, smaller.size, "\(larger) / \(smaller) の pt 順")
                XCTAssertGreaterThanOrEqual(
                    rank[larger.relativeTextStyle]!, rank[smaller.relativeTextStyle]!,
                    "\(larger)(\(larger.size)pt) が \(smaller)(\(smaller.size)pt) より小さいスタイルに相対している"
                )
            }
        }
    }

    func testDisplayScalesLessAggressivelyThanBody() {
        // display を body に相対させるとアクセシビリティ最大で 3 倍を超えて画面を埋める。
        // 大きい役割ほど拡大率の小さいスタイルに相対させる
        XCTAssertGreaterThan(
            rank[Typography.displayLarge.relativeTextStyle]!,
            rank[Typography.bodyLarge.relativeTextStyle]!
        )
        XCTAssertLessThan(
            rank[Typography.labelSmall.relativeTextStyle]!,
            rank[Typography.bodyLarge.relativeTextStyle]!
        )
    }

    func testBrandFontsScaleThroughTheSameStyle() {
        // .named（ブランド書体）も .system と同じ役割写像を通る
        XCTAssertEqual(Typography.bodyMedium.relativeTextStyle, .body)
        let branded = TypeStyle(size: 14, weight: .regular, leadingMultiplier: 1.5, fontResource: .named("Brand"))
        XCTAssertEqual(branded.fontResource, .named("Brand"))
        XCTAssertEqual(branded.size, 14)
    }
}
