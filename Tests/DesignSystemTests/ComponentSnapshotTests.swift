// スナップショットテスト（swift-visual-testing）
//
// VisualTesting は UIKit ベースのため iOS でのみ実行される（macOS の `swift test` ではコンパイル対象外）。
// 参照画像はレンダラの都合で iOS のバージョンが変わると差分が出るため、記録時と同じランタイムで比較すること。
// 実行方法:
//   xcodebuild test -scheme DesignSystem-Package -destination 'platform=iOS Simulator,name=<simulator>'
// 参照画像の初回記録・再記録:
//   TEST_RUNNER_SNAPSHOT_TESTING_RECORD=all xcodebuild test -scheme DesignSystem-Package \
//     -destination 'platform=iOS Simulator,name=<simulator>'
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

@MainActor
private func setupVisualTesting() {
    VisualTesting.themeApplicable = DesignSystemThemeApplicable()
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

    @Test func snapshots() {
        for snapshotCase in Self.__snapshotCases { snapshotCase.run() }
    }
}

// MARK: - Card

@SnapshotSuite("Card")
@MainActor
struct CardSnapshots {
    init() { setupVisualTesting() }

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

    @ComponentSnapshot(width: 220, height: 80)
    func deletable() -> some View {
        Chip("Swift", systemImage: "tag.fill", onDelete: {})
            .chipStyle(.filled)
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
    func thirtyPercent() -> some View {
        ProgressBar(value: 0.3)
            .padding()
    }

    @ComponentSnapshot(width: 340, height: 60)
    func eightyPercent() -> some View {
        ProgressBar(value: 0.8)
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

    @Test func snapshots() {
        for snapshotCase in Self.__snapshotCases { snapshotCase.run() }
    }
}
#endif
