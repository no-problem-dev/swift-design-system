import SwiftUI

/// Lightテーマのカラーパレット
public struct LightColorPalette: ColorPalette {
    public init() {}

    // MARK: - Primary
    public var primary: Color { PrimitiveColors.blue500 }
    public var onPrimary: Color { .white }

    // MARK: - Secondary
    public var secondary: Color { PrimitiveColors.purple500 }
    public var onSecondary: Color { .white }

    // MARK: - Tertiary
    public var tertiary: Color { PrimitiveColors.cyan500 }
    public var onTertiary: Color { .white }

    // MARK: - Background & Surface

    // 面の段差は色で作る。影は光の当たり方の表現なので、暗い場所・スクリーンショット・
    // コントラストを上げた設定のどれでも消え、そこに頼るとカードの輪郭がなくなる。
    //
    // 地を沈めて面を白へ置く。逆（地が白・カードが灰）にすると、手前にあるものほど
    // 暗いという上下関係の逆転が起きる。Apple のグループ化リストも地が灰で面が白。
    public var background: Color { PrimitiveColors.gray100 }
    public var onBackground: Color { PrimitiveColors.gray900 }
    public var surface: Color { .white }
    public var onSurface: Color { PrimitiveColors.gray900 }
    public var surfaceVariant: Color { PrimitiveColors.gray200 }
    public var onSurfaceVariant: Color { PrimitiveColors.gray700 }

    // MARK: - Semantic State
    public var error: Color { PrimitiveColors.red500 }
    public var warning: Color { PrimitiveColors.orange500 }
    public var success: Color { PrimitiveColors.green500 }
    public var info: Color { PrimitiveColors.blue500 }

    // MARK: - Outline
    public var outline: Color { PrimitiveColors.gray300 }

    // Container colors use default implementation from protocol extension
}
