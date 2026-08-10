// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "DesignSystem",
    platforms: [
        .iOS(.v17),
        .macOS(.v14)
    ],
    products: [
        .library(
            name: "DesignSystem",
            targets: ["DesignSystem"]
        ),
        .library(
            name: "DesignSpec",
            targets: ["DesignSpec"]
        ),
        .library(
            name: "DesignCatalogKit",
            targets: ["DesignCatalogKit"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/swiftlang/swift-docc-plugin", from: "1.4.0"),
        .package(url: "https://github.com/no-problem-dev/swift-visual-testing.git", from: "2.0.0"),
    ],
    targets: [
        .target(
            name: "DesignSystem",
            dependencies: []
        ),
        // A Codable model of a brand's design specification (the nine DESIGN.md sections).
        // Pure data with no SwiftUI dependency, so a CLI can generate, validate, diff, and import it.
        .target(
            name: "DesignSpec",
            dependencies: []
        ),
        // Instrumentation for seeing what differs between brands: cross-brand galleries,
        // side-by-side comparison, token diffing, and annotations. Each brand registers a CatalogEntry.
        .target(
            name: "DesignCatalogKit",
            dependencies: ["DesignSystem", "DesignSpec"]
        ),
        .testTarget(
            name: "DesignSystemTests",
            dependencies: [
                "DesignSystem",
                .product(name: "VisualTesting", package: "swift-visual-testing"),
            ]
        ),
        .testTarget(
            name: "DesignSpecTests",
            dependencies: ["DesignSpec"]
        ),
        .testTarget(
            name: "DesignCatalogKitTests",
            dependencies: ["DesignCatalogKit"]
        ),
    ]
)
