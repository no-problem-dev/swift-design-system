import Foundation

/// バイトサイズを表す型
///
/// ファイルサイズの指定を直感的に行うための型です。
/// Int拡張と組み合わせて、自然な記述が可能です。
///
/// ## 使用例
/// ```swift
/// // Int拡張を使用した記述
/// let imageMaxSize = 1.mb
/// let videoMaxSize = 50.mb
///
/// // スタティックメソッドを使用
/// let size = ByteSize.megabytes(100)
///
/// // バイト数の取得
/// print(size.bytes) // 104857600
///
/// // フォーマット済み文字列
/// print(size.formatted) // "100 MB"
/// ```
public struct ByteSize: Sendable, Equatable, Comparable, Hashable {
    /// バイト数
    public let bytes: Int

    // MARK: - Initializers

    /// バイト数から初期化
    ///
    /// - Parameter bytes: バイト数
    public init(bytes: Int) {
        self.bytes = bytes
    }

    // MARK: - Static Factory Methods

    /// バイト単位で作成
    ///
    /// - Parameter value: バイト数
    /// - Returns: ByteSize
    public static func bytes(_ value: Int) -> ByteSize {
        ByteSize(bytes: value)
    }

    /// キロバイト単位で作成
    ///
    /// - Parameter value: キロバイト数
    /// - Returns: ByteSize
    public static func kilobytes(_ value: Int) -> ByteSize {
        ByteSize(bytes: value * 1_024)
    }

    /// メガバイト単位で作成
    ///
    /// - Parameter value: メガバイト数
    /// - Returns: ByteSize
    public static func megabytes(_ value: Int) -> ByteSize {
        ByteSize(bytes: value * 1_024 * 1_024)
    }

    /// ギガバイト単位で作成
    ///
    /// - Parameter value: ギガバイト数
    /// - Returns: ByteSize
    public static func gigabytes(_ value: Int) -> ByteSize {
        ByteSize(bytes: value * 1_024 * 1_024 * 1_024)
    }

    // MARK: - Computed Properties

    /// キロバイト数（小数点以下切り捨て）
    public var kilobytes: Int {
        bytes / 1_024
    }

    /// メガバイト数（小数点以下切り捨て）
    public var megabytes: Int {
        bytes / (1_024 * 1_024)
    }

    /// ギガバイト数（小数点以下切り捨て）
    public var gigabytes: Int {
        bytes / (1_024 * 1_024 * 1_024)
    }

    /// フォーマット済み文字列
    ///
    /// 適切な単位で表示します。
    /// 例: "1.5 MB", "500 KB", "2 GB"
    public var formatted: String {
        let formatter = ByteCountFormatter()
        formatter.allowedUnits = [.useBytes, .useKB, .useMB, .useGB]
        formatter.countStyle = .file
        return formatter.string(fromByteCount: Int64(bytes))
    }

    // MARK: - Comparable

    public static func < (lhs: ByteSize, rhs: ByteSize) -> Bool {
        lhs.bytes < rhs.bytes
    }

    // MARK: - Operators

    /// 加算
    public static func + (lhs: ByteSize, rhs: ByteSize) -> ByteSize {
        ByteSize(bytes: lhs.bytes + rhs.bytes)
    }

    /// 減算
    public static func - (lhs: ByteSize, rhs: ByteSize) -> ByteSize {
        ByteSize(bytes: max(0, lhs.bytes - rhs.bytes))
    }

    /// 乗算
    public static func * (lhs: ByteSize, rhs: Int) -> ByteSize {
        ByteSize(bytes: lhs.bytes * rhs)
    }

    /// 除算
    public static func / (lhs: ByteSize, rhs: Int) -> ByteSize {
        ByteSize(bytes: lhs.bytes / rhs)
    }
}

// MARK: - Int Extension

public extension Int {
    /// バイト単位のByteSize
    var bytes: ByteSize {
        ByteSize.bytes(self)
    }

    /// キロバイト単位のByteSize
    var kb: ByteSize {
        ByteSize.kilobytes(self)
    }

    /// メガバイト単位のByteSize
    var mb: ByteSize {
        ByteSize.megabytes(self)
    }

    /// ギガバイト単位のByteSize
    var gb: ByteSize {
        ByteSize.gigabytes(self)
    }
}

// MARK: - CustomStringConvertible

extension ByteSize: CustomStringConvertible {
    public var description: String {
        formatted
    }
}

// MARK: - ExpressibleByIntegerLiteral

extension ByteSize: ExpressibleByIntegerLiteral {
    /// 整数リテラルから初期化（バイト単位）
    ///
    /// - Parameter value: バイト数
    public init(integerLiteral value: Int) {
        self.bytes = value
    }
}
