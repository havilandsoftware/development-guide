# Coding Standards & Development Guide Consolidation Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Create `technologies/standards.md` as the single authoritative coding standards doc, consolidate and delete `python.md`, `javascript.md`, and `angular.md`, and update all cross-links and navigation.

**Architecture:** One new file (`technologies/standards.md`) replaces three existing files. `installation-and-setup-guide.md` absorbs the install steps from the deleted files inline. `README.md`, `git.md`, and `claude.md` get targeted cross-link updates. No new directories needed — all changes are in the existing `technologies/` and `getting-started/` dirs.

**Tech Stack:** Markdown, GitHub (branch protection via `gh api`), development-guide repo at `~/workspaces/hs/development-guide`

---

## Context

Working in the `HS-parallel-dev-ai-guide` branch of `~/workspaces/hs/development-guide`. The spec is at `docs/superpowers/specs/2026-05-20-coding-standards-design.md`. All tasks run from `~/workspaces/hs/development-guide`.

Current file state:
- `technologies/python.md` — install steps + thin uv usage notes → **to be deleted**
- `technologies/javascript.md` — install steps + Next.js/Tailwind notes → **to be deleted**
- `technologies/angular.md` — stub with tutorial links → **to be deleted**
- `getting-started/installation-and-setup-guide.md` — links to python.md and javascript.md for install steps → **needs inline install content**
- `README.md` — lists python.md, javascript.md in Technologies section → **needs update**
- `technologies/git.md` — no changes needed
- `technologies/claude.md` — company plugin skills list → **add project-check mention**

---

## File Map

| Action | File | Responsible for |
|--------|------|----------------|
| Create | `technologies/standards.md` | All coding standards |
| Delete | `technologies/python.md` | (content absorbed) |
| Delete | `technologies/javascript.md` | (content absorbed) |
| Delete | `technologies/angular.md` | (content dropped) |
| Modify | `getting-started/installation-and-setup-guide.md` | Inline Python + Node install steps |
| Modify | `README.md` | Updated Technologies nav |
| Modify | `technologies/claude.md` | Add project-check to skills list |

---

## Task 1: Create `technologies/standards.md`

**Files:**
- Create: `technologies/standards.md`

- [ ] **Step 1: Create the file with all 9 sections**

Create `technologies/standards.md` with the following complete content:

```markdown
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
```

- [ ] **Step 2: Verify the file renders correctly**

```bash
wc -l technologies/standards.md
# Expected: 300+ lines
grep "^## " technologies/standards.md
# Expected: 9 section headers
```

- [ ] **Step 3: Commit**

```bash
git add technologies/standards.md
git commit -m "feat: add technologies/standards.md — unified coding standards"
```

---

## Task 2: Update `installation-and-setup-guide.md` — inline Python and Node install steps

**Files:**
- Modify: `getting-started/installation-and-setup-guide.md`

The current file links to `python.md#installation` and `javascript.md#installation`. Those files will be deleted in Task 4. The install steps need to move inline here.

- [ ] **Step 1: Replace the Install Languages section**

Find this block in `getting-started/installation-and-setup-guide.md`:

```markdown
## Install Languages and Frameworks
- [Python 3.11](../technologies/python.md#installation)
- [Node.js v22](../technologies/javascript.md#installation)
- [Docker](https://docs.docker.com/engine/install/ubuntu)
- [uv (Python dependency manager)](../technologies/python.md#modern-dependency-management-with-uv)
```

Replace it with:

```markdown
## Install Languages and Frameworks

### Python 3.11+

**Ubuntu:**
```bash
sudo apt update
sudo apt install software-properties-common
sudo add-apt-repository ppa:deadsnakes/ppa
sudo apt update
sudo apt install python3.11 python3.11-dev python3.11-venv
```

**macOS:**
```bash
brew update
brew install python@3.11
```

**Windows:** Download the Python 3.11 installer from [python.org/downloads](https://www.python.org/downloads/windows/), run it, and check "Add Python to PATH".

### uv (Python dependency manager)

```bash
curl -LsSf https://astral.sh/uv/install.sh | sh
```

Verify: `uv --version`

### Node.js v22 (via nvm)

```bash
# Install nvm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
source ~/.bashrc

# Install and use Node 22
nvm install 22
nvm use 22

# Make it the default
echo "nvm use 22" >> ~/.bashrc
```

Verify: `node --version` → should show `v22.x.x`

### Docker

Follow the [Docker Engine install guide for Ubuntu](https://docs.docker.com/engine/install/ubuntu).

For project structure and coding standards, see [Coding Standards](../technologies/standards.md).
```

- [ ] **Step 2: Verify no broken links remain**

```bash
grep "python.md\|javascript.md\|angular.md" getting-started/installation-and-setup-guide.md
# Expected: no output
```

- [ ] **Step 3: Commit**

```bash
git add getting-started/installation-and-setup-guide.md
git commit -m "docs: inline Python and Node install steps, remove links to deleted files"
```

---

## Task 3: Update `README.md` navigation

**Files:**
- Modify: `README.md`

- [ ] **Step 1: Replace the Technologies section**

Find this block in `README.md`:

```markdown
## Technologies
- [Git](technologies/git.md)
- [Python](technologies/python.md)
- [JavaScript](technologies/javascript.md)
- [Claude Code](technologies/claude.md)
```

Replace it with:

```markdown
## Technologies
- [Git](technologies/git.md)
- [Coding Standards](technologies/standards.md)
- [Claude Code](technologies/claude.md)
```

- [ ] **Step 2: Verify**

```bash
grep "python.md\|javascript.md\|angular.md" README.md
# Expected: no output
grep "standards.md" README.md
# Expected: one line with the Coding Standards link
```

- [ ] **Step 3: Commit**

```bash
git add README.md
git commit -m "docs: update README nav — replace python/javascript links with standards.md"
```

---

## Task 4: Update `technologies/claude.md`

**Files:**
- Modify: `technologies/claude.md`

- [ ] **Step 1: Add `/pixelfuel:project-check` to the company plugin skills list**

Find this block in `technologies/claude.md`:

```markdown
- `/pixelfuel:build-skill <name>` — guided authoring of a new company skill, committed to a branch and submitted for admin review
```

Replace it with:

```markdown
- `/pixelfuel:build-skill <name>` — guided authoring of a new company skill, committed to a branch and submitted for admin review
- `/pixelfuel:project-check` — audit a repo against company coding standards, report gaps (coming soon)
```

- [ ] **Step 2: Verify**

```bash
grep "project-check" technologies/claude.md
# Expected: one line
grep "python.md\|javascript.md\|angular.md" technologies/claude.md
# Expected: no output
```

- [ ] **Step 3: Commit**

```bash
git add technologies/claude.md
git commit -m "docs: add project-check coming-soon entry to claude.md skills list"
```

---

## Task 5: Delete `python.md`, `javascript.md`, `angular.md`

**Files:**
- Delete: `technologies/python.md`
- Delete: `technologies/javascript.md`
- Delete: `technologies/angular.md`

Before deleting, verify no remaining files link to them.

- [ ] **Step 1: Check for any remaining references**

```bash
grep -r "python\.md\|javascript\.md\|angular\.md" --include="*.md" .
# Expected: no output (all references removed in Tasks 2-4)
```

If any references remain, fix them before proceeding.

- [ ] **Step 2: Delete the files**

```bash
git rm technologies/python.md technologies/javascript.md technologies/angular.md
```

- [ ] **Step 3: Verify deletion**

```bash
ls technologies/
# Expected: claude.md  git.md  standards.md
```

- [ ] **Step 4: Commit**

```bash
git commit -m "docs: remove python.md, javascript.md, angular.md — consolidated into standards.md"
```

---

## Task 6: Set up branch protection on `pixelfuel-claude` `main`

**Context:** This task operates on the `pixelfuel-claude` repo, not the `development-guide` repo. The branch protection must be configured once and doesn't need to be on a branch — it's a GitHub API call.

Admins: `havkarl` (admin), `kengsc` (admin).

- [ ] **Step 1: Create `.github/CODEOWNERS` in `pixelfuel-claude`**

In `~/workspaces/hs/pixelfuel-claude`, on the current branch (`fix/onboard-project-gap-fixes` or a new branch off `main`):

```bash
mkdir -p /home/havkarl/workspaces/hs/pixelfuel-claude/.github
```

Create `/home/havkarl/workspaces/hs/pixelfuel-claude/.github/CODEOWNERS` with:

```
# All skills require admin review before merging to main
* @havkarl @kengsc
```

- [ ] **Step 2: Commit CODEOWNERS to a branch and open a PR**

```bash
cd /home/havkarl/workspaces/hs/pixelfuel-claude
git checkout -b chore/branch-protection
git add .github/CODEOWNERS
git commit -m "chore: add CODEOWNERS — require admin review for all PRs"
git push -u origin chore/branch-protection
gh pr create \
  --title "chore: add CODEOWNERS and branch protection" \
  --body "Adds CODEOWNERS so GitHub auto-requests review from @havkarl and @kengsc on every PR. Branch protection rule on main will be applied separately via API." \
  --base main \
  --repo havilandsoftware/pixelfuel-claude
```

- [ ] **Step 3: Apply branch protection on `main` via GitHub API**

This call can be run immediately (does not need a PR):

```bash
gh api \
  --method PUT \
  repos/havilandsoftware/pixelfuel-claude/branches/main/protection \
  --input - <<'EOF'
{
  "required_status_checks": {
    "strict": true,
    "contexts": []
  },
  "enforce_admins": false,
  "required_pull_request_reviews": {
    "dismissal_restrictions": {},
    "dismiss_stale_reviews": true,
    "require_code_owner_reviews": true,
    "required_approving_review_count": 1
  },
  "restrictions": null,
  "allow_force_pushes": false,
  "allow_deletions": false
}
EOF
```

- [ ] **Step 4: Verify branch protection is active**

```bash
gh api repos/havilandsoftware/pixelfuel-claude/branches/main/protection \
  --jq '{
    require_pr: .required_pull_request_reviews.required_approving_review_count,
    codeowner_review: .required_pull_request_reviews.require_code_owner_reviews,
    dismiss_stale: .required_pull_request_reviews.dismiss_stale_reviews,
    force_push_blocked: (.allow_force_pushes == false)
  }'
```

Expected output:
```json
{
  "require_pr": 1,
  "codeowner_review": true,
  "dismiss_stale": true,
  "force_push_blocked": true
}
```

---

## Task 7: Push dev guide branch and open PR

**Files:** git/GitHub only

- [ ] **Step 1: Push the development-guide branch**

```bash
cd /home/havkarl/workspaces/hs/development-guide
git push origin HS-parallel-dev-ai-guide
```

- [ ] **Step 2: Check if PR #7 already exists**

```bash
gh pr view 7 --repo havilandsoftware/development-guide --json state,title --jq '{state, title}'
```

If state is `OPEN`: the PR already exists, no need to create a new one. The new commits are already pushed.

If state is `MERGED` or `CLOSED`: create a new PR:

```bash
gh pr create \
  --title "docs: coding standards, guide consolidation, and onboarding improvements" \
  --body "$(cat <<'EOF'
## Summary

- Adds `technologies/standards.md` — unified coding standards for Python, JS/TS, SQL, and any language
- Covers: project structure, linting (ruff / ESLint+Prettier), testing (pytest / Vitest), Dockerfile (distroless / alpine), GitHub Actions CI baseline (lint + test + build + secret scan)
- Adds universal requirements: README, CLAUDE.md, .gitignore, .env.example, environment tiers (local/dev/prod), semver versioning, secret removal procedure
- Consolidates and removes `python.md`, `javascript.md`, `angular.md`
- Updates `installation-and-setup-guide.md` with inline install steps
- Updates `README.md` nav and `claude.md` skills list

## Test Plan
- [ ] All links in `standards.md` resolve correctly
- [ ] No references to deleted files remain in any `.md` file
- [ ] `installation-and-setup-guide.md` install steps are complete without linking to deleted files
- [ ] `README.md` Technologies section shows only `git.md`, `standards.md`, `claude.md`

🤖 Generated with [Claude Code](https://claude.ai/claude-code)
EOF
)" \
  --base main \
  --repo havilandsoftware/development-guide
```

---

## Self-Review

**Spec coverage:**
- Universal requirements (README, CLAUDE.md, .gitignore): ✅ Task 1, Section 1
- .env.example + environment tiers: ✅ Task 1, Section 1
- Versioning (semver, package.json, pyproject.toml): ✅ Task 1, Section 1
- Secret removal procedure: ✅ Task 1, Section 1
- LTS version policy: ✅ Task 1, Section 2
- Python standards (structure, uv, ruff, type hints, pytest, Dockerfile): ✅ Task 1, Section 3
- JS/TS standards (Next.js structure, ESLint+Prettier, Vitest, Dockerfile): ✅ Task 1, Section 4
- SQL standards (Supabase, migrations, naming): ✅ Task 1, Section 5
- Other languages (best-effort principles): ✅ Task 1, Section 6
- Approved infrastructure (AWS, Vercel, Supabase, Zapier, GitHub): ✅ Task 1, Section 7
- GitHub Actions CI (secret scan + lint + test + build): ✅ Task 1, Section 8
- Intentionally not enforced: ✅ Task 1, Section 9
- Delete python.md, javascript.md, angular.md: ✅ Task 5
- Update installation-and-setup-guide.md inline install steps: ✅ Task 2
- Update README.md nav: ✅ Task 3
- Update claude.md skills list: ✅ Task 4
- Branch protection on pixelfuel-claude main: ✅ Task 6
- CODEOWNERS file: ✅ Task 6

**Placeholder scan:** No TBDs. All code blocks are complete. All bash commands have expected outputs. All file paths are exact.

**Type consistency:** N/A — this is a documentation plan, no code types.
