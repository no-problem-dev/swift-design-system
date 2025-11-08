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

    private let icon: String
    private let size: FABSize
    private let action: () -> Void

    public init(
        icon: String,
        size: FABSize = .regular,
        action: @escaping () -> Void
    ) {
        self.icon = icon
        self.size = size
        self.action = action
    }

    public var body: some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.system(size: size.iconSize, weight: .semibold))
                .foregroundStyle(colorPalette.onPrimaryContainer)
                .frame(width: size.diameter, height: size.diameter)
                .background(colorPalette.primaryContainer)
                .clipShape(Circle())
        }
        .elevation(.level3)
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
