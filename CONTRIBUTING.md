# Contributing

Thanks for taking the time to look at this package.

## Reporting a problem

Open an issue with the smallest example that reproduces it, the Swift and Xcode
versions you're on, and the platform you're targeting. A failing test is the
clearest possible report.

## Working on a change

```bash
swift build --build-tests
swift test
```

**There is no CI.** Run both commands locally and make sure they pass before
opening a pull request.

Documentation lives in the DocC catalog under `Sources/*/*.docc/`. Public
declarations are documented with `///` comments, in English.

## Releasing

Maintainers only.

1. In `CHANGELOG.md`, turn `## [Unreleased]` into `## [x.y.z] - YYYY-MM-DD` and
   merge that to `main`.
2. Tag the merge and push the tag:

   ```bash
   git tag x.y.z && git push origin x.y.z
   ```

Versions follow [SemVer](https://semver.org) with bare tags (`1.2.3`, no `v`).
While the major version is 0, a breaking change bumps the minor version.
