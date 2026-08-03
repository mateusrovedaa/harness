# Minimal Harness

**English** · [Português](README.pt-br.md)

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

The mental model is simple: **an LLM in a loop, with four tools, reading and
writing your repository.** No MCP, no subagents, no plan mode on day one. When a
procedure repeats, extract a skill; when parallel work shows up,
`scripts/worktree-new.sh` + tmux.

## What is in here

```
AGENTS.md                    the project contract — the most important file
.agents/skills/plan/         writes PLAN.md with a strong model (plan mode = a file)
.agents/skills/cross-review/ cross-review with a model from ANOTHER vendor
.agents/skills/ship/         tests -> diff -> commit -> PR
.pi/settings.json            project-local extensions (npm/git packages)
scripts/worktree-new.sh      isolated worktree, zero dependencies
docs/en/                     docs in English: pi, layer 3, choosing a model
docs/pt-br/                  os mesmos docs em português
```

`.agents/skills/` is the **cross-harness** location: pi, Claude Code and
firstmate all read from there. `AGENTS.md` is read natively by pi, Codex and
OpenCode; for Claude Code, run `ln -s AGENTS.md CLAUDE.md`.

### Extensions (pi)

Extensions are TypeScript modules that add tools, commands, and events to pi.
They live in `.pi/settings.json` (project) or `~/.pi/agent/extensions/`
(global).

To add an extension to the project:

```sh
pi install -l npm:@foo/bar           # npm package
pi install -l git:github.com/user/repo  # git repository
```

The `-l` flag installs locally into the project (`.pi/npm/` or `.pi/git/`),
and the registration goes into `.pi/settings.json` — everything versioned in
git. Without `-l` the installation is global (`~/.pi/agent/`).

**Instruction files are written in English** — `AGENTS.md` and every skill,
including `name` and `description`. English instructions get better adherence
from models, and they travel across teams and harnesses. Talking to the agent
stays in whatever language you prefer.

## The one rule that matters

**Never trust the agent's report — verify with a script that exits 0 or 1.**
We caught a model claiming success with an empty response and exit code 0,
and a worktree that reported `ok: true` while isolating nothing. Method and
lessons in [docs/en/choosing-a-model.md](docs/en/choosing-a-model.md).

## License

Referenced tools: pi (MIT), Orca (MIT), firstmate (see its repository).
This kit: pick your own.
