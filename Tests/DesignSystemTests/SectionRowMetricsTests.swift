import XCTest
import SwiftUI
@testable import DesignSystem

/// 行の骨格がトークンから導出され、Dynamic Type で伸びても最小タップ領域を割らないことを見る。
///
/// アイコン列の幅とテキストの寸法が別々に決まると行ごとにラベルの左端がずれるため、
/// 「同じ入力からは必ず同じ骨格が出る」ことを値で固定する。
final class SectionRowMetricsTests: XCTestCase {
    private let iconSize = DefaultIconSizeScale()
    private let spacing = DefaultSpacingScale()

    private func metrics(typeScale: CGFloat) -> SectionRowMetrics {
        SectionRowMetrics(iconSize: iconSize, spacing: spacing, typeScale: typeScale)
    }

    func testIconColumnComesFromTheIconScale() {
        let m = metrics(typeScale: 1)
        // 生の数値ではなくトークン由来であること。LinkCard の IconBadge(.small) と同じ 32pt
        XCTAssertEqual(m.iconColumnWidth, iconSize.lg)
        XCTAssertEqual(m.iconGlyphSize, iconSize.sm)
        XCTAssertEqual(m.iconGap, spacing.sm)
    }

    func testGlyphFitsInsideTheColumn() {
        // 字幅の広い記号でも列からはみ出しにくいよう、字面は列より小さい
        let m = metrics(typeScale: 1)
        XCTAssertLessThan(m.iconGlyphSize, m.iconColumnWidth)
    }

    func testMinimumHeightNeverGoesBelowTheTouchTarget() {
        // 文字を最小にした設定でも 44pt は割らない
        XCTAssertEqual(metrics(typeScale: 0.82).minHeight, ControlTokens.minTouchTarget)
        XCTAssertEqual(metrics(typeScale: 1).minHeight, ControlTokens.minTouchTarget)
    }

    func testColumnAndHeightGrowWithDynamicType() {
        let large = metrics(typeScale: 2)
        XCTAssertEqual(large.iconColumnWidth, iconSize.lg * 2)
        XCTAssertEqual(large.iconGlyphSize, iconSize.sm * 2)
        XCTAssertEqual(large.minHeight, ControlTokens.minTouchTarget * 2)
    }

    func testLabelLeadingEdgeIsStableAcrossRows() {
        // 行の horizontal padding + アイコン列 + 間隔 = ラベルの左端。
        // アイコンの記号が何であってもこの合計は変わらない
        let m = metrics(typeScale: 1)
        XCTAssertEqual(spacing.lg + m.iconColumnWidth + m.iconGap, 56)
    }
}
