import Foundation

/// One selectable symbol in an icon picker.
///
/// `systemName` is an SF Symbols name such as "star.fill" or "heart.circle". The picker's search
/// field matches against both that name and `displayName`.
///
/// ## Note
/// This picker only handles SF Symbols. Use the emoji picker for emoji.
public struct IconItem: Identifiable, Sendable, Hashable {
    public let id: String
    public let systemName: String
    public let displayName: String?

    public init(id: String, systemName: String, displayName: String? = nil) {
        self.id = id
        self.systemName = systemName
        self.displayName = displayName
    }
}

/// A named group of icons, drawn as one section of the picker with `displayName` as its heading.
///
/// Conform an existing model to this to feed the picker without converting it first. Otherwise use
/// `IconCategory`.
public protocol IconCategoryProtocol: Identifiable, Sendable {
    var id: String { get }
    var displayName: String { get }
    var icons: [IconItem] { get }
}

/// A ready-made icon category, for when there is no existing model to conform.
///
/// ## Example
/// ```swift
/// let generalCategory = IconCategory(
///     id: "general",
///     displayName: "General",
///     icons: [
///         IconItem(id: "book", systemName: "book.fill", displayName: "Book"),
///         IconItem(id: "briefcase", systemName: "briefcase.fill", displayName: "Business"),
///     ]
/// )
///
/// struct MyView: View {
///     @State private var selectedIcon: String?
///     @State private var showIconPicker = false
///     let categories = [generalCategory, /* ... */]
///
///     var body: some View {
///         Button("Select a symbol") {
///             showIconPicker = true
///         }
///         .iconPicker(
///             categories: categories,
///             selectedIcon: $selectedIcon,
///             isPresented: $showIconPicker
///         )
///     }
/// }
/// ```
public struct IconCategory: IconCategoryProtocol {
    public let id: String
    public let displayName: String
    public let icons: [IconItem]

    public init(id: String, displayName: String, icons: [IconItem]) {
        self.id = id
        self.displayName = displayName
        self.icons = icons
    }
}
