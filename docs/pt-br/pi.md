# pi — o motor

**O que é:** um harness de terminal para agentes de código. MIT, npm, escrito
em TypeScript. Publicado em [pi.dev](https://pi.dev).

**Para que serve:** ser a camada de execução agnóstica de modelo — recebe a
tarefa, gerencia contexto, chama ferramentas, controla o loop. Nada além disso.

## Por que ele resolve o problema do lock-in

O pi tem **quatro ferramentas**: `read`, `write`, `edit`, `bash`. Todo o resto
é extensão em TypeScript ou skill em markdown. O núcleo pequeno é o que torna o
motor substituível: não há formato proprietário nem estado escondido — as
instruções são `AGENTS.md`, as skills são markdown, as sessões são JSONL.

**15+ provedores**: Anthropic, OpenAI, Google, Bedrock, Groq, OpenRouter,
**Ollama** e outros. Troca de modelo com `/model` no meio da sessão; provedor
customizado (Ollama, vLLM, LM Studio, qualquer proxy) entra via
`~/.pi/agent/models.json`.

Bônus raro: o pi grava `usage` por mensagem no arquivo de sessão, com o custo
em dólar já calculado — dá para medir custo real por tarefa em vez de estimar.
É a base de [escolher-modelo.md](escolher-modelo.md).

## O que ele deliberadamente NÃO tem

Cada ausência tem substituto, e o substituto costuma ser mais simples:

| Ausente | O que usar |
|---|---|
| MCP | extensão TypeScript, ou um CLI chamado via `bash` |
| Subagentes | outra sessão no tmux, ou uma extensão |
| Plan mode | escreva `PLAN.md` (ver a skill `plan`) |
| Lista de tarefas | `TODO.md` |
| Popup de permissão | container, ou repo git com commit frequente |
| Bash em background | tmux, onde você vê o que está rodando |

## O risco real, e como mitigar

**Não há popup de permissão.** O agente executa `bash` e escreve arquivos sem
pedir confirmação. Mitigação, em ordem de eficácia:

1. Trabalhe **sempre dentro de um repositório git**, com commit antes de soltar
   o agente. `git diff` e `git checkout .` resolvem quase tudo.
2. Use **worktree isolada** para trabalho que você não vai acompanhar de perto
   (`scripts/worktree-new.sh`).
3. Rode em **container** se o trabalho tocar credenciais ou infraestrutura.

O mesmo vale para skills: elas podem instruir o modelo a fazer qualquer coisa e
podem conter código executável. **Leia antes de usar skill de terceiro.**

## Comandos que resolvem 90% do uso

```sh
pi                            # sessão interativa
pi -p "tarefa"                # uma tarefa, sem TUI (bom para script)
pi -c                         # continua a sessão anterior
pi --model claude-sonnet-5    # escolhe modelo na invocação
pi --list-models              # catálogo (só provedores autenticados aparecem)
pi --mode json -p "..."       # stream de eventos JSON, para integrar
```

Dentro da sessão: `/login`, `/model`, `/tree` (voltar a qualquer ponto e
ramificar), `Ctrl+P` (ciclar modelos favoritos).

## Pegadinhas que custaram tempo

- **`--list-models` só mostra provedor com credencial configurada.** Confirme o
  ID exato do modelo *depois* de configurar a chave, antes de rodar algo longo.
- **Guarde o diretório de sessão fora do diretório de trabalho.** `--session-dir`
  dentro do projeto faz o agente ler o próprio arquivo de sessão em crescimento
  — nos custou 38 mil tokens por rodada e um falso negativo de teste.
- **Dois-pontos na `description` de uma skill quebra o frontmatter**, e a skill
  é ignorada em silêncio. Coloque a descrição entre aspas. Confirme o
  carregamento com: `pi -a -p "liste apenas os nomes das skills disponíveis"`
- **Assinatura Claude Pro/Max não move o pi** sem *extra usage* habilitado. Ou
  habilite extra usage, ou use API key, ou use Claude Code (first-party) para
  trabalho na assinatura.
