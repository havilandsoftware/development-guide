# Installation and Setup Guide

Work through this guide in order: create your accounts, install your programs, set up your
machine, then verify the result. You are not finished until the verification step passes.

Tooling is split into three tiers. **Install Tier 1 on day one** — it is what every developer
needs before opening any project. Tiers 2 and 3 are installed on demand and are covered in
[Additional Tooling](#additional-tooling-install-on-demand) at the end.

| Tier | What | When to install |
|------|------|-----------------|
| **1 — Core** | Git, uv, Python, nvm/Node, Docker, `gh`, Claude Code, InnoDay, linters | Onboarding. Required. |
| **1 — Platform** | Supabase, Vercel, AWS CLI, gcloud | Onboarding, or when you first deploy to them. |
| **2 — Project-specific** | Angular, Amplify, clasp | Only when you take on a project that uses it. |
| **3 — DevOps** | Railway, kubectl, Terraform, Helm, Minikube, Zapier | Only if you do infrastructure work. |

If a tool is missing when you import a project, `/dev-check` run from inside that repo will
tell you exactly which tier-2/3 tools that project needs.

> **Versions:** this guide does not repeat them. The minimum for every tool, and where to
> install it, is in the newest file in the [radar](../radar/) folder — the same file `/dev-check` checks
> against. Every version there is a floor: `2.55+` means 2.55 or newer.

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
- Railway — needed to view deployments and logs even if you never install the CLI

Enable MFA on every one of them. See
[Expectations → Security Practices](expectations.md#security-practices) for why that is not
optional.

---

## 2. Programs to Install

### Tier 1 — Core Toolchain

Everyone installs all of these, whatever you work on.

| Tool | Install |
|------|---------|
| Git | [git-scm.com](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git) |
| GitHub CLI (`gh`) | [cli.github.com](https://cli.github.com/) |
| nvm | [nvm-sh/nvm](https://github.com/nvm-sh/nvm#installing-and-updating) |
| Node.js | `nvm install 24 && nvm alias default 24` |
| uv | `curl -LsSf https://astral.sh/uv/install.sh \| sh` |
| Python | Provisioned per-project by `uv` — see below |
| Claude Code CLI | `npm install -g @anthropic-ai/claude-code` |
| InnoDay CLI | `uv tool install innoday` — see [InnoDay](../technologies/innoday.md) |
| Docker Engine | [docs.docker.com](https://docs.docker.com/engine/install/ubuntu) |

**Node.js — install via nvm, not your system package manager:**

```bash
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.6/install.sh | bash
source ~/.bashrc

nvm install 24
nvm alias default 24
```

Verify: `node --version` → `v24.x.x`

Node 24 is the current Active LTS. If you are still on Node 22 (now Maintenance LTS), the two
`nvm` commands above move you across.

**Python — do not install a global Python per version.** `uv` provisions and pins the right
interpreter per project, which is why there is no `apt install python3.x` step here.

```bash
curl -LsSf https://astral.sh/uv/install.sh | sh
```

Verify: `uv --version`

**Claude Code** — after installing, see [Claude Code](../technologies/claude.md) for
configuration, MCP servers, and working practices.

### Tier 1 — Linters and Formatters

Your editor and pre-commit hooks invoke these *before* any project environment is active, so
they must be global rather than per-project.

| Tool | Install |
|------|---------|
| ruff | `uv tool install ruff` |
| mypy | `uv tool install mypy` |
| TypeScript | `npm install -g typescript` |
| prettier | `npm install -g prettier` |
| pnpm | `npm install -g pnpm` |

```bash
uv tool install ruff mypy
. ~/.nvm/nvm.sh && npm install -g typescript prettier pnpm
```

Python globals always go through `uv tool install`, never `pip install --user` — each gets an
isolated environment and a binary on your PATH.

### Tier 1 — Platform CLIs

These act on projects from the shell, so they are machine-level too. Install whichever you
need; a backend-only developer will not need `vercel`.

- [Supabase CLI](https://supabase.com/docs/guides/local-development/cli/getting-started) — Postgres, auth, migrations
- [Vercel CLI](https://vercel.com/docs/cli) — Next.js deployments
- [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html) — AWS services
- [gcloud CLI](https://cloud.google.com/sdk/docs/install) — Google Cloud

### Tier 1 — Editors and Applications

- [VSCode](https://code.visualstudio.com/download)
- [DBeaver](https://dbeaver.io/download/) — database client

Claude Code is the team's AI tool and is in the core table above; there is no separate
AI-assisted IDE to install.

### Tier 1 — Browsers and Communication

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

Add it to GitHub: profile picture → **Settings** → **SSH and GPG keys** → **New SSH key**.
Title it after your computer, paste the key contents, and save.

Test it:

```bash
ssh -T git@github.com
```

Expected: `Hi <username>! You've successfully authenticated...`

### Clone This Guide

```bash
cd ~/workspaces
git clone git@github.com:havilandsoftware/development-guide.git
```

That proves SSH works and gives you the `/interview` skill. You do not need the clone for
`/dev-check` — see the next section.

### Install WSL (Windows only)

*Skip this section on macOS and Linux.*

Install [WSL](https://learn.microsoft.com/en-us/windows/wsl/install) with Ubuntu 24.04 LTS,
then run everything above from inside WSL rather than from PowerShell.

```powershell
wsl --install -d Ubuntu-24.04
```

---

## 4. Verify Your Setup

Installing tools and knowing they work are different things. Verify with the `dev-check`
skill. Install it once — this also installs Claude Code if it is missing — then run it from
outside any project directory:

```bash
curl -fsSL https://raw.githubusercontent.com/havilandsoftware/development-guide/main/install.sh | sh
cd ~ && claude
> /dev-check
```

It reports your core toolchain, git config, SSH access, and the InnoDay CLI and MCP server,
with a copy-pasteable fix for anything missing.

**You are not done onboarding until every ❌ is resolved.** Warnings are fine to leave — they
flag platform CLIs you may not need yet. Run it again from *inside* a project to find out
which tier-2/3 tools that project requires.

---

## Additional Tooling (Install On Demand)

Everything above is required. Everything below is **not** — install it only when a project or
role actually calls for it. Installing all of it up front creates a machine full of stale
CLIs that `dev-check` then reports as outdated.

The signal to install is concrete: you clone or import a project, run `/dev-check` **from
inside that repository**, and it reports a tool that project depends on. Then install just
that tool.

### Tier 2 — Project-Specific

Needed only by projects built on these platforms. New frontend projects use Next.js, so
Angular is maintenance-only; see
[Coding Standards](../technologies/standards.md#4-javascript--typescript-standards).

| Tool | Install | Needed when |
|------|-------------|
| [Angular CLI](https://angular.dev/tools/cli) | `npm install -g @angular/cli` | Maintaining an existing Angular app |
| [AWS Amplify CLI](https://docs.amplify.aws/cli/) | `npm install -g @aws-amplify/cli` | Project deploys via Amplify |
| [clasp](https://github.com/google/clasp) | `npm install -g @google/clasp` | Project ships Google Apps Script |

### Tier 3 — DevOps and Infrastructure

Needed only if you provision or operate infrastructure. A developer working purely on
application code does not need any of these.

| Tool | Needed when |
|------|-------------|
| [Railway CLI](https://docs.railway.com/guides/cli) | Deploying to or debugging Railway |
| [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/) | Operating Kubernetes / EKS |
| [Terraform](https://developer.hashicorp.com/terraform/install) | Managing infrastructure as code |
| [Helm](https://helm.sh/docs/intro/install/) | Deploying Kubernetes charts |
| [Minikube](https://minikube.sigs.k8s.io/docs/start/) | Running Kubernetes locally |
| [Zapier Platform CLI](https://docs.zapier.com/platform/build-cli/overview) | Building a Zapier integration |

**kubectl version skew:** Kubernetes supports only ±1 minor version between `kubectl` and the
API server, so match your cluster rather than always taking the newest release. Current
stable: `curl -Ls https://dl.k8s.io/release/stable.txt`.

---

## Next Steps

- [Expectations](expectations.md) — how the team works
- [AI Responsibility Guide](ai.md) — using AI tools responsibly
- [Learning Guide](learning-guide.md) — what to learn first
- [Coding Standards](../technologies/standards.md) — project structure, linting, testing, CI
