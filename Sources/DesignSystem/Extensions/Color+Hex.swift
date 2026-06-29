import SwiftUI

public extension Color {
    /// HEX文字列からColorを作成
    ///
    /// カスタムブランドカラーやデザイナー提供の色を HEX 形式で定義できる。
    /// `#` の有無・3/6/8 桁の HEX 形式に対応する。
    ///
    /// - Parameter hex: HEX文字列（例: `"#FF5733"`, `"FF5733"`, `"#F57"`, `"AAFF5733"`）
    ///
    /// ## 使用例
    /// ```swift
    /// // 6桁HEX（最も一般的）
    /// let brandColor = Color(hex: "#FF5733")
    ///
    /// // #なしでも可
    /// let accentColor = Color(hex: "3B82F6")
    ///
    /// // 3桁短縮形式
    /// let redColor = Color(hex: "#F00")  // #FF0000と同じ
    ///
    /// // 8桁HEX（アルファチャンネル付き）
    /// let semiTransparent = Color(hex: "80FF5733")  // 50%透明度
    /// ```
    ///
    /// ## カスタムパレットでの使用
    /// ```swift
    /// struct MyBrandPalette: ColorPalette {
    ///     var primary: Color { Color(hex: "#007AFF") }
    ///     var secondary: Color { Color(hex: "#5856D6") }
    ///     var background: Color { .white }
    ///     // ...
    /// }
    /// ```
    ///
    /// ## フォーマット
    /// - **3桁**: RGB（各チャンネル4bit）- 例: `"F00"` → `"FF0000"`
    /// - **6桁**: RGB（各チャンネル8bit）- 例: `"FF5733"`
    /// - **8桁**: ARGB（アルファ+RGB）- 例: `"80FF5733"`
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
