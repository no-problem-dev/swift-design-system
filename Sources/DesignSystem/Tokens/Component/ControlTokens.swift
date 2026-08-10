import Foundation

/// Control dimensions and state values that do not vary by theme.
///
/// These come from fixed sources such as the Human Interface Guidelines. A value that a
/// theme needs to change belongs in a semantic scale instead.
public enum ControlTokens {
    /// The shortest edge a touch target may have (44pt, per the Human Interface Guidelines).
    ///
    /// No interactive element goes below this, including the diameter of a circular button
    /// and the height of an input bar.
    public static let minTouchTarget: CGFloat = 44

    /// The opacity of a disabled control.
    public static let disabledOpacity: Double = 0.5
}
