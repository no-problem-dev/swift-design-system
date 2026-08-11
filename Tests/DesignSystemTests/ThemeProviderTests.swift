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
        let defaultPrimary = provider.colorPalette(for: .light).primary

        provider.switchToTheme(id: "ocean")

        XCTAssertEqual(provider.currentTheme.id, "ocean")
        // ID だけでなく解決されるパレットまで実際に入れ替わる
        assertColorsDiffer(provider.colorPalette(for: .light).primary, defaultPrimary, "primary")
        assertSameColor(provider.colorPalette(for: .light).primary, OceanTheme().colorPalette(for: .light).primary, "ocean primary")
    }

    func testSwitchToUnknownThemeIsNoOp() {
        let provider = ThemeProvider()
        let before = provider.currentTheme.id

        provider.switchToTheme(id: "nonexistent-theme")
        XCTAssertEqual(provider.currentTheme.id, before)
        assertSameColor(provider.colorPalette(for: .light).primary, LightColorPalette().primary, "primary")
    }

    func testApplyThemeSetsCurrentThemeAndPalette() {
        let provider = ThemeProvider()

        provider.applyTheme(HighContrastTheme())

        XCTAssertEqual(provider.currentTheme.id, "high-contrast")
        assertSameColor(
            provider.colorPalette(for: .light).primary,
            HighContrastTheme().colorPalette(for: .light).primary,
            "high-contrast primary"
        )
    }

    // MARK: - パレット解決

    func testLightAndDarkModesResolveToTheirOwnPalettes() {
        let light = ThemeProvider(initialMode: .light)
        let dark = ThemeProvider(initialMode: .dark)

        assertSameColor(light.colorPalette(for: .light).primary, LightColorPalette().primary, "light primary")
        assertSameColor(dark.colorPalette(for: .dark).primary, DarkColorPalette().primary, "dark primary")
        assertColorsDiffer(light.colorPalette(for: .light).primary, dark.colorPalette(for: .dark).primary, "primary")
        assertColorsDiffer(light.colorPalette(for: .light).background, dark.colorPalette(for: .dark).background, "background")
    }

    func testSystemModeFollowsTheAppearanceItIsGiven() {
        // .system は既定モード。端末の外観が dark なら dark パレットが返らなければならない
        // （常に light を返していたのが元の不具合）
        let provider = ThemeProvider()
        XCTAssertEqual(provider.themeMode, .system)

        assertSameColor(provider.colorPalette(for: .light).background, LightColorPalette().background, "system + light")
        assertSameColor(provider.colorPalette(for: .dark).background, DarkColorPalette().background, "system + dark")
        assertColorsDiffer(
            provider.colorPalette(for: .light).background,
            provider.colorPalette(for: .dark).background,
            "system background"
        )
    }

    func testPinnedModesIgnoreTheAppearance() {
        // .light / .dark は端末の外観に関係なく固定される
        let light = ThemeProvider(initialMode: .light)
        let dark = ThemeProvider(initialMode: .dark)

        assertSameColor(light.colorPalette(for: .dark).background, LightColorPalette().background, "pinned light")
        assertSameColor(dark.colorPalette(for: .light).background, DarkColorPalette().background, "pinned dark")
    }

    func testResolvedModeNeverReportsSystem() {
        // .system は必ず light / dark のどちらかへ解決される。
        // .theme(_:) はこの解決結果で colorScheme を決めるため、system が漏れると外観が固定される
        XCTAssertEqual(ThemeProvider(initialMode: .system).resolvedMode(for: .light), .light)
        XCTAssertEqual(ThemeProvider(initialMode: .system).resolvedMode(for: .dark), .dark)
        XCTAssertEqual(ThemeProvider(initialMode: .light).resolvedMode(for: .dark), .light)
        XCTAssertEqual(ThemeProvider(initialMode: .dark).resolvedMode(for: .light), .dark)
    }

    func testChangingModeReresolvesThePaletteOfTheCurrentTheme() {
        let provider = ThemeProvider(initialMode: .light)
        provider.switchToTheme(id: "high-contrast")
        let lightPrimary = provider.colorPalette(for: .light).primary

        provider.themeMode = .dark

        // 端末の外観は light のままでも、モードを .dark に固定したので dark パレットになる
        assertColorsDiffer(provider.colorPalette(for: .light).primary, lightPrimary, "high-contrast primary")
        assertSameColor(
            provider.colorPalette(for: .light).primary,
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
