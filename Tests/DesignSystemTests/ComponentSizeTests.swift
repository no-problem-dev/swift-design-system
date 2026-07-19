import XCTest
import SwiftUI
@testable import DesignSystem

/// コンポーネントのサイズバリアント（値マップ）の実値検証。
///
/// `ButtonSize` / `ChipSize` / `IconBadgeSize` / `StatDisplaySize` の
/// 各ケースが返す寸法・フォントを、定義値と直接突き合わせる。
final class ComponentSizeTests: XCTestCase {

    // MARK: - ButtonSize.height
    // macOS はポインタ操作前提で標準コントロールに寄せた寸法、それ以外はタッチ用の寸法。

    func testButtonSizeHeightsMatchPlatformSpec() {
        #if os(macOS)
        XCTAssertEqual(ButtonSize.large.height, 32)
        XCTAssertEqual(ButtonSize.medium.height, 28)
        XCTAssertEqual(ButtonSize.small.height, 22)
        #else
        XCTAssertEqual(ButtonSize.large.height, 56)
        XCTAssertEqual(ButtonSize.medium.height, 48)
        XCTAssertEqual(ButtonSize.small.height, 40)
        #endif
    }

    func testButtonSizeHeightsDecreaseMonotonically() {
        XCTAssertGreaterThan(ButtonSize.large.height, ButtonSize.medium.height)
        XCTAssertGreaterThan(ButtonSize.medium.height, ButtonSize.small.height)
    }

    func testButtonSizeHorizontalPaddingsMatchPlatformSpec() {
        #if os(macOS)
        XCTAssertEqual(ButtonSize.large.horizontalPadding, 16)
        XCTAssertEqual(ButtonSize.medium.horizontalPadding, 12)
        XCTAssertEqual(ButtonSize.small.horizontalPadding, 10)
        #else
        XCTAssertEqual(ButtonSize.large.horizontalPadding, 24)
        XCTAssertEqual(ButtonSize.medium.horizontalPadding, 20)
        XCTAssertEqual(ButtonSize.small.horizontalPadding, 16)
        #endif
    }

    func testButtonSizeHorizontalPaddingsDecreaseMonotonically() {
        XCTAssertGreaterThan(ButtonSize.large.horizontalPadding, ButtonSize.medium.horizontalPadding)
        XCTAssertGreaterThan(ButtonSize.medium.horizontalPadding, ButtonSize.small.horizontalPadding)
    }

    func testButtonSizeTypographyTokens() {
        XCTAssertEqual(ButtonSize.large.typography, .labelLarge)
        XCTAssertEqual(ButtonSize.medium.typography, .labelMedium)
        XCTAssertEqual(ButtonSize.small.typography, .labelSmall)
    }

    // MARK: - ButtonSize とタッチターゲット最小値の関係

    func testButtonSizeTouchTargetContract() {
        #if os(macOS)
        // macOS はポインタ操作前提。ButtonSize.height の doc comment が明示するとおり
        // 44pt を意図的に下回る（HIG の 44pt は hit region の最小値であってボタン本体寸法ではない）
        XCTAssertLessThan(ButtonSize.large.height, ControlTokens.minTouchTarget)
        XCTAssertLessThan(ButtonSize.small.height, ControlTokens.minTouchTarget)
        #else
        // タッチ環境では操作可能要素は 44pt を下回らないのが契約
        XCTAssertGreaterThanOrEqual(ButtonSize.large.height, ControlTokens.minTouchTarget)
        XCTAssertGreaterThanOrEqual(ButtonSize.medium.height, ControlTokens.minTouchTarget)
        // .small は 40pt でこの契約を満たさない。実装の現状を記録する（要修正）
        XCTAssertEqual(ButtonSize.small.height, 40)
        XCTAssertLessThan(ButtonSize.small.height, ControlTokens.minTouchTarget)
        #endif
    }

    func testMinTouchTargetIsHIGValue() {
        XCTAssertEqual(ControlTokens.minTouchTarget, 44)
    }

    // MARK: - ButtonSize の Environment

    func testDefaultButtonSizeIsLarge() {
        XCTAssertEqual(EnvironmentValues().buttonSize.height, ButtonSize.large.height)
    }

    // MARK: - ChipSize

    func testChipSizeHeights() {
        XCTAssertEqual(ChipSize.small.height, 24)
        XCTAssertEqual(ChipSize.medium.height, 32)
    }

    func testChipSizePaddings() {
        XCTAssertEqual(ChipSize.small.horizontalPadding, 6)
        XCTAssertEqual(ChipSize.medium.horizontalPadding, 8)
        XCTAssertEqual(ChipSize.small.verticalPadding, 2)
        XCTAssertEqual(ChipSize.medium.verticalPadding, 4)
    }

    func testChipSizeIconSizes() {
        XCTAssertEqual(ChipSize.small.iconSize, 14)
        XCTAssertEqual(ChipSize.medium.iconSize, 18)
    }

    func testChipSizeTypographyTokens() {
        XCTAssertEqual(ChipSize.small.typography, .labelSmall)
        XCTAssertEqual(ChipSize.medium.typography, .labelMedium)
    }

    func testChipSizeIconFitsInsideHeight() {
        // アイコンが高さを超えると描画が破綻する
        XCTAssertLessThan(ChipSize.small.iconSize, ChipSize.small.height)
        XCTAssertLessThan(ChipSize.medium.iconSize, ChipSize.medium.height)
    }

    func testDefaultChipSizeIsMedium() {
        XCTAssertEqual(EnvironmentValues().chipSize.height, ChipSize.medium.height)
    }

    // MARK: - IconBadgeSize

    func testIconBadgeCircleSizes() {
        XCTAssertEqual(IconBadgeSize.small.circleSize, 32)
        XCTAssertEqual(IconBadgeSize.medium.circleSize, 48)
        XCTAssertEqual(IconBadgeSize.large.circleSize, 64)
        XCTAssertEqual(IconBadgeSize.extraLarge.circleSize, 80)
    }

    func testIconBadgeIconSizes() {
        XCTAssertEqual(IconBadgeSize.small.iconSize, 14)
        XCTAssertEqual(IconBadgeSize.medium.iconSize, 20)
        XCTAssertEqual(IconBadgeSize.large.iconSize, 28)
        XCTAssertEqual(IconBadgeSize.extraLarge.iconSize, 36)
    }

    func testIconBadgeIconAlwaysFitsInsideCircle() {
        let sizes: [IconBadgeSize] = [.small, .medium, .large, .extraLarge]
        for size in sizes {
            XCTAssertLessThan(size.iconSize, size.circleSize)
        }
    }

    func testIconBadgeSizesIncreaseMonotonically() {
        XCTAssertLessThan(IconBadgeSize.small.circleSize, IconBadgeSize.medium.circleSize)
        XCTAssertLessThan(IconBadgeSize.medium.circleSize, IconBadgeSize.large.circleSize)
        XCTAssertLessThan(IconBadgeSize.large.circleSize, IconBadgeSize.extraLarge.circleSize)

        XCTAssertLessThan(IconBadgeSize.small.iconSize, IconBadgeSize.medium.iconSize)
        XCTAssertLessThan(IconBadgeSize.medium.iconSize, IconBadgeSize.large.iconSize)
        XCTAssertLessThan(IconBadgeSize.large.iconSize, IconBadgeSize.extraLarge.iconSize)
    }

    // MARK: - StatDisplaySize

    func testStatDisplayValueFonts() {
        XCTAssertEqual(StatDisplaySize.small.valueFont, .system(size: 24))
        XCTAssertEqual(StatDisplaySize.medium.valueFont, .system(size: 32))
        XCTAssertEqual(StatDisplaySize.large.valueFont, .system(size: 48))
        XCTAssertEqual(StatDisplaySize.extraLarge.valueFont, .system(size: 64))
    }

    func testStatDisplayValueFontsDifferPerSize() {
        XCTAssertNotEqual(StatDisplaySize.small.valueFont, StatDisplaySize.medium.valueFont)
        XCTAssertNotEqual(StatDisplaySize.large.valueFont, StatDisplaySize.extraLarge.valueFont)
    }

    func testStatDisplayUnitFonts() {
        XCTAssertEqual(StatDisplaySize.small.unitFont, .subheadline)
        XCTAssertEqual(StatDisplaySize.medium.unitFont, .title3)
        XCTAssertEqual(StatDisplaySize.large.unitFont, .title2)
        XCTAssertEqual(StatDisplaySize.extraLarge.unitFont, .title)
    }

    func testStatDisplaySpacings() {
        XCTAssertEqual(StatDisplaySize.small.spacing, 4)
        XCTAssertEqual(StatDisplaySize.medium.spacing, 6)
        XCTAssertEqual(StatDisplaySize.large.spacing, 8)
        XCTAssertEqual(StatDisplaySize.extraLarge.spacing, 10)
    }

    func testStatDisplaySpacingsIncreaseMonotonically() {
        XCTAssertLessThan(StatDisplaySize.small.spacing, StatDisplaySize.medium.spacing)
        XCTAssertLessThan(StatDisplaySize.medium.spacing, StatDisplaySize.large.spacing)
        XCTAssertLessThan(StatDisplaySize.large.spacing, StatDisplaySize.extraLarge.spacing)
    }
}
