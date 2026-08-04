---
name: setup-extensions
description: "Install the kit's opt-in token-reduction extensions, rtk and caveman, on the harness in use. Use when the user asks to add rtk or caveman to a project, or after the setup skill offers them."
---

# Extensions

`pi-web-search` already ships in `.pi/settings.json`, and Claude Code has web
search natively. Nothing to ask there.

The other two are opt-in. Ask which the user wants, then install for the harness
in use — the commands differ:

| | pi | Claude Code |
|---|---|---|
| **rtk** | `rtk init --agent pi` | `rtk init --agent claude` |
| **caveman** | `pi install -l npm:@casualjim/pi-caveman` | `claude plugin marketplace add JuliusBrussee/caveman && claude plugin install caveman@caveman` |

Two things to state rather than smooth over:

- **Run `rtk --version` and `rtk gain` first.** Another tool ships under the same
  name (`reachingforthejack/rtk`). If `rtk gain` errors, it is the wrong binary —
  report that and skip; do not install over it.
- **caveman on Claude Code writes outside the repository.** Its hooks go into
  `~/.claude/` and apply to every Claude Code session on the machine, unversioned
  — against this kit's premise. Default to **no**. If the user says yes, put the
  uninstall command in your report:
  `npx -y github:JuliusBrussee/caveman -- --uninstall`. The pi side carries no
  such caveat: it lands in `.pi/settings.json`, versioned with the repo.

Finish with `git status --short` and `git diff .pi/`, so the user sees exactly
what changed and what is now committed on their behalf.

## Common objections

| Excuse | Reality |
|---|---|
| "Installing both is more helpful" | caveman on Claude Code changes every session on the machine. Opt-in means asking, not assuming. |
| "`rtk` is on the PATH, so it is the right rtk" | A namesake exists. `rtk gain` is the check that tells them apart. |
| "It installed, so it works" | Both act through hooks that load on a fresh session. Say what needs a restart. |
