import CoreGraphics

/// 保存する前に寸法を落とす規則。品質を下げる前に寸法を落とすのは、
/// 表示に使わない画素を運ぶのが一番無駄だから。
///
/// ## 使用例
/// ```swift
/// // アバター。240pt の円に出すなら 3x でも 720 あれば足りる
/// .imagePicker(isPresented: $show, selectedImageData: $data, resize: .square(720))
///
/// // 本文に載せる写真。長辺だけ抑えて縦横比は保つ
/// .imagePicker(isPresented: $show, selectedImageData: $data, resize: .longestEdge(2048))
/// ```
public enum ImageResizeRule: Sendable, Equatable {
    /// center-crop して 1 辺 N の正方形にする（アバター・アイコン）
    case square(CGFloat)
    /// 長辺を N に収める（アスペクト比は保つ）
    case longestEdge(CGFloat)
}

/// 規則を元の寸法にあてはめた結果。
///
/// 切り取りを「出力より大きく描いて、はみ出した分を捨てる」で表す。こうすると
/// 切り取りと縮小が 1 回の描画で済み、中間画像を作らずにいられる。
struct ImageResizePlan: Equatable {
    /// 出力のピクセル寸法
    let outputSize: CGSize
    /// 出力座標系のどこに元画像全体を描くか。origin が負なら、その分がはみ出して捨てられる
    let drawRect: CGRect
}

extension ImageResizeRule {
    /// 元のピクセル寸法から出力の計画を立てる。寸法が 0 以下なら計画を立てられないので nil。
    ///
    /// どちらの規則でも元より大きくはしない。引き伸ばしても情報は増えず、バイト数だけ増えるため。
    func plan(for source: CGSize) -> ImageResizePlan? {
        guard source.width > 0, source.height > 0 else { return nil }

        switch self {
        case .square(let side):
            // 短辺いっぱいの正方形を切り出してから、指定の 1 辺まで縮める
            let cropSide = min(source.width, source.height)
            let outputSide = max(1, min(side, cropSide).rounded())
            let scale = outputSide / cropSide
            let drawSize = CGSize(width: source.width * scale, height: source.height * scale)

            return ImageResizePlan(
                outputSize: CGSize(width: outputSide, height: outputSide),
                drawRect: CGRect(
                    x: (outputSide - drawSize.width) / 2,
                    y: (outputSide - drawSize.height) / 2,
                    width: drawSize.width,
                    height: drawSize.height
                )
            )

        case .longestEdge(let limit):
            let scale = min(1, limit / max(source.width, source.height))
            let outputSize = CGSize(
                width: max(1, (source.width * scale).rounded()),
                height: max(1, (source.height * scale).rounded())
            )

            return ImageResizePlan(
                outputSize: outputSize,
                drawRect: CGRect(origin: .zero, size: outputSize)
            )
        }
    }
}
