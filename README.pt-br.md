# harness-mínimo

[English](README.md) · **Português**

Kit inicial para trabalhar com agentes de código **sem depender de modelo ou de
ferramenta fechada**. Clone, ajuste o `AGENTS.md`, comece a trabalhar.

## A tese

O harness virou commodity. O que acumula valor é **texto versionado em git** —
instruções, skills, procedimentos. Se o seu investimento mora em arquivos,
trocar de motor é trocar uma linha de configuração; se mora dentro de um
produto fechado, trocar é começar de novo.

| Camada | O que é | Ferramenta | Lock-in |
|---|---|---|---|
| 0 — Modelo | acesso a LLM | OpenRouter, Ollama local, API direta | zero |
| 1 — Motor | loop + ferramentas + contexto | **pi** (MIT) | baixo |
| 2 — Distro | `AGENTS.md`, skills, scripts | **este repositório** | zero |
| 3 — Orquestração | paralelismo, cockpit | Orca, firstmate | zero: opcional |

Comece pelas camadas 1 e 2. A camada 3 só quando rodar agentes em paralelo for
rotina — veja [docs/pt-br/camada-3.md](docs/pt-br/camada-3.md).

## Comece hoje

```sh
curl -fsSL https://pi.dev/install.sh | sh   # 1. o motor
pi                                          # 2. o modelo: /login (ou: ollama serve)
git clone https://github.com/mateusrovedaa/harness-minimo && cd harness-minimo   # 3. a distro
$EDITOR AGENTS.md                           #    20 linhas sobre o SEU projeto bastam
pi                                          # 4. trabalhe
```

O modelo mental é um só: **um LLM num loop, com quatro ferramentas, lendo e
escrevendo o seu repositório.** Nada de MCP, subagente ou plan mode no primeiro
dia. Quando um procedimento se repetir, extraia uma skill; quando aparecer
trabalho paralelo, `scripts/worktree-new.sh` + tmux.

## O que tem aqui

```
AGENTS.md                    contrato do projeto — o arquivo mais importante
.agents/skills/plan/         escreve PLAN.md com modelo forte (plan mode = arquivo)
.agents/skills/cross-review/ revisão cruzada com modelo de OUTRO fornecedor
.agents/skills/ship/         testes -> diff -> commit -> PR
.pi/settings.json            extensões locais do projeto (pacotes npm/git)
scripts/worktree-new.sh      worktree isolada, zero dependência
docs/pt-br/                  documentação em português: pi, camada 3, escolher modelo
docs/en/                     the same docs in English
```

`.agents/skills/` é a localização **cross-harness**: pi, Claude Code e firstmate
leem todos daí. `AGENTS.md` é lido nativamente por pi, Codex e OpenCode; para o
Claude Code, faça `ln -s AGENTS.md CLAUDE.md`.

### Extensões (pi)

Extensões são módulos TypeScript que adicionam ferramentas, comandos e eventos
ao pi. Ficam em `.pi/settings.json` (projeto) ou `~/.pi/agent/extensions/`
(global).

Para adicionar uma extensão ao projeto:

```sh
pi install -l npm:@foo/bar           # pacote npm
pi install -l git:github.com/user/repo  # repositório git
```

A flag `-l` instala localmente no projeto (`.pi/npm/` ou `.pi/git/`), e o
registro vai para `.pi/settings.json` — tudo versionado em git. Sem `-l` a
instalação é global (`~/.pi/agent/`).

**Arquivo de instrução é escrito em inglês** — o `AGENTS.md` e toda skill,
incluindo `name` e `description`. Instrução em inglês tem adesão melhor dos
modelos e viaja entre times e harnesses. A conversa com o agente continua no
idioma que você preferir.

## A regra que vale mais que todas as ferramentas

**Nunca confie no relato do agente — verifique com script que sai 0 ou 1.** Foi
assim que pegamos um modelo declarando sucesso com resposta vazia e exit code 0,
e uma worktree que reportava `ok: true` sem isolar nada. Método e lições em
[docs/pt-br/escolher-modelo.md](docs/pt-br/escolher-modelo.md).

## Licença

Ferramentas referenciadas: pi (MIT), Orca (MIT), firstmate (ver repositório).
Este kit: escolha a sua.
