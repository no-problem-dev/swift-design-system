import Foundation

/// コンポーネントの種類
enum ComponentType: String, CaseIterable, Identifiable {
    case button = "Button"
    case card = "Card"
    case chip = "Chip"
    case colorPicker = "ColorPicker"
    case emojiPicker = "EmojiPicker"
    case fab = "FloatingActionButton"
    case iconButton = "IconButton"
    case iconPicker = "IconPicker"
    case imagePicker = "ImagePicker"
    case snackbar = "Snackbar"
    case textField = "TextField"
    case videoPicker = "VideoPicker"
    case videoPlayer = "VideoPlayer"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .button: return "hand.tap.fill"
        case .card: return "rectangle.fill"
        case .chip: return "tag.fill"
        case .colorPicker: return "paintpalette.fill"
        case .emojiPicker: return "face.smiling"
        case .fab: return "plus.circle.fill"
        case .iconButton: return "heart.circle.fill"
        case .iconPicker: return "square.grid.3x3"
        case .imagePicker: return "photo.on.rectangle.angled"
        case .snackbar: return "message.fill"
        case .textField: return "textformat.abc"
        case .videoPicker: return "video.badge.plus"
        case .videoPlayer: return "play.rectangle.fill"
        }
    }

    var description: String {
        switch self {
        case .button: return "Primary, Secondary, Tertiaryの3種類"
        case .card: return "関連情報をグループ化するコンテナ"
        case .chip: return "ステータス、カテゴリ、フィルター用のコンパクトなラベル"
        case .colorPicker: return "プリセットカラーから色を選択"
        case .emojiPicker: return "カテゴリ別の絵文字を選択"
        case .fab: return "画面上の主要アクションボタン"
        case .iconButton: return "アイコンのみのコンパクトなボタン"
        case .iconPicker: return "SF Symbolsアイコンを選択"
        case .imagePicker: return "カメラと写真ライブラリから画像を選択"
        case .snackbar: return "一時的な通知とフィードバックを表示"
        case .textField: return "テキスト入力フィールド"
        case .videoPicker: return "カメラと動画ライブラリから動画を選択"
        case .videoPlayer: return "動画データやURLから動画を再生"
        }
    }
}
