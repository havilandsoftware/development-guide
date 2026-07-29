# Development Guide Restructure — Design

**Date:** 2026-07-29
**Repo:** `havilandsoftware/development-guide`
**Branch:** `feature/development-guide-restructure`

## Purpose

Bring the onboarding guide in line with the tools the team actually uses. Today it
sends a new hire to Trello, Jira, Cursor, GitHub Copilot (listed twice), and Atom —
none of which are current. It also scatters accounts, installs, and machine setup
through a single file in no deliberate order, and omits InnoDay entirely.

Success means a new hire can read four documents top to bottom, in order, and end
up with a working machine and a clear picture of how the team works.

## Scope

Six files change. One is new.

| File | Action |
|------|--------|
| `getting-started/installation-and-setup-guide.md` | Restructure into 3 ordered sections |
| `getting-started/learning-guide.md` | Rewrite as a hub with 5 focus areas |
| `technologies/innoday.md` | New |
| `README.md` | Reorder, add InnoDay |
| `getting-started/ai.md` | Drop Cursor and Copilot from tools table |
| `getting-started/release-guide.md` | Jira/Trello → Linear/InnoDay |
| `getting-started/expectations.md` | Atlassian → Linear in security practices |
| `getting-started/interview-test.md` | Cursor/Copilot → Claude Code (2 lines) |
| `CLAUDE.md` | Cursor → Claude Code as primary tool |

Out of scope: `technologies/standards.md` (565 lines of coding standards, unaffected)
and `technologies/git.md` content.

## 1. Installation and Setup Guide

Stays one file. Its `##` sections are reordered and regrouped into three numbered
sections. The document order is deliberate: you cannot install tooling before you
have accounts, and you cannot configure git before the tools exist.

### `## 1. Create Cloud Accounts`

```
- Slack
- GitHub
- Linear
- InnoDay
- Google
- AWS
- Supabase
- Railway
```

Changes from current: `Github & Copilot` → `GitHub`; the duplicate standalone
`Github Copilot` line is deleted; `Trello & Jira` → `Linear`; `InnoDay` and
`Railway` added.

### `## 2. Programs to Install`

Four subsections. The first applies to everyone; the second is conditional.

**`### Developer Tools`** — every developer installs all of these.

- GitHub CLI (`gh`)
- nvm + Node.js v22
- uv + Python 3.11+
- Claude Code CLI — `npm install -g @anthropic-ai/claude-code`, then the pixelfuel
  plugin; links to `technologies/claude.md`
- InnoDay CLI — `uv tool install`; links to `technologies/innoday.md`
- Docker

This consolidates what are currently three separate sections ("Install Languages and
Frameworks", "Install AI Tools", and the GitHub CLI entry) into one grouping, since
the distinction between a language runtime and a CLI tool does not affect what a new
hire has to do.

**`### DevOps Tools`** — prefaced with: *"Install this group only if you are working
on infrastructure or deployments."*

- Railway CLI
- Terraform
- gcloud CLI
- AWS CLI
- Supabase CLI
- kubectl
- Minikube
- Helm

**`### Editors & Applications`**

- VSCode
- DBeaver

Cursor is removed (the team standardised on Claude Code). Atom is removed (the
project was discontinued in 2022).

**`### Browsers & Communication`**

- Firefox
- Chrome
- Slack
- LastPass or another password manager

Edge is removed. Slack and the password manager stay in this section as day-one
desktop applications.

### `## 3. Setup`

Three subsections in this order:

1. **Create a Workspaces Directory** — `mkdir -p ~/workspaces/hs`
2. **Setup Git** — install (2.49+), first-time global config, SSH key generation and
   upload to GitHub. Ends by cloning this repository into the workspace as a test.
3. **Install WSL (Windows)** — last, as it applies to a subset of machines.

Note: the existing clone step references `developer-guide.git`; the repository is
`development-guide`. Fix the URL while moving the section.

## 2. Learning Guide

Rewritten as a hub. Five focus areas, each with a short "what you should be able to
do" framing, a link to the authoritative internal doc, and two to four curated
external resources. No tutorial content is written inline — this respects the repo's
stated no-tutorials rule.

Section order:

1. **Git Basics** → `technologies/git.md`, plus GitHub's Hello World and Pro Git
2. **Claude Basics** → `technologies/claude.md`, plus Anthropic's docs and prompting guide
3. **AI Safety** → `getting-started/ai.md`, plus external responsible-AI resources
4. **Releases** → `getting-started/release-guide.md`, plus blastoff usage
5. **Expectations & Rules** → `getting-started/expectations.md` and `technologies/standards.md`

AI Safety follows Claude Basics so a reader learns to use the tool and then
immediately learns to use it responsibly.

A `## Further Reading` appendix preserves the existing language and framework
tutorials (Python, Node, React, Next.js, Supabase), the book recommendations, and
the ThoughtWorks Radar link. The Angular and Kubernetes tutorial links are dropped
as stale relative to the current stack. The empty "Video Recommendations" heading is
dropped.

## 3. New: technologies/innoday.md

A short reference, consistent in length and tone with `technologies/git.md` (64
lines) rather than `technologies/claude.md` (148 lines).

Contents:

- What InnoDay is: the platform holding orgs, projects, tickets, and boards
- CLI install and `innoday config init`
- Core commands: `innoday tickets list`, `innoday projects show`, `innoday orgs current`
- The structural model: Org → Project → Tickets / Boards
- **CLI-only rule**: agents, skills, and CI use the `innoday` CLI. Only the UI talks
  to the API directly. No `curl`, `httpx`, or direct API calls.
- Note that the CLI resolves org and project from the working directory; do not pass
  `--organization` as a matter of course.

## 4. Consistency Edits

These are not optional. Cursor, Copilot, Trello, and Jira each appear in more than
one file; removing them from the install guide alone leaves the guide contradicting
itself.

- **`README.md`** — Getting Started list becomes:

  1. [Installation and Setup Guide](getting-started/installation-and-setup-guide.md)
     — accounts, programs, setup
  2. [Expectations](getting-started/expectations.md)
  3. [AI Responsibility Guide](getting-started/ai.md)
  4. [Learning Guide](getting-started/learning-guide.md)

  The install guide moves to first position so the top-level reading order matches
  the requested Accounts → Programs → Setup → Learning progression, with the Learning
  Guide last. Expectations and the AI Responsibility Guide sit between them because
  the Learning Guide links onward to both. Add InnoDay to the Technologies list.
- **`getting-started/ai.md`** — remove the Cursor and GitHub Copilot rows from the
  Tools and Frameworks table, leaving Claude Code and claude.ai.
- **`getting-started/release-guide.md`** — step 1 says "close all associated tickets
  in Jira/Trello"; change to Linear/InnoDay.
- **`getting-started/expectations.md`** — security practices lists "AWS, Atlassian,
  Github, Slack"; change to "AWS, GitHub, Linear, Slack".
- **`getting-started/interview-test.md`** — two lines direct candidates to install
  Cursor and enable Copilot. Line 17 becomes "Install VSCode and the Claude Code
  CLI"; line 47 becomes "Use Claude Code or other AI tools for support during
  development". No other change to the interview test.
- **`CLAUDE.md`** — the AI-First Approach section names Cursor as the primary AI
  coding tool; replace with Claude Code. Update the install-guide section list under
  "Updating Installation Guides" to match the new three-section structure.

## Verification

No build or test exists in this repository. Verification is:

1. Every internal markdown link resolves to a file that exists
2. No occurrence of Cursor, Copilot, Trello, Jira, Atom, or Edge remains outside of
   intentional historical context — confirmed by grep
3. The install guide reads in the order Accounts → Programs → Setup
4. `README.md` links to every file in `getting-started/` and `technologies/`

## Delivery

Work happens in the worktree at
`~/workspaces/hs/pf/.worktrees/development-guide-restructure` on branch
`feature/development-guide-restructure`. Commits are grouped by logical change
(install guide, learning guide, InnoDay doc, consistency edits). Delivered as a pull
request via `gh pr create`. No direct commits to `main`.
