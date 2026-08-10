import Foundation

/// A light or dark appearance, with no option to follow the device.
///
/// Use it for a setting that offers exactly those two choices. A setting that also offers
/// "follow the system" needs `ThemeMode` instead, which is what `ThemeProvider` stores.
///
/// ## Example
/// ```swift
/// @State private var selectedScheme: ThemeColorScheme = .light
///
/// Picker("Theme", selection: $selectedScheme) {
///     ForEach(ThemeColorScheme.allCases) { scheme in
///         Text(scheme.rawValue.capitalized).tag(scheme)
///     }
/// }
/// ```
public enum ThemeColorScheme: String, CaseIterable, Identifiable {
    case light

    case dark

    public var id: String { rawValue }
}
