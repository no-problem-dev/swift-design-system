import SwiftUI

/// Shows a number next to its unit.
///
/// Takes an already formatted number and adds an optional unit label. It suits metrics,
/// statistics, and numeric dashboards.
///
/// ## Example
/// ```swift
/// // A number with a unit
/// StatDisplay(value: "42.5", unit: "kg")
///
/// // A large, headline-sized display
/// StatDisplay(value: "1,234", unit: "steps", size: .large)
///
/// // A custom color
/// StatDisplay(
///     value: "98%",
///     unit: "complete",
///     valueColor: .green
/// )
/// ```
public struct StatDisplay: View {
    @Environment(\.colorPalette) private var colorPalette

    private let value: String
    private let unit: String?
    private let size: StatDisplaySize
    private let valueColor: Color?
    private let unitColor: Color?
    private let alignment: HorizontalAlignment

    /// Creates a numeric display.
    /// - Parameters:
    ///   - value: The already formatted number, as a string.
    ///   - unit: The unit label, which can be omitted.
    ///   - size: The display size. Defaults to `.medium`.
    ///   - valueColor: The color of the number. Defaults to onSurface.
    ///   - unitColor: The color of the unit. Defaults to onSurfaceVariant.
    ///   - alignment: The horizontal alignment. Defaults to `.leading`.
    public init(
        value: String,
        unit: String? = nil,
        size: StatDisplaySize = .medium,
        valueColor: Color? = nil,
        unitColor: Color? = nil,
        alignment: HorizontalAlignment = .leading
    ) {
        self.value = value
        self.unit = unit
        self.size = size
        self.valueColor = valueColor
        self.unitColor = unitColor
        self.alignment = alignment
    }

    public var body: some View {
        HStack(alignment: .lastTextBaseline, spacing: size.spacing) {
            Text(value)
                .font(size.valueFont)
                .fontWeight(.bold)
                .fontDesign(.rounded)
                .foregroundColor(valueColor ?? colorPalette.onSurface)

            if let unit {
                Text(unit)
                    .font(size.unitFont)
                    .fontWeight(.semibold)
                    .foregroundColor(unitColor ?? colorPalette.onSurfaceVariant)
            }

            if alignment == .leading {
                Spacer(minLength: 0)
            }
        }
        .frame(maxWidth: alignment == .center ? nil : .infinity, alignment: alignment.toAlignment)
    }
}

public enum StatDisplaySize {
    case small
    case medium
    case large
    case extraLarge

    var valueFont: Font {
        switch self {
        case .small: return .system(size: 24)
        case .medium: return .system(size: 32)
        case .large: return .system(size: 48)
        case .extraLarge: return .system(size: 64)
        }
    }

    var unitFont: Font {
        switch self {
        case .small: return .subheadline
        case .medium: return .title3
        case .large: return .title2
        case .extraLarge: return .title
        }
    }

    var spacing: CGFloat {
        switch self {
        case .small: return 4
        case .medium: return 6
        case .large: return 8
        case .extraLarge: return 10
        }
    }
}

private extension HorizontalAlignment {
    var toAlignment: Alignment {
        switch self {
        case .leading: return .leading
        case .center: return .center
        case .trailing: return .trailing
        default: return .leading
        }
    }
}

#Preview("Sizes") {
    VStack(alignment: .leading, spacing: 24) {
        StatDisplay(value: "42.5", unit: "kg", size: .small)
        StatDisplay(value: "42.5", unit: "kg", size: .medium)
        StatDisplay(value: "42.5", unit: "kg", size: .large)
        StatDisplay(value: "42.5", unit: "kg", size: .extraLarge)
    }
    .padding()
    .theme(ThemeProvider())
}

#Preview("Custom Colors") {
    VStack(alignment: .leading, spacing: 20) {
        StatDisplay(
            value: "5.43",
            unit: "kg",
            size: .large,
            valueColor: .purple
        )

        StatDisplay(
            value: "1,234",
            unit: "kcal",
            size: .large,
            valueColor: .orange
        )

        StatDisplay(
            value: "98%",
            unit: "complete",
            size: .large,
            valueColor: .green
        )
    }
    .padding()
    .theme(ThemeProvider())
}

#Preview("No Unit") {
    VStack(alignment: .leading, spacing: 16) {
        StatDisplay(value: "42")
        StatDisplay(value: "1,234,567", size: .large)
    }
    .padding()
    .theme(ThemeProvider())
}

#Preview("Alignments") {
    VStack(spacing: 16) {
        StatDisplay(value: "100", unit: "pts", alignment: .leading)
            .background(Color.gray.opacity(0.1))

        StatDisplay(value: "100", unit: "pts", alignment: .center)
            .background(Color.gray.opacity(0.1))

        StatDisplay(value: "100", unit: "pts", alignment: .trailing)
            .background(Color.gray.opacity(0.1))
    }
    .padding()
    .theme(ThemeProvider())
}
