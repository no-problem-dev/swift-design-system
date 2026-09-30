import XCTest
import SwiftUI
@testable import DesignSystem

/// `.theme(_:)` の外（ウィジェット・Live Activity・プレビュー）で読む既定のパレット。
///
/// 4.x は `LightColorPalette` 固定で、ダークのウィジェットでは暗い背景に暗い文字が載った。
final class DefaultColorPaletteTests: XCTestCase {

    func testFollowsLightColorScheme() {
        var env = EnvironmentValues()
        env.colorScheme = .light
        XCTAssertTrue(env.colorPalette is LightColorPalette)
    }

    func testFollowsDarkColorScheme() {
        var env = EnvironmentValues()
        env.colorScheme = .dark
        XCTAssertTrue(env.colorPalette is DarkColorPalette)
    }

    /// 置かれたパレットは明暗より優先する（`.theme(_:)` が解決した結果を上書きしない）。
    func testExplicitPaletteWinsOverColorScheme() {
        var env = EnvironmentValues()
        env.colorPalette = OceanLightPalette()
        env.colorScheme = .dark
        XCTAssertTrue(env.colorPalette is OceanLightPalette)
    }
}
