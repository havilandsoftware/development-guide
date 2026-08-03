# Expectations
These expectations are meant to be read and followed by all team members to foster growth, improve communication, and bolster product development.

## Team Guidelines
- *Responsible AI First* - We are an AI-driven team, and our productivity improves when we use it in new and creative ways. Responsible and ethical usage of AI requires a methodical and iterative process.  We are intentional about AI, but believe in its use for good! For more details, refer to the [AI Responsibility Guide](./ai.md).
- *Review What your AI Generates before Sharing* - You are 100% responsible for anything that is generated with AI.  Do not share your work/PR with others unless you have thoroghly reviewed the changes first!
- *Don't Hide* - As a remote team, we depend on you being proactive to use your voice and show your face. You are more than an empty screen or Slack handle. Additinoally, good teammates communicate to their team and clients often!  Let them know what's happening, when its happening.
- *Keep Learning, and Set Your Bar High* - Technologies change, and so should you.  There's always a next level and new things to learn.  The learning guide is a great place to start for reading material, videos/content, and tutorials!
- *Contribute, Create, and Share* - As you learn/create new things, make your work known by sharing and teaching others!
- *Use Campground Rules* - Find ways to make the surrounding code, communication channel, directory, etc. nicer than what you found it.
- *Bring Positive Energy* - Sometimes its not easy, but your team depends on it. Cheer your teammates on!
- *Follow the Tech Radar* - The technology radar is a guiding star for technology adoption in the company.  New technologies should be introduced or decommissioned methodically, not in isolation. And most importantly, avoid straddling technologies that accomplish the same thing!
- *Know your OKRs* - OKRs are the flag poles that guide the team towards its strategic objectives.  If you don't know your OKRs, you won't know where to go!
- *Deliver to Production, not Development* - If your code stays in development, it isn't adding value! You are responsible for your PRs and getting them closed.
- *Do the little things* - You are never too experienced to do the little things.  Set the example!

## Standard Practices
These standard practices represent the most important procedural concepts that allow the company to function efficiently.

### OKRs
Popularized by the book Measure What Matters, objective key results (OKRs) provide a relationship between the completion of work and the strategic vision through quarterly objectives produced by the leadership team(s).  This book is one of the most important suggested reading material.  Developers are expected to know the quarter's OKRs and to assist the team in delivering to them (or communicate that an OKR is no longer relevant).

### Maintaining Documentation
The development team relies on the README documentation to communicate how to work with the repository.  As the project changes, the README should include updates alongside their corresponding development changes.  And when creating a new repository, the README should include each section:
- Title and summary
- Prerequisites and installations
- Build
- Run
- Test
- Troubleshooting

### Maintaining Code Quality

- Keep Branching, Pull Requests, and Code Reviews Focused
- Automate Feedback Loops over Manual Processes
- Use Pair Programming
- Leverage Approved Technology and Standards

### Ticketing Practices
Employees use the ticketing process to assign work.  The ticket owner is responsible for moving the ticket forward and being its advocate.
- Aim for 2-3 days worth of work per ticket.
- Break up tickets if you see they are set to become project tickets (over 5 days of work) or could potentially linger.
- In Test tickets are higher priority than In Progress.
- Make sure your ticket is given success criteria.  If it doesn't, then either timebox the ticket as a Research task or determine the success criteria when first assigned.
- Ticket completion should be equivalent with "production" use, no matter the type of ticket.
- Tickets should be given a standard label, and in the case of product development, a release assignment.

### Development Tooling
Install the core (Tier 1) toolchain during onboarding — see the
[Installation and Setup Guide](installation-and-setup-guide.md). Project-specific and DevOps tooling
(Tier 2 and 3) is installed only when a project actually needs it: import the project, run
`dev-check` from inside the repository, and install what it reports. Installing every CLI up front
leaves you maintaining tools you never use.

### Security Practices
Employees are responsible to protect the data and software systems of the company through basic security practices.
- Enable MFA on all SaaS applications, e.g AWS, GitHub, Linear, Slack
- Using the Technology Radar and Development Guide as a barometer for approved frameworks, language, technologies
- Do not share keys, passwords, code or data to unauthorized personel inside and outside of the organization.
- Evaluate vulnerabilities in code that is deployed
- Never make a repository public without an admin's approval and a full history scrub — see [GitHub](../technologies/git.md#public-repositories)
