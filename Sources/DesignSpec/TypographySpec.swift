import Foundation

/// §3 Typography Rules（CJK 拡張の本丸）。
///
/// 既存 `Typography` 固定 enum が表現できなかったもの全てをここで保持する:
/// - 和文フォントスタック（specified-but-not-bundled = system 委譲も一級）
/// - size と leading(行間倍率) の分離（SmartHR: 本文 16px × leading 1.5）
/// - 生成モデル（SmartHR の harmonic ランプ等）を失わず記録
public struct TypographySpec: Codable, Sendable, Equatable {
    public var fontStack: FontStack
    /// ランプ生成モデル（示唆・再現の根拠）
    public var scaleModel: ScaleModel
    /// role 単位の型スタイル
    public var ramp: [TypeStyle]
    /// 行間トークン（倍率）。role はここを名前参照する。
    public var leading: [LeadingToken]

    public init(fontStack: FontStack, scaleModel: ScaleModel, ramp: [TypeStyle], leading: [LeadingToken]) {
        self.fontStack = fontStack
        self.scaleModel = scaleModel
        self.ramp = ramp
        self.leading = leading
    }

    public func leading(named name: String) -> LeadingToken? {
        leading.first { $0.name == name }
    }
}

/// フォントスタック。`system == true` のとき同梱書体を持たず host の system font に委ねる
/// （SmartHR の実態であり、書体ライセンス問題を構造的に回避する既定方針）。
public struct FontStack: Codable, Sendable, Equatable {
    /// 優先順のファミリ名（和文 → 欧文 → generic）。`system` の場合は空でもよい。
    public var families: [String]
    /// system-ui 委譲か
    public var system: Bool
    public var note: String?

    public init(families: [String] = [], system: Bool = true, note: String? = nil) {
        self.families = families
        self.system = system
        self.note = note
    }
}

/// 型ランプの生成モデル。
public enum ScaleModel: Codable, Sendable, Equatable {
    /// 調和級数（size = base * scaleFactor/(scaleFactor+diff)）。SmartHR 方式。
    case harmonic(base: Double, scaleFactor: Double)
    /// 等比（size = base * ratio^step）。Major Third 等。
    case modular(base: Double, ratio: Double)
    /// 個別指定
    case manual
}

/// role 単位の型スタイル。size は rem（1rem = 16px 基準）で保持しプラットフォーム非依存にする。
public struct TypeStyle: Codable, Sendable, Equatable {
    /// 役割名（例: "body-m", "heading-l"）。ブランド語彙を保持。
    public var role: String
    /// rem（1rem=16px）
    public var sizeRem: Double
    public var weight: FontWeightToken
    /// leading トークン名参照（例: "normal"）
    public var leadingRef: String
    /// 字間（em）。和文では通常 nil/0。
    public var trackingEm: Double?

    public init(role: String, sizeRem: Double, weight: FontWeightToken, leadingRef: String, trackingEm: Double? = nil) {
        self.role = role
        self.sizeRem = sizeRem
        self.weight = weight
        self.leadingRef = leadingRef
        self.trackingEm = trackingEm
    }
}

public enum FontWeightToken: String, Codable, Sendable, Equatable {
    case thin, light, regular, medium, semibold, bold, heavy, black
}

/// 行間トークン（倍率）。例: normal = 1.5。
public struct LeadingToken: Codable, Sendable, Equatable {
    public var name: String
    public var multiplier: Double

    public init(name: String, multiplier: Double) {
        self.name = name
        self.multiplier = multiplier
    }
}
