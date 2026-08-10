import SwiftUI

public extension Color {
    /// Creates a color from a hex string, for brand colors given in the form a designer hands over.
    ///
    /// The leading `#` is optional, and 3, 6, and 8 digit forms are all accepted. Anything else,
    /// including an empty or malformed string, produces opaque black rather than failing, so a
    /// typo shows up on screen instead of at the call site.
    ///
    /// - Parameter hex: The hex string, such as `"#FF5733"`, `"FF5733"`, `"#F57"`, or `"AAFF5733"`.
    ///
    /// ## Example
    /// ```swift
    /// // Six digits, the usual form
    /// let brandColor = Color(hex: "#FF5733")
    ///
    /// // The # can be left off
    /// let accentColor = Color(hex: "3B82F6")
    ///
    /// // Three digit shorthand
    /// let redColor = Color(hex: "#F00")  // same as #FF0000
    ///
    /// // Eight digits, with an alpha channel
    /// let semiTransparent = Color(hex: "80FF5733")  // 50% opacity
    /// ```
    ///
    /// ## Use in a custom palette
    /// ```swift
    /// struct MyBrandPalette: ColorPalette {
    ///     var primary: Color { Color(hex: "#007AFF") }
    ///     var secondary: Color { Color(hex: "#5856D6") }
    ///     var background: Color { .white }
    ///     // ...
    /// }
    /// ```
    ///
    /// ## Formats
    /// - **3 digits**: RGB, 4 bits per channel. `"F00"` expands to `"FF0000"`.
    /// - **6 digits**: RGB, 8 bits per channel, such as `"FF5733"`.
    /// - **8 digits**: ARGB, with alpha first, such as `"80FF5733"`.
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
