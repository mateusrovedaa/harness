# AGENTS.md

> Copy this to `AGENTS.md` and replace every section with your project's — or
> run the `setup` skill and let it interview you.
>
> **This file is longer than yours should be.** It carries its guidance in HTML
> comments and shows all three optional sections. Yours keeps only what you
> actually filled in; see *Growing this file* at the bottom.
>
> Written in English on purpose: this is instruction text the model consumes.
> English gets better adherence. Talk to the agent in whatever language you
> prefer.
>
> Read natively by pi, Codex and OpenCode. Claude Code reads `CLAUDE.md`, which
> this kit ships as a symlink to `AGENTS.md`.

## The project

<!-- What it is, who uses it, and what it must never get wrong. That last clause
     is what makes the agent cautious in the right place instead of uniformly
     timid.
     ✅ "Billing service. Wrong amounts reach real customer statements — a money
         bug is not fixed by a redeploy."
     ❌ "A backend service built with modern best practices." -->

Billing service for the SaaS: issues invoices and charges cards through Stripe.
Consumed by the web app and by the nightly dunning job. Wrong amounts reach real
customer statements — a money bug is not fixed by a redeploy.

## How to run and test

<!-- Exact commands, copy-pasteable. This section saves more tokens than any
     other: without it the agent guesses, and guesses wrong two or three times
     first. Include the fast/slow split if you have one — it changes how the
     agent loops. -->

```sh
make setup            # dependencies + pre-commit hooks
make test             # unit + integration, ~40s
make test-unit        # unit only, ~3s — use this in a tight loop
make lint             # ruff + mypy, autofixes what it can
```

Postgres must be running: `docker compose up -d db`. Without it the tests fail
with a bare connection error, not a helpful one.

## Conventions that hold here

<!-- Only what is NOT deducible from the code and NOT enforced by tooling. If
     ruff, mypy or prettier already rejects it, writing it here spends context
     for nothing.
     ✅ "Money is Decimal internally, int cents at the boundary. Never float."
     ❌ "Follow PEP 8."                  — the linter does that
     ❌ "Write clean, maintainable code." — a slogan, not a convention -->

- Money is `Decimal` internally and `int` cents at the API boundary. Never
  `float`.
- Migrations are never edited after being applied — add a new one.
- No network in unit tests. Stripe calls resolve against `tests/fixtures/stripe/`.
- Every charge path is idempotent, keyed on `idempotency_key`. A retry that
  double-charges is the worst bug this service can produce.
- Commit messages in Portuguese, imperative, no type prefix.

## Where things live — OPTIONAL

<!-- Add when the layout is not obvious from `ls`. Four to six lines. It pays for
     itself by cutting the exploration at the start of every session. -->

```
src/billing/invoices/   invoice lifecycle — the core domain
src/billing/gateway/    Stripe adapter; the only module that touches the network
src/billing/dunning/    retry schedule for failed charges
migrations/             Alembic, applied in order, never edited
tests/fixtures/         recorded Stripe responses
```

## Traps — OPTIONAL

<!-- What looks wrong and is deliberate. This is the section that stops the agent
     from "fixing" working code, and almost no AGENTS.md has it. One line each:
     what looks wrong, then why it stays. Write these from failures you actually
     watched, never from imagination. -->

- `gateway/client.py` retries 3× with no backoff on purpose — Stripe's SDK
  already backs off, and stacking both blew the request timeout.
- `invoices/totals.py` rounds half-up, not banker's rounding. It matches the
  finance team's spreadsheet; changing it makes the reports disagree.
- `_normalize_tax_id` is duplicated in two modules on purpose. The copies drifted
  by jurisdiction, and merging them coupled two release cycles.

## Do not touch — OPTIONAL

<!-- Generated, vendored or snapshot files. An agent that "tidies" these produces
     a diff nobody can review. -->

- `src/billing/proto/` — generated from the schema repo. Regenerate, don't edit.
- `tests/snapshots/` — update with `make test-update-snapshots`, never by hand.

## Limits — what requires my authorization

<!-- Write this BEFORE letting an autonomous agent loose. In a harness with no
     permission popup, this section is your main line of containment. Be
     specific: "be careful with the database" is not a limit, it is a mood. -->

- Do not run migrations against any database other than local.
- Do not change anything under `infra/` or `.github/workflows/`.
- Do not add a dependency without asking me.
- Do not `push` or open a PR unless I ask in the same conversation.
- Do not touch the Stripe live keys, ever — including to "check that they load".

## How to work here

<!-- Delete the lines for skills you did not keep. -->

- Before a change spanning more than one file, write the plan to `PLAN.md`
  (skill `plan`).
- Done implementing? Run the cross-review (skill `cross-review`) before calling
  me.
- Tasks live in `TODO.md`. Check off what you finish.
- Instruction files are written in English — this file and every skill, including
  `name` and `description`.
- When you are done, show `git diff` and the test output, not your summary of
  what you believe you did.

## Verification

A completion claim needs executed evidence: test output, `git diff`, a command
that ran. "Fixed it, should work" does not count.

---

## Growing this file

<!-- Delete this whole section from your real AGENTS.md. -->

Start with four sections: **The project**, **How to run and test**, **Limits**,
**Verification**. That is a working contract in about 20 lines, and it is where
most of the value already is.

Add an OPTIONAL section once you have watched the agent get the same thing wrong
**twice**. Not once — once is noise. Twice is a pattern, and a pattern is worth
spending context on. One `Traps` line written from a failure you saw beats ten
written from imagination.

Past roughly 60 lines you are writing documentation instead of a contract, and
the agent starts skimming. When it gets long the fix is usually to move a
procedure into a skill, which loads only when it is relevant.
