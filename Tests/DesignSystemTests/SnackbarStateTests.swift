import XCTest
@testable import DesignSystem

/// `SnackbarState` の表示状態と自動消滅タイマーの検証。
///
/// タイマーは実時間で動くため、テストは 50ms 級の短い duration を使い、
/// 「まだ消えていないこと」と「もう消えたこと」を別々の待機時間で確認する。
///
/// duration に負値を渡すと `UInt64(duration * 1_000_000_000)` がトラップして
/// プロセスごと落ちるため、負値のテストは書かない（実装側のガード欠如）。
@MainActor
final class SnackbarStateTests: XCTestCase {

    /// 実時間の待機。タイマー起動と観測の間に挟む
    private func wait(seconds: Double) async {
        try? await Task.sleep(nanoseconds: UInt64(seconds * 1_000_000_000))
    }

    // MARK: - 初期状態

    func testInitialStateIsHiddenWithEmptyMessage() {
        let state = SnackbarState()

        XCTAssertFalse(state.isVisible)
        XCTAssertEqual(state.message, "")
        XCTAssertNil(state.primaryAction)
        XCTAssertNil(state.secondaryAction)
    }

    // MARK: - show

    func testShowMakesVisibleAndStoresMessage() {
        let state = SnackbarState()

        state.show(message: "保存しました", duration: 10)

        XCTAssertTrue(state.isVisible)
        XCTAssertEqual(state.message, "保存しました")
    }

    func testShowStoresBothActions() {
        let state = SnackbarState()

        state.show(
            message: "削除しました",
            primaryAction: SnackbarAction(title: "元に戻す") {},
            secondaryAction: SnackbarAction(title: "閉じる") {},
            duration: 10
        )

        XCTAssertEqual(state.primaryAction?.title, "元に戻す")
        XCTAssertEqual(state.secondaryAction?.title, "閉じる")
    }

    func testShowWithoutActionsClearsPreviousActions() {
        let state = SnackbarState()

        state.show(message: "1回目", primaryAction: SnackbarAction(title: "元に戻す") {}, duration: 10)
        state.show(message: "2回目", duration: 10)

        XCTAssertEqual(state.message, "2回目")
        XCTAssertNil(state.primaryAction)
        XCTAssertNil(state.secondaryAction)
    }

    // MARK: - dismiss

    func testDismissHidesSnackbar() {
        let state = SnackbarState()

        state.show(message: "メッセージ", duration: 10)
        state.dismiss()

        XCTAssertFalse(state.isVisible)
    }

    func testDismissKeepsMessageForExitAnimation() {
        // dismiss は isVisible だけを倒す。message は消さない（退場アニメ中の描画用）
        let state = SnackbarState()

        state.show(message: "メッセージ", duration: 10)
        state.dismiss()

        XCTAssertEqual(state.message, "メッセージ")
    }

    func testDismissOnHiddenStateIsNoOp() {
        let state = SnackbarState()

        state.dismiss()

        XCTAssertFalse(state.isVisible)
    }

    func testDismissCancelsAutoDismissTimer() async {
        let state = SnackbarState()

        state.show(message: "メッセージ", duration: 0.05)
        state.dismiss()
        state.show(message: "再表示", duration: 10)

        // 最初のタイマーが生きていれば 0.05 秒後に消える
        await wait(seconds: 0.2)
        XCTAssertTrue(state.isVisible)
        XCTAssertEqual(state.message, "再表示")
    }

    // MARK: - 自動消滅タイマー

    func testAutoDismissFiresAfterDuration() async {
        let state = SnackbarState()

        state.show(message: "メッセージ", duration: 0.05)
        XCTAssertTrue(state.isVisible)

        await wait(seconds: 0.3)
        XCTAssertFalse(state.isVisible)
    }

    func testAutoDismissDoesNotFireBeforeDuration() async {
        let state = SnackbarState()

        state.show(message: "メッセージ", duration: 1.0)

        await wait(seconds: 0.1)
        XCTAssertTrue(state.isVisible)
    }

    func testSecondShowCancelsFirstAutoDismissTimer() async {
        let state = SnackbarState()

        // 短命の 1 回目を、長命の 2 回目で上書きする
        state.show(message: "1回目", duration: 0.05)
        state.show(message: "2回目", duration: 5.0)

        // 1 回目のタイマーがキャンセルされていなければ 0.05 秒後に消える
        await wait(seconds: 0.3)
        XCTAssertTrue(state.isVisible)
        XCTAssertEqual(state.message, "2回目")
    }

    func testLatestDurationGovernsAutoDismiss() async {
        let state = SnackbarState()

        // 長命の 1 回目を、短命の 2 回目で上書きする
        state.show(message: "1回目", duration: 5.0)
        state.show(message: "2回目", duration: 0.05)

        await wait(seconds: 0.3)
        XCTAssertFalse(state.isVisible)
        XCTAssertEqual(state.message, "2回目")
    }

    func testZeroDurationDismissesImmediately() async {
        // UInt64(0 * 1e9) == 0 なのでトラップせず、次のスケジュールで消える
        let state = SnackbarState()

        state.show(message: "メッセージ", duration: 0)
        XCTAssertTrue(state.isVisible)

        await wait(seconds: 0.1)
        XCTAssertFalse(state.isVisible)
    }

    func testDefaultDurationKeepsSnackbarVisibleShortTerm() async {
        // デフォルト 5 秒。短い待機では消えない
        let state = SnackbarState()

        state.show(message: "メッセージ")

        await wait(seconds: 0.1)
        XCTAssertTrue(state.isVisible)
    }

    // MARK: - SnackbarAction

    func testSnackbarActionStoresTitleAndRunsHandler() async {
        let box = RunFlag()
        let action = SnackbarAction(title: "元に戻す") { box.didRun = true }

        XCTAssertEqual(action.title, "元に戻す")
        XCTAssertFalse(box.didRun)
        await action.action()
        XCTAssertTrue(box.didRun)
    }
}

/// ハンドラ実行を記録するための参照型
@MainActor
private final class RunFlag {
    var didRun = false
}
