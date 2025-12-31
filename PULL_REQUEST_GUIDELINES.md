# Pull Request Guidelines

When creating a pull request, please follow the commit message convention for the pull request title. This convention helps in providing a clear and standardized way to communicate the nature of the changes.

## PR Title Format

The pull request title should follow the format:

```md
<type>(<branch>): <message> [#issue_number]
```

- `<type>`: Type of the change. Use one of the following:

  - `feat`: A new feature or enhancement to existing functionality.
  - `fix`: A bug fix or correction of an issue.
  - `docs`: Documentation updates (e.g., README, comments).
  - `style`: Code style changes (e.g., formatting, indentation).
  - `refactor`: Code refactoring or restructuring without changing functionality.
  - `perf`: Performance improvements.
  - `test`: Adding or modifying tests.
  - `chore`: Routine tasks, maintenance, or tooling changes.

- `<branch>`: Branch where the changes are made, e.g., `main`.

- `<message>`: A short, clear, and concise description of the changes.

- `[#issue_number]` (optional): If the pull request is related to a GitHub issue, include the issue number.

## Examples

- `feat(main): Add new footer [#09]`
- `fix(dev): Resolve issue with login [#123]`
- `docs(readme): Update installation instructions`
- `style(main): Format code according to style guide`

Please adhere to this naming convention to maintain consistency and clarity.
