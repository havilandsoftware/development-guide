# Coding Standards & Development Guide Consolidation Design

**Date**: 2026-05-20
**Status**: Approved
**Scope**: New `technologies/standards.md` as single authoritative coding standards doc; consolidate `python.md`, `javascript.md`, `angular.md` into it; update `README.md` and cross-links; update `installation-and-setup-guide.md` to point to `standards.md`.

---

## Overview

The development guide currently has strong installation coverage but no actionable coding standards. Developers joining the team have no single reference for how to structure a Python or JavaScript project, which linter to use, what a Dockerfile should look like, or what the CI/CD baseline is.

This change creates `technologies/standards.md` as the single source of truth for project coding standards across all languages and frameworks. The existing per-language installation files (`python.md`, `javascript.md`, `angular.md`) are deleted — their installation content moves to `standards.md` under a Prerequisites pointer, and their thin standards content is replaced by the full standards defined here. The `README.md` navigation and `installation-and-setup-guide.md` links are updated to reflect the new structure.

---

## Goals

- A new developer can open `standards.md` and know exactly how to structure any project
- Standards are specific enough to be machine-checkable (used by `/pixelfuel:project-check` skill in a future phase)
- Standards are best-effort for non-Python/JS languages — not prohibitive
- LTS version policy is explicit: projects below minimum supported versions are flagged
- Secrets and credentials are never committed; procedure for removing them from history is documented
- Every project defines local/dev/prod environment tiers with `.env.example` committed
- All apps are versioned with semver; `package.json` and `pyproject.toml` are always filled out
- What we intentionally don't enforce is documented so developers don't wonder

---

## File Changes

| Action | File |
|--------|------|
| Create | `technologies/standards.md` |
| Delete | `technologies/python.md` |
| Delete | `technologies/javascript.md` |
| Delete | `technologies/angular.md` |
| Modify | `technologies/README.md` → `README.md` (root) |
| Modify | `getting-started/installation-and-setup-guide.md` |
| Modify | `technologies/git.md` |
| Modify | `technologies/claude.md` |

---

## Component 1: `technologies/standards.md`

### Section 1: Universal Requirements

Every repository — regardless of language — must have:

#### README.md
Must contain all six sections from `git.md`:
- Title and summary
- Prerequisites and installations
- Build
- Run
- Test
- Troubleshooting

If a section doesn't apply (e.g. no build step for a script), include the heading with "N/A — [reason]".

#### CLAUDE.md
Every repo gets a `CLAUDE.md` at root with at minimum:
- What this repo does (one paragraph)
- How to run tests
- Any non-obvious patterns or constraints Claude should know

#### .gitignore
Must be present and cover at minimum:
- `.env` and `.env.*` (never commit secrets)
- Language build artifacts (`__pycache__/`, `*.pyc`, `.venv/`, `node_modules/`, `dist/`, `.next/`)
- IDE files (`.idea/`, `.vscode/` unless team-shared settings)
- OS files (`.DS_Store`, `Thumbs.db`)

A language-appropriate `.gitignore` template from [github.com/github/gitignore](https://github.com/github/gitignore) is the starting point.

#### .env.example
Every project with environment variables must commit a `.env.example` file with all required keys listed, values blanked out or set to safe placeholders:

```bash
# .env.example
DATABASE_URL=postgresql://user:password@localhost:5432/mydb
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_ANON_KEY=your-anon-key
NEXT_PUBLIC_API_URL=http://localhost:3000
```

`.env` is always in `.gitignore`. `.env.example` is always committed.

#### Environment Tiers

Every project that connects to external services defines three environment tiers:

| Tier | Purpose | Config source |
|------|---------|--------------|
| `local` | Developer's machine | `.env` (gitignored, copied from `.env.example`) |
| `dev` | Shared development/staging environment | Environment variables set in hosting platform (Vercel, AWS, etc.) |
| `prod` | Production | Environment variables set in hosting platform, restricted access |

The README must document:
- How to set up the local environment (copy `.env.example` → `.env`, fill in values)
- Where dev/prod environment variables are managed (e.g. "Vercel dashboard → Settings → Environment Variables")
- Which variables differ between tiers (e.g. different Supabase project for prod)

#### Secret Removal Procedure

If credentials or secrets are discovered in git history:

1. **Rotate immediately** — treat the secret as compromised regardless of whether it was pushed
2. **Remove from history** using `git filter-repo`:
   ```bash
   pip install git-filter-repo
   git filter-repo --path-glob '*.env' --invert-paths
   # Or to remove a specific string:
   git filter-repo --replace-text <(echo 'ACTUAL_SECRET==>REMOVED')
   ```
3. **Force-push all branches** after history rewrite (coordinate with team)
4. **Notify** the team and any affected service owners

Never use `git rebase` or `git commit --amend` alone — they don't rewrite the full history.

#### Versioning

All applications use [Semantic Versioning](https://semver.org/) (`MAJOR.MINOR.PATCH`):
- `MAJOR` — breaking changes
- `MINOR` — new features, backwards compatible
- `PATCH` — bug fixes

**Python** — version in `pyproject.toml`:
```toml
[project]
name = "my-package"
version = "1.2.0"
```

**JavaScript/TypeScript** — version in `package.json`. `package.json` must always be fully filled out:
```json
{
  "name": "my-app",
  "version": "1.2.0",
  "description": "What this app does",
  "scripts": {
    "dev": "next dev",
    "build": "next build",
    "start": "next start",
    "test": "vitest",
    "lint": "eslint ."
  },
  "engines": {
    "node": ">=22.0.0"
  }
}
```

Required `package.json` fields: `name`, `version`, `description`, `scripts` (with at minimum `dev`, `build`, `test`, `lint`), `engines.node`.

Version is bumped as part of the release process (via `github-ops` tag commands).

#### Branch Protection
- `main` branch: direct pushes blocked, PR + at least 1 reviewer required
- CI status checks must pass before merge (once CI is set up)

---

### Section 2: LTS Version Policy

Projects must run on actively supported LTS versions. Using an end-of-life runtime is a tracked issue, not a blocking error, but must be documented in the README under a "Known Issues" heading.

| Runtime | Minimum Version | Current LTS | Check |
|---------|----------------|-------------|-------|
| Python  | 3.11           | 3.12 / 3.13 | `python --version` |
| Node.js | 22 LTS         | 22 LTS      | `node --version` |
| Any other | Latest LTS at project creation | — | Document in README |

Projects below minimum version must add to their README:
```markdown
## Known Issues
- Runtime: Python X.Y — below minimum supported version (3.11). Upgrade tracked in [issue link].
```

---

### Section 3: Python Standards

**Prerequisites**: See [installation-and-setup-guide.md](../getting-started/installation-and-setup-guide.md) for Python 3.11+ and uv installation.

#### Project Structure

```
my-project/
├── src/
│   └── my_package/
│       ├── __init__.py
│       └── main.py
├── tests/
│   ├── __init__.py
│   └── test_main.py
├── pyproject.toml
├── .gitignore
├── .python-version        # uv: pins Python version
├── Dockerfile
├── CLAUDE.md
└── README.md
```

- All application code lives under `src/<package_name>/`
- Tests mirror the `src/` structure under `tests/`
- No top-level script files (no `app.py`, `run.py` at root)
- Package name is snake_case matching the repo name

#### Dependency Management

Use `uv` exclusively. No bare `pip install`, no `requirements.txt` as primary dependency file.

```bash
# Start a new project
uv init my-project
cd my-project

# Add a dependency
uv add fastapi

# Add a dev dependency
uv add --dev pytest ruff

# Sync dependencies (e.g. after cloning)
uv sync

# Run within the project environment
uv run python -m my_package.main
uv run pytest
```

`pyproject.toml` is the single source of truth for dependencies. Commit `uv.lock`.

#### Linting and Formatting

Use `ruff` for both linting and formatting (replaces black + flake8 + isort).

```toml
# pyproject.toml
[tool.ruff]
line-length = 100
target-version = "py311"

[tool.ruff.lint]
select = ["E", "F", "I", "UP"]  # pycodestyle, pyflakes, isort, pyupgrade

[tool.ruff.format]
quote-style = "double"
```

```bash
# Check
uv run ruff check .
uv run ruff format --check .

# Fix
uv run ruff check --fix .
uv run ruff format .
```

#### Type Hints

Required on all public functions and methods. Use `from __future__ import annotations` for forward references.

```python
# Good
def process_items(items: list[str], limit: int = 10) -> list[str]:
    ...

# Bad — missing type hints on public function
def process_items(items, limit=10):
    ...
```

Private/internal helpers (`_name`) are exempt but encouraged.

#### Testing

Use `pytest`. Test files named `test_<module>.py`, test functions named `test_<behaviour>`.

```bash
# Run all tests
uv run pytest

# With coverage report
uv run pytest --cov=src --cov-report=term-missing
```

Minimum: every public function has at least one test. 100% coverage is not required — meaningful tests over metric coverage.

#### Dockerfile

Use `python:3.11-slim` as base. Distroless (`gcr.io/distroless/python3`) is preferred for production images where no shell is needed.

```dockerfile
# Build stage
FROM python:3.11-slim AS builder
WORKDIR /app
COPY pyproject.toml uv.lock ./
RUN pip install uv && uv sync --frozen --no-dev

# Runtime stage — distroless preferred
FROM gcr.io/distroless/python3-debian12
WORKDIR /app
COPY --from=builder /app/.venv /app/.venv
COPY src/ ./src/
ENV PATH="/app/.venv/bin:$PATH"
CMD ["python", "-m", "my_package.main"]
```

If distroless is not viable (e.g. requires shell for entrypoint scripts), use `ubuntu:22.04` or `ubuntu:24.04`. Document the reason in the Dockerfile as a comment.

---

### Section 4: JavaScript / TypeScript Standards

**Prerequisites**: See [installation-and-setup-guide.md](../getting-started/installation-and-setup-guide.md) for Node.js v22 and nvm installation.

#### Language Policy

TypeScript is required for all new JavaScript projects. Plain JavaScript is acceptable only for one-off scripts and tooling configs.

#### Project Structure (Next.js)

```
my-app/
├── app/                   # Next.js App Router
│   ├── layout.tsx
│   ├── page.tsx
│   └── api/
│       └── route.ts
├── components/
│   └── Button.tsx
├── lib/                   # Shared utilities, API clients
│   └── supabase.ts
├── public/
├── tests/
│   └── button.test.tsx
├── .eslintrc.json
├── .prettierrc
├── next.config.ts
├── tsconfig.json
├── package.json
├── Dockerfile
├── CLAUDE.md
└── README.md
```

#### Linting and Formatting

ESLint + Prettier. Both config files committed to the repo.

```json
// .eslintrc.json
{
  "extends": ["next/core-web-vitals", "plugin:@typescript-eslint/recommended"],
  "rules": {
    "@typescript-eslint/no-explicit-any": "warn",
    "@typescript-eslint/explicit-function-return-type": "off"
  }
}
```

```json
// .prettierrc
{
  "semi": true,
  "singleQuote": true,
  "tabWidth": 2,
  "trailingComma": "es5",
  "printWidth": 100
}
```

```bash
# Check
npx eslint .
npx prettier --check .

# Fix
npx eslint --fix .
npx prettier --write .
```

#### Testing

Vitest for unit and component tests. Playwright for E2E (optional, add when the app has user-facing flows worth automating).

```bash
# Install
npm install --save-dev vitest @testing-library/react @testing-library/jest-dom

# Run
npm test
```

```typescript
// tests/button.test.tsx
import { render, screen } from '@testing-library/react';
import { Button } from '../components/Button';

test('renders label', () => {
  render(<Button label="Click me" />);
  expect(screen.getByText('Click me')).toBeInTheDocument();
});
```

#### Dockerfile

Multi-stage build. Use `node:22-alpine` for build and runtime. Non-root user required.

```dockerfile
FROM node:22-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build

FROM node:22-alpine AS runner
WORKDIR /app
ENV NODE_ENV=production
RUN addgroup --system --gid 1001 nodejs && \
    adduser --system --uid 1001 nextjs
COPY --from=builder /app/.next/standalone ./
COPY --from=builder /app/.next/static ./.next/static
USER nextjs
EXPOSE 3000
CMD ["node", "server.js"]
```

---

### Section 5: SQL Standards

Used with Supabase (PostgreSQL).

- **Migrations only** — never hand-edit schema in production. All schema changes go through migration files.
- **Naming**: snake_case for tables, columns, indexes. Plural table names (`users`, `orders`).
- **Foreign keys**: always explicit, always indexed.
- **No `SELECT *`** in application code — always name columns.
- **Timestamps**: every table gets `created_at TIMESTAMPTZ DEFAULT NOW()` and `updated_at TIMESTAMPTZ DEFAULT NOW()`.

```bash
# Create a new migration
supabase migration new add_users_table

# Apply locally
supabase db push

# Generate TypeScript types from schema
supabase gen types typescript --local > lib/database.types.ts
```

---

### Section 6: Other Languages and Frameworks

Projects in Go, Rust, Java, or other languages apply the same principles:

| Principle | How to apply |
|-----------|-------------|
| Project structure | Follow the language's idiomatic layout (Go: `cmd/`, `internal/`, `pkg/`; Rust: `src/`, `tests/`) |
| Dependency management | Use the language's standard tool (`go mod`, `cargo`) |
| Linting | Use the language's standard linter (`go vet`/`golangci-lint`, `clippy`) |
| Testing | Use the language's standard test runner, tests alongside or separate from source |
| Dockerfile | Use the official slim/alpine base image for the language, non-root user |
| GitHub Actions | Lint + test + build on every PR |
| LTS policy | Document runtime version in README, flag if below active LTS |

If a standard cannot be applied (e.g. no Dockerfile because the project is a CLI tool distributed as a binary), document it in the README under a "Project Standards Notes" heading.

---

### Section 7: Approved Infrastructure & Services

| Category | Service | Use case |
|----------|---------|----------|
| Cloud infrastructure | AWS | Backend services, compute, storage, queues |
| Frontend hosting | Vercel | Next.js production deployments |
| Database / Auth | Supabase | PostgreSQL, row-level security, auth, realtime |
| Workflow automation | Zapier | Cross-service automation, no-code integrations |
| Source control | GitHub (`havilandsoftware` org) | All repos, CI/CD via GitHub Actions |

**What goes where:**
- Python API services → AWS (ECS, Lambda, or EC2 depending on scale)
- Next.js frontend → Vercel
- Database → Supabase (Postgres)
- Background jobs / integrations → Zapier or AWS Lambda
- Container registry → AWS ECR or GitHub Container Registry

---

### Section 8: GitHub Actions — CI Baseline

Every repo gets a workflow at `.github/workflows/ci.yml` that runs on every PR and push to `main`.

**Python:**
```yaml
name: CI
on: [push, pull_request]
jobs:
  ci:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
        with:
          fetch-depth: 0
      - name: Secret scan
        uses: trufflesecurity/trufflehog@main
        with:
          extra_args: --only-verified
      - uses: astral-sh/setup-uv@v3
      - run: uv sync --frozen
      - run: uv run ruff check .
      - run: uv run ruff format --check .
      - run: uv run pytest --cov=src
      - uses: docker/build-push-action@v5
        with:
          push: false
```

**JavaScript / TypeScript (Next.js):**
```yaml
name: CI
on: [push, pull_request]
jobs:
  ci:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
        with:
          fetch-depth: 0
      - name: Secret scan
        uses: trufflesecurity/trufflehog@main
        with:
          extra_args: --only-verified
      - uses: actions/setup-node@v4
        with:
          node-version: '22'
          cache: 'npm'
      - run: npm ci
      - run: npx eslint .
      - run: npx prettier --check .
      - run: npm test
      - run: npm run build
```

---

### Section 9: What We Intentionally Don't Enforce

These are conscious decisions, not gaps:

| Standard | Decision | Reason |
|----------|----------|--------|
| Docstring format | Google style encouraged, not enforced by CI | Too prescriptive for varied project types |
| 100% test coverage | Not required | Meaningful tests beat metric coverage |
| Mandatory Playwright E2E | Recommended, not required | Overhead too high for small/internal tools |
| Mandatory distroless Docker | Preferred, not required | Some projects need a shell; document when not used |
| TypeScript in all JS | Required for new projects, not enforced on legacy | Pragmatic for existing codebases |
| Specific ORM/framework | Not mandated | Project needs vary; follow idiomatic choices |

---

## Component 2: Updated `README.md`

Remove individual Python/JavaScript entries from the Technologies section. Replace with `standards.md`. Updated Technologies list:

```markdown
## Technologies
- [Git](technologies/git.md)
- [Coding Standards](technologies/standards.md)
- [Claude Code](technologies/claude.md)
```

---

## Component 3: Updated `installation-and-setup-guide.md`

- Remove links to `python.md#installation` and `javascript.md#installation` (files will be deleted)
- Replace with direct install commands inline (copy the install steps from python.md and javascript.md into the guide)
- Add a note: "For project structure and coding standards, see [Coding Standards](../technologies/standards.md)"

---

## Component 4: Updated `git.md` and `claude.md`

- `git.md`: no content change needed — README template stays there, `standards.md` references it
- `claude.md`: update the company plugin skills list to mention `/pixelfuel:project-check` (coming in phase 2)

---

## What Is Not In Scope (this phase)

- `/pixelfuel:project-check` skill (phase 2 — audits a repo against these standards)
- Auto-fix branch creation (phase 3)
- Filling in the empty process files (`development-lifecycle.md`, `scrum-and-ticketing.md`, etc.)
- Angular documentation (dropped — not in active use)
- Security standards beyond `.gitignore` and secret handling basics
