# pi — o motor

**O que é:** um harness de terminal para agentes de código. MIT, npm, escrito em
TypeScript. Publicado em [pi.dev](https://pi.dev).

**Para que serve:** ser a camada de execução agnóstica de modelo — recebe a
tarefa, gerencia contexto, chama ferramentas, controla o loop. Nada além disso.

## Por que ele resolve o problema do lock-in

O pi tem **quatro ferramentas**: `read`, `write`, `edit`, `bash`. É isso. Todo o
resto é extensão em TypeScript ou skill em markdown.

Isso importa porque o núcleo pequeno é o que torna o motor substituível. Não há
formato proprietário para exportar, nem estado escondido: as instruções são
`AGENTS.md`, as skills são markdown, as sessões são JSONL.

**15+ provedores** falam com ele: Anthropic, OpenAI, Google, Azure, Bedrock,
Mistral, Groq, Cerebras, xAI, Hugging Face, OpenRouter, **Ollama**, e outros. Troca
de modelo com `/model` no meio da sessão, ou `Ctrl+P` para ciclar favoritos.
Provedor customizado (Ollama, vLLM, LM Studio, qualquer proxy) entra via
`~/.pi/agent/models.json`.

## Vantagens que verificamos na prática

**Trocar de fornecedor é uma linha.** Rodamos a mesma bateria de tarefas contra
Ollama local, Anthropic e OpenAI mudando só a configuração — sem adaptador, sem
reescrita.

**Telemetria de custo embutida, e isso é raro.** O pi grava `usage` por mensagem
no arquivo de sessão: `input`, `output`, `cacheRead`, `cacheWrite` e o **custo em
dólar já calculado**. Dá para medir custo real por tarefa em vez de estimar. É a
base de [docs/escolher-modelo.md](escolher-modelo.md).

**Quatro ferramentas bastam.** Cobrimos correção de bug, renomeação multi-arquivo,
debug a partir de traceback, adesão a restrição declarada e tarefa de quatro
passos. Nenhuma exigiu nada além de `read`/`write`/`edit`/`bash`.

**Sessões em árvore.** `/tree` volta a qualquer ponto anterior e ramifica dali.
Compactação automática resume o histórico antigo perto do limite de contexto.

**Skills, extensões e pacotes.** Skills são markdown carregado sob demanda
(padrão [Agent Skills](https://agentskills.io/specification), o mesmo de outros
harnesses). Extensões são TypeScript com acesso a ferramentas, comandos, eventos e
TUI. Pacotes empacotam tudo isso para distribuir por npm ou git.

## O que ele deliberadamente NÃO tem

Esta é a parte mais mal compreendida do pi. Cada ausência tem substituto, e o
substituto costuma ser mais simples que o recurso:

| Ausente | O que usar |
|---|---|
| MCP | extensão TypeScript, ou simplesmente um CLI chamado via `bash` |
| Subagentes | outra sessão no tmux, ou uma extensão |
| Plan mode | escreva `PLAN.md` (ver a skill `planejar`) |
| Lista de tarefas | `TODO.md` |
| Popup de permissão | container, ou repo git com commit frequente |
| Bash em background | tmux, onde você vê o que está rodando |

A lógica: o núcleo permanece pequeno e você implementa o que de fato usa, do jeito
que o seu fluxo pede.

## O risco real, e como mitigar

**Não há popup de permissão.** O agente executa `bash` e escreve arquivos sem
pedir confirmação. Para quem está começando, este é o principal risco do pi.

Mitigação, em ordem de eficácia:

1. Trabalhe **sempre dentro de um repositório git**, com commit antes de soltar o
   agente. `git diff` e `git checkout .` resolvem quase tudo.
2. Use **worktree isolada** para trabalho que você não vai acompanhar de perto
   (`scripts/worktree-nova.sh`).
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
pi --mode json -p "..."       # stream de eventos JSON, para integrar em ferramenta
```

Dentro da sessão: `/login`, `/logout`, `/model`, `/tree`, `Ctrl+L` (modelo),
`Ctrl+P` (ciclar favoritos).

Para medição e comparação de backend, use flags que isolam variáveis:
`--no-skills --no-prompt-templates` e fixture nova por rodada.

## Pegadinhas que custaram tempo

- **`--list-models` só mostra provedor com credencial configurada.** Confirme o ID
  exato do modelo *depois* de configurar a chave, antes de rodar algo longo.
- **Guarde o diretório de sessão fora do diretório de trabalho.** Se `--session-dir`
  aponta para dentro do projeto, o diretório aparece no `git status` e o agente
  pode acabar lendo o próprio arquivo de sessão em crescimento. Isso nos custou 38
  mil tokens por rodada e um falso negativo de teste.
- **Dois-pontos na `description` de uma skill quebra o frontmatter, e a skill é
  ignorada em silêncio.** `description: Fecha a tarefa: testes verdes...` é YAML
  inválido — o pi não carrega e não avisa. Use travessão, ou coloque a descrição
  entre aspas. Confirme o carregamento com:
  `pi -a -p "liste apenas os nomes das skills disponíveis"`
- **Assinatura Claude Pro/Max não move o pi** sem *extra usage* habilitado. Apps de
  terceiro consomem dessa carteira separada, não dos limites do plano. Ou habilite
  extra usage, ou use API key, ou use Claude Code (first-party) para trabalho na
  assinatura.
