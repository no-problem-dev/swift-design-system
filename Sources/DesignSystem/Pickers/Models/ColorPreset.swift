import SwiftUI

/// カラーアイテム
///
/// カラーピッカーで表示される個々の色を表します。
public struct ColorItem: Identifiable, Sendable, Hashable {
    public let id: String
    public let hex: String
    public let name: String

    public init(hex: String, name: String) {
        self.id = hex
        self.hex = hex
        self.name = name
    }
}

/// カラープリセット
///
/// カラーピッカーで使用するプリセットカラーのコレクションです。
///
/// ## 使用例
/// ```swift
/// struct MyView: View {
///     @State private var selectedColor: String?
///     @State private var showColorPicker = false
///
///     var body: some View {
///         Button("色を選択") {
///             showColorPicker = true
///         }
///         .colorPicker(
///             preset: .tagFriendly,
///             selectedColor: $selectedColor,
///             isPresented: $showColorPicker
///         )
///     }
/// }
/// ```
public struct ColorPreset: Identifiable, Sendable {
    public let id: String
    public let colors: [ColorItem]

    public init(id: String, colors: [ColorItem]) {
        self.id = id
        self.colors = colors
    }

    /// タグやカテゴリ選択に適した配色セット
    ///
    /// 視認性が高く、区別しやすい10色のセットです。
    public static var tagFriendly: ColorPreset {
        ColorPreset(id: "tagFriendly", colors: [
            ColorItem(hex: "#EF4444", name: "Red"),
            ColorItem(hex: "#F97316", name: "Orange"),
            ColorItem(hex: "#EAB308", name: "Yellow"),
            ColorItem(hex: "#10B981", name: "Green"),
            ColorItem(hex: "#14B8A6", name: "Teal"),
            ColorItem(hex: "#06B6D4", name: "Cyan"),
            ColorItem(hex: "#3B82F6", name: "Blue"),
            ColorItem(hex: "#6366F1", name: "Indigo"),
            ColorItem(hex: "#A855F7", name: "Purple"),
            ColorItem(hex: "#EC4899", name: "Pink"),
        ])
    }

    /// すべてのプリミティブカラーの500番台
    ///
    /// より多くの選択肢を提供する場合に使用します。
    public static var allPrimitives: ColorPreset {
        ColorPreset(id: "allPrimitives", colors: [
            ColorItem(hex: "#6B7280", name: "Gray"),
            ColorItem(hex: "#EF4444", name: "Red"),
            ColorItem(hex: "#F97316", name: "Orange"),
            ColorItem(hex: "#EAB308", name: "Yellow"),
            ColorItem(hex: "#10B981", name: "Green"),
            ColorItem(hex: "#14B8A6", name: "Teal"),
            ColorItem(hex: "#06B6D4", name: "Cyan"),
            ColorItem(hex: "#3B82F6", name: "Blue"),
            ColorItem(hex: "#6366F1", name: "Indigo"),
            ColorItem(hex: "#A855F7", name: "Purple"),
            ColorItem(hex: "#EC4899", name: "Pink"),
        ])
    }
}
