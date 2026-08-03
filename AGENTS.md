# AGENTS.md

> The most important file in this kit. It is loaded in every session and is the
> project's operating contract. Replace this content with **your** project's —
> what is here is a commented template.
>
> Written in English on purpose: this is instruction text the model consumes, and
> English gets better adherence. Talk to the agent in whatever language you
> prefer.
>
> Read natively by pi, Codex and OpenCode. For Claude Code: `ln -s AGENTS.md CLAUDE.md`

## The project

<!-- One or two sentences: what it is, who it is for, what problem it solves. -->
<!-- The agent uses this to decide what is relevant. Be concrete. -->

Example project: a Python reporting API consumed by the internal dashboard.

## How to run and test

<!-- Exact commands. This saves more tokens than any other section, because
     without them the agent tries to figure it out on its own, getting it
     wrong a few times first. -->

```sh
make setup      # dependencies
make test       # full suite
make lint       # formatting and lint
```

## Conventions that hold in this repository

<!-- Only what is NOT deducible from the code. Don't repeat what the linter
     already enforces. -->

- Migrations are never edited after being applied; create a new one.
- No network calls in unit tests — use the fixtures in `tests/fixtures/`.
- Commit messages in Portuguese, imperative, no type prefix.

## Limits — what requires my authorization

<!-- Write this BEFORE letting an autonomous agent loose. pi has no permission
     popup: this file is your main line of containment. -->

- Do not run migrations against any database other than local.
- Do not change anything under `infra/` or `.github/workflows/`.
- Do not add a new dependency without asking me.
- Do not `push` or open a PR unless I ask.

## How to work here

- Before a change that spans more than one file, write the plan to `PLAN.md`
  (skill `plan`).
- Done implementing? Run the cross-review (skill `cross-review`) before calling
  me.
- Tasks live in `TODO.md`. Check off what you finished.
- Instruction files are written in **English** — this file and every skill,
  including `name` and `description`. Applies to new skills and to edits of
  existing ones.
- When you are done, show `git diff` and the test output — not just your summary
  of what you think you did.

## Verification

<!-- The rule that prevents the most rework in this kit. -->

A completion claim needs executed evidence: test output, `git diff`, a command
that ran. "Fixed it, should work" does not count.
