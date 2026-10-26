import Testing
@testable import DesignSystem

@MainActor
struct ShineScheduleTests {
    @Test func firesTimesThenStops() async {
        let schedule = ShineSchedule(interval: .seconds(4), times: 3, firstDelay: .milliseconds(1200))
        var sleeps: [Duration] = []
        var fired = 0
        await schedule.run(sleep: { sleeps.append($0) }, fire: { fired += 1 })
        #expect(fired == 3)
        #expect(sleeps == [.milliseconds(1200), .seconds(4), .seconds(4)])
    }

    @Test func stopsWhenSleepIsInterrupted() async {
        struct Interrupted: Error {}
        let schedule = ShineSchedule(interval: .seconds(4), times: 3, firstDelay: .zero)
        var fired = 0
        var calls = 0
        await schedule.run(sleep: { _ in
            calls += 1
            if calls == 2 { throw Interrupted() }
        }, fire: { fired += 1 })
        #expect(fired == 1)
    }

    @Test func zeroTimesNeverFires() async {
        var fired = 0
        await ShineSchedule(interval: .seconds(1), times: 0, firstDelay: .zero).run(sleep: { _ in }, fire: { fired += 1 })
        #expect(fired == 0)
    }

    @Test func resumingRunsOnlyTheSweepsLeft() async {
        var fired = 0
        await ShineSchedule(interval: .seconds(4), times: 3, firstDelay: .zero).run(alreadyFired: 2, sleep: { _ in }, fire: { fired += 1 })
        #expect(fired == 1)
    }

    @Test func runsOnlyWhenActiveVisibleAndMotionAllowed() {
        #expect(ShineSchedule.shouldRun(isActive: true, reduceMotion: false, sceneIsActive: true))
        #expect(!ShineSchedule.shouldRun(isActive: false, reduceMotion: false, sceneIsActive: true))
        #expect(!ShineSchedule.shouldRun(isActive: true, reduceMotion: true, sceneIsActive: true))
        #expect(!ShineSchedule.shouldRun(isActive: true, reduceMotion: false, sceneIsActive: false))
    }
}
