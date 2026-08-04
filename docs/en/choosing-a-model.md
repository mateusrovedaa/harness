# Choosing a model with data

The engine is agnostic, so the question is **which model to put behind it**.
Don't guess: build half a dozen tasks with objective verification and measure.
The central rule: **every verification is a script that exits 0 or 1 — never
the model's own report**, which is what you are auditing.

Somebody already ran this experiment at scale, with the scaffold held constant.
[mini-swe-agent](https://github.com/swe-agent/mini-swe-agent) (MIT, from the
SWE-bench authors) is about 100 lines of Python that hand the model **only bash**,
and the bash-only SWE-bench Verified leaderboard it powers compares models on that
fixed scaffold, above 74% at the top. Read it as the shape of the answer, not as
your answer: it measures one-shot patch tasks on Python repositories, which is not
your repository or your workday.

## The three dimensions

- **Cost** — the deciding metric is **cost per completed task**, not per
  run. List price misleads: a model 10× cheaper that fails 2 out of 3 times
  ends up more expensive than the pricey one that gets it right first try.
  A local model costs zero dollars and non-zero seconds — count your
  waiting time.
- **Tokens** — tokens per completion measures loop efficiency. Also watch
  turns per task (every round repays the whole context), tool-error rate
  (the hidden rework of small models) and the fraction served from cache.
- **Quality** — include tasks that discriminate: **constraint adherence**
  (the forbidden shortcut that `git diff` exposes — the most important one
  if the agent will run unattended) and **honesty** (the target file does
  not exist; a good model says so, a bad one makes something up).

## What 43 runs taught us

- **Local models fail multi-step tasks in the worst possible way:** an
  empty response, `stop_reason: stop`, exit code 0, having executed
  nothing. A harness that trusts the exit code marks it a success. That is
  why verification must be a script.
- **"Free" is expensive for interactive work:** ~120s per completion versus
  ~20s for a frontier model. Local is rational for batch work, or for data
  that cannot leave the machine — not for work you sit waiting for.
- **Between frontier models, pick by the scarce axis:** the cheaper one
  with less tool rework for autonomous fleets at volume; the faster one for
  interactive work.

## Division of roles

| Task tier | Model |
|---|---|
| single-step mechanical, batched | local (free; latency doesn't matter) |
| multi-step, ambiguous, on a deadline | cheap frontier (e.g. claude-sonnet-5) |
| latency-sensitive interactive | fast frontier |

## Caveats

- LLMs are stochastic: compare with at least 3 repetitions per task, then
  repeat with two or three tasks from **your** real repository.
- Keep the session directory **outside** the measured working directory:
  instrumentation inside the fixture inflated 38k tokens per round, because
  the agent was reading its own growing session file.
- A short-task battery does not capture long-session cost. Cache hit rate and
  any context price tier only show up once sessions get long — see the
  gotchas in [pi.md](pi.md).
