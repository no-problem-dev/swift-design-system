import SwiftUI

/// テーマが供給する「型ランプ」。役割（``Typography``）→ 解決済みスタイル（``TypeStyle``）の写像。
///
/// 既存 ``Typography`` enum は値を自分の中にハードコードしていたため、ブランドが型を
/// 差し替えられなかった（最大の抽象不足 G1）。本プロトコルは値の供給責務をテーマ側へ移し、
/// `.typography(.bodyMedium)` の呼び出しはそのままに、解決を Environment 経由にする。
///
/// ``Typography`` enum は「役割セレクタ」として残るため、既存の呼び出しは一切変更不要。
public protocol TypographyScale: Sendable {
    /// 役割に対応する解決済みスタイルを返す。
    func style(for role: Typography) -> TypeStyle
}

/// 役割に解決された型スタイル。size と leading(行間倍率) を分離して保持する
/// （SmartHR の「本文 16pt × leading 1.5」のような CJK 型を表現するため）。
public struct TypeStyle: Sendable, Equatable {
    /// フォントサイズ（pt）
    public var size: CGFloat
    /// ウェイト
    public var weight: Font.Weight
    /// 行間倍率（line-height / size）。1.5 で和文標準。
    public var leadingMultiplier: CGFloat
    /// 字間（em）。和文では通常 nil。
    public var trackingEm: CGFloat?
    /// 書体ソース（既定は system 委譲 = specified-but-not-bundled）
    public var fontResource: FontResource

    public init(
        size: CGFloat,
        weight: Font.Weight,
        leadingMultiplier: CGFloat,
        trackingEm: CGFloat? = nil,
        fontResource: FontResource = .system
    ) {
        self.size = size
        self.weight = weight
        self.leadingMultiplier = leadingMultiplier
        self.trackingEm = trackingEm
        self.fontResource = fontResource
    }

    /// 実効行高（pt）
    public var lineHeight: CGFloat { size * leadingMultiplier }

    /// SwiftUI Font を生成する。
    public func font(design: Font.Design? = nil) -> Font {
        fontResource.font(size: size, weight: weight, design: design)
    }
}

/// 書体ソース。OSS 配布の法務制約に対応するため、書体は「指定するが同梱しない」を一級で表現する。
public enum FontResource: Sendable, Equatable {
    /// system-ui へ委譲（同梱書体なし）。SmartHR の実態であり既定。
    case system
    /// 名前付き書体。**このパッケージは書体ファイルを同梱しない**。
    /// host に当該書体があれば使われ、無ければ system にフォールバックする。
    case named(String)

    /// SwiftUI Font を生成する。
    public func font(size: CGFloat, weight: Font.Weight, design: Font.Design?) -> Font {
        switch self {
        case .system:
            return .system(size: size, weight: weight, design: design ?? .default)
        case let .named(name):
            return .custom(name, size: size).weight(weight)
        }
    }
}

/// 既定の型ランプ。**既存 ``Typography`` enum の値から導出**するため、
/// テーマ未適用時・既存テーマでの見た目は従来と完全に一致する（視覚回帰ゼロ）。
public struct DefaultTypographyScale: TypographyScale {
    public init() {}

    public func style(for role: Typography) -> TypeStyle {
        TypeStyle(
            size: role.size,
            weight: role.weight,
            leadingMultiplier: role.size > 0 ? role.lineHeight / role.size : 1,
            fontResource: .system
        )
    }
}
