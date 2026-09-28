# Plan Format

Every plan or design — written by a person or by Claude — uses this format. A reader should know
what will change, how it behaves, and when it is finished without reading any code.

## Style

- **Short.** One idea per line. Bullets, numbered steps and small tables over paragraphs.
- **Step by step.** Behaviour is written as numbered flows, in the order things happen.
- **Outcome first.** Say what changes for the person using it; keep code detail inside *Build*.
- **Honest.** Anything undecided or unverified goes in *Open / unsure*, with your pick.
- **Consistent.** Same sections, same order, every time. Leave a section out only if it is truly empty.

## Template

```markdown
# <Feature>: <A> ⇄ <B>

## 1. Goal
- 3–5 bullets. Outcomes only, no mechanism.

## 2. Terms
- Only new or ambiguous words. One small table or a line each.

## 3. Rules
1. Numbered, one line each. The behaviour every flow must obey.

## 4. Flows
**A. <Scenario>**
1. Step
2. Step

**B. <Scenario>**
1. Step

## 5. Done when
- [ ] Checkable outcomes — what a reviewer verifies before calling it finished.

## 6. Build: N PRs, each shippable alone
1. **<Name>:** what it delivers (Flows A, B)
- Reuse: existing pieces this builds on
- New: what is added
- DB change: yes / no

## 7. Open / unsure
- Decision or unknown — and what you would pick.

## 8. Verify
- Tests per flow, then a live check per flow.
```

## Section guide

| Section | Answers | Keep out |
|---|---|---|
| Goal | What will be true afterwards? | How it works |
| Terms | What do these words mean here? | Anything the reader already knows |
| Rules | What must always hold? | Scenarios — those are flows |
| Flows | What happens, step by step, in each case? | File names, functions |
| Done when | How do we know it is finished? | Vague items ("works well") |
| Build | What PRs, in what order, reusing what? | Line-level detail |
| Open / unsure | What is not decided or verified yet? | Decisions already made |
| Verify | How is each flow proven? | Restating Done when |
