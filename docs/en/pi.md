# pi — the engine

A terminal harness for coding agents. MIT, npm, TypeScript.
[pi.dev](https://pi.dev).

The model-agnostic execution layer — takes the task, manages context, calls
tools, runs the loop. Nothing beyond that.

## Lock-in

pi has **four tools**: `read`, `write`, `edit`, `bash`. Everything else is a
TypeScript extension or a markdown skill. The small core keeps the engine
replaceable: no proprietary format, no hidden state — instructions are
`AGENTS.md`, skills are markdown, sessions are JSONL.

**15+ providers**: Anthropic, OpenAI, Google, Bedrock, Groq, OpenRouter,
**Ollama** and others. Switch models mid-session with `/model`; custom
providers (Ollama, vLLM, LM Studio, any proxy) plug in via
`~/.pi/agent/models.json`.

Bonus: pi records per-message `usage` in the session file, with dollar cost
already computed — measure real cost per task instead of estimating. Basis of
[choosing-a-model.md](choosing-a-model.md).

## What it does not have

Every absence has a substitute, and the substitute is usually simpler:

| Missing | Use instead |
|---|---|
| MCP | a TypeScript extension, or a CLI called via `bash` |
| Subagents | another session in tmux, or an extension |
| Plan mode | write `PLAN.md` (see the `plan` skill) |
| Task list | `TODO.md` |
| Permission popup | a container, or a git repo with frequent commits |
| Background bash | tmux, where you can see what is running |
| Web search | an extension: `pi-web-access` or `@ollama/pi-web-search` |

## The real risk (and how to mitigate it)

**There is no permission popup.** The agent runs `bash` and writes files
without asking. Mitigation, in order of effectiveness:

1. Always work **inside a git repository**, committing before letting the
   agent loose. `git diff` and `git checkout .` solve almost everything.
2. Use an **isolated worktree** for work you will not watch closely
   (`scripts/worktree-new.sh`).
3. Run in a **container** if the work touches credentials or infrastructure.

The same goes for skills: they can instruct the model to do anything and may
contain executable code. **Read third-party skills before using them.**

## Commands that cover 90% of usage

```sh
pi                            # interactive session
pi -p "task"                  # one task, no TUI (good for scripting)
pi -c                         # continue the previous session
pi --model claude-sonnet-5    # pick the model at invocation
pi --list-models              # catalog (only authenticated providers appear)
pi --mode json -p "..."       # JSON event stream, for integrations
```

Inside the session: `/login`, `/model`, `/tree` (go back to any point and
branch from there), `Ctrl+P` (cycle favorite models).

Two settings in `~/.pi/agent/settings.json` that change the working rhythm:
`followUpMode: "all"` sends every queued follow-up at once instead of the
default `one-at-a-time` — you keep typing the next instructions while the
model works, and they all land together. `steeringMode: "all"` does the same
for steering prompts.

## Extensions

Extensions are TypeScript modules that add tools, commands and events to pi. They
are registered in `.pi/settings.json` (project) or `~/.pi/agent/extensions/`
(global).

```sh
pi install -l npm:@foo/bar              # npm package
pi install -l git:github.com/user/repo  # git repository
```

The `-l` flag installs into the project (`.pi/npm/` or `.pi/git/`) and writes the
registration to `.pi/settings.json` — versioned in git. Without `-l` the install
is global (`~/.pi/agent/`).

### What this kit ships, and what it only offers

Only one extension ships registered. The other two are opt-in through the
`setup-extensions` skill, because both change how every session behaves and one of
them writes outside the repository.

| | What it does | How it arrives |
|---|---|---|
| `@ollama/pi-web-search` | web search, which pi has no native answer for | ships in `.pi/settings.json` |
| rtk | filters tool output before it reaches context | `rtk init --agent pi` |
| caveman | terser agent output, session hooks | `pi install -l npm:@casualjim/pi-caveman` |

`.pi/rtk-config.json` holds the filter tuning (source-code, build, test, git and
lint output). It is inert without rtk installed, so it ships either way.

Two caveats worth knowing before you say yes:

- A **different tool** publishes as `rtk` (`reachingforthejack/rtk`). If
  `rtk gain` errors, you have the wrong binary.
- `@casualjim/pi-caveman` is a **pi port** of
  [JuliusBrussee/caveman](https://github.com/JuliusBrussee/caveman) and touches
  nothing outside `.pi/`. The upstream project, which is what you install for
  Claude Code, merges hooks into `~/.claude/` instead — machine-global and not
  versioned with your repo. Different trade, same name.

## Gotchas

- **`--list-models` only shows providers with configured credentials.**
  Confirm the exact model ID *after* setting up the key, before a long run.
- **Keep the session directory outside the working directory.**
  `--session-dir` inside the project makes the agent read its own growing
  session file — it cost us 38k tokens per round and a false test negative.
- **A colon in a skill's `description` breaks the frontmatter**, and the
  skill is silently ignored. Quote the description. Confirm loading with:
  `pi -a -p "list only the names of available skills"`
- **A Claude Pro/Max subscription does not power pi** without *extra usage*
  enabled. Either enable extra usage, use an API key, or use Claude Code
  (first-party) for subscription work.
- **Long sessions can cross a provider's context price tier.** Some providers
  charge a higher rate above a context threshold, and an agentic loop drifts
  upward until compaction kicks in. You can force compaction to happen
  earlier by declaring a smaller `contextWindow` for the model in
  `~/.pi/agent/models.json` than the provider's real limit. Check your
  provider's current pricing for where the tier actually starts — the
  mechanism is pi's, the threshold is theirs.

## Reference

Kun's personal pi config, with the settings and extensions they run:
[Kun's pi agent config](https://blog.kunchenguid.com/p/kuns-pi-agent-config).
