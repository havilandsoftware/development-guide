# Haviland Software Development Guide

**Set up your machine in one command.** It works on macOS, Linux, and WSL, and you don't need to clone anything:

```bash
curl -fsSL https://raw.githubusercontent.com/havilandsoftware/development-guide/main/install.sh | sh
claude
> /dev-check
```

This installs Claude Code and the `/dev-check` skill. `/dev-check` then checks your machine against
the newest [technology radar](radar/) and gives you a checklist of what to install.
[Details ↓](#quick-start--dev-check)

---

Hello! 👋 My name is Karl Haviland and this is my company's development guide for your benefit to use freely! Over my nearly 20 year career, I have been lucky enough to hire and train many developers that work at some of the best development shops around the world. This repository captures many of the practices and technical background I use today to keep my teams up to date and in order. It is published openly because I believe in transparency and sharing such as coding standards, git workflow, AI-assisted development practices. I am continually adjusting this guide, so if you have ideas for new additions, please let me know!

---

## Your First Week

Work through these in order. Days are a guide, not a deadline.

| | Do this | Read |
|---|---|---|
| **1** | Run the [Quick Start](#quick-start--dev-check) one-liner, then `/dev-check`, and resolve every ❌ | [Quick Start](#quick-start--dev-check) |
| **1** | Create your accounts, install anything `/dev-check` flagged, configure git and SSH | [Installation and Setup Guide](getting-started/installation-and-setup-guide.md) |
| **2** | Learn how we work — branching, PRs, tickets, code review | [Expectations](getting-started/expectations.md) · [Git & GitHub](technologies/git.md) |
| **3** | Learn how we use AI, and where we are careful with it | [AI Responsibility Guide](getting-started/ai.md) · [Claude Code](technologies/claude.md) |
| **4** | Read the standards for your language before your first PR | [Coding Standards](technologies/standards.md) |
| **5** | Understand how code reaches production | [Release Guide](getting-started/release-guide.md) |
| **Ongoing** | Fill the gaps, in this order | [Learning Guide](getting-started/learning-guide.md) |

**The one thing that matters most:** if you are stuck, say so early. Asking a question on day one is
a good signal. Being quietly blocked for two days is the only real way to struggle here.

## Quick Start — `/dev-check`

One command on any macOS, Linux, or WSL machine. No clone needed:

```bash
curl -fsSL https://raw.githubusercontent.com/havilandsoftware/development-guide/main/install.sh | sh
```

It installs [Claude Code](https://docs.claude.com/en/docs/claude-code/overview) if you do not have
it, and adds the `/dev-check` skill for your user. Then:

```bash
claude
> /dev-check
```

`/dev-check` audits your machine against this guide: toolchain, cloud CLIs, git config, SSH, and
InnoDay. Then it offers to install what's missing. Run it again until it is clean. Run it from inside a project and it also checks what that project needs.

It prints every tool `/dev-check` will check, with its minimum version and install link. After the
audit, `/dev-check` shows a checklist of what's missing. Tick what you want and it installs those.
Anything that needs `sudo`, it hands back for you to run.

Versions and install links come from the [technology radar](radar/): dated CSVs, with the newest one
used by default. To use a different one, pass a radar file name, a local path, or a URL:

```bash
curl -fsSL https://raw.githubusercontent.com/havilandsoftware/development-guide/main/install.sh | sh -s -- 2026-09-28.csv
```

Piping a script into your shell deserves a look first: [`install.sh`](install.sh) is under 80 lines,
needs no `sudo`, and writes only to `~/.claude/skills/dev-check/` (plus Anthropic's own Claude Code
installer when `claude` is missing). Re-run it any time to pick up the latest checks.

### Other skills

`/interview` — a guided walkthrough of the [interview task](getting-started/interview-test.md) —
ships in this repo. Clone it and run `claude` from inside to use it.

## Join Us

If you're interested in working with an amazing group of innovators, we value clear communication and thought, good questions, independence, and organization over years of experience or whether you know the ins and outs of a specific
technology. Tools change; those habits are what make someone worth working with on the second
project as much as the first!

If that sounds like you, let us know you exist — fill out
[Join Us](https://www.pixelfuel.io/join-us).

## Contributing

This guide is published for reference and is maintained by our own team, so we do not accept outside
pull requests. That said, I meant what I said above about wanting ideas — **open an issue**. Spotted a
stale version, a broken link, or a standard that no longer makes sense? That is genuinely useful and
I would rather hear it.

Security concerns go through [SECURITY.md](SECURITY.md), not a public issue.

## Licence

Documentation is licensed [CC BY 4.0](https://creativecommons.org/licenses/by/4.0/); the embedded
code and configuration samples are additionally MIT-licensed so you can copy them into your own
projects freely. See [LICENSE](LICENSE).
