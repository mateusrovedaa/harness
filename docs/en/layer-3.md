# Layer 3 — fleet orchestration

Only come here when running 2+ agents in parallel is routine. Until then,
`tmux` + `scripts/worktree-new.sh` deliver 80% of the value with zero
dependencies.

## Orca — the cockpit

An ADE (Agent Development Environment) for driving several CLI coding agents
in parallel. MIT, macOS/Linux.
[github.com/stablyai/orca](https://github.com/stablyai/orca)

```sh
brew install --cask stablyai/orca/orca
```

Why it: runs any terminal agent (pi, Claude Code, Codex, ...), native
worktree per agent, no token markup, and the cockpit itself is scriptable —
`orca agent-context` prints the command schema for agent consumption.

**The gotcha that matters:** Orca classifies each project as `git` or
`folder`, and a `folder` project **gets no worktree** — `orca worktree
create` returns `ok: true` while handing back the primary checkout itself,
with no error. In our tests the discriminator was having a `remote origin`
configured, and there is no way to reclassify via the CLI afterwards.
Configure `origin` **before** registering the repo, and confirm:

```sh
orca repo list --json | jq -r '.result.repos[] | "\(.kind)  \(.path)"'
```

## firstmate — the fleet distro

A portable directory of instructions, skills and scripts that turns a
terminal agent into a fleet manager: you talk to **one** agent, it
dispatches crewmates in isolated worktrees and escalates only what needs a
decision.
[github.com/kunchenguid/firstmate](https://github.com/kunchenguid/firstmate)

Adopt it only when managing a fleet is already routine. Until then, steal
the four ideas that carry the value — all of them work with tmux + git
worktree:

1. **One isolated worktree per task.** Never two agents in the same
   checkout.
2. **Ship vs scout.** Authorized delivery vs investigation that never
   pushes — keeps exploratory research from becoming an accidental commit.
3. **Supervision in bash, not in an LLM.** A shell watcher sleeps over the
   fleet and wakes the agent only when something is actionable. Watching
   with an LLM burns context.
4. **Verify instead of trusting.** Before launching, check that the
   worktree is real and distinct from the primary checkout. That guard is
   what caught the Orca bug above — without it, the agent would have
   written straight into the checkout.

Beware: crewmates run with permissions disabled
(`--dangerously-skip-permissions`). The isolated worktree is not a
convenience — it is the only containment.
