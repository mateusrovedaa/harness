# harness-minimo

**English** · [Português](README.pt-br.md)

A starter kit for working with coding agents **without depending on a model or a
closed tool**. Clone it, adjust `AGENTS.md`, start working.

## The thesis

The harness became a commodity. What accumulates value is **text versioned in
git** — instructions, skills, procedures. If your investment lives in files,
switching engines is switching one config line; if it lives inside a closed
product, switching means starting over.

| Layer | What it is | Tool | Lock-in |
|---|---|---|---|
| 0 — Model | LLM access | OpenRouter, local Ollama, direct API | zero |
| 1 — Engine | loop + tools + context | **pi** (MIT) | low |
| 2 — Distro | `AGENTS.md`, skills, scripts | **this repository** | zero |
| 3 — Orchestration | parallelism, cockpit | Orca, firstmate | zero: optional |

Start with layers 1 and 2. Layer 3 only when running agents in parallel is
routine — see [docs/en/layer-3.md](docs/en/layer-3.md).

## Start today

```sh
curl -fsSL https://pi.dev/install.sh | sh   # 1. the engine
pi                                          # 2. the model: /login (or: ollama serve)
git clone https://github.com/mateusrovedaa/harness-minimo && cd harness-minimo   # 3. the distro
$EDITOR AGENTS.md                           #    20 lines about YOUR project is enough
pi                                          # 4. work
```

There is only one mental model: **an LLM in a loop, with four tools, reading and
writing your repository.** No MCP, no subagents, no plan mode on day one. When a
procedure repeats, extract a skill; when parallel work shows up,
`scripts/worktree-new.sh` + tmux.

## What is in here

```
AGENTS.md                    the project contract — the most important file
.agents/skills/plan/         writes PLAN.md with a strong model (plan mode = a file)
.agents/skills/cross-review/ cross-review with a model from ANOTHER vendor
.agents/skills/ship/         tests -> diff -> commit -> PR
scripts/worktree-new.sh      isolated worktree, zero dependencies
docs/en/                     docs in English: pi, layer 3, choosing a model
docs/pt-br/                  os mesmos docs em português
```

`.agents/skills/` is the **cross-harness** location: pi, Claude Code and
firstmate all read from there. `AGENTS.md` is read natively by pi, Codex and
OpenCode; for Claude Code, run `ln -s AGENTS.md CLAUDE.md`.

**Instruction files are written in English** — `AGENTS.md` and every skill,
including `name` and `description`. English instructions get better adherence
from models, and they travel across teams and harnesses. Talking to the agent
stays in whatever language you prefer.

## The rule worth more than all the tools

**Never trust the agent's report — verify with a script that exits 0 or 1.** That
is how we caught a model claiming success with an empty response and exit code 0,
and a worktree that reported `ok: true` while isolating nothing. Method and
lessons in [docs/en/choosing-a-model.md](docs/en/choosing-a-model.md).

## License

Referenced tools: pi (MIT), Orca (MIT), firstmate (see its repository).
This kit: pick your own.
