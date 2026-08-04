# Haviland Software Development Guide

Hello! 👋 My name is Karl Haviland and this is my company's development guide for your benefit to use freely! Over my nearly 20 year career, I have been lucky enough to hire and train many developers that work at some of the best development shops around the world. This repository captures many of the practices and technical background I use today to keep my teams up to date and in order. It is published openly because I believe in transparency and sharing such as coding standards, git workflow, AI-assisted development practices. I am continually adjusting this guide, so if you have ideas for new additions, please let me know!

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

## Claude Code Skills

This repository ships two skills. Clone it, run `claude` from inside it, and they are available —
there is nothing else to install.

- `/dev-check` — audit your machine against this guide
- `/interview` — guided walkthrough of the [interview task](getting-started/interview-test.md)

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
