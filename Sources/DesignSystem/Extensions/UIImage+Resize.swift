#if canImport(UIKit)
import UIKit

/// JPEG のデフォルト品質。`maxSize` を指定しないときはここで打ち止め。
private let defaultJPEGQuality: CGFloat = 0.8

/// `maxSize` に収めるために順に試す品質。下限まで下げても収まらなければ、いちばん小さいものを返す。
private let jpegQualitySteps: [CGFloat] = [0.8, 0.7, 0.6, 0.5, 0.4, 0.3, 0.2, 0.1]

public extension UIImage {
    /// 規則に従って寸法を落とした画像を返す。
    ///
    /// 戻り値は必ず向きが `.up`、scale が 1 になる。`UIImage` は EXIF 由来の `imageOrientation` を
    /// 持っていて、`jpegData(compressionQuality:)` はそれを尊重するが、自分で描き直すときは効かない。
    /// 正規化せずに描くと、縦で撮った写真が横になる。`draw(in:)` は向きを解決して正立で描くため、
    /// 描き直すこと自体が正規化になる——だから規則が渡されたときは、縮小が要らなくても必ず描き直す。
    ///
    /// - Parameter rule: 落とし方の規則
    /// - Returns: 寸法を落として向きを正規化した画像。寸法が 0 の画像はそのまま返す
    func resized(by rule: ImageResizeRule) -> UIImage {
        // size は向きを解決したあとの寸法（縦で撮った写真なら幅と高さが入れ替わっている）。
        // これに scale を掛けたものが、見たままの向きでのピクセル数になる
        let sourcePixels = CGSize(width: size.width * scale, height: size.height * scale)
        guard let plan = rule.plan(for: sourcePixels) else { return self }

        let format = UIGraphicsImageRendererFormat.preferred()
        // ピクセルと点を一致させて、以降の寸法をピクセルのまま扱えるようにする
        format.scale = 1
        format.opaque = false

        return UIGraphicsImageRenderer(size: plan.outputSize, format: format).image { _ in
            // レンダラが出力矩形で切り落とすので、はみ出す分がそのまま center-crop になる
            draw(in: plan.drawRect)
        }
    }

    /// ピッカーが返す JPEG データを作る。
    ///
    /// 寸法 → JPEG 化 → 品質、の順で落とす。品質より先に寸法を落とすのは、表示に使わない画素を
    /// 運ぶのが一番無駄だから。寸法で削ってなお `maxSize` を超えるときだけ、品質を段階的に下げる。
    ///
    /// - Parameters:
    ///   - resize: 寸法を落とす規則。nil なら元の寸法のまま
    ///   - maxSize: 上限バイト数。nil なら品質 0.8 で 1 回変換するだけ
    /// - Returns: JPEG データ。変換できなければ nil
    func jpegData(resize: ImageResizeRule?, maxSize: ByteSize?) -> Data? {
        let source = resize.map { resized(by: $0) } ?? self

        guard let maxSize else {
            return source.jpegData(compressionQuality: defaultJPEGQuality)
        }
        return source.jpegData(fittingIn: maxSize)
    }

    /// 品質を段階的に下げて上限バイト数に収める。
    ///
    /// 下限品質でも収まらないときは、そこで得たいちばん小さいデータを返す。上限を守れないからと
    /// nil を返すと、呼び出し側は「変換できなかった」のか「大きすぎた」のか区別できないため。
    private func jpegData(fittingIn maxSize: ByteSize) -> Data? {
        var smallest: Data?

        for quality in jpegQualitySteps {
            guard let data = jpegData(compressionQuality: quality) else { return smallest }
            if data.count <= maxSize.bytes { return data }
            smallest = data
        }
        return smallest
    }
}

#endif
