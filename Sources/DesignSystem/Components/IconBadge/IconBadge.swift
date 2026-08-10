import SwiftUI

/// A circular badge with an icon (atom).
///
/// Centers an SF Symbols icon on a circular background. It covers a wide range of uses:
/// showing status, marking a category, or drawing attention to an action.
///
/// ## Example
/// ```swift
/// // A plain badge
/// IconBadge(systemName: "star.fill")
///
/// // Custom colors
/// IconBadge(
///     systemName: "heart.fill",
///     foregroundColor: .white,
///     backgroundColor: .red
/// )
///
/// // A specific size
/// IconBadge(systemName: "bell.fill", size: .large)
/// ```
public struct IconBadge: View {
    @Environment(\.colorPalette) private var colorPalette

    private let systemName: String
    private let size: IconBadgeSize
    private let foregroundColor: Color?
    private let backgroundColor: Color?

    /// Creates an icon badge.
    /// - Parameters:
    ///   - systemName: The SF Symbols name.
    ///   - size: The badge size. Defaults to `.medium`.
    ///   - foregroundColor: The icon color. Defaults to primary.
    ///   - backgroundColor: The background color of the circle. Defaults to primary at 15% opacity.
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
