import Foundation

/// ブランドのデザイン仕様を機械可読に表現する root モデル。
///
/// `awesome-design-md-jp` の `DESIGN.md`（9 セクション）を Codable に移植したもの。
/// SwiftUI 非依存・純データであり、CLI で生成・検証・差分・取り込みができる。
/// ここから `Theme`（トークン）を決定論的に導出するのは上位レイヤー（DesignSystemCore）の責務。
///
/// 設計原則:
/// - 値はプラットフォーム非依存（色は hex 文字列、寸法は数値）。
/// - ブランド差を「失わずに」保持できること（SmartHR の char-relative spacing や
///   harmonic 型ランプ、二重 focus ring を表現できる）が妥当性条件。
public struct DesignSpec: Codable, Sendable, Equatable {
    /// §0 ブランドメタ
    public var meta: BrandMeta
    /// §1 Visual Theme & Atmosphere
    public var theme: VisualTheme
    /// §2 Color Palette & Roles
    public var color: ColorSpec
    /// §3 Typography Rules（CJK 拡張の本丸）
    public var typography: TypographySpec
    /// §5 Layout の余白系（char-relative / absolute）
    public var spacing: SpacingSpec
    /// 角丸
    public var radius: RadiusSpec
    /// §6 Depth & Elevation
    public var elevation: ElevationSpec
    /// §5/§8 Layout Principles & Responsive
    public var layout: LayoutSpec
    /// §4 Component Stylings（archetype 単位 + 示唆注釈）
    public var components: [ComponentSpec]
    /// §7/§9 Do's & Don'ts + Agent Prompt Guide
    public var guidance: Guidance

    public init(
        meta: BrandMeta,
        theme: VisualTheme,
        color: ColorSpec,
        typography: TypographySpec,
        spacing: SpacingSpec,
        radius: RadiusSpec,
        elevation: ElevationSpec,
        layout: LayoutSpec,
        components: [ComponentSpec],
        guidance: Guidance
    ) {
        self.meta = meta
        self.theme = theme
        self.color = color
        self.typography = typography
        self.spacing = spacing
        self.radius = radius
        self.elevation = elevation
        self.layout = layout
        self.components = components
        self.guidance = guidance
    }
}

/// ブランドメタ。OSS 公開を前提に、書体・ロゴ等の配布可否を明示する。
public struct BrandMeta: Codable, Sendable, Equatable {
    /// 一意な識別子（例: "smarthr"）
    public var id: String
    /// 表示名
    public var name: String
    /// 一次情報の URL（公開デザインシステム等）。完全準拠の根拠。
    public var sourceURL: String?
    /// 準拠度・再現の注記（どこまで忠実か、何を省いたか）
    public var fidelityNotes: String?
    /// 法務: 同梱しない資産（有償書体・ロゴ・商標）の宣言
    public var assetPolicy: String?

    public init(id: String, name: String, sourceURL: String? = nil, fidelityNotes: String? = nil, assetPolicy: String? = nil) {
        self.id = id
        self.name = name
        self.sourceURL = sourceURL
        self.fidelityNotes = fidelityNotes
        self.assetPolicy = assetPolicy
    }
}

/// §1 Visual Theme & Atmosphere — 美的方向のキーワード群。
public struct VisualTheme: Codable, Sendable, Equatable {
    /// 雰囲気を表すキーワード（例: ["warm", "trustworthy", "business", "accessible"]）
    public var atmosphere: [String]
    /// 一文の方向性記述
    public var summary: String

    public init(atmosphere: [String], summary: String) {
        self.atmosphere = atmosphere
        self.summary = summary
    }
}
