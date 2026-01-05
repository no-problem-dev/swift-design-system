import SwiftUI

/// モーションデモカード
///
/// 各モーションの動きを実際に体験できるインタラクティブなカード
struct MotionDemoCard: View {
    @Environment(\.colorPalette) private var colors
    @Environment(\.spacingScale) private var spacing
    @Environment(\.radiusScale) private var radius

    let spec: MotionSpec
    @State private var isAnimating = false

    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading, spacing: 0) {
                // ヘッダー
                HStack {
                    VStack(alignment: .leading, spacing: spacing.xs) {
                        Text(spec.name)
                            .typography(.titleSmall)
                            .foregroundStyle(colors.onSurface)

                        Text(spec.usage)
                            .typography(.bodySmall)
                            .foregroundStyle(colors.onSurfaceVariant)
                            .lineLimit(2)
                            .minimumScaleFactor(0.9)
                    }

                    Spacer()

                    // 仕様表示
                    VStack(alignment: .trailing, spacing: spacing.xs) {
                        Text(spec.duration)
                            .typography(.labelSmall)
                            .foregroundStyle(colors.primary)

                        Text(spec.easing)
                            .typography(.labelSmall)
                            .foregroundStyle(colors.onSurfaceVariant)
                    }
                }
                .padding(spacing.md)

                // デモエリア - 利用可能な空間を計算
                let buttonHeight: CGFloat = 40
                let headerHeight: CGFloat = 60
                let totalPadding: CGFloat = spacing.md * 2
                let availableHeight = geometry.size.height - headerHeight - buttonHeight - totalPadding

                demoArea
                    .frame(height: max(availableHeight, 60))
                    .background(colors.surfaceVariant.opacity(0.5))
                    .clipShape(RoundedRectangle(cornerRadius: radius.md))
                    .padding(.horizontal, spacing.md)

                Spacer(minLength: 0)

                // トリガーボタン
                Button(action: {
                    isAnimating.toggle()
                }) {
                    HStack {
                        Image(systemName: "play.fill")
                        Text("アニメーション実行")
                    }
                    .typography(.labelMedium)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, spacing.sm)
                    .background(colors.primary)
                    .foregroundStyle(colors.onPrimary)
                    .clipShape(RoundedRectangle(cornerRadius: radius.sm))
                }
                .buttonStyle(.plain)
                .padding(spacing.md)
            }
            .background(colors.surface)
            .clipShape(RoundedRectangle(cornerRadius: radius.lg))
            .elevation(.level1)
        }
    }

    // MARK: - Demo Area

    @ViewBuilder
    private var demoArea: some View {
        switch spec.category {
        case .microInteraction, .stateChange:
            buttonPressDemo
        case .transition:
            slideDemo
        case .spring:
            springDemo
        }
    }

    // ボタン押下デモ
    private var buttonPressDemo: some View {
        HStack {
            Spacer()
            Circle()
                .fill(colors.primary)
                .frame(width: 60, height: 60)
                .scaleEffect(isAnimating ? 0.85 : 1.0)
                .opacity(isAnimating ? 0.7 : 1.0)
                .animate(spec.animation(DefaultMotion()), value: isAnimating)
            Spacer()
        }
    }

    // スライドデモ
    private var slideDemo: some View {
        GeometryReader { geometry in
            let cardWidth: CGFloat = 60
            let cardHeight: CGFloat = 80
            let totalCards = 3
            let cardSpacing = spacing.md
            let totalWidth = CGFloat(totalCards) * cardWidth + CGFloat(totalCards - 1) * cardSpacing
            let centerOffsetX = (geometry.size.width - totalWidth) / 2
            let centerOffsetY = (geometry.size.height - cardHeight) / 2

            ZStack(alignment: .topLeading) {
                ForEach(0..<totalCards, id: \.self) { index in
                    RoundedRectangle(cornerRadius: radius.sm)
                        .fill(colors.primary.opacity(isAnimating && index == 1 ? 1.0 : 0.3))
                        .frame(width: cardWidth, height: cardHeight)
                        .offset(
                            x: centerOffsetX + CGFloat(index) * (cardWidth + cardSpacing) + (isAnimating ? CGFloat(index - 1) * 20 : 0),
                            y: centerOffsetY
                        )
                        .animate(spec.animation(DefaultMotion()), value: isAnimating)
                }
            }
        }
    }

    // スプリングデモ
    private var springDemo: some View {
        VStack {
            Circle()
                .fill(colors.primary)
                .frame(width: 50, height: 50)
                .offset(y: isAnimating ? 30 : -30)
                .animate(spec.animation(DefaultMotion()), value: isAnimating)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    VStack(spacing: 16) {
        MotionDemoCard(spec: MotionSpec.all[0])
        MotionDemoCard(spec: MotionSpec.all[1])
    }
    .padding()
    .background(Color(hex: "#F5F5F5"))
    .theme(ThemeProvider())
}
