# GitHub

This page covers the GitHub platform and the `gh` CLI. For branching strategy, pull
request workflow, and repository creation standards, see [Git](git.md).

## Account Setup

1. Create your account and join the [havilandsoftware](https://github.com/havilandsoftware)
   organisation.
2. **Enable MFA.** Required on every SaaS account — see
   [Expectations](../getting-started/expectations.md#security-practices).
3. Add an SSH key — steps in the
   [Installation and Setup Guide](../getting-started/installation-and-setup-guide.md#create-an-ssh-key-and-add-it-to-github).
4. Authenticate the CLI:

   ```bash
   gh auth login
   ```

   Check with `gh auth status`. Claude Code uses `gh` for issue and PR operations, so
   this is not optional if you use the agentic workflow.

## Topics

Every repository carries a GitHub topic identifying the project or client it belongs to.
Topics are not decoration — tooling reads them. Release batching and project onboarding
both discover repositories by topic, so a missing topic means a repository silently drops
out of releases.

Use the topic for the project the repository belongs to. If you are unsure which applies,
ask rather than guessing — the wrong topic puts a repository in the wrong release.

## Repository Settings Baseline

New repositories need all of this set, and [Git](git.md) covers it as a checklist:

| Setting | Value |
|---------|-------|
| Visibility | Private |
| Default branch | `main` |
| Merge strategy | Squash merge only — disable merge commits and rebase merging |
| Branch protection | On `main`: require a pull request, require one approving review |
| Topics | Set (see above) |
| Description | Set |
| Team access | Attached to the appropriate team |
| Slack channel | Repository attached to its channel |

## The `gh` CLI

The commands that come up daily:

```bash
# Pull requests
gh pr create --title "Title" --body "Description" --base main
gh pr list
gh pr view 123
gh pr checks 123
gh pr diff 123

# Issues
gh issue create --title "Title" --body "Description"
gh issue list --label bug
gh issue view 456

# Actions
gh run list
gh run watch
gh run view --log-failed

# Anything else
gh api repos/havilandsoftware/<repo>
```

`gh api` reaches any REST endpoint with your existing auth, which is usually simpler than
building a request by hand.

## Actions

CI configuration standards — required workflows, what must pass before merge, and the
baseline for each language — live in
[Coding Standards §8](standards.md#8-github-actions--ci-baseline). That section is
authoritative; this page does not duplicate it.

## Public Repositories

Most of our repositories are private. A public one carries extra requirements, because
publishing is effectively irreversible: history stays visible in forks, mirrors, and
caches after a takedown.

Before making a repository public:

- **Get approval from a repository admin.** This is not a solo decision.
- **Add a LICENSE.** Without one, default copyright applies and nobody can legally reuse
  the code — which defeats the purpose of publishing.
- **Scrub the full history, not just the current state.** A credential in an old commit
  is still exposed. See
  [Coding Standards §Secret Removal Procedure](standards.md#secret-removal-procedure).
- **Remove client names, internal URLs, service endpoints, and customer data.**
- **Add `SECURITY.md`** with a vulnerability disclosure contact.
- **Add `CONTRIBUTING.md`** if you intend to accept outside contributions.
- **Enable secret scanning and push protection**, and turn on Dependabot alerts.
- **Audit dependency licences** for compatibility with the licence you are publishing
  under.

Once public, treat every commit as permanent.

## Related

- [Git](git.md) — branching, pull requests, repository creation standards
- [Coding Standards](standards.md) — CI baseline, secret removal
- [Claude Code](claude.md) — how the agentic workflow uses `gh`
