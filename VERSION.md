# Version Information

**Current Version:** 1.2.0

**Last Updated:** 2026-01-25

**Build:** d232a87

## Version History

See [CHANGELOG.md](CHANGELOG.md) for detailed release notes.

## Semantic Versioning

This project follows [Semantic Versioning 2.0.0](https://semver.org/):

- **MAJOR** version for breaking changes to workshop structure or challenge flow
- **MINOR** version for new challenges, scenarios, or significant workshop enhancements
- **PATCH** version for bug fixes, documentation improvements, timing corrections

## Automated Versioning

Version bumps are automated via GitHub Actions based on [Conventional Commits](https://www.conventionalcommits.org/):

| Commit Type                    | Version Bump | Example                         |
| ------------------------------ | ------------ | ------------------------------- |
| `feat:`                        | Minor        | `feat: add new challenge`       |
| `fix:`                         | Patch        | `fix: correct timing`           |
| `feat!:` or `BREAKING CHANGE:` | Major        | `feat!: redesign workshop flow` |
| `docs:`, `chore:`, etc.        | None         | `docs: update README`           |
