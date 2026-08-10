import SwiftUI

enum CatalogCategory: String, CaseIterable, Identifiable {
    case themes = "テーマ"
    case foundations = "デザイントークン"
    case components = "コンポーネント"
    case patterns = "パターン"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .themes: return "paintpalette.fill"
        case .foundations: return "slider.horizontal.3"
        case .components: return "square.stack.3d.up.fill"
        case .patterns: return "square.grid.3x3.fill"
        }
    }

    var description: String {
        switch self {
        case .themes: return "全テーマを閲覧・切り替え"
        case .foundations: return "Color, Typography, Spacingなど"
        case .components: return "全コンポーネントのカタログ"
        case .patterns: return "レイアウトパターンなど"
        }
    }
}
