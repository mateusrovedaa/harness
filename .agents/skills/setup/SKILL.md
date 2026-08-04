---
name: setup
description: "Bootstrap this kit in a repository — interview the user to write a real AGENTS.md, create the symlinks the chosen harness needs, and offer the optional extensions. Use on the first run in a fresh clone, or when the user asks to set up, configure or bootstrap the harness."
---

# Set up the harness

Turns a fresh clone into a configured harness: a real `AGENTS.md`, the symlinks
the chosen harness needs, and the opt-in token-reduction extensions.

Runs once per repository. Re-running is safe — detect what is already done and
offer to patch instead of overwriting.

## Procedure

### 1. Ask which harness — before anything else

Every later step branches on this answer. Do not infer it from what happens to
be installed: installed is not chosen.

- **pi** — reads `AGENTS.md` and `.agents/skills/` natively. No symlinks needed.
- **Claude Code** — needs `CLAUDE.md` and `.claude/skills`. Both ship with this
  kit; confirm they resolve rather than recreating them.
- **Both** — the kit's default shape. Nothing conflicts.
- **Codex / OpenCode** — read `AGENTS.md` natively, but the skills do not carry
  over. Say so instead of implying they will.

### 2. Detect, then confirm

Read the repository and propose answers. Never ask the user for something that is
already on disk.

| Read | To propose |
|---|---|
| `Makefile`, `package.json` scripts, `pyproject.toml`, `go.mod`, `justfile` | the setup / test / lint commands |
| `git log --oneline -20` | commit language, imperative or not, prefix or not |
| top-level directories | whether `Where things live` is worth writing |
| `docker-compose.yml`, `.env.example` | services the tests need running |

Present findings as a list to correct, not as questions. "Your commits are in
Portuguese, imperative, no prefix — right?" beats "What are your commit
conventions?" — it costs the user one word instead of a paragraph.

A brand-new or empty repository has nothing to detect. Say that and go to 3.

The same holds signal by signal. Zero commits means the commit convention is not
detectable — ask for it. Do not offer this kit's own convention as the proposal:
that imports a default from an unrelated project and dresses it up as something
you derived from the repo.

### 3. Ask only what cannot be detected

Two things:

1. **What the project is** — one or two sentences, including what it must never
   get wrong. That last clause is what makes the agent cautious in the right
   place instead of uniformly timid.
2. **The limits** — propose the defaults from `AGENTS.example.md`, let the user
   cut or add. In a harness with no permission popup this is the main line of
   containment, so do not skip it to save a round trip.

If the user cannot say what the project is, stop. An `AGENTS.md` with an invented
description is worse than no file: it loads in every session and it is wrong.

### 4. Write `AGENTS.md`

Fill `AGENTS.example.md` with the answers, stripping the instructional HTML
comments and the `Growing this file` section.

**Generate the core only** — `The project`, `How to run and test`,
`Conventions`, `Limits`, `How to work here`, `Verification`. The three optional
sections (`Where things live`, `Traps`, `Do not touch`) are written from observed
failure, and an empty heading is worse than an absent one. One exception: write
`Where things live` when the tree has three or more top-level **code**
directories, where the map pays off immediately. Code means this project's source
or tests — `.agents/`, `.claude/`, `.pi/`, `docs/` and `scripts/` are harness
plumbing and do not count, so a fresh clone with no project code yet scores zero.

Close by telling the user those sections exist in the example, and to add one
after watching the agent get the same thing wrong twice.

If `AGENTS.md` already exists, decide by reading its first lines — **not** by
comparing it against the example:

```sh
grep -qF 'kit-stock-contract' AGENTS.md && echo stock || echo custom
```

- `stock` → this is the file every clone of the kit ships with. Replace it. Say
  that you are replacing it; do not ask permission for it.
- `custom` → someone wrote this for the project. Do not overwrite. Show what
  differs and offer to patch named sections.

Two things that look like simplifications and are not. Comparing against
`AGENTS.example.md` cannot decide this — the stock file always differs from the
example, so that test blocks the one case setup exists for. And the marker stays
an opaque sentinel rather than a readable sentence: a phrase like "the contract
for this repository" is something a user could plausibly type into their own
file, and a false `stock` reading destroys their work. Deleting the sentinel is
how a user opts out of being overwritten, which the stock file says on its face.

### 5. Symlinks

Only for the harness chosen in step 1. Check first; skip whatever already
resolves.

```sh
ls -l CLAUDE.md .claude/skills          # both ship with this kit
ln -s AGENTS.md CLAUDE.md               # only if missing
ln -s ../.agents/skills .claude/skills  # only if missing
```

If Claude Code does not pick the skills up through the directory symlink, fall
back to a real `.claude/skills/` directory holding one file symlink per skill.

### 6. Offer the extensions

`pi-web-search` already ships in `.pi/settings.json` for pi, and Claude Code has
web search natively — nothing to ask. The other two are opt-in, and the install
differs by harness:

| | pi | Claude Code |
|---|---|---|
| **rtk** | `rtk init --agent pi` | `rtk init --agent claude` |
| **caveman** | `pi install -l npm:@casualjim/pi-caveman` | `claude plugin marketplace add JuliusBrussee/caveman && claude plugin install caveman@caveman` |

Two things to state rather than smooth over:

- **Run `rtk --version` and `rtk gain` first.** A different tool ships under the
  same name (`reachingforthejack/rtk`). If `rtk gain` errors, the binary is the
  wrong one — report it and skip, do not install over it.
- **caveman on Claude Code writes outside the repository.** It merges hooks into
  `~/.claude/` and applies to every Claude Code session on the machine, not just
  this project, so it is not versioned in git — which is the premise of this
  kit. Default to **no**. If the user says yes, put the uninstall command in your
  report: `npx -y github:JuliusBrussee/caveman -- --uninstall`.

  The pi side carries no such caveat: it lands in `.pi/settings.json`, versioned
  with the repository.

### 7. Show the evidence

```sh
git status --short
ls -l CLAUDE.md .claude/skills
```

Then show the generated `AGENTS.md` in full. Per this kit's own rule, a
completion claim needs executed output — not your summary of what you set up.

## Common objections

| Excuse | Reality |
|---|---|
| "I can tell the harness from what is installed" | Installed is not chosen. Someone running both pi and Claude Code wants one of them configured. Ask. |
| "Asking for the test command is thorough" | It is in the Makefile. Detect it, then confirm. Asking what is on disk spends the user's patience on nothing. |
| "The README gives me the project description" | A README sells the product; the contract needs what must never break. Read it, then have the user confirm one sentence. |
| "Empty optional headings show what to fill in" | An empty heading is context the model reads and learns nothing from. Absent is cheaper. |
| "The AGENTS.md here differs from the example, so I must not overwrite it" | Every fresh clone ships the kit's own AGENTS.md, which always differs. Decide by the marker in its first lines, not by the comparison — otherwise you block the one case this skill exists for, and then waste a round trip asking the user something the file already told you. |
| "Installing both extensions is more helpful" | caveman on Claude Code changes every session on the machine. Opt-in means asking, not assuming. |
| "Setup ran, so the harness works" | The skills only load on a fresh session. Report what you created and what the user still has to confirm after restarting. |
