import SwiftUI
import DesignSystem

@main
struct DesignSystemCatalogApp: App {
    @State private var themeProvider = ThemeProvider()

    var body: some Scene {
        WindowGroup {
            DesignSystemCatalogView()
                .theme(themeProvider)
        }
    }
}
