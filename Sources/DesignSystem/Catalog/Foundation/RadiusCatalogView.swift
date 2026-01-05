import SwiftUI

/// 角丸カタログビュー
struct RadiusCatalogView: View {
    @Environment(\.radiusScale) private var radius
    @Environment(\.colorPalette) private var colors
    @Environment(\.spacingScale) private var spacing

    var body: some View {
        CatalogPageContainer(title: "角丸") {
            CatalogOverview(description: "Material Design 3ベースの角丸スケール")

            SectionCard(title: "Radius Scale") {
                VStack(spacing: spacing.md) {
                    RadiusDemoView(name: "none", value: radius.none)
                    RadiusDemoView(name: "xs", value: radius.xs)
                    RadiusDemoView(name: "sm", value: radius.sm)
                    RadiusDemoView(name: "md", value: radius.md)
                    RadiusDemoView(name: "lg", value: radius.lg)
                    RadiusDemoView(name: "xl", value: radius.xl)
                    RadiusDemoView(name: "xxl", value: radius.xxl)
                    RadiusDemoView(name: "full", value: radius.full)
                }
            }

            SectionCard(title: "使用例") {
                CodeExample(code: """
                    @Environment(\\.radiusScale) var radius

                    RoundedRectangle(cornerRadius: radius.md)
                        .fill(.blue)
                        .frame(height: 100)
                    """)
            }
        }
    }
}

#Preview {
    NavigationStack {
        RadiusCatalogView()
            .environment(\.radiusScale, DefaultRadiusScale())
    }
}
