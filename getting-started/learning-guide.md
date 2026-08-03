# Learning Guide

Five areas to get solid in, in this order. Each one says what you should be able to do,
points at the internal document that is authoritative for us, and links a small number
of external resources worth your time.

This guide deliberately does not teach any of it. Technology providers maintain far
better material than we could, and ours would be out of date within months.

---

## 1. Git Basics

**You should be able to:** create a branch, commit in logical chunks, push, open a pull
request, review someone else's PR, resolve a merge conflict, and explain why we
squash-merge. You should also be able to get yourself out of trouble — undo a commit,
recover a lost branch, and know why force-pushing a shared branch is dangerous.

**Ours:** [Git](../technologies/git.md) · [GitHub](../technologies/github.md)

**External:**
- [GitHub Hello World](https://docs.github.com/en/get-started/quickstart/hello-world) — start here if git is new to you
- [Pro Git, chapters 2–3](https://git-scm.com/book/en/v2) — the free canonical book
- [Oh Sh*t, Git!?!](https://ohshitgit.com/) — how to undo the specific thing you just did
- [Learn Git Branching](https://learngitbranching.js.org/) — visual, interactive branching practice

---

## 2. Claude Basics

**You should be able to:** plan before implementing, give Claude enough context to be
useful, review what it produces rather than accepting it, keep a `CLAUDE.md` current,
and run isolated worktrees without sessions colliding.

The skill that matters most is knowing when to stop and redirect. An agent that has
drifted from the plan produces confident, plausible, wrong work — catching that early is
the difference between a productive session and a wasted afternoon.

**Ours:** [Claude Code](../technologies/claude.md)

**External:**
- [Claude Code documentation](https://docs.claude.com/en/docs/claude-code) — features, configuration, MCP
- [Claude Code best practices](https://www.anthropic.com/engineering/claude-code-best-practices) — how the team that builds it uses it
- [Prompt engineering guide](https://docs.claude.com/en/docs/build-with-claude/prompt-engineering) — useful well beyond prompting

---

## 3. AI Safety

**You should be able to:** explain why you trust a piece of AI-generated code, spot a
hallucinated API or import, recognise when a task is too security-sensitive to delegate,
and keep credentials and client data out of prompts.

This is not a compliance exercise. You own everything you commit regardless of what
wrote it, which makes your review the safety mechanism — not a policy document.

**Ours:** [AI Responsibility Guide](ai.md)

**External:**
- [Anthropic usage policies](https://www.anthropic.com/legal/aup) — what these tools may and may not be used for
- [NIST AI Risk Management Framework](https://www.nist.gov/itl/ai-risk-management-framework) — the standard vocabulary for AI risk
- [OWASP Top 10 for LLM Applications](https://owasp.org/www-project-top-10-for-large-language-model-applications/) — prompt injection, data leakage, and the rest, if you build on models
- [Google Responsible AI practices](https://ai.google/responsibility/responsible-ai-practices/) — fairness and transparency in practice

---

## 4. Releases

**You should be able to:** take a change from merged PR to verified production
deployment, tag a release, know what to do when a deployment goes wrong, and explain why
the database snapshot happens before the deploy rather than after.

**Ours:** [Release Guide](release-guide.md)

**External:**
- [Martin Fowler on Continuous Delivery](https://martinfowler.com/bliki/ContinuousDelivery.html) — the reasoning behind the practice
- [Semantic Versioning](https://semver.org/) — what a version number is actually claiming
- [Google SRE Book, chapter 27](https://sre.google/sre-book/reliable-product-launches/) — reliable launches, free online

---

## 5. Expectations & Rules

**You should be able to:** work the way the team works without being reminded — branch
naming, PR review, README upkeep, ticket hygiene, security basics, and the coding
standards for whichever language you are in.

Read these two properly rather than skimming. Most friction on a team traces back to
someone not having read the standards.

**Ours:** [Expectations](expectations.md) · [Coding Standards](../technologies/standards.md)

**External:**
- [Measure What Matters](https://www.whatmatters.com/) — OKRs, which drive how work is prioritised here
- [The Pragmatic Programmer](https://pragprog.com/titles/tpp20/the-pragmatic-programmer-20th-anniversary-edition/) — the closest thing to a shared professional baseline
- [Conventional Commits](https://www.conventionalcommits.org/) — commit message structure

---

## Further Reading

Not required, but worth your time as you go.

### Languages & Frameworks

- [Python](https://www.python.org/about/gettingstarted/)
- [Node.js](https://nodejs.org/en/learn/getting-started/introduction-to-nodejs)
- [React](https://react.dev/learn)
- [Next.js](https://nextjs.org/learn)
- [TypeScript Handbook](https://www.typescriptlang.org/docs/handbook/intro.html)
- [Supabase](https://supabase.com/docs)

### Books

**Business & strategy**
- Measure What Matters
- Blue Ocean Strategy
- The Art of Innovation
- The Innovator's Dilemma

**Leadership**
- Good to Great
- Designing Your Life

**Engineering practice**
- The Phoenix Project
- The Pragmatic Programmer
- [Continuous Delivery for Machine Learning](https://martinfowler.com/articles/cd4ml.html) — Martin Fowler

### Resources

- [ThoughtWorks Technology Radar](https://www.thoughtworks.com/en-us/radar) — our guiding star for technology adoption
- [Google AI](https://ai.google/) — research, education, and tooling
