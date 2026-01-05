import SwiftUI

/// パターンのアイテム
enum PatternItem: String, CaseIterable, Identifiable {
    case aspectGrid = "AspectGrid"
    case sectionCard = "SectionCard"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .aspectGrid: return "square.grid.2x2.fill"
        case .sectionCard: return "rectangle.fill.on.rectangle.fill"
        }
    }

    var description: String {
        switch self {
        case .aspectGrid: return "アスペクト比固定グリッドレイアウト"
        case .sectionCard: return "タイトル付きセクションコンテナ"
        }
    }
}
