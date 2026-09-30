import Foundation
import DesignSystem

/// Compares the tokens of two themes.
///
/// The diff is an instrument in its own right: it puts numbers on why two brands feel different.
/// The logic depends on no UI, so it can be unit tested.
public enum TokenDiff {

    /// One row of a diff, holding a single token's value in each of the two themes.
    public struct Row: Sendable, Equatable, Identifiable {
        public var id: String { label }
        /// The name of the token, such as "bodyMedium", "lg", or "card".
        public var label: String
        /// The token's value in the first theme, formatted for display.
        public var a: String
        /// The token's value in the second theme, formatted for display.
        public var b: String
        /// Whether the two themes give this token different values.
        ///
        /// Combine it with ``differing(_:)`` to keep only the rows that differ.
        public var differs: Bool

        public init(label: String, a: String, b: String) {
            self.label = label
            self.a = a
            self.b = b
            self.differs = a != b
        }
    }

    /// The typography differences: the size and leading of every role.
    public static func typography(_ a: any TypographyScale, _ b: any TypographyScale) -> [Row] {
        Typography.allCases.map { role in
            let sa = a.style(for: role)
            let sb = b.style(for: role)
            return Row(
                label: String(describing: role),
                a: fmt(sa.size, sa.leadingMultiplier),
                b: fmt(sb.size, sb.leadingMultiplier)
            )
        }
    }

    /// The spacing differences, across every step of the scale.
    public static func spacing(_ a: any SpacingScale, _ b: any SpacingScale) -> [Row] {
        let items: [(String, CGFloat, CGFloat)] = [
            ("none", a.none, b.none), ("xxs", a.xxs, b.xxs), ("xs", a.xs, b.xs),
            ("sm", a.sm, b.sm), ("md", a.md, b.md), ("lg", a.lg, b.lg),
            ("xl", a.xl, b.xl), ("xxl", a.xxl, b.xxl), ("xxxl", a.xxxl, b.xxxl),
            ("xxxxl", a.xxxxl, b.xxxxl),
        ]
        return items.map { Row(label: $0.0, a: num($0.1), b: num($0.2)) }
    }

    /// The corner radius differences, across every step of the scale.
    public static func radius(_ a: any RadiusScale, _ b: any RadiusScale) -> [Row] {
        let items: [(String, CGFloat, CGFloat)] = [
            ("none", a.none, b.none), ("xs", a.xs, b.xs), ("sm", a.sm, b.sm),
            ("md", a.md, b.md), ("lg", a.lg, b.lg), ("xl", a.xl, b.xl),
            ("xxl", a.xxl, b.xxl), ("card", a.card, b.card), ("full", a.full, b.full),
        ]
        return items.map { Row(label: $0.0, a: num($0.1), b: num($0.2)) }
    }

    /// Returns only the rows whose values differ, which is the short form of a diff.
    public static func differing(_ rows: [Row]) -> [Row] { rows.filter(\.differs) }

    private static func fmt(_ size: CGFloat, _ leading: CGFloat) -> String {
        "\(num(size))pt ×\(String(format: "%.2f", leading))"
    }
    private static func num(_ v: CGFloat) -> String {
        guard v.isFinite else { return "∞" }
        if v != v.rounded() { return String(format: "%.1f", v) }
        // Keeps Int() from trapping on the huge values used by steps such as full, which come from
        // rounding or overflowing .infinity
        if abs(v) > 1e9 { return String(format: "%.0f", v) }
        return String(Int(v))
    }
}
