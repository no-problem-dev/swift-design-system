import SwiftUI

// MARK: - Chip Style Modifier

public extension View {
    /// Sets the style for every chip in this view.
    ///
    /// ## Example
    /// ```swift
    /// Chip("Label")
    ///     .chipStyle(.filled)
    ///
    /// Chip("Filter", isSelected: $isSelected)
    ///     .chipStyle(.outlined)
    ///
    /// Chip("Premium")
    ///     .chipStyle(.liquidGlass)
    /// ```
    ///
    /// - Parameter style: The style to apply.
    func chipStyle<S: ChipStyle>(_ style: S) -> some View {
        environment(\.chipStyle, AnyChipStyle(style))
    }
}

// MARK: - Chip Size Modifier

public extension View {
    /// Sets the size for every chip in this view.
    ///
    /// ## Example
    /// ```swift
    /// Chip("Small Chip")
    ///     .chipSize(.small)
    ///
    /// Chip("Medium Chip")
    ///     .chipSize(.medium)
    /// ```
    ///
    /// - Parameter size: The size to apply.
    func chipSize(_ size: ChipSize) -> some View {
        environment(\.chipSize, size)
    }
}
