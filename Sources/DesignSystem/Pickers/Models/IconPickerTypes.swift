import Foundation

/// アイコンアイテム（SF Symbols専用）
///
/// アイコンピッカーで表示される個々のSF Symbolsアイコンを表します。
///
/// `systemName` には SF Symbols の名前を指定します（例: "star.fill", "heart.circle"）。
///
/// ## 注意
/// このピッカーはSF Symbols専用です。絵文字を使用する場合は `EmojiPicker` を使用してください。
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

/// アイコンのカテゴリを表すプロトコル
///
/// アイコンをグループ化するためのプロトコルです。
public protocol IconCategoryProtocol: Identifiable, Sendable {
    var id: String { get }
    var displayName: String { get }
    var icons: [IconItem] { get }
}

/// 汎用的なアイコンカテゴリ実装（SF Symbols専用）
///
/// ## 使用例
/// ```swift
/// let generalCategory = IconCategory(
///     id: "general",
///     displayName: "一般",
///     icons: [
///         IconItem(id: "book", systemName: "book.fill", displayName: "本"),
///         IconItem(id: "briefcase", systemName: "briefcase.fill", displayName: "ビジネス"),
///     ]
/// )
///
/// struct MyView: View {
///     @State private var selectedIcon: String?
///     @State private var showIconPicker = false
///     let categories = [generalCategory, /* ... */]
///
///     var body: some View {
///         Button("SF Symbolsを選択") {
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
