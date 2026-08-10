import SwiftUI

/// Holds the theme and the light/dark mode for a view hierarchy.
///
/// Create one instance near the app entry point, keep it in `@State`, and apply it with `.theme(_:)`.
/// The type is `@Observable`, so changing the theme or the mode updates every view that reads a
/// design token.
///
/// The selection lives in memory only. Nothing is written to disk, so to restore a choice on the
/// next launch, persist it and pass it back through
/// `init(initialTheme:initialMode:additionalThemes:)`.
///
/// ## Applying a theme
/// ```swift
/// @main
/// struct MyApp: App {
///     @State private var themeProvider = ThemeProvider()
///
///     var body: some Scene {
///         WindowGroup {
///             ContentView()
///                 .theme(themeProvider)
///         }
///     }
/// }
/// ```
///
/// ## Setting the mode
/// ```swift
/// // Follow the system setting (the default)
/// themeProvider.themeMode = .system
///
/// // Always light
/// themeProvider.themeMode = .light
///
/// // Always dark
/// themeProvider.themeMode = .dark
/// ```
///
/// ## Switching themes
/// ```swift
/// themeProvider.switchToTheme(id: "ocean")
/// ```
@Observable
@MainActor
public final class ThemeProvider {
    public var currentTheme: any Theme

    /// Whether the palette follows the device appearance or is pinned to light or dark.
    ///
    /// Set from `initialMode` at creation, which follows the device by default.
    public var themeMode: ThemeMode

    /// The themes this provider can switch between.
    ///
    /// Starts as the built-in themes plus anything passed to the initializer, and grows as custom
    /// themes are registered.
    public private(set) var availableThemes: [any Theme]

    /// The palette of the current theme for the current mode.
    ///
    /// This resolves the mode as stored, so while the mode follows the device this returns the
    /// light palette. Views should read the palette from the environment instead, because
    /// `.theme(_:)` resolves the device appearance before handing the palette down.
    public var colorPalette: any ColorPalette {
        currentTheme.colorPalette(for: themeMode)
    }

    /// Creates a provider with a starting theme, a starting mode, and any custom themes to register.
    ///
    /// - Parameters:
    ///   - initialTheme: The theme to start with. Defaults to the built-in default theme.
    ///   - initialMode: The mode to start in. Defaults to following the device appearance.
    ///   - additionalThemes: Custom themes to make selectable alongside the built-in ones. Themes
    ///     whose identifier is already registered are ignored.
    public init(
        initialTheme: (any Theme)? = nil,
        initialMode: ThemeMode = .system,
        additionalThemes: [any Theme] = []
    ) {
        // Start from the built-in themes
        var themes = ThemeRegistry.builtInThemes
        
        if let initialTheme {
            // Register it only when no theme already claims that identifier
            if !themes.contains(where: { $0.id == initialTheme.id }) {
                themes.append(initialTheme)
            }
        }
        
        // Append the extra themes, again skipping identifiers already present
        for theme in additionalThemes {
            if !themes.contains(where: { $0.id == theme.id }) {
                themes.append(theme)
            }
        }
        
        self.availableThemes = themes

        // Prefer the requested theme, then the built-in default, then whatever comes first
        if let initialTheme {
            self.currentTheme = initialTheme
        } else if let defaultTheme = themes.first(where: { $0.id == "default" }) {
            self.currentTheme = defaultTheme
        } else {
            self.currentTheme = themes[0]
        }

        self.themeMode = initialMode
    }

    /// Selects one of the available themes by identifier.
    ///
    /// An identifier that is not registered leaves the current theme in place and logs a warning,
    /// so a typo shows up as nothing happening rather than as a crash.
    ///
    /// - Parameter id: The identifier of the theme to select.
    ///
    /// ## Example
    /// ```swift
    /// withAnimation {
    ///     themeProvider.switchToTheme(id: "ocean")
    /// }
    /// ```
    public func switchToTheme(id: String) {
        guard let theme = availableThemes.first(where: { $0.id == id }) else {
            print("⚠️ Theme with id '\(id)' not found")
            return
        }
        currentTheme = theme
    }

    /// Applies a theme instance without requiring it to be registered first.
    ///
    /// The theme does not join `availableThemes`, so a theme list will not show it and
    /// `switchToTheme(id:)` cannot come back to it. Register it as well if it needs to be pickable.
    ///
    /// - Parameter theme: The theme to apply.
    public func applyTheme(_ theme: any Theme) {
        currentTheme = theme
    }

    /// Advances to the next mode.
    ///
    /// The cycle runs system, light, dark, and back to system. Wrap the call in `withAnimation`
    /// to cross-fade the palette.
    public func toggleMode() {
        switch themeMode {
        case .system:
            themeMode = .light
        case .light:
            themeMode = .dark
        case .dark:
            themeMode = .system
        }
    }

    /// Makes a custom theme selectable, replacing any theme that shares its identifier.
    ///
    /// Registering does not switch to the theme. Follow with `switchToTheme(id:)` to apply it.
    ///
    /// - Parameter theme: The theme to register.
    ///
    /// ## Example
    /// ```swift
    /// struct MyCustomTheme: Theme {
    ///     var id: String { "my-theme" }
    ///     // ... the rest of the conformance
    /// }
    ///
    /// themeProvider.registerTheme(MyCustomTheme())
    /// ```
    public func registerTheme(_ theme: any Theme) {
        if let index = availableThemes.firstIndex(where: { $0.id == theme.id }) {
            availableThemes[index] = theme
        } else {
            availableThemes.append(theme)
        }
    }

    /// Registers several themes, replacing any that share an identifier.
    ///
    /// - Parameter themes: The themes to register.
    public func registerThemes(_ themes: [any Theme]) {
        themes.forEach { registerTheme($0) }
    }
}
