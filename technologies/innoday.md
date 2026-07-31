# InnoDay

> **Internal tooling.** InnoDay is Haviland Software's project and team orchestration
> platform. This page documents how we use it and will not apply outside the
> organisation.

InnoDay holds tickets, boards, projects, releases, and repository links. It is the
authoritative record of what is happening on a project — if something significant
happens, it belongs in InnoDay rather than only in a local file or a chat thread.

## Structure

```
Organisation
└── Project
    ├── Tickets   (TODO / IN_PROGRESS / DONE)
    ├── Boards    (kanban views, scoped to a project or sprint)
    └── Releases
```

Both the CLI and the MCP server resolve the current organisation and project from your
working directory, by walking up to find `.innoday/project.yml`. There is no global
"current org" setting to switch.

## Install

```bash
uv tool install innoday
innoday config init
```

Verify with `innoday --version`, then `innoday orgs current` to confirm it resolved your
identity. Upgrade later with `uv tool upgrade innoday`.

### MCP server

Register the MCP server so Claude Code can read and write InnoDay directly:

```bash
claude mcp add innoday -- mcp-server-innoday
```

It reads the same `~/.innoday/config.json` the CLI uses — no additional environment
variables. Confirm with `claude mcp list`.

If MCP calls return `401` while the CLI works, the server started before the config was
complete and cached the old values. Reconnect it with `/mcp reconnect`.

### Gated APIs and the team secret

A deployed InnoDay API gates every non-public route behind a team secret sent as an
`X-Team-Secret` header. `innoday config init` does **not** seed it, so a machine can
have the CLI installed and MCP registered and still fail every call:

```bash
innoday config show                        # confirm which profile is active
innoday config set team-secret "<secret>"  # writes to the active profile
```

Configuration is **per profile** — the secret lives at
`profiles.<current_profile>.platform.team_secret` in `~/.innoday/config.json`, not at the
top level. Having it seeded on `default` while working on `dev` fails exactly as though it
were never set, so check the profile before concluding the secret is missing.

Get the secret from whoever administers the API you are targeting. A purely local API
has none. `/dev-check` checks for this specifically, because the symptom —
uniform `401`s — reads like a network or auth bug rather than missing configuration.

## Core commands

```bash
innoday tickets list                      # tickets for the current project
innoday tickets list --status IN_PROGRESS  # filter by status
innoday tickets create                    # create a ticket
innoday projects show <slug>              # project detail
innoday orgs current                      # which org am I resolving to?
innoday config show                        # current CLI configuration
innoday ping api                          # is the API reachable?
```

## Use the CLI, not the API

**Agents, skills, and CI talk to InnoDay through the `innoday` CLI.** Only the web UI
calls the API directly.

Do not reach for `curl`, `httpx`, or a hand-rolled HTTP client against the InnoDay API
in any script or automation. The CLI owns authentication, config resolution, retry
behaviour, and output formatting; bypassing it means reimplementing all four and
breaking whenever the API changes. Use `--format json` when you need machine-readable
output.

## Working conventions

- **Do not pass `--organization` routinely.** The CLI resolves the org from your
  directory. The flag is an override for the unusual case, not something to include by
  default.
- **The current org is never persisted** to shared config — it is derived from the
  working directory every time.
- **Record outcomes in InnoDay, not just locally.** Local caches are convenient;
  InnoDay is the record.

## Related

- [Claude Code](claude.md) — the MCP integration and company plugin
- [Release Guide](../getting-started/release-guide.md) — releases are registered in InnoDay
- [dev-check skill](../skills/dev-check/SKILL.md) — verifies CLI, config, MCP, and team secret
