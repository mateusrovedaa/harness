# AGENTS.md

<!-- kit-stock-contract

     The contract for THIS repository — the kit itself. Looking for the template
     to copy into your own project? That is AGENTS.example.md.

     Reading this in a clone that is NOT the kit? Then none of it applies to your
     project — the limits below are the kit's, not yours. Run the `setup` skill:
     it replaces this file with your project's real contract.

     Writing your own by hand instead? Delete the `kit-stock-contract` line above
     and `setup` will leave this file alone. -->

## The project

Minimal Harness: a starter kit of instructions, skills and scripts for coding
agents, meant to be cloned into other repositories. Everything here is
instruction text that a model consumes, so stale or wrong prose *is* the defect —
a claim about a harness that no longer holds sends every user of the kit down a
wrong path.

## How to run and test

No build and no test suite. Verification is consistency:

```sh
git ls-files                              # the inventory the READMEs must match
ls -l CLAUDE.md .claude/skills            # the shipped symlinks must resolve
bash -n scripts/worktree-new.sh           # the one script must still parse
grep -rn 'docs/pt-br' --include='*.md' .  # must be empty: that tree was dropped
```

Claims about pi, Claude Code, rtk or caveman get checked against the tool before
they go into a file — `--help`, the package's own README, the real config. Three
of the last review's findings were claims that had quietly gone stale.

## Conventions that hold here

- Instruction files are in English: `AGENTS.md`, `AGENTS.example.md` and every
  `SKILL.md`, including `name` and `description`. Prose for humans is English
  too; `README.pt-br.md` is the single translation.
- A skill's `description` is quoted. An unquoted colon breaks the frontmatter and
  pi drops the skill without saying so.
- Every skill closes with a `Common objections` table. It is the highest-value
  structure in the kit: it names the specific rationalization the model reaches
  for, which generic advice never does.
- Commits in Portuguese, imperative, no type prefix.

## Where things live

```
AGENTS.md              this contract; CLAUDE.md is a symlink to it
AGENTS.example.md      the template the setup skill fills — one source of the structure
.agents/skills/        setup, plan, cross-review, ship — pi reads here; .claude/skills points here
.pi/settings.json      ships pi-web-search only; rtk and caveman are opt-in via the setup skill
docs/en/               pi, layer 3, choosing a model — English only
scripts/               worktree-new.sh, the only executable in the kit
```

## Limits — what requires my authorization

- Do not `push` or open a PR unless I ask in the same conversation.
- Do not add a package to `.pi/settings.json`. Whatever ships there installs on
  every clone — that is my call, not a convenience.
- Do not install rtk, caveman or any extension on this machine while working on
  the kit. Writing about them is the job; running them is not.
- Do not reintroduce `docs/pt-br/` or a second language under `docs/`.

## How to work here

- Before a change spanning more than one file, write the plan to `PLAN.md`
  (skill `plan`) and wait for approval.
- Done implementing? Run the cross-review (skill `cross-review`) before calling
  me.
- When you are done, show `git diff` and the output of the verification commands
  above — not your summary of what you believe you did.

## Verification

A completion claim needs executed evidence: command output, `git diff`, a link
actually checked. "Fixed it, should work" does not count.

What cannot be verified inside the session — whether a symlink loads skills in a
harness that has to restart first — is reported as unverified, with the fallback
written down.
