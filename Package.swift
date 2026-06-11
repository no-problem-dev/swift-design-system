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
        .package(url: "https://github.com/swiftlang/swift-docc-plugin", from: "1.4.0")
    ],
    targets: [
        .target(
            name: "DesignSystem",
            dependencies: []
        ),
        // ブランドのデザイン仕様（DESIGN.md 9 セクション）の Codable モデル。
        // SwiftUI 非依存・純データ。CLI で生成/検証/差分/取り込みが可能。
        .target(
            name: "DesignSpec",
            dependencies: []
        ),
        // 「可視化して示唆を得る」計器の枠組み。ブランド横断のギャラリー・比較・
        // トークン差分・示唆注釈を提供する。各ブランドは CatalogEntry を登録する。
        .target(
            name: "DesignCatalogKit",
            dependencies: ["DesignSystem", "DesignSpec"]
        ),
        .testTarget(
            name: "DesignSystemTests",
            dependencies: ["DesignSystem"]
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
