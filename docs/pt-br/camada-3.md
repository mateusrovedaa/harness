# Camada 3 — orquestração de frota

Só chegue aqui quando rodar 2+ agentes em paralelo for rotina. Antes disso,
`tmux` + `scripts/worktree-new.sh` entregam 80% do valor com zero dependência.

## Orca — o cockpit

ADE (Agent Development Environment) para conduzir vários agentes de CLI em
paralelo. MIT, macOS/Linux.
[github.com/stablyai/orca](https://github.com/stablyai/orca)

```sh
brew install --cask stablyai/orca/orca
```

Por que ele: roda qualquer agente de terminal (pi, Claude Code, Codex, ...),
worktree nativa por agente, sem markup de token, e o cockpit é scriptável —
`orca agent-context` imprime o schema de comandos para consumo por agente.

**Pegadinha:** o Orca classifica cada projeto como `git` ou `folder`.
Projeto `folder` **não recebe worktree** — `orca worktree create` retorna
`ok: true` devolvendo o próprio checkout primário, sem erro. Nos nossos testes
o discriminador foi ter `remote origin` configurado, e não há como
reclassificar pelo CLI depois. Configure o `origin` **antes** de registrar o
repo e confirme:

```sh
orca repo list --json | jq -r '.result.repos[] | "\(.kind)  \(.path)"'
```

## firstmate

Diretório portátil de instruções, skills e scripts que transforma um agente de
terminal em gerente de frota: você fala com **um** agente, ele despacha
crewmates em worktrees isoladas e escala só o que precisa de decisão.
[github.com/kunchenguid/firstmate](https://github.com/kunchenguid/firstmate)

Adote só quando gerenciar frota já for rotina. Antes disso, roube as quatro
ideias que carregam o valor — todas funcionam com tmux + git worktree:

1. **Worktree isolada por tarefa.** Nunca dois agentes no mesmo checkout.
2. **Ship vs scout.** Entrega autorizada vs investigação que nunca dá push —
   separa pesquisa exploratória de commit acidental.
3. **Supervisão em bash, não em LLM.** Um watcher shell dorme sobre a frota e
   só acorda o agente quando há algo acionável. Vigiar com LLM queima contexto.
4. **Verificar em vez de confiar.** Antes de lançar, conferir que a worktree é
   real e distinta do checkout primário. Foi essa guarda que pegou o bug do
   Orca acima — sem ela, o agente teria escrito direto no checkout.

Atenção: crewmates rodam com permissões desativadas
(`--dangerously-skip-permissions`). A worktree isolada não é conforto — é a
única contenção.
