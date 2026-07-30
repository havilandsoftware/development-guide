---
name: dev-check
description: Audit your development machine against the Haviland Software development guide — core toolchain, git config, SSH, and per-project dependencies. Reports a pass/fail table with exact fix commands. Use when setting up a new machine, onboarding, or after importing a project to find out which tooling it needs.
---

# Developer Environment Check

Audit the machine against the [Installation and Setup Guide](../../../getting-started/installation-and-setup-guide.md)
and [Coding Standards](../../../technologies/standards.md).

The guide splits tooling into three tiers, and **this skill must respect that split** — the tier a
tool belongs to determines whether a missing tool is a failure or simply not needed:

| Tier | Contents | Verdict when missing |
|------|----------|----------------------|
| **1 — Core** | git, uv, Python, nvm/Node, Docker, `gh`, Claude Code, ruff, mypy, TypeScript, prettier, pnpm | ❌ **FAIL** — required for every developer |
| **1 — Platform** | Supabase, Vercel | ⚠️ **WARN** — install when you first touch a project that deploys there |
| **2 — Project-specific** | Angular, Amplify, clasp, Codex | ℹ️ **N/A** unless this repo needs it |
| **3 — DevOps** | AWS, gcloud, kubectl, Terraform, Helm, Minikube, Zapier | ℹ️ **N/A** unless this repo provisions infrastructure |

**Never fail a developer for a missing tier-2 or tier-3 tool.** Reporting a red ❌ for Terraform on
an application developer's machine trains people to ignore the report. Only flag tier 2/3 when the
current repository gives evidence it is needed (see Step 4).

---

## Step 1 — Detect Context

```bash
git rev-parse --show-toplevel 2>/dev/null && echo GIT_REPO || echo NOT_GIT
{ [ -f pyproject.toml ] || [ -f requirements.txt ]; } && echo HAS_PYTHON
[ -f package.json ] && echo HAS_NODE
[ -f go.mod ] && echo HAS_GO
[ -f Cargo.toml ] && echo HAS_RUST
```

| Mode | Condition | Scope |
|------|-----------|-------|
| **GLOBAL** | Not in a git repo | Tier 1 + git/SSH only. Skip project checks. |
| **REPO** | Inside a git repo | Tier 1 + git/SSH + this project's dependencies and tier 2/3 needs. |

State the mode at the top of the report so the reader knows what was and wasn't checked:

```
## Developer Environment Check

**Context:** REPO — git repo detected (Python)
  Run from outside any repo to check machine-level tooling only.
```

---

## Step 2 — Tier 1: Core Toolchain (all modes)

| Tool | Min | Check |
|------|-----|-------|
| Git | 2.49+ | `git --version` |
| uv | any | `uv --version` |
| Python | 3.12+ | `python3 --version` |
| nvm | any | `[ -s "$HOME/.nvm/nvm.sh" ] && echo found \|\| echo missing` |
| Node.js | v22+ | `node --version 2>/dev/null \|\| (. "$HOME/.nvm/nvm.sh" && node --version)` |
| Docker | any | `docker --version` |
| GitHub CLI | any | `gh --version \| head -1` |
| Claude Code | any | `claude --version` |
| ruff | any | `ruff --version` |
| mypy | any | `mypy --version` |
| TypeScript | any | `tsc --version 2>/dev/null \|\| (. ~/.nvm/nvm.sh && tsc --version)` |
| prettier | any | `prettier --version 2>/dev/null \|\| (. ~/.nvm/nvm.sh && prettier --version)` |
| pnpm | any | `pnpm --version 2>/dev/null \|\| (. ~/.nvm/nvm.sh && pnpm --version)` |
| Supabase CLI† | any | `supabase --version 2>/dev/null \|\| (. ~/.nvm/nvm.sh && supabase --version)` |
| Vercel CLI† | any | `vercel --version 2>/dev/null \|\| (. ~/.nvm/nvm.sh && vercel --version)` |

† Platform CLIs — report ⚠️ WARN, not ❌ FAIL. They are the approved platforms
([standards](../../../technologies/standards.md#7-approved-infrastructure--services)), but a
backend-only developer has no use for `vercel`, and hard-failing them for it is the same mistake as
failing them for Terraform.

Source nvm before checking Node globals: `. ~/.nvm/nvm.sh 2>/dev/null`. If a tool is absent from
`PATH` but present under `~/.nvm/versions/node/*/bin/`, report it found with a note that the shell
has not sourced nvm — that is a shell-init problem, not a missing install.

**Python is checked but not installed globally per-version.** `uv` provisions the right Python per
project, so a 3.12+ system Python is a baseline only. Do not tell anyone to install every version.

**Node version nuance:** if `node --version` reports v20 or below but `nvm alias default` resolves to
v22, the shell simply has not sourced nvm. Report ✅ with `open a new terminal, or run: nvm use default`
rather than ❌.

```bash
. "$HOME/.nvm/nvm.sh" 2>/dev/null && nvm alias default 2>/dev/null | grep -oE 'v[0-9]+\.[0-9]+\.[0-9]+'
```

### Fixes

```bash
# Python tools — always uv tool, never pip install --user
uv tool install ruff
uv tool install mypy

# Node globals
. ~/.nvm/nvm.sh && npm install -g typescript prettier pnpm

# uv itself
curl -LsSf https://astral.sh/uv/install.sh | sh
```

For anything more than one minor version behind current: report ⚠️ OUTDATED with
`uv tool upgrade <tool>` or `npm update -g <package>`.

---

## Step 3 — Git Config & SSH (all modes)

```bash
git config --global --list 2>/dev/null | grep -E '^(user\.|init\.|core\.editor|push\.)'
```

Required per the [installation guide](../../../getting-started/installation-and-setup-guide.md#tier-1--setup-git):

| Setting | Expected |
|---------|----------|
| `user.name` | set |
| `user.email` | set |
| `init.defaultBranch` | `main` |
| `core.editor` | set |
| `push.autoSetupRemote` | `true` |

SSH — verify a key exists and authenticates:

```bash
ls -1 ~/.ssh/id_ed25519.pub 2>/dev/null || echo "no ed25519 key"
ssh -o StrictHostKeyChecking=accept-new -T git@github.com 2>&1 | head -2
```

`Hi <user>! You've successfully authenticated` is a pass. Note that GitHub always exits non-zero on
this command — judge the message, not the exit code.

Generate a missing key with `ssh-keygen -t ed25519 -C "your-email"`, then add the public key to
GitHub. **Never print a private key** in the report, and never suggest committing one.

---

## Step 4 — Project Dependencies and Tier 2/3 Needs (REPO mode only)

This is where tier 2 and 3 become relevant: check what **this repository** actually needs, then
report only those.

Detect from the repo, not from guesswork:

```bash
# Tier 3 — infrastructure. Each marker is tested separately: a single `ls` with
# several operands exits non-zero if ANY is missing, which would turn these
# OR-detectors into AND-detectors and silently report "no markers found".
{ [ -d terraform/ ] || compgen -G "*.tf" >/dev/null; } && echo NEEDS_TERRAFORM
{ [ -d k8s/ ] || [ -d helm/ ] || [ -f Chart.yaml ]; } && echo NEEDS_KUBERNETES
grep -rqE "boto3|aws-sdk|amazonaws" --include=pyproject.toml --include=package.json . 2>/dev/null && echo NEEDS_AWS

# Tier 2 — project frameworks
[ -f angular.json ] && echo NEEDS_ANGULAR
[ -f amplify/.config/project-config.json ] && echo NEEDS_AMPLIFY
[ -f .clasp.json ] && echo NEEDS_CLASP
```

Only if a marker is found, check the matching tool and report a ❌ for it. Otherwise list the tier as
`N/A — not needed by this project`. If a project is only *deployed* by someone else's pipeline, it
does not need the CLI locally; say so rather than flagging it.

### Python (`pyproject.toml` present)

```bash
[ -f uv.lock ] && echo "uv.lock present" || echo "NO LOCKFILE"
[ -f .python-version ] && echo ".python-version present" || echo "no .python-version"
grep -E '^requires-python' pyproject.toml
grep -E 'target-version' pyproject.toml
uv run ruff check . 2>&1 | tail -3
uv run pytest -q 2>&1 | tail -3
```

Check against [Python Standards](../../../technologies/standards.md#3-python-standards):

- `uv.lock` committed — ❌ if absent
- `requires-python` is `>=3.12` — ⚠️ if lower ([LTS policy](../../../technologies/standards.md#2-lts-version-policy))
- `ruff` `target-version` matches the floor
- Code under `src/<package>/`, tests under `tests/` — ⚠️ on loose root scripts
- `requirements.txt` as the primary dependency file — ⚠️, `pyproject.toml` is the source of truth

### Node (`package.json` present)

```bash
[ -d node_modules ] && echo "installed" || echo "run install"
for f in pnpm-lock.yaml package-lock.json yarn.lock; do [ -f "$f" ] && echo "lockfile: $f"; done
node -e "const p=require('./package.json'); console.log('engines:', JSON.stringify(p.engines||{}))"
```

Required `package.json` fields per the standards: `name`, `version`, `description`, `engines.node`,
and `scripts` with at least `dev`, `build`, `test`, `lint`.

### Universal repo requirements

Check the [Universal Requirements](../../../technologies/standards.md#1-universal-requirements):

```bash
for f in README.md CLAUDE.md .gitignore .env.example; do
  [ -f "$f" ] && echo "✅ $f" || echo "❌ $f"
done
# Fixed-string, whole-line match. An unanchored regex like `^\.env` also matches
# `.envrc` and `.env.example`, so a repo that ignores neither would falsely pass.
grep -qxF '.env' .gitignore 2>/dev/null && echo "✅ .env ignored" || echo "❌ .env NOT ignored"
git ls-files --error-unmatch .env >/dev/null 2>&1 && echo "🚨 .env IS COMMITTED" || echo "✅ no .env tracked"
```

A committed `.env` is the one finding worth interrupting the report for. Point at the
[Secret Removal Procedure](../../../technologies/standards.md#secret-removal-procedure) and say plainly
that the credential must be rotated first — removing it from history does not un-leak it.

`.env.example` is only required if the project uses environment variables; `N/A` otherwise.

---

## Step 5 — Report

One table per section, in this order: context, Tier 1, git/SSH, project (REPO mode only).

```markdown
## Developer Environment Check

**Context:** REPO — git repo detected (Python)

### Tier 1 — Core Toolchain

| Tool | Required | Found | Status |
|------|----------|-------|--------|
| Git | 2.49+ | 2.51.0 | ✅ |
| uv | any | 0.9.9 | ✅ |
| ruff | any | — | ❌ `uv tool install ruff` |

### Git Config & SSH

| Check | Status |
|-------|--------|
| `push.autoSetupRemote` | ❌ `git config --global --add --bool push.autoSetupRemote true` |

### This Project

| Check | Status |
|-------|--------|
| `uv.lock` committed | ✅ |
| `requires-python` | ⚠️ `>=3.11` — guide minimum is 3.12 |
| Tier 2 (project-specific) | N/A — no Angular/Amplify/clasp markers |
| Tier 3 (DevOps) | N/A — no terraform/k8s/AWS markers |

### Summary

**3 issues.** Copy-paste fixes:

```bash
uv tool install ruff
git config --global --add --bool push.autoSetupRemote true
```
```

Rules for the report:

- **Every ❌ carries a copy-pasteable fix command.** A failure without a fix is a complaint.
- Group all fixes into one block at the end so the reader can paste once.
- Report versions you actually observed. If a check errored, say "could not determine" — never infer
  a version you did not see.
- Distinguish ❌ FAIL (tier 1 missing), ⚠️ WARN (present but outdated or below guide minimum), and
  ℹ️ N/A (tier 2/3 not needed here). Three states, used consistently.
- Do not install anything. Report and hand over the commands — the developer decides.
