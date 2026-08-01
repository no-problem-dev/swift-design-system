import SwiftUI

/// ``SectionRow`` の先頭に置く、アイコン列付きのラベル。
///
/// アイコンの無い行でも列のぶんを空けるため、アイコンのある行と無い行でラベルの
/// 左端が縦に揃う。列の幅・字面サイズ・行の最小高は ``SectionRowMetrics`` が
/// トークンから導出し、Dynamic Type に追随する。
///
/// ## 使用例
/// ```swift
/// SectionCard("通知") {
///     SectionRow {
///         SectionRowLabel("朝のリマインド", systemImage: "bell")
///         Spacer(minLength: 0)
///         Toggle("", isOn: $isOn).labelsHidden()
///     }
///     SectionRowDivider()
///     SectionRow {
///         SectionRowLabel("メール", subtitle: "user@example.com")
///     }
/// }
/// ```
public struct SectionRowLabel: View {
    @Environment(\.colorPalette) private var colors
    @Environment(\.iconSizeScale) private var iconSize
    @Environment(\.spacingScale) private var spacing
    @ScaledMetric(relativeTo: .body) private var typeScale: CGFloat = 1

    private let title: String
    private let systemImage: String?
    private let subtitle: String?

    /// セクション行のラベルを生成する
    /// - Parameters:
    ///   - title: 主ラベル
    ///   - systemImage: 先頭に置く SF Symbols 名。省略しても列の幅は確保される
    ///   - subtitle: タイトルの下に置く補足
    public init(_ title: String, systemImage: String? = nil, subtitle: String? = nil) {
        self.title = title
        self.systemImage = systemImage
        self.subtitle = subtitle
    }

    public var body: some View {
        let metrics = SectionRowMetrics(iconSize: iconSize, spacing: spacing, typeScale: typeScale)
        HStack(spacing: metrics.iconGap) {
            iconColumn(metrics)
            VStack(alignment: .leading, spacing: spacing.xxs) {
                Text(title)
                    .typography(.bodyLarge)
                    .foregroundStyle(colors.onSurface)
                    .multilineTextAlignment(.leading)
                if let subtitle {
                    Text(subtitle)
                        .typography(.labelSmall)
                        .foregroundStyle(colors.onSurfaceVariant)
                        .multilineTextAlignment(.leading)
                }
            }
        }
    }

    private func iconColumn(_ metrics: SectionRowMetrics) -> some View {
        Group {
            if let systemImage {
                Image(systemName: systemImage)
                    .font(.system(size: metrics.iconGlyphSize))
                    .foregroundStyle(colors.onSurface)
            } else {
                // アイコンが無い行も列を空ける。空けないと行ごとにラベルの左端が動く。
                // 高さを字面ぶんに閉じるのは、Color が縦に伸びきって行だけ高くなるため
                Color.clear.frame(height: metrics.iconGlyphSize)
            }
        }
        .frame(width: metrics.iconColumnWidth)
    }
}

#Preview("Section Row Labels") {
    @Previewable @Environment(\.spacingScale) var spacing

    ScrollView {
        VStack(spacing: spacing.xl) {
            SectionCard("アカウント", footer: "アイコンの有無でラベルの左端は動かない") {
                SectionRow { SectionRowLabel("プロフィール", systemImage: "person.crop.circle") }
                SectionRowDivider()
                SectionRow { SectionRowLabel("パスワード", systemImage: "lock") }
                SectionRowDivider()
                SectionRow { SectionRowLabel("連携サービス", systemImage: "rectangle.3.group") }
                SectionRowDivider()
                SectionRow { SectionRowLabel("メール", subtitle: "user@example.com") }
            }
        }
        .padding(spacing.lg)
    }
    .theme(ThemeProvider())
}
