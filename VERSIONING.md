# Versioning

This project follows a versioning pattern similar to [Semantic Versioning](https://semver.org/) (SemVer) for managing releases.

## Table of Contents

- [Versioning](#versioning)
  - [Table of Contents](#table-of-contents)
  - [Format](#format)
    - [Examples](#examples)
  - [Release Process](#release-process)
    - [Typical Steps](#typical-steps)
  - [Simple Versioning for This Project](#simple-versioning-for-this-project)
  - [Questions or Issues?](#questions-or-issues)

## Format

Version numbers follow the structure:

`MAJOR.MINOR.PATCH`

- **MAJOR** – Incompatible API changes or major breaking updates  
- **MINOR** – Backward-compatible functionality and feature additions  
- **PATCH** – Backward-compatible bug fixes and small improvements

### Examples

- `1.0.0` – First stable release  
- `1.1.0` – Adds a new endpoint or feature  
- `1.1.1` – Fixes a bug or makes a minor improvement

## Release Process

All notable changes are documented in the [CHANGELOG.md](CHANGELOG.md) file.

### Typical Steps

1. Complete all features and fixes planned for the release
2. Update the `CHANGELOG.md` with categorized entries:  
   - **Added**, **Changed**, **Fixed**, **Removed**
3. Bump the version number in `package.json` (and `package-lock.json` if needed)
4. Commit changes with a version-related message (e.g. `chore: release v1.2.0`)
5. Tag the release:

   ```bash
   git tag v1.2.0
   git push origin v1.2.0
    ````

6. (Optional) Create a GitHub release and paste the relevant changelog section

## Pre-release Versions

For beta or release candidates, we use suffixes:

- `1.2.0-beta.1` – Beta release
- `2.0.0-rc.1` – Release candidate

These versions are intended for testing and may not be fully stable.

## Viewing Tags & Differences

List all version tags:

```bash
git tag
```

View differences between versions:

```bash
git log v1.1.0..v1.2.0
```

## Simple Versioning for This Project

Since this is a simple project, we will **not use the full `MAJOR.MINOR.PATCH` (`x.y.z`) format**.
Instead, we will use only `MAJOR.MINOR` (`x.y`) versions to keep things simple and easy to manage:

- `1.0` – First stable release
- `1.1` – Adds a new feature
- `1.2` – Minor improvements or fixes

This is sufficient for tracking releases without overcomplicating the versioning scheme.

## Questions or Issues?

If you have questions about the versioning strategy or encounter version-related problems, feel free to open an issue on the [GitHub repository](https://github.com/dileepadev/trashpick/issues).
