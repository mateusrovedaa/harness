#!/usr/bin/env bash
# Creates an isolated git worktree for parallel agent work.
#
#   scripts/worktree-new.sh <task-name>
#
# Two agents in the same checkout trample each other. A worktree is the
# cheapest containment — no dependency beyond git, and disposable.
#
# This is firstmate's most valuable idea in 30 lines of bash. If you adopt
# firstmate or Orca they do this better (registry + teardown); until then,
# this does the job.

set -euo pipefail

NAME="${1:-}"
if [ -z "$NAME" ]; then
  echo "usage: scripts/worktree-new.sh <task-name>" >&2
  echo "       short name, no spaces. e.g.: fix-rounding" >&2
  exit 1
fi

case "$NAME" in
  *[[:space:]]*)
    echo "error: task name must not contain spaces" >&2; exit 1 ;;
esac

git rev-parse --git-dir >/dev/null 2>&1 || {
  echo "error: not a git repository" >&2; exit 1
}

ROOT="$(git rev-parse --show-toplevel)"
DEST="$ROOT/.worktrees/$NAME"

if [ -e "$DEST" ]; then
  echo "error: $DEST already exists" >&2
  echo "       remove it with: git worktree remove '$DEST'" >&2
  exit 1
fi

# .worktrees/ must never enter the repository. Warn instead of editing: writing a
# tracked file as a side effect of "create a worktree" is a surprise.
if ! grep -qs '^\.worktrees/$' "$ROOT/.gitignore" 2>/dev/null; then
  echo "warning: .worktrees/ is not in $ROOT/.gitignore" >&2
  echo "         add it before committing, or the worktree lands in the repo" >&2
fi

git worktree add -b "$NAME" "$DEST" >/dev/null
echo "✓ worktree created"
echo "  path:   $DEST"
echo "  branch: $NAME"
echo
echo "  cd '$DEST' && pi"
echo
echo "  when done: git worktree remove '$DEST'"
echo "  list all:  git worktree list"
