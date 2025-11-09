import SwiftUI

/// デザインシステムカタログのエントリポイント
/// デザインシステムの全要素を階層的に表示
///
/// 画面サイズに応じて最適なレイアウトを自動選択：
/// - Regular horizontal size class: 3カラムのNavigationSplitView
/// - Compact horizontal size class: NavigationStackベースのリスト表示
///
/// これにより、iPad Split ViewやSlide Overでも適切に対応します。
public struct DesignSystemCatalogView: View {
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass

    public init() {}

    public var body: some View {
        if horizontalSizeClass == .regular {
            DesignSystemCatalogSplitView()
        } else {
            CatalogListView()
        }
    }
}

#Preview {
    DesignSystemCatalogView()
        .theme(ThemeProvider())
}
