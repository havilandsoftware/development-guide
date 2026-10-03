# Writing CLAUDE.md and AGENTS.md

`CLAUDE.md` (Claude Code) and `AGENTS.md` (the cross-tool convention) are loaded into **every**
agent session in the repository. Every line is read on every task, and every wrong line is acted
on. Write them like code: short, accurate, reviewed.

Authoritative references — read these rather than a summary of them:

- [Claude Code memory (CLAUDE.md)](https://docs.claude.com/en/docs/claude-code/memory) — where the
  files live, how nested files load, `@path` imports
- [AGENTS.md](https://agents.md/) — the cross-tool format

## What belongs in one

- What the project is, in a sentence or two
- The commands to build, test, lint, and run — exactly as they work today
- Conventions an agent can't infer from the code: branch naming, where things go, what not to touch
- Pointers to where the rest lives (`README`, `docs/`, this guide) rather than copies of it

**One source, not two.** If a repo needs both files, keep the shared content in `AGENTS.md` and
make `CLAUDE.md` import it with `@AGENTS.md`, adding only what is Claude-specific. Two hand-kept
copies drift.

## Top 10 Anti-Patterns

`/dev-check` looks for these in the current project's files (Step 5b) and offers to fix them in a
pull request.

| # | Anti-pattern | Looks like | Do instead |
|---|---|---|---|
| 1 | **Bloat** | Hundreds of lines, most of them irrelevant to a given task | Keep it to what every session needs, a few hundred lines at most. Move detail to `docs/` and link or `@`-import it |
| 2 | **Duplicating the codebase** | Directory trees, file inventories, endpoint lists, changelogs | Say where to look. The repo is the source of truth, and the copy rots the day it's written |
| 3 | **Snapshots that rot** | "Latest release: 1.4", "12 open tickets", versions, dates written as current | Name the command that gives the live answer (`gh release list`, `innoday tickets list`) |
| 4 | **Vague rules** | "Write clean code", "be careful with the database" | A rule a reviewer could check: "Migrations go through Alembic; never edit the schema by hand" |
| 5 | **Emphasis inflation, no reasons** | CRITICAL / MUST / NEVER on every other line | Save emphasis for the few rules where a mistake is costly, and give the reason. An agent applies a rule better when it knows why |
| 6 | **Contradictions** | Global, workspace and repo files disagree, or `CLAUDE.md` and `AGENTS.md` do (`HS-123-…` vs `feature/…`) | One owner per rule. The repo file overrides with a stated reason, and never silently |
| 7 | **Secrets and private details** | Tokens, connection strings, internal URLs, client names, `/home/<user>/…` paths, personal emails | Point to the password manager or the env var name. Treat a public repo's file as published |
| 8 | **Broken content** | Unclosed code fences, empty headings, `[TODO]`, references to files or commands that no longer exist | Read it rendered, and run every command in it. CI can catch unclosed fences and dead links |
| 9 | **Copy-paste and hand-edited generated blocks** | The same standards block pasted into every repo; edits inside an auto-generated section | Link to the one source (this guide). Change a generated section through its generator, never by hand |
| 10 | **One-size process mandates** | "Every change must go through the full multi-agent workflow" — including a one-line typo fix | Scale the process to the change, and say where the threshold is |

## Reviewing One

Before merging a change to either file, ask of each line: would an agent do the wrong thing
without it? If not, cut it. Then check the commands still run.
