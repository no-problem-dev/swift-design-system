import XCTest
@testable import DesignSystem

/// `ByteSize` の算術・変換・プロトコル適合の実値検証。
///
/// `formatted` は `ByteCountFormatter` 由来で、区切り記号や小数表記はロケールに依存する。
/// 依存しないのは「どの単位に何で割るか」で、そこは型の算術（1,024 進）と一致していなければ
/// ならない。単位の桁が一致することだけを実文字列で押さえる。
final class ByteSizeTests: XCTestCase {

    // MARK: - ファクトリと単位換算

    func testFactoryMethodsUse1024AsBase() {
        XCTAssertEqual(ByteSize.bytes(500).bytes, 500)
        XCTAssertEqual(ByteSize.kilobytes(1).bytes, 1_024)
        XCTAssertEqual(ByteSize.megabytes(1).bytes, 1_048_576)
        XCTAssertEqual(ByteSize.gigabytes(1).bytes, 1_073_741_824)
    }

    func testFactoryMethodsScaleLinearly() {
        XCTAssertEqual(ByteSize.kilobytes(3).bytes, 3_072)
        XCTAssertEqual(ByteSize.megabytes(50).bytes, 52_428_800)
        XCTAssertEqual(ByteSize.gigabytes(2).bytes, 2_147_483_648)
    }

    func testIntExtensionsMatchFactoryMethods() {
        XCTAssertEqual(500.bytes.bytes, ByteSize.bytes(500).bytes)
        XCTAssertEqual(4.kb.bytes, 4_096)
        XCTAssertEqual(1.mb.bytes, 1_048_576)
        XCTAssertEqual(3.gb.bytes, 3_221_225_472)
    }

    // MARK: - 切り捨て換算

    func testKilobytesTruncatesRemainder() {
        // 1535 は 1KB(1024) + 511 なので 1 に切り捨てられる
        XCTAssertEqual(ByteSize(bytes: 1_535).kilobytes, 1)
        XCTAssertEqual(ByteSize(bytes: 1_024).kilobytes, 1)
        XCTAssertEqual(ByteSize(bytes: 1_023).kilobytes, 0)
        XCTAssertEqual(ByteSize(bytes: 2_048).kilobytes, 2)
    }

    func testMegabytesTruncatesRemainder() {
        XCTAssertEqual(ByteSize(bytes: 1_048_575).megabytes, 0)
        XCTAssertEqual(ByteSize(bytes: 1_048_576).megabytes, 1)
        XCTAssertEqual(ByteSize(bytes: 1_572_864).megabytes, 1) // 1.5MB → 1
        XCTAssertEqual(ByteSize.megabytes(7).megabytes, 7)
    }

    func testGigabytesTruncatesRemainder() {
        XCTAssertEqual(ByteSize(bytes: 1_073_741_823).gigabytes, 0)
        XCTAssertEqual(ByteSize(bytes: 1_073_741_824).gigabytes, 1)
        XCTAssertEqual(ByteSize.megabytes(2_047).gigabytes, 1) // 約 2GB 弱 → 1
    }

    func testUnitAccessorsAreConsistentWithEachOther() {
        let size = ByteSize.megabytes(3)
        XCTAssertEqual(size.bytes, 3_145_728)
        XCTAssertEqual(size.kilobytes, 3_072)
        XCTAssertEqual(size.megabytes, 3)
        XCTAssertEqual(size.gigabytes, 0)
    }

    // MARK: - 加算

    func testAdditionSumsBytes() {
        XCTAssertEqual((1.kb + 512.bytes).bytes, 1_536)
        XCTAssertEqual((1.mb + 1.kb).bytes, 1_049_600)
    }

    func testAdditionWithZeroIsIdentity() {
        XCTAssertEqual((1.mb + 0.bytes).bytes, 1_048_576)
    }

    // MARK: - 減算（0 でクランプ）

    func testSubtractionSubtractsBytes() {
        XCTAssertEqual((2.kb - 512.bytes).bytes, 1_536)
    }

    func testSubtractionClampsToZeroWhenResultWouldBeNegative() {
        // max(0, _) により負値にならない
        XCTAssertEqual((1.kb - 2.kb).bytes, 0)
        XCTAssertEqual((0.bytes - 1.gb).bytes, 0)
    }

    func testSubtractionOfEqualSizesIsZero() {
        XCTAssertEqual((5.mb - 5.mb).bytes, 0)
    }

    func testSubtractionIsNotSymmetric() {
        // クランプがあるため a-b と b-a は一致しない
        XCTAssertEqual((3.kb - 1.kb).bytes, 2_048)
        XCTAssertEqual((1.kb - 3.kb).bytes, 0)
    }

    // MARK: - 乗算

    func testMultiplicationScalesBytes() {
        XCTAssertEqual((1.mb * 3).bytes, 3_145_728)
        XCTAssertEqual((512.bytes * 4).bytes, 2_048)
    }

    func testMultiplicationByZeroIsZero() {
        XCTAssertEqual((1.gb * 0).bytes, 0)
    }

    func testMultiplicationByLargeFactorStaysExact() {
        // オーバーフローしない範囲で桁の大きい乗算が正確であること
        XCTAssertEqual((1.mb * 1_000_000).bytes, 1_048_576_000_000)
    }

    func testMultiplicationByNegativeFactorProducesNegativeBytes() {
        // 減算と違いクランプが無いため負の bytes がそのまま生まれる
        XCTAssertEqual((1.kb * -1).bytes, -1_024)
    }

    // MARK: - 除算
    // rhs = 0 は Int の除算トラップでプロセスが落ちるためテストしない（実装側のガード欠如）

    func testDivisionTruncatesTowardZero() {
        XCTAssertEqual((1.mb / 3).bytes, 349_525) // 1048576/3 = 349525.33...
        XCTAssertEqual((1.kb / 3).bytes, 341)     // 1024/3 = 341.33...
    }

    func testDivisionByOneIsIdentity() {
        XCTAssertEqual((7.mb / 1).bytes, 7_340_032)
    }

    func testDivisionRoundTripsWithMultiplication() {
        XCTAssertEqual((4.mb * 5 / 5).bytes, 4_194_304)
    }

    // MARK: - ExpressibleByIntegerLiteral（リテラルはバイト単位）

    func testIntegerLiteralInitializesAsBytesNotKilobytes() {
        let size: ByteSize = 2_048
        XCTAssertEqual(size.bytes, 2_048)
        XCTAssertEqual(size.kilobytes, 2)
    }

    func testIntegerLiteralEqualsExplicitByteInitializer() {
        let literal: ByteSize = 1_048_576
        XCTAssertEqual(literal, ByteSize(bytes: 1_048_576))
        XCTAssertEqual(literal, 1.mb)
    }

    func testIntegerLiteralWorksInOperators() {
        let sum: ByteSize = 1_000 + 24
        XCTAssertEqual(sum.bytes, 1_024)
    }

    // MARK: - Comparable

    func testComparisonUsesByteCount() {
        XCTAssertTrue(1.kb < 1.mb)
        XCTAssertTrue(1.mb < 1.gb)
        XCTAssertTrue(1_025.bytes > 1.kb)
        XCTAssertFalse(1.kb < 1_024.bytes)
    }

    func testComparisonAcrossUnitsAtBoundary() {
        // 1023KB < 1MB < 1025KB
        XCTAssertTrue(ByteSize.kilobytes(1_023) < 1.mb)
        XCTAssertTrue(1.mb < ByteSize.kilobytes(1_025))
        XCTAssertFalse(ByteSize.kilobytes(1_024) < 1.mb)
    }

    func testSortingOrdersBySize() {
        let sorted = [1.mb, 512.bytes, 2.kb, 1.gb].sorted()
        XCTAssertEqual(sorted.map(\.bytes), [512, 2_048, 1_048_576, 1_073_741_824])
    }

    // MARK: - Equatable / Hashable

    func testEqualityIsByByteCountAcrossUnits() {
        XCTAssertEqual(1.kb, ByteSize(bytes: 1_024))
        XCTAssertEqual(1.mb, ByteSize.kilobytes(1_024))
        XCTAssertNotEqual(1.kb, ByteSize(bytes: 1_023))
    }

    func testHashingDeduplicatesEqualSizes() {
        let set: Set<ByteSize> = [1.kb, ByteSize(bytes: 1_024), 1.mb]
        XCTAssertEqual(set.count, 2)
        XCTAssertTrue(set.contains(ByteSize.kilobytes(1)))
    }

    // MARK: - CustomStringConvertible

    func testDescriptionDelegatesToFormatted() {
        // formatted 自体はロケール依存なので、委譲されていることだけを検証する
        let size = 1.mb
        XCTAssertEqual(size.description, size.formatted)
        XCTAssertEqual("\(size)", size.formatted)
    }

    func testFormattedIsNonEmptyAndDiffersBetweenScales() {
        XCTAssertFalse(1.mb.formatted.isEmpty)
        XCTAssertNotEqual(1.kb.formatted, 1.gb.formatted)
    }

    // MARK: - formatted は型と同じ 1,024 進で数える

    func testFormattedCountsInBinaryUnitsLikeTheArithmetic() {
        // 1,000 進で数えると 100MB が "104.9 MB"、1GB が "1.07 GB" になり、
        // 組み立てた単位と表示が食い違う
        XCTAssertEqual(ByteSize.megabytes(100).formatted, "100 MB")
        XCTAssertEqual(ByteSize.megabytes(1).formatted, "1 MB")
        XCTAssertEqual(ByteSize.kilobytes(1).formatted, "1 KB")
        XCTAssertEqual(ByteSize.gigabytes(1).formatted, "1 GB")
        XCTAssertEqual(ByteSize.gigabytes(2).formatted, "2 GB")
        XCTAssertEqual(50.mb.formatted, "50 MB")
    }

    func testFormattedRoundTripsWithTheUnitAccessors() {
        // formatted が示す単位と桁は、切り捨て換算のプロパティと一致する
        for value in [1, 3, 7, 100, 512] {
            let size = ByteSize.megabytes(value)
            XCTAssertEqual(size.megabytes, value)
            XCTAssertEqual(size.formatted, "\(value) MB", "megabytes(\(value))")
        }
    }
}
