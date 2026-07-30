# Installation Guide

Tooling here is split into three tiers. **Install Tier 1 on day one** — it is what every developer
needs before opening any project. Tiers 2 and 3 are installed on demand and are covered in
[Additional Tooling](#additional-tooling-install-on-demand) at the end of this guide.

| Tier | What | When to install |
|------|------|-----------------|
| **1 — Core** | Git, uv, Python, nvm/Node, Docker, `gh`, Claude Code, linters, Supabase, Vercel | Onboarding. Required. |
| **2 — Project-specific** | Angular, Amplify, clasp, Codex | Only when you take on a project that uses it. |
| **3 — DevOps** | AWS, gcloud, kubectl, Terraform, Helm, Zapier | Only if you do infrastructure work. |

If a tool is missing when you import a project, `dev-check` run from inside that repo will tell you
exactly which tier-2/3 tools that project needs.

## Tier 1 — Create Cloud Accounts
- Slack
- Github & Copilot
- Trello & Jira
- Google
- Github Copilot
- AWS
- Supabase

## Tier 1 — Install WSL (Windows)
*NOTE: only necessary if using Windows*
- Ubuntu 22.04 LTS

## Tier 1 — Setup Git

### Install Git
- Install [Git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git). **Needs to be version 2.49+.**
- Setup [first time configuration](https://git-scm.com/book/en/v2/Getting-Started-First-Time-Git-Setup) locally.- 
```
  git config --global user.name "John Doe"
  git config --global user.email johndoe@example.com
  git config --global init.defaultBranch main
  git config --global core.editor nano
  git config --global --add --bool push.autoSetupRemote true
```
- Create account in Github.

### Create SSH Key and Add to Github
For more detailed instructions, refer to [this guide](https://www.unixtutorial.org/how-to-generate-ed25519-ssh-key/).
1. Generate the ssh key, then hit enter to create it in the default folder. *Notice the location of the id_ed25519.pub file in the output.*
`ssh-keygen -t ed25519 -C "your-email@goes-here"`
2. Type a password when prompted.
3. Run the command to output the public key.
`cat ~/.ssh/id_ed25519.pub`

Copy the contents into Github by
1. Click on picture > Settings > SSH and GPG keys > New SSH Key >
2. Put a name for your computer in the Title
3. Paste the contents of your ~/.ssh/id_ed25519.pub file in the Key
4. Click Add SSH key

### Create a Workspaces Directory
Test your installation by cloning the development guide repository to your local workspace.

1. Open a terminal.
2. Create the `~/workspaces/hs` directory:
  ```sh
  mkdir -p ~/workspaces/hs
  ```
3. Change into the new directory:
  ```sh
  cd ~/workspaces/hs
  ```
4. Clone the repository:
  ```sh
  git clone git@github.com:havilandsoftware/development-guide.git
  ```

## Tier 1 — Install Languages and Frameworks

### Python 3.12+

**Ubuntu:**
```bash
sudo apt update
sudo apt install software-properties-common
sudo add-apt-repository ppa:deadsnakes/ppa
sudo apt update
sudo apt install python3.12 python3.12-dev python3.12-venv
```

**macOS:**
```bash
brew update
brew install python@3.12
```

**Windows:** Download the Python 3.12 installer from [python.org/downloads](https://www.python.org/downloads/windows/), run it, and check "Add Python to PATH".

Note that `uv` provisions the right Python version per project, so this system Python is only a
baseline — you do not need to install every version you work with.

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

## Tier 1 — Install Developer Applications
- [Cursor](https://www.cursor.com/)
- [VSCode](https://code.visualstudio.com/download)
- [Atom](https://flight-manual.atom.io/getting-started/sections/installing-atom/)
- [DBeaver](https://dbeaver.io/download/)

## Tier 1 — Install AI Tools
- [Claude Code CLI](../technologies/claude.md#installation) - AI-powered development assistant
- [GitHub CLI](https://cli.github.com/) - Required for Claude Code GitHub integration

## Tier 1 — Install Browsers & Communication
- Slack
- Edge
- Chrome
- FireFox
- LastPass or other password manager

## Tier 1 — Linters, Formatters, and Platform CLIs

These are invoked by your editor and pre-commit hooks *before* any project environment is activated,
so they must be installed globally rather than per-project.

**Python globals** — always via `uv tool install`, never `pip install --user`:

```bash
uv tool install ruff    # linter + formatter (replaces flake8, black, isort)
uv tool install mypy    # static type checker
```

**Node globals:**

```bash
. ~/.nvm/nvm.sh
npm install -g typescript prettier pnpm
```

**Platform CLIs** — these act on projects from the shell, so they are machine-level too:

- [Supabase CLI](https://supabase.com/docs/guides/local-development/cli/getting-started) — PostgreSQL, auth, migrations
- [Vercel CLI](https://vercel.com/docs/cli) — Next.js deployments

Verify everything at once by running `dev-check` from outside any repository.

---

## Additional Tooling (Install On Demand)

Everything above is required. Everything below is **not** — install it only when a project or role
actually calls for it. Installing all of it up front creates a machine full of stale CLIs that
`dev-check` then reports as outdated.

The signal to install is concrete: you clone or import a project, run `dev-check` **from inside that
repository**, and it reports a tool that project depends on. Then install just that tool.

### Tier 2 — Project-Specific

Needed only by projects built on these platforms. New frontend projects use Next.js, so Angular is
maintenance-only; see [Coding Standards](../technologies/standards.md#4-javascript--typescript-standards).

| Tool | Install | Needed when |
|------|---------|-------------|
| [Angular CLI](https://angular.dev/tools/cli) | `npm install -g @angular/cli` | Maintaining an existing Angular app |
| [AWS Amplify CLI](https://docs.amplify.aws/cli/) | `npm install -g @aws-amplify/cli` | Project deploys via Amplify |
| [clasp](https://github.com/google/clasp) | `npm install -g @google/clasp` | Project ships Google Apps Script |
| [Codex CLI](https://github.com/openai/codex) | `npm install -g @openai/codex` | Project workflow uses Codex |

### Tier 3 — DevOps and Infrastructure

Needed only if you provision or operate infrastructure. A developer working purely on application
code does not need any of these.

| Tool | Install | Needed when |
|------|---------|-------------|
| [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html) | [installer](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html) | Deploying to or debugging AWS |
| [gcloud CLI](https://cloud.google.com/sdk/docs/install) | [installer](https://cloud.google.com/sdk/docs/install) | Working on Google Cloud |
| [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/) | [installer](https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/) | Operating Kubernetes / EKS |
| [Terraform](https://developer.hashicorp.com/terraform/install) | [installer](https://developer.hashicorp.com/terraform/install) | Managing infrastructure as code |
| [Helm](https://helm.sh/docs/intro/install/) | [installer](https://helm.sh/docs/intro/install/) | Deploying Kubernetes charts |
| [Minikube](https://minikube.sigs.k8s.io/docs/start/) | [installer](https://minikube.sigs.k8s.io/docs/start/) | Running Kubernetes locally |
| [Zapier Platform CLI](https://docs.zapier.com/platform/build-cli/overview) | `npm install -g zapier-platform-cli` | Building a Zapier integration |

**kubectl version skew:** Kubernetes supports only ±1 minor version between `kubectl` and the API
server, so match your cluster rather than always taking the newest release.
