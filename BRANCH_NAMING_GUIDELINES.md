# Branch Naming Guidelines

When creating a new branch, please follow this naming convention to maintain consistency and clarity in communication regarding the nature of changes.

## Protected Branches

These branches are protected and can only be updated by repository administrators. As a contributor, do **not** commit directly to these branches.

| Branch Name | Description                                                                            |
| ----------- | -------------------------------------------------------------------------------------- |
| `main`      | The stable, production-ready version of the website.                                   |
| `dev`       | The development branch containing features and bug fixes not yet ready for production. |

## Contributing Branches

These branches are open for contributions from all contributors. Follow these naming conventions when creating a new branch:

| Branch Name  | Description                                                                                            |
| ------------ | ------------------------------------------------------------------------------------------------------ |
| `feat/x`     | A branch for adding new features or enhancing functionality. Replace `x` with a short description.     |
| `fix/x`      | A branch for fixing bugs. Replace `x` with a description of the issue being addressed.                 |
| `docs/x`     | A branch for documentation updates. Replace `x` with a description of the documentation being updated. |
| `style/x`    | A branch for code style changes (formatting, spacing, etc.). Replace `x` with the style change.        |
| `refactor/x` | A branch for code refactoring that doesn’t change functionality. Replace `x` with a description.       |
| `perf/x`     | A branch for performance improvements. Replace `x` with the specific performance enhancement.          |
| `test/x`     | A branch for adding or modifying tests. Replace `x` with the test being added or modified.             |
| `chore/x`    | A branch for routine tasks or maintenance (e.g., upgrading dependencies). Replace `x` with the task.   |

## Examples

Here are a few examples of valid branch names:

- `feat/user-auth` - Add user authentication feature.
- `fix/login` - Bug fix for the login functionality.
- `docs/readme` - Update to the README documentation.
- `style/formatting` - Code style formatting changes.
- `refactor/database` - Refactor the database connection handling.
- `test/authentication` - Tests for the authentication service.
- `chore/dependencies` - Update dependencies.
