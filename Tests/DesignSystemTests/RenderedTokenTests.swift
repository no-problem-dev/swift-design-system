import XCTest
import SwiftUI
@testable import DesignSystem

/// トークンが「画面に届いている」ことを描画結果の画素で押さえる。
///
/// トークン表の値を assert しても、それを読む描画側が無ければ何も証明しない
/// （``NewTokenTests`` は表しか見ていない）。ここは逆に、表の値は一切見ずに
/// 「描いた絵が変わるか」「変わり方が token の値そのものか」だけを見る。
///
/// スナップショット（``ComponentSnapshotTests``）は precision 0.99 で走るので
/// 1pt の線や 0.1 の不透明度は緑のまま通る。ここは参照画像を持たず、
/// 同じ部品を条件違いで 2 回描いて画素を引き算するので、その閾値に埋もれない。
@MainActor
final class RenderedTokenTests: XCTestCase {

    // MARK: - 描画ヘルパー

    /// テーマを当てて実際に描画し、RGBA の画素列を取り出す。
    private func pixels(
        theme: (any Theme)? = nil,
        size: CGSize = CGSize(width: 160, height: 80),
        file: StaticString = #filePath,
        line: UInt = #line,
        @ViewBuilder _ content: () -> some View
    ) throws -> [UInt8] {
        let provider = theme.map { ThemeProvider(initialTheme: $0, initialMode: .light) }
            ?? ThemeProvider(initialMode: .light)
        let view = content()
            .theme(provider)
            .frame(width: size.width, height: size.height)
            .background(provider.colorPalette(for: .light).background)

        let renderer = ImageRenderer(content: view)
        renderer.scale = 2
        let image = try XCTUnwrap(renderer.cgImage, "描画に失敗した", file: file, line: line)

        var buffer = [UInt8](repeating: 0, count: image.width * image.height * 4)
        let context = try XCTUnwrap(
            CGContext(
                data: &buffer,
                width: image.width,
                height: image.height,
                bitsPerComponent: 8,
                bytesPerRow: image.width * 4,
                space: CGColorSpaceCreateDeviceRGB(),
                bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
            ),
            "CGContext を作れない", file: file, line: line
        )
        context.draw(image, in: CGRect(origin: .zero, size: CGSize(width: image.width, height: image.height)))
        return buffer
    }

    /// 色成分（アルファを除く）の添字。
    private func colorComponents(_ count: Int) -> StrideTo<Int> {
        stride(from: 0, to: count, by: 1)
    }

    private func isAlphaChannel(_ index: Int) -> Bool { index % 4 == 3 }

    // MARK: - disabledOpacity が画面に届く

    /// `.opacity` を通った不透明度を、描画結果から逆算して測る。
    ///
    /// 背景 `bg`・有効 `on`・無効 `off` を同じ場所で描くと、無効時の画素は
    /// `off = a·on + (1-a)·bg` になる（`.opacity(a)` は部品を一枚の層に畳んでから
    /// 掛かるので、影も文字も縁も同じ `a` を被る）。よって
    /// `a = (off - bg) / (on - bg)` が、実際に画面へ届いた不透明度そのものになる。
    ///
    /// 影や文字のアンチエイリアスは `on - bg` と `off - bg` の両方に同じだけ乗るため
    /// 約分されて消える。だから測定は部品の中身に依存しない。
    private func measuredDisabledOpacities(
        file: StaticString = #filePath,
        line: UInt = #line,
        @ViewBuilder _ control: @escaping (_ isEnabled: Bool) -> some View
    ) throws -> [Double] {
        let bg = try pixels(file: file, line: line) { Color.clear }
        let on = try pixels(file: file, line: line) { control(true) }
        let off = try pixels(file: file, line: line) { control(false) }
        XCTAssertEqual(bg.count, on.count, "同じ大きさで描かれていない", file: file, line: line)
        XCTAssertEqual(on.count, off.count, "同じ大きさで描かれていない", file: file, line: line)

        // 量子化誤差が比に効かない程度に、背景から十分離れた画素だけを使う
        let minimumSignal = 48.0
        var values: [Double] = []
        for index in colorComponents(on.count) where !isAlphaChannel(index) {
            let enabledDelta = Double(on[index]) - Double(bg[index])
            guard abs(enabledDelta) >= minimumSignal else { continue }
            values.append((Double(off[index]) - Double(bg[index])) / enabledDelta)
        }
        return values.sorted()
    }

    /// 測った不透明度が token であることを見る。
    ///
    /// 代表値は平均ではなく中央値を取る。文字の縁の画素は、層に不透明度が掛かると
    /// 平滑化のかかり方自体が変わるので比が乱れるからで、外れ値に引きずられない。
    ///
    /// 許容 0.05 は「測れる信号の量」で決まっている。塗りが不透明な primary は
    /// 13,000 画素以上が取れて実測 0.500 に乗るが、secondaryContainer のように
    /// 半透明の塗りだと背景との差が小さく閾値で落ち、文字の画素しか残らないので
    /// 実測が 0.53 前後まで振れる。一方この不具合の実際の値は 0.6（直書き）と
    /// 0.36（`.opacity` 二重掛け）で、どちらも 0.05 の外にある。
    private func assertDisabledOpacityReachesTheScreen(
        _ label: String,
        file: StaticString = #filePath,
        line: UInt = #line,
        @ViewBuilder _ control: @escaping (_ isEnabled: Bool) -> some View
    ) throws {
        let values = try measuredDisabledOpacities(file: file, line: line, control)

        XCTAssertGreaterThan(
            values.count, 500,
            "\(label): 有効時と背景の差が小さすぎて測れない（部品が描かれていない）",
            file: file, line: line
        )
        guard !values.isEmpty else { return }

        let measured = values[values.count / 2]

        XCTAssertEqual(
            measured, ControlTokens.disabledOpacity, accuracy: 0.05,
            "\(label): 画面に届いた不透明度は \(String(format: "%.3f", measured)) で、"
            + "ControlTokens.disabledOpacity (\(ControlTokens.disabledOpacity)) ではない",
            file: file, line: line
        )
    }

    func testPrimaryButtonDrawsDisabledAtTheToken() throws {
        try assertDisabledOpacityReachesTheScreen("primary") { isEnabled in
            Button("Save") {}
                .buttonStyle(.primary)
                .disabled(!isEnabled)
        }
    }

    func testSecondaryButtonDrawsDisabledAtTheToken() throws {
        try assertDisabledOpacityReachesTheScreen("secondary") { isEnabled in
            Button("Cancel") {}
                .buttonStyle(.secondary)
                .disabled(!isEnabled)
        }
    }

    func testTertiaryButtonDrawsDisabledAtTheToken() throws {
        try assertDisabledOpacityReachesTheScreen("tertiary") { isEnabled in
            Button("Details") {}
                .buttonStyle(.tertiary)
                .disabled(!isEnabled)
        }
    }

    func testPrimaryTonalButtonDrawsDisabledAtTheToken() throws {
        try assertDisabledOpacityReachesTheScreen("primaryTonal") { isEnabled in
            Button("Share") {}
                .buttonStyle(.primaryTonal)
                .disabled(!isEnabled)
        }
    }

    /// FloatingActionButton は `.buttonStyle(.plain)` を通すので、無効時には
    /// プラットフォーム側の減光が我々の不透明度に重なる（macOS 実測で合計 0.27）。
    /// その係数はこのパッケージの持ち物ではないので値では押さえられない。
    /// 代わりに、デザインシステム側が二重に掛けていないこと（＝一様であること）を見る。
    func testFloatingActionButtonDimsUniformlyWhenDisabled() throws {
        let values = try measuredDisabledOpacities { isEnabled in
            FloatingActionButton(icon: "plus", size: .large) {}
                .disabled(!isEnabled)
        }
        XCTAssertGreaterThan(values.count, 500, "描かれていない")
        let measured = values[values.count / 2]
        // プラットフォーム側の減光 0.5 に token 0.5 が重なった値（実測 0.27）。
        // 二重掛けが design system 側に戻れば、ここはさらに半分に落ちる。
        XCTAssertGreaterThan(measured, 0.2, "無効時が暗すぎる。.opacity が二重に掛かっていないか")
        XCTAssertLessThan(measured, 0.4, "無効時に薄くなっていない")
    }

    /// トークンを 1.0 にすると無効時の絵が有効時と一致する。
    ///
    /// 上の測定が本当にトークンを見ているのか（たまたま 0.5 前後の別の定数を
    /// 測っていないか）を、値を動かして確かめる代わりの押さえ。
    func testTheMeasurementTracksTheOpacityAndNotAConstant() throws {
        let values = try measuredDisabledOpacities { isEnabled in
            Button("Save") {}
                .buttonStyle(.primary)
                .opacity(isEnabled ? 1 : 0.25)
        }
        XCTAssertGreaterThan(values.count, 500)
        XCTAssertEqual(values[values.count / 2], 0.25, accuracy: 0.02, "測定器自体がずれている")
    }

    /// 検査に歯があることを確かめる。
    ///
    /// 元の不具合と同じ形（塗りと全体に二重に `.opacity` が掛かる）を作ると、
    /// 塗りには a² が乗る。面積で勝つのは塗りなので中央値は 0.25 側へ落ちる。
    /// ここが token と区別できないなら、上の検査は二重掛けを見逃す。
    func testTheCheckDetectsADoubledOpacity() throws {
        let values = try measuredDisabledOpacities { isEnabled in
            Text("Save")
                .typography(.labelLarge)
                .foregroundStyle(Color.white)
                .padding(.horizontal, 20)
                .frame(height: 44)
                .background(
                    Capsule()
                        .fill(Color(red: 0.2, green: 0.4, blue: 0.9))
                        .opacity(isEnabled ? 1 : ControlTokens.disabledOpacity)
                )
                .opacity(isEnabled ? 1 : ControlTokens.disabledOpacity)
        }
        XCTAssertGreaterThan(values.count, 500)
        let doubled = values[values.count / 2]
        let token = ControlTokens.disabledOpacity
        XCTAssertEqual(doubled, token * token, accuracy: 0.05, "二重掛けが a² にならない")
        XCTAssertGreaterThan(
            abs(doubled - token), 0.05,
            "二重掛けの結果が token と 0.05 以内にある。この検査は不具合を拾えない"
        )
    }

    // MARK: - borderScale が画面に届く

    private struct HeavyBorderScale: BorderScale {
        var none: CGFloat { 0 }
        var thin: CGFloat { 3 }
        var regular: CGFloat { 6 }
        var thick: CGFloat { 9 }
        var heavy: CGFloat { 12 }
    }

    /// 線幅だけを既定から変えたテーマ。色・角丸・余白は既定のまま。
    private struct HeavyBorderTheme: Theme {
        var id: String { "heavy-border" }
        var name: String { "Heavy Border" }
        var description: String { "" }
        var category: ThemeCategory { .brandPersonality }
        var previewColors: [Color] { [.blue] }
        func colorPalette(for mode: ThemeMode) -> any ColorPalette { LightColorPalette() }
        var borderScale: any BorderScale { HeavyBorderScale() }
    }

    /// テーマの線幅が部品の描画に届いているか。
    ///
    /// 線幅「だけ」が違う 2 つのテーマで同じ部品を描き、絵が変わることを見る。
    /// 変わらなければ、その部品は `lineWidth` を自分で書いていて
    /// `@Environment(\.borderScale)` を読んでいない。
    private func assertBorderScaleReachesTheScreen(
        _ label: String,
        size: CGSize = CGSize(width: 160, height: 80),
        file: StaticString = #filePath,
        line: UInt = #line,
        @ViewBuilder _ content: @escaping () -> some View
    ) throws {
        let normal = try pixels(size: size, file: file, line: line, content)
        let heavy = try pixels(theme: HeavyBorderTheme(), size: size, file: file, line: line, content)
        XCTAssertEqual(normal.count, heavy.count, "同じ大きさで描かれていない", file: file, line: line)

        let differing = zip(normal, heavy).reduce(0) { $0 + ($1.0 == $1.1 ? 0 : 1) }
        XCTAssertGreaterThan(
            differing, 0,
            "\(label): テーマの borderScale を変えても絵が変わらない（lineWidth を直書きしている）",
            file: file, line: line
        )
        // 差が面全体に及ぶなら、変わったのは線ではなく塗り
        XCTAssertLessThan(
            differing, normal.count / 2,
            "\(label): 差分が広すぎる。線ではなく塗りが変わっていないか",
            file: file, line: line
        )
    }

    func testCardBorderFollowsTheTheme() throws {
        try assertBorderScaleReachesTheScreen("Card") {
            Card { Text("Body") }
        }
    }

    func testSegmentedControlBorderFollowsTheTheme() throws {
        try assertBorderScaleReachesTheScreen("SegmentedControl") {
            SegmentedControl(selection: .constant("a"), options: ["a", "b"]) { Text($0) }
        }
    }

    func testOutlinedTextFieldBorderFollowsTheTheme() throws {
        try assertBorderScaleReachesTheScreen("DSTextField(.outlined)", size: CGSize(width: 200, height: 120)) {
            DSTextField("Label", text: .constant("value"), style: .outlined)
        }
    }

    func testPrimaryTonalButtonBorderFollowsTheTheme() throws {
        try assertBorderScaleReachesTheScreen("primaryTonal") {
            Button("Share") {}
                .buttonStyle(.primaryTonal)
        }
    }

    func testIconButtonOutlineFollowsTheTheme() throws {
        try assertBorderScaleReachesTheScreen("IconButton(.outlined)", size: CGSize(width: 60, height: 60)) {
            IconButton(icon: "square.and.arrow.up", style: .outlined) {}
        }
    }

    /// 線を持たない部品はテーマの線幅で変わらない。
    ///
    /// 上のテストが「テーマを差し替えたら何であれ絵が変わる」を見ているだけ
    /// ではないことを押さえる対照。
    func testAComponentWithoutABorderIsUnaffected() throws {
        let content = { Text("Plain").typography(.bodyMedium) }
        let normal = try pixels(content)
        let heavy = try pixels(theme: HeavyBorderTheme(), content)
        XCTAssertEqual(normal, heavy, "線を持たない部品が borderScale で変わっている")
    }

    // MARK: - iconSizeScale が画面に届く

    private struct BigIconSizeScale: IconSizeScale {
        var xxs: CGFloat { 20 }
        var xs: CGFloat { 24 }
        var sm: CGFloat { 40 }
        var md: CGFloat { 48 }
        var lg: CGFloat { 56 }
        var xl: CGFloat { 64 }
        var xxl: CGFloat { 72 }
    }

    /// アイコンの大きさだけを既定から変えたテーマ。
    private struct BigIconTheme: Theme {
        var id: String { "big-icon" }
        var name: String { "Big Icon" }
        var description: String { "" }
        var category: ThemeCategory { .brandPersonality }
        var previewColors: [Color] { [.blue] }
        func colorPalette(for mode: ThemeMode) -> any ColorPalette { LightColorPalette() }
        var iconSizeScale: any IconSizeScale { BigIconSizeScale() }
    }

    /// `.iconSize(.sm)` がテーマの尺度を読んでいるか。
    ///
    /// `ThemeModifier` は `\.iconSizeScale` を environment に流しているが、
    /// modifier 側が `DefaultIconSizeScale()` を直に作っていると、テーマを
    /// 差し替えてもアイコンは 1pt も動かない（それが元の状態）。
    func testIconSizeFollowsTheTheme() throws {
        let content = {
            Image(systemName: "checkmark")
                .iconSize(.sm)
                .foregroundStyle(Color.black)
        }
        let normal = try pixels(content)
        let big = try pixels(theme: BigIconTheme(), content)

        let differing = zip(normal, big).reduce(0) { $0 + ($1.0 == $1.1 ? 0 : 1) }
        XCTAssertGreaterThan(
            differing, 0,
            "テーマの iconSizeScale を変えてもアイコンの絵が変わらない"
        )
    }

    /// 拡大したテーマの方が実際に大きく描かれている（変わっただけでなく向きも正しい）。
    func testABiggerIconScaleDrawsMoreInk() throws {
        let content = {
            Image(systemName: "checkmark")
                .iconSize(.sm)
                .foregroundStyle(Color.black)
        }
        let background = try pixels { Color.clear }
        func inkedPixels(_ buffer: [UInt8]) -> Int {
            var count = 0
            for index in colorComponents(buffer.count) where !isAlphaChannel(index) {
                if abs(Double(buffer[index]) - Double(background[index])) >= 48 { count += 1 }
            }
            return count
        }
        let normal = inkedPixels(try pixels(content))
        let big = inkedPixels(try pixels(theme: BigIconTheme(), content))
        XCTAssertGreaterThan(big, normal, "sm を 16pt から 40pt にしてもアイコンが大きくならない")
    }
}
