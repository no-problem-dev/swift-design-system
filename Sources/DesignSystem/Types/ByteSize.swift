import Foundation

/// A byte count that carries its unit, so a size limit cannot be passed as a bare number.
///
/// The units are binary: a kilobyte is 1,024 bytes and a megabyte is 1,024 of those. `formatted`
/// counts the way the Finder does, in powers of 1,000, so a displayed value reads slightly larger
/// than the unit it was built from.
///
/// ## Example
/// ```swift
/// // Through the Int properties
/// let imageMaxSize = 1.mb
/// let videoMaxSize = 50.mb
///
/// // Through the factory methods
/// let size = ByteSize.megabytes(100)
///
/// print(size.bytes) // 104857600
/// print(size.formatted) // "104.9 MB"
/// ```
public struct ByteSize: Sendable, Equatable, Comparable, Hashable {
    public let bytes: Int

    // MARK: - Initializers

    public init(bytes: Int) {
        self.bytes = bytes
    }

    // MARK: - Static Factory Methods

    public static func bytes(_ value: Int) -> ByteSize {
        ByteSize(bytes: value)
    }

    public static func kilobytes(_ value: Int) -> ByteSize {
        ByteSize(bytes: value * 1_024)
    }

    public static func megabytes(_ value: Int) -> ByteSize {
        ByteSize(bytes: value * 1_024 * 1_024)
    }

    public static func gigabytes(_ value: Int) -> ByteSize {
        ByteSize(bytes: value * 1_024 * 1_024 * 1_024)
    }

    // MARK: - Computed Properties

    /// Whole kilobytes, with any remainder dropped. A size under 1 KB reads as 0.
    public var kilobytes: Int {
        bytes / 1_024
    }

    /// Whole megabytes, with any remainder dropped. A size under 1 MB reads as 0.
    public var megabytes: Int {
        bytes / (1_024 * 1_024)
    }

    /// Whole gigabytes, with any remainder dropped. A size under 1 GB reads as 0.
    public var gigabytes: Int {
        bytes / (1_024 * 1_024 * 1_024)
    }

    /// A string for display, in whichever unit fits, such as "1.5 MB" or "500 KB".
    ///
    /// The count follows the Finder's convention of 1,000 bytes to the kilobyte, so the number
    /// differs from `kilobytes` and its siblings, which count in 1,024s.
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

    public static func + (lhs: ByteSize, rhs: ByteSize) -> ByteSize {
        ByteSize(bytes: lhs.bytes + rhs.bytes)
    }

    /// Subtracts, stopping at zero rather than producing a negative size.
    public static func - (lhs: ByteSize, rhs: ByteSize) -> ByteSize {
        ByteSize(bytes: max(0, lhs.bytes - rhs.bytes))
    }

    public static func * (lhs: ByteSize, rhs: Int) -> ByteSize {
        ByteSize(bytes: lhs.bytes * rhs)
    }

    /// Divides, dropping any remainder.
    public static func / (lhs: ByteSize, rhs: Int) -> ByteSize {
        ByteSize(bytes: lhs.bytes / rhs)
    }
}

// MARK: - Int Extension

public extension Int {
    var bytes: ByteSize {
        ByteSize.bytes(self)
    }

    /// This many kilobytes, counted as 1,024 bytes each.
    var kb: ByteSize {
        ByteSize.kilobytes(self)
    }

    /// This many megabytes, counted as 1,024 kilobytes each.
    var mb: ByteSize {
        ByteSize.megabytes(self)
    }

    /// This many gigabytes, counted as 1,024 megabytes each.
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
    /// Reads a plain integer literal as a count of bytes, not kilobytes or megabytes.
    ///
    /// - Parameter value: The number of bytes.
    public init(integerLiteral value: Int) {
        self.bytes = value
    }
}
