import SwiftUI

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

    // Depth between surfaces is made with color, not shadow. A shadow depicts how light falls,
    // so it vanishes in a dark room, in a screenshot, and under increased contrast settings,
    // and a card that relies on one loses its outline.
    //
    // The background sits low and surfaces are white. Reversing that (white background, gray
    // cards) inverts the depth order, so the nearer thing is the darker one. Apple's grouped
    // lists also put white surfaces on a gray background.
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
