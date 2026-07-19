import XCTest
import SwiftUI
@testable import DesignSystem

/// `ThemeRegistry` の内容と検索 API の検証。
///
/// レジストリはテーマピッカーの唯一の供給源なので、ID 集合・カテゴリ分類・検索の
/// 失敗系までを固定する。
final class ThemeRegistryTests: XCTestCase {

    func testBuiltInThemesArePinnedByIDAndOrder() {
        XCTAssertEqual(
            ThemeRegistry.builtInThemes.map(\.id),
            ["default", "ocean", "forest", "sunset", "purple-haze", "monochrome", "high-contrast"]
        )
    }

    func testBuiltInThemeIDsAreUnique() {
        // 重複があると theme(withID:) と registerTheme の in-place 更新が壊れる
        let ids = ThemeRegistry.builtInThemes.map(\.id)
        XCTAssertEqual(Set(ids).count, ids.count)
    }

    func testEveryBuiltInThemeHasDisplayMetadata() {
        for theme in ThemeRegistry.builtInThemes {
            XCTAssertFalse(theme.name.isEmpty, "\(theme.id).name")
            XCTAssertFalse(theme.description.isEmpty, "\(theme.id).description")
            // ピッカーのスウォッチ用。3-5 色が契約
            XCTAssertGreaterThanOrEqual(theme.previewColors.count, 3, "\(theme.id).previewColors")
            XCTAssertLessThanOrEqual(theme.previewColors.count, 5, "\(theme.id).previewColors")
        }
    }

    // MARK: - themesByCategory

    func testThemesByCategoryGroupsEveryThemeUnderItsOwnCategory() {
        let grouped = ThemeRegistry.themesByCategory

        XCTAssertEqual(grouped[.standard]?.map(\.id), ["default"])
        XCTAssertEqual(
            grouped[.brandPersonality]?.map(\.id),
            ["ocean", "forest", "sunset", "purple-haze", "monochrome"]
        )
        XCTAssertEqual(grouped[.accessibility]?.map(\.id), ["high-contrast"])

        // custom はビルトインには存在しない（アプリ側が register するカテゴリ）
        XCTAssertNil(grouped[.custom])
    }

    func testGroupingLosesNoTheme() {
        let grouped = ThemeRegistry.themesByCategory
        let total = grouped.values.reduce(0) { $0 + $1.count }
        XCTAssertEqual(total, ThemeRegistry.builtInThemes.count)

        for (category, themes) in grouped {
            for theme in themes {
                XCTAssertEqual(theme.category, category, "\(theme.id) が誤ったカテゴリに入っている")
            }
        }
    }

    // MARK: - theme(withID:)

    func testThemeWithIDReturnsTheMatchingTheme() {
        XCTAssertEqual(ThemeRegistry.theme(withID: "ocean")?.id, "ocean")
        XCTAssertEqual(ThemeRegistry.theme(withID: "ocean")?.name, OceanTheme().name)
        XCTAssertEqual(ThemeRegistry.theme(withID: "high-contrast")?.category, .accessibility)
    }

    func testThemeWithUnknownIDReturnsNil() {
        XCTAssertNil(ThemeRegistry.theme(withID: "nonexistent"))
        XCTAssertNil(ThemeRegistry.theme(withID: ""))
        // ID は完全一致。前方一致や大文字小文字無視で拾ってはいけない
        XCTAssertNil(ThemeRegistry.theme(withID: "Ocean"))
        XCTAssertNil(ThemeRegistry.theme(withID: "oce"))
    }

    func testEveryBuiltInThemeIsReachableByItsOwnID() {
        for theme in ThemeRegistry.builtInThemes {
            XCTAssertEqual(ThemeRegistry.theme(withID: theme.id)?.id, theme.id)
        }
    }
}
