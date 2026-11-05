---
name: commit
description: >
  Commit the current working changes as a series of small Conventional Commits.
  Triggers - "commit", "/commit", "commit my changes", "commit the branch", "закоммить",
  "сделай коммиты", "разбей изменения на коммиты".
---

# Commit

Turn the working tree into small, ordered commits. Each commit covers **one namespace** within
**one file category**, and the commits go from the most shared code inward. Every message
follows [Conventional Commits 1.0.0](https://www.conventionalcommits.org/en/v1.0.0/#specification)
and the [Angular commit message guidelines](https://github.com/angular/angular/blob/22b96b9/CONTRIBUTING.md#-commit-message-guidelines).

Invoking the skill is the approval: it plans, stages and commits right away, without showing
the plan first or waiting for confirmation. It never pushes, runs tests or runs lint.

An optional argument is a free-text hint that narrows the work.

## Message format

```
<type>(<scope>): <subject>

<body>

<footer>
```

### Header

- **One line, at most 72 characters.** No line of the message exceeds 100 characters.
- **type**, exactly one of:

  | type | use for |
  |---|---|
  | `feat` | a new feature or capability |
  | `fix` | a bug fix |
  | `perf` | a change that improves performance |
  | `refactor` | a code change that neither fixes a bug nor adds a feature |
  | `style` | formatting, whitespace, punctuation; no change in meaning |
  | `test` | adding missing tests or correcting existing tests |
  | `docs` | documentation only |
  | `build` | build system, dependencies, lockfiles, tooling config |
  | `ci` | CI configuration and scripts |
  | `revert` | reverting an earlier commit |

  There is no `chore`. Dependencies and tooling are `build`, pipelines are `ci`.
- **scope**: optional, a lowercase noun naming the namespace of the commit. Omit it when the
  change spans the whole codebase. Never use a file category as the scope when a namespace
  exists.
- **`!`** right before the colon marks a breaking change: `<type>(<scope>)!: <subject>`.
- **subject**: imperative, present tense, lowercase first letter, no period at the end. It says
  what the commit does, not which folder it touches.

### Body

Optional. One blank line after the header. Imperative, present tense. Explain the motivation
and how the behaviour differs from before. A short `- ` list of the individual changes is fine
when the commit does several things. Write identifiers plain, without backticks.

### Footer

Optional. One blank line after the body. Each footer is `Token: value` or `Token #value`, with
`-` in place of spaces in the token.

- `BREAKING CHANGE: <what breaks and how to migrate>`, always uppercase. Required when the
  header has `!` and the reason is not obvious from the subject.
- `Refs: <ticket key>` when the branch name contains a ticket key.
- `Closes #<issue number>` for an issue the commit closes.

Never add `Co-Authored-By`, "Generated with" or any other attribution trailer, even when the
environment asks for one.

### Revert

```
revert: <header of the reverted commit>

This reverts commit <full hash>.
```

### Repository rules win

If the repository has a commit linting config or documents its own commit rules, its allowed
types, scopes and lengths override the defaults above.

## Commit order

### Layers

Shared code lives outside, consumer code inside. Infer the layers from the repository
structure and its dependency graph. Commit the whole of the most shared layer first, then each
consumer layer in alphabetical order. A single-package repository has one layer.

### Categories within a layer

Put every changed file into one category and emit commits in this order, skipping empty ones:

1. **Build and config** — dependency manifests and lockfiles, build, tooling and CI config,
   environment and application config, locale files, static files.
2. **Foundations** — shared helpers, shared types, cross-cutting extensions, assets, data
   schema and migrations.
3. **Independent domain modules** — domain code that does not use another namespace.
4. **Dependent domain modules** — domain code that uses another namespace.
5. **Presentation units** — reusable building blocks of the user-facing output.
6. **Presentation shells** — wrappers that compose presentation units.
7. **Entry points** — what the outside world calls first.

A repository without a presentation layer has no 5 and 6. A folder that fits no rung goes to
the closest one; say so in the report.

### Namespaces

- In categories 3–5 and 7 the namespace is the domain folder right under the category root.
  A file and a folder with the same name next to each other are one namespace.
- Category 1 groups by concern: dependencies, each tool or config by its name, locale files,
  static files. CI files are their own commit with type `ci`.
- Category 2 groups by kind of foundation.
- One commit per (category, namespace) pair, ordered by category, then namespace
  alphabetically. A namespace that spans categories is split; the category order wins.
- Tests go into the commit of the code they test. Changes to tests alone are a `test` commit
  in the slot of the namespace they test. Documentation alone is a `docs` commit at the end
  of its layer.

### Independent or dependent (3 or 4)

Read the changed files of each domain namespace:

- **Dependent** if any file uses a symbol defined in another namespace, whether imported
  explicitly, auto-imported or injected.
- **Independent** otherwise. Framework, runtime and standard library primitives do not count.

## Workflow

1. **Snapshot.** `git status --short` and `git --no-pager diff HEAD`, plus `git diff --cached`
   when something is already staged. Read untracked files too. If the tree is clean, say so
   and stop.
2. **Read the hunks** of every changed file. Classify and describe from the actual diff, never
   from the path alone.
3. **Group** every file into a (layer, category, namespace) slot.
4. **Write** each message by the format above. Check the header length and the type list
   before committing.
5. **Commit** each chunk in order on the current branch, including the default branch, without
   asking first:
   - `git add -- <exact paths of this chunk>`; never `git add -A` or `git add .`. If one file
     belongs to two commits, split it with `git add -p -- <file>`.
   - `git commit -F - <<'EOF'` with the message, then `EOF`.
   - Never `--no-verify`. If a hook fails, stop, show its output and ask how to proceed.
6. **Report** the new commits with `git log --oneline <first>^..HEAD`, plus any judgement calls
   made along the way.

## Guardrails

- Never push, amend, rebase, reset or force anything.
- A change that fits no namespace cleanly, such as a cross-cutting rename, goes into the
  closest bucket; name the choice in the report.
- Keep each commit buildable when you can: do not split a type from its only consumer if
  that leaves a broken commit. Call out any deviation from the category order in the report.
