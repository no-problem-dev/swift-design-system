import SwiftUI

/// One selectable color in a color picker.
///
/// The hex string doubles as the identity, so two items with the same hex are the same item as far
/// as the picker is concerned, whatever their names say.
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

/// The set of colors a color picker offers.
///
/// Two presets ship with the design system, and a custom one can be built from any list of colors.
///
/// ## Example
/// ```swift
/// struct MyView: View {
///     @State private var selectedColor: String?
///     @State private var showColorPicker = false
///
///     var body: some View {
///         Button("Select a color") {
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

    /// Ten colors for tags and categories, chosen to stay legible and to tell apart at a glance.
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

    /// The 500 step of every primitive color, for when the tag palette does not offer enough choice.
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
