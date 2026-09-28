# Technology Radar

The versions and install links `/dev-check` checks against. **This folder is the source of truth
for version floors** — nowhere else in the guide repeats them.

- One file per snapshot, named `YYYY-MM-DD.csv`. The file whose name sorts last is the current
  radar; `install.sh` and `/dev-check` use it unless you pass another.
- Columns: `technology,version,url`. Rows sorted by `technology`, case-insensitive.
- `version` is a floor written with a `+` (`2.55+`), or `any`. Never an exact pin.
- `url` is the official install page — where to go, not a copy of its instructions.
- `technology` must match a tool name in the
  [dev-check skill](../.claude/skills/dev-check/SKILL.md) check table.

To move a floor, add a new dated file rather than editing an old one, so earlier radars stay
usable. Use an older one with:

```bash
curl -fsSL https://raw.githubusercontent.com/havilandsoftware/development-guide/main/install.sh | sh -s -- 2026-09-28.csv
```

`2026-09-28.csv` carries the floors verified 2026-07-29 and moves the AWS and gcloud CLIs into
the set checked on every machine.
