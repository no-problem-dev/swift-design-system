import Foundation

/// 余白スケール。絶対 pt と char-relative（em ベース）の両モデルを表せる。
///
/// SmartHR は char-relative（base 8px、charSize=16px、step = multiplier×16px）。
/// 既存の絶対 pt `SpacingScale` とは思想が異なるため、ここで両方を保持できることが妥当性条件。
public struct SpacingSpec: Codable, Sendable, Equatable {
    public var model: SpacingModel
    public var steps: [SpacingStep]

    public init(model: SpacingModel, steps: [SpacingStep]) {
        self.model = model
        self.steps = steps
    }
}

public enum SpacingModel: Codable, Sendable, Equatable {
    /// 値をそのまま pt として扱う
    case absolutePt
    /// base(px) を基準に multiplier で算出（pt 化は導出層が行う）
    case charRelative(basePx: Double)
}

public struct SpacingStep: Codable, Sendable, Equatable {
    public var name: String
    /// 解決済み pt 値（absolute）または multiplier 解決後の px 値
    public var value: Double
    /// char-relative の元倍率（記録用・nil 可）
    public var multiplier: Double?

    public init(name: String, value: Double, multiplier: Double? = nil) {
        self.name = name
        self.value = value
        self.multiplier = multiplier
    }
}

/// 角丸スケール。
public struct RadiusSpec: Codable, Sendable, Equatable {
    public var steps: [RadiusStep]

    public init(steps: [RadiusStep]) {
        self.steps = steps
    }
}

public struct RadiusStep: Codable, Sendable, Equatable {
    public var name: String
    /// pt（full は巨大値）
    public var value: Double

    public init(name: String, value: Double) {
        self.name = name
        self.value = value
    }
}
