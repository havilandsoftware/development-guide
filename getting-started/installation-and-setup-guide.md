# Installation Guide

## Create Cloud Accounts
- Slack
- Github & Copilot
- Trello & Jira
- Google
- Github Copilot
- AWS
- Supabase

## Install WSL (Windows)
*NOTE: only necessary if using Windows*
- Ubuntu 22.04 LTS

## Setup Git

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
  git clone git@github.com:havilandsoftware/developer-guide.git
  ```

## Install Languages and Frameworks
- [Python 3.11](../technologies/python.md#installation)
- [Node.js v22](../technologies/javascript.md#installation)
- [Docker](https://docs.docker.com/engine/install/ubuntu)
- [uv (Python dependency manager)](../technologies/python.md#modern-dependency-management-with-uv)

## Install Developer Applications
- [Cursor](https://www.cursor.com/)
- [VSCode](https://code.visualstudio.com/download)
- [Atom](https://flight-manual.atom.io/getting-started/sections/installing-atom/)
- [DBeaver](https://dbeaver.io/download/)

## Install AI Tools
- [Claude Code CLI](../technologies/claude.md#installation) - AI-powered development assistant
- [GitHub CLI](https://cli.github.com/) - Required for Claude Code GitHub integration

## Install Browsers & Communication
- Slack
- Edge
- Chrome
- FireFox
- LastPass or other password manager

## Install Cloud CLI Tools
- [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html) - Amazon Web Services command line interface
- [gcloud CLI](https://cloud.google.com/sdk/docs/install) - Google Cloud Platform command line interface
- [Supabase CLI](https://supabase.com/docs/guides/local-development/cli/getting-started) - Supabase local development and project management
- [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/) - Kubernetes command line tool

## Install Additional CLI Tools
- [Terraform](https://developer.hashicorp.com/terraform/install)
- [Minikube](https://minikube.sigs.k8s.io/docs/start/)
- [Helm](https://helm.sh/docs/intro/install/)
