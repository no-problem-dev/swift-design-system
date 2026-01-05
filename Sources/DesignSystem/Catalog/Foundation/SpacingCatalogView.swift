import SwiftUI

/// スペーシングカタログビュー
struct SpacingCatalogView: View {
    @Environment(\.spacingScale) private var spacing
    @Environment(\.colorPalette) private var colors

    var body: some View {
        CatalogPageContainer(title: "スペーシング") {
            CatalogOverview(description: "Tシャツサイズベースのスペーシングスケール")

            SectionCard(title: "Spacing Scale") {
                VStack(spacing: spacing.md) {
                    SpacingDemoView(name: "none", value: spacing.none)
                    SpacingDemoView(name: "xxs", value: spacing.xxs)
                    SpacingDemoView(name: "xs", value: spacing.xs)
                    SpacingDemoView(name: "sm", value: spacing.sm)
                    SpacingDemoView(name: "md", value: spacing.md)
                    SpacingDemoView(name: "lg", value: spacing.lg)
                    SpacingDemoView(name: "xl", value: spacing.xl)
                    SpacingDemoView(name: "xxl", value: spacing.xxl)
                    SpacingDemoView(name: "xxxl", value: spacing.xxxl)
                    SpacingDemoView(name: "xxxxl", value: spacing.xxxxl)
                }
            }

            SectionCard(title: "使用例") {
                CodeExample(code: """
                    @Environment(\\.spacingScale) var spacing

                    VStack(spacing: spacing.md) {
                        Text("Hello")
                        Text("World")
                    }
                    .padding(spacing.lg)
                    """)
            }
        }
    }
}

#Preview {
    NavigationStack {
        SpacingCatalogView()
            .environment(\.spacingScale, DefaultSpacingScale())
    }
}
