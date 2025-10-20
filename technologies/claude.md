# Claude Code

Claude Code is an AI-powered CLI tool that assists with software development tasks. It provides intelligent code generation, refactoring, and project management capabilities.

## Installation

Install Claude Code CLI globally:

```bash
npm install -g @anthropic-ai/claude-code
```

For complete installation instructions, see the [Claude Code documentation](https://docs.claude.com/en/docs/claude-code).

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
