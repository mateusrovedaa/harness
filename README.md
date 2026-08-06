# Minimal Harness

A starter kit for coding agents **without depending on a specific model or
closed tool**. Clone it, adjust `AGENTS.md`, start working.

## Why this exists

The harness is a commodity now. What accumulates value is **text versioned in
git**: instructions, skills, procedures. Keep your investment in files and
switching engines is one config line away. Keep it inside a closed product
and you start from zero.

| Layer | What it is | Tool | Lock-in |
|---|---|---|---|
| 0 — Model | LLM access | OpenRouter, local Ollama, direct API | zero |
| 1 — Engine | loop + tools + context | **pi** (MIT) | low |
| 2 — Distro | `AGENTS.md`, skills, scripts | **this repository** | zero |
| 3 — Orchestration | parallelism, cockpit | [Orca](https://github.com/stablyai/orca), [firstmate](https://github.com/kunchenguid/firstmate) | zero: optional |

Start with layers 1 and 2, and stay there. Layer 3 earns its place only once
running agents in parallel is routine, and `scripts/worktree-new.sh` + tmux cover
most of it without another tool.

## Start today

```sh
curl -fsSL https://pi.dev/install.sh | sh   # 1. the engine
pi                                          # 2. the model: /login (or: ollama serve)
git clone https://github.com/mateusrovedaa/harness my-project   # 3. the distro
cd my-project && rm -rf .git && git init    #    your history, not the kit's
pi                                          # 4. ask for the `setup` skill
```

The `setup` skill interviews you and writes `AGENTS.md`: it reads your
`Makefile`, `package.json` and `git log` to propose the commands and conventions,
so you confirm instead of typing. Prefer doing it by hand? Copy
`AGENTS.example.md` over `AGENTS.md` and fill it in — 20 lines about your project
is enough.

The mental model is simple: **an LLM in a loop, with four tools, reading and
writing your repository.** No MCP, no subagents, no plan mode on day one. When a
procedure repeats, extract a skill; when parallel work shows up,
`scripts/worktree-new.sh` + tmux.

That is not just a preference. The SWE-bench authors' own
[mini-swe-agent](https://github.com/swe-agent/mini-swe-agent) (MIT) gives the model
**only bash** — fewer tools than pi has — in about 100 lines of Python, and reports
scoring above 74% on SWE-bench Verified with it. The scaffold is not where the
capability lives.

The honest counter-case: Prime Intellect's
[prime-agent](https://github.com/PrimeIntellect-ai/prime-agent) (MIT) argues that
fixed tool schemas make the model "work around its own scaffolding instead of
leveraging it", and puts a persistent Python REPL with programmatic sub-agents past
the human baseline on ARC-AGI-3. Harness design can buy a great deal. It is still
not what you buy first — you are one person with a repository, and the minimal path
costs nothing to abandon once your work outgrows it.

## What is in here

```
AGENTS.md                    the project contract — the most important file
AGENTS.example.md            the template the setup skill fills in
.agents/skills/setup/        interviews you, writes AGENTS.md, wires the harness
.agents/skills/setup-extensions/  installs rtk or caveman, per harness
.agents/skills/plan/         writes PLAN.md with a strong model (plan mode = a file)
.agents/skills/cross-review/ cross-review with a model from ANOTHER vendor
.agents/skills/ship/         tests -> diff -> commit -> PR
.pi/settings.json            ships one extension: web search
scripts/worktree-new.sh      isolated worktree, zero dependencies
docs/en/                     pi's gotchas, and choosing a model with data
```

`.agents/skills/` is the **cross-harness** location. pi and firstmate read it
directly; Claude Code reads `.claude/skills`, which ships as a symlink to it.
`AGENTS.md` is read natively by pi, Codex and OpenCode; Claude Code reads
`CLAUDE.md`, which also ships as a symlink. Nothing to wire by hand.

Only **one** extension ships registered — web search, which pi has no native
answer for. rtk and caveman are opt-in through `setup-extensions`, because they
change how every session behaves; see
[docs/en/pi.md](docs/en/pi.md#extensions).

Everything here is written in English: better adherence from models, and it
travels across teams and harnesses. The operative rule lives in
[`AGENTS.md`](AGENTS.md). Talking to the agent stays in whatever language you
prefer.

## The one rule that matters

**Never trust the agent's report — verify with a script that exits 0 or 1.**
We caught a model claiming success with an empty response and exit code 0,
and a worktree that reported `ok: true` while isolating nothing. Method and
lessons in [docs/en/choosing-a-model.md](docs/en/choosing-a-model.md).

## License

Referenced tools: pi (MIT), Orca (MIT), firstmate (see its repository).
This kit: pick your own.
