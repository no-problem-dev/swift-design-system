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

    /// テーマのアイコンサイズスケール
    ///
    /// `Image(systemName:).iconSize(.sm/.md/...)` などで参照される token。
    /// デフォルト実装は ``DefaultIconSizeScale`` を返すため、特別なカスタマイズ
    /// が不要なテーマは override する必要はない。
    var iconSizeScale: any IconSizeScale { get }

    /// テーマのモーションタイミング
    ///
    /// `.animate(motion.tap, value:)` などで参照される token。
    /// デフォルト実装は ``DefaultMotion`` を返すため、特別なカスタマイズ
    /// が不要なテーマは override する必要はない。
    var motion: any Motion { get }

    /// テーマの型ランプ（タイポグラフィスケール）。
    ///
    /// `.typography(.bodyMedium)` などで参照される token を供給する。
    /// デフォルト実装は ``DefaultTypographyScale``（既存値由来）を返すため、型を
    /// カスタマイズしないテーマは override 不要で見た目も変わらない。ブランドテーマは
    /// ここを override して固有の型（サイズ・行間・書体）を差し込む。
    var typographyScale: any TypographyScale { get }

    /// テーマの余白スケール。
    ///
    /// `@Environment(\.spacingScale)` 経由でコンポーネントが参照する token。
    /// デフォルト実装は ``DefaultSpacingScale`` を返すため override 不要で見た目も不変。
    /// ブランドテーマはここを override して固有の余白（例: SmartHR の char-relative）を差し込む。
    var spacingScale: any SpacingScale { get }

    /// テーマの角丸スケール。
    ///
    /// `@Environment(\.radiusScale)` 経由でコンポーネントが参照する token。
    /// デフォルト実装は ``DefaultRadiusScale`` を返すため override 不要で見た目も不変。
    var radiusScale: any RadiusScale { get }

    /// 線幅スケール。デフォルトは ``DefaultBorderScale``。
    var borderScale: any BorderScale { get }

    /// 状態レイヤー不透明度。デフォルトは ``DefaultStateLayer``。
    var stateLayer: any StateLayer { get }

    /// 意味的グラデーション。デフォルトは ``DefaultGradientTokens``。ブランドが固有を差し込む。
    var gradients: any GradientTokens { get }

    /// 影ランプ。デフォルトは ``DefaultElevationScale``（既存 enum 由来）。
    var elevationScale: any ElevationScale { get }
}

// MARK: - Equatable Default Implementation

public extension Theme {
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }
}

// MARK: - Default Token Implementations

public extension Theme {
    var iconSizeScale: any IconSizeScale {
        DefaultIconSizeScale()
    }

    var motion: any Motion {
        DefaultMotion()
    }

    var typographyScale: any TypographyScale {
        DefaultTypographyScale()
    }

    var spacingScale: any SpacingScale {
        DefaultSpacingScale()
    }

    var radiusScale: any RadiusScale {
        DefaultRadiusScale()
    }

    var borderScale: any BorderScale {
        DefaultBorderScale()
    }

    var stateLayer: any StateLayer {
        DefaultStateLayer()
    }

    var gradients: any GradientTokens {
        DefaultGradientTokens()
    }

    var elevationScale: any ElevationScale {
        DefaultElevationScale()
    }
}
