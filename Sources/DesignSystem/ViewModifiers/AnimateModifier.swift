import SwiftUI

// MARK: - Animate Modifier

/// アニメーションモディファイア（アクセシビリティ自動対応）
///
/// 値の変化に応じてアニメーションを適用します。
/// システムの「視差効果を減らす」設定が有効な場合、自動的にアニメーションを最小化します。
///
/// ## アクセシビリティ対応
/// - WCAG 2.1 Success Criterion 2.3.3 (Animation from Interactions) に準拠
/// - `accessibilityReduceMotion` が有効な場合、アニメーションを瞬時の変化（10ms）に変更
/// - ユーザーが手動で設定を行う必要がなく、自動的に適切なアニメーションを提供
///
/// ## 使用例
/// ```swift
/// @Environment(\.motion) var motion
/// @State private var isPressed = false
///
/// Button("タップ") {
///     isPressed.toggle()
/// }
/// .scaleEffect(isPressed ? 0.98 : 1.0)
/// .animate(motion.tap, value: isPressed)
/// ```
///
/// ## Motion との組み合わせ
/// ```swift
/// // フェードイン/アウト
/// Text("メッセージ")
///     .opacity(isVisible ? 1 : 0)
///     .animate(motion.fadeIn, value: isVisible)
///
/// // スライド
/// SomeView()
///     .offset(x: selectedTab == .home ? 0 : -UIScreen.main.bounds.width)
///     .animate(motion.slide, value: selectedTab)
///
/// // スプリング
/// Circle()
///     .offset(y: isDragging ? dragOffset : 0)
///     .animate(motion.spring, value: dragOffset)
/// ```
public struct AnimateModifier<V: Equatable>: ViewModifier {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    /// 適用するアニメーション
    let animation: Animation

    /// 監視する値（この値が変化するとアニメーションが実行される）
    let value: V

    /// イニシャライザ
    /// - Parameters:
    ///   - animation: 適用するアニメーション（Motionプロトコルから取得することを推奨）
    ///   - value: 監視する値
    public init(animation: Animation, value: V) {
        self.animation = animation
        self.value = value
    }

    public func body(content: Content) -> some View {
        content.animation(
            reduceMotion ? .linear(duration: 0.01) : animation,
            value: value
        )
    }
}

// MARK: - View Extension

public extension View {
    /// アニメーションを適用（アクセシビリティ自動対応）
    ///
    /// 値の変化に応じてアニメーションを適用します。
    /// システムの「視差効果を減らす」設定が有効な場合、自動的にアニメーションを最小化します。
    ///
    /// - Parameters:
    ///   - animation: 適用するアニメーション
    ///   - value: 監視する値（この値が変化するとアニメーションが実行される）
    /// - Returns: アニメーションが適用されたビュー
    ///
    /// ## 推奨される使用方法
    /// ```swift
    /// @Environment(\.motion) var motion
    ///
    /// // ボタンの押下フィードバック
    /// Button("ボタン") { }
    ///     .scaleEffect(isPressed ? 0.98 : 1.0)
    ///     .animate(motion.tap, value: isPressed)
    ///
    /// // 状態の切り替え
    /// Toggle("設定", isOn: $isEnabled)
    ///     .foregroundColor(isEnabled ? .blue : .gray)
    ///     .animate(motion.toggle, value: isEnabled)
    /// ```
    func animate<V: Equatable>(_ animation: Animation, value: V) -> some View {
        modifier(AnimateModifier(animation: animation, value: value))
    }
}
