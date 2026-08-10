import Foundation

/// One selectable emoji in an emoji picker.
///
/// The picker's search field matches against `displayName` as well as the emoji itself, so an item
/// without a display name can only be found by scrolling to it.
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

/// A named group of emoji, drawn as one section of the picker with `displayName` as its heading.
///
/// Conform an existing model to this to feed the picker without converting it first. Otherwise use
/// `EmojiCategory`.
public protocol EmojiCategoryProtocol: Identifiable, Sendable {
    var id: String { get }
    var displayName: String { get }
    var emojis: [EmojiItem] { get }
}

/// A ready-made emoji category, for when there is no existing model to conform.
///
/// ## Example
/// ```swift
/// let smileyCategory = EmojiCategory(
///     id: "smileys",
///     displayName: "Smileys & Emotion",
///     emojis: [
///         EmojiItem(id: "smile", emoji: "😊", displayName: "Smiling"),
///         EmojiItem(id: "laugh", emoji: "😂", displayName: "Laughing"),
///     ]
/// )
///
/// struct MyView: View {
///     @State private var selectedEmoji: String?
///     @State private var showEmojiPicker = false
///     let categories = [smileyCategory, /* ... */]
///
///     var body: some View {
///         Button("Select an emoji") {
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
