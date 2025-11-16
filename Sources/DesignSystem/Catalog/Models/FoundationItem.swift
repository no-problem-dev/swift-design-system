import Foundation

/// デザイントークン（Foundation）のアイテム
enum FoundationItem: String, CaseIterable, Identifiable {
    case colors = "カラー"
    case typography = "タイポグラフィ"
    case spacing = "スペーシング"
    case radius = "角丸"
    case motion = "モーション"
    case imagePicker = "画像ピッカー"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .colors: return "paintpalette.fill"
        case .typography: return "textformat.size"
        case .spacing: return "arrow.left.and.right"
        case .radius: return "square.fill"
        case .motion: return "waveform.path"
        case .imagePicker: return "photo.on.rectangle.angled"
        }
    }

    var description: String {
        switch self {
        case .colors: return "カラーパレットとセマンティックカラー"
        case .typography: return "フォントサイズと行間のスケール"
        case .spacing: return "レイアウト用のスペーシングスケール"
        case .radius: return "コーナー半径のスケール"
        case .motion: return "アニメーションタイミングとモーション"
        case .imagePicker: return "カメラと写真ライブラリから画像を選択"
        }
    }
}
