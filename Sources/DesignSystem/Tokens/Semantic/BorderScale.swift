import SwiftUI

/// 線幅スケール。境界線・区切り線・フォーカスリング外周などの stroke 幅を token 化する。
///
/// 既存はコンポーネント内に `lineWidth: 1` 等が散在していた。ブランドにより線の重さは
/// 大きく異なる（SmartHR は 1px 主体、フォーカスは 2px+2px の二重リング）ため抽象化する。
public protocol BorderScale: Sendable {
    /// 0
    var none: CGFloat { get }
    /// ヘアライン（0.5）
    var thin: CGFloat { get }
    /// 標準（1）
    var regular: CGFloat { get }
    /// 強調（2）
    var thick: CGFloat { get }
    /// フォーカスリング等（4）
    var heavy: CGFloat { get }
}

public struct DefaultBorderScale: BorderScale {
    public init() {}
    public var none: CGFloat { 0 }
    public var thin: CGFloat { 0.5 }
    public var regular: CGFloat { 1 }
    public var thick: CGFloat { 2 }
    public var heavy: CGFloat { 4 }
}
