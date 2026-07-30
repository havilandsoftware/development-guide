# Interview Task: Build an AI Agent

## What This Is

Build a small AI agent that pulls data from a public API and answers questions about it. The topic is
yours to pick — the point is not the agent, it's how you work.

You have **4–5 days** to do as much as you like, then we walk through your code together. There is no
hidden pass mark and no trick requirements. We are looking for four things:

1. You can stand up a Python project that meets our standards
2. You can use git and pull requests the way a team does
3. You can work effectively *with* AI rather than just accepting its output
4. You can self-start, ask good questions, and follow through

**If you get stuck, reach out immediately.** Asking early is a positive signal, not a negative one.
Being blocked in silence for two days is the only real way to fail this.

---

## How the Work Is Organised

The work is split into six tickets, mirroring how we actually assign work
(see [Expectations → Ticketing Practices](expectations.md#ticketing-practices)). Each ticket is one
branch and one pull request.

**Ticket IDs here are fictional** (`HS-90xx`) — they exist so you can practise the branch naming
convention. If you are given access to our ticket system during the interview, use the real IDs you
find there instead; otherwise these are fine.

| Ticket | Focus | Rough size |
|--------|-------|-----------|
| [HS-9001](#hs-9001--project-skeleton) | Repo, README, CLAUDE.md, gitignore | Half a day |
| [HS-9002](#hs-9002--python-project-setup) | uv, `src/` layout, ruff, mypy | Half a day |
| [HS-9003](#hs-9003--fetch-real-data) | API client, secrets handling | Half a day |
| [HS-9004](#hs-9004--tests) | pytest, mocking the network | Half a day |
| [HS-9005](#hs-9005--the-agent) | The LLM layer | 1 day |
| [HS-9006](#hs-9006--docker--ci) | Dockerfile, GitHub Actions | Half a day |

**You do not have to finish all six.** Three tickets done properly beats six done badly — we would
much rather see HS-9001 through HS-9004 polished than all six rushed. Tell us where you stopped and
why.

### The Rules That Matter

Two things we care about more than the code itself:

- **One branch per ticket, named `HS-9001-project-skeleton`** — see [Git standards](../technologies/git.md#branching)
- **Open the pull request early**, while the work is still in progress. Not at the end. We want to see
  your thinking as it develops, and a draft PR is the normal way a team does that.

Merge to `main` yourself once a ticket feels done. Code does not need to be perfect to merge.

### Guided Mode (Optional)

This repository ships a Claude Code skill that walks you through the tickets one at a time, tracks
your time, and writes a session summary at the end:

```bash
cd your-project
claude
> /interview
```

It coaches — it will not write the tickets for you. Using it is optional and does not affect how we
assess your work. See [the skill](../.claude/skills/interview/SKILL.md) for what it records.

---

## Before You Start

Work through the [Installation and Setup Guide](installation-and-setup-guide.md) **Tier 1** only.
You need: Git 2.49+ with an SSH key, Python 3.12+, `uv`, `ruff`, `mypy`, Docker, `gh`, and an IDE
with AI assistance (Cursor, or VSCode with Copilot).

You do not need any Tier 2 or Tier 3 tooling — no AWS, Terraform, Kubernetes, or Angular.

Then skim [Coding Standards](../technologies/standards.md). You will be referred back to specific
sections as you go, so you do not need to memorise it.

### Model Access

You need access to an LLM for HS-9005. If you have your own API key, use it. If not, tell us early
and we will sort access out — do not spend your own money on this.

---

## HS-9001 — Project Skeleton

**Goal:** A repository that a teammate could clone and understand without asking you anything.

Create a public GitHub repository, then add the four files every repo of ours has
([Universal Requirements](../technologies/standards.md#1-universal-requirements)).

**Success criteria**
- [ ] Public repo, default branch `main`, squash-merge only, description and topics set
- [ ] `README.md` with all six sections: Title/summary, Prerequisites, Build, Run, Test, Troubleshooting
- [ ] The summary says what your agent does in plain language and gives one example question it answers
- [ ] `CLAUDE.md` — what the repo does, how to run tests, any non-obvious constraints
- [ ] `.gitignore` covering `.env`, `__pycache__/`, `.venv/`
- [ ] `.env.example` with every key you will need, values blanked
- [ ] Merged via PR

**Read:** [Git standards](../technologies/git.md) · [Universal Requirements](../technologies/standards.md#1-universal-requirements)

> **Try asking Claude:** *"Read the Haviland coding standards at <link> and scaffold the four
> universal files for a project that does X. Ask me anything you need to know first."*
>
> Then check what it produced against the standard yourself. It will get some of it wrong.

---

## HS-9002 — Python Project Setup

**Goal:** `uv sync`, `ruff check .`, and `mypy` all pass on a clean clone.

**Success criteria**
- [ ] Project initialised with `uv init`; `pyproject.toml` and `uv.lock` both committed
- [ ] Code under `src/<your_package>/`, tests under `tests/` mirroring it
- [ ] No loose `app.py` or `run.py` at the repo root
- [ ] `ruff` configured in `pyproject.toml` with `line-length = 100` and `target-version = "py312"`
- [ ] `uv run ruff check .` and `uv run ruff format --check .` both clean
- [ ] Type hints on every public function
- [ ] `README.md` Build/Run/Test sections updated to real commands

**Read:** [Python Standards](../technologies/standards.md#3-python-standards)

Use `uv` for everything. No bare `pip install`, no `requirements.txt`.

---

## HS-9003 — Fetch Real Data

**Goal:** Pull live data from a public API into a typed structure.

Pick any free API that interests you — weather, transit, football scores, earthquakes, air quality,
book metadata. Choose something you would actually find interesting to ask questions about.

**Success criteria**
- [ ] A module that calls the API and returns typed Python objects (not raw `dict`s passed around)
- [ ] Errors handled deliberately: timeouts, non-200s, and a shape you did not expect
- [ ] Any key read from the environment via `.env`, listed in `.env.example`, never committed
- [ ] Loading the data is separate from presenting it
- [ ] `README.md` documents how to get an API key, if one is needed

**Read:** [Environment Tiers](../technologies/standards.md#environment-tiers)

> If you accidentally commit a key: rotate it first, then clean the history. The procedure is in
> [Secret Removal](../technologies/standards.md#secret-removal-procedure). Tell us — it happens, and
> handling it correctly is genuinely more interesting to us than never doing it.

---

## HS-9004 — Tests

**Goal:** `uv run pytest` passes with no network connection.

**Success criteria**
- [ ] `pytest` as a dev dependency (`uv add --dev pytest`)
- [ ] Every public function has at least one test
- [ ] The API layer is tested against a **mocked** response, not the live service
- [ ] At least one test covers a failure path (bad response, timeout, missing field)
- [ ] Files named `test_<module>.py`, functions named `test_<behaviour>`
- [ ] Tests pass with your network disconnected

**Read:** [Testing](../technologies/standards.md#testing)

Tests that hit the live API will fail in CI the moment the service rate-limits you. That is why we
mock. We are not looking for 100% coverage — we are looking for tests that would actually catch a
regression.

---

## HS-9005 — The Agent

**Goal:** Ask a question in natural language, get an answer grounded in your data.

This is the interesting ticket, and the most open-ended. A working loop that answers three or four
question types well is a much better result than an ambitious framework that half-works.

**Success criteria**
- [ ] A question in, a useful answer out
- [ ] The answer is grounded in the data you fetched — not the model's own knowledge
- [ ] Prompts live in the code as readable constants, not buried inline
- [ ] API failures and unanswerable questions degrade gracefully
- [ ] A test for the agent layer with the LLM call mocked
- [ ] `README.md` shows at least three real example interactions with actual output

**Read:** [AI Responsibility Guide](ai.md)

> Be ready to explain, at the walkthrough: what happens when the model is asked something the data
> cannot answer? A confident wrong answer is worse than "I don't know," and we will ask about it.

---

## HS-9006 — Docker & CI

**Goal:** A green check on your pull request.

**Success criteria**
- [ ] Multi-stage `Dockerfile` on `python:3.12-slim`, running as a non-root user
- [ ] The image builds and runs
- [ ] `.github/workflows/ci.yml` running lint → test → build on every PR and push to `main`
- [ ] CI passing (green) on the PR
- [ ] `README.md` documents the Docker build and run commands

**Read:** [Dockerfile](../technologies/standards.md#dockerfile) · [CI Baseline](../technologies/standards.md#8-github-actions--ci-baseline)

The standards document has a working Python CI workflow you can copy and adapt.

---

## The Walkthrough

We will sit down for about an hour and go through what you built. Expect:

- A demo — run it, ask it something
- A read through the code, with you explaining the decisions
- **"Why did you do it this way?"** on a few specific choices
- **"Where did Claude get it wrong?"** — we will ask this, and *"it didn't"* is not a credible
  answer. Knowing where your tools failed you is the skill we are actually testing
- What you would do next with another week

Bring your questions about how we work. The interview goes both ways.

## What Stands Out

Things that consistently impress us, in rough order:

1. **Honest, specific communication** — "I spent four hours on X, it was the wrong approach, here's
   what I'd do instead" tells us more than a clean repo does
2. **Judgement about AI output** — you caught something wrong, understood why, and fixed it
3. **Early pull requests** — visible thinking beats a perfect final commit
4. **Genuine tests** — ones that would catch a real bug
5. **Creativity** — an idea we have not seen before, even if it only half-works
