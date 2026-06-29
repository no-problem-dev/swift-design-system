import Foundation

/// テーマのカラースキーム。アプリで使用可能なテーマの種類を定義する。
///
/// ## 使用例
/// ```swift
/// @State private var selectedScheme: ThemeColorScheme = .light
///
/// Picker("テーマ", selection: $selectedScheme) {
///     ForEach(ThemeColorScheme.allCases) { scheme in
///         Text(scheme.rawValue.capitalized).tag(scheme)
///     }
/// }
/// ```
public enum ThemeColorScheme: String, CaseIterable, Identifiable {
    /// ライトテーマ
    case light

    /// ダークテーマ
    case dark

    public var id: String { rawValue }
}
