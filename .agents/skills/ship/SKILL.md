---
name: ship
description: "Close a task with discipline — green tests, diff read in full, commit, and (if authorized) PR. Use when the implementation is done, or when the user asks to deliver, commit, finish the task, or open a PR."
---

# Ship

"Done" has a verifiable meaning: green tests, a diff you read in full, and a
commit that says why.

## Procedure

1. **Run the verification and paste the output verbatim.**

   ```sh
   make test    # or whatever AGENTS.md defines for this project
   make lint
   ```

   A red test ends the delivery. Fix it or report it, then stop.

2. **Read your own diff, all of it.**

   ```sh
   git diff HEAD
   git status --short     # catches forgotten files and untracked junk
   ```

   Look specifically for: temp or debug files, leftover `print`/`console.log`,
   changes outside the requested scope, leaked credentials or local paths.

3. **Check the limits in `AGENTS.md`.** If the diff touches anything listed as
   forbidden — infra, workflows, new dependencies — STOP and ask, even if the
   change looks right.

4. **Commit.** One task, one commit, a message that says WHY. Follow the
   project's commit conventions in `AGENTS.md` (language, style):

   ```sh
   git add -A
   git commit -m "fix rounding in the discount calculation"
   ```

5. **PR only if authorized.** `push` and opening a PR are external actions: they
   require an explicit request from the user in THIS conversation. Authorization
   once does not carry over to the next time.

   ```sh
   git push -u origin HEAD
   gh pr create --fill
   ```

## Parallel work

More than one task at a time? One worktree per task:

```sh
scripts/worktree-new.sh <task-name>
```

Agents stop stepping on each other and each diff stays isolated, with nothing
beyond git.

Confirm the worktree is a different path from the primary checkout before you turn
an agent loose in it. Tooling has reported `ok: true` while handing back the
checkout itself, and an agent that believes it is isolated writes straight into
your working tree.

## Common objections

| Excuse | Reality |
|---|---|
| "It should work now" | Not a delivery. Run the command and paste the output. |
| "Tests passed earlier this session" | A green run only proves the tree it ran on. Run again on what you are about to commit. |
| "Commit now so the work is not lost" | Not on a red test. Use `git stash` or a branch. |
| "While I am here, I will clean this up too" | A mixed diff is a diff nobody reviews well. One task, one commit. |
