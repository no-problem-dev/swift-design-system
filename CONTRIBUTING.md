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

**Verification happens here, not in CI.** The release workflow does not build or
test — it only turns a tag into a GitHub Release. Run both commands locally and
make sure they pass before opening a pull request.

Documentation lives in the DocC catalog under `Sources/*/*.docc/`. Public
declarations are documented with `///` comments, in English.

## Releasing

Maintainers only. The version is **computed, never chosen**:

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
