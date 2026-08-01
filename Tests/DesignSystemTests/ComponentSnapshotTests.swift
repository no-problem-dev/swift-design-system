// スナップショットテスト（swift-visual-testing）
//
// VisualTesting は UIKit ベースのため iOS でのみ実行される（macOS の `swift test` ではコンパイル対象外）。
// 参照画像はレンダラの都合で iOS のバージョンが変わると差分が出るため、記録時と同じランタイムで比較すること。
// 実行方法:
//   xcodebuild test -scheme DesignSystem-Package -destination 'platform=iOS Simulator,name=<simulator>'
// 参照画像の初回記録・再記録:
//   TEST_RUNNER_SNAPSHOT_TESTING_RECORD=all xcodebuild test -scheme DesignSystem-Package \
//     -destination 'platform=iOS Simulator,name=<simulator>'
//
// 対象の選び方: 描画が決定論的なコンポーネントだけを撮る。
// Skeleton / Spinner / Staggered / Scroll は時間駆動アニメーションが本体で、
// MediaViewer / VideoPlayer は非同期取得とジェスチャ状態に依存するため、意図的に対象外。
#if canImport(UIKit)
import DesignSystem
import SwiftUI
import Testing
import VisualTesting

// MARK: - Theme Integration

/// DesignSystem の ThemeProvider をスナップショットのテーマ軸（light / dark）へ接続する
private struct DesignSystemThemeApplicable: ThemeApplicable {
    @MainActor
    func applyTheme<V: View>(_ view: V, theme: SnapshotTheme) -> AnyView {
        let provider = ThemeProvider(initialMode: theme == .light ? .light : .dark)
        return AnyView(
            view
                .theme(provider)
                .environment(\.colorScheme, theme == .light ? .light : .dark)
        )
    }
}

/// `VisualTesting.themeApplicable` はグローバルなので、スイートごとに書くとスイート並列実行時に
/// 同じ変数へ同時書き込みが起きる。グローバル `let` の初期化に載せて 1 回だけ実行させる。
@MainActor
private let themeApplicableInstalled: Bool = {
    VisualTesting.themeApplicable = DesignSystemThemeApplicable()
    return true
}()

@MainActor
private func setupVisualTesting() {
    _ = themeApplicableInstalled
}

// MARK: - Button

@SnapshotSuite("Button")
@MainActor
struct ButtonSnapshots {
    init() { setupVisualTesting() }

    @ComponentSnapshot(width: 340, height: 100)
    func primary() -> some View {
        Button("保存") {}
            .buttonStyle(.primary)
            .padding()
    }

    @ComponentSnapshot(width: 340, height: 100)
    func secondary() -> some View {
        Button("キャンセル") {}
            .buttonStyle(.secondary)
            .padding()
    }

    @ComponentSnapshot(width: 340, height: 100)
    func tertiary() -> some View {
        Button("詳細を見る") {}
            .buttonStyle(.tertiary)
            .padding()
    }

    @ComponentSnapshot(width: 340, height: 100)
    func primaryTonal() -> some View {
        Button("下書きを保存") {}
            .buttonStyle(.primaryTonal)
            .padding()
    }

    @ComponentSnapshot(width: 340, height: 100)
    func glass() -> some View {
        Button("あとで読む") {}
            .buttonStyle(.glass)
            .padding()
    }

    @ComponentSnapshot(width: 340, height: 100)
    func primaryGlass() -> some View {
        Button("共有") {}
            .buttonStyle(.primaryGlass)
            .padding()
    }

    /// 無効時は塗りと文字が 0.6 に落ちる。有効時と取り違えていないかを押さえる
    @ComponentSnapshot(width: 340, height: 100)
    func primaryDisabled() -> some View {
        Button("保存") {}
            .buttonStyle(.primary)
            .disabled(true)
            .padding()
    }

    /// 長いラベルの折り返し・切り詰めの挙動を固定する
    @ComponentSnapshot(width: 340, height: 140)
    func primaryLongLabel() -> some View {
        Button("この内容で登録して次の画面へ進む") {}
            .buttonStyle(.primary)
            .padding()
    }

    @ComponentSnapshot(width: 340, height: 100)
    func smallSize() -> some View {
        Button("保存") {}
            .buttonStyle(.primary)
            .buttonSize(.small)
            .padding()
    }

    @Test func snapshots() {
        for snapshotCase in Self.__snapshotCases { snapshotCase.run() }
    }
}

// MARK: - Card

@SnapshotSuite("Card")
@MainActor
struct CardSnapshots {
    init() { setupVisualTesting() }

    /// 影なしの下限
    @ComponentSnapshot(width: 340, height: 160)
    func level0() -> some View {
        Card(elevation: .level0) {
            VStack(alignment: .leading, spacing: 8) {
                Text("影なしカード").typography(.titleMedium)
                Text("Elevation level0。").typography(.bodyMedium)
            }
        }
        .padding()
    }

    @ComponentSnapshot(width: 340, height: 160)
    func level1() -> some View {
        Card(elevation: .level1) {
            VStack(alignment: .leading, spacing: 8) {
                Text("カードタイトル").typography(.titleMedium)
                Text("カードの説明文がここに入ります。").typography(.bodyMedium)
            }
        }
        .padding()
    }

    @ComponentSnapshot(width: 340, height: 160)
    func level3() -> some View {
        Card(elevation: .level3) {
            VStack(alignment: .leading, spacing: 8) {
                Text("強調カード").typography(.titleMedium)
                Text("Elevation level3 のカード。").typography(.bodyMedium)
            }
        }
        .padding()
    }

    /// 影の上限
    @ComponentSnapshot(width: 340, height: 160)
    func level5() -> some View {
        Card(elevation: .level5) {
            VStack(alignment: .leading, spacing: 8) {
                Text("最大の影").typography(.titleMedium)
                Text("Elevation level5。").typography(.bodyMedium)
            }
        }
        .padding()
    }

    @Test func snapshots() {
        for snapshotCase in Self.__snapshotCases { snapshotCase.run() }
    }
}

// MARK: - Chip

@SnapshotSuite("Chip")
@MainActor
struct ChipSnapshots {
    init() { setupVisualTesting() }

    @ComponentSnapshot(width: 220, height: 80)
    func filled() -> some View {
        Chip("Active", systemImage: "checkmark.circle.fill")
            .chipStyle(.filled)
            .padding()
    }

    @ComponentSnapshot(width: 220, height: 80)
    func outlined() -> some View {
        Chip("Outlined")
            .chipStyle(.outlined)
            .padding()
    }

    @ComponentSnapshot(width: 220, height: 80)
    func selected() -> some View {
        Chip("フィルター", systemImage: "line.3.horizontal.decrease", isSelected: .constant(true))
            .chipStyle(.outlined)
            .padding()
    }

    /// 選択・非選択で見た目が変わることを両方固定する
    @ComponentSnapshot(width: 220, height: 80)
    func unselected() -> some View {
        Chip("フィルター", systemImage: "line.3.horizontal.decrease", isSelected: .constant(false))
            .chipStyle(.outlined)
            .padding()
    }

    @ComponentSnapshot(width: 220, height: 80)
    func deletable() -> some View {
        Chip("Swift", systemImage: "tag.fill", onDelete: {})
            .chipStyle(.filled)
            .padding()
    }

    // liquidGlass スタイルは iOS 26.0 以降限定のため対象外。
    // 可用性で分岐させると参照画像が実行ランタイムに依存して比較が不安定になる。

    @Test func snapshots() {
        for snapshotCase in Self.__snapshotCases { snapshotCase.run() }
    }
}

// MARK: - ParameterChip

@SnapshotSuite("ParameterChip")
@MainActor
struct ParameterChipSnapshots {
    init() { setupVisualTesting() }

    @ComponentSnapshot(width: 220, height: 80)
    func plain() -> some View {
        ParameterChip("1024px", systemImage: "ruler")
            .padding()
    }

    @ComponentSnapshot(width: 220, height: 80)
    func prominent() -> some View {
        ParameterChip("1024px", systemImage: "ruler", prominent: true)
            .padding()
    }

    @Test func snapshots() {
        for snapshotCase in Self.__snapshotCases { snapshotCase.run() }
    }
}

// MARK: - FloatingActionButton

@SnapshotSuite("FloatingActionButton")
@MainActor
struct FloatingActionButtonSnapshots {
    init() { setupVisualTesting() }

    @ComponentSnapshot(width: 120, height: 120)
    func regular() -> some View {
        FloatingActionButton(icon: "plus") {}
            .padding()
    }

    @ComponentSnapshot(width: 100, height: 100)
    func small() -> some View {
        FloatingActionButton(icon: "pencil", size: .small) {}
            .padding()
    }

    @Test func snapshots() {
        for snapshotCase in Self.__snapshotCases { snapshotCase.run() }
    }
}

// MARK: - Snackbar

@SnapshotSuite("Snackbar")
@MainActor
struct SnackbarSnapshots {
    init() { setupVisualTesting() }

    @ComponentSnapshot(width: 393, height: 160)
    func message() -> some View {
        let state = SnackbarState()
        state.show(message: "保存しました")
        return Snackbar(state: state)
    }

    @ComponentSnapshot(width: 393, height: 160)
    func withActions() -> some View {
        let state = SnackbarState()
        state.show(
            message: "削除しました",
            primaryAction: SnackbarAction(title: "元に戻す") {},
            secondaryAction: SnackbarAction(title: "閉じる") {}
        )
        return Snackbar(state: state)
    }

    /// 非表示状態では何も描かれない。表示状態と取り違えていないかを押さえる
    @ComponentSnapshot(width: 393, height: 160)
    func hidden() -> some View {
        Snackbar(state: SnackbarState())
    }

    @Test func snapshots() {
        for snapshotCase in Self.__snapshotCases { snapshotCase.run() }
    }
}

// MARK: - ProgressBar

@SnapshotSuite("ProgressBar")
@MainActor
struct ProgressBarSnapshots {
    init() { setupVisualTesting() }

    @ComponentSnapshot(width: 340, height: 60)
    func empty() -> some View {
        ProgressBar(value: 0.0)
            .padding()
    }

    @ComponentSnapshot(width: 340, height: 60)
    func thirtyPercent() -> some View {
        ProgressBar(value: 0.3)
            .padding()
    }

    @ComponentSnapshot(width: 340, height: 60)
    func eightyPercent() -> some View {
        ProgressBar(value: 0.8)
            .padding()
    }

    @ComponentSnapshot(width: 340, height: 60)
    func full() -> some View {
        ProgressBar(value: 1.0)
            .padding()
    }

    /// 範囲外は 0...1 に丸められる。`empty` / `full` と同じ絵になるのが正しい
    @ComponentSnapshot(width: 340, height: 60)
    func belowRangeClampsToEmpty() -> some View {
        ProgressBar(value: -0.5)
            .padding()
    }

    @ComponentSnapshot(width: 340, height: 60)
    func aboveRangeClampsToFull() -> some View {
        ProgressBar(value: 1.5)
            .padding()
    }

    @Test func snapshots() {
        for snapshotCase in Self.__snapshotCases { snapshotCase.run() }
    }
}

// MARK: - EmptyState

@SnapshotSuite("EmptyState")
@MainActor
struct EmptyStateSnapshots {
    init() { setupVisualTesting() }

    @ComponentSnapshot(width: 340, height: 280)
    func basic() -> some View {
        EmptyState(
            systemImage: "tray",
            title: "アイテムがありません",
            description: "右下の + ボタンから追加できます"
        )
        .padding()
    }

    /// description なしの分岐
    @ComponentSnapshot(width: 340, height: 240)
    func titleOnly() -> some View {
        EmptyState(systemImage: "tray", title: "アイテムがありません")
            .padding()
    }

    @Test func snapshots() {
        for snapshotCase in Self.__snapshotCases { snapshotCase.run() }
    }
}

// MARK: - StatusIndicator

@SnapshotSuite("StatusIndicator")
@MainActor
struct StatusIndicatorSnapshots {
    init() { setupVisualTesting() }

    /// 5 ケースを 1 枚に並べる。ケース間で色・アイコンが取り違わっていないかを一度に押さえる
    @ComponentSnapshot(width: 220, height: 220)
    func allKinds() -> some View {
        VStack(alignment: .leading, spacing: 8) {
            ForEach(StatusKind.allCases, id: \.self) { kind in
                StatusIndicator(kind)
            }
        }
        .padding()
    }

    @Test func snapshots() {
        for snapshotCase in Self.__snapshotCases { snapshotCase.run() }
    }
}

// MARK: - IconBadge

@SnapshotSuite("IconBadge")
@MainActor
struct IconBadgeSnapshots {
    init() { setupVisualTesting() }

    @ComponentSnapshot(width: 300, height: 120)
    func allSizes() -> some View {
        HStack(spacing: 12) {
            IconBadge(systemName: "bell.fill", size: .small)
            IconBadge(systemName: "bell.fill", size: .medium)
            IconBadge(systemName: "bell.fill", size: .large)
        }
        .padding()
    }

    @ComponentSnapshot(width: 140, height: 140)
    func tinted() -> some View {
        IconBadge(
            systemName: "checkmark",
            size: .large,
            foregroundColor: .white,
            backgroundColor: .green
        )
        .padding()
    }

    @Test func snapshots() {
        for snapshotCase in Self.__snapshotCases { snapshotCase.run() }
    }
}

// MARK: - IconButton

@SnapshotSuite("IconButton")
@MainActor
struct IconButtonSnapshots {
    init() { setupVisualTesting() }

    @ComponentSnapshot(width: 300, height: 120)
    func allStyles() -> some View {
        HStack(spacing: 12) {
            IconButton(icon: "square.and.arrow.up", style: .standard) {}
            IconButton(icon: "square.and.arrow.up", style: .filled) {}
            IconButton(icon: "square.and.arrow.up", style: .tonal) {}
            IconButton(icon: "square.and.arrow.up", style: .outlined) {}
        }
        .padding()
    }

    @ComponentSnapshot(width: 300, height: 120)
    func allSizes() -> some View {
        HStack(spacing: 12) {
            IconButton(icon: "trash", style: .filled, size: .small) {}
            IconButton(icon: "trash", style: .filled, size: .medium) {}
            IconButton(icon: "trash", style: .filled, size: .large) {}
        }
        .padding()
    }

    @ComponentSnapshot(width: 160, height: 120)
    func disabled() -> some View {
        IconButton(icon: "trash", style: .filled) {}
            .disabled(true)
            .padding()
    }

    @Test func snapshots() {
        for snapshotCase in Self.__snapshotCases { snapshotCase.run() }
    }
}

// MARK: - StatDisplay

@SnapshotSuite("StatDisplay")
@MainActor
struct StatDisplaySnapshots {
    init() { setupVisualTesting() }

    @ComponentSnapshot(width: 340, height: 300)
    func allSizes() -> some View {
        VStack(alignment: .leading, spacing: 12) {
            StatDisplay(value: "128", unit: "件", size: .small)
            StatDisplay(value: "128", unit: "件", size: .medium)
            StatDisplay(value: "128", unit: "件", size: .large)
            StatDisplay(value: "128", unit: "件", size: .extraLarge)
        }
        .padding()
    }

    @ComponentSnapshot(width: 340, height: 120)
    func withoutUnit() -> some View {
        StatDisplay(value: "1,024")
            .padding()
    }

    @ComponentSnapshot(width: 340, height: 120)
    func centerAligned() -> some View {
        StatDisplay(value: "98.6", unit: "%", alignment: .center)
            .frame(maxWidth: .infinity)
            .padding()
    }

    @Test func snapshots() {
        for snapshotCase in Self.__snapshotCases { snapshotCase.run() }
    }
}

// MARK: - StepIndicator

@SnapshotSuite("StepIndicator")
@MainActor
struct StepIndicatorSnapshots {
    init() { setupVisualTesting() }

    @ComponentSnapshot(width: 240, height: 80)
    func firstOfFive() -> some View {
        StepIndicator(stepCount: 5, currentIndex: 0)
            .padding()
    }

    @ComponentSnapshot(width: 240, height: 80)
    func middleOfFive() -> some View {
        StepIndicator(stepCount: 5, currentIndex: 2)
            .padding()
    }

    @ComponentSnapshot(width: 240, height: 80)
    func lastOfFive() -> some View {
        StepIndicator(stepCount: 5, currentIndex: 4)
            .padding()
    }

    /// 選択なしの分岐
    @ComponentSnapshot(width: 240, height: 80)
    func noSelection() -> some View {
        StepIndicator(stepCount: 5, currentIndex: nil)
            .padding()
    }

    @Test func snapshots() {
        for snapshotCase in Self.__snapshotCases { snapshotCase.run() }
    }
}

// MARK: - Section

@SnapshotSuite("Section")
@MainActor
struct SectionSnapshots {
    init() { setupVisualTesting() }

    @ComponentSnapshot(width: 360, height: 220)
    func surfaceWithHeaderAndFooter() -> some View {
        SectionCard("通知", footer: "変更はすぐに反映されます") {
            SectionRow { Text("メール").typography(.bodyMedium) }
            SectionRowDivider()
            SectionRow { Text("プッシュ").typography(.bodyMedium) }
        }
        .padding()
    }

    @ComponentSnapshot(width: 360, height: 200)
    func titled() -> some View {
        SectionCard(title: "アカウント") {
            SectionRow { Text("表示名").typography(.bodyMedium) }
        }
        .padding()
    }

    @ComponentSnapshot(width: 360, height: 140)
    func navigationLabel() -> some View {
        SectionCard {
            SectionNavigationLabel("プライバシー", systemImage: "lock")
        }
        .padding()
    }

    @Test func snapshots() {
        for snapshotCase in Self.__snapshotCases { snapshotCase.run() }
    }
}

// MARK: - SectionRow

/// 行の骨格（最小高・先頭アイコン列）が効いていることを絵で押さえる。
/// 数値で確かめられるのは導出だけなので、「並べたときに揃うか」はここで見る。
@SnapshotSuite("SectionRow")
@MainActor
struct SectionRowSnapshots {
    init() { setupVisualTesting() }

    /// 字幅の違う記号を並べても、アイコンの無い行を挟んでも、ラベルの左端が縦に揃う
    @ComponentSnapshot(width: 360, height: 280)
    func labelsAlignAcrossRows() -> some View {
        SectionCard("アカウント") {
            SectionRow { SectionRowLabel("パスワード", systemImage: "lock") }
            SectionRowDivider()
            SectionRow { SectionRowLabel("連携サービス", systemImage: "rectangle.3.group") }
            SectionRowDivider()
            SectionRow { SectionRowLabel("通知", systemImage: "bell.badge.waveform.fill") }
            SectionRowDivider()
            SectionRow { SectionRowLabel("メールアドレス") }
        }
        .padding()
    }

    /// 副題付きの行。LinkCard と同じ「アイコン → タイトル + 副題」の構造になる
    @ComponentSnapshot(width: 360, height: 220)
    func labelWithSubtitle() -> some View {
        SectionCard {
            SectionRow { SectionRowLabel("メール", systemImage: "envelope", subtitle: "user@example.com") }
            SectionRowDivider()
            SectionRow { SectionRowLabel("プラン", subtitle: "無料") }
        }
        .padding()
    }

    /// 行の中身が小さくても最小タップ領域を割らない。
    /// 上の行（11pt ラベルだけ）と下の行（通常の本文）の高さが同じになるのが正しい
    @ComponentSnapshot(width: 360, height: 200)
    func smallContentKeepsTouchTarget() -> some View {
        SectionCard {
            SectionRow { Text("小さいラベルだけの行").typography(.labelSmall) }
            SectionRowDivider()
            SectionRow { Text("通常の本文の行").typography(.bodyLarge) }
        }
        .padding()
    }

    /// `Label` を直接置いた既存の書き方でも先頭アイコン列は固定される
    @ComponentSnapshot(width: 360, height: 260)
    func plainLabelsGetTheIconColumn() -> some View {
        SectionCard("従来の書き方") {
            SectionRow {
                Label("パスワード", systemImage: "lock")
                Spacer(minLength: 0)
            }
            SectionRowDivider()
            SectionRow {
                Label("連携サービス", systemImage: "rectangle.3.group")
                Spacer(minLength: 0)
            }
        }
        .padding()
    }

    /// アクセシビリティサイズで文字・アイコン列・行高が揃って伸び、崩れないこと
    @ComponentSnapshot(width: 360, height: 460)
    func accessibilitySize() -> some View {
        SectionCard("アカウント") {
            SectionRow { SectionRowLabel("パスワード", systemImage: "lock") }
            SectionRowDivider()
            SectionRow { SectionRowLabel("メールアドレス") }
            SectionRowDivider()
            SectionNavigationLabel("プライバシー", systemImage: "hand.raised")
        }
        .padding()
        .dynamicTypeSize(.accessibility3)
    }

    @Test func snapshots() {
        for snapshotCase in Self.__snapshotCases { snapshotCase.run() }
    }
}

// MARK: - Typography

/// `.typography(_:)` が Dynamic Type に追随することを絵で押さえる。
/// 既定サイズと同じ絵になってしまう実装では `accessibility3` の 1 枚が成立しない。
@SnapshotSuite("Typography")
@MainActor
struct TypographySnapshots {
    init() { setupVisualTesting() }

    private static let roles: [(Typography, String)] = [
        (.displaySmall, "Display Small"),
        (.headlineSmall, "Headline Small"),
        (.titleMedium, "Title Medium"),
        (.bodyLarge, "本文 Body Large"),
        (.bodySmall, "補足 Body Small"),
        (.labelSmall, "Label Small"),
    ]

    private static var ramp: some View {
        VStack(alignment: .leading, spacing: 8) {
            ForEach(Array(roles.enumerated()), id: \.offset) { _, row in
                Text(row.1).typography(row.0)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
    }

    @ComponentSnapshot(width: 360, height: 300)
    func defaultSize() -> some View {
        Self.ramp
    }

    /// 大きい役割ほど拡大率が小さいスタイルに相対させているため、
    /// display だけが画面を埋めることなく全役割が読める大きさに伸びる
    @ComponentSnapshot(width: 360, height: 620)
    func accessibilitySize() -> some View {
        Self.ramp.dynamicTypeSize(.accessibility3)
    }

    /// 文字を最小まで下げても役割の大小関係が保たれる
    @ComponentSnapshot(width: 360, height: 300)
    func smallestSize() -> some View {
        Self.ramp.dynamicTypeSize(.xSmall)
    }

    @Test func snapshots() {
        for snapshotCase in Self.__snapshotCases { snapshotCase.run() }
    }
}

// MARK: - ReadableWidth

@SnapshotSuite("ReadableWidth")
@MainActor
struct ReadableWidthSnapshots {
    init() { setupVisualTesting() }

    private static var body: some View {
        Card(elevation: .level1) {
            Text("本文がここに入ります。1 行が長くなりすぎると視線が行頭に戻れなくなるため、読みやすい幅で頭打ちにする。")
                .typography(.bodyLarge)
        }
        .padding()
    }

    /// 横も縦も regular（iPad 全画面）では幅が頭打ちになり中央に寄る
    @ComponentSnapshot(width: 900, height: 200)
    func cappedWhenSpacious() -> some View {
        Self.body
            .readableWidth()
            .environment(\.horizontalSizeClass, .regular)
            .environment(\.verticalSizeClass, .regular)
    }

    /// 横が compact（iPhone 縦・細い分割）では画面幅のまま。
    /// ここで頭打ちにすると余白が増えるだけになる
    @ComponentSnapshot(width: 900, height: 200)
    func untouchedWhenCompact() -> some View {
        Self.body
            .readableWidth()
            .environment(\.horizontalSizeClass, .compact)
            .environment(\.verticalSizeClass, .regular)
    }

    @Test func snapshots() {
        for snapshotCase in Self.__snapshotCases { snapshotCase.run() }
    }
}

// MARK: - LinkCard

@SnapshotSuite("LinkCard")
@MainActor
struct LinkCardSnapshots {
    init() { setupVisualTesting() }

    @ComponentSnapshot(width: 360, height: 140)
    func withTitle() -> some View {
        LinkCard(title: "Swift.org", url: URL(string: "https://www.swift.org/documentation/")!)
            .padding()
    }

    /// title が nil のときはホスト名にフォールバックする
    @ComponentSnapshot(width: 360, height: 140)
    func titleFallsBackToHost() -> some View {
        LinkCard(title: nil, url: URL(string: "https://developer.apple.com/design/")!)
            .padding()
    }

    @ComponentSnapshot(width: 360, height: 160)
    func longTitleTruncates() -> some View {
        LinkCard(
            title: "とても長いタイトルで折り返しと切り詰めの挙動を確認するためのリンクカード",
            url: URL(string: "https://example.com/a/very/long/path/segment/for/truncation")!
        )
        .padding()
    }

    @Test func snapshots() {
        for snapshotCase in Self.__snapshotCases { snapshotCase.run() }
    }
}

// MARK: - TextField

@SnapshotSuite("TextField")
@MainActor
struct TextFieldSnapshots {
    init() { setupVisualTesting() }

    @ComponentSnapshot(width: 360, height: 140)
    func emptyWithPlaceholder() -> some View {
        DSTextField("メールアドレス", text: .constant(""), placeholder: "you@example.com")
            .padding()
    }

    @ComponentSnapshot(width: 360, height: 140)
    func filled() -> some View {
        DSTextField("メールアドレス", text: .constant("kyoichi@example.com"))
            .padding()
    }

    @ComponentSnapshot(width: 360, height: 160)
    func withError() -> some View {
        DSTextField(
            "メールアドレス",
            text: .constant("invalid"),
            error: "メールアドレスの形式が正しくありません"
        )
        .padding()
    }

    @ComponentSnapshot(width: 360, height: 160)
    func withSupportingText() -> some View {
        DSTextField(
            "パスワード",
            text: .constant(""),
            supportingText: "8 文字以上で入力してください"
        )
        .padding()
    }

    @ComponentSnapshot(width: 360, height: 140)
    func filledStyle() -> some View {
        DSTextField("検索", text: .constant("SwiftUI"), style: .filled, leadingIcon: "magnifyingglass")
            .padding()
    }

    @ComponentSnapshot(width: 360, height: 140)
    func disabled() -> some View {
        DSTextField("メールアドレス", text: .constant("kyoichi@example.com"))
            .disabled(true)
            .padding()
    }

    @Test func snapshots() {
        for snapshotCase in Self.__snapshotCases { snapshotCase.run() }
    }
}

// MARK: - Timeline

@SnapshotSuite("Timeline")
@MainActor
struct TimelineSnapshots {
    init() { setupVisualTesting() }

    /// 端では接続線の描き方が変わる。first / middle / last を 1 枚で押さえる
    @ComponentSnapshot(width: 340, height: 260)
    func firstMiddleLast() -> some View {
        VStack(spacing: 0) {
            TimelineRow(isFirst: true) {
                Circle().fill(.blue).frame(width: 10, height: 10)
            } content: {
                Text("作成").typography(.bodyMedium)
            }
            TimelineRow {
                Circle().fill(.blue).frame(width: 10, height: 10)
            } content: {
                Text("レビュー").typography(.bodyMedium)
            }
            TimelineRow(isLast: true) {
                Circle().fill(.blue).frame(width: 10, height: 10)
            } content: {
                Text("公開").typography(.bodyMedium)
            }
        }
        .padding()
    }

    @Test func snapshots() {
        for snapshotCase in Self.__snapshotCases { snapshotCase.run() }
    }
}

// MARK: - Attachment

@SnapshotSuite("Attachment")
@MainActor
struct AttachmentSnapshots {
    init() { setupVisualTesting() }

    @ComponentSnapshot(width: 160, height: 160)
    func fileWithName() -> some View {
        AttachmentThumbnail(systemImage: "doc.text", fileName: "契約書.pdf", onRemove: {})
            .padding()
    }

    @ComponentSnapshot(width: 160, height: 160)
    func longFileNameTruncates() -> some View {
        AttachmentThumbnail(
            systemImage: "doc.text",
            fileName: "とても長いファイル名で切り詰めの挙動を確認する.pdf",
            onRemove: {}
        )
        .padding()
    }

    /// fileName が nil の分岐
    @ComponentSnapshot(width: 160, height: 160)
    func fileWithoutName() -> some View {
        AttachmentThumbnail(systemImage: "paperclip", fileName: nil, onRemove: {})
            .padding()
    }

    @Test func snapshots() {
        for snapshotCase in Self.__snapshotCases { snapshotCase.run() }
    }
}

// MARK: - SegmentedControl

@SnapshotSuite("SegmentedControl")
@MainActor
struct SegmentedControlSnapshots {
    init() { setupVisualTesting() }

    private static let options = ["日", "週", "月"]

    @ComponentSnapshot(width: 340, height: 100)
    func firstSelected() -> some View {
        SegmentedControl(selection: .constant("日"), options: Self.options) { option in
            Text(option)
        }
        .padding()
    }

    @ComponentSnapshot(width: 340, height: 100)
    func lastSelected() -> some View {
        SegmentedControl(selection: .constant("月"), options: Self.options) { option in
            Text(option)
        }
        .padding()
    }

    @Test func snapshots() {
        for snapshotCase in Self.__snapshotCases { snapshotCase.run() }
    }
}
#endif
