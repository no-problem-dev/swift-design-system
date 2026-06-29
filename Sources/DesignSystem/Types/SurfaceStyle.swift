import SwiftUI

/// サーフェス（カードなどの「面」コンポーネント）の描画スタイル。
///
/// `Card` をはじめとする面コンポーネントが、不透明なサーフェスとして描画するか、
/// 背景を透かす Liquid Glass として描画するかを Environment 経由で切り替える。
/// 動的に生成される UI ツリー（例: A2UI レンダリング）に対して、レンダラーへ手を
/// 入れずにアプリのデザイン言語を注入する仕組み。
///
/// ## 使用例
/// ```swift
/// // 配下の Card がすべてガラス面になる
/// A2UISurfaceView(surface)
///     .surfaceStyle(.glass)
/// ```
///
/// ## ネストの自動降格
/// ガラスは重ねると濁って可読性を損なうため、`Card` はネスト深度を自動追跡し、
/// 深度 1 以上のカードを「薄いティント面」へ自動降格する。近接性による
/// グルーピングは保ちつつ、ガラスの透明感はトップレベルにのみ与える。
public enum SurfaceStyle: Sendable, Equatable {
    /// 不透明なサーフェス（Elevation トークンに基づく従来描画）
    case solid
    /// Liquid Glass。背景を透かし、グラデーションボーダーで縁の光を表現する
    case glass
    /// 強調ガラス。primary ティントとより明るいボーダーで主役の面を演出する
    case glassProminent
}

// MARK: - Environment

private struct SurfaceStyleKey: EnvironmentKey {
    static let defaultValue: SurfaceStyle = .solid
}

private struct CardNestingLevelKey: EnvironmentKey {
    static let defaultValue: Int = 0
}

extension EnvironmentValues {
    /// 面コンポーネントの描画スタイル。デフォルトは `.solid`（従来描画）。
    public var surfaceStyle: SurfaceStyle {
        get { self[SurfaceStyleKey.self] }
        set { self[SurfaceStyleKey.self] = newValue }
    }

    /// カードのネスト深度。`Card` がコンテンツへ自動的に +1 して伝播する。
    /// glass スタイル時、深度 1 以上のカードはティント面へ自動降格する。
    public var cardNestingLevel: Int {
        get { self[CardNestingLevelKey.self] }
        set { self[CardNestingLevelKey.self] = newValue }
    }
}

public extension View {
    /// 配下の面コンポーネント（``Card`` など）の描画スタイルを切り替える。
    ///
    /// - Parameter style: 適用する ``SurfaceStyle``
    func surfaceStyle(_ style: SurfaceStyle) -> some View {
        environment(\.surfaceStyle, style)
    }
}
