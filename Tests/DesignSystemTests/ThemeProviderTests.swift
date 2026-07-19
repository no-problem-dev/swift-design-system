import XCTest
import SwiftUI
@testable import DesignSystem

@MainActor
final class ThemeProviderTests: XCTestCase {

    // MARK: - Helpers

    private func rgb(_ color: Color) -> (red: Double, green: Double, blue: Double) {
        let resolved = color.resolve(in: EnvironmentValues())
        return (Double(resolved.red), Double(resolved.green), Double(resolved.blue))
    }

    private func assertSameColor(
        _ lhs: Color, _ rhs: Color, _ label: String,
        file: StaticString = #filePath, line: UInt = #line
    ) {
        let a = rgb(lhs), b = rgb(rhs)
        XCTAssertEqual(a.red, b.red, accuracy: 0.002, "\(label).red", file: file, line: line)
        XCTAssertEqual(a.green, b.green, accuracy: 0.002, "\(label).green", file: file, line: line)
        XCTAssertEqual(a.blue, b.blue, accuracy: 0.002, "\(label).blue", file: file, line: line)
    }

    private func assertColorsDiffer(
        _ lhs: Color, _ rhs: Color, _ label: String,
        file: StaticString = #filePath, line: UInt = #line
    ) {
        let a = rgb(lhs), b = rgb(rhs)
        let delta = abs(a.red - b.red) + abs(a.green - b.green) + abs(a.blue - b.blue)
        XCTAssertGreaterThan(delta, 0.01, "\(label) が同一色になっている", file: file, line: line)
    }

    /// ThemeRegistry が提供するビルトインテーマの ID（ThemeRegistry.builtInThemes の順）
    private let builtInIDs = [
        "default", "ocean", "forest", "sunset", "purple-haze", "monochrome", "high-contrast",
    ]

    // MARK: - 初期化

    func testDefaultInitializationExposesEveryBuiltInTheme() {
        let provider = ThemeProvider()

        XCTAssertEqual(provider.themeMode, .system)
        XCTAssertEqual(provider.currentTheme.id, "default")
        XCTAssertEqual(provider.availableThemes.count, 7)
        XCTAssertEqual(provider.availableThemes.map(\.id), builtInIDs)
    }

    func testInitializationWithMode() {
        let provider = ThemeProvider(initialMode: .dark)
        XCTAssertEqual(provider.themeMode, .dark)
    }

    func testInitialThemeWithNewIDIsAppendedAndSelected() {
        let provider = ThemeProvider(initialTheme: CustomTheme(name: "Custom"))

        XCTAssertEqual(provider.currentTheme.id, "custom")
        XCTAssertEqual(provider.availableThemes.count, 8)
        XCTAssertEqual(provider.availableThemes.last?.id, "custom")
    }

    func testInitialThemeWithBuiltInIDIsNotDuplicated() {
        let provider = ThemeProvider(initialTheme: OceanTheme())

        XCTAssertEqual(provider.availableThemes.count, 7)
        XCTAssertEqual(provider.currentTheme.id, "ocean")
    }

    // MARK: - モード

    func testToggleModeCyclesSystemLightDark() {
        let provider = ThemeProvider(initialMode: .system)

        provider.toggleMode()
        XCTAssertEqual(provider.themeMode, .light)

        provider.toggleMode()
        XCTAssertEqual(provider.themeMode, .dark)

        provider.toggleMode()
        XCTAssertEqual(provider.themeMode, .system)
    }

    // MARK: - テーマ切り替え

    func testSwitchToThemeByLiteralIDChangesResolvedPalette() {
        let provider = ThemeProvider()
        let defaultPrimary = provider.colorPalette.primary

        provider.switchToTheme(id: "ocean")

        XCTAssertEqual(provider.currentTheme.id, "ocean")
        // ID だけでなく解決されるパレットまで実際に入れ替わる
        assertColorsDiffer(provider.colorPalette.primary, defaultPrimary, "primary")
        assertSameColor(provider.colorPalette.primary, OceanTheme().colorPalette(for: .system).primary, "ocean primary")
    }

    func testSwitchToUnknownThemeIsNoOp() {
        let provider = ThemeProvider()
        let before = provider.currentTheme.id

        provider.switchToTheme(id: "nonexistent-theme")
        XCTAssertEqual(provider.currentTheme.id, before)
        assertSameColor(provider.colorPalette.primary, LightColorPalette().primary, "primary")
    }

    func testApplyThemeSetsCurrentThemeAndPalette() {
        let provider = ThemeProvider()

        provider.applyTheme(HighContrastTheme())

        XCTAssertEqual(provider.currentTheme.id, "high-contrast")
        assertSameColor(
            provider.colorPalette.primary,
            HighContrastTheme().colorPalette(for: .system).primary,
            "high-contrast primary"
        )
    }

    // MARK: - パレット解決

    func testLightAndDarkModesResolveToTheirOwnPalettes() {
        let light = ThemeProvider(initialMode: .light)
        let dark = ThemeProvider(initialMode: .dark)

        assertSameColor(light.colorPalette.primary, LightColorPalette().primary, "light primary")
        assertSameColor(dark.colorPalette.primary, DarkColorPalette().primary, "dark primary")
        assertColorsDiffer(light.colorPalette.primary, dark.colorPalette.primary, "primary")
        assertColorsDiffer(light.colorPalette.background, dark.colorPalette.background, "background")
    }

    func testSystemModeResolvesToTheLightPalette() {
        // .system は既定モード。DefaultTheme は .system と .light を同じ分岐で扱う
        let provider = ThemeProvider()
        XCTAssertEqual(provider.themeMode, .system)

        assertSameColor(provider.colorPalette.primary, LightColorPalette().primary, "system primary")
        assertSameColor(provider.colorPalette.background, LightColorPalette().background, "system background")
        assertColorsDiffer(provider.colorPalette.background, DarkColorPalette().background, "background")
    }

    func testChangingModeReresolvesThePaletteOfTheCurrentTheme() {
        let provider = ThemeProvider(initialMode: .light)
        provider.switchToTheme(id: "high-contrast")
        let lightPrimary = provider.colorPalette.primary

        provider.themeMode = .dark

        assertColorsDiffer(provider.colorPalette.primary, lightPrimary, "high-contrast primary")
        assertSameColor(
            provider.colorPalette.primary,
            HighContrastTheme().colorPalette(for: .dark).primary,
            "high-contrast dark primary"
        )
    }

    // MARK: - 登録

    func testRegisterExistingIDReplacesTheThemeInPlace() {
        let provider = ThemeProvider(initialTheme: CustomTheme(name: "Custom"))
        let countBefore = provider.availableThemes.count
        guard let index = provider.availableThemes.firstIndex(where: { $0.id == "custom" }) else {
            return XCTFail("custom テーマが登録されていない")
        }

        // 同じ ID・違う内容で再登録すると、追加ではなく置換になる
        provider.registerTheme(CustomTheme(name: "Custom Updated"))

        XCTAssertEqual(provider.availableThemes.count, countBefore)
        XCTAssertEqual(provider.availableThemes[index].id, "custom")
        XCTAssertEqual(provider.availableThemes[index].name, "Custom Updated")
    }

    func testRegisterNewIDAppends() {
        let provider = ThemeProvider()

        provider.registerTheme(CustomTheme(name: "Custom"))

        XCTAssertEqual(provider.availableThemes.count, 8)
        XCTAssertEqual(provider.availableThemes.last?.id, "custom")
    }

    func testRegisterThemesAppliesEachRegistration() {
        let provider = ThemeProvider()

        provider.registerThemes([CustomTheme(name: "Custom"), CustomTheme(id: "custom-2", name: "Custom 2")])
        XCTAssertEqual(provider.availableThemes.count, 9)

        // 2 回目は片方が置換になるので総数は増えない
        provider.registerThemes([CustomTheme(name: "Custom Again")])
        XCTAssertEqual(provider.availableThemes.count, 9)
        XCTAssertEqual(provider.availableThemes.first { $0.id == "custom" }?.name, "Custom Again")
    }
}

// MARK: - Fixtures

private struct CustomTheme: Theme {
    var id: String = "custom"
    var name: String
    var description: String { "テスト用" }
    var category: ThemeCategory { .custom }
    var previewColors: [Color] { [PrimitiveColors.pink500] }
    func colorPalette(for mode: ThemeMode) -> any ColorPalette { LightColorPalette() }
}
