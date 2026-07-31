#!/usr/bin/env bash
# Cria uma worktree git isolada para trabalho paralelo de agente.
#
#   scripts/worktree-nova.sh <nome-da-tarefa>
#
# Por que: dois agentes no mesmo checkout se atropelam, e um agente sem popup de
# permissao precisa de contencao. A worktree e a contencao mais barata que existe -
# zero dependencia alem do git, e descartavel.
#
# Isto e a ideia mais valiosa do firstmate em 30 linhas de bash. Se um dia voce
# adotar o firstmate ou o Orca, eles fazem isso melhor (com registro e teardown);
# ate la, isto resolve.

set -euo pipefail

NOME="${1:-}"
if [ -z "$NOME" ]; then
  echo "uso: scripts/worktree-nova.sh <nome-da-tarefa>" >&2
  echo "     nome curto, sem espaco. ex: fix-arredondamento" >&2
  exit 1
fi

git rev-parse --git-dir >/dev/null 2>&1 || {
  echo "erro: nao e um repositorio git" >&2; exit 1
}

RAIZ="$(git rev-parse --show-toplevel)"
DEST="$RAIZ/.worktrees/$NOME"

if [ -e "$DEST" ]; then
  echo "erro: $DEST ja existe" >&2
  echo "      remova com: git worktree remove '$DEST'" >&2
  exit 1
fi

# .worktrees/ nunca deve entrar no repositorio
if ! grep -qs '^\.worktrees/$' "$RAIZ/.gitignore" 2>/dev/null; then
  echo '.worktrees/' >> "$RAIZ/.gitignore"
  echo "nota: adicionei .worktrees/ ao .gitignore"
fi

git worktree add -b "$NOME" "$DEST" >/dev/null
echo "✓ worktree criada"
echo "  caminho: $DEST"
echo "  branch:  $NOME"
echo
echo "  cd '$DEST' && pi"
echo
echo "  ao terminar:  git worktree remove '$DEST'"
echo "  listar todas: git worktree list"
