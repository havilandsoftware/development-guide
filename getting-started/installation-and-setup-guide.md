# Installation and Setup Guide

Work through this guide in order: create your accounts, install your programs, set up
your machine, then verify the result. You are not finished until the verification step
passes.

> **Versions verified:** 2026-07-29. Every version below is a **floor** — `2.55+` means
> 2.55 or newer. Newer is always fine. Run the verification step in section 4 to check
> your machine against the current floors.

---

## 1. Create Cloud Accounts

Create these before installing anything — several installers ask you to log in.

- Slack
- GitHub
- Linear
- InnoDay
- Google
- AWS
- Supabase
- Railway — you need the account to view deployments and logs even if you never install
  the CLI

Enable MFA on every one of them. See [Expectations](expectations.md#security-practices)
for why this is not optional.

---

## 2. Programs to Install

### Developer Tools

Everyone installs all of these, whatever you work on.

| Tool | Version | Install |
|------|---------|---------|
| Git | 2.55+ | [git-scm.com](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git) |
| GitHub CLI (`gh`) | 2.96+ | [cli.github.com](https://cli.github.com/) |
| nvm | 0.40+ | [nvm-sh/nvm](https://github.com/nvm-sh/nvm#installing-and-updating) |
| Node.js | 24.18+ | `nvm install 24 && nvm alias default 24` |
| uv | 0.11+ | `curl -LsSf https://astral.sh/uv/install.sh \| sh` |
| Python | 3.14 | Provisioned per-project by `uv` — see note below |
| Claude Code CLI | 2.1+ | `npm install -g @anthropic-ai/claude-code` |
| InnoDay CLI | latest | See [InnoDay](../technologies/innoday.md) |
| Docker Engine | 29.6+ | [docs.docker.com](https://docs.docker.com/engine/install/ubuntu) |

**Node.js — install via nvm, not your system package manager:**

```bash
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.6/install.sh | bash
source ~/.bashrc

nvm install 24
nvm alias default 24
```

Verify: `node --version` → `v24.x.x`

Node 24 is the current Active LTS. If you are still on Node 22 (now Maintenance LTS),
run the two `nvm` commands above to move across.

**Python — do not install a global Python.** `uv` provisions and pins the right Python
per project, which is why there is no `apt install python3.x` step here. Installing
Python globally leads to projects silently running against the wrong interpreter.

```bash
curl -LsSf https://astral.sh/uv/install.sh | sh
```

Verify: `uv --version`

**Claude Code** — after installing, see [Claude Code](../technologies/claude.md) for
configuration and working practices.

### Linters and Formatters

These must be installed **globally**, not per project — editors and pre-commit hooks
invoke them before any project environment is active.

| Tool | Version | Install |
|------|---------|---------|
| ruff | 0.16+ | `uv tool install ruff` |
| mypy | 2.3+ | `uv tool install mypy` |
| TypeScript | 6+ | `npm install -g typescript` |
| prettier | 3.9+ | `npm install -g prettier` |
| pnpm | 11+ | `npm install -g pnpm` |

```bash
uv tool install ruff mypy
. ~/.nvm/nvm.sh && npm install -g typescript prettier pnpm
```

Python globals go through `uv tool install`, never `pip install --user` — each gets an
isolated environment and a binary on your PATH.

### Platform CLIs — install as needed

Only if you work with the platform in question. These are shell tools invoked against any
project, so install them globally rather than as project dependencies.

| Tool | Install | When |
|------|---------|------|
| Supabase CLI | `npm install -g supabase` | Supabase projects |
| Vercel CLI | `npm install -g vercel` | Vercel deployments |
| AWS Amplify CLI | `npm install -g @aws-amplify/cli` | Amplify projects |
| Google clasp | `npm install -g @google/clasp` | Apps Script projects |
| Zapier CLI | `npm install -g zapier-platform-cli` | Zapier integrations |

### DevOps Tools

**Install this group only if you are working on infrastructure or deployments.** If you
are writing application code, skip it.

| Tool | Version | Install |
|------|---------|---------|
| Railway CLI | 5.30+ | [docs.railway.com/guides/cli](https://docs.railway.com/guides/cli) |
| Terraform | 1.15+ | [developer.hashicorp.com](https://developer.hashicorp.com/terraform/install) |
| gcloud CLI | 578+ | [cloud.google.com/sdk](https://cloud.google.com/sdk/docs/install) |
| AWS CLI | 2.36+ | [docs.aws.amazon.com](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html) |
| Supabase CLI | 2.110+ | [supabase.com/docs](https://supabase.com/docs/guides/local-development/cli/getting-started) |
| kubectl | 1.36+ | [kubernetes.io](https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/) |
| Minikube | 1.38+ | [minikube.sigs.k8s.io](https://minikube.sigs.k8s.io/docs/start/) |
| Helm | 4.2+ | [helm.sh](https://helm.sh/docs/intro/install/) |

**kubectl version skew:** Kubernetes supports kubectl within ±1 minor version of the
cluster's API server. Match your kubectl to the cluster you are targeting rather than
always taking the newest release.

### Editors & Applications

- [VSCode](https://code.visualstudio.com/download)
- [DBeaver](https://dbeaver.io/download/) — database client

### Browsers & Communication

- [Firefox](https://www.mozilla.org/firefox/)
- [Chrome](https://www.google.com/chrome/)
- Slack
- A password manager (LastPass, 1Password, or Bitwarden)

Two browsers, because anything user-facing needs testing in more than one engine.

---

## 3. Setup

### Create a Workspaces Directory

All repositories are cloned under `~/workspaces/`.

```bash
mkdir -p ~/workspaces
cd ~/workspaces
```

### Setup Git

Install Git 2.55+, then set your global configuration:

```bash
git config --global user.name "Your Name"
git config --global user.email "your-email@example.com"
git config --global init.defaultBranch main
git config --global core.editor nano
git config --global --add --bool push.autoSetupRemote true
```

Check what is set with `git config --global --list`.

### Create an SSH Key and Add It to GitHub

For a more detailed walkthrough, see
[this guide](https://www.unixtutorial.org/how-to-generate-ed25519-ssh-key/).

1. Generate the key, accepting the default location:

   ```bash
   ssh-keygen -t ed25519 -C "your-email@example.com"
   ```

2. Set a passphrase when prompted.
3. Print the public key:

   ```bash
   cat ~/.ssh/id_ed25519.pub
   ```

Add it to GitHub: profile picture → **Settings** → **SSH and GPG keys** →
**New SSH key**. Title it after your computer, paste the key contents, and save.

Test it:

```bash
ssh -T git@github.com
```

Expected: `Hi <username>! You've successfully authenticated...`

### Install WSL (Windows only)

*Skip this section on macOS and Linux.*

Install [WSL](https://learn.microsoft.com/en-us/windows/wsl/install) with Ubuntu
24.04 LTS, then run everything above from inside the WSL environment rather than
from PowerShell.

```powershell
wsl --install -d Ubuntu-24.04
```

---

## 4. Verify Your Setup

Installing tools and knowing they work are different things. Verify with the
[dev-check skill](../skills/dev-check/SKILL.md) bundled in this repository:

```
/dev-check
```

It prints a pass/fail table for every tool, your git configuration, SSH access, and
the InnoDay CLI and MCP server — with the exact fix command for anything missing or
out of date.

**You are not done onboarding until this comes back clean** — every ❌ resolved. Warnings
are fine to leave: they flag optional platform CLIs you may not need.

If `/dev-check` is not available as a slash command, the skill is written as
instructions rather than a script — open
[`skills/dev-check/SKILL.md`](../skills/dev-check/SKILL.md) and work through the checks by
hand, or copy the directory into `~/.claude/skills/` first. See
[Claude Code](../technologies/claude.md#skills-in-this-guide).

---

## Next Steps

- [Expectations](expectations.md) — how the team works
- [AI Responsibility Guide](ai.md) — using AI tools responsibly
- [Learning Guide](learning-guide.md) — what to learn first
- [Coding Standards](../technologies/standards.md) — project structure, linting, testing, CI
