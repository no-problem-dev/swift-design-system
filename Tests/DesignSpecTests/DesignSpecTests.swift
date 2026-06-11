import XCTest
@testable import DesignSpec

/// DesignSpec スキーマの妥当性検証。
/// 中心的主張: SmartHR の特異性を失わず表現でき、JSON round-trip で完全一致する
/// （= 315 コーパス取り込みと LLM 生成の交換形式として成立する）。
final class DesignSpecTests: XCTestCase {

    func testJSONRoundTripIsLossless() throws {
        let original = SmartHRSpecFixture.spec

        let encoder = JSONEncoder()
        encoder.outputFormatting = [.sortedKeys]
        let data = try encoder.encode(original)
        let decoded = try JSONDecoder().decode(DesignSpec.self, from: data)

        XCTAssertEqual(original, decoded, "JSON round-trip でデータが失われてはならない")
    }

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

    func testTypographySeparatesSizeAndLeading() {
        let typo = SmartHRSpecFixture.spec.typography
        // 既存 enum で表現できなかった「本文 16px × leading 1.5」を保持
        let bodyM = typo.ramp.first { $0.role == "M" }
        XCTAssertEqual(bodyM?.sizeRem, 1.0)
        XCTAssertEqual(typo.leading(named: bodyM!.leadingRef)?.multiplier, 1.5)
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
    }

    func testComponentsCarryArchetypeAndAnnotation() {
        let comps = SmartHRSpecFixture.spec.components
        XCTAssertTrue(comps.contains { $0.archetype == "FocusIndicator" })
        // 示唆注釈（なぜ）が空でない = 比較・学習の燃料が載っている
        XCTAssertTrue(comps.allSatisfy { !$0.annotation.isEmpty })
    }
}
