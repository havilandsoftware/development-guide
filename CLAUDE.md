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
- Claude (claude.ai) for research, writing, and analysis
- Focus on responsible, methodical, and iterative AI usage

Cursor and GitHub Copilot are no longer used — do not reintroduce references to them.

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

Four ordered sections — do not reorder them, the sequence is deliberate:
1. Create Cloud Accounts
2. Programs to Install — Developer Tools (everyone), DevOps Tools (infrastructure work
   only), Editors & Applications, Browsers & Communication
3. Setup — workspaces directory, git config, SSH key, then WSL last
4. Verify Your Setup — run the dev-check skill

**Version data has one source of truth: `skills/dev-check/SKILL.md`.** Its Step 2 table
holds the floors. When bumping a version, edit the skill first, then bring the install
guide tables into line — never the other way round, and never only one of them.

Versions are written as floors with a `+` (`2.55+`), never exact pins, and each versioned
section carries a `> **Versions verified:** <date>` marker. Update the date whenever you
re-verify. Exact pins rot within weeks for tools that ship daily.

The bundled skill is a copy of the one in the company Claude Code plugin. A version bump
needs to land in both, or they drift.

### Technology-Specific Guidelines
- **All languages**: `technologies/standards.md` is the single source of truth for coding standards, project structure, linting, testing, Dockerfiles, and CI
- Runtimes use two numbers, and `standards.md` §2 is authoritative for both: **minimum
  supported** (Python 3.11+, Node 22+ — below this a repo is a tracked issue) and **new
  projects use** (Python 3.14, Node 24 Active LTS). The install guide, Dockerfile
  templates, and CI templates all specify the latter. Do not reintroduce Node 22 or
  Python 3.11 as what new work starts on.
- Python is never installed globally — `uv` provisions it per project. Do not add a global
  Python install step.

## Important Files

- `README.md` - Main entry point, outlines all major sections
- `LICENSE` - CC BY 4.0 for prose, MIT for embedded code samples
- `getting-started/installation-and-setup-guide.md` - Complete setup instructions
- `getting-started/expectations.md` - Team guidelines and standard practices
- `getting-started/ai.md` - AI responsibility principles
- `getting-started/learning-guide.md` - Hub over the five areas to learn first
- `getting-started/interview-test.md` - Hiring assessment; contains interviewer-only
  notes in HTML comments (see warning below)
- `getting-started/release-guide.md` - Standard release process
- `technologies/git.md` - Git workflow and repository standards
- `technologies/github.md` - GitHub platform, `gh` CLI, public-repo requirements
- `technologies/innoday.md` - InnoDay CLI and MCP (internal tooling)
- `skills/dev-check/SKILL.md` - Environment audit skill; source of truth for versions
- `interview/generated_report.py` - Deliberately defective code for the review exercise

## This Repository Is Public

Published under CC BY 4.0 / MIT. Before adding anything, check it does not include:
- Client names, internal URLs, service endpoints, or customer data
- Credentials or secrets of any kind
- Absolute paths containing a username (`/home/<user>/...`)
- Named individuals with privileges attached

`interview/generated_report.py` **contains intentional bugs.** Do not "fix" them — they
are the assessment. Its interviewer notes explain each one and record that all four were
verified by execution.

Both `getting-started/interview-test.md` and `interview/generated_report.py` carry
interviewer-only sections in comments. They are visible to anyone reading the source, so
rotate the planted defects and ambiguities periodically rather than relying on secrecy.

## Editing Guidelines

When making changes to this repository:
1. **Respect the "no tutorials" philosophy** - this guide links to authoritative sources, it doesn't replace them
2. **Maintain consistent structure** - new sections should follow existing patterns
3. **Update links carefully** - ensure all internal references remain valid
4. **Version specifications matter** - when updating tools, update version numbers throughout
5. **Think about onboarding** - new team members rely on this guide being accurate and current
