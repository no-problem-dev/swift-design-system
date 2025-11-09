import SwiftUI

/// モーションタイミング定義
///
/// デザインシステム全体で一貫したアニメーションを提供する、事前定義されたタイミング設定。
/// Material Design 3、IBM Carbon Design System、Apple Human Interface Guidelinesの
/// 業界標準に基づいた、最適化されたアニメーション値を提供します。
///
/// ## 使用例
/// ```swift
/// @Environment(\.motion) var motion
///
/// Button("タップ") { }
///     .scaleEffect(isPressed ? 0.98 : 1.0)
///     .animate(motion.tap, value: isPressed)
/// ```
///
/// ## カテゴリ
/// - **マイクロインタラクション**: `quick`, `tap` - 瞬時のフィードバック（70-110ms）
/// - **状態変化**: `toggle`, `fadeIn`, `fadeOut` - UI要素の切り替え（150ms）
/// - **トランジション**: `slide`, `slow`, `slower` - コンテンツの移動（240-375ms）
/// - **スプリング**: `spring`, `bounce` - 自然な物理ベースの動き
///
/// ## アクセシビリティ
/// `.animate()` モディファイアを使用すると、視差効果を減らす設定が有効な場合に
/// 自動的にアニメーションが最小化されます（WCAG 2.1準拠）。
public protocol Motion: Sendable {
    // MARK: - Micro-interactions

    /// 最速アニメーション - マイクロインタラクション用
    ///
    /// ホバー効果、カーソルフィードバックなど、瞬時の視覚的応答に最適。
    /// - Duration: 70ms
    /// - Easing: Ease-out
    var quick: Animation { get }

    /// タップ/押下アニメーション
    ///
    /// ボタン押下、スイッチ切り替えなど、直接的なユーザー操作への即座のフィードバック。
    /// - Duration: 110ms
    /// - Easing: Ease-out
    var tap: Animation { get }

    // MARK: - State Changes

    /// トグル/状態切り替えアニメーション
    ///
    /// チェックボックス、選択状態、アクティブ/非アクティブの切り替えに使用。
    /// - Duration: 150ms
    /// - Easing: Ease-in-out
    var toggle: Animation { get }

    /// フェードイン - 要素の出現
    ///
    /// 新しいコンテンツの表示、モーダルの出現、アラートの表示に使用。
    /// - Duration: 150ms
    /// - Easing: Ease-out
    var fadeIn: Animation { get }

    /// フェードアウト - 要素の消失
    ///
    /// コンテンツの非表示、モーダルの閉じる、通知の消去に使用。
    /// - Duration: 150ms
    /// - Easing: Ease-in
    var fadeOut: Animation { get }

    // MARK: - Transitions

    /// スライド - 位置変更
    ///
    /// タブ切り替え、ページネーション、カルーセルなど、コンテンツのスムーズな移動。
    /// - Duration: 240ms
    /// - Easing: Ease-in-out
    var slide: Animation { get }

    /// 遅いアニメーション - コンテキスト変更用
    ///
    /// セクション展開、複雑なレイアウト変更、全画面トランジション。
    /// - Duration: 300ms
    /// - Easing: Ease-in-out
    var slow: Animation { get }

    /// より遅いアニメーション - 複雑なトランジション用
    ///
    /// ナビゲーション遷移、大規模なレイアウトシフト、複数要素の協調動作。
    /// - Duration: 375ms
    /// - Easing: Ease-in-out
    var slower: Animation { get }

    // MARK: - Spring Animations

    /// 自然なスプリングアニメーション
    ///
    /// ドラッグ＆ドロップのリリース、スクロール後の静止、弾性的な動き。
    /// - Response: 0.3s
    /// - Damping: 0.6 (適度な弾み)
    var spring: Animation { get }

    /// バウンスのあるスプリングアニメーション
    ///
    /// 楽しさを演出したい場面、成功フィードバック、注意を引く動作。
    /// - Response: 0.5s
    /// - Damping: 0.5 (より大きな弾み)
    var bounce: Animation { get }
}

// MARK: - Default Implementation

/// デフォルトのモーション実装
///
/// Material Design 3とIBM Carbon Design Systemの推奨値に基づいた、
/// プロダクション品質のアニメーションタイミング。
public struct DefaultMotion: Motion {
    public init() {}

    // MARK: - Micro-interactions

    public var quick: Animation {
        .easeOut(duration: 0.07)
    }

    public var tap: Animation {
        .easeOut(duration: 0.11)
    }

    // MARK: - State Changes

    public var toggle: Animation {
        .easeInOut(duration: 0.15)
    }

    public var fadeIn: Animation {
        .easeOut(duration: 0.15)
    }

    public var fadeOut: Animation {
        .easeIn(duration: 0.15)
    }

    // MARK: - Transitions

    public var slide: Animation {
        .easeInOut(duration: 0.24)
    }

    public var slow: Animation {
        .easeInOut(duration: 0.30)
    }

    public var slower: Animation {
        .easeInOut(duration: 0.375)
    }

    // MARK: - Spring Animations

    public var spring: Animation {
        .spring(response: 0.3, dampingFraction: 0.6)
    }

    public var bounce: Animation {
        .spring(response: 0.5, dampingFraction: 0.5)
    }
}
