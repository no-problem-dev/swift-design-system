import XCTest
@testable import DesignSystem

/// The components' user-facing strings resolve to Japanese.
///
/// 4.0.0 turned the hardcoded Japanese into English literals with no catalog behind them, so every
/// app on a Japanese device showed English sheets and alerts. These tests pin both halves of the
/// fix: every string the sources look up has a Japanese entry, and the built bundle serves it.
final class LocalizationTests: XCTestCase {

    private static let packageRoot = URL(fileURLWithPath: #filePath)
        .deletingLastPathComponent()
        .deletingLastPathComponent()
        .deletingLastPathComponent()

    private static let sourcesDirectory = packageRoot.appendingPathComponent("Sources/DesignSystem")

    private static let catalogURL = sourcesDirectory.appendingPathComponent("Resources/Localizable.xcstrings")

    /// The catalog's keys mapped to their Japanese value, or `nil` when the key has no translated `ja`.
    private func japaneseByKey() throws -> [String: String?] {
        let data = try Data(contentsOf: Self.catalogURL)
        let catalog = try XCTUnwrap(JSONSerialization.jsonObject(with: data) as? [String: Any])
        let strings = try XCTUnwrap(catalog["strings"] as? [String: [String: Any]])
        return strings.mapValues { entry in
            let localizations = entry["localizations"] as? [String: Any]
            let unit = (localizations?["ja"] as? [String: Any])?["stringUnit"] as? [String: Any]
            guard unit?["state"] as? String == "translated" else { return nil }
            return unit?["value"] as? String
        }
    }

    /// Every literal handed to `String(localized:bundle: .module)` or `Text(_:bundle: .module)`.
    ///
    /// Interpolations are replaced with a placeholder so they can be matched against the catalog's
    /// format specifiers, whose exact type (`%@`, `%lld`) the source does not spell out.
    private func lookedUpKeys() throws -> Set<String> {
        let pattern = try NSRegularExpression(
            pattern: #"(?:String\(\s*localized:|Text\()\s*"((?:[^"\\]|\\.)*)"\s*,\s*bundle:\s*\.module"#
        )
        let interpolation = try NSRegularExpression(pattern: #"\\\((?:[^()]|\([^()]*\))*\)"#)
        var keys: Set<String> = []
        let enumerator = try XCTUnwrap(FileManager.default.enumerator(at: Self.sourcesDirectory, includingPropertiesForKeys: nil))
        for case let url as URL in enumerator where url.pathExtension == "swift" {
            let source = try String(contentsOf: url, encoding: .utf8)
            let range = NSRange(source.startIndex..., in: source)
            for match in pattern.matches(in: source, range: range) {
                let literal = String(source[Range(match.range(at: 1), in: source)!])
                let literalRange = NSRange(literal.startIndex..., in: literal)
                keys.insert(interpolation.stringByReplacingMatches(in: literal, range: literalRange, withTemplate: "{}"))
            }
        }
        return keys
    }

    private func placeholderForm(_ catalogKey: String) -> String {
        catalogKey.replacingOccurrences(of: #"%(lld|ld|d|@|f)"#, with: "{}", options: .regularExpression)
    }

    func testEveryLookedUpStringHasJapanese() throws {
        let catalog = try japaneseByKey()
        let catalogByPlaceholderForm = Dictionary(
            catalog.map { (placeholderForm($0.key), $0.value) },
            uniquingKeysWith: { first, _ in first }
        )
        let keys = try lookedUpKeys()
        XCTAssertFalse(keys.isEmpty, "The source scan found no localized lookups; the pattern no longer matches the code.")

        for key in keys.sorted() {
            guard let japanese = catalogByPlaceholderForm[key] else {
                XCTFail("\"\(key)\" is looked up but missing from Localizable.xcstrings")
                continue
            }
            XCTAssertNotNil(japanese, "\"\(key)\" has no translated Japanese")
        }
    }

    func testCatalogHasNoUnusedKeys() throws {
        let used = try lookedUpKeys()
        for key in try japaneseByKey().keys.sorted() {
            XCTAssertTrue(used.contains(placeholderForm(key)), "\"\(key)\" is in the catalog but nothing looks it up")
        }
    }

    // MARK: - The built bundle

    private func japaneseBundle() throws -> Bundle {
        let path = try XCTUnwrap(
            Bundle.module.path(forResource: "ja", ofType: "lproj"),
            "The DesignSystem resource bundle ships no ja.lproj"
        )
        return try XCTUnwrap(Bundle(path: path))
    }

    func testImagePickerSheetIsJapanese() throws {
        let ja = try japaneseBundle()
        XCTAssertEqual(ja.localizedString(forKey: "Select an Image", value: nil, table: nil), "画像を選択")
        XCTAssertEqual(ja.localizedString(forKey: "Take Photo", value: nil, table: nil), "カメラで撮影")
        XCTAssertEqual(ja.localizedString(forKey: "Choose from Library", value: nil, table: nil), "写真ライブラリから選択")
        XCTAssertEqual(ja.localizedString(forKey: "Cancel", value: nil, table: nil), "キャンセル")
    }

    func testFormattedStringsKeepTheirArguments() throws {
        let ja = try japaneseBundle()
        let step = ja.localizedString(forKey: "Step %lld of %lld", value: nil, table: nil)
        XCTAssertEqual(String(format: step, 2 as Int64, 5 as Int64), "ステップ 2 / 5")

        let tooLong = ja.localizedString(
            forKey: "The video is too long (%@ seconds). The maximum is %@ seconds.",
            value: nil,
            table: nil
        )
        XCTAssertEqual(String(format: tooLong, "90", "60"), "動画が長すぎます（90秒）。最大60秒までです。")
    }

    /// A bundle that ships only `ja.lproj` hands Japanese to every language, English included,
    /// because it is the only localization to choose from. English needs its own `en.lproj`.
    func testEachLanguageGetsItsOwnStrings() {
        let localizations = Bundle.module.localizations
        XCTAssertEqual(Bundle.module.developmentLocalization, "en")
        XCTAssertTrue(localizations.contains("en"), "No en.lproj: \(localizations)")
        XCTAssertTrue(localizations.contains("ja"), "No ja.lproj: \(localizations)")

        func chosen(for preferences: [String]) -> String? {
            Bundle.preferredLocalizations(from: localizations, forPreferences: preferences).first
        }
        XCTAssertEqual(chosen(for: ["ja-JP"]), "ja")
        XCTAssertEqual(chosen(for: ["en-US"]), "en")
    }
}
