import SwiftUI

/// アイコンボタン
///
/// SF Symbolsアイコンを使用した円形のボタンコンポーネント。
/// コンパクトで、ツールバーやナビゲーションバーに最適です。
///
/// ## 使用例
/// ```swift
/// // 標準スタイル
/// IconButton(icon: "heart") {
///     toggleFavorite()
/// }
///
/// // 塗りつぶしスタイル
/// IconButton(icon: "star.fill", style: .filled) {
///     addToFavorites()
/// }
///
/// // サイズ指定
/// HStack {
///     IconButton(icon: "gear", size: .small) { }
///     IconButton(icon: "gear", size: .medium) { }
///     IconButton(icon: "gear", size: .large) { }
/// }
/// ```
///
/// ## スタイルバリエーション
/// - **Standard**: 背景なし、アイコンのみ
/// - **Filled**: Primary色の背景
/// - **Tonal**: SecondaryContainer色の背景
/// - **Outlined**: アウトラインのみ（背景なし）
public struct IconButton: View {
    @Environment(\.colorPalette) private var colorPalette

    private let icon: String
    private let style: IconButtonStyle
    private let size: IconButtonSize
    private let action: () -> Void

    public init(
        icon: String,
        style: IconButtonStyle = .standard,
        size: IconButtonSize = .medium,
        action: @escaping () -> Void
    ) {
        self.icon = icon
        self.style = style
        self.size = size
        self.action = action
    }

    public var body: some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.system(size: size.iconSize, weight: .regular))
                .foregroundStyle(foregroundColor)
                .frame(width: size.containerSize, height: size.containerSize)
                .background(backgroundColor)
                .clipShape(Circle())
        }
    }

    private var foregroundColor: Color {
        switch style {
        case .standard:
            return colorPalette.onSurfaceVariant
        case .filled:
            return colorPalette.onPrimary
        case .tonal:
            return colorPalette.onSecondaryContainer
        case .outlined:
            return colorPalette.onSurfaceVariant
        }
    }

    private var backgroundColor: Color {
        switch style {
        case .standard:
            return .clear
        case .filled:
            return colorPalette.primary
        case .tonal:
            return colorPalette.secondaryContainer
        case .outlined:
            return .clear
        }
    }
}

/// IconButtonのスタイル
public enum IconButtonStyle {
    /// 標準（背景なし）
    case standard
    /// 塗りつぶし（プライマリカラー背景）
    case filled
    /// トーン（セカンダリコンテナ背景）
    case tonal
    /// アウトライン（枠線のみ）
    case outlined
}

/// IconButtonのサイズ
public enum IconButtonSize {
    case small
    case medium
    case large

    var containerSize: CGFloat {
        switch self {
        case .small: return 32
        case .medium: return 40
        case .large: return 48
        }
    }

    var iconSize: CGFloat {
        switch self {
        case .small: return 16
        case .medium: return 20
        case .large: return 24
        }
    }
}

struct IconButtonPreview: View {
    @Environment(\.spacingScale) private var spacing

    var body: some View {
        VStack(spacing: spacing.xl) {
            HStack(spacing: spacing.lg) {
                IconButton(icon: "heart", style: .standard) {}
                IconButton(icon: "heart", style: .filled) {}
                IconButton(icon: "heart", style: .tonal) {}
                IconButton(icon: "heart", style: .outlined) {}
            }

            HStack(spacing: spacing.lg) {
                IconButton(icon: "star", size: .small) {}
                IconButton(icon: "star", size: .medium) {}
                IconButton(icon: "star", size: .large) {}
            }
        }
    }
}

#Preview {
    IconButtonPreview()
        .theme(ThemeProvider())
}
