#!/usr/bin/env bash
# Isolated git worktree for parallel agent work: scripts/worktree-new.sh <task>
#
# Two agents in the same checkout trample each other. A worktree is the cheapest
# containment — nothing beyond git, and disposable.
#
# The value here is the convention, not the guards: one branch per task, always at
# .worktrees/<task>. Let git report the errors it already reports well.

set -euo pipefail

NAME="${1:?usage: scripts/worktree-new.sh <task-name>   (short, no spaces)}"
ROOT="$(git rev-parse --show-toplevel)"

grep -qs '^\.worktrees/$' "$ROOT/.gitignore" ||
  echo "warning: .worktrees/ is not in .gitignore — add it before committing" >&2

git worktree add -b "$NAME" "$ROOT/.worktrees/$NAME"

cat <<EOF

  cd '$ROOT/.worktrees/$NAME' && pi
  done: git worktree remove '$ROOT/.worktrees/$NAME'
EOF
