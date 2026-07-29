# AI

## Responsibility Guide
This guide outlines the principles and best practices for responsible AI use within our team. We are an AI-first team — we actively use AI tools to accelerate development, improve quality, and learn faster. Responsible usage means being intentional, verifying output, and maintaining accountability for everything we ship.

### 1. Fairness
- Ensure AI-generated systems and content do not discriminate against individuals or groups.
- Regularly review AI-assisted decisions for unintended bias.

### 2. Transparency
- Document when and how AI tools were used in a given piece of work.
- Communicate the purpose and limitations of any AI system to stakeholders.

### 3. Accountability
- You are responsible for code you commit, regardless of whether AI generated it.
- Review and understand AI-generated output before accepting it. Never blindly apply suggestions.

### 4. Privacy
- Do not paste sensitive data, credentials, API keys, or PII into AI tools.
- Treat AI prompts as potentially logged — apply the same judgment you would to any external service.

### 5. Safety
- Test AI-generated code thoroughly before shipping.
- When using AI agents or automated workflows, monitor outputs and have rollback plans.

## Practical Usage Guidelines

### When to Use AI
- First-pass code generation, boilerplate, and scaffolding
- Code review and refactoring suggestions
- Explaining unfamiliar codebases or libraries
- Writing tests, documentation, and commit messages
- Debugging and root cause analysis

### When to Be Careful
- Security-sensitive code (auth, encryption, access control) — always manually review
- Business logic with edge cases AI may not be aware of
- Anything touching production data or infrastructure
- Legal, compliance, or contractual language

### Verify Before You Ship
- Run the code and read it — don't assume AI output is correct
- Check for hallucinated imports, APIs, or method signatures
- Validate logic against requirements, not just syntax

## Tools and Frameworks

| Tool | Purpose |
|------|---------|
| [Cursor](https://www.cursor.com/) | Primary AI coding IDE with inline suggestions and chat |
| [Claude Code](../technologies/claude.md) | CLI-based AI agent for complex coding tasks, planning, and GitHub integration |
| [GitHub Copilot](https://github.com/features/copilot) | In-editor code completion and chat (VSCode, Cursor) |
| [Claude (claude.ai)](https://claude.ai) | General-purpose AI assistant for research, writing, and analysis |
