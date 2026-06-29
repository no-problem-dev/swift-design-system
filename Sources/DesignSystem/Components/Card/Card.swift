import SwiftUI

/// カードコンポーネント
///
/// Elevation（影）、角丸、背景色を備えた汎用コンテナ。
/// コンテンツをグルーピングし、視覚的な階層を表現する。
///
/// 環境の ``SurfaceStyle`` に応じて描画が切り替わる:
/// - `.solid`（デフォルト）: 従来の不透明サーフェス + Elevation 影
/// - `.glass` / `.glassProminent`: Liquid Glass。背景を透かし、グラデーション
///   ボーダーで縁の光を表現。Elevation は影の濃さではなく「ボーダーの輝度」と
///   「ティント強度」に再解釈される。ネストされたカード（深度 1 以上）は
///   ガラスの重なりによる濁りを避けるため、薄いティント面へ自動降格する。
///
/// ## 使用例
/// ```swift
/// @Environment(\.spacingScale) var spacing
///
/// // 基本的な使い方
/// Card {
///     Text("デフォルトカード")
///         .typography(.bodyMedium)
/// }
///
/// // 配下のカードをすべてガラス面に（A2UI サーフェスなど動的ツリー向け）
/// A2UISurfaceView(surface)
///     .surfaceStyle(.glass)
///
/// // Elevationとスペーシングのカスタマイズ
/// Card(elevation: .level2) {
///     VStack(alignment: .leading, spacing: spacing.md) {
///         Text("カードタイトル")
///             .typography(.titleMedium)
///         Text("カードの説明文がここに入ります。")
///             .typography(.bodyMedium)
///     }
/// }
///
/// // 角丸・背景色のカスタマイズ
/// Card(elevation: .level3, cornerRadius: 20, backgroundColor: colors.primaryContainer) {
///     Text("カスタムカード")
/// }
///
/// // パディングの均一指定
/// Card(elevation: .level1, allSides: 24) {
///     Text("均一パディング")
/// }
/// ```
///
/// ## デザインガイドライン
/// - **level0〜level1**: リスト項目やフラットなカード
/// - **level2**: 標準的なカード（推奨）
/// - **level3〜level5**: 強調・モーダル的な用途
public struct Card<Content: View>: View {
    @Environment(\.colorPalette) private var colorPalette
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.radiusScale) private var radiusScale
    @Environment(\.spacingScale) private var spacingScale
    @Environment(\.surfaceStyle) private var surfaceStyle
    @Environment(\.cardNestingLevel) private var nestingLevel

    private let content: Content
    private let elevation: Elevation
    private let padding: EdgeInsets?
    private let cornerRadius: CGFloat?
    private let backgroundColor: Color?

    /// カードを作成する
    ///
    /// - Parameters:
    ///   - elevation: 影のレベル（デフォルト: `.level1`）
    ///   - padding: コンテンツの内側余白（`nil`の場合は`SpacingScale.lg`を上下左右に適用）
    ///   - cornerRadius: 角丸の半径（`nil`の場合は`RadiusScale.lg`を使用）
    ///   - backgroundColor: 背景色（`nil`の場合はElevationに応じたSurface Tokenを使用）
    ///   - content: カード内に表示するコンテンツ
    public init(
        elevation: Elevation = .level1,
        padding: EdgeInsets? = nil,
        cornerRadius: CGFloat? = nil,
        backgroundColor: Color? = nil,
        @ViewBuilder content: () -> Content
    ) {
        self.elevation = elevation
        self.padding = padding
        self.cornerRadius = cornerRadius
        self.backgroundColor = backgroundColor
        self.content = content()
    }

    public var body: some View {
        let resolvedPadding = padding ?? EdgeInsets(
            top: spacingScale.lg,
            leading: spacingScale.lg,
            bottom: spacingScale.lg,
            trailing: spacingScale.lg
        )
        // 明示的な backgroundColor 指定は常に solid 描画（呼び出し側の意図を最優先）
        let renderMode: RenderMode = if backgroundColor != nil || surfaceStyle == .solid {
            .solid
        } else if nestingLevel >= 1 {
            .nestedTint
        } else {
            .glass
        }

        styledCard(renderMode: renderMode) {
            content
                .environment(\.cardNestingLevel, nestingLevel + 1)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(resolvedPadding)
        }
    }

    /// 描画モード。surfaceStyle とネスト深度から body 冒頭で解決する。
    private enum RenderMode {
        case solid
        case glass
        case nestedTint
    }

    @ViewBuilder
    private func styledCard(renderMode: RenderMode, @ViewBuilder _ padded: () -> some View) -> some View {
        switch renderMode {
        case .solid:
            padded()
                .background {
                    solidBackground
                }
                .overlay {
                    RoundedRectangle(cornerRadius: cornerRadius ?? radiusScale.lg)
                        .stroke(colorPalette.outlineVariant, lineWidth: 1)
                }
                .clipShape(RoundedRectangle(cornerRadius: cornerRadius ?? radiusScale.lg))
                .elevation(elevation)

        case .glass:
            let shape = RoundedRectangle(cornerRadius: cornerRadius ?? radiusScale.lg, style: .continuous)
            padded()
                .background {
                    glassBackground(in: shape)
                }
                .overlay {
                    // 縁の光: 左上から差す光がボーダーを駆け抜けるグラデーション。
                    // Elevation が高いほど輝度が上がる（影の濃さの再解釈）。
                    shape.strokeBorder(glassBorderGradient, lineWidth: 1)
                }
                .clipShape(shape)
                .elevation(elevation)

        case .nestedTint:
            // ネストされたカード: ガラスの重なりは濁るため、近接グルーピングだけを
            // 担う薄いティント面に降格する（影なし・ヘアラインボーダー）
            let shape = RoundedRectangle(cornerRadius: cornerRadius ?? radiusScale.lg, style: .continuous)
            padded()
                .background {
                    shape.fill(colorPalette.onSurface.opacity(colorScheme == .dark ? 0.06 : 0.04))
                }
                .overlay {
                    shape.strokeBorder(colorPalette.outlineVariant.opacity(0.6), lineWidth: 1)
                }
                .clipShape(shape)
        }
    }

    // MARK: - Solid

    @ViewBuilder
    private var solidBackground: some View {
        let shape = RoundedRectangle(cornerRadius: cornerRadius ?? radiusScale.lg)

        if let backgroundColor {
            shape.fill(backgroundColor)
        } else {
            let baseColor = elevatedSurfaceColor
            shape
                .fill(baseColor)
                .overlay {
                    shape.fill(colorPalette.primary.opacity(elevation.surfaceTintOpacity(for: colorScheme)))
                }
        }
    }

    private var elevatedSurfaceColor: Color {
        switch elevation {
        case .level0:
            colorPalette.surface
        case .level1, .level2, .level3:
            colorPalette.elevatedSurface
        case .level4, .level5:
            colorPalette.elevatedSurfaceHigh
        }
    }

    // MARK: - Glass

    @ViewBuilder
    private func glassBackground(in shape: RoundedRectangle) -> some View {
        if #available(iOS 26.0, macOS 26.0, *) {
            Color.clear.glassEffect(glassMaterial, in: shape)
        } else {
            shape
                .fill(.ultraThinMaterial)
                .overlay {
                    if surfaceStyle == .glassProminent {
                        shape.fill(colorPalette.primary.opacity(0.06))
                    }
                }
        }
    }

    @available(iOS 26.0, macOS 26.0, *)
    private var glassMaterial: Glass {
        var glass: Glass = .regular
        if surfaceStyle == .glassProminent {
            glass = glass.tint(colorPalette.primary.opacity(0.18))
        }
        return glass
    }

    /// ガラスの縁を照らすグラデーションボーダー。
    /// Elevation level0→level5 で輝度が段階的に上がる。
    private var glassBorderGradient: LinearGradient {
        let highlight = glassBorderHighlightOpacity
        return LinearGradient(
            colors: [
                .white.opacity(highlight),
                .white.opacity(highlight * 0.12),
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    private var glassBorderHighlightOpacity: Double {
        let base: Double = switch elevation {
        case .level0: 0.22
        case .level1: 0.32
        case .level2: 0.40
        case .level3: 0.48
        case .level4: 0.56
        case .level5: 0.64
        }
        let prominentBoost: Double = surfaceStyle == .glassProminent ? 0.12 : 0
        // ライトモードでは白ボーダーが沈むため少し持ち上げる
        let schemeBoost: Double = colorScheme == .light ? 0.08 : 0
        return min(base + prominentBoost + schemeBoost, 0.85)
    }
}

public extension Card {
    /// 均一なパディングでカードを作成する
    ///
    /// - Parameters:
    ///   - elevation: 影のレベル（デフォルト: `.level1`）
    ///   - padding: 上下左右に均一に適用するパディング値
    ///   - cornerRadius: 角丸の半径（`nil`の場合は`RadiusScale.lg`を使用）
    ///   - backgroundColor: 背景色（`nil`の場合はElevationに応じたSurface Tokenを使用）
    ///   - content: カード内に表示するコンテンツ
    init(
        elevation: Elevation = .level1,
        allSides padding: CGFloat,
        cornerRadius: CGFloat? = nil,
        backgroundColor: Color? = nil,
        @ViewBuilder content: () -> Content
    ) {
        self.init(
            elevation: elevation,
            padding: EdgeInsets(top: padding, leading: padding, bottom: padding, trailing: padding),
            cornerRadius: cornerRadius,
            backgroundColor: backgroundColor,
            content: content
        )
    }
}

#Preview("Solid") {
    VStack(spacing: 16) {
        Card {
            Text("Default Card")
        }
        Card(elevation: .level3, cornerRadius: 20) {
            Text("Custom Corner Radius")
        }
    }
    .padding()
    .theme(ThemeProvider())
}

#Preview("Glass") {
    ZStack {
        LinearGradient(
            colors: [.purple, .blue, .cyan],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()

        VStack(spacing: 16) {
            Card(elevation: .level2) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Glass Card")
                    // ネストカードはティント面へ自動降格する
                    Card(elevation: .level1) {
                        Text("Nested Card（自動降格）")
                    }
                }
            }
            Card(elevation: .level3, cornerRadius: 24) {
                Text("Prominent Glass")
            }
            .surfaceStyle(.glassProminent)
        }
        .padding()
        .surfaceStyle(.glass)
    }
    .theme(ThemeProvider())
}
