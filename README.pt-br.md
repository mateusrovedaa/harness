# harness-mínimo

[English](README.md) · **Português**

Kit inicial para agentes de código **sem depender de modelo específico ou
ferramenta fechada**. Clone, ajuste o `AGENTS.md`, comece a trabalhar.

## Por que isso existe

O harness virou commodity. O que acumula valor é **texto versionado em git** —
instruções, skills, procedimentos. Seu investimento em arquivos significa trocar
de motor com uma linha de configuração. Dentro de um produto fechado, é começar
do zero.

| Camada | O que é | Ferramenta | Lock-in |
|---|---|---|---|
| 0 — Modelo | acesso a LLM | OpenRouter, Ollama local, API direta | zero |
| 1 — Motor | loop + ferramentas + contexto | **pi** (MIT) | baixo |
| 2 — Distro | `AGENTS.md`, skills, scripts | **este repositório** | zero |
| 3 — Orquestração | paralelismo, cockpit | Orca, firstmate | zero: opcional |

Comece pelas camadas 1 e 2. A camada 3 só quando rodar agentes em paralelo for
rotina — veja [docs/en/layer-3.md](docs/en/layer-3.md).

## Comece hoje

```sh
curl -fsSL https://pi.dev/install.sh | sh   # 1. o motor
pi                                          # 2. o modelo: /login (ou: ollama serve)
git clone https://github.com/mateusrovedaa/harness meu-projeto   # 3. a distro
cd meu-projeto && rm -rf .git && git init   #    seu histórico, não o do kit
pi                                          # 4. peça a skill `setup`
```

A skill `setup` te entrevista e escreve o `AGENTS.md`: ela lê seu `Makefile`,
`package.json` e `git log` para propor os comandos e as convenções, então você
confirma em vez de digitar. Prefere na mão? Copie o `AGENTS.example.md` sobre o
`AGENTS.md` e preencha — 20 linhas sobre o seu projeto bastam.

O modelo mental é simples: **um LLM num loop, com quatro ferramentas, lendo e
escrevendo o seu repositório.** Nada de MCP, subagente ou plan mode no primeiro
dia. Quando um procedimento se repetir, extraia uma skill; quando aparecer
trabalho paralelo, `scripts/worktree-new.sh` + tmux.

## O que tem aqui

```
AGENTS.md                    contrato do projeto — o arquivo mais importante
AGENTS.example.md            o template que a skill de setup preenche
.agents/skills/setup/        te entrevista, escreve o AGENTS.md, liga o harness
.agents/skills/setup-extensions/  instala rtk ou caveman, conforme o harness
.agents/skills/plan/         escreve PLAN.md com modelo forte (plan mode = arquivo)
.agents/skills/cross-review/ revisão cruzada com modelo de OUTRO fornecedor
.agents/skills/ship/         testes -> diff -> commit -> PR
.pi/settings.json            traz uma extensão: busca na web
.pi/rtk-config.json          tuning dos filtros do rtk, inerte até você instalar
scripts/worktree-new.sh      worktree isolada, zero dependência
docs/en/                     pi, camada 3, escolher modelo — em inglês
```

`.agents/skills/` é a localização **cross-harness**. pi e firstmate leem direto
de lá; o Claude Code lê `.claude/skills`, que já vem como symlink para lá. O
`AGENTS.md` é lido nativamente por pi, Codex e OpenCode; o Claude Code lê o
`CLAUDE.md`, que também já vem como symlink. Nada para ligar na mão.

Só **uma** extensão vem registrada — busca na web, que o pi não tem nativo. rtk e
caveman são opt-in pela `setup-extensions`, porque mudam o comportamento de toda
sessão; veja [docs/en/pi.md](docs/en/pi.md#extensions).

Arquivo de instrução é escrito em inglês: adesão melhor dos modelos, e viaja
entre times e harnesses. A regra operativa está no [`AGENTS.md`](AGENTS.md). A
conversa com o agente continua no idioma que você preferir.

## A regra que importa

**Nunca confie no relato do agente — verifique com script que sai 0 ou 1.**
Pegamos um modelo declarando sucesso com resposta vazia e exit code 0, e uma
worktree que reportava `ok: true` sem isolar nada. Método e lições em
[docs/en/choosing-a-model.md](docs/en/choosing-a-model.md).

## Licença

Ferramentas referenciadas: pi (MIT), Orca (MIT), firstmate (ver repositório).
Este kit: escolha a sua.
