# Haviland Software Development Guide

Hello!  My name is Karl Haviland and this is my company's development guide, for your benefit! I have
been lucky enough to build up developers who went off to work at some of the best computer science
and data science shops around the world. I am continuing to add and adjust to this guide — and if
you have ideas for new additions, please let me know!

It tries to balance the process for onboarding a new developer with speed and flexibility.

It is published openly because most of it — coding standards, git workflow, AI-assisted development
practices — is useful to anyone building software. A few sections reference internal-only tooling and
won't apply outside the org; the standards themselves stand on their own.

*NOTE:* This is **not a tutorial**. Technologies change constantly, and the providers building them
maintain far better documentation than we could. The learning guide links out to the resources we
think are best.

---

## Your First Week

Work through these in order. Days are a guide, not a deadline.

| | Do this | Read |
|---|---|---|
| **1** | Create your accounts, install the Tier 1 toolchain, configure git and SSH | [Installation and Setup Guide](getting-started/installation-and-setup-guide.md) |
| **1** | Run `/dev-check` and resolve every ❌ | ↑ section 4 |
| **2** | Learn how we work — branching, PRs, tickets, code review | [Expectations](getting-started/expectations.md) · [Git & GitHub](technologies/git.md) |
| **3** | Learn how we use AI, and where we are careful with it | [AI Responsibility Guide](getting-started/ai.md) · [Claude Code](technologies/claude.md) |
| **4** | Read the standards for your language before your first PR | [Coding Standards](technologies/standards.md) |
| **5** | Understand how code reaches production | [Release Guide](getting-started/release-guide.md) |
| **Ongoing** | Fill the gaps, in this order | [Learning Guide](getting-started/learning-guide.md) |

**The one thing that matters most:** if you are stuck, say so early. Asking a question on day one is
a good signal. Being quietly blocked for two days is the only real way to struggle here.

## Quick Start

```bash
mkdir -p ~/workspaces && cd ~/workspaces
git clone git@github.com:havilandsoftware/development-guide.git
cd development-guide && claude
> /dev-check
```

## Technologies

| | |
|---|---|
| [Git & GitHub](technologies/git.md) | Branching, pull requests, `gh` CLI, repository standards |
| [Coding Standards](technologies/standards.md) | Structure, linting, testing, Docker, CI |
| [Claude Code](technologies/claude.md) | AI-assisted development, MCP |
| [InnoDay](technologies/innoday.md) | Tickets and projects *(internal)* |

## Claude Code Skills

This repository ships two skills. Clone it, run `claude` from inside it, and they are available —
there is nothing else to install.

- `/dev-check` — audit your machine against this guide
- `/interview` — guided walkthrough of the [interview task](getting-started/interview-test.md)

## Join Us

**What we're looking for:** I value clear communication and thought, good questions, independence,
and organization over years of experience or whether you know the ins and outs of a specific
technology. Tools change; those habits are what make someone worth working with on the second
project as much as the first.

If that sounds like you, let us know you exist — fill out
[Join Us](https://www.pixelfuel.io/join-us).

## Licence

Documentation is licensed [CC BY 4.0](https://creativecommons.org/licenses/by/4.0/); the embedded
code and configuration samples are additionally MIT-licensed so you can copy them into your own
projects freely. See [LICENSE](LICENSE).
