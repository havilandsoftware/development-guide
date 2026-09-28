---
name: dev-check
description: Audit your development machine against the Haviland Software development guide — core toolchain, git config, SSH, and per-project dependencies — then offer a checklist of what to install. Versions come from the technology radar (radar/*.csv). Use when setting up a new machine, onboarding, or after importing a project to find out which tooling it needs.
argument-hint: "[radar-file]"
---

# Developer Environment Check

Audit the machine against the [Installation and Setup Guide](https://github.com/havilandsoftware/development-guide/blob/main/getting-started/installation-and-setup-guide.md)
and [Coding Standards](https://github.com/havilandsoftware/development-guide/blob/main/technologies/standards.md).

The guide splits tooling into three tiers, and **this skill must respect that split** — the tier a
tool belongs to determines whether a missing tool is a failure or simply not needed:

| Tier | Contents | Verdict when missing |
|------|----------|----------------------|
| **1 — Core** | git, uv, Python, nvm/Node, Docker, `gh`, Claude Code, InnoDay, ruff, mypy, TypeScript, prettier, pnpm | ❌ **FAIL** — required for every developer |
| **1 — Platform** | Supabase, Vercel, AWS CLI, gcloud | ⚠️ **WARN** — checked on every machine, offered in the install checklist |
| **2 — Project-specific** | Angular, Amplify, clasp | ℹ️ **N/A** unless this repo needs it |
| **3 — DevOps** | Railway, kubectl, Terraform, Helm, Minikube, Zapier | ℹ️ **N/A** unless this repo provisions infrastructure |

**Never fail a developer for a missing tier-2 or tier-3 tool.** Reporting a red ❌ for Terraform on
an application developer's machine trains people to ignore the report. Only flag tier 2/3 when the
current repository gives evidence it is needed (see Step 5).

---

## Step 0 — Load the Radar

Every version floor and install link comes from a **radar** file: a CSV with the header
`technology,version,url`, one row per tool. Nothing in this skill hard-codes a version.
Pick the radar in this order, and stop at the first that applies:

1. **An argument was passed** (`/dev-check 2026-07-29.csv`) — a local path if it exists, otherwise
   that name under `https://raw.githubusercontent.com/havilandsoftware/development-guide/main/radar/`,
   or a URL used as-is.
2. **You are inside a clone of this guide** (a `radar/` folder next to `.claude/skills/dev-check/`) —
   the local `radar/*.csv` whose name sorts last, so unmerged radar edits can be tested.
3. **Otherwise the newest published radar** — the name that sorts last from
   `curl -fsSL https://api.github.com/repos/havilandsoftware/development-guide/contents/radar?ref=main`.
4. **Offline** — `radar.csv` in this skill's base directory, which `install.sh` put there.

Name the radar file in the report's first line. If none of these yields a file whose first line is
`technology,version,url`, stop and say so rather than guessing floors.

A radar `version` is a floor (`2.55+`, anything newer passes) or `any` (present is enough). A tool
this skill checks that the radar does not list is reported `could not determine floor`, not failed.

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

Floors come from the radar (Step 0); the `Tool` names below match its `technology` column.

| Tool | Check |
|------|-------|
| Git | `git --version` |
| uv | `uv --version` |
| Python | `python3 --version` |
| nvm | `[ -s "$HOME/.nvm/nvm.sh" ] && echo found \|\| echo missing` |
| Node.js | `node --version 2>/dev/null \|\| (. "$HOME/.nvm/nvm.sh" && node --version)` |
| Docker | `docker --version` |
| GitHub CLI | `gh --version \| head -1` |
| Claude Code | `claude --version` |
| InnoDay CLI | `innoday --version 2>/dev/null \| grep -oE 'v?[0-9]+\.[0-9]+\.[0-9]+[^ ]*' \| head -1` |
| ruff | `ruff --version` |
| mypy | `mypy --version` |
| TypeScript | `tsc --version 2>/dev/null \|\| (. ~/.nvm/nvm.sh && tsc --version)` |
| prettier | `prettier --version 2>/dev/null \|\| (. ~/.nvm/nvm.sh && prettier --version)` |
| pnpm | `pnpm --version 2>/dev/null \|\| (. ~/.nvm/nvm.sh && pnpm --version)` |
| Supabase CLI† | `supabase --version 2>/dev/null \|\| (. ~/.nvm/nvm.sh && supabase --version)` |
| Vercel CLI† | `vercel --version 2>/dev/null \|\| (. ~/.nvm/nvm.sh && vercel --version)` |
| AWS CLI† | `aws --version` |
| gcloud CLI† | `gcloud --version 2>/dev/null \| head -1` |

† Platform CLIs — report ⚠️ WARN, not ❌ FAIL. They are the approved platforms
([standards](https://github.com/havilandsoftware/development-guide/blob/main/technologies/standards.md#7-approved-infrastructure--services)), but a
backend-only developer has no use for `vercel`, and hard-failing them for it is the same mistake as
failing them for Terraform. They are still offered in the Step 7 checklist, so installing them is one
tick away.

Source nvm before checking Node globals: `. ~/.nvm/nvm.sh 2>/dev/null`. If a tool is absent from
`PATH` but present under `~/.nvm/versions/node/*/bin/`, report it found with a note that the shell
has not sourced nvm — that is a shell-init problem, not a missing install.

**Python is checked but not installed globally per-version.** `uv` provisions the right Python per
project, so a 3.12+ system Python is a baseline only. Do not tell anyone to install every version.
New projects use 3.14 — see
[LTS Version Policy](https://github.com/havilandsoftware/development-guide/blob/main/technologies/standards.md#2-lts-version-policy) for the distinction
between the minimum supported and what new work starts on.

**Node version nuance:** if `node --version` reports v22 or below but `nvm alias default` resolves to
v24, the shell simply has not sourced nvm. Report ✅ with `open a new terminal, or run: nvm use default`
rather than ❌. Node 24 is the current Active LTS; 22 has moved to Maintenance, so a machine genuinely
on 22 is ⚠️ OUTDATED rather than ❌ FAIL — the fix is `nvm install 24 && nvm alias default 24`.

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

Required per the [installation guide](https://github.com/havilandsoftware/development-guide/blob/main/getting-started/installation-and-setup-guide.md#setup-git):

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

## Step 4 — InnoDay CLI and MCP (all modes)

InnoDay is internal tier-1 tooling: the CLI and its MCP server should work on every machine
regardless of which project you are in. Skip this section entirely if `innoday` is not on PATH and
the developer is outside Haviland Software — it will not apply to them.

**4a — Configured:** the CLI reads identity and API URL from `~/.innoday/config.json`. No
environment variables are involved.

```bash
ls ~/.innoday/config.json >/dev/null 2>&1 && echo PRESENT || echo MISSING
innoday --format json orgs current 2>/dev/null | python3 -c "
import json,sys
try:
    d=json.load(sys.stdin); print('org=' + (d.get('alias') or d.get('name','')))
except Exception: print('not configured')
" 2>/dev/null || echo "not configured"
```

Config present and an org resolved → ✅. Otherwise ❌ with `innoday config init`.

**4b — API reachable:**

```bash
innoday ping api 2>&1
```

Exit 0 → ✅. Unreachable → ⚠️ WARN, not ❌: the API may simply not be running, which says nothing
about the developer's machine. Show `innoday config show` to confirm the configured URL.

**4c — MCP server registered:**

```bash
claude mcp list 2>/dev/null
```

Look for a server named `innoday`. Connected → ✅ / Error or absent → ❌, fix
`claude mcp add innoday -- mcp-server-innoday`. If `claude mcp list` itself fails, ⚠️ WARN — the
Claude Code CLI is unavailable, which Step 2 already reported.

**4d — Team secret seeded:** a deployed API gates every non-public route behind an
`X-Team-Secret` header, and `innoday config init` does **not** seed it. A machine can have the CLI
installed and MCP registered and still `401` on every call.

The config is **profile-based** — the secret lives at
`profiles.<current_profile>.platform.team_secret`, not at the top level. Resolve the active profile
first and report only on that one; a secret seeded on `default` while working on `dev` fails
exactly as though it were never set.

```bash
python3 -c "
import json,os
try:
    d=json.load(open(os.path.expanduser('~/.innoday/config.json')))
    prof=d.get('profiles',{}).get(d.get('current_profile') or 'default',{})
    print('seeded' if prof.get('platform',{}).get('team_secret') else 'missing')
except Exception: print('no-config')
" 2>/dev/null
```

`seeded` → ✅. `missing` → ⚠️ WARN (only an error against a gated API; a local one has no secret),
fix `innoday config set team-secret "<secret>"` — which writes to the active profile, so check
`innoday config show` first. `no-config` → skip, already reported by 4a.

After seeding, reconnect the MCP server (`/mcp reconnect`) so it re-reads the file. A server caches
config at startup, so uniform `401`s from MCP while the CLI works is this, not a network fault.

State which profile you checked in the report.

---

## Step 5 — Project Dependencies and Tier 2/3 Needs (REPO mode only)

This is where tier 2 and 3 become relevant: check what **this repository** actually needs, then
report only those.

Detect from the repo, not from guesswork:

```bash
# Tier 3 — infrastructure. Each marker is tested separately: a single `ls` with
# several operands exits non-zero if ANY is missing, which would turn these
# OR-detectors into AND-detectors and silently report "no markers found".
{ [ -d terraform/ ] || compgen -G "*.tf" >/dev/null; } && echo NEEDS_TERRAFORM
{ [ -d k8s/ ] || [ -d helm/ ] || [ -f Chart.yaml ]; } && echo NEEDS_KUBERNETES

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

Check against [Python Standards](https://github.com/havilandsoftware/development-guide/blob/main/technologies/standards.md#3-python-standards):

- `uv.lock` committed — ❌ if absent
- `requires-python` is `>=3.12` — ⚠️ if lower ([LTS policy](https://github.com/havilandsoftware/development-guide/blob/main/technologies/standards.md#2-lts-version-policy))
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

Check the [Universal Requirements](https://github.com/havilandsoftware/development-guide/blob/main/technologies/standards.md#1-universal-requirements):

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
[Secret Removal Procedure](https://github.com/havilandsoftware/development-guide/blob/main/technologies/standards.md#secret-removal-procedure) and say plainly
that the credential must be rotated first — removing it from history does not un-leak it.

`.env.example` is only required if the project uses environment variables; `N/A` otherwise.

---

## Step 6 — Report

One table per section, in this order: context, Tier 1, git/SSH, InnoDay, project (REPO mode only).

```markdown
## Developer Environment Check

**Context:** REPO — git repo detected (Python) · **Radar:** `2026-09-28.csv`

### Tier 1 — Core Toolchain

| Tool | Required | Found | Status |
|------|----------|-------|--------|
| Git | 2.55+ | 2.55.0 | ✅ |
| uv | 0.11+ | 0.8.3 | ⚠️ `uv self update` |
| Node.js | v24+ | v24.18.0 | ✅ |
| ruff | 0.16+ | — | ❌ `uv tool install ruff` |
| Vercel CLI | 54+ | — | ⚠️ platform CLI — install when you deploy to Vercel |
| gcloud CLI | 578+ | — | ⚠️ platform CLI — offered below |

### Git Config & SSH

| Check | Status |
|-------|--------|
| `push.autoSetupRemote` | ❌ `git config --global --add --bool push.autoSetupRemote true` |

### InnoDay

| Check | Status |
|-------|--------|
| CLI installed | ✅ v0.1.87b0 |
| config + org resolved | ✅ profile `dev` |
| `ping api` | ⚠️ API unreachable — `innoday config show` |
| Claude Code MCP | ✅ connected |
| team secret (profile `dev`) | ✅ seeded |

### This Project

| Check | Status |
|-------|--------|
| `uv.lock` committed | ✅ |
| `requires-python` | ⚠️ `>=3.11` — guide minimum is 3.12 |
| Tier 2 (project-specific) | N/A — no Angular/Amplify/clasp markers |
| Tier 3 (DevOps) | N/A — no terraform/k8s markers |

### Summary

**3 issues, 2 warnings.** Copy-paste fixes:

```bash
uv self update
uv tool install ruff
git config --global --add --bool push.autoSetupRemote true
```
```

Rules for the report:

- **Every ❌ carries a copy-pasteable fix command.** A failure without a fix is a complaint.
- Group all fixes into one block at the end so the reader can paste once.
- Report versions you actually observed. If a check errored, say "could not determine" — never infer
  a version you did not see.
- Distinguish ❌ FAIL (tier 1 missing), ⚠️ WARN (present but outdated, or a platform/tier-2/3 tool
  this developer does not need yet), and ℹ️ N/A (tier 2/3 with no marker in this repo). Three
  states, used consistently.
- **Sample values above must stay consistent with the newest radar.** Showing `uv 0.8.3` as ✅
  against a 0.11+ floor teaches the wrong thing; regenerate this block whenever floors move.
- Nothing is installed during Steps 1–6. Installing happens only in Step 7, and only what the
  developer ticks.

---

## Step 7 — Offer to Install

If the report has no ❌ or ⚠️ items, stop here. Otherwise show a checklist with
`AskUserQuestion` (`multiSelect: true`) of every ❌ and ⚠️ item that has an install — missing tools
and outdated ones. Tier 2/3 tools appear only if Step 5 flagged them.

- One question per report section (Core, Platform, Project), up to 4 options each — the tool's
  limit. If a section has more than 4, split it (`Core 1/2`, `Core 2/2`); more than 16 items in
  total, run a second round for the rest.
- Label: tool name and radar floor (`ruff 0.16+`). Description: the exact command you will run and
  the radar `url` it comes from.
- Say above the checklist that nothing is ticked by default: tick what to install, leave the rest.

Then, for each ticked item, one at a time:

1. Use the install method at the tool's radar `url` for this OS. Prefer user-level installs:
   `uv tool install`, `npm install -g` under nvm, Homebrew on macOS, the vendor's own install script.
2. **Anything needing `sudo`** (Docker Engine on Linux, `apt`, system packages) — do not run it:
   Claude cannot answer a password prompt. Give it as `! <command>` for the developer to run, and
   carry on with the rest.
3. After each install, re-run that tool's Step 2 check and report the version you actually saw.

Finish with a short table — installed ✅, left for the developer (`sudo`) ⏭, failed ❌ with the
error — and suggest running `/dev-check` again from a new terminal so `PATH` changes take effect.
