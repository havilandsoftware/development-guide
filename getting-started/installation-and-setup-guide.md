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
- Install [Git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git). **Needs to be version 2.40+.**
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
- [Python](../technologies/python.md#installation)
- [Node.js](../technologies/javascript.md#installation)
- [Docker](https://docs.docker.com/engine/install/ubuntu)

## Install Developer Applications
- [Cursor](https://www.cursor.com/)
- [VSCode](https://code.visualstudio.com/download)
- [Atom](https://flight-manual.atom.io/getting-started/sections/installing-atom/)
- [DBeaver](https://dbeaver.io/download/)

## Install Browsers & Communication
- Slack
- Edge
- Chrome
- FireFox
- LastPass or other password manager

## Install CLI Tools
- Kubectl
- Terraform
- Minikube
- Helm
