import SwiftUI

public extension View {
    /// Liquid Glass のサーフェス背景を敷く。カード・行・コンポーザーなどの面に使う。
    ///
    /// iOS 26 未満では ultraThinMaterial + アウトラインにフォールバックする。
    ///
    /// 注意: ScrollView 内で複数並べる用途（カルーセル・チップ行・マーキー等）には
    /// ``frostedSurface(cornerRadius:tint:)`` を使うこと。glassEffect はスクロール領域
    /// 全幅のガラス板を描くアーティファクト（行の高さぶんの「帯」）が出る。
    /// - Parameters:
    ///   - cornerRadius: 角丸半径。
    ///   - tint: ガラスに重ねるティント色。
    ///   - interactive: タッチに反応するガラスにするか。
    func glassSurface(cornerRadius: CGFloat = 16, tint: Color? = nil, interactive: Bool = false) -> some View {
        modifier(GlassSurfaceModifier(cornerRadius: cornerRadius, tint: tint, interactive: interactive))
    }

    /// スクロール領域内で並ぶ面に使う、マテリアルベースのフロストサーフェス背景。
    ///
    /// `glassEffect` は ScrollView 内に複数並ぶとスクロール領域全幅のガラス板
    /// （行の高さぶんの「帯」）を描くため、カルーセル・チップ行・マーキーなど
    /// 流れる要素はこちらを使う。見た目はガラス面と揃うよう、グラデーション
    /// ヘアラインの縁の光を持つ。
    /// - Parameters:
    ///   - cornerRadius: 角丸半径。
    ///   - tint: マテリアルに重ねるティント色。
    func frostedSurface(cornerRadius: CGFloat = 16, tint: Color? = nil) -> some View {
        modifier(FrostedSurfaceModifier(cornerRadius: cornerRadius, tint: tint))
    }
}

struct FrostedSurfaceModifier: ViewModifier {
    @Environment(\.colorScheme) private var colorScheme
    let cornerRadius: CGFloat
    let tint: Color?

    func body(content: Content) -> some View {
        let shape = RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
        content
            .background {
                shape.fill(.ultraThinMaterial)
                    .overlay {
                        if let tint { shape.fill(tint.opacity(0.08)) }
                    }
            }
            .overlay {
                shape.strokeBorder(
                    LinearGradient(
                        colors: [
                            .white.opacity(colorScheme == .light ? 0.45 : 0.35),
                            .white.opacity(0.05),
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1
                )
            }
    }
}

struct GlassSurfaceModifier: ViewModifier {
    @Environment(\.colorPalette) private var colorPalette
    let cornerRadius: CGFloat
    let tint: Color?
    let interactive: Bool

    func body(content: Content) -> some View {
        if #available(iOS 26.0, macOS 26.0, *) {
            content.glassEffect(glass, in: RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
        } else {
            content
                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
                .overlay {
                    RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                        .stroke(colorPalette.outlineVariant, lineWidth: 1)
                }
        }
    }

    @available(iOS 26.0, macOS 26.0, *)
    private var glass: Glass {
        var glass: Glass = .regular
        if let tint { glass = glass.tint(tint) }
        if interactive { glass = glass.interactive() }
        return glass
    }
}
