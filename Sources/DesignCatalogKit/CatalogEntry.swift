import SwiftUI
import DesignSystem
import DesignSpec

/// 示唆注釈。コンポーネント/トークン決定の「なぜ」を保持し、横断比較の燃料になる。
public struct DesignAnnotation: Sendable, Equatable {
    /// 何を解くか
    public var purpose: String
    /// なぜ効くか（CV・継続・アクセシビリティ等）
    public var whyItWorks: String
    /// 一次情報の URL
    public var sourceURL: String?

    public init(purpose: String, whyItWorks: String, sourceURL: String? = nil) {
        self.purpose = purpose
        self.whyItWorks = whyItWorks
        self.sourceURL = sourceURL
    }

    /// `DesignSpec` の `ComponentSpec` から注釈を起こす（spec を source of truth にする）。
    public init(from component: ComponentSpec) {
        self.purpose = component.name
        self.whyItWorks = component.annotation
        self.sourceURL = component.sourceURL
    }
}

/// カタログに登録される 1 ショーケース。ブランドの象徴コンポーネントを、その**ブランド自身の
/// テーマ下で**描画し、archetype（比較軸）と示唆注釈を添える。
///
/// `archetype` が同じエントリ同士を並べるのが compare-mode の核心
/// （SmartHR の FormControl と他社の FormControl を横並びで比較する）。
public struct CatalogEntry: Identifiable {
    public let id: String
    /// ブランド識別子（例: "smarthr"）
    public let brandId: String
    public let brandName: String
    /// 横断比較の軸（例: "FormControl", "FocusIndicator", "ProductCard"）
    public let archetype: String
    public let title: String
    public let annotation: DesignAnnotation
    /// このエントリを描画するブランドテーマ
    public let theme: any Theme
    /// 生のコンポーネント（型消去）
    public let content: AnyView

    @MainActor
    public init<Content: View>(
        id: String,
        brandId: String,
        brandName: String,
        archetype: String,
        title: String,
        annotation: DesignAnnotation,
        theme: any Theme,
        @ViewBuilder content: @MainActor () -> Content
    ) {
        self.id = id
        self.brandId = brandId
        self.brandName = brandName
        self.archetype = archetype
        self.title = title
        self.annotation = annotation
        self.theme = theme
        self.content = AnyView(content())
    }
}

public extension Array where Element == CatalogEntry {
    /// archetype ごとにグルーピング（compare-mode 用）。archetype 名でソート。
    func groupedByArchetype() -> [(archetype: String, entries: [CatalogEntry])] {
        Dictionary(grouping: self, by: \.archetype)
            .sorted { $0.key < $1.key }
            .map { (archetype: $0.key, entries: $0.value) }
    }

    /// 指定 archetype のエントリのみ。
    func entries(ofArchetype archetype: String) -> [CatalogEntry] {
        filter { $0.archetype == archetype }
    }
}
