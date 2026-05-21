# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is the **Haviland Software Development Guide** - a comprehensive documentation repository that outlines technologies, processes, and development standards for the team. This is NOT a tutorial repository; it provides curated links to external resources and establishes team standards.

The guide is structured into three main sections:
- **getting-started/**: Onboarding materials, expectations, installation guides, and learning resources
- **technologies/**: Language and framework-specific guidelines (Git, Coding Standards, Claude Code)
- **processes/**: Team workflows including OKRs, scrum, ticketing, and lifecycle management

## Repository Purpose & Architecture

This is a **documentation-only repository** with no code to build, test, or run. The architecture is intentionally simple:
- All content is in Markdown (.md) files
- Navigation starts from README.md which links to all major sections
- Documentation follows a hierarchical structure: Getting Started → Technologies → Processes

## Key Team Principles

When editing this guide, respect these core team values:

### AI-First Approach
The team is "Responsible AI First" - they actively use AI tools in creative ways while maintaining ethical standards. The team uses:
- Cursor (primary AI coding tool)
- Claude Code (this tool)
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
2. Tag Applications (using github-ops: `python src/main.py release -t <tag> -c <topic>`)
3. Snapshot Database
4. Deploy to Development Environment
5. Test in Development
6. Deploy to Production Environment
7. Verify Production Deployment

## Common Tasks

Since this is a documentation repository, there are no build/test commands. Common tasks include:

### Adding New Documentation
1. Create .md files in the appropriate directory (getting-started/, technologies/, or processes/)
2. Update README.md links if adding a new major section
3. Follow existing documentation style and structure
4. Link to external resources rather than duplicating content

### Updating Installation Guides
Location: `getting-started/installation-and-setup-guide.md`
- Maintain sections: Cloud Accounts, WSL, Git Setup, Languages/Frameworks, Developer Applications, Browsers, CLI Tools
- Include version requirements where applicable (e.g., Git 2.40+, Python 3.11, Node.js v22)

### Technology-Specific Guidelines
- **All languages**: `technologies/standards.md` is the single source of truth for coding standards, project structure, linting, testing, Dockerfiles, and CI
- Install steps for Python 3.11+ and Node.js v22 are inline in `getting-started/installation-and-setup-guide.md`
- Always specify version requirements (Python 3.11+, Node.js v22)

## Important Files

- `README.md` - Main entry point, outlines all major sections
- `getting-started/installation-and-setup-guide.md` - Complete setup instructions
- `getting-started/expectations.md` - Team guidelines and standard practices
- `getting-started/ai.md` - AI responsibility principles
- `technologies/git.md` - Git workflow and repository standards
- `getting-started/release-guide.md` - Standard release process

## Editing Guidelines

When making changes to this repository:
1. **Respect the "no tutorials" philosophy** - this guide links to authoritative sources, it doesn't replace them
2. **Maintain consistent structure** - new sections should follow existing patterns
3. **Update links carefully** - ensure all internal references remain valid
4. **Version specifications matter** - when updating tools, update version numbers throughout
5. **Think about onboarding** - new team members rely on this guide being accurate and current
