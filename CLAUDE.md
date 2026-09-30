# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is the **Haviland Software Development Guide** - a comprehensive documentation repository that outlines technologies, processes, and development standards for the team. This is NOT a tutorial repository; it provides curated links to external resources and establishes team standards.

The guide is structured into three main sections:
- **getting-started/**: Onboarding materials, expectations, installation guides, and learning resources
- **technologies/**: Language and framework-specific guidelines (Git, Coding Standards, Claude Code)

## Repository Purpose & Architecture

This is a **documentation-only repository** with no code to build, test, or run. The architecture is intentionally simple:
- All content is in Markdown (.md) files
- Navigation starts from README.md which links to all major sections
- Documentation follows a hierarchical structure: Getting Started → Technologies → Processes

## Key Team Principles

When editing this guide, respect these core team values:

### AI-First Approach
The team is "Responsible AI First" - they actively use AI tools in creative ways while maintaining ethical standards. The team uses:
- Claude Code (primary AI coding tool)
- VSCode as the editor — plain, no AI plugins. Do not reintroduce Cursor or Copilot.
- Focus on responsible, methodical, and iterative AI usage

### Documentation Standards
When creating or updating documentation in this repository:
- **Do NOT create tutorials** - link to external authoritative sources instead
- Use the standard README structure for any new repositories:
  - Title and summary
  - Prerequisites and installations
  - Build
  - Run
  - Test
  - Troubleshooting
- Follow the "Campground Rules" - make documentation better than you found it

### Git & Branching Standards
The team follows a feature-centric variant of git flow:
1. Branch naming: `HS-####-descriptive-name` (based on ticket number)
2. All changes require pull requests
3. PRs must be peer-reviewed and approved
4. Merging strategy: **squash merge only**
5. Default branch: `main`
6. Developer is responsible for merging after approval

### Release Process
When documenting release workflows, reference this standard flow:
1. Close PRs and Tickets
2. Tag Applications (using blastoff: `blastoff release -c <alias> --release`)
3. Snapshot Database
4. Deploy to Development Environment
5. Test in Development
6. Deploy to Production Environment
7. Verify Production Deployment

## Common Tasks

Since this is a documentation repository, there are no build/test commands. Common tasks include:

### Adding New Documentation
1. Create .md files in the appropriate directory (getting-started/ or technologies/)
2. Update README.md links if adding a new major section
3. Follow existing documentation style and structure
4. Link to external resources rather than duplicating content

### Updating Installation Guides
Location: `getting-started/installation-and-setup-guide.md`
- Maintain the three-tier structure: Tier 1 (core, required at onboarding), Tier 2 (project-specific), Tier 3 (DevOps). Tier 2/3 tools belong under "Additional Tooling" at the end, not in the main flow
- Keep the four-section order: Accounts → Programs to Install → Setup → Verify
- **Version floors and install commands live only in `radar/YYYY-MM-DD.csv`**
  (`technology,version,url,requires,linux,macos`, rows sorted by name, no commas inside fields).
  `radar/LATEST` names the current file and must equal the name that sorts last. To change
  anything, add a new dated file and update `LATEST` — never edit an old one, and never write a
  version or install command into the guide or the skill. See `radar/README.md`; the `install`
  workflow validates all of this.
- Floors are written with a `+` (`2.55+`) or `any`, never exact pins. Exact pins rot within weeks
  for tools that ship daily.

### Technology-Specific Guidelines
- **All languages**: `technologies/standards.md` is the single source of truth for coding standards, project structure, linting, testing, Dockerfiles, and CI
- Runtimes carry two numbers, and `standards.md` §2 is authoritative: **minimum supported**
  (Python 3.12+, Node 22+ — below this a repo is a tracked issue) and **new projects use**
  (Python 3.14, Node 24 Active LTS). The install guide, Dockerfile, and CI templates all specify
  the latter. Do not reintroduce Node 22 as what new work starts on.
- Python is never installed globally per-version — `uv` provisions it per project.
- The editor is plain VSCode. Claude Code is the AI tool. **Do not reintroduce Cursor or Copilot.**

### Skills
`.claude/skills/` ships skills usable from any clone of this repo. They must depend on **nothing
outside this repository** — no private repos, no internal service endpoints, no client names. A
skill that only works for one org does not belong here.

- `install.sh` (repo root) — the public `curl … | sh` bootstrap: installs Claude Code if missing,
  then copies `dev-check/SKILL.md` and the radar named in `radar/LATEST` (or one passed as `$1`)
  into `~/.claude/skills/dev-check/`. `DEV_CHECK_REF` points it at another branch or commit; CI
  uses that to run it on clean Ubuntu and macOS runners. Keep it POSIX `sh`, no `sudo`,
  fetching only from this repo and Anthropic's installer. Because the skill runs outside the repo,
  **links in `dev-check/SKILL.md` must be absolute GitHub URLs**, never relative.
- `dev-check/` — machine audit. **Must honour the three tiers**: only Tier 1 can produce a ❌.
  Tier 2/3 are `N/A` unless the current repo shows a marker (`angular.json`, `*.tf`, etc.) proving
  it needs them. Failing a developer for a missing Terraform trains people to ignore the report.
  Reads floors and install commands from the radar and never improvises one. After the report it
  offers to install, in `requires` order. It never runs `sudo`: those commands come back in one
  block. Also holds the InnoDay checks — those
  degrade to skipped rather than failing for anyone outside the org.

### Interview Task and Skill
- `getting-started/interview-test.md` — the candidate task, structured as six virtual tickets
  (`HS-9001`–`HS-9006`). Ticket IDs are deliberately fictional; real InnoDay/ticket-system
  integration is out of scope and marked TBD in the doc.
- `.claude/skills/interview/SKILL.md` — guided mode. **It must coach, never implement**: writing a
  candidate's ticket for them invalidates the assessment. It samples repo state every 2 minutes for
  one hour into `log/.checkpoints.tsv` and writes an observational (never scored) report at wrap-up.
- `log/` is gitignored — session logs must never land in a PR.

## Important Files

- `README.md` - Main entry point, outlines all major sections
- `LICENSE` - CC BY 4.0 for prose, MIT for embedded code samples
- `getting-started/installation-and-setup-guide.md` - Complete setup instructions
- `getting-started/expectations.md` - Team guidelines and standard practices
- `getting-started/ai.md` - AI responsibility principles
- `getting-started/learning-guide.md` - Five areas to learn, in order
- `getting-started/release-guide.md` - Standard release process
- `technologies/git.md` - Git and GitHub: workflow, `gh` CLI, repo standards, public-repo rules
- `technologies/innoday.md` - InnoDay CLI and MCP (internal tooling)
- `.claude/skills/dev-check/SKILL.md` - Machine audit and install checklist
- `radar/` - Technology radar: dated CSVs, source of truth for version floors and install links

## This Repository Is Public

Published under CC BY 4.0 / MIT. Before adding anything, check it does not include client names,
internal URLs, service endpoints, credentials, absolute paths containing a username, or named
individuals with privileges attached.

## Editing Guidelines

When making changes to this repository:
1. **Respect the "no tutorials" philosophy** - this guide links to authoritative sources, it doesn't replace them
2. **Maintain consistent structure** - new sections should follow existing patterns
3. **Update links carefully** - ensure all internal references remain valid
4. **Version specifications matter** - when updating tools, update version numbers throughout
5. **Think about onboarding** - new team members rely on this guide being accurate and current
