# harness-mínimo

Kit inicial para trabalhar com agentes de código **sem depender de modelo ou de
ferramenta fechada**. Clone, ajuste o `AGENTS.md`, comece a trabalhar.

## A tese

O harness virou commodity. O que acumula valor é **texto versionado em git** —
instruções, skills, procedimentos. Se o seu investimento mora em arquivos, trocar
de motor é trocar uma linha de configuração; se mora dentro de um produto fechado,
trocar é começar de novo.

Este kit organiza isso em camadas, das mais para as menos essenciais:

| Camada | O que é | Ferramenta | Lock-in |
|---|---|---|---|
| 0 — Modelo | acesso a LLM | OpenRouter, Ollama local, API direta | zero: é o eixo trocável |
| 1 — Motor | loop + ferramentas + contexto | **pi** (MIT) | baixo: substituível |
| 2 — Distro | `AGENTS.md`, skills, scripts | **este repositório** | zero: é git |
| 3 — Orquestração | paralelismo, cockpit | **Orca** (ADE), firstmate | zero: opcional |

As camadas 0 e 2 são chaves e texto — portáveis por definição. A camada 1 fica
trocável *porque* seu investimento mora na 2.

**Comece pelas camadas 1 e 2. Adicione a 3 só quando tiver necessidade paralela
medida.** A camada 3 é a única onde encontramos atrito real (ver
[docs/firstmate.md](docs/firstmate.md) e [docs/orca.md](docs/orca.md)).

## Comece hoje

```sh
# 1. o motor
curl -fsSL https://pi.dev/install.sh | sh

# 2. o modelo — escolha um
pi           # /login  ->  OpenRouter, Anthropic, OpenAI, ou uma API key
ollama serve # ou 100% local, custo zero

# 3. a distro
git clone <este-repo> && cd <este-repo>
$EDITOR AGENTS.md   # 20 linhas sobre o seu projeto já bastam

# 4. trabalhe
pi
```

O modelo mental é um só: **um LLM num loop, com quatro ferramentas, lendo e
escrevendo o seu repositório.** É isso. Nada de MCP, subagente ou plan mode para
entender no primeiro dia.

## Trilha de adoção

1. **Dia 1** — sessão única. Escreva o `AGENTS.md`. Trabalhe.
2. **Semana 1** — aprenda `/model` e use diversidade por papel: modelo forte
   planeja, barato implementa, um de **outro fornecedor** revisa. Modos de falha
   diferentes pegam o que um só deixa passar.
3. **Depois** — extraia skills dos procedimentos que você já repetiu. As três em
   `.agents/skills/` são o ponto de partida.
4. **Quando aparecer trabalho paralelo** — `scripts/worktree-nova.sh` + tmux.
   Depois **Orca** como ADE, se quiser cockpit visual.
5. **Só quando gerenciar frota for rotina** — avalie o firstmate.

Não pule etapas. Cada uma resolve um problema que você só sente depois de ter o
anterior funcionando.

## O que tem aqui

```
AGENTS.md                    contrato do projeto — o arquivo mais importante
.agents/skills/planejar/     escreve PLAN.md com modelo forte (plan mode = arquivo)
.agents/skills/revisar/      revisão cruzada com modelo de OUTRO fornecedor
.agents/skills/entregar/     worktree -> testes -> commit -> PR
scripts/worktree-nova.sh     worktree isolada, zero dependência
docs/pi.md                   o motor: o que é, vantagens, o que não tem e por quê
docs/firstmate.md            a distro de frota: quando adotar, o que medimos
docs/orca.md                 o ADE: por que sugerimos, e seus limites reais
docs/escolher-modelo.md      como decidir backend com dado, não com opinião
```

`.agents/skills/` é a localização **cross-harness**: pi, Claude Code e firstmate
leem todos daí. `AGENTS.md` é lido nativamente por pi, Codex e OpenCode; para o
Claude Code, faça `ln -s AGENTS.md CLAUDE.md`.

## Uma prática que vale mais que todas as ferramentas

**Nunca confie no relato do agente. Verifique com script.**

Medindo backends com verificação objetiva (ver
[docs/escolher-modelo.md](docs/escolher-modelo.md)) encontramos três falhas que
nenhuma inspeção visual pegaria:

- um modelo local **declarando conclusão com resposta vazia e exit code 0**, sem
  ter executado nenhum dos passos pedidos;
- o Orca retornando `ok: true` ao criar uma worktree **sem isolar nada**;
- um falso negativo no nosso próprio harness de medição, que inflava 38 mil
  tokens por rodada.

Se você levar uma única coisa daqui, leve esta.

## Licença

Ferramentas referenciadas: pi (MIT), Orca (MIT), firstmate (ver repositório).
Este kit: escolha a sua.
