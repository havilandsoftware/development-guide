# Interview Task

This assessment is deliberately not a coding test. Claude can write the code; we are
interested in how you **direct** it, what you **ask**, what you **choose not to build**,
and how well you **explain** the result.

Three phases. The middle one carries the least weight.

| Phase | Weight | What you submit |
|-------|--------|-----------------|
| 1. Plan | 40% | `PLAN.md` and `ASSUMPTIONS.md`, **before writing any code** |
| 2. Build | 20% | Working code on a branch, via pull request |
| 3. Review | 40% | `REVIEW.md`, plus a live walkthrough with us |

**Time:** cap yourself at **4 hours** total. Tell us when you plan to start. We would
rather see 4 focused hours than a rushed weekend, and we will not reward whoever had the
most spare time.

**Compensation:** this task is paid at a flat rate of <!-- RATE: set before sending -->.
You will be paid whether or not we move forward.

**Ask us things.** Your named contact is included in the email with this task. Questions
are expected, not a sign of weakness — the brief below has gaps in it.

---

## 1. Setup

Work through the
[Installation and Setup Guide](installation-and-setup-guide.md), then verify it:

```
/dev-check
```

Paste the output into your `PLAN.md`. If you cannot run the skill, the same checks are
written out step by step in [`skills/dev-check/SKILL.md`](../skills/dev-check/SKILL.md) —
run them by hand and paste those results instead.

If you are new to Claude Code, read [Claude Code](../technologies/claude.md) first and
spend twenty minutes on something throwaway before you start the real task. We are
assessing your judgment, not your familiarity with a particular tool, and we would rather
you spent the warm-up time here than in the middle of the assessment.

---

## 2. The Brief

Build a small service that **tracks the price of something over time and answers
questions about it.**

What "something" is, is up to you — a stock, a cryptocurrency, a commodity, transit
times, weather, anything with a public data source and a number that changes. Pick
something you find genuinely interesting; it makes the walkthrough better.

Requirements:

1. It pulls data from a **public API**.
2. It **stores history** so it can answer questions about change over time, not just the
   current value.
3. It **answers natural-language questions** about that data.
4. It has a **README** that someone else could follow to run it.
5. It has **tests**, however small.

### Fixed interface — do not change this

Your project must expose exactly this function, with this signature:

```python
def answer(question: str) -> str:
    """Answer a natural-language question about the tracked data."""
```

Name it `answer`, take a single string, return a single string. Put it somewhere
importable and say where in your README. Build whatever you like behind it, but this
signature is frozen — we run it directly.

### Out of scope

Do not build any of these. They are not bonus points; building them counts against you.

- A web UI or frontend of any kind
- User accounts, authentication, or multi-user support
- Deployment, containerisation, or CI configuration
- A database server — use SQLite or files
- Support for more than one data source
- Real-time streaming or websockets

If you think something on this list is genuinely necessary, say so in `PLAN.md` and
explain why, then don't build it.

---

## 3. Phase 1 — Plan (submit before coding)

Create a branch, add these two files, and open a pull request **before you write any
implementation code.**

### `PLAN.md`

- What you are building and why you picked it
- Your approach — the shape of the solution, not a line-by-line design
- What you will **not** do, and why
- Your `dev-check` output
- **Open questions.** Things the brief does not tell you. Send the ones that block you to
  your contact; record all of them here.

### `ASSUMPTIONS.md`

For every ambiguity you did not resolve by asking: what was unclear, what you assumed,
and why that assumption was reasonable. One line each is fine.

This file matters. An undocumented assumption is indistinguishable from not having
noticed the problem.

---

## 4. Phase 2 — Build

- Commit in **logical, frequent chunks** with clear messages. We read the history.
- Push to the same branch and PR you opened in Phase 1.
- Follow [Coding Standards](../technologies/standards.md) for whichever language you use.
- Use Claude Code, and **keep your session transcript or prompt log.** Submit it with
  your work — we are more interested in how you directed the agent than in the diff.

### Included exercise: review this code

In `interview/generated_report.py` you will find a file written by an AI agent that we
have not reviewed. **It contains at least one defect.**

Review it as though a junior engineer on your team had opened it as a PR. For each
problem you find, write in `REVIEW.md`:

1. What is wrong
2. **How you noticed** — what made you look there
3. What you would do about it

The second point is the one we care about most. "I ran it and it crashed" is a fine
answer. So is "the method doesn't exist in that library's docs." What we are looking for
is a repeatable method rather than a lucky catch.

---

## 5. Phase 3 — Review

### `REVIEW.md`

- **What you chose not to build, and why.** Restraint only counts if it was deliberate.
- **What you would do next** with another four hours.
- **What you are least confident about** in what you submitted.
- Your findings from the code review exercise above.
- Roughly how long you actually spent.

### Walkthrough

We will book 45 minutes to go through it together. Expect to:

- Explain how it works, including any part Claude wrote
- Critique your own work — what shortcuts did you take, and why were they the right ones?
- Talk through a change we suggest, and push back if you disagree

You are welcome to disagree with us in this conversation. Defending a decision well is a
better signal than conceding quickly.

---

## 6. How We Assess

Five dimensions, each scored 1–4. Every score is backed by specific evidence from your
submission, and each of us scores independently before we discuss it.

| Dimension | What a 4 looks like |
|-----------|--------------------|
| **Question-asking** | Surfaced the real gaps in the brief, including the contradictory bits. Asked about the ones that blocked progress and documented the rest. |
| **Scope judgment** | Frozen interface untouched. Nothing from the out-of-scope list built. Noticed the tempting adjacent work and deliberately left it, saying so. |
| **Communication** | `PLAN.md`, `ASSUMPTIONS.md`, `REVIEW.md`, README and commit messages are all clear to someone with no context. |
| **AI direction** | Prompts carried real context. Output was verified, not accepted. Caught the planted defect and can say how. Noticed when the agent drifted and redirected it. |
| **Ownership** | Explains every part of the submission, including AI-written parts. Critiques their own work honestly. Defends decisions with reasons. |

Whether the code works is a **threshold**, not a score. It needs to run. Beyond that,
elegance earns you less than judgment does.

Everyone who completes this gets specific feedback, whatever the outcome.

---

## 7. Model Access

You need access to an LLM. Use your own Claude subscription or API key if you have one.
If you do not, tell your contact and we will sort out access — do not let this block you,
and do not pay out of pocket.

---

<!--
================================================================================
INTERVIEWER NOTES — DO NOT SHARE WITH CANDIDATES
================================================================================

## Planted ambiguities

Score against WHICH of these the candidate surfaced, never against how many questions
they asked. Asking about 3 of these thoughtfully beats asking 12 vague questions, and
penalising someone for "too many questions" while also penalising "too few" makes the
criterion unfalsifiable. Pre-committing to this list is what stops that.

1. "Over time" — no interval is specified. Hourly? Daily? On demand?
2. "Answers natural-language questions" — no accuracy bar, and no list of question types
   that must work.
3. "Public API" — no guidance on rate limits, or what to do when the API is down.
4. No retention period. Keep all history forever, or a window?
5. "Tests, however small" — no coverage expectation. Deliberately vague.
6. `answer()` returns a string — no format specified. Prose? JSON? What about a question
   it can't answer?

## Planted contradictions

7. §2 requires "stores history so it can answer questions about change over time," while
   Out of Scope forbids "a database server." Resolvable with SQLite/files, but only if
   they notice the tension and say how they resolved it.
8. §2 requires a README "someone else could follow to run it," while Out of Scope forbids
   "deployment, containerisation." Mild, but it invites a question about how far "run it"
   goes.

A candidate who surfaces 7 has read carefully. One who surfaces both is unusual.

## The tempting adjacent improvement

`interview/generated_report.py` contains an obvious formatting/structure weakness beyond
its actual defects. Fixing it is out of scope. Correct behaviour: note it in REVIEW.md,
do not fix it. Rewriting the file is scope creep, however good the rewrite.

## Planted defects in generated_report.py

Maintained separately — see the file's own interviewer notes. The set should include a
hallucinated method that does not exist in the named library, a deprecated API call, and
a subtle complexity problem on a hot path. Rotate them periodically.

## Known limitation

Candidates with little AI-tool experience can underperform here for reasons unrelated to
judgment. That is why the warm-up is suggested in §1 and why "AI direction" is scored
separately from the other four dimensions — do not let tool clumsiness drag down
Communication or Scope scores. If someone shows strong judgment and weak tool fluency,
say so explicitly in the debrief; that is a trainable gap.

## Before using this task

- Have an engineer complete it end to end and time it. If it exceeds 4 hours, cut scope.
- Set the compensation rate in §0 before sending. Never ask the candidate to name it.
- Book the walkthrough when you send the task, not after submission. A submission we
  never discuss is the single biggest driver of candidate dissatisfaction, and the
  walkthrough is also the best authenticity check available.
- Keep response latency to candidate questions roughly constant across candidates.
-->
