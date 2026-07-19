import XCTest
import SwiftUI
@testable import DesignSystem

/// `Elevation` ランプの実値検証。
///
/// level0〜level5 の radius / offset / opacity を具体値で固定する。
/// `DefaultElevationScale` は enum から導出する実装なので、enum 側の値を独立に
/// 固定してから scale がそれを写していることを見る（scale を自分自身と比べない）。
final class ElevationTests: XCTestCase {

    /// (level, radius, offsetHeight, opacity)。全 6 レベルを網羅する。
    private let expected: [(level: Elevation, radius: CGFloat, offsetHeight: CGFloat, opacity: Double)] = [
        (.level0, 0, 0, 0),
        (.level1, 3, 1, 0.08),
        (.level2, 6, 2, 0.10),
        (.level3, 8, 4, 0.12),
        (.level4, 10, 6, 0.14),
        (.level5, 12, 8, 0.16),
    ]

    func testEveryLevelPinsItsShadowGeometry() {
        for row in expected {
            XCTAssertEqual(row.level.radius, row.radius, "radius")
            XCTAssertEqual(row.level.offset.width, 0, "offset.width は全レベルで 0（影は真下へ落ちる）")
            XCTAssertEqual(row.level.offset.height, row.offsetHeight, "offset.height")
            XCTAssertEqual(row.level.opacity, row.opacity, accuracy: 0.0001, "opacity")
        }
    }

    func testLevel0IsFullyFlat() {
        // 埋め込み要素用。radius / offset / opacity のいずれかが非ゼロだと影が出てしまう
        XCTAssertEqual(Elevation.level0.radius, 0)
        XCTAssertEqual(Elevation.level0.offset, .zero)
        XCTAssertEqual(Elevation.level0.opacity, 0, accuracy: 0.0001)
    }

    func testLevel5IsTheHeaviestBound() {
        XCTAssertEqual(Elevation.level5.radius, 12)
        XCTAssertEqual(Elevation.level5.offset, CGSize(width: 0, height: 8))
        XCTAssertEqual(Elevation.level5.opacity, 0.16, accuracy: 0.0001)
    }

    func testRampIncreasesMonotonicallyAcrossLevels() {
        let radii = expected.map(\.radius)
        let offsets = expected.map(\.offsetHeight)
        let opacities = expected.map(\.opacity)
        for index in 1..<expected.count {
            XCTAssertGreaterThan(radii[index], radii[index - 1], "radius が単調増加していない")
            XCTAssertGreaterThan(offsets[index], offsets[index - 1], "offset が単調増加していない")
            XCTAssertGreaterThan(opacities[index], opacities[index - 1], "opacity が単調増加していない")
        }
    }

    func testDarkModeDampsOpacityToFiftyFivePercent() {
        for row in expected {
            XCTAssertEqual(row.level.opacity(for: .light), row.opacity, accuracy: 0.0001)
            XCTAssertEqual(row.level.opacity(for: .dark), row.opacity * 0.55, accuracy: 0.0001)
        }
        // 具体値でも固定（係数を書き換えたら落ちる）
        XCTAssertEqual(Elevation.level5.opacity(for: .dark), 0.088, accuracy: 0.0001)
    }

    func testSurfaceTintOpacityIsHigherInDarkModeAndZeroAtLevel0() {
        XCTAssertEqual(Elevation.level0.surfaceTintOpacity(for: .light), 0, accuracy: 0.0001)
        XCTAssertEqual(Elevation.level0.surfaceTintOpacity(for: .dark), 0, accuracy: 0.0001)

        let light: [(Elevation, Double)] = [
            (.level1, 0.015), (.level2, 0.02), (.level3, 0.025), (.level4, 0.03), (.level5, 0.035),
        ]
        let dark: [(Elevation, Double)] = [
            (.level1, 0.03), (.level2, 0.04), (.level3, 0.05), (.level4, 0.06), (.level5, 0.07),
        ]
        for (level, value) in light {
            XCTAssertEqual(level.surfaceTintOpacity(for: .light), value, accuracy: 0.0001)
        }
        for (level, value) in dark {
            // ダークは surface の明度差で奥行きを出すため tint が濃い
            XCTAssertEqual(level.surfaceTintOpacity(for: .dark), value, accuracy: 0.0001)
        }
    }

    // MARK: - DefaultElevationScale

    func testDefaultScaleReproducesTheRampForEveryLevel() {
        let scale = DefaultElevationScale()
        for row in expected {
            let style = scale.style(for: row.level)
            XCTAssertEqual(style.radius, row.radius, "level radius")
            XCTAssertEqual(style.offset, CGSize(width: 0, height: row.offsetHeight), "level offset")
            XCTAssertEqual(style.opacity, row.opacity, accuracy: 0.0001, "level opacity")
        }
    }

    func testElevationStyleAppliesTheSameDarkModeDamping() {
        let style = DefaultElevationScale().style(for: .level4)
        XCTAssertEqual(style.opacity(for: .light), 0.14, accuracy: 0.0001)
        XCTAssertEqual(style.opacity(for: .dark), 0.14 * 0.55, accuracy: 0.0001)
    }

    func testElevationStyleEqualityDistinguishesEachComponent() {
        let base = ElevationStyle(radius: 6, offset: CGSize(width: 0, height: 2), opacity: 0.1)
        XCTAssertEqual(base, ElevationStyle(radius: 6, offset: CGSize(width: 0, height: 2), opacity: 0.1))
        XCTAssertNotEqual(base, ElevationStyle(radius: 7, offset: CGSize(width: 0, height: 2), opacity: 0.1))
        XCTAssertNotEqual(base, ElevationStyle(radius: 6, offset: CGSize(width: 0, height: 3), opacity: 0.1))
        XCTAssertNotEqual(base, ElevationStyle(radius: 6, offset: CGSize(width: 0, height: 2), opacity: 0.2))
    }
}
