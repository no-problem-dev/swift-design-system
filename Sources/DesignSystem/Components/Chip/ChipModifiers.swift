import SwiftUI

// MARK: - Chip Style Modifier

public extension View {
    /// Chip のスタイルを設定する
    ///
    /// ## 使用例
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
    /// - Parameter style: 適用するChipStyle
    /// - Returns: スタイルが適用されたView
    func chipStyle<S: ChipStyle>(_ style: S) -> some View {
        environment(\.chipStyle, AnyChipStyle(style))
    }
}

// MARK: - Chip Size Modifier

public extension View {
    /// Chip のサイズを設定する
    ///
    /// ## 使用例
    /// ```swift
    /// Chip("Small Chip")
    ///     .chipSize(.small)
    ///
    /// Chip("Medium Chip")
    ///     .chipSize(.medium)
    /// ```
    ///
    /// - Parameter size: 適用するChipSize
    /// - Returns: サイズが適用されたView
    func chipSize(_ size: ChipSize) -> some View {
        environment(\.chipSize, size)
    }
}
