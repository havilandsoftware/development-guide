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

Each tool's tier is the radar's `tier` column (Step 0). Radars without that column: use Tier 1 for
anything not listed as a Platform, Project or DevOps tool in the install guide.

| Tier | Radar `tier` | Verdict when missing |
|------|--------------|----------------------|
| **1 — Core** | `core` | ❌ **FAIL** — required for every developer |
| **1 — Platform** | `platform` | ⚠️ **WARN** — checked on every machine, offered in the install checklist |
| **2 — Project-specific** | `project` | ℹ️ **N/A** unless this repo needs it |
| **3 — DevOps** | `devops` | ℹ️ **N/A** unless this repo provisions infrastructure |

**Never fail a developer for a missing tier-2 or tier-3 tool.** Reporting a red ❌ for Terraform on
an application developer's machine trains people to ignore the report. Only flag tier 2/3 when the
current repository gives evidence it is needed (see Step 5).

---

## Step 0 — Load the Radar

Every version floor, install link and install command comes from a **radar** file: a CSV, one row
per tool. Nothing in this skill hard-codes a version or an install command. Pick the radar in this
order, and stop at the first that applies:

1. **An argument was passed** (`/dev-check 2026-07-29.csv`) — a local path if it exists, otherwise
   that name under `https://raw.githubusercontent.com/havilandsoftware/development-guide/main/radar/`, or a URL used as-is.
2. **You are inside a clone of this guide** (a `radar/` folder next to `.claude/skills/dev-check/`) —
   the local `radar/*.csv` whose name sorts last, so unmerged radar edits can be tested.
3. **Otherwise the published radar** named in `https://raw.githubusercontent.com/havilandsoftware/development-guide/main/radar/LATEST`.
4. **Offline** — `radar.csv` in this skill's base directory, which `install.sh` put there.

Name the radar file in the report's first line. If none of these yields a file whose first line
starts `technology,version,url`, stop and say so rather than guessing floors.

Columns (split on commas; no field contains one):

| Column | Meaning |
|--------|---------|
| `technology` | Matches a `Tool` name in the Step 2 check table |
| `version` | A floor (`2.55+`, anything newer passes) or `any` (present is enough) |
| `url` | The official install page |
| `tier` | `core`, `platform`, `project` or `devops` — see the tier table above |
| `requires` | Tools that must be installed first, `;`-separated |
| `linux` | Install-or-upgrade command on Ubuntu/WSL. Empty = follow `url` by hand. `-` = not used on this OS (skip the check) |
| `macos` | The same on macOS |

Older radars lack some columns: `2026-09-28.csv` has only the first three (treat every command as
empty), and `2026-09-29.csv` has no `tier`. A
tool this skill checks that the radar does not list is reported `could not determine floor`, not
failed.

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
| curl | `curl --version \| head -1` |
| Git | `git --version` |
| uv | `uv --version` |
| Python | `python3 --version` |
| nvm | `. "$HOME/.nvm/nvm.sh" && nvm --version` |
| Node.js | `(. "$HOME/.nvm/nvm.sh" 2>/dev/null && { nvm use --silent default >/dev/null 2>&1 \|\| :; }; node --version)` |
| Docker | `docker --version` |
| GitHub CLI | `gh --version \| head -1` |
| Claude Code | `claude --version` |
| InnoDay CLI‡ | `innoday --version 2>/dev/null \| grep -oE 'v?[0-9]+\.[0-9]+\.[0-9]+[^ ]*' \| head -1` |
| ruff | `ruff --version` |
| mypy | `mypy --version` |
| TypeScript | `(. "$HOME/.nvm/nvm.sh" 2>/dev/null && { nvm use --silent default >/dev/null 2>&1 \|\| :; }; tsc --version)` |
| prettier | `(. "$HOME/.nvm/nvm.sh" 2>/dev/null && { nvm use --silent default >/dev/null 2>&1 \|\| :; }; prettier --version)` |
| pnpm | `(. "$HOME/.nvm/nvm.sh" 2>/dev/null && { nvm use --silent default >/dev/null 2>&1 \|\| :; }; pnpm --version)` |
| Supabase CLI† | `(. "$HOME/.nvm/nvm.sh" 2>/dev/null && { nvm use --silent default >/dev/null 2>&1 \|\| :; }; supabase --version)` |
| Vercel CLI† | `(. "$HOME/.nvm/nvm.sh" 2>/dev/null && { nvm use --silent default >/dev/null 2>&1 \|\| :; }; vercel --version)` |
| AWS CLI† | `aws --version` |
| gcloud CLI† | `gcloud --version 2>/dev/null \| head -1` |
| Homebrew (macOS only) | `brew --version \| head -1` |

‡ InnoDay is Haviland Software's internal tool. Missing → ❌ only for Haviland Software developers;
anyone else → ℹ️ N/A, and skip Step 4. This guide is public.

† Platform CLIs — report ⚠️ WARN, not ❌ FAIL. They are the approved platforms
([standards](https://github.com/havilandsoftware/development-guide/blob/main/technologies/standards.md#7-approved-infrastructure--services)), but a
backend-only developer has no use for `vercel`, and hard-failing them for it is the same mistake as
failing them for Terraform. They are still offered in the Step 7 checklist, so installing them is one
tick away.

**Node and its global tools are checked under the nvm default** (the checks above select it).
That is what a new terminal uses. A shell started before a Node upgrade still has the old Node, and
its old global tools, first on `PATH`. Checking those reports versions the developer will never see
again. If plain `node --version` differs from the nvm default, mention it as `open a new terminal`;
it is not a failure.

**Python is checked but not installed globally per-version.** `uv` provisions the right Python per
project, so a 3.12+ system Python is a baseline only. Do not tell anyone to install every version.
New projects use 3.14 — see
[LTS Version Policy](https://github.com/havilandsoftware/development-guide/blob/main/technologies/standards.md#2-lts-version-policy) for the distinction
between the minimum supported and what new work starts on.

**Fix commands come only from the radar** (Step 7d), never from this file or from memory. A tool
present but below its floor is ⚠️ OUTDATED. Its fix is the radar command for this OS, which is
written to install or upgrade.

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

**4a — Signed in:** everyday CLI and MCP use needs only a sign-in token. There is no org to pick
here: the org comes from whichever InnoDay workspace you are working in.

```bash
innoday whoami 2>&1 | head -1
```

Give it 30 seconds (Bash tool timeout). Report only the verdict, never the name, email or orgs it
prints:

- A name with an email in brackets → ✅ signed in.
- `Cannot reach InnoDay` or a timeout → ⚠️ could not reach InnoDay. This is not a sign-in problem,
  so don't suggest `innoday login`; re-run later.
- Anything else → ❌, fix `innoday login`.

Don't use `innoday status` here: it loads every project in every org, which can take over 30
seconds. It also says "cannot reach" for a network blip, which reads like a sign-in failure.

A plain `401` from the CLI or MCP means the token: `innoday login`. If MCP `401`s while the CLI
works, the MCP server cached old config at startup — `/mcp reconnect`.

**4b — API reachable:**

```bash
innoday ping api 2>&1
```

Give it 20 seconds. Exit 0 → ✅. Unreachable or timed out → ⚠️ WARN, not ❌: the API may simply not be running, which says nothing
about the developer's machine. Show `innoday config show` to confirm the configured URL.

**4c — MCP server registered:**

```bash
claude mcp list 2>/dev/null
```

Give it 90 seconds: it health-checks every configured server, and one slow server can hold it up.
Look for a server named `innoday`. Connected → ✅ / Error or absent → ❌, fix
`claude mcp add innoday -- mcp-server-innoday`. If `claude mcp list` itself fails, ⚠️ WARN — the
Claude Code CLI is unavailable, which Step 2 already reported.

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

**Context:** REPO — git repo detected (Python) · **Radar:** `2026-09-30.csv`

### Tier 1 — Core Toolchain

| Tool | Required | Found | Status |
|------|----------|-------|--------|
| Git | 2.55+ | 2.55.0 | ✅ |
| uv | 0.11+ | 0.8.3 | ⚠️ `uv self update` |
| Node.js | 24+ | v24.21.0 | ✅ |
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
| signed in | ✅ profile `dev` |
| `ping api` | ⚠️ API unreachable — `innoday config show` |
| Claude Code MCP | ✅ connected |

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
- **A network failure is never a ❌.** If a check that goes over the network times out or can't
  connect (SSH to GitHub, InnoDay, MCP), report ⚠️ `could not reach — re-run` and keep going. The
  developer's machine may be fine.
- Distinguish ❌ FAIL (tier 1 missing), ⚠️ WARN (present but outdated, or a platform/tier-2/3 tool
  this developer does not need yet), and ℹ️ N/A (tier 2/3 with no marker in this repo). Three
  states, used consistently.
- **Sample values above must stay consistent with the newest radar.** Showing `uv 0.8.3` as ✅
  against a 0.11+ floor teaches the wrong thing; regenerate this block whenever floors move.
- Nothing is installed during Steps 1–6. Installing happens only in Step 7, and only what the
  developer picks.

---

## Step 7 — Offer to Install

If the report has no ❌ or ⚠️ items, skip to 7b. Otherwise:

### 7a — Pick what to install

First ask one question (single select): **"Install all N items (Recommended)"**, **"Let me choose"**,
or **"Skip"**. List the N items and their commands in the question text. Tier 2/3 tools are included
only if Step 5 flagged them.

On **Let me choose**, show checklists with `AskUserQuestion` (`multiSelect: true`):

- One question per report section (Core, Platform, Project), up to 4 options each — the tool's
  limit. More than 4, split it (`Core 1/2`, `Core 2/2`); more than 16 in total, a second round.
- Label: tool and floor (`ruff 0.16+`). Description: the exact command and the radar `url`.
- Say that nothing is ticked yet: tick what to install.

### 7b — Upgrade tools that already pass

Ask once (single select): **"Also upgrade tools that already pass?"** — `No (Recommended)` / `Choose`.
On `Choose`, offer every ✅ tool that has a radar command, in checklists as in 7a. This is how a
passing tool such as gcloud gets upgraded.

### 7c — Order

Install in dependency order, never in the order ticked:

1. Build the order from the radar's `requires` column: a tool goes after everything it requires,
   and ties keep radar order. On macOS, every `brew …` command also requires Homebrew. A
   requirement whose command for this OS is `-` counts as present (curl ships with macOS).
2. If a required tool is missing and was not ticked, add it and say so — `ruff` cannot install
   without `uv`.

### 7d — Commands

Use the radar column for this OS (`linux` or `macos`) exactly as written. **Never improvise a
command.** If the column is empty, list the tool as manual with its `url`.

Change the command only in these cases:

- **Existing install from a package manager.** If `dpkg -S "$(readlink -f "$(command -v <tool>)")"`
  names a package, upgrade with `sudo apt-get install --only-upgrade <package>`. If the tool's path
  is under `$(brew --prefix)`, use `brew upgrade <formula>`. The vendor script would install a
  second copy.
- **Needs nvm.** For a command whose `requires` includes `Node.js` or `nvm`, prefix it with
  `. ~/.nvm/nvm.sh && { nvm use --silent default >/dev/null 2>&1 || :; } &&`. The `|| :` matters:
  on a fresh machine there is no default yet, and a bare `nvm use default` fails the first Node
  install.
- **Needs uv.** For a command whose `requires` includes `uv`, prefix it with
  `export PATH="$HOME/.local/bin:$PATH" &&`. A `uv` (or Claude Code) installed a moment ago lives in
  `~/.local/bin`, which this shell does not have on `PATH` until a new terminal.
- **Moving to a new Node major.** When a Node is already installed, add
  `--reinstall-packages-from=<old version>` to `nvm install`, so global tools such as TypeScript
  and prettier come across. Otherwise they vanish from `PATH`.

### 7e — Run, then hand back the rest

1. Run each non-`sudo` command, one at a time, in the 7c order, as
   `bash -o pipefail -c '<command>'`. **`pipefail` is required.** Without it,
   `curl … | sh` reports success when `curl` is missing or the download fails, and the tool
   silently never installs. Stop that tool's chain on failure; carry on with unrelated tools.
2. **Do not run any command containing `sudo`.** Claude cannot answer a password prompt. Collect
   them as one block of `! <command>` lines in 7c order, so the developer can paste once.
   - **Blocking `sudo` first.** If a ticked non-`sudo` tool requires a `sudo` one that is missing
     (on a bare Ubuntu, `uv` needs `curl`), print that block **before** installing anything.
     Ask the developer to run it and say when done, re-check, then continue. Otherwise hand the
     block over at the end.
3. After each install, re-run that tool's Step 2 check and report the version you actually saw.
   Run Node-based checks through the same nvm prefix and every check with `~/.local/bin` on
   `PATH`: the current shell may still have the old Node first on `PATH`, and not have tools
   installed a moment ago.

Finish with a table — installed ✅, `sudo` for the developer ⏭, manual (empty radar command) 📖,
failed ❌ with the error. Then tell them to open a new terminal and run `/dev-check` again.
