import XCTest
@testable import DesignSpec

/// DesignSpec スキーマの妥当性検証。
/// 中心的主張: SmartHR の特異性を失わず表現でき、JSON round-trip で完全一致する
/// （= 315 コーパス取り込みと LLM 生成の交換形式として成立する）。
///
/// fixture は 1 ブランド分の値しか含まないため、fixture を読むだけのテストと
/// スキーマ自体を検証するテストを名前で区別している。前者は `testFixture...`。
final class DesignSpecTests: XCTestCase {

    /// JSON を経由して往復させ、元と一致することを確認したうえでデコード結果を返す
    private func roundTrip<T: Codable & Equatable>(
        _ value: T, file: StaticString = #filePath, line: UInt = #line
    ) throws -> T {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.sortedKeys]
        let decoded = try JSONDecoder().decode(T.self, from: try encoder.encode(value))
        XCTAssertEqual(value, decoded, "round-trip で値が変わってはならない", file: file, line: line)
        return decoded
    }

    // MARK: - Round-trip（スキーマ本体）

    func testJSONRoundTripIsLossless() throws {
        let original = SmartHRSpecFixture.spec

        let encoder = JSONEncoder()
        encoder.outputFormatting = [.sortedKeys]
        let data = try encoder.encode(original)
        let decoded = try JSONDecoder().decode(DesignSpec.self, from: data)

        XCTAssertEqual(original, decoded, "JSON round-trip でデータが失われてはならない")
    }

    /// ColorTransform の全ケースが、ケースの種類も payload も保ったまま往復する。
    /// fixture は darken と alpha しか使っていないため、lighten と custom はここでしか通らない。
    func testColorTransformRoundTripsEveryCase() throws {
        let states = [
            ColorState(name: "hover", transform: .darken(0.05)),
            ColorState(name: "highlight", transform: .lighten(0.2)),
            ColorState(name: "disabled", transform: .alpha(0.5)),
            ColorState(name: "selected", transform: .custom("mix(MAIN, WHITE, 20%)")),
        ]
        let decoded = try roundTrip(ColorSpec(primitives: [], roles: [], states: states))

        guard case let .darken(amount) = decoded.states[0].transform else {
            return XCTFail("hover は darken のままであるべき")
        }
        XCTAssertEqual(amount, 0.05)

        guard case let .lighten(amount) = decoded.states[1].transform else {
            return XCTFail("highlight は lighten のままであるべき（darken と取り違えていないか）")
        }
        XCTAssertEqual(amount, 0.2)

        guard case let .alpha(amount) = decoded.states[2].transform else {
            return XCTFail("disabled は alpha のままであるべき")
        }
        XCTAssertEqual(amount, 0.5)

        guard case let .custom(rule) = decoded.states[3].transform else {
            return XCTFail("selected は custom のままであるべき")
        }
        XCTAssertEqual(rule, "mix(MAIN, WHITE, 20%)", "自由記述は一字も変えずに保持する")
    }

    /// SpacingModel の absolutePt（payload なしのケース）が charRelative に化けない
    func testSpacingModelRoundTripsBothModels() throws {
        let absolute = try roundTrip(
            SpacingSpec(model: .absolutePt, steps: [SpacingStep(name: "S", value: 8)])
        )
        guard case .absolutePt = absolute.model else {
            return XCTFail("absolutePt が別モデルに化けている")
        }
        XCTAssertNil(absolute.steps[0].multiplier, "absolute では multiplier は nil のまま")

        let relative = try roundTrip(
            SpacingSpec(model: .charRelative(basePx: 8.0), steps: [SpacingStep(name: "S", value: 24, multiplier: 1.5)])
        )
        guard case let .charRelative(basePx) = relative.model else {
            return XCTFail("charRelative が別モデルに化けている")
        }
        XCTAssertEqual(basePx, 8.0)
        XCTAssertEqual(relative.steps[0].multiplier, 1.5)
    }

    /// ScaleModel の 3 ケースが往復する。fixture は harmonic のみなので modular と manual はここだけ。
    func testScaleModelRoundTripsEveryCase() throws {
        let modular = try roundTrip(typographySpec(scaleModel: .modular(base: 1.0, ratio: 1.25)))
        guard case let .modular(base, ratio) = modular.scaleModel else {
            return XCTFail("modular が別モデルに化けている（harmonic と同じラベル構造で潰れていないか）")
        }
        XCTAssertEqual(base, 1.0)
        XCTAssertEqual(ratio, 1.25)

        let manual = try roundTrip(typographySpec(scaleModel: .manual))
        guard case .manual = manual.scaleModel else {
            return XCTFail("manual が別モデルに化けている")
        }

        let harmonic = try roundTrip(typographySpec(scaleModel: .harmonic(base: 1.0, scaleFactor: 6.0)))
        guard case let .harmonic(base, scaleFactor) = harmonic.scaleModel else {
            return XCTFail("harmonic が別モデルに化けている")
        }
        XCTAssertEqual(base, 1.0)
        XCTAssertEqual(scaleFactor, 6.0)
    }

    /// 省略可能フィールドは nil のまま往復し、値がある場合は保持される
    func testOptionalFieldsRoundTripAsNilAndAsValue() throws {
        let bare = try roundTrip(
            ComponentSpec(archetype: "FormControl", name: "FormControl", annotation: "a")
        )
        XCTAssertNil(bare.sourceURL)
        XCTAssertNil(bare.fidelity)

        let full = try roundTrip(
            ComponentSpec(
                archetype: "FocusIndicator", name: "二重リング", annotation: "a",
                sourceURL: "https://example.com", fidelity: "shadow 値まで準拠"
            )
        )
        XCTAssertEqual(full.sourceURL, "https://example.com")
        XCTAssertEqual(full.fidelity, "shadow 値まで準拠")

        // focusRing を持たないブランドも表現できる
        let noRing = try roundTrip(ElevationSpec(layers: []))
        XCTAssertNil(noRing.focusRing)
    }

    /// FontWeightToken は文字列として符号化され、8 段階すべてが往復する
    func testFontWeightTokenRoundTripsAllWeights() throws {
        let weights: [FontWeightToken] = [.thin, .light, .regular, .medium, .semibold, .bold, .heavy, .black]
        XCTAssertEqual(weights.map(\.rawValue), [
            "thin", "light", "regular", "medium", "semibold", "bold", "heavy", "black",
        ])
        for weight in weights {
            let style = try roundTrip(
                TypeStyle(role: "M", sizeRem: 1.0, weight: weight, leadingRef: "normal")
            )
            XCTAssertEqual(style.weight, weight)
        }
    }

    // MARK: - ルックアップ

    func testPrimitiveLookupReturnsNilForAbsentName() {
        let color = SmartHRSpecFixture.spec.color
        XCTAssertNil(color.primitive(named: "PURPLE_100"), "存在しない名前は nil")
        XCTAssertNil(color.primitive(named: ""), "空文字は nil")
        XCTAssertNil(color.primitive(named: "black"), "名前は大文字小文字を区別する")
        XCTAssertEqual(color.primitive(named: "BLACK")?.hex, "#030302")
    }

    func testLeadingLookupReturnsNilForAbsentName() {
        let typo = SmartHRSpecFixture.spec.typography
        XCTAssertNil(typo.leading(named: "loose"), "存在しないトークンは nil")
        XCTAssertNil(typo.leading(named: "NORMAL"), "名前は大文字小文字を区別する")
        XCTAssertEqual(typo.leading(named: "normal")?.multiplier, 1.5)
    }

    /// 同名 primitive が複数ある場合は先頭（= 配列順が優先順位）を返す
    func testPrimitiveLookupReturnsFirstMatch() {
        let color = ColorSpec(
            primitives: [
                ColorToken(name: "MAIN", hex: "#111111"),
                ColorToken(name: "MAIN", hex: "#222222"),
            ],
            roles: []
        )
        XCTAssertEqual(color.primitive(named: "MAIN")?.hex, "#111111")
    }

    // MARK: - SmartHR fixture の実値（スキーマが特異性を保持できている証拠）

    func testCaptursWarmGreyPrimitives() {
        let spec = SmartHRSpecFixture.spec
        // warm black（純黒でない）が保持されている
        XCTAssertEqual(spec.color.primitive(named: "BLACK")?.hex, "#030302")
        // brand cyan と main blue が別ロールとして共存できる
        let brand = spec.color.roles.first { $0.role == "BRAND" }
        let main = spec.color.roles.first { $0.role == "MAIN" }
        XCTAssertEqual(brand?.ref, "SMARTHR_BLUE")
        XCTAssertEqual(main?.ref, "BLUE_100")
        XCTAssertNotEqual(brand?.ref, main?.ref, "BRAND と MAIN は別色")
    }

    func testTypographySeparatesSizeAndLeading() throws {
        let typo = SmartHRSpecFixture.spec.typography
        // 既存 enum で表現できなかった「本文 16px × leading 1.5」を保持
        let bodyM = try XCTUnwrap(typo.ramp.first { $0.role == "M" }, "本文ロール M がランプに無い")
        XCTAssertEqual(bodyM.sizeRem, 1.0)
        XCTAssertEqual(typo.leading(named: bodyM.leadingRef)?.multiplier, 1.5)
        // harmonic モデルが記録されている
        if case let .harmonic(base, scaleFactor) = typo.scaleModel {
            XCTAssertEqual(base, 1.0)
            XCTAssertEqual(scaleFactor, 6.0)
        } else {
            XCTFail("SmartHR は harmonic スケールであるべき")
        }
    }

    func testSpacingIsCharRelative() {
        let spacing = SmartHRSpecFixture.spec.spacing
        guard case let .charRelative(basePx) = spacing.model else {
            return XCTFail("SmartHR の余白は char-relative")
        }
        XCTAssertEqual(basePx, 8.0)
        // XS = multiplier 1.0 × charSize(16) = 16pt
        let xs = spacing.steps.first { $0.name == "XS" }
        XCTAssertEqual(xs?.value, 16)
        XCTAssertEqual(xs?.multiplier, 1.0)
    }

    func testFocusRingIsDoubleRing() {
        let ring = SmartHRSpecFixture.spec.elevation.focusRing
        XCTAssertEqual(ring?.doubleRing, true, "SmartHR の focus は二重リング")
        XCTAssertEqual(ring?.colorRef, "OUTLINE")
    }

    func testFontStackDefersToSystem() {
        // specified-but-not-bundled（書体ライセンス回避）が表現できる
        XCTAssertTrue(SmartHRSpecFixture.spec.typography.fontStack.system)
        XCTAssertTrue(
            SmartHRSpecFixture.spec.typography.fontStack.families.isEmpty,
            "system 委譲なので同梱ファミリは持たない"
        )
    }

    /// fixture 側の記述漏れを見張るガード（スキーマの検証ではない）
    func testFixtureComponentsAreWellFormed() {
        let comps = SmartHRSpecFixture.spec.components
        XCTAssertEqual(comps.map(\.archetype).sorted(), ["FocusIndicator", "FormControl"])
        XCTAssertTrue(comps.allSatisfy { !$0.annotation.isEmpty }, "示唆注釈（なぜ）が空の component がある")
    }

    // MARK: - Helpers

    private func typographySpec(scaleModel: ScaleModel) -> TypographySpec {
        TypographySpec(
            fontStack: FontStack(),
            scaleModel: scaleModel,
            ramp: [TypeStyle(role: "M", sizeRem: 1.0, weight: .regular, leadingRef: "normal")],
            leading: [LeadingToken(name: "normal", multiplier: 1.5)]
        )
    }
}
