import SwiftUI

/// カタログページ全体のコンテナ
struct CatalogPageContainer<Content: View>: View {
    @Environment(\.colorPalette) private var colors
    @Environment(\.spacingScale) private var spacing

    let title: String
    @ViewBuilder let content: () -> Content

    var body: some View {
        ScrollView {
            VStack(spacing: spacing.xl) {
                content()
            }
            .padding(.bottom, spacing.xl)
        }
        .background(colors.background)
        .navigationTitle(title)
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
    }
}
