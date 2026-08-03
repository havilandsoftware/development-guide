# Git and GitHub

## Installation & First Time Setup
Please follow the installation and first time setup instructions [here](../getting-started/installation-and-setup-guide.md#setup-git).

Enable MFA on your GitHub account — see
[Expectations → Security Practices](../getting-started/expectations.md#security-practices). Then
authenticate the CLI, which Claude Code uses for all issue and PR operations:

```bash
gh auth login     # check with: gh auth status
```

## Repository Creation Standards
- Make it private
- Add README using documentation standards below
- Add your topics on the GitHub page - we have a set list to choose from below
- Add a description on the GitHub page
- Update the merging strategy to only squash merge
- Set default branch to main
- Protect `main`: require a pull request and one approving review
- Attach the GitHub repository to the appropriate team
- Attach the repository to a channel

**Topics are not decoration** — tooling reads them. Release batching and project onboarding both
discover repositories by topic, so a missing topic silently drops a repository out of releases. If
you are unsure which applies, ask rather than guessing.

## The `gh` CLI

The commands that come up daily:

```bash
gh pr create --title "Title" --body "Description" --base main
gh pr list · gh pr view 123 · gh pr checks 123 · gh pr diff 123
gh issue create --title "Title" --body "Description"
gh issue list --label bug
gh run list · gh run watch · gh run view --log-failed
gh api repos/havilandsoftware/<repo>
```

`gh api` reaches any REST endpoint with your existing auth, which is usually simpler than building a
request by hand.

CI configuration standards live in
[Coding Standards §8](standards.md#8-github-actions--ci-baseline).

## Branching
We follow a more consolidated/feature centric version of `git flow` as a branching strategy.
1. When work begins, the **developer** checks out and pulls code from main branch.
2. They then create a branch using the ticket name, e.g. `git checkout -b HS-1234-build-something`.  
3. All changes associated with that ticket should be committed in the branch.  
4. When the person is ready, they should push the branch and create a `pull request` in github.  A pull request allows the development team the chance to provide feedback and approve the changes.  
5. Once approved by a **peer** and the application is built through the CI/CD system, the **developer** is responsible for merging the changes into the `main` branch.


## Documentation
README documentation communicates how to work with the repository.  As the project changes, the README should include updates alongside their corresponding development changes.  And when creating a new repository, the README should include each section:
- Title and summary
- Prerequisites and installations
- Build
- Run
- Test
- Troubleshooting

```
# Title
.... summary goes Here

## Prerequisites
- Install [app 1](https://something/app/1)
- Install [app 2](https://something/app/2)
...

## Build

### Local Build

### Dev/Prod Build


## Testing
...

## Troubleshooting
### Issue number 1
....

### Issue number 2
....

## TODO
- [] First todo
- [] Second todo

```

## Public Repositories

Most of our repositories are private. A public one carries extra requirements, because publishing is
effectively irreversible — history stays visible in forks, mirrors, and caches after a takedown.

### 1. Approval and content

- **Get approval from a repository admin.** This is not a solo decision.
- **Scrub the full history, not just the current state.** A credential in an old commit is still
  exposed — see [Secret Removal Procedure](standards.md#secret-removal-procedure).
- **Remove client names, internal URLs, service endpoints, and customer data.**
- **Remove absolute paths containing a username** (`/home/<user>/…`) and any named individual with
  privileges attached.
- **Audit dependency licences** for compatibility with the licence you are publishing under.

### 2. Required files

| File | Purpose |
|------|---------|
| `LICENSE` | **Required.** Without one, default copyright applies and nobody may legally reuse the code — which defeats the point of publishing. |
| `SECURITY.md` | **Required.** Where to report a vulnerability privately, what is in scope, and how quickly you will respond. Without it, the first report arrives as a public issue. |
| `README.md` | **Required.** Must state what the repo is, who it is for, and whether outside use is supported. |
| `CONTRIBUTING.md` | Required **only if you accept outside pull requests.** Decide deliberately — omitting it silently is not the same as declining contributions. |
| `CODE_OF_CONDUCT.md` | Optional. Conventional for repos expecting outside participation. |

A minimal `SECURITY.md` covers four things: the private reporting channel (never a public issue), the
scope, an acknowledgement target ("within 5 working days" beats silence), and which versions are
supported — for most of our repos that is `main` only.

### 3. Repository settings

Set all of these **before** flipping visibility:

| Setting | Value |
|---------|-------|
| Secret scanning | Enabled |
| Secret scanning — push protection | Enabled |
| Secret scanning — non-provider patterns and validity checks | Enabled |
| Dependabot alerts and security updates | Enabled |
| Branch protection on `main` | Require a pull request and at least one approving review |
| Actions → workflow permissions | **Read-only**, and disable "Allow Actions to approve pull requests" |
| Private vulnerability reporting | Enable **immediately after** going public — see note below |

```bash
R=havilandsoftware/<repo>

gh api -X PATCH repos/$R \
  -f 'security_and_analysis[secret_scanning][status]=enabled' \
  -f 'security_and_analysis[secret_scanning_push_protection][status]=enabled' \
  -f 'security_and_analysis[secret_scanning_non_provider_patterns][status]=enabled' \
  -f 'security_and_analysis[secret_scanning_validity_checks][status]=enabled' \
  -f 'security_and_analysis[dependabot_security_updates][status]=enabled'

gh api -X PUT repos/$R/actions/permissions/workflow \
  -f default_workflow_permissions=read -F can_approve_pull_request_reviews=false

gh api -X PUT repos/$R/branches/main/protection \
  -F 'required_pull_request_reviews[required_approving_review_count]=1' \
  -F enforce_admins=false -F required_status_checks=null -F restrictions=null
```

**Private vulnerability reporting is a public-repo-only feature.** Attempting it while the repo is
private returns `404`, and it is silently ignored if passed in the `security_and_analysis` PATCH
above. Enable it as the first step *after* flipping visibility:

```bash
gh api -X PUT repos/$R/private-vulnerability-reporting   # public repos only
```

**Why workflow permissions matter most here.** GitHub's default gives every workflow a `write` token
and lets Actions approve pull requests. On a public repo that combination means a workflow — yours or
one added in a PR — can push to `main` and approve its own change. Read-only by default, elevated
per-workflow only where genuinely needed.

**On branch protection:** requiring a review means you cannot merge your own PR unaided on a
solo-maintained repo. `enforce_admins=false` above leaves an admin override, which is the intended
tradeoff — know it before you hit it mid-merge rather than after.

Verify the result rather than assuming:

```bash
gh api repos/$R --jq '.security_and_analysis'
gh api repos/$R/branches/main/protection --jq '.required_pull_request_reviews'
gh api repos/$R/actions/permissions/workflow
```

Once public, treat every commit as permanent.
