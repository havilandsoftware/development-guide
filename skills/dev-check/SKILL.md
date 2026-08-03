---
name: dev-check
description: Audit your dev machine against the Haviland Software development guide — CLI tools, global linters, git config, SSH, and the InnoDay CLI and MCP server. Context-aware: detects whether you're in a git repo, an InnoDay project, or a plain directory and scopes dependency checks accordingly. Returns a pass/fail table with exact fix commands for anything missing or stale.
---

# Developer Environment Check

Audit the developer's machine against the Haviland Software development guide. The first thing this skill does is determine **where it's being run** — the checks that follow depend entirely on context. Follow every step below exactly.

## Step 1: Detect Context

Run these checks to determine what kind of directory you're in:

```bash
# Are we inside a git repo?
git rev-parse --show-toplevel 2>/dev/null && echo GIT_REPO || echo NOT_GIT

# Walk up to find .innoday/project.yml (InnoDay project workspace)
_find_project_root() {
  local dir="$PWD"
  while [ "$dir" != "/" ]; do
    [ -f "$dir/.innoday/project.yml" ] && echo "$dir" && return 0
    dir=$(dirname "$dir")
  done
  echo ""
}
INNODAY_ROOT=$(_find_project_root)
echo "innoday_root=${INNODAY_ROOT:-none}"

# If in a git repo, what language does it use?
ls pyproject.toml requirements.txt 2>/dev/null && echo HAS_PYTHON || true
ls package.json 2>/dev/null && echo HAS_NODE || true
ls go.mod 2>/dev/null && echo HAS_GO || true
ls Cargo.toml 2>/dev/null && echo HAS_RUST || true
```

Classify the current invocation into one of three modes:

| Mode | Condition | What changes |
|------|-----------|--------------|
| **GLOBAL** | Not inside any git repo | Check global CLI tools + machine setup only. Skip all repo-specific dependency checks. |
| **REPO** | Inside a git repo, no `.innoday/project.yml` found above | Check global CLI tools + repo language dependencies only. |
| **INNODAY** | `.innoday/project.yml` found anywhere up the tree | Check global CLI tools + repo language dependencies + InnoDay integration. |

Print the detected mode at the top of the report before any checks:

```
## Developer Environment Check

**Context:** GLOBAL — not inside a git repository
  (Run from inside a repo to also check project-level dependencies)
```

or:

```
## Developer Environment Check

**Context:** REPO — git repo detected
  Language: Python + Node.js
  (Run from outside any repo to check machine-level tooling only)
```

or:

```
## Developer Environment Check

**Context:** INNODAY — InnoDay project workspace detected
  Project root: ~/workspaces/<project>/
  Language: Python + Node.js
```

---

## Step 2: Check Global CLI Tools (all modes)

These are machine-level tools that every developer needs regardless of what repo they're in. Run all of them.

> **Version floors verified 2026-07-29.** Floors are minimums — anything newer passes.
> This table is the source of truth for the version tables in
> `getting-started/installation-and-setup-guide.md`; update it here first.

| Tool | Min Version | Check Command |
|------|-------------|---------------|
| Git | 2.55+ | `git --version` |
| uv | 0.11+ | `uv --version` |
| nvm | 0.40+ | `[ -s "$NVM_DIR/nvm.sh" ] && echo "nvm found" \|\| [ -s "$HOME/.nvm/nvm.sh" ] && echo "nvm found" \|\| echo "nvm not found"` |
| Node.js | v24 | `node --version 2>/dev/null \|\| ([ -s "$HOME/.nvm/nvm.sh" ] && . "$HOME/.nvm/nvm.sh" && node --version 2>/dev/null)` |
| Docker | 29.6+ | `docker --version` |
| Claude Code CLI | 2.1+ | `claude --version` |
| GitHub CLI (gh) | 2.96+ | `gh --version` |
| innoday CLI | any | `innoday --version 2>/dev/null \| grep -oE 'v[0-9]+\.[0-9]+\.[0-9]+[^ ]*' \| head -1` |

**DevOps tools** — check these only if the developer works on infrastructure or
deployments. Report them as ⚠️ WARN rather than ❌ FAIL when absent, since most
developers do not need them.

| Tool | Min Version | Check Command |
|------|-------------|---------------|
| Railway CLI | 5.30+ | `railway --version` |
| AWS CLI | 2.36+ | `aws --version` |
| gcloud CLI | 578+ | `gcloud version 2>/dev/null \| head -1` |
| Supabase CLI | 2.110+ | `supabase --version` |
| kubectl | 1.36+ | `kubectl version --client 2>/dev/null \| head -1` |
| Terraform | 1.15+ | `terraform --version \| head -1` |
| Minikube | 1.38+ | `minikube version \| head -1` |
| Helm | 4.2+ | `helm version --short` |

**Why these are global:** These tools are invoked directly from the shell, work across repos, and are not installed per-project. `uv`, `nvm`, `gh`, `docker`, `claude` — you need these before you ever open a project.

**Why Python itself is NOT listed here:** Python runtime is managed per-project via `uv`. The global check for Python is only that `uv` is installed (it will provision the right Python version per project). Checking for a globally-installed `python3` is misleading — it implies you should install Python globally, which conflicts with uv's model.

**kubectl skew note:** Kubernetes enforces a ±1 minor version skew between kubectl and the API server, so the right version depends on the cluster being targeted. Current Kubernetes stable is **1.36**.
- Within ±1 minor of the target cluster → ✅ PASS
- More than one minor behind → ⚠️ OUTDATED
- More than one minor ahead → ⚠️ TOO NEW

Determine current stable with `curl -Ls https://dl.k8s.io/release/stable.txt`.

**Node.js version check logic:** When `node --version` returns v22 or below but nvm is installed, also check whether the nvm *default alias* points to v24 — if it does, the current shell simply hasn't sourced nvm yet (common in non-interactive sessions), not a genuine failure. Run:

```bash
. "$HOME/.nvm/nvm.sh" 2>/dev/null && nvm alias default 2>/dev/null | grep -oE 'v[0-9]+\.[0-9]+\.[0-9]+'
```

- nvm default resolves to v24.x → ✅ PASS with note: `"active shell is v22 — open a new terminal or run: nvm use default"`
- nvm default is not v24 → ❌ FAIL — run fix command below

**nvm PATH note:** If nvm is installed but tools installed via `npm install -g` are not on PATH, probe `~/.nvm/versions/node/*/bin/<tool>` before reporting missing.

**OS-agnostic note:** nvm is the cross-platform Node version manager and works identically on macOS, Linux, and WSL. All nvm commands and paths (`~/.nvm/`) are the same across these platforms. Windows-native (non-WSL) uses `nvm-windows` instead — paths differ (`%APPDATA%\nvm\`) but the commands are the same.

---

## Step 3: Check Global Tools & Frameworks (all modes)

These are installed once on the machine and available from any shell — not inside a project venv or node_modules. Two categories:

1. **Linting/formatting** — invoked by editors and pre-commit hooks before any environment is activated; must be truly global
2. **Platform CLIs and SDKs** — invoked against or between projects from the shell; meaningless as project dependencies

Source nvm first: `. ~/.nvm/nvm.sh 2>/dev/null`

### Python: uv tools

All Python globals are installed via `uv tool install` — each gets an isolated env and a binary on PATH. Never `pip install --user`.

**Linting (❌ FAIL if missing):**

| Tool | Check Command | Latest Known | Purpose |
|------|---------------|-------------|---------|
| `ruff` | `ruff --version 2>/dev/null` | 0.16.0 | Linter + formatter (replaces flake8/black/isort) |
| `mypy` | `mypy --version 2>/dev/null` | 2.3.0 | Static type checker |

**SDKs and clients (⚠️ WARN if missing):**

These are library packages (no CLI binary) used for quick scripts and REPL work across any project. They cannot be installed as `uv tool` (tools require an executable entrypoint). Instead they live in a shared uv script environment or are available via `uv run --with <pkg>`. Check whether they're importable from the default Python:

| Package | Check Command | Latest Known | Purpose |
|---------|---------------|-------------|---------|
| `anthropic` | `python3 -c "import anthropic; print(anthropic.__version__)" 2>/dev/null \|\| uv run --with anthropic python3 -c "import anthropic; print('via uv run')" 2>/dev/null \|\| echo "not found"` | 0.103.1 | Claude API client |
| `openai` | `python3 -c "import openai; print(openai.__version__)" 2>/dev/null \|\| echo "not found"` | 2.37.0 | OpenAI API client |
| `boto3` | `python3 -c "import boto3; print(boto3.__version__)" 2>/dev/null \|\| echo "not found"` | 1.43.12 | AWS SDK |

- Found importable globally → ✅ PASS
- Found only via `uv run --with` → ⚠️ WARN (available on demand but not installed)
- Not found at all → ⚠️ WARN with install suggestion

Install for global availability (add to a shared script environment):
```bash
uv tool install ruff mypy
# For SDKs — install into a shared uv managed env or use uv run --with on demand:
uv run --with anthropic --with openai --with boto3 python3 -c "print('SDKs available')"
```

**What does NOT belong here:** `fastapi`, `uvicorn`, `pydantic`, `httpx`, `asyncpg`, `sqlalchemy`, `pandas`, `numpy` — these are project dependencies that belong in `pyproject.toml`, managed per-project by `uv sync`. Never check for these globally.

### Node.js: npm global packages

**Linting, compilation, package management (❌ FAIL if missing):**

Every developer needs these — editors and pre-commit hooks invoke them before any project environment is active.

| Package | Check Command | Latest Known | Purpose |
|---------|---------------|-------------|---------|
| `typescript` | `tsc --version 2>/dev/null \|\| (. ~/.nvm/nvm.sh && tsc --version 2>/dev/null)` | 7.0.2 | TypeScript compiler — editors invoke this globally |
| `prettier` | `prettier --version 2>/dev/null \|\| (. ~/.nvm/nvm.sh && prettier --version 2>/dev/null)` | 3.9.6 | Formatter — editors invoke this globally |
| `pnpm` | `pnpm --version 2>/dev/null \|\| (. ~/.nvm/nvm.sh && pnpm --version 2>/dev/null)` | 11.18.0 | Package manager — must be global |

**Platform CLIs (⚠️ WARN if missing — not required for everyone):**

These are platform tools, not project dependencies — a project that deploys to Vercel doesn't put `vercel` in its `node_modules`. But **only a developer who works with that platform needs them**, so absence is a warning, never a failure. Do not tell someone writing a Python API that a missing Apps Script CLI is a problem.

| Package | Check Command | Latest Known | Needed for |
|---------|---------------|-------------|------------|
| `supabase` | `supabase --version 2>/dev/null \|\| (. ~/.nvm/nvm.sh && supabase --version 2>/dev/null)` | 2.110.0 | Supabase projects |
| `vercel` | `vercel --version 2>/dev/null \|\| (. ~/.nvm/nvm.sh && vercel --version 2>/dev/null)` | 54.2.0 | Vercel deployments |
| `@aws-amplify/cli` | `amplify --version 2>/dev/null \|\| (. ~/.nvm/nvm.sh && amplify --version 2>/dev/null)` | 14.5.0 | AWS Amplify projects |
| `@google/clasp` | `clasp --version 2>/dev/null \|\| (. ~/.nvm/nvm.sh && clasp --version 2>/dev/null)` | 3.3.0 | Google Apps Script projects |
| `zapier-platform-cli` | `zapier-platform --version 2>/dev/null \|\| (. ~/.nvm/nvm.sh && zapier-platform --version 2>/dev/null)` | 19.0.0 | Zapier integrations |

Angular tooling (`@angular/cli`) is deliberately not checked — `standards.md` §4 states Angular is not in active use and new frontend projects use Next.js. Do not add it back without changing that standard first.

Do not check for other AI coding CLIs. `standards.md` and `ai.md` name Claude Code as the team's tool; requiring a competing agent on every machine contradicts that.

**What does NOT belong here:** `jest`, `playwright`, `react`, `express`, `next`, `lodash`, `axios`, `tailwindcss`, `prisma`, etc. — these are project dependencies that belong in `package.json` and are installed per-project via `pnpm install`. Never check for these globally.

For installed tools more than one minor version behind Latest Known, report ⚠️ OUTDATED with the upgrade command:
- Python uv tools: `uv tool upgrade <tool>`
- Node globals: `. ~/.nvm/nvm.sh && npm update -g <package>`

---

## Step 4: Check Git Config & SSH (all modes)

### Git global config

Run `git config --global --list` and verify:

| Config Key | Required Value |
|------------|----------------|
| `user.name` | any non-empty value |
| `user.email` | any non-empty email (GitHub no-reply accepted) |
| `init.defaultbranch` | `main` |
| `push.autosetupremote` | `true` |

### SSH

1. `ls ~/.ssh/id_ed25519.pub` — PASS if exists
2. `ssh -T git@github.com 2>&1` — PASS if output contains "successfully authenticated"

---

## Step 5: Check Workspace Root (all modes)

All repositories are cloned under `~/workspaces/`. Confirm the root exists:

```bash
ls -d ~/workspaces 2>/dev/null && echo EXISTS || echo MISSING
```

PASS if EXISTS. FAIL if MISSING — fix is `mkdir -p ~/workspaces`.

That is the whole check. Do not audit individual project directories for
`.innoday/project.yml` or `CLAUDE.md` — how a developer organises repositories inside
the workspace root is their business, and the tooling that generates those files
reports its own errors.

---

## Step 6: Check Repo-Level Dependencies (REPO and INNODAY modes only)

**Skip this step entirely in GLOBAL mode.** These checks only make sense when you're inside a repo because the right answer depends entirely on what that repo uses. Flagging "fastapi not installed globally" while standing in a Node.js repo is noise.

Detect what the current repo uses (from Step 1) and run only the relevant checks.

### If HAS_PYTHON (pyproject.toml or requirements.txt present)

Check that `uv` is available (already done in Step 2) — that's the only hard requirement. Then verify the project can be bootstrapped:

```bash
# Does a lockfile exist?
ls uv.lock 2>/dev/null && echo LOCK_OK || echo NO_LOCK

# Can the venv be created? (dry-run — don't actually create it here)
uv sync --dry-run 2>/dev/null | tail -3 || echo "uv sync check failed"
```

| Check | PASS condition | Notes |
|-------|---------------|-------|
| `uv.lock` present | file exists | Absent → `uv lock` needed |
| `uv sync` dry-run succeeds | no errors | Dependency resolution works |

**Do NOT check for globally-installed Python packages** (fastapi, uvicorn, asyncpg, etc.) in REPO mode. These live in the project's uv-managed venv — not in global pip. Checking `pip list` for them is misleading and will always miss what's actually in the project's venv.

If you want to know what's installed in the active project environment, the right command is:
```bash
uv run pip list 2>/dev/null | head -20
```
But this is informational, not a pass/fail check.

### If HAS_NODE (package.json present)

```bash
# Does node_modules exist?
ls node_modules 2>/dev/null && echo INSTALLED || echo NOT_INSTALLED

# Which package manager does this project use?
ls pnpm-lock.yaml 2>/dev/null && echo PNPM
ls package-lock.json 2>/dev/null && echo NPM
ls yarn.lock 2>/dev/null && echo YARN
ls bun.lockb 2>/dev/null && echo BUN
```

| Check | PASS condition |
|-------|---------------|
| `node_modules` present | `ls node_modules` succeeds |
| Lockfile present | any of pnpm-lock.yaml, package-lock.json, yarn.lock, bun.lockb |

**Do NOT check for globally-installed Node frameworks** (jest, playwright, angular, etc.) when inside a repo. These are project-local dependencies — the project installs them in `node_modules` via the lockfile.

### If HAS_GO or HAS_RUST

```bash
# Go
ls go.sum 2>/dev/null && echo GO_LOCK_OK || echo GO_LOCK_MISSING

# Rust
ls Cargo.lock 2>/dev/null && echo RUST_LOCK_OK || echo RUST_LOCK_MISSING
```

---

## Step 7: Check InnoDay CLI & MCP (all modes)

These checks run in every mode. InnoDay is a global developer tool — the CLI and MCP server should be working on every machine regardless of which project you're in.

**7a. CLI installed and reachable:**

```bash
innoday --version 2>/dev/null | grep -oE 'v[0-9]+\.[0-9]+\.[0-9]+[^ ]*' | head -1
```

PASS if a version is printed. FAIL if `innoday` is not on PATH.

**7b. CLI configured — config file and identity:**

The CLI reads its identity and API URL from `~/.innoday/config.json`. No environment
variables are involved.

```bash
ls ~/.innoday/config.json 2>/dev/null && echo PRESENT || echo MISSING

innoday --format json orgs current 2>/dev/null | python3 -c "
import json, sys
try:
    d = json.load(sys.stdin)
    alias = d.get('alias') or d.get('name', '')
    print(f'org={alias}')
except: print('not configured')
" 2>/dev/null || echo "not configured"
```

- Config present and org resolved → ✅ PASS — show the org alias
- Config missing, or `not configured` → ❌ FAIL — fix is `innoday config init`

Do **not** check for `INNODAY_API_URL`, `INNODAY_API_KEY`, or
`INNODAY_ORGANIZATION_ID` — the CLI does not read them.

**7c. CLI functional — ping the API:**

```bash
innoday ping api 2>&1
```

- Exits 0 → ✅ PASS — API is reachable
- CLI not found → skip (caught in 7a)
- API unreachable → ⚠️ WARN (the API may simply not be running; the CLI itself is
  fine) — show `innoday config show` to confirm the configured URL

**7d. Claude Code MCP server registered:**

```bash
claude mcp list 2>/dev/null
```

Parse for a server named `innoday`: Connected → ✅ PASS / Error → ❌ FAIL /
Not found → ❌ FAIL. Fix is in Step 9.

**7e. Team secret seeded (gated APIs only):**

A deployed InnoDay API gates every non-public route behind a team secret. The CLI and
MCP server read it from the client config — it is **not** seeded automatically by
`innoday config init`, so a machine can have the CLI installed, MCP registered, and
still `401` on every call.

The config is profile-based, so the secret lives under the **active profile**, not at the
top level — `profiles.<current_profile>.platform.team_secret`. Check it there:

```bash
python3 -c "
import json, os
try:
    d = json.load(open(os.path.expanduser('~/.innoday/config.json')))
    prof = d.get('profiles', {}).get(d.get('current_profile') or 'default', {})
    secret = prof.get('platform', {}).get('team_secret')
    print('seeded' if secret else 'missing')
except Exception: print('no-config')
" 2>/dev/null
```

- `seeded` → ✅ PASS
- `missing` → ⚠️ WARN — only an error when targeting a gated/deployed API; a purely
  local API has no team secret. Fix is in Step 9.
- `no-config` → skip (already reported by 7b)

**Check the active profile, not every profile.** A machine commonly has a `default`
profile with no secret and a `dev` profile with one. Reporting on the wrong profile gives
a confidently wrong answer in both directions, so always resolve `current_profile` first
and report only on that one. Mention which profile was checked in the output.

If MCP tools `401` while the CLI works, the running MCP server cached the config from
before it was seeded — reconnect it so it re-reads the file.

---

## Step 8: Print Results

Print results grouped by section. Always show the detected mode header first.

```
## Developer Environment Check

**Context:** <MODE> — <description>

### Global CLI Tools
| Tool | Status | Installed | Notes |
|------|--------|-----------|-------|
| Git 2.55+ | ✅ PASS | 2.55.0 | |
| uv 0.11+ | ⚠️ OUTDATED | 0.8.3 | run: `uv self update` |
| nvm 0.40+ | ✅ PASS | 0.40.6 | |
| Node.js v24 | ✅ PASS | v24.18.0 | |
| Docker 29.6+ | ✅ PASS | 29.6.2 | |
| Claude Code CLI 2.1+ | ✅ PASS | 2.1.220 | |
| GitHub CLI 2.96+ | ✅ PASS | 2.96.0 | |
| innoday CLI | ✅ PASS | v0.1.87b0 | |

### DevOps Tools *(⚠️ WARN if absent — only needed for infrastructure work)*
| Tool | Status | Installed | Notes |
|------|--------|-----------|-------|
| Railway CLI 5.30+ | ✅ PASS | 5.30.1 | |
| AWS CLI 2.36+ | ✅ PASS | 2.36.10 | |
| gcloud CLI 578+ | ✅ PASS | 578.0.0 | |
| Supabase CLI 2.110+ | ⚠️ WARN | — | not installed |
| kubectl 1.36+ | ⚠️ OUTDATED | v1.28.0 | outside ±1 skew of the target cluster |
| Terraform 1.15+ | ✅ PASS | v1.15.8 | |
| Minikube 1.38+ | ⚠️ WARN | — | not installed |
| Helm 4.2+ | ⚠️ OUTDATED | v3.20.1 | Helm 4 is current major |

Values in this sample are illustrative but must stay **consistent with the floors declared
in Step 2** — a sample showing `uv 0.8.3` as ✅ PASS against a 0.11+ floor teaches the
wrong thing. Regenerate this block whenever the floors move.

### Global Tools & Frameworks

**Python (uv tools)**
| Tool | Status | Installed | Latest | Notes |
|------|--------|-----------|--------|-------|
| ruff | ✅ PASS | 0.16.0 | 0.16.0 | |
| mypy | ✅ PASS | 2.3.0 | 2.3.0 | |
| anthropic | ⚠️ WARN | — | 0.103.1 | not importable globally |
| openai | ⚠️ WARN | — | 2.37.0 | not importable globally |
| boto3 | ⚠️ WARN | — | 1.43.12 | not importable globally |

**Node.js (npm globals)**
| Tool | Status | Installed | Latest | Notes |
|------|--------|-----------|--------|-------|
| typescript | ✅ PASS | 7.0.2 | 7.0.2 | |
| prettier | ✅ PASS | 3.9.6 | 3.9.6 | |
| pnpm | ✅ PASS | 11.18.0 | 11.18.0 | |
| supabase | ⚠️ WARN | — | 2.110.0 | not installed — only needed for Supabase projects |
| vercel | ✅ PASS | 54.2.0 | 54.2.0 | |
| @aws-amplify/cli | ⚠️ WARN | — | 14.5.0 | not installed — only needed for Amplify projects |
| @google/clasp | ⚠️ WARN | — | 3.3.0 | not installed — only needed for Apps Script |
| zapier-platform-cli | ⚠️ WARN | — | 19.0.0 | not installed — only needed for Zapier |
| supabase | ✅ PASS | 2.110.0 | 2.110.0 | |
| pnpm | ✅ PASS | 11.18.0 | 11.18.0 | |

### Git Config
| Check | Status | Notes |
|-------|--------|-------|
| git user.name | ✅ PASS | your-name |
| git user.email | ✅ PASS | you@example.com |
| git init.defaultBranch=main | ✅ PASS | |
| git push.autoSetupRemote=true | ✅ PASS | |

### SSH & Access
| Check | Status | Notes |
|-------|--------|-------|
| SSH key exists | ✅ PASS | ~/.ssh/id_ed25519.pub |
| SSH GitHub access | ✅ PASS | authenticated as your-username |

### Workspace Root
| Check | Status | Notes |
|-------|--------|-------|
| ~/workspaces exists | ✅ PASS | |
```

In **REPO** or **INNODAY** mode, append a repo section:

```
### Repo Dependencies (Python)
| Check | Status | Notes |
|-------|--------|-------|
| uv.lock present | ✅ PASS | |
| uv sync (dry-run) | ✅ PASS | all dependencies resolved |

### Repo Dependencies (Node.js)
| Check | Status | Notes |
|-------|--------|-------|
| node_modules present | ⚠️ WARN | run: pnpm install |
| lockfile present | ✅ PASS | pnpm-lock.yaml |
```

Always append (all modes):

```
### InnoDay CLI & MCP
| Check | Status | Notes |
|-------|--------|-------|
| innoday CLI installed | ✅ PASS | v0.91.0-beta |
| config + org resolved | ✅ PASS | ~/.innoday/config.json — org=your-org |
| ping api | ⚠️ WARN | API unreachable — run: innoday config show |
| Claude Code MCP | ❌ FAIL | not registered — see fix below |
| team secret seeded | ⚠️ WARN | only needed for a gated/deployed API |
```

End with:

```
**Overall: ❌ N failures, ⚠️ M warnings**
```

---

## Step 9: Print Fix Instructions

Print fix commands only for ❌ FAIL and ⚠️ OUTDATED items found in this run. Omit sections that had no failures.

**Missing Python linters:**
```bash
uv tool install ruff mypy
```

**Python SDKs not globally importable (optional — use on demand instead):**
```bash
# Run scripts using these packages without a global install:
uv run --with anthropic python3 myscript.py
uv run --with openai --with boto3 python3 myscript.py
```

**Missing Node.js global tools (required for everyone):**
```bash
. ~/.nvm/nvm.sh && npm install -g typescript prettier pnpm
```

**Missing platform CLIs (only what you actually use — do not install all of these):**
```bash
. ~/.nvm/nvm.sh && npm install -g supabase          # Supabase projects
. ~/.nvm/nvm.sh && npm install -g vercel            # Vercel deployments
. ~/.nvm/nvm.sh && npm install -g @aws-amplify/cli  # Amplify projects
. ~/.nvm/nvm.sh && npm install -g @google/clasp     # Apps Script
. ~/.nvm/nvm.sh && npm install -g zapier-platform-cli
```

**Node.js v24 (if FAIL — nvm default not pointing to v24):**
```bash
# macOS / Linux / WSL (nvm):
nvm install 24 && nvm use 24 && nvm alias default 24
# Then add to ~/.bashrc or ~/.zshrc so it activates on every shell:
echo 'nvm use default --silent 2>/dev/null' >> ~/.bashrc

# Windows (nvm-windows) — run in PowerShell as Administrator:
# nvm install 24.0.0 && nvm use 24.0.0
```

**kubectl (outside the ±1 minor skew window):**
```bash
# Install the version matching your cluster, or current stable:
VER=$(curl -Ls https://dl.k8s.io/release/stable.txt)
curl -LO "https://dl.k8s.io/release/${VER}/bin/linux/amd64/kubectl"
install kubectl ~/.local/bin/kubectl
```

**Workspace missing:**
```bash
mkdir -p ~/workspaces
```

**node_modules missing (REPO/INNODAY mode):**
```bash
# Use whichever lockfile the project has:
pnpm install   # pnpm-lock.yaml
npm install    # package-lock.json
yarn           # yarn.lock
```

**uv.lock missing (REPO/INNODAY mode):**
```bash
uv lock
uv sync
```

**innoday CLI not installed:**
```bash
uv tool install innoday
```
To upgrade later: `uv tool upgrade innoday`. If you work from a local clone of the
InnoDay source instead, `uv tool install . --force` from inside it.

**innoday not configured (no config file, or no org resolved):**
```bash
innoday config init
```

**InnoDay MCP not registered:**
```bash
claude mcp add innoday -- mcp-server-innoday
```
The MCP server reads its config from `~/.innoday/config.json` — no extra env vars
needed.

**Team secret not seeded (gated/deployed API only):**
```bash
innoday config set team-secret "<secret>"
```
This writes to the **active profile**, so confirm you are on the right one first with
`innoday config show`. Obtain the secret from whoever administers the API you are
targeting; a purely local API has none and this warning can be ignored. After seeding,
reconnect the MCP server (`/mcp reconnect`) so it re-reads the config — otherwise MCP
calls keep `401`ing while the CLI works.

For git config failures, print the exact `git config --global` command.

---

## Error Handling

| Scenario | Behavior |
|----------|----------|
| Run from outside a git repo | Mode = GLOBAL; skip Step 6; still run Step 7 (InnoDay CLI checks are global) |
| Run from inside a git repo with no .innoday found | Mode = REPO; run Steps 1–7 (InnoDay checks are global) |
| Run from inside an InnoDay workspace | Mode = INNODAY; run all steps |
| Tool not found | Mark ❌; probe nvm fallback before failing; continue |
| kubectl outside ±1 minor of the cluster | Mark ⚠️ OUTDATED or ⚠️ TOO NEW; print skew window |
| Tool installed via nvm but not on PATH | Mark ✅ PASS with "(via nvm)" note |
| Tool installed but behind latest known | Mark ⚠️ OUTDATED with upgrade command |
| `~/workspaces/` missing | Mark ❌ FAIL; fix is `mkdir -p ~/workspaces` |
| `innoday` CLI not on PATH | Mark 7a ❌ FAIL; skip 7b–7e; continue |
| `~/.innoday/config.json` missing or no org | Mark 7b ❌ FAIL; show `innoday config init` |
| `innoday ping api` fails (API not running) | Mark 7c ⚠️ WARN; CLI itself is fine; continue |
| `claude mcp list` fails | Mark 7d as ⚠️ WARN — Claude Code CLI unavailable |
| `team_secret` absent from config | Mark 7e ⚠️ WARN; only an error against a gated API |
| pyproject.toml present but uv not installed | Mark ❌ FAIL on uv (Step 2); note project cannot be set up |
| package.json present but nvm/node missing | Mark ❌ FAIL on Node (Step 2); note project cannot be set up |

---

## Reference: Install Links

- **uv**: `curl -LsSf https://astral.sh/uv/install.sh | sh`
- **nvm**: `curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.6/install.sh | bash`
- **Node.js v24**: `nvm install 24 && nvm use 24 && nvm alias default 24`
- **Python linters (uv tools)**: `uv tool install ruff mypy`
- **Python SDKs (on-demand)**: `uv run --with anthropic --with openai --with boto3 python3 myscript.py`
- **Node.js global tools (all developers)**: `. ~/.nvm/nvm.sh && npm install -g typescript prettier pnpm`
- **Platform CLIs (only those you use)**: `. ~/.nvm/nvm.sh && npm install -g supabase vercel @aws-amplify/cli @google/clasp zapier-platform-cli`
- **Docker**: https://docs.docker.com/engine/install/ubuntu
- **Claude Code CLI**: `npm install -g @anthropic-ai/claude-code`
- **GitHub CLI**: https://cli.github.com/
- **AWS CLI**: https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html
- **gcloud**: https://cloud.google.com/sdk/docs/install
- **kubectl**: https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/
- **Terraform**: https://developer.hashicorp.com/terraform/install
- **Railway CLI**: https://docs.railway.com/guides/cli
- **Helm**: https://helm.sh/docs/intro/install/
- **SSH setup**: `ssh-keygen -t ed25519 -C "your-email"`, then add `~/.ssh/id_ed25519.pub` to GitHub Settings → SSH Keys
- **innoday CLI**: `uv tool install innoday` (then `innoday config init`)
- **innoday MCP**: `claude mcp add innoday -- mcp-server-innoday`
