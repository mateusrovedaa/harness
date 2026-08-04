---
name: setup
description: "Bootstrap this kit in a repository — write a real AGENTS.md from a short interview and wire the symlinks the chosen harness needs. Use on the first run in a fresh clone, or when the user asks to set up, configure or bootstrap the harness."
---

# Set up the harness

## 1. Ask which harness

Ask this first; everything else branches on it. Installed is not chosen.

- **pi** — reads `AGENTS.md` and `.agents/skills/` natively. No symlinks.
- **Claude Code** — needs `CLAUDE.md` and `.claude/skills`. Both ship with the kit.
- **Both** — the kit's default shape. Nothing conflicts.
- **Codex / OpenCode** — read `AGENTS.md`; skills do not carry over. Say so.

## 2. Decide whether to write `AGENTS.md` at all

```sh
grep -qF 'kit-stock-contract' AGENTS.md 2>/dev/null && echo stock || echo custom
git rev-list --count HEAD 2>/dev/null || echo 0
```

| State | Replace `AGENTS.md`? |
|---|---|
| `custom` | No. Show what differs, offer to patch named sections. |
| `stock`, zero commits | Yes. Say you are replacing it; do not ask permission. |
| `stock`, commits present | No. Read `git remote -v` and `git log --oneline -5`, report what they say, and ask whether to convert this repo or leave the kit alone. |

## 3. Detect

Read the repo and propose; do not ask for what is on disk.

| Read | To propose |
|---|---|
| `Makefile`, `package.json`, `pyproject.toml`, `go.mod`, `justfile` | setup / test / lint commands |
| `git log --oneline -20` | commit language, imperative or not, prefix or not |
| top-level directories | whether `Where things live` earns its place |
| `docker-compose.yml`, `.env.example` | services the tests need running |

State findings as a list to correct. "Commits are Portuguese, imperative, no
prefix — right?" costs the user one word.

Zero commits means the convention is undetectable: ask for it.

## 4. Ask what is left

1. **What the project is** — one or two sentences, including what it must never
   get wrong. That clause is what makes the agent cautious in the right place.
2. **The limits** — propose the defaults from `AGENTS.example.md`; let the user
   cut or add. Where there is no permission popup, this is the containment.

If the user cannot say what the project is, stop. An invented description loads
in every session and is wrong.

## 5. Write it

Fill `AGENTS.example.md`, stripping the HTML comments and `Growing this file`.

Write only the sections you filled. `Where things live`, `Traps` and `Do not
touch` come from observed failure, so omit them — and omit `How to run and test`
too when there is no build yet. One exception: write `Where things live` at three
or more top-level **code** directories, meaning this project's source or tests
(`.agents/`, `.claude/`, `.pi/`, `docs/`, `scripts/` are plumbing and do not
count).

Tell the user which sections you left out, and that a section is earned once they
have watched the agent get the same thing wrong **twice** — once is noise.

## 6. Symlinks

Only for the chosen harness. Skip whatever resolves; leave the other harness's
alone.

```sh
ls -l CLAUDE.md .claude/skills
ln -s AGENTS.md CLAUDE.md
ln -s ../.agents/skills .claude/skills
```

If Claude Code does not see the skills through the directory symlink, use a real
`.claude/skills/` holding one file symlink per skill.

## 7. Report

```sh
git status --short
ls -l CLAUDE.md .claude/skills
```

Show the generated `AGENTS.md` in full — a completion claim needs executed
output, not your summary.

Then name the leftovers. In somebody's project, `README.md`, `README.pt-br.md`,
`docs/en/`, `AGENTS.example.md` and a stray `PLAN.md` describe the wrong product.
List what is present and offer to remove it; delete nothing unasked.

Then ask whether they want rtk or caveman. If yes, run the `setup-extensions`
skill; if no, say it exists for later. Do not end setup without asking — nothing
else in the flow reaches that question.

## Common objections

| Excuse | Reality |
|---|---|
| "I can tell the harness from what is installed" | Installed is not chosen. Ask. |
| "Asking for the test command is thorough" | It is in the Makefile. Detect, then confirm. |
| "The README gives me the project description" | A README sells the product; the contract needs what must never break. Read it, draft one sentence, have the user confirm it. |
| "It differs from the example, so I must not overwrite" | Every clone's stock file differs from the example, so that test blocks the only case this skill exists for. Use the table in step 2. |
| "The marker says stock, so I replace it" | Stock plus commits is history setup did not expect. Stop and read it. |
| "I saw the convention before the repo was re-initialized" | They deleted it deliberately. Zero commits means ask — and this kit's own convention is not a fallback. |
| "Empty headings show the user what to fill in" | Absent is cheaper than a heading that teaches nothing. |
| "Setup ran, so the harness works" | Skills load on a fresh session. Say what still needs a restart. |
