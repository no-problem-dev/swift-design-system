import SwiftUI

/// Primitive color tokens - 基本的な色パレット
///
/// 定義済みの色の値を提供します。**直接使用は避け**、Semantic tokens（`ColorPalette`）から参照してください。
///
/// ## ⚠️ 重要な使用方法
/// ```swift
/// // ❌ 避けるべき使い方
/// Text("Bad")
///     .foregroundColor(PrimitiveColors.blue500)
///
/// // ✅ 推奨される使い方
/// @Environment(\.colorPalette) var colors
/// Text("Good")
///     .foregroundColor(colors.primary)
/// ```
///
/// ## カスタムテーマでの参照
/// ```swift
/// struct MyBrandPalette: ColorPalette {
///     var primary: Color { PrimitiveColors.blue600 }
///     var secondary: Color { PrimitiveColors.purple500 }
///     // ...
/// }
/// ```
///
/// ## 色スケール
/// 各色は50（最も薄い）から950（最も濃い）までの11段階で定義されています。
/// - 50-200: 背景色、極めて薄い強調
/// - 300-500: アクセントカラー、標準的な強調
/// - 600-950: 濃い強調、テキスト色
public enum PrimitiveColors {
    // MARK: - Blue Scale
    public static let blue50 = Color(hex: "#EFF6FF")
    public static let blue100 = Color(hex: "#DBEAFE")
    public static let blue200 = Color(hex: "#BFDBFE")
    public static let blue300 = Color(hex: "#93C5FD")
    public static let blue400 = Color(hex: "#60A5FA")
    public static let blue500 = Color(hex: "#3B82F6")
    public static let blue600 = Color(hex: "#2563EB")
    public static let blue700 = Color(hex: "#1D4ED8")
    public static let blue800 = Color(hex: "#1E40AF")
    public static let blue900 = Color(hex: "#1E3A8A")
    public static let blue950 = Color(hex: "#172554")

    // MARK: - Gray Scale
    public static let gray50 = Color(hex: "#F9FAFB")
    public static let gray100 = Color(hex: "#F3F4F6")
    public static let gray200 = Color(hex: "#E5E7EB")
    public static let gray300 = Color(hex: "#D1D5DB")
    public static let gray400 = Color(hex: "#9CA3AF")
    public static let gray500 = Color(hex: "#6B7280")
    public static let gray600 = Color(hex: "#4B5563")
    public static let gray700 = Color(hex: "#374151")
    public static let gray800 = Color(hex: "#1F2937")
    public static let gray900 = Color(hex: "#111827")
    public static let gray950 = Color(hex: "#030712")

    // MARK: - Purple Scale
    public static let purple50 = Color(hex: "#FAF5FF")
    public static let purple100 = Color(hex: "#F3E8FF")
    public static let purple200 = Color(hex: "#E9D5FF")
    public static let purple300 = Color(hex: "#D8B4FE")
    public static let purple400 = Color(hex: "#C084FC")
    public static let purple500 = Color(hex: "#A855F7")
    public static let purple600 = Color(hex: "#9333EA")
    public static let purple700 = Color(hex: "#7E22CE")
    public static let purple800 = Color(hex: "#6B21A8")
    public static let purple900 = Color(hex: "#581C87")
    public static let purple950 = Color(hex: "#3B0764")

    // MARK: - Cyan Scale
    public static let cyan50 = Color(hex: "#ECFEFF")
    public static let cyan100 = Color(hex: "#CFFAFE")
    public static let cyan200 = Color(hex: "#A5F3FC")
    public static let cyan300 = Color(hex: "#67E8F9")
    public static let cyan400 = Color(hex: "#22D3EE")
    public static let cyan500 = Color(hex: "#06B6D4")
    public static let cyan600 = Color(hex: "#0891B2")
    public static let cyan700 = Color(hex: "#0E7490")
    public static let cyan800 = Color(hex: "#155E75")
    public static let cyan900 = Color(hex: "#164E63")
    public static let cyan950 = Color(hex: "#083344")

    // MARK: - Red Scale
    public static let red50 = Color(hex: "#FEF2F2")
    public static let red100 = Color(hex: "#FEE2E2")
    public static let red200 = Color(hex: "#FECACA")
    public static let red300 = Color(hex: "#FCA5A5")
    public static let red400 = Color(hex: "#F87171")
    public static let red500 = Color(hex: "#EF4444")
    public static let red600 = Color(hex: "#DC2626")
    public static let red700 = Color(hex: "#B91C1C")
    public static let red800 = Color(hex: "#991B1B")
    public static let red900 = Color(hex: "#7F1D1D")
    public static let red950 = Color(hex: "#450A0A")

    // MARK: - Orange Scale
    public static let orange50 = Color(hex: "#FFF7ED")
    public static let orange100 = Color(hex: "#FFEDD5")
    public static let orange200 = Color(hex: "#FED7AA")
    public static let orange300 = Color(hex: "#FDBA74")
    public static let orange400 = Color(hex: "#FB923C")
    public static let orange500 = Color(hex: "#F97316")
    public static let orange600 = Color(hex: "#EA580C")
    public static let orange700 = Color(hex: "#C2410C")
    public static let orange800 = Color(hex: "#9A3412")
    public static let orange900 = Color(hex: "#7C2D12")
    public static let orange950 = Color(hex: "#431407")

    // MARK: - Green Scale
    public static let green50 = Color(hex: "#F0FDF4")
    public static let green100 = Color(hex: "#DCFCE7")
    public static let green200 = Color(hex: "#BBF7D0")
    public static let green300 = Color(hex: "#86EFAC")
    public static let green400 = Color(hex: "#4ADE80")
    public static let green500 = Color(hex: "#10B981")
    public static let green600 = Color(hex: "#059669")
    public static let green700 = Color(hex: "#047857")
    public static let green800 = Color(hex: "#065F46")
    public static let green900 = Color(hex: "#064E3B")
    public static let green950 = Color(hex: "#022C22")

    // MARK: - Yellow Scale
    public static let yellow50 = Color(hex: "#FEFCE8")
    public static let yellow100 = Color(hex: "#FEF9C3")
    public static let yellow200 = Color(hex: "#FEF08A")
    public static let yellow300 = Color(hex: "#FDE047")
    public static let yellow400 = Color(hex: "#FACC15")
    public static let yellow500 = Color(hex: "#EAB308")
    public static let yellow600 = Color(hex: "#CA8A04")
    public static let yellow700 = Color(hex: "#A16207")
    public static let yellow800 = Color(hex: "#854D0E")
    public static let yellow900 = Color(hex: "#713F12")
    public static let yellow950 = Color(hex: "#422006")

    // MARK: - Pink Scale
    public static let pink50 = Color(hex: "#FDF2F8")
    public static let pink100 = Color(hex: "#FCE7F3")
    public static let pink200 = Color(hex: "#FBCFE8")
    public static let pink300 = Color(hex: "#F9A8D4")
    public static let pink400 = Color(hex: "#F472B6")
    public static let pink500 = Color(hex: "#EC4899")
    public static let pink600 = Color(hex: "#DB2777")
    public static let pink700 = Color(hex: "#BE185D")
    public static let pink800 = Color(hex: "#9D174D")
    public static let pink900 = Color(hex: "#831843")
    public static let pink950 = Color(hex: "#500724")

    // MARK: - Teal Scale
    public static let teal50 = Color(hex: "#F0FDFA")
    public static let teal100 = Color(hex: "#CCFBF1")
    public static let teal200 = Color(hex: "#99F6E4")
    public static let teal300 = Color(hex: "#5EEAD4")
    public static let teal400 = Color(hex: "#2DD4BF")
    public static let teal500 = Color(hex: "#14B8A6")
    public static let teal600 = Color(hex: "#0D9488")
    public static let teal700 = Color(hex: "#0F766E")
    public static let teal800 = Color(hex: "#115E59")
    public static let teal900 = Color(hex: "#134E4A")
    public static let teal950 = Color(hex: "#042F2E")

    // MARK: - Indigo Scale
    public static let indigo50 = Color(hex: "#EEF2FF")
    public static let indigo100 = Color(hex: "#E0E7FF")
    public static let indigo200 = Color(hex: "#C7D2FE")
    public static let indigo300 = Color(hex: "#A5B4FC")
    public static let indigo400 = Color(hex: "#818CF8")
    public static let indigo500 = Color(hex: "#6366F1")
    public static let indigo600 = Color(hex: "#4F46E5")
    public static let indigo700 = Color(hex: "#4338CA")
    public static let indigo800 = Color(hex: "#3730A3")
    public static let indigo900 = Color(hex: "#312E81")
    public static let indigo950 = Color(hex: "#1E1B4B")
}
