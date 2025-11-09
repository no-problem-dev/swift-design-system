import SwiftUI

/// モーション仕様データモデル
struct MotionSpec: Identifiable, Sendable {
    let id: String
    let name: String
    let duration: String
    let easing: String
    let category: MotionCategory
    let usage: String
    let description: String
    let animation: @Sendable (Motion) -> Animation

    /// モーションカテゴリ
    enum MotionCategory: String, CaseIterable {
        case microInteraction = "マイクロインタラクション"
        case stateChange = "状態変化"
        case transition = "トランジション"
        case spring = "スプリング"

        var icon: String {
            switch self {
            case .microInteraction: return "hand.tap.fill"
            case .stateChange: return "arrow.triangle.2.circlepath"
            case .transition: return "arrow.left.arrow.right"
            case .spring: return "arrow.down.bounce"
            }
        }

        var description: String {
            switch self {
            case .microInteraction: return "瞬時のフィードバック用（70-110ms）"
            case .stateChange: return "UI要素の状態切り替え（150ms）"
            case .transition: return "コンテンツの移動と変化（240-375ms）"
            case .spring: return "自然な物理ベースの動き"
            }
        }
    }

    /// 全モーション仕様
    static let all: [MotionSpec] = [
        // マイクロインタラクション
        MotionSpec(
            id: "quick",
            name: "quick",
            duration: "70ms",
            easing: "Ease-out",
            category: .microInteraction,
            usage: "ホバー、カーソルフィードバック",
            description: "最速のアニメーション。マイクロインタラクション用。",
            animation: { $0.quick }
        ),
        MotionSpec(
            id: "tap",
            name: "tap",
            duration: "110ms",
            easing: "Ease-out",
            category: .microInteraction,
            usage: "ボタン押下、タップフィードバック",
            description: "タップやボタン押下への即座のフィードバック。",
            animation: { $0.tap }
        ),

        // 状態変化
        MotionSpec(
            id: "toggle",
            name: "toggle",
            duration: "150ms",
            easing: "Ease-in-out",
            category: .stateChange,
            usage: "チェックボックス、選択状態",
            description: "トグルや状態切り替えに使用。",
            animation: { $0.toggle }
        ),
        MotionSpec(
            id: "fadeIn",
            name: "fadeIn",
            duration: "150ms",
            easing: "Ease-out",
            category: .stateChange,
            usage: "新しいコンテンツの表示",
            description: "要素の出現、モーダルの表示。",
            animation: { $0.fadeIn }
        ),
        MotionSpec(
            id: "fadeOut",
            name: "fadeOut",
            duration: "150ms",
            easing: "Ease-in",
            category: .stateChange,
            usage: "コンテンツの非表示",
            description: "要素の消失、モーダルの閉じる。",
            animation: { $0.fadeOut }
        ),

        // トランジション
        MotionSpec(
            id: "slide",
            name: "slide",
            duration: "240ms",
            easing: "Ease-in-out",
            category: .transition,
            usage: "タブ切り替え、ページネーション",
            description: "コンテンツのスムーズな移動。",
            animation: { $0.slide }
        ),
        MotionSpec(
            id: "slow",
            name: "slow",
            duration: "300ms",
            easing: "Ease-in-out",
            category: .transition,
            usage: "セクション展開、テーマ切り替え",
            description: "コンテキスト変更用の遅いアニメーション。",
            animation: { $0.slow }
        ),
        MotionSpec(
            id: "slower",
            name: "slower",
            duration: "375ms",
            easing: "Ease-in-out",
            category: .transition,
            usage: "ナビゲーション遷移",
            description: "複雑なトランジション用のより遅いアニメーション。",
            animation: { $0.slower }
        ),

        // スプリング
        MotionSpec(
            id: "spring",
            name: "spring",
            duration: "Response: 0.3s",
            easing: "Damping: 0.6",
            category: .spring,
            usage: "ドラッグ&ドロップ、スクロール",
            description: "自然なスプリングアニメーション。",
            animation: { $0.spring }
        ),
        MotionSpec(
            id: "bounce",
            name: "bounce",
            duration: "Response: 0.5s",
            easing: "Damping: 0.5",
            category: .spring,
            usage: "楽しさの演出、成功フィードバック",
            description: "バウンスのあるスプリングアニメーション。",
            animation: { $0.bounce }
        )
    ]

    /// カテゴリ別にグループ化
    static func grouped() -> [MotionCategory: [MotionSpec]] {
        Dictionary(grouping: all, by: { $0.category })
    }
}
