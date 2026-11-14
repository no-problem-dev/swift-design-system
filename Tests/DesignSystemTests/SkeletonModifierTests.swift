import Testing
@testable import DesignSystem

struct SkeletonModifierTests {
    @Test func sweepsOnlyWhileRedactedAndMotionIsAllowed() {
        #expect(SkeletonModifier.sweeps(isRedacted: true, reduceMotion: false))
        #expect(!SkeletonModifier.sweeps(isRedacted: true, reduceMotion: true))
        #expect(!SkeletonModifier.sweeps(isRedacted: false, reduceMotion: false))
        #expect(!SkeletonModifier.sweeps(isRedacted: false, reduceMotion: true))
    }
}
