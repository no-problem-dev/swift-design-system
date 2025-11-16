import SwiftUI

/// カタログのルーティングロジック
///
/// カテゴリとアイテムから適切な詳細ビューを返す
enum CatalogRouter {
    @ViewBuilder
    static func destination(for category: CatalogCategory, item: CatalogItem) -> some View {
        switch category {
        case .themes:
            destinationForTheme()
        case .foundations:
            destinationForFoundation(item: item)
        case .components:
            destinationForComponent()
        case .patterns:
            destinationForPattern()
        }
    }

    // MARK: - Private Helpers

    @ViewBuilder
    private static func destinationForTheme() -> some View {
        ThemeGalleryView()
    }

    @ViewBuilder
    private static func destinationForFoundation(item: CatalogItem) -> some View {
        // 型安全な方法でFoundationItemに変換
        if let foundationItem = FoundationItem.allCases.first(where: { $0.rawValue == item.name }) {
            switch foundationItem {
            case .colors:
                ColorsCatalogView()
            case .typography:
                TypographyCatalogView()
            case .spacing:
                SpacingCatalogView()
            case .radius:
                RadiusCatalogView()
            case .motion:
                MotionCatalogView()
            }
        } else {
            ContentUnavailableView("アイテムが見つかりません", systemImage: "exclamationmark.triangle")
        }
    }

    @ViewBuilder
    private static func destinationForComponent() -> some View {
        ComponentsCatalogView()
    }

    @ViewBuilder
    private static func destinationForPattern() -> some View {
        PatternsCatalogView()
    }
}
