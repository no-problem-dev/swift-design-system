import SwiftUI

/// アイコン付き円形バッジ（atom）。
///
/// 円形の背景に SF Symbols アイコンを中央表示する。
/// ステータス表示・カテゴリアイコン・アクション強調など幅広い用途で使用する。
///
/// ## 使用例
/// ```swift
/// // シンプルなバッジ
/// IconBadge(systemName: "star.fill")
///
/// // カスタムカラー
/// IconBadge(
///     systemName: "heart.fill",
///     foregroundColor: .white,
///     backgroundColor: .red
/// )
///
/// // サイズ指定
/// IconBadge(systemName: "bell.fill", size: .large)
/// ```
public struct IconBadge: View {
    @Environment(\.colorPalette) private var colorPalette

    private let systemName: String
    private let size: IconBadgeSize
    private let foregroundColor: Color?
    private let backgroundColor: Color?

    /// アイコンバッジを作成する
    /// - Parameters:
    ///   - systemName: SF Symbols 名
    ///   - size: バッジサイズ（デフォルト: `.medium`）
    ///   - foregroundColor: アイコン色（デフォルト: primary）
    ///   - backgroundColor: 円の背景色（デフォルト: primary の 15% 不透明度）
    public init(
        systemName: String,
        size: IconBadgeSize = .medium,
        foregroundColor: Color? = nil,
        backgroundColor: Color? = nil
    ) {
        self.systemName = systemName
        self.size = size
        self.foregroundColor = foregroundColor
        self.backgroundColor = backgroundColor
    }

    public var body: some View {
        ZStack {
            Circle()
                .fill(backgroundColor ?? colorPalette.primary.opacity(0.15))
                .frame(width: size.circleSize, height: size.circleSize)

            Image(systemName: systemName)
                .font(.system(size: size.iconSize, weight: .medium))
                .foregroundColor(foregroundColor ?? colorPalette.primary)
        }
    }
}

/// `IconBadge` のサイズバリアント
public enum IconBadgeSize {
    case small
    case medium
    case large
    case extraLarge

    var circleSize: CGFloat {
        switch self {
        case .small: return 32
        case .medium: return 48
        case .large: return 64
        case .extraLarge: return 80
        }
    }

    var iconSize: CGFloat {
        switch self {
        case .small: return 14
        case .medium: return 20
        case .large: return 28
        case .extraLarge: return 36
        }
    }
}

#Preview("Sizes") {
    HStack(spacing: 20) {
        IconBadge(systemName: "star.fill", size: .small)
        IconBadge(systemName: "star.fill", size: .medium)
        IconBadge(systemName: "star.fill", size: .large)
        IconBadge(systemName: "star.fill", size: .extraLarge)
    }
    .padding()
    .theme(ThemeProvider())
}

#Preview("Custom Colors") {
    VStack(spacing: 20) {
        HStack(spacing: 16) {
            IconBadge(
                systemName: "flame.fill",
                foregroundColor: .orange,
                backgroundColor: .orange.opacity(0.15)
            )
            IconBadge(
                systemName: "heart.fill",
                foregroundColor: .red,
                backgroundColor: .red.opacity(0.15)
            )
            IconBadge(
                systemName: "leaf.fill",
                foregroundColor: .green,
                backgroundColor: .green.opacity(0.15)
            )
        }

        HStack(spacing: 16) {
            IconBadge(
                systemName: "dumbbell.fill",
                size: .large,
                foregroundColor: .purple,
                backgroundColor: .purple.opacity(0.15)
            )
            IconBadge(
                systemName: "figure.run",
                size: .large,
                foregroundColor: .blue,
                backgroundColor: .blue.opacity(0.15)
            )
        }
    }
    .padding()
    .theme(ThemeProvider())
}

#Preview("Various Icons") {
    LazyVGrid(columns: [GridItem(.adaptive(minimum: 60))], spacing: 16) {
        IconBadge(systemName: "bell.fill")
        IconBadge(systemName: "gear")
        IconBadge(systemName: "person.fill")
        IconBadge(systemName: "chart.bar.fill")
        IconBadge(systemName: "calendar")
        IconBadge(systemName: "clock.fill")
    }
    .padding()
    .theme(ThemeProvider())
}
