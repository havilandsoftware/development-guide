# Claude Code

Claude Code is an AI-powered CLI tool that assists with software development tasks. It provides intelligent code generation, refactoring, and project management capabilities.

## Installation

Install Claude Code CLI globally:

```bash
npm install -g @anthropic-ai/claude-code
```

For complete installation instructions, see the [Claude Code documentation](https://docs.claude.com/en/docs/claude-code).

### Company Plugin

After installing Claude Code, install the Haviland Software company plugin to get company-wide standards, developer environment verification, and project onboarding:

```bash
# Inside a Claude Code session:
/plugin marketplace add havilandsoftware/pixelfuel-claude
/plugin install pixelfuel@pixelfuel-claude
```

This provides:
- Company git workflow rules and standards loaded into every Claude session
- `/pixelfuel:dev-check` — verify your developer environment against this guide
- `/pixelfuel:onboard-project <label>` — clone and bootstrap all repos for a topic label
- `/pixelfuel:parallel-dev <task1> [task2]` — spin up parallel isolated development sessions
- `/pixelfuel:build-skill <name>` — guided authoring of a new company skill, committed to a branch and submitted for admin review
- `/pixelfuel:project-check [--fix]` — audit a repo against company coding standards, report gaps; `--fix` creates a branch with automated corrections

Source: [havilandsoftware/pixelfuel-claude](https://github.com/havilandsoftware/pixelfuel-claude)

### Contributing Skills

Skills in `pixelfuel-claude` must be **company-wide or broadly applicable to any Haviland Software development workflow** — things every developer across all projects would benefit from.

**Belongs in `pixelfuel-claude`:**
- Developer tooling (environment setup, onboarding, repo auditing)
- Git and release workflow automation
- Skills any developer on any project would use

**Does not belong here — put it in the project's own `.claude/skills/` instead:**
- Anything specific to a single client or product (e.g. a skill that only works on one app or references client-specific services)
- Workflows unique to one team
- Anything that embeds client data, credentials, or service endpoints

The `build-skill` scope check will prompt you if a proposed skill sounds project-specific and redirect you to the right place.

**Review process** for skills that do belong here:

1. Run `/pixelfuel:build-skill <name>` — Claude scope-checks the idea, interviews you, drafts the `SKILL.md`, commits it to a `skill/<name>` branch, and opens a PR
2. GitHub auto-requests review from repo admins (`@havkarl`, `@kengsc`)
3. Admin approves and merges — the skill becomes available to everyone on next plugin update

Direct pushes to `main` are blocked; all skill additions require an approved PR.

## Best Practices

### Always Use Plan Mode
Plan mode is critical for complex tasks. It allows Claude to:
- Break down work into clear steps
- Get your approval before implementing
- Ensure alignment with your goals before writing code

Start plan mode by using the `/plan` command or specifying your intent upfront.

### Creating GitHub Issues with Claude
Use the GitHub CLI integration to create well-structured issues efficiently:

```bash
gh issue create --title "Issue Title" --body "Description"
```

**Key principles when creating issues:**
- **Re-plan to force code reuse**: Before implementing, have Claude analyze existing patterns and architectures to maximize code reuse
- **Break up changes into separate issues**: Large features should be decomposed into smaller, manageable issues that can be worked independently
- **Be pragmatic about modifications**: Focus on targeted changes rather than large rewrites. Modify only what's necessary to achieve the goal

### Setting Up a Design Agent
A design agent helps ensure architectural consistency and proper planning before implementation.

**Configuration steps:**
1. Create a `.claude/` directory in your repository
2. Define agent prompts for architectural review
3. Configure the agent to validate changes against established patterns
4. Use the agent to review proposals before implementation

For detailed agent configuration, see the [Claude Code Agents documentation](https://docs.claude.com/en/docs/claude-code/agents).

## Additional Resources
- [Claude Code Documentation](https://docs.claude.com/en/docs/claude-code)
- [GitHub CLI Documentation](https://cli.github.com/manual/)
- [Effective Prompting Guide](https://docs.anthropic.com/en/docs/build-with-claude/prompt-engineering)

## Parallel Development

Running multiple Claude Code sessions simultaneously across isolated git worktrees is the single biggest productivity unlock, per the Claude Code team.

### How It Works

Each worktree is a full checkout of the repo on its own branch, with its own Claude session. Sessions work independently without interfering with each other.

```bash
# Create a worktree for each parallel task
git worktree add .claude/worktrees/add-auth -b parallel/add-auth
git worktree add .claude/worktrees/fix-payments -b parallel/fix-payments

# Launch a Claude session in each (run in separate terminals)
claude .claude/worktrees/add-auth
claude .claude/worktrees/fix-payments

# Clean up when done
git worktree remove .claude/worktrees/add-auth
```

**Core rule**: Only one agent should edit a given file at a time. Design task boundaries so file changes don't overlap between sessions.

### Multi-Repo Sessions

Give Claude access to additional repositories in a session:

```bash
# At launch
claude . --add-dir ~/workspaces/hs/shared-lib

# Inside a running session
/add-dir ~/workspaces/hs/shared-lib

# Always load certain repos — add to .claude/settings.json
{
  "additionalDirectories": ["~/workspaces/hs/shared-lib"]
}
```

### Self-Improvement Loop

After every correction or mistake Claude makes, update the project's `CLAUDE.md` with a rule to prevent repeating it:

> "Now update CLAUDE.md so you don't make that mistake again."

### Reference

These patterns are drawn from Boris Charny's (Claude Code team) published configuration:
- [bcherny-claude CLAUDE.md](https://github.com/0xquinto/bcherny-claude/blob/main/CLAUDE.md) — full configuration with parallel dev, session management, automation, and self-improvement patterns
- [pixelfuel-claude plugin](https://github.com/havilandsoftware/pixelfuel-claude) — company plugin that encodes these patterns as `/pixelfuel:parallel-dev` skill
