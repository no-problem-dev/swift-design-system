import SwiftUI

/// カードコンポーネント
///
/// コンテンツをグループ化して表示するための汎用コンテナ。
/// Surface色の背景、角丸、影によって他の要素から分離されます。
///
/// ## 使用例
/// ```swift
/// @Environment(\.spacingScale) var spacing
///
/// Card {
///     VStack(alignment: .leading, spacing: spacing.md) {
///         Text("タイトル")
///             .typography(.titleMedium)
///         Text("説明文")
///             .typography(.bodyMedium)
///     }
/// }
///
/// // Elevationレベルを指定
/// Card(elevation: .level3) {
///     Text("浮き上がったカード")
/// }
/// ```
///
/// ## 使用シーン
/// - リスト項目のグループ化
/// - 情報カード
/// - ダッシュボードウィジェット
/// - 設定セクション
public struct Card<Content: View>: View {
    @Environment(\.colorPalette) private var colorPalette
    @Environment(\.spacingScale) private var spacing

    private let content: Content
    private let elevation: Elevation
    private let padding: EdgeInsets

    public init(
        elevation: Elevation = .level1,
        padding: EdgeInsets? = nil,
        @ViewBuilder content: () -> Content
    ) {
        self.elevation = elevation
        // デフォルトはspacing.lgだが、initの時点では@Environmentが使えないため、
        // nilの場合はbodyでspacing.lgを適用
        self.padding = padding ?? EdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16)
        self.content = content()
    }

    public var body: some View {
        content
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(padding)
            .background(colorPalette.surface)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .elevation(elevation)
    }
}

// MARK: - Convenience Initializers

public extension Card {
    /// パディングを個別指定（spacing tokensを使用することを推奨）
    init(
        elevation: Elevation = .level1,
        top: CGFloat,
        leading: CGFloat,
        bottom: CGFloat,
        trailing: CGFloat,
        @ViewBuilder content: () -> Content
    ) {
        self.init(
            elevation: elevation,
            padding: EdgeInsets(top: top, leading: leading, bottom: bottom, trailing: trailing),
            content: content
        )
    }

    /// 全方向同じパディング（spacing tokensを使用することを推奨）
    init(
        elevation: Elevation = .level1,
        allSides padding: CGFloat,
        @ViewBuilder content: () -> Content
    ) {
        self.init(
            elevation: elevation,
            padding: EdgeInsets(top: padding, leading: padding, bottom: padding, trailing: padding),
            content: content
        )
    }
}

struct CardPreview: View {
    @Environment(\.spacingScale) private var spacing

    var body: some View {
        VStack(spacing: spacing.lg) {
            Card {
                Text("Default Card (spacing.lg padding)")
            }

            Card(elevation: .level3) {
                VStack(alignment: .leading, spacing: spacing.sm) {
                    Text("Elevated Card")
                        .typography(.titleMedium)
                    Text("Level 3 elevation")
                        .typography(.bodySmall)
                }
            }

            Card(allSides: spacing.xl) {
                Text("Custom Padding (spacing.xl)")
            }
        }
        .padding()
    }
}

#Preview {
    CardPreview()
        .theme(ThemeProvider())
}
