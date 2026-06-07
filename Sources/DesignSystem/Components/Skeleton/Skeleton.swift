import SwiftUI

public extension View {
    /// スケルトンローディング。redacted + softLight の光帯が横切る。
    ///
    /// 実コンテンツに `.skeleton(isRedacted: isLoading)` を付けるか、
    /// プレースホルダ用の Shape 群に付けて使う。
    /// 親ビューのアニメーショントランザクションに上書きされないよう内部でガードしている。
    ///
    /// 出典: Kavsoft "SwiftUI Skeleton View - Skeleton Loading Animations" (2025-04)
    /// - Parameters:
    ///   - isRedacted: スケルトン表示中かどうか。
    ///   - tint: 光帯の色。nil ならカラースキームに応じて白/黒。
    func skeleton(isRedacted: Bool, tint: Color? = nil) -> some View {
        modifier(SkeletonModifier(isRedacted: isRedacted, tint: tint))
    }
}

struct SkeletonModifier: ViewModifier {
    var isRedacted: Bool
    var tint: Color?
    @Environment(\.colorScheme) private var scheme

    func body(content: Content) -> some View {
        content
            .redacted(reason: isRedacted ? .placeholder : [])
            .overlay {
                if isRedacted {
                    // 時刻駆動（TimelineView）: @State + withAnimation(.repeatForever) は
                    // 祖先の再描画・挿入トランジションにアニメーションを殺される脆さがある。
                    // 時刻から毎フレーム位置を導出すれば、何に再描画されても止まらない。
                    TimelineView(.animation) { timeline in
                        GeometryReader {
                            let size = $0.size
                            let skeletonWidth = size.width / 2
                            // ブラー半径は 30 以上を保証
                            let blurRadius = max(skeletonWidth / 2, 30)
                            let blurDiameter = blurRadius * 2
                            // 移動の端点
                            let minX = -(skeletonWidth + blurDiameter)
                            let maxX = size.width + skeletonWidth + blurDiameter
                            let progress = Self.easeInOut(
                                timeline.date.timeIntervalSinceReferenceDate
                                    .truncatingRemainder(dividingBy: period) / period
                            )

                            Rectangle()
                                .fill(tint ?? (scheme == .dark ? .white : .black))
                                .frame(width: skeletonWidth, height: size.height * 2)
                                .frame(height: size.height)
                                .blur(radius: blurRadius)
                                .rotationEffect(.degrees(rotation))
                                // 左 → 右へ無限に流す
                                .offset(x: minX + (maxX - minX) * progress)
                        }
                    }
                    .mask {
                        content
                            .redacted(reason: .placeholder)
                    }
                    .blendMode(.softLight)
                }
            }
    }

    var rotation: Double { 5 }
    var period: Double { 1.5 }

    /// 旧実装の .easeInOut(duration: 1.5) と同じ緩急。
    private static func easeInOut(_ t: Double) -> Double {
        t < 0.5 ? 2 * t * t : 1 - pow(-2 * t + 2, 2) / 2
    }
}

#Preview {
    VStack(alignment: .leading, spacing: 12) {
        HStack(spacing: 12) {
            Circle().frame(width: 44, height: 44)
            VStack(alignment: .leading, spacing: 6) {
                RoundedRectangle(cornerRadius: 4).frame(width: 140, height: 12)
                RoundedRectangle(cornerRadius: 4).frame(width: 90, height: 10)
            }
        }
        RoundedRectangle(cornerRadius: 12).frame(height: 120)
    }
    .foregroundStyle(.gray.opacity(0.3))
    .skeleton(isRedacted: true)
    .padding()
}
