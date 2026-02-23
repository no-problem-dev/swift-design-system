import SwiftUI

/// デザインシステムのテーマを定義するプロトコル
///
/// テーマは名前、説明、カテゴリなどのメタデータと、
/// ライト/ダークモードそれぞれのカラーパレットを提供します。
///
/// ## 使用例
/// ```swift
/// struct CustomTheme: Theme {
///     var id: String { "custom" }
///     var name: String { "カスタム" }
///     var description: String { "独自のカラーテーマ" }
///     var category: ThemeCategory { .brandPersonality }
///     var previewColors: [Color] { [.blue, .cyan, .teal] }
///
///     func colorPalette(for mode: ThemeMode) -> any ColorPalette {
///         switch mode {
///         case .system, .light:
///             CustomLightPalette()
///         case .dark:
///             CustomDarkPalette()
///         }
///     }
/// }
/// ```
public protocol Theme: Sendable, Identifiable, Equatable {
    /// テーマの一意な識別子
    var id: String { get }

    /// テーマの表示名
    var name: String { get }

    /// テーマの説明
    var description: String { get }

    /// テーマのカテゴリ
    var category: ThemeCategory { get }

    /// プレビュー用の代表色（3-5色）
    var previewColors: [Color] { get }

    /// 指定されたモードに対応するカラーパレットを返す
    /// - Parameter mode: ライトモードまたはダークモード
    /// - Returns: 対応するカラーパレット
    func colorPalette(for mode: ThemeMode) -> any ColorPalette
}

// MARK: - Equatable Default Implementation

public extension Theme {
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }
}
