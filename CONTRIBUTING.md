# Contributing

Thanks for taking the time to look at this package.

## Reporting a problem

Open an issue with the smallest example that reproduces it, the Swift and Xcode
versions you're on, and the platform you're targeting. A failing test is the
clearest possible report.

## Working on a change

```bash
swift build
swift test
```

**CI runs `swift build` and `swift test` on every push and pull request**
(`.github/workflows/tests.yml`), resolving dependencies fresh rather than from a
cache. That run is the authority: a local `.build` left over from an earlier
resolve can report green where a fresh checkout does not. Run both commands
locally first anyway — it is faster than waiting for a runner.

Snapshot tests are the exception and do not run in CI: the recorded pixels follow
the host simulator's scale, so they are compared locally with
`xcodebuild test -destination 'platform=iOS Simulator,...'`. Wrap image-test files
in `#if canImport(UIKit)` so the macOS run leaves them out.

Documentation lives in the DocC catalog under `Sources/*/*.docc/`. Public
declarations are documented with `///` comments, in English.

## Releasing

Maintainers only. Release from a commit whose Tests run is green — `release-on-tag.yml`
turns a tag into a GitHub Release and nothing else, so nothing is compiled on the
way out. The version is **computed, never chosen**:

```bash
scripts/release.sh --dry-run   # see what version the API diff implies
scripts/release.sh             # stamp CHANGELOG, tag, push
```

Write what changed under `## [Unreleased]` in `CHANGELOG.md` — prose only, no
version number. `scripts/release.sh` compares the public API against the last
release and derives the version from the actual difference: a removed or changed
public symbol means a major, additions mean a minor, and a change in the
generation of a dependency whose types appear in this package's public API also
means a major.
