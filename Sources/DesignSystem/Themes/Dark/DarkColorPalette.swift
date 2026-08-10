import SwiftUI

public struct DarkColorPalette: ColorPalette {
    public init() {}

    // MARK: - Primary
    public var primary: Color { PrimitiveColors.blue400 }
    public var onPrimary: Color { PrimitiveColors.gray900 }

    // MARK: - Secondary
    public var secondary: Color { PrimitiveColors.purple500 }
    public var onSecondary: Color { PrimitiveColors.gray900 }

    // MARK: - Tertiary
    public var tertiary: Color { PrimitiveColors.cyan500 }
    public var onTertiary: Color { PrimitiveColors.gray900 }

    // MARK: - Background & Surface
    public var background: Color { PrimitiveColors.gray900 }
    public var onBackground: Color { .white }
    public var surface: Color { PrimitiveColors.gray800 }
    public var onSurface: Color { .white }
    public var surfaceVariant: Color { PrimitiveColors.gray700 }
    public var onSurfaceVariant: Color { PrimitiveColors.gray300 }

    // MARK: - Semantic State
    public var error: Color { PrimitiveColors.red500 }
    public var warning: Color { PrimitiveColors.orange500 }
    public var success: Color { PrimitiveColors.green500 }
    public var info: Color { PrimitiveColors.blue400 }

    // MARK: - Outline
    public var outline: Color { PrimitiveColors.gray600 }

    // Container colors use default implementation from protocol extension
}
