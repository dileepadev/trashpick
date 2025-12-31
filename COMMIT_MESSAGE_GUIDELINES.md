# Commit Message Guidelines

A good commit message should be descriptive and provide context about the changes made. This helps improve code review, debugging, and long-term maintainability.

## Commit Message Format

Use the following format for commit messages:

```md
<type>(<scope>): <short message> (optional issue references)
```

### `<type>`

The `<type>` field indicates the nature of the changes made in the commit. Use one of the following values:

| Type     | Description                                                   |
|----------|---------------------------------------------------------------|
| feat     | A new feature or enhancement to existing functionality.       |
| fix      | A bug fix or correction of an issue.                          |
| docs     | Documentation updates (e.g., README, code comments).          |
| style    | Code style changes (e.g., formatting, indentation, no logic). |
| refactor | Code refactoring without changing external behavior.          |
| perf     | Performance improvements.                                     |
| test     | Adding or modifying tests.                                    |
| chore    | Routine tasks, maintenance, or tooling changes.               |

### `<scope>`

The `<scope>` is optional, but recommended. It helps clarify which part of the project the commit affects. For example:

| Scope         | Description                                           |
|---------------|-------------------------------------------------------|
| repo          | Project-wide configuration or setup                   |
| config        | Build scripts, environment, or settings               |
| auth          | Authentication logic or features                      |
| api           | API endpoints or integrations                         |
| ui            | User interface components or styling                  |
| db            | Database models or queries                            |

### `<short message>`

A concise summary of what the commit does.

#### Writing Tips

- Use the imperative mood (e.g., “Add” not “Added”)
- Capitalize the first letter
- Don’t end with a period
- Keep under 50 characters if possible
- Be specific (e.g., “Add agent tools” > “Update code”)
- Avoid "I", "this commit", or "fix" as vague verbs

### Commit Example Format

```md
<type>(<scope>): <short message> (optional issue references)

<BLANK LINE>
<optional longer description>
```

**Example:**

```md
feat(api): Add login endpoint (fixes #12)

This adds a new login endpoint to the API that allows users to authenticate using their email and password.
```

### Issue References

Use GitHub issue references to link commits to issues.

#### Format

```md
<action> #<issue_number>
```

- `fixes #123` – closes the issue on merge
- `refs #123` – just links the issue

#### Examples

```md
fix(auth): Prevent session expiration bug (fixes #42)
docs(repo): Update contribution guide (refs #17)
```

### Summary Table for Issue Linking (with Scope)

| Purpose                | Example Commit Message                                         | Result                             |
| ---------------------- | -------------------------------------------------------------- | ---------------------------------- |
| Close single issue     | `fix(ui): Resolve button alignment issue (fixes #12)`          | Links & closes issue #12           |
| Reference single issue | `docs(config): Clarify setup instructions (refs #34)`          | Links issue #34 only               |
| Close multiple issues  | `feat(api): Add user registration endpoint (fixes #56, #57)`   | Links & closes issues #56, #57     |
| Reference multiple     | `refactor(db): Optimize query structure (refs #33, #38)`       | Links only                         |

## ✅ Summary Example with All Fields

```md
feat(api): Add login endpoint (fixes #12)

This adds a new login endpoint to the API that allows users to authenticate using their email and password.
```
