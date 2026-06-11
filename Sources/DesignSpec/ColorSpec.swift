import Foundation

/// §2 Color Palette & Roles。
///
/// 2 段構成: primitive（生の色ラダー）→ role（意味付け）。
/// state（hover/disabled 等）は「関数」を値として保持し、ブランドの導出規則
/// （例: SmartHR の hover = darken 5%, disabled = alpha 0.5）を失わずに表す。
public struct ColorSpec: Codable, Sendable, Equatable {
    /// 生の色トークン（名前順を保つため配列）
    public var primitives: [ColorToken]
    /// 意味的ロール（primitive 名 or hex を参照）
    public var roles: [ColorRole]
    /// 状態派生規則（hover / disabled / link-hover 等）
    public var states: [ColorState]

    public init(primitives: [ColorToken], roles: [ColorRole], states: [ColorState] = []) {
        self.primitives = primitives
        self.roles = roles
        self.states = states
    }

    /// primitive を名前で引く（role 解決のヘルパ）。
    public func primitive(named name: String) -> ColorToken? {
        primitives.first { $0.name == name }
    }
}

/// 生の色トークン。
public struct ColorToken: Codable, Sendable, Equatable {
    public var name: String
    /// `#rrggbb` または `#rrggbbaa`
    public var hex: String
    /// 由来メモ（例: "warm black hwb(56,17,1)"）
    public var note: String?

    public init(name: String, hex: String, note: String? = nil) {
        self.name = name
        self.hex = hex
        self.note = note
    }
}

/// 意味的ロール。`ref` は primitive 名（推奨）か直接 hex。
public struct ColorRole: Codable, Sendable, Equatable {
    /// 役割名（例: "MAIN", "TEXT_LINK", "BRAND"）。ブランド語彙をそのまま保持。
    public var role: String
    /// 参照する primitive 名、または `#hex`
    public var ref: String
    public var note: String?

    public init(role: String, ref: String, note: String? = nil) {
        self.role = role
        self.ref = ref
        self.note = note
    }
}

/// 状態派生規則。
public struct ColorState: Codable, Sendable, Equatable {
    public var name: String
    public var transform: ColorTransform

    public init(name: String, transform: ColorTransform) {
        self.name = name
        self.transform = transform
    }
}

/// 色変換関数。ブランドの導出ロジックを宣言的に保持する。
public enum ColorTransform: Codable, Sendable, Equatable {
    /// 暗くする（0.0–1.0）
    case darken(Double)
    /// 明るくする（0.0–1.0）
    case lighten(Double)
    /// 不透明度を掛ける（0.0–1.0）
    case alpha(Double)
    /// 上記で表せない規則の自由記述
    case custom(String)
}
