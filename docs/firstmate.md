# firstmate — a distro de frota

**O que é:** uma *agent distro* — um diretório portátil de instruções, skills,
scripts e políticas que transforma qualquer agente de terminal em gerente de frota.
Não é harness, não é modelo, não é MCP, não é CLI: é o repositório em si.
[github.com/kunchenguid/firstmate](https://github.com/kunchenguid/firstmate)

> "Talk to one agent. Ship with a crew."

**Para que serve:** você conversa com **um** agente — o *first mate*. Ele despacha
crewmates que trabalham em paralelo, cada um em worktree isolada, e escala para você
só o que precisa de decisão. Resolve o atrito de babá de várias sessões: nada de
copiar contexto entre terminais nem rastrear qual janela tem qual tarefa.

## Os conceitos que valem ouro mesmo sem adotar

Se você não for usar o firstmate, roube estas quatro ideias. Elas são o núcleo do
valor e funcionam com `tmux` + `git worktree`:

**1. Worktree isolada por tarefa.** Trabalho paralelo em clones descartáveis, nunca
no checkout primário. Sem isso, dois agentes simultâneos se atropelam.
(`scripts/worktree-nova.sh` neste kit faz isso com zero dependência.)

**2. Duas formas de tarefa: *ship* e *scout*.** Ship entrega mudança autorizada via
PR ou merge local. Scout **nunca dá push** — produz um relatório em
`data/<id>/report.md`. Separar investigação de entrega evita que uma pesquisa
exploratória vire commit acidental.

**3. Supervisão a custo zero de token.** Um watcher em **bash** dorme sobre a frota,
classifica os eventos e acorda o agente só quando há algo acionável. Quem observa é
shell, não LLM. É a diferença entre supervisão barata e queimar contexto vigiando.

**4. Verificar em vez de confiar.** O firstmate se acopla aos harnesses por
**contratos de ciclo de vida** que cada fornecedor já expõe (hooks no pi, hooks
`UserPromptSubmit`/`Stop` no Claude Code, plugin no OpenCode, probes no Codex) — não
por raspagem de texto renderizado. E antes de lançar, ele **confere** que a worktree
é real e distinta do checkout primário.

## Vantagens

**Agnóstico de harness de verdade.** Roda sobre Claude Code, Grok, pi, pi-signed,
Codex e OpenCode. É a prova prática de que a camada de distro sobrevive à troca de
motor — o mesmo argumento que sustenta este kit.

**Roteamento por tipo de tarefa.** O `config/crew-dispatch.json` escolhe harness,
modelo e nível de esforço por regra. O exemplo que ele traz já usa `claude`+`haiku`+
`effort: low` para edição mecânica e `claude-sonnet-5`+`effort: high` para refactor
ambíguo. É onde a divisão de papéis de
[escolher-modelo.md](escolher-modelo.md) vira configuração.

**Estado em disco, resistente a restart.** Mate a sessão e reabra: a próxima
invocação reconcilia a partir do estado persistido.

**Conhecimento durável por projeto.** `AGENTS.md` committado (com `CLAUDE.md` como
symlink), e escrita de memória por *inspect-then-update* em vez de append cego.

## O que medimos na prática

Testamos com backend Orca e harness Claude Code. **A tarefa scout não completou** —
e o motivo é informativo:

**A guarda de isolamento funcionou, e foi ela que pegou um bug de terceiro.** O
`orca worktree create` retornou `ok: true` devolvendo o próprio checkout primário. O
firstmate comparou os caminhos, **recusou lançar** com mensagem explícita, e o
`git status` do repositório ficou limpo. Sem essa checagem, um agente com permissões
desativadas teria escrito direto no checkout. Detalhes em [orca.md](orca.md).

**As duas rotas de worktree têm pré-requisito.** O backend Orca falhou pela
classificação `folder`; o backend tmux — que é o **de referência verificado** —
exige o `treehouse` como provedor de worktree, uma dependência a mais instalada por
`curl | sh`.

**O bootstrap apontou 6 ferramentas opcionais ausentes** além do treehouse
(`no-mistakes`, `gh-axi`, `chrome-devtools-axi`, `lavish-axi`, `tasks-axi`,
`quota-axi`). Nenhuma bloqueia um scout no Orca, mas o `no-mistakes` é o gate de
validação de tarefas *ship*.

**Crewmates rodam com permissões desativadas.** O harness `claude` é lançado com
`--dangerously-skip-permissions`. É o que torna a autonomia possível — e é por isso
que a worktree isolada não é conforto, é a única contenção. É também a razão pela
qual a guarda de isolamento importa tanto.

**A superfície é grande.** O `AGENTS.md` do firstmate tem ~57 KB e o `bin/` passa de
60 scripts. É um projeto sério e bem construído, mas o contrato de operação em si já
é uma leitura longa.

## Quando adotar

**Adote quando** gerenciar frota já for rotina: você roda várias tarefas simultâneas
com frequência, tem orçamento para vários agentes de fronteira ao mesmo tempo, e
perder o fio entre sessões já te custou trabalho.

**Não adote quando** você está começando. O valor dele é proporcional ao paralelismo
que você realmente tem; sem isso, é superfície operacional sem retorno.

**No meio:** leia o [`docs/architecture.md`](https://github.com/kunchenguid/firstmate/blob/main/docs/architecture.md)
dele como documento de design desde já, e copie os quatro padrões acima aos poucos.
Foi o que mais rendeu para nós — o valor conceitual chegou antes da adoção.

## Configuração mínima, se for testar

```sh
gh auth login
git clone https://github.com/kunchenguid/firstmate && cd firstmate

echo orca   > config/backend        # ou: tmux (referência, exige treehouse)
echo claude > config/crew-harness   # ou: pi, codex, opencode, grok

bin/fm-bootstrap.sh                 # diagnóstico; silêncio = tudo ok
claude                              # aprove o trust prompt uma vez
```

Para despachar direto pelos scripts, sem a sessão interativa: escreva
`data/<id>/brief.md` e rode
`bin/fm-spawn.sh <id> <dir-do-projeto> --scout --backend <backend>`.
O spawn recusa se o brief não existir ou se a worktree não for isolada.
