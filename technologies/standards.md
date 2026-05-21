# Coding Standards

This document is the single source of truth for how we structure, lint, test, version, and deploy projects at Haviland Software. It applies to every repository regardless of language. Standards for Python and JavaScript/TypeScript are fully specified; other languages apply the same principles best-effort.

**Prerequisites:** Install your development environment first — see the [Installation and Setup Guide](../getting-started/installation-and-setup-guide.md).

---

## Table of Contents

1. [Universal Requirements](#1-universal-requirements)
2. [LTS Version Policy](#2-lts-version-policy)
3. [Python Standards](#3-python-standards)
4. [JavaScript / TypeScript Standards](#4-javascript--typescript-standards)
5. [SQL Standards](#5-sql-standards)
6. [Other Languages and Frameworks](#6-other-languages-and-frameworks)
7. [Approved Infrastructure & Services](#7-approved-infrastructure--services)
8. [GitHub Actions — CI Baseline](#8-github-actions--ci-baseline)
9. [What We Intentionally Don't Enforce](#9-what-we-intentionally-dont-enforce)

---

## 1. Universal Requirements

Every repository — regardless of language — must have the following.

### README.md

Must contain all six sections (from the [Git standards](git.md)):

- Title and summary
- Prerequisites and installations
- Build
- Run
- Test
- Troubleshooting

If a section doesn't apply, include the heading with "N/A — [reason]".

### CLAUDE.md

Every repo gets a `CLAUDE.md` at root containing at minimum:

- What this repo does (one paragraph)
- How to run tests
- Any non-obvious patterns or constraints

### .gitignore

Must be present and cover at minimum:

- `.env` and `.env.*` — never commit secrets
- Language build artifacts: `__pycache__/`, `*.pyc`, `.venv/`, `node_modules/`, `dist/`, `.next/`
- IDE files: `.idea/`, `.vscode/` (unless team-shared settings are committed intentionally)
- OS files: `.DS_Store`, `Thumbs.db`

Start from the language-appropriate template at [github.com/github/gitignore](https://github.com/github/gitignore).

### .env.example

Every project with environment variables must commit a `.env.example` listing all required keys with values blanked out:

```bash
# .env.example
DATABASE_URL=postgresql://user:password@localhost:5432/mydb
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_ANON_KEY=your-anon-key
NEXT_PUBLIC_API_URL=http://localhost:3000
```

`.env` is always in `.gitignore`. `.env.example` is always committed.

### Environment Tiers

Every project that connects to external services defines three tiers:

| Tier | Purpose | Config source |
|------|---------|---------------|
| `local` | Developer's machine | `.env` (gitignored, copied from `.env.example`) |
| `dev` | Shared development environment | Platform environment variables (Vercel, AWS, etc.) |
| `prod` | Production | Platform environment variables, restricted access |

The README must document:
- How to set up the local environment (copy `.env.example` → `.env`, fill in values)
- Where dev/prod variables are managed (e.g. "Vercel dashboard → Settings → Environment Variables")
- Which variables differ between tiers

### Versioning

All applications use [Semantic Versioning](https://semver.org/) (`MAJOR.MINOR.PATCH`):

- `MAJOR` — breaking changes
- `MINOR` — new features, backwards compatible
- `PATCH` — bug fixes

Version is bumped as part of the release process via `github-ops`.

**Python** — version in `pyproject.toml`:

```toml
[project]
name = "my-package"
version = "1.2.0"
description = "What this package does"
```

**JavaScript/TypeScript** — version in `package.json`. Required fields:

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

### Secret Removal Procedure

If credentials or secrets are discovered in git history:

1. **Rotate immediately** — treat the secret as compromised regardless of whether it was pushed to a remote
2. **Remove from history** using `git-filter-repo`:
   ```bash
   pip install git-filter-repo

   # Remove files matching a pattern
   git filter-repo --path-glob '*.env' --invert-paths

   # Or remove a specific string across all history
   git filter-repo --replace-text <(echo 'ACTUAL_SECRET==>REMOVED')
   ```
3. **Force-push all branches** after the history rewrite — coordinate with the team first
4. **Notify** the team and rotate access on any affected service

Do not use `git rebase` or `git commit --amend` alone — they do not rewrite full history.

### Branch Protection

- `main` is protected: direct pushes blocked, PR + at least 1 reviewer required
- CI status checks must pass before merge (once CI is configured)

---

## 2. LTS Version Policy

Run on actively supported LTS versions. Using an end-of-life runtime is a tracked issue, not a blocking error — document it in the README.

| Runtime | Minimum Version | Current LTS | Check |
|---------|----------------|-------------|-------|
| Python  | 3.11+          | 3.12 / 3.13 | `python --version` |
| Node.js | 22 LTS+        | 22 LTS      | `node --version` |
| Other   | Latest LTS at project creation | — | Document in README |

Projects below minimum version add to their README:

```markdown
## Known Issues
- Runtime: Python X.Y — below minimum supported version (3.11). Upgrade tracked in [issue link].
```

---

## 3. Python Standards

**Prerequisites:** See [Installation and Setup Guide](../getting-started/installation-and-setup-guide.md) for Python 3.11+ and uv installation.

### Project Structure

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
├── uv.lock
├── .python-version
├── .gitignore
├── .env.example
├── Dockerfile
├── .github/
│   └── workflows/
│       └── ci.yml
├── CLAUDE.md
└── README.md
```

- All application code lives under `src/<package_name>/` (snake_case, matching repo name)
- Tests mirror the `src/` structure under `tests/`
- No top-level script files (`app.py`, `run.py`) at the repo root

### Dependency Management

Use `uv` exclusively. No bare `pip install`. No `requirements.txt` as primary dependency file.

```bash
# Start a new project
uv init my-project
cd my-project

# Add a runtime dependency
uv add fastapi

# Add a dev-only dependency
uv add --dev pytest ruff

# Sync after cloning
uv sync

# Run within the project environment
uv run python -m my_package.main
uv run pytest
```

`pyproject.toml` is the single source of truth. Commit `uv.lock`.

### Linting and Formatting

Use `ruff` for both linting and formatting (replaces black + flake8 + isort).

Add to `pyproject.toml`:

```toml
[tool.ruff]
line-length = 100
target-version = "py311"

[tool.ruff.lint]
select = ["E", "F", "I", "UP"]

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

### Type Hints

Required on all public functions and methods:

```python
# Good
def process_items(items: list[str], limit: int = 10) -> list[str]:
    return items[:limit]

# Bad
def process_items(items, limit=10):
    return items[:limit]
```

Private helpers (`_name`) are exempt but encouraged.

### Testing

Use `pytest`. Test files: `test_<module>.py`. Test functions: `test_<behaviour>`.

```bash
uv run pytest
uv run pytest --cov=src --cov-report=term-missing
```

Every public function has at least one test. 100% coverage is not required.

### Dockerfile

Use `python:3.11-slim` as builder. Distroless (`gcr.io/distroless/python3-debian12`) preferred for runtime. If distroless is not viable (e.g. shell required for entrypoint), use `ubuntu:22.04` or `ubuntu:24.04` and document the reason in the Dockerfile.

```dockerfile
# Build stage
FROM python:3.11-slim AS builder
WORKDIR /app
COPY pyproject.toml uv.lock ./
RUN pip install uv && uv sync --frozen --no-dev

# Runtime stage
FROM gcr.io/distroless/python3-debian12
WORKDIR /app
COPY --from=builder /app/.venv /app/.venv
COPY src/ ./src/
ENV PATH="/app/.venv/bin:$PATH"
CMD ["python", "-m", "my_package.main"]
```

---

## 4. JavaScript / TypeScript Standards

**Prerequisites:** See [Installation and Setup Guide](../getting-started/installation-and-setup-guide.md) for Node.js v22 and nvm installation.

TypeScript is required for all new JavaScript projects. Plain JavaScript is acceptable only for one-off scripts and tooling configs. Angular is not in active use; new frontend projects use Next.js.

### Project Structure (Next.js)

```
my-app/
├── app/
│   ├── layout.tsx
│   ├── page.tsx
│   └── api/
│       └── route.ts
├── components/
│   └── Button.tsx
├── lib/
│   └── supabase.ts
├── public/
├── tests/
│   └── button.test.tsx
├── .eslintrc.json
├── .prettierrc
├── next.config.ts
├── tsconfig.json
├── package.json
├── .gitignore
├── .env.example
├── Dockerfile
├── .github/
│   └── workflows/
│       └── ci.yml
├── CLAUDE.md
└── README.md
```

### Linting and Formatting

ESLint + Prettier. Both config files committed to the repo.

`.eslintrc.json`:
```json
{
  "extends": ["next/core-web-vitals", "plugin:@typescript-eslint/recommended"],
  "rules": {
    "@typescript-eslint/no-explicit-any": "warn",
    "@typescript-eslint/explicit-function-return-type": "off"
  }
}
```

`.prettierrc`:
```json
{
  "semi": true,
  "singleQuote": true,
  "tabWidth": 2,
  "trailingComma": "es5",
  "printWidth": 100
}
```

```bash
npx eslint .
npx prettier --check .
npx eslint --fix .
npx prettier --write .
```

### Testing

Vitest for unit and component tests. Playwright for E2E (add when the app has user-facing flows worth automating).

```bash
npm install --save-dev vitest @testing-library/react @testing-library/jest-dom
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

### Dockerfile

Multi-stage build, `node:22-alpine`, non-root user.

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

## 5. SQL Standards

Used with Supabase (PostgreSQL).

- **Migrations only** — never hand-edit schema in production
- **Naming**: snake_case for tables and columns; plural table names (`users`, `orders`)
- **Foreign keys**: always explicit, always indexed
- **No `SELECT *`** in application code — always name columns
- **Timestamps**: every table gets `created_at TIMESTAMPTZ DEFAULT NOW()` and `updated_at TIMESTAMPTZ DEFAULT NOW()`

```bash
# Create a migration
supabase migration new add_users_table

# Apply locally
supabase db push

# Generate TypeScript types
supabase gen types typescript --local > lib/database.types.ts
```

---

## 6. Other Languages and Frameworks

Projects in Go, Rust, Java, or other languages apply the same principles:

| Principle | How to apply |
|-----------|-------------|
| Project structure | Follow the language's idiomatic layout (Go: `cmd/`, `internal/`; Rust: `src/`, `tests/`) |
| Dependency management | Use the language's standard tool (`go mod`, `cargo`) |
| Linting | Use the language's standard linter (`golangci-lint`, `clippy`) |
| Testing | Use the language's standard test runner |
| Dockerfile | Official slim/alpine base image, non-root user |
| GitHub Actions | Lint + test + build on every PR |
| LTS policy | Document runtime version in README, flag if below active LTS |

If a standard cannot be applied (e.g. no Dockerfile for a CLI distributed as a binary), add a "Project Standards Notes" section to the README explaining what applies and what doesn't.

---

## 7. Approved Infrastructure & Services

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
- Database → Supabase (PostgreSQL)
- Background jobs / integrations → Zapier or AWS Lambda
- Container registry → AWS ECR or GitHub Container Registry

---

## 8. GitHub Actions — CI Baseline

Every repo gets `.github/workflows/ci.yml` running on every PR and push to `main`. The workflow runs: secret scan → lint → test → build.

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
      - name: Build Docker image
        uses: docker/build-push-action@v5
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

## 9. What We Intentionally Don't Enforce

| Standard | Decision | Reason |
|----------|----------|--------|
| Docstring format | Google style encouraged, not enforced by CI | Too prescriptive for varied project types |
| 100% test coverage | Not required | Meaningful tests beat metric coverage |
| Mandatory Playwright E2E | Recommended, not required | Overhead too high for small/internal tools |
| Mandatory distroless Docker | Preferred, not required | Some projects need a shell; document when not used |
| TypeScript on legacy JS projects | Not retroactively enforced | Pragmatic for existing codebases |
| Specific ORM or framework | Not mandated | Project needs vary; follow idiomatic choices for the stack |
