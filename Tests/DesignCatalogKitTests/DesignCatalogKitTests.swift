import XCTest
import SwiftUI
import DesignSystem
@testable import DesignCatalogKit

/// CatalogKit の純ロジック検証（UI 非依存）: 差分計算とグルーピングが正しいこと。
final class DesignCatalogKitTests: XCTestCase {

    /// 既定と異なる型を持つテスト用テーマ
    struct BigTypeScale: TypographyScale {
        func style(for role: Typography) -> TypeStyle {
            TypeStyle(size: 99, weight: .bold, leadingMultiplier: 2.0)
        }
    }
    struct ThemeA: Theme {
        var id: String { "a" }; var name: String { "A" }; var description: String { "" }
        var category: ThemeCategory { .standard }; var previewColors: [Color] { [.blue] }
        func colorPalette(for mode: ThemeMode) -> any ColorPalette { LightColorPalette() }
    }
    struct ThemeB: Theme {
        var id: String { "b" }; var name: String { "B" }; var description: String { "" }
        var category: ThemeCategory { .standard }; var previewColors: [Color] { [.red] }
        func colorPalette(for mode: ThemeMode) -> any ColorPalette { LightColorPalette() }
        var typographyScale: any TypographyScale { BigTypeScale() }
    }

    func testTypographyDiffDetectsDifferences() {
        let rows = TokenDiff.typography(ThemeA().typographyScale, ThemeB().typographyScale)
        XCTAssertEqual(rows.count, Typography.allCases.count)
        // B は全ロール 99pt×2.0 なので default と全て異なる
        XCTAssertTrue(rows.allSatisfy { $0.differs })
        XCTAssertFalse(TokenDiff.differing(rows).isEmpty)
    }

    func testIdenticalThemesHaveNoDiff() {
        let rows = TokenDiff.spacing(ThemeA().spacingScale, ThemeA().spacingScale)
        XCTAssertTrue(TokenDiff.differing(rows).isEmpty, "同一テーマ間に差分は出ない")
    }

    func testRadiusDiffRowFormatting() {
        let rows = TokenDiff.radius(ThemeA().radiusScale, ThemeA().radiusScale)
        XCTAssertTrue(rows.contains { $0.label == "full" })
        XCTAssertTrue(rows.allSatisfy { !$0.differs })
    }

    @MainActor
    func testEntriesGroupAndFilterByArchetype() {
        let entries: [CatalogEntry] = [
            entry(id: "1", archetype: "FormControl", brand: "x"),
            entry(id: "2", archetype: "FormControl", brand: "y"),
            entry(id: "3", archetype: "FocusIndicator", brand: "x"),
        ]
        let groups = entries.groupedByArchetype()
        XCTAssertEqual(groups.count, 2)
        // archetype 名でソート: FocusIndicator < FormControl
        XCTAssertEqual(groups.first?.archetype, "FocusIndicator")
        XCTAssertEqual(entries.entries(ofArchetype: "FormControl").count, 2)
    }

    @MainActor
    private func entry(id: String, archetype: String, brand: String) -> CatalogEntry {
        CatalogEntry(
            id: id, brandId: brand, brandName: brand, archetype: archetype, title: archetype,
            annotation: DesignAnnotation(purpose: "p", whyItWorks: "w"),
            theme: ThemeA()
        ) { Text("x") }
    }
}
