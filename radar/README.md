# Technology Radar

The versions, install links and install commands `/dev-check` uses. **This folder is the source of
truth for version floors** — nowhere else in the guide repeats them.

- One file per snapshot, named `YYYY-MM-DD.csv`. `LATEST` names the current one, and must always
  be the name that sorts last (CI checks). `install.sh` and `/dev-check` use it unless you pass
  another.
- Rows sorted by `technology`, case-insensitive. Fields are split on commas, so **no field may
  contain a comma**, and nothing is quoted.
- To move a floor or change a command, add a new dated file and update `LATEST`. Never edit an old
  one, so earlier radars stay usable.

| Column | Meaning |
|--------|---------|
| `technology` | Must match a tool name in the [dev-check skill](../.claude/skills/dev-check/SKILL.md) check table |
| `version` | A floor written with a `+` (`2.55+`), or `any`. Never an exact pin |
| `url` | The official install page |
| `requires` | Tools that must be installed first, `;`-separated. `/dev-check` installs in this order |
| `linux` | Install-or-upgrade command for Debian/Ubuntu/WSL. Empty = the setup is too involved to script; follow `url` |
| `macos` | The same for macOS. `brew` commands implicitly require Homebrew |

`/dev-check` runs these commands exactly as written. It never makes one up, and it hands back any
command containing `sudo` for you to run. Files before `2026-09-29.csv` have only the first three
columns.

Use a specific radar with:

```bash
curl -fsSL https://raw.githubusercontent.com/havilandsoftware/development-guide/main/install.sh | sh -s -- 2026-09-28.csv
```

The floors in these files were last verified 2026-07-29.
