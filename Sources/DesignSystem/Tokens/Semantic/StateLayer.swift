import SwiftUI

/// 状態レイヤーの不透明度トークン。hover/pressed/focus 等のインタラクション時に
/// 前景色を重ねるオーバーレイの濃度を表す（Material の state layer 相当）。
///
/// ブランドにより状態表現は異なる（SmartHR は hover=darken 5% + INPUT_HOVER リング、
/// Material は overlay 不透明度）。ここでは不透明度オーバーレイモデルで統一する。
public protocol StateLayer: Sendable {
    var hover: Double { get }
    var focus: Double { get }
    var pressed: Double { get }
    var dragged: Double { get }
    var selected: Double { get }
}

public struct DefaultStateLayer: StateLayer {
    public init() {}
    public var hover: Double { 0.08 }
    public var focus: Double { 0.10 }
    public var pressed: Double { 0.10 }
    public var dragged: Double { 0.16 }
    public var selected: Double { 0.12 }
}
