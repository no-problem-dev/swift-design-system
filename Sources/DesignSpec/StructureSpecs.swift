import Foundation

/// §6 Depth & Elevation。
///
/// shadow の CSS をプラットフォーム間で完全移植するのは非現実的なので、
/// 構造化フィールド + 由来記述（rawCSS）の両建てで「準拠の根拠」を残す。
/// focus ring はアクセシビリティの指紋（SmartHR は白ギャップ+色の二重リング）なので一級で持つ。
public struct ElevationSpec: Codable, Sendable, Equatable {
    public var layers: [ElevationLayer]
    public var focusRing: FocusRing?

    public init(layers: [ElevationLayer], focusRing: FocusRing? = nil) {
        self.layers = layers
        self.focusRing = focusRing
    }
}

public struct ElevationLayer: Codable, Sendable, Equatable {
    public var name: String
    /// 影の y オフセット（pt, 概算）
    public var yOffset: Double?
    /// ぼかし半径（pt, 概算）
    public var blur: Double?
    /// 不透明度（0–1, 概算）
    public var opacity: Double?
    /// 由来の生 CSS（完全準拠の根拠）
    public var rawCSS: String?

    public init(name: String, yOffset: Double? = nil, blur: Double? = nil, opacity: Double? = nil, rawCSS: String? = nil) {
        self.name = name
        self.yOffset = yOffset
        self.blur = blur
        self.opacity = opacity
        self.rawCSS = rawCSS
    }
}

public struct FocusRing: Codable, Sendable, Equatable {
    /// 二重リング（白ギャップ + 色）か
    public var doubleRing: Bool
    /// リング色（role 名 or hex）
    public var colorRef: String
    public var note: String?

    public init(doubleRing: Bool, colorRef: String, note: String? = nil) {
        self.doubleRing = doubleRing
        self.colorRef = colorRef
        self.note = note
    }
}

/// §5 Layout Principles + §8 Responsive。
public struct LayoutSpec: Codable, Sendable, Equatable {
    public var principles: [String]
    public var breakpoints: [Breakpoint]

    public init(principles: [String] = [], breakpoints: [Breakpoint] = []) {
        self.principles = principles
        self.breakpoints = breakpoints
    }
}

public struct Breakpoint: Codable, Sendable, Equatable {
    public var name: String
    public var minWidth: Double

    public init(name: String, minWidth: Double) {
        self.name = name
        self.minWidth = minWidth
    }
}

/// §4 Component Stylings。
///
/// behavioral protocol で縛らず**メタデータだけ標準化**する（ブランドの形こそ示唆）。
/// archetype で横断比較を可能にし、`annotation`（なぜそうしたか）が示唆レイヤーの燃料になる。
public struct ComponentSpec: Codable, Sendable, Equatable {
    /// 横断比較の軸（例: "ProductCard", "FocusIndicator", "FormControl"）
    public var archetype: String
    /// ブランド内での呼称（例: "FormControl"）
    public var name: String
    /// 示唆注釈: なぜこの設計か / 何を解くか / CV・継続にどう効くか
    public var annotation: String
    /// 一次情報の URL
    public var sourceURL: String?
    /// 準拠度メモ
    public var fidelity: String?

    public init(archetype: String, name: String, annotation: String, sourceURL: String? = nil, fidelity: String? = nil) {
        self.archetype = archetype
        self.name = name
        self.annotation = annotation
        self.sourceURL = sourceURL
        self.fidelity = fidelity
    }
}

/// §7 Do's & Don'ts + §9 Agent Prompt Guide。
public struct Guidance: Codable, Sendable, Equatable {
    public var dos: [String]
    public var donts: [String]
    /// AI に一貫した UI を生成させるためのプロンプト指針
    public var agentPrompt: String?

    public init(dos: [String] = [], donts: [String] = [], agentPrompt: String? = nil) {
        self.dos = dos
        self.donts = donts
        self.agentPrompt = agentPrompt
    }
}
