# Security Policy

## Supported Versions

Only the current state of the `main` branch. This is a documentation repository — there are no
releases, tags, or versioned artifacts to support.

## Reporting a Vulnerability

**Do not open a public issue.** Use GitHub's private vulnerability reporting instead:

1. Go to the **Security** tab of this repository
2. Click **Report a vulnerability**
3. Describe what you found and how to reproduce it

That opens a private advisory visible only to the maintainers. If the Security tab is not available
to you, open a normal issue saying only that you have a security concern and asking for a private
channel — no details.

We aim to acknowledge a report **within 5 working days**. If a report is valid we will fix it and
credit you in the commit or advisory unless you would rather stay anonymous.

## Scope

This repository contains Markdown documentation and two Claude Code skills. There is no application,
no server, and no dependencies to exploit, so the realistic surface is narrow:

**In scope**

- A command in the guide that would damage a reader's machine, delete data, or weaken their security
  if run as written
- A command that sends data somewhere it should not — including anything that would leak a
  credential, token, or private key
- A credential, token, or other secret committed to this repository or present in its history
- A link that points somewhere malicious, or a domain we reference that has been taken over
- An instruction in `.claude/skills/` that could cause an AI agent to take a destructive or
  data-exfiltrating action

**Out of scope**

- Disagreement with a standard or a version floor — open a normal issue instead
- Vulnerabilities in the third-party tools this guide tells you to install (report those upstream)
- Anything requiring write access to this repository, which is restricted to maintainers
- Typos, broken links to moved documentation, and stale version numbers — normal issues, not
  security reports

## A Note on This Repository

This guide is published for reference and is maintained by Haviland Software for its own team. We do
not accept outside pull requests. Corrections and ideas are genuinely welcome as issues, and if you
would like to work with us, see [Join Us](https://www.pixelfuel.io/join-us).
