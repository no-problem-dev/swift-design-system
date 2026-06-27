import SwiftUI

/// Floating Action Button (FAB)
///
/// 画面の主要アクションを表す円形の浮遊ボタン。
/// 通常、画面右下に配置され、最も重要な操作（作成、追加など）をトリガーします。
///
/// ## 使用例
/// ```swift
/// // 標準サイズ
/// FloatingActionButton(icon: "plus") {
///     createNewItem()
/// }
///
/// // サイズバリエーション
/// FloatingActionButton(icon: "pencil", size: .small) {
///     edit()
/// }
///
/// FloatingActionButton(icon: "photo", size: .large) {
///     addPhoto()
/// }
/// ```
///
/// ## 配置例
/// ```swift
/// ZStack {
///     ContentView()
///
///     VStack {
///         Spacer()
///         HStack {
///             Spacer()
///             FloatingActionButton(icon: "plus") {
///                 createNew()
///             }
///             .padding()
///         }
///     }
/// }
/// ```
///
/// ## サイズ
/// - **Small**: 40pt直径 - コンパクトなレイアウト
/// - **Regular**: 56pt直径 - 標準サイズ（推奨）
/// - **Large**: 96pt直径 - 特に重要なアクション
public struct FloatingActionButton: View {
    @Environment(\.colorPalette) private var colorPalette
    @Environment(\.isEnabled) private var isEnabled

    private let icon: String
    private let size: FABSize
    private let style: FABStyle
    private let action: () -> Void

    /// FloatingActionButton を作成します。
    ///
    /// - Parameters:
    ///   - icon: SF Symbols のシステムアイコン名（例: `"plus"`, `"pencil"`）
    ///   - size: ボタンサイズ（デフォルト: `.regular`、直径 56pt）
    ///   - style: 表示スタイル（デフォルト: `.primary`、テーマの Primary container 色）
    ///   - action: タップ時に呼び出されるクロージャ
    public init(
        icon: String,
        size: FABSize = .regular,
        style: FABStyle = .primary,
        action: @escaping () -> Void
    ) {
        self.icon = icon
        self.size = size
        self.style = style
        self.action = action
    }

    public var body: some View {
        Button(action: action) {
            content
        }
        .buttonStyle(.plain)
        .opacity(isEnabled ? 1 : 0.6)
    }

    private var content: some View {
        Image(systemName: icon)
            .font(.system(size: size.iconSize, weight: .semibold))
            .foregroundStyle(foregroundColor)
            .frame(width: size.diameter, height: size.diameter)
            .background(background)
            .clipShape(Circle())
            .elevation(style.elevation)
    }

    @ViewBuilder
    private var background: some View {
        switch style {
        case .primary:
            Circle()
                .fill(colorPalette.primaryContainer)
        case .secondary:
            Circle()
                .fill(colorPalette.secondaryContainer)
        case .glass:
            if #available(iOS 26.0, macOS 26.0, *) {
                Circle()
                    .fill(colorPalette.primary.opacity(0.05))
                    .glassEffect(.regular.tint(colorPalette.primary.opacity(0.18)).interactive(true), in: Circle())
            } else {
                Circle()
                    .fill(colorPalette.primary.opacity(0.06))
                    .background(.ultraThinMaterial, in: Circle())
            }
        }
    }

    private var foregroundColor: Color {
        switch style {
        case .primary:
            colorPalette.onPrimaryContainer
        case .secondary:
            colorPalette.onSecondaryContainer
        case .glass:
            colorPalette.primary
        }
    }

}

/// FABの表示スタイル。
public enum FABStyle: Sendable {
    /// テーマのPrimary containerを使う標準の主要アクション。
    case primary

    /// Secondary containerを使う補助的な浮遊アクション。
    case secondary

    /// Liquid Glass表現を使う浮遊アクション。
    case glass

    var elevation: Elevation {
        switch self {
        case .primary, .secondary:
            .level3
        case .glass:
            .level4
        }
    }
}

/// FABのサイズバリエーション
public enum FABSize {
    case small
    case regular
    case large

    var diameter: CGFloat {
        switch self {
        case .small: return 40
        case .regular: return 56
        case .large: return 96
        }
    }

    var iconSize: CGFloat {
        switch self {
        case .small: return 18
        case .regular: return 24
        case .large: return 36
        }
    }
}

struct FABPreview: View {
    @Environment(\.spacingScale) private var spacing

    var body: some View {
        VStack(spacing: spacing.xxl) {
            FloatingActionButton(icon: "plus", size: .small) {
                print("Small FAB tapped")
            }

            FloatingActionButton(icon: "plus", size: .regular) {
                print("Regular FAB tapped")
            }

            FloatingActionButton(icon: "plus", size: .large) {
                print("Large FAB tapped")
            }
        }
    }
}

#Preview {
    FABPreview()
        .theme(ThemeProvider())
}
