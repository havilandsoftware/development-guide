# Haviland Software Development Guide

This is the internal development guide for
[Haviland Software](https://github.com/havilandsoftware), published openly because most of it —
coding standards, git workflow, AI-assisted development practices — is useful to anyone building
software. A few sections reference internal-only tooling and won't apply outside the org; the
standards themselves stand on their own.

*NOTE:* This guide is **not a tutorial**. Technologies change constantly, and the providers
building them maintain far better documentation than we could. The learning guide links out to the
resources we think are best.

## Getting Started

Work through these in order.

1. [Installation and Setup Guide](getting-started/installation-and-setup-guide.md) — accounts, tooling, machine setup, verification
2. [Expectations](getting-started/expectations.md) — how the team works
3. [AI Responsibility Guide](getting-started/ai.md) — using AI tools responsibly
4. [Learning Guide](getting-started/learning-guide.md) — what to learn, in what order
5. [Release Guide](getting-started/release-guide.md) — merged PR to verified production

## Technologies

| | |
|---|---|
| [Git & GitHub](technologies/git.md) | Branching, pull requests, `gh` CLI, repository standards |
| [Coding Standards](technologies/standards.md) | Structure, linting, testing, Docker, CI |
| [Claude Code](technologies/claude.md) | AI-assisted development, MCP |
| [InnoDay](technologies/innoday.md) | Tickets and projects *(internal)* |

## Claude Code Skills

This repository ships two skills that work once it is cloned:

- `/dev-check` — audit your machine against this guide
- `/interview` — guided walkthrough of the [interview task](getting-started/interview-test.md)

## Licence

Documentation is licensed [CC BY 4.0](https://creativecommons.org/licenses/by/4.0/); the embedded
code and configuration samples are additionally MIT-licensed so you can copy them into your own
projects freely. See [LICENSE](LICENSE).
