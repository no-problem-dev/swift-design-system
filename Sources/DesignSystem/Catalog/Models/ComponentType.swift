import SwiftUI

/// コンポーネントの種類
enum ComponentType: String, CaseIterable, Identifiable {
    case button = "Button"
    case card = "Card"
    case chip = "Chip"
    case colorPicker = "ColorPicker"
    case emojiPicker = "EmojiPicker"
    case emptyState = "EmptyState"
    case fab = "FloatingActionButton"
    case iconBadge = "IconBadge"
    case iconButton = "IconButton"
    case iconPicker = "IconPicker"
    case imagePicker = "ImagePicker"
    case linkCard = "LinkCard"
    case progressBar = "ProgressBar"
    case snackbar = "Snackbar"
    case statDisplay = "StatDisplay"
    case statusIndicator = "StatusIndicator"
    case stepIndicator = "StepIndicator"
    case textField = "TextField"
    case timelineRow = "TimelineRow"
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
        case .emptyState: return "tray"
        case .fab: return "plus.circle.fill"
        case .iconBadge: return "circle.fill"
        case .iconButton: return "heart.circle.fill"
        case .iconPicker: return "square.grid.3x3"
        case .imagePicker: return "photo.on.rectangle.angled"
        case .linkCard: return "link"
        case .progressBar: return "chart.bar.fill"
        case .snackbar: return "message.fill"
        case .statDisplay: return "number.circle.fill"
        case .statusIndicator: return "checkmark.circle.fill"
        case .stepIndicator: return "ellipsis.circle"
        case .textField: return "textformat.abc"
        case .timelineRow: return "list.bullet.indent"
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
        case .emptyState: return "リストや検索結果が空のときの明示ステート"
        case .fab: return "画面上の主要アクションボタン"
        case .iconBadge: return "円形背景にアイコンを表示するバッジ"
        case .iconButton: return "アイコンのみのコンパクトなボタン"
        case .iconPicker: return "SF Symbolsアイコンを選択"
        case .imagePicker: return "カメラと写真ライブラリから画像を選択"
        case .linkCard: return "URL 参照（出典・関連リンク）のカード"
        case .progressBar: return "進捗状況を視覚的に表示するバー"
        case .snackbar: return "一時的な通知とフィードバックを表示"
        case .statDisplay: return "数値と単位を表示する統計コンポーネント"
        case .statusIndicator: return "待機・実行中・完了などの作業状態を 1 グリフで表示"
        case .stepIndicator: return "N ステップの現在位置を表すドット列"
        case .textField: return "テキスト入力フィールド"
        case .timelineRow: return "時系列フィード（アクティビティログ）の 1 行"
        case .videoPicker: return "カメラと動画ライブラリから動画を選択"
        case .videoPlayer: return "動画データやURLから動画を再生"
        }
    }
}
