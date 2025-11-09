import SwiftUI

/// タイポグラフィトークン
///
/// 一貫したテキストスタイリングを提供する定義済みのフォントスケール。
/// フォントサイズ、ウェイト、行間が最適化されており、`.typography()` モディファイアで簡単に適用できます。
///
/// ## 使用例
/// ```swift
/// Text("大きな見出し")
///     .typography(.headlineLarge)
///
/// Text("本文テキスト")
///     .typography(.bodyMedium)
///
/// Button("ボタンラベル") { }
///     .typography(.labelLarge)
/// ```
///
/// ## カテゴリ
/// - **Display**: 最大サイズ（57pt〜36pt）- ヒーロー、ランディングページ
/// - **Headline**: 見出し（32pt〜24pt）- セクション見出し
/// - **Title**: タイトル（22pt〜14pt）- カードタイトル、ダイアログ
/// - **Body**: 本文（16pt〜12pt）- 段落、説明文
/// - **Label**: ラベル（14pt〜11pt）- ボタン、タブ、フォーム
public enum Typography {
    // MARK: - Display

    /// Display Large - 最大かつ最も目立つテキスト
    /// サイズ: 57pt, ウェイト: Bold
    case displayLarge

    /// Display Medium
    /// サイズ: 45pt, ウェイト: Bold
    case displayMedium

    /// Display Small
    /// サイズ: 36pt, ウェイト: Bold
    case displaySmall

    // MARK: - Headline

    /// Headline Large - 大きな見出し
    /// サイズ: 32pt, ウェイト: Semibold
    case headlineLarge

    /// Headline Medium - 中程度の見出し
    /// サイズ: 28pt, ウェイト: Semibold
    case headlineMedium

    /// Headline Small - 小さな見出し
    /// サイズ: 24pt, ウェイト: Semibold
    case headlineSmall

    // MARK: - Title

    /// Title Large - 大きなタイトル
    /// サイズ: 22pt, ウェイト: Semibold
    case titleLarge

    /// Title Medium - 中程度のタイトル
    /// サイズ: 16pt, ウェイト: Semibold
    case titleMedium

    /// Title Small - 小さなタイトル
    /// サイズ: 14pt, ウェイト: Semibold
    case titleSmall

    // MARK: - Body

    /// Body Large - 大きな本文
    /// サイズ: 16pt, ウェイト: Regular
    case bodyLarge

    /// Body Medium - 標準的な本文
    /// サイズ: 14pt, ウェイト: Regular
    case bodyMedium

    /// Body Small - 小さな本文
    /// サイズ: 12pt, ウェイト: Regular
    case bodySmall

    // MARK: - Label

    /// Label Large - 大きなラベル（ボタン、タブなど）
    /// サイズ: 14pt, ウェイト: Medium
    case labelLarge

    /// Label Medium - 標準的なラベル
    /// サイズ: 12pt, ウェイト: Medium
    case labelMedium

    /// Label Small - 小さなラベル
    /// サイズ: 11pt, ウェイト: Medium
    case labelSmall

    // MARK: - Properties

    /// フォントサイズ
    public var size: CGFloat {
        switch self {
        // Display
        case .displayLarge: return PrimitiveTypography.size57
        case .displayMedium: return PrimitiveTypography.size45
        case .displaySmall: return PrimitiveTypography.size36

        // Headline
        case .headlineLarge: return PrimitiveTypography.size32
        case .headlineMedium: return PrimitiveTypography.size28
        case .headlineSmall: return PrimitiveTypography.size24

        // Title
        case .titleLarge: return PrimitiveTypography.size22
        case .titleMedium: return PrimitiveTypography.size16
        case .titleSmall: return PrimitiveTypography.size14

        // Body
        case .bodyLarge: return PrimitiveTypography.size16
        case .bodyMedium: return PrimitiveTypography.size14
        case .bodySmall: return PrimitiveTypography.size12

        // Label
        case .labelLarge: return PrimitiveTypography.size14
        case .labelMedium: return PrimitiveTypography.size12
        case .labelSmall: return PrimitiveTypography.size11
        }
    }

    /// フォントウェイト
    public var weight: Font.Weight {
        switch self {
        // Display
        case .displayLarge, .displayMedium, .displaySmall:
            return .bold

        // Headline
        case .headlineLarge, .headlineMedium, .headlineSmall:
            return .semibold

        // Title
        case .titleLarge, .titleMedium, .titleSmall:
            return .semibold

        // Body
        case .bodyLarge, .bodyMedium, .bodySmall:
            return .regular

        // Label
        case .labelLarge, .labelMedium, .labelSmall:
            return .medium
        }
    }

    /// SwiftUI Font
    /// Dynamic Type自動対応
    public var font: Font {
        .system(size: size, weight: weight, design: .default)
    }

    /// SwiftUI Font with custom design
    /// - Parameter design: フォントデザイン（.default, .serif, .rounded, .monospaced）
    /// - Returns: 指定されたデザインのフォント
    public func font(design: Font.Design) -> Font {
        .system(size: size, weight: weight, design: design)
    }

    /// 行の高さ（Line Height）
    /// Material Design 3仕様に基づく
    public var lineHeight: CGFloat {
        switch self {
        // Display
        case .displayLarge: return PrimitiveTypography.lineHeight64
        case .displayMedium: return PrimitiveTypography.lineHeight52
        case .displaySmall: return PrimitiveTypography.lineHeight44

        // Headline
        case .headlineLarge: return PrimitiveTypography.lineHeight40
        case .headlineMedium: return PrimitiveTypography.lineHeight36
        case .headlineSmall: return PrimitiveTypography.lineHeight32

        // Title
        case .titleLarge: return PrimitiveTypography.lineHeight28
        case .titleMedium: return PrimitiveTypography.lineHeight24
        case .titleSmall: return PrimitiveTypography.lineHeight20

        // Body
        case .bodyLarge: return PrimitiveTypography.lineHeight24
        case .bodyMedium: return PrimitiveTypography.lineHeight20
        case .bodySmall: return PrimitiveTypography.lineHeight16

        // Label
        case .labelLarge: return PrimitiveTypography.lineHeight20
        case .labelMedium: return PrimitiveTypography.lineHeight16
        case .labelSmall: return PrimitiveTypography.lineHeight16
        }
    }
}
