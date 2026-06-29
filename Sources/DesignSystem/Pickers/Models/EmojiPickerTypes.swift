import Foundation

/// 絵文字アイテム。絵文字ピッカーで表示される個々の絵文字。
public struct EmojiItem: Identifiable, Sendable, Hashable {
    public let id: String
    public let emoji: String
    public let displayName: String?

    public init(id: String, emoji: String, displayName: String? = nil) {
        self.id = id
        self.emoji = emoji
        self.displayName = displayName
    }
}

/// 絵文字のカテゴリを表すプロトコル。絵文字をグループ化するために使う。
public protocol EmojiCategoryProtocol: Identifiable, Sendable {
    var id: String { get }
    var displayName: String { get }
    var emojis: [EmojiItem] { get }
}

/// 汎用的な絵文字カテゴリ実装
///
/// ## 使用例
/// ```swift
/// let smileyCategory = EmojiCategory(
///     id: "smileys",
///     displayName: "顔・感情",
///     emojis: [
///         EmojiItem(id: "smile", emoji: "😊", displayName: "笑顔"),
///         EmojiItem(id: "laugh", emoji: "😂", displayName: "笑い"),
///     ]
/// )
///
/// struct MyView: View {
///     @State private var selectedEmoji: String?
///     @State private var showEmojiPicker = false
///     let categories = [smileyCategory, /* ... */]
///
///     var body: some View {
///         Button("絵文字を選択") {
///             showEmojiPicker = true
///         }
///         .emojiPicker(
///             categories: categories,
///             selectedEmoji: $selectedEmoji,
///             isPresented: $showEmojiPicker
///         )
///     }
/// }
/// ```
public struct EmojiCategory: EmojiCategoryProtocol {
    public let id: String
    public let displayName: String
    public let emojis: [EmojiItem]

    public init(id: String, displayName: String, emojis: [EmojiItem]) {
        self.id = id
        self.displayName = displayName
        self.emojis = emojis
    }
}
