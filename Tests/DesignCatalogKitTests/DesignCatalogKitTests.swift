import XCTest
import SwiftUI
import DesignSystem
import DesignSpec
@testable import DesignCatalogKit

/// CatalogKit の純ロジック検証（UI 非依存）: 差分計算とグルーピングが正しいこと。
///
/// 差分テストは必ず**異なる 2 つのスケール**を突き合わせ、どの行が `differs` になり
/// その行がどんな文字列を運ぶかまで固定する（同一スケール同士の比較は `!=` の反射律しか
/// 検証しないため、実装を定数に差し替えても通ってしまう）。
final class DesignCatalogKitTests: XCTestCase {

    // MARK: - テスト用スケール

    /// 全ロール 99pt × 2.0 の型スケール
    /// （`TypeStyle` は DesignSpec 側にも同名型があるためモジュール修飾する）
    struct BigTypeScale: TypographyScale {
        func style(for role: Typography) -> DesignSystem.TypeStyle {
            DesignSystem.TypeStyle(size: 99, weight: .bold, leadingMultiplier: 2.0)
        }
    }

    /// 全ロール 13.5pt × 1.25 の型スケール（小数サイズで `%.1f` 経路を通す）
    struct FractionalTypeScale: TypographyScale {
        func style(for role: Typography) -> DesignSystem.TypeStyle {
            DesignSystem.TypeStyle(size: 13.5, weight: .regular, leadingMultiplier: 1.25)
        }
    }

    /// `DefaultSpacingScale` から sm と xxl の 2 つだけずらしたスケール
    struct TweakedSpacingScale: SpacingScale {
        var none: CGFloat { 0 }
        var xxs: CGFloat { 2 }
        var xs: CGFloat { 4 }
        var sm: CGFloat { 10 }   // default は 8
        var md: CGFloat { 12 }
        var lg: CGFloat { 16 }
        var xl: CGFloat { 24 }
        var xxl: CGFloat { 40 }  // default は 32
        var xxxl: CGFloat { 48 }
        var xxxxl: CGFloat { 64 }
    }

    /// num() の全分岐を 1 スケールで踏むための角丸スケール。
    /// full は有限の巨大値、xs は小数、他は整数。
    struct EdgeCaseRadiusScale: RadiusScale {
        var none: CGFloat { 0 }
        var xs: CGFloat { 2.5 }    // 小数 → "%.1f"
        var sm: CGFloat { 4 }
        var md: CGFloat { 8 }
        var lg: CGFloat { 12 }
        var xl: CGFloat { 16 }
        var xxl: CGFloat { 20 }
        var card: CGFloat { 24 }
        var full: CGFloat { 1e19 } // Int() が trap する桁 → "%.0f"
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

    /// label で行を引く（見つからなければ失敗）
    private func row(
        _ rows: [TokenDiff.Row], _ label: String,
        file: StaticString = #filePath, line: UInt = #line
    ) throws -> TokenDiff.Row {
        try XCTUnwrap(rows.first { $0.label == label }, "行 \(label) が無い", file: file, line: line)
    }

    // MARK: - Typography

    func testTypographyDiffDetectsDifferences() {
        let rows = TokenDiff.typography(ThemeA().typographyScale, ThemeB().typographyScale)
        XCTAssertEqual(rows.count, Typography.allCases.count)
        // B は全ロール 99pt×2.0 なので default と全て異なる
        XCTAssertTrue(rows.allSatisfy { $0.differs })
        XCTAssertEqual(TokenDiff.differing(rows).count, rows.count)
    }

    /// 型スタイルの表示形式が「サイズpt ×行間(小数2桁)」であることを実値で固定する
    func testTypographyRowFormatsSizeAndLeading() throws {
        let rows = TokenDiff.typography(BigTypeScale(), FractionalTypeScale())
        let body = try row(rows, String(describing: Typography.bodyMedium))
        XCTAssertEqual(body.a, "99pt ×2.00")
        XCTAssertEqual(body.b, "13.5pt ×1.25")
        XCTAssertTrue(body.differs)
    }

    // MARK: - Spacing

    /// 異なる 2 スケールを突き合わせ、差分の出る行と出ない行を実値で固定する
    func testSpacingDiffReportsOnlyChangedSteps() throws {
        let rows = TokenDiff.spacing(DefaultSpacingScale(), TweakedSpacingScale())
        XCTAssertEqual(rows.count, 10)

        XCTAssertEqual(TokenDiff.differing(rows).map(\.label), ["sm", "xxl"])

        let sm = try row(rows, "sm")
        XCTAssertEqual(sm.a, "8")
        XCTAssertEqual(sm.b, "10")
        XCTAssertTrue(sm.differs)

        let xxl = try row(rows, "xxl")
        XCTAssertEqual(xxl.a, "32")
        XCTAssertEqual(xxl.b, "40")
        XCTAssertTrue(xxl.differs)

        // 値が一致する行は差分にならない
        let lg = try row(rows, "lg")
        XCTAssertEqual(lg.a, "16")
        XCTAssertEqual(lg.b, "16")
        XCTAssertFalse(lg.differs)
    }

    /// 行の並びはスケール定義順（小 → 大）で固定
    func testSpacingRowOrderFollowsScaleOrder() {
        let rows = TokenDiff.spacing(DefaultSpacingScale(), DefaultSpacingScale())
        XCTAssertEqual(
            rows.map(\.label),
            ["none", "xxs", "xs", "sm", "md", "lg", "xl", "xxl", "xxxl", "xxxxl"]
        )
    }

    // MARK: - Radius / 数値フォーマットの全分岐

    /// `.infinity` の full は "∞"、有限の巨大値は指数表記せず桁を並べる
    func testRadiusFullFormatsInfinityAndHugeFiniteValue() throws {
        let rows = TokenDiff.radius(DefaultRadiusScale(), EdgeCaseRadiusScale())
        XCTAssertEqual(rows.count, 8)

        let full = try row(rows, "full")
        XCTAssertEqual(full.a, "∞", "DefaultRadiusScale.full は .infinity")
        XCTAssertEqual(full.b, "10000000000000000000", "Int() が trap する桁でも文字列化できる")
        XCTAssertTrue(full.differs)
    }

    /// 小数は 1 桁、整数は小数点なしで出す
    func testRadiusFormatsFractionalAndIntegerValues() throws {
        let rows = TokenDiff.radius(DefaultRadiusScale(), EdgeCaseRadiusScale())

        let xs = try row(rows, "xs")
        XCTAssertEqual(xs.a, "2", "整数は小数点を付けない")
        XCTAssertEqual(xs.b, "2.5", "小数は 1 桁")
        XCTAssertTrue(xs.differs)
    }

    /// 差分ゼロの組み合わせでは differing() が空になる
    func testDifferingIsEmptyWhenAllValuesMatch() {
        let rows = TokenDiff.radius(DefaultRadiusScale(), DefaultRadiusScale())
        XCTAssertEqual(rows.count, 8)
        XCTAssertTrue(TokenDiff.differing(rows).isEmpty)
        // 全行が値を持ち、full は ∞ 同士で一致している
        XCTAssertEqual(rows.first { $0.label == "full" }?.a, "∞")
    }

    // MARK: - CatalogEntry グルーピング

    @MainActor
    func testEntriesGroupAndFilterByArchetype() {
        let entries: [CatalogEntry] = [
            entry(id: "1", archetype: "FormControl", brand: "x"),
            entry(id: "2", archetype: "FormControl", brand: "y"),
            entry(id: "3", archetype: "FocusIndicator", brand: "x"),
        ]
        let groups = entries.groupedByArchetype()

        // archetype 名でソート: FocusIndicator < FormControl
        XCTAssertEqual(groups.map(\.archetype), ["FocusIndicator", "FormControl"])
        XCTAssertEqual(groups[0].entries.map(\.id), ["3"])
        XCTAssertEqual(Set(groups[1].entries.map(\.id)), ["1", "2"])

        XCTAssertEqual(entries.entries(ofArchetype: "FormControl").map(\.id).sorted(), ["1", "2"])
        XCTAssertEqual(entries.entries(ofArchetype: "FocusIndicator").map(\.id), ["3"])
    }

    @MainActor
    func testGroupingEmptyArrayProducesNoGroups() {
        let entries: [CatalogEntry] = []
        XCTAssertTrue(entries.groupedByArchetype().isEmpty)
        XCTAssertTrue(entries.entries(ofArchetype: "FormControl").isEmpty)
    }

    @MainActor
    func testUnknownArchetypeReturnsNoEntries() {
        let entries: [CatalogEntry] = [
            entry(id: "1", archetype: "FormControl", brand: "x"),
            entry(id: "2", archetype: "FocusIndicator", brand: "y"),
        ]
        XCTAssertTrue(entries.entries(ofArchetype: "ProductCard").isEmpty)
        // archetype 名は完全一致（部分一致・大文字小文字の揺れは拾わない）
        XCTAssertTrue(entries.entries(ofArchetype: "Form").isEmpty)
        XCTAssertTrue(entries.entries(ofArchetype: "formcontrol").isEmpty)
    }

    // MARK: - DesignAnnotation

    /// spec を source of truth にする初期化が全フィールドを写すこと
    func testAnnotationFromComponentSpecCopiesEveryField() {
        let component = ComponentSpec(
            archetype: "FocusIndicator",
            name: "二重リング focus",
            annotation: "白ギャップ+色の二重リングで背景色に依らずフォーカスを保証する。",
            sourceURL: "https://github.com/kufu/smarthr-ui",
            fidelity: "shadow 値まで準拠"
        )
        let annotation = DesignAnnotation(from: component)
        XCTAssertEqual(annotation.purpose, "二重リング focus", "purpose には name が入る")
        XCTAssertEqual(annotation.whyItWorks, "白ギャップ+色の二重リングで背景色に依らずフォーカスを保証する。")
        XCTAssertEqual(annotation.sourceURL, "https://github.com/kufu/smarthr-ui")
    }

    func testAnnotationFromComponentSpecKeepsNilSourceURL() {
        let component = ComponentSpec(archetype: "FormControl", name: "FormControl", annotation: "a")
        XCTAssertNil(DesignAnnotation(from: component).sourceURL)
    }

    @MainActor
    private func entry(id: String, archetype: String, brand: String) -> CatalogEntry {
        CatalogEntry(
            id: id, brandName: brand, archetype: archetype, title: archetype,
            annotation: DesignAnnotation(purpose: "p", whyItWorks: "w"),
            theme: ThemeA()
        ) { Text("x") }
    }
}
