import SwiftUI

/// Chipコンポーネントのスタイルプロトコル
///
/// ChipStyleプロトコルは、Chipの視覚的なバリエーションを定義します。
/// SwiftUIのButtonStyleと同様のパターンで、再利用可能なスタイルを作成できます。
///
/// ## カスタムスタイルの作成
/// ```swift
/// struct CustomChipStyle: ChipStyle {
///     func makeBody(configuration: ChipStyleConfiguration) -> some View {
///         HStack(spacing: 4) {
///             if let icon = configuration.icon {
///                 icon
///             }
///             configuration.label
///             if let onDelete = configuration.onDelete {
///                 Button(action: onDelete) {
///                     Image(systemName: "xmark.circle.fill")
///                 }
///             }
///         }
///         .padding(.horizontal, 12)
///         .padding(.vertical, 6)
///         .background(Color.blue.opacity(0.2))
///         .cornerRadius(16)
///     }
/// }
/// ```
public protocol ChipStyle: Sendable {
    /// スタイルが生成するViewの型
    associatedtype Body: View

    /// Chipの外観を構築します
    /// - Parameter configuration: Chipの設定情報
    /// - Returns: スタイル適用後のView
    @MainActor
    func makeBody(configuration: ChipStyleConfiguration) -> Body
}

/// ChipStyleに渡される設定情報
///
/// Chipのラベル、アイコン、削除ハンドラ、選択状態などの情報を含みます。
public struct ChipStyleConfiguration {
    /// Chipのラベルテキスト
    public let label: AnyView

    /// 先頭に表示するアイコン（オプション）
    public let icon: AnyView?

    /// 削除ボタンのハンドラ（オプション）
    /// 設定されている場合、削除可能なInput Chipとして動作
    public let onDelete: (() -> Void)?

    /// 選択状態（フィルターチップなど）
    public let isSelected: Bool

    /// 押下状態（タップ時のフィードバック用）
    public let isPressed: Bool

    /// 現在のChipサイズ
    public let size: ChipSize

    /// カラーパレット
    public let colorPalette: any ColorPalette

    /// スペーシングスケール
    public let spacingScale: any SpacingScale

    /// 角丸スケール
    public let radiusScale: any RadiusScale

    /// モーションタイミング
    public let motion: any Motion
}

/// ChipStyle用のEnvironmentKey
private struct ChipStyleKey: EnvironmentKey {
    static let defaultValue: AnyChipStyle = AnyChipStyle(FilledChipStyle())
}

public extension EnvironmentValues {
    /// 環境から取得するChipStyle
    var chipStyle: AnyChipStyle {
        get { self[ChipStyleKey.self] }
        set { self[ChipStyleKey.self] = newValue }
    }
}

/// 型消去されたChipStyle
public struct AnyChipStyle: ChipStyle {
    private let _makeBody: @MainActor @Sendable (ChipStyleConfiguration) -> AnyView

    init<S: ChipStyle>(_ style: S) where S: Sendable {
        _makeBody = { @MainActor @Sendable configuration in
            AnyView(style.makeBody(configuration: configuration))
        }
    }

    @MainActor
    public func makeBody(configuration: ChipStyleConfiguration) -> some View {
        _makeBody(configuration)
    }
}
