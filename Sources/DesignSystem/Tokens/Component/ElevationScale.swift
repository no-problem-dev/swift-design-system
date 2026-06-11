import SwiftUI

/// レベルに解決された影スタイル。
public struct ElevationStyle: Sendable, Equatable {
    public var radius: CGFloat
    public var offset: CGSize
    public var opacity: Double

    public init(radius: CGFloat, offset: CGSize, opacity: Double) {
        self.radius = radius
        self.offset = offset
        self.opacity = opacity
    }

    /// ダークモードでは影を控えめに（surface 明度差で奥行きを出すため）。
    public func opacity(for colorScheme: ColorScheme) -> Double {
        colorScheme == .dark ? opacity * 0.55 : opacity
    }
}

/// Elevation レベル → 影スタイルの写像。テーマが override すると影の重さを差し替えられる
/// （フラット ⇔ 重厚 をブランドが選べる。既存 ``Elevation`` enum は固定だった）。
public protocol ElevationScale: Sendable {
    func style(for level: Elevation) -> ElevationStyle
}

/// 既定の影ランプ。**既存 ``Elevation`` enum の値から導出**するため視覚回帰ゼロ。
public struct DefaultElevationScale: ElevationScale {
    public init() {}
    public func style(for level: Elevation) -> ElevationStyle {
        ElevationStyle(radius: level.radius, offset: level.offset, opacity: level.opacity)
    }
}
