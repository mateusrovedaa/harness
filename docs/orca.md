# Orca — o ADE

**O que é:** um ADE (Agent Development Environment) — cockpit para rodar vários
agentes de código em paralelo. MIT, macOS e Linux, app desktop com companion mobile.
[github.com/stablyai/orca](https://github.com/stablyai/orca)

```sh
brew install --cask stablyai/orca/orca
```

**Para que serve:** ser a camada 3 do stack — onde você *vê* e conduz frota. Não é
harness nem modelo: é o ambiente em volta deles.

## Por que sugerimos o Orca como ADE

**Ele roda qualquer agente de CLI.** Claude Code, Codex, Cursor CLI, Gemini,
Copilot, OpenCode e o **pi** vêm pré-configurados; qualquer outro que rode em
terminal entra sem atrito. Isso preserva exatamente a propriedade que este kit
busca: o cockpit não te amarra a um motor.

**Worktree nativa por agente.** Cada agente trabalha isolado, com diff e progresso
separados. No stack do firstmate, isso substitui o `treehouse` — o Orca é o único
backend que fornece worktree *e* terminal, dispensando uma dependência.

**Sem markup de modelo.** MIT, e você usa suas próprias assinaturas/chaves. Não há
camada de revenda de tokens no meio.

**Dirigível por agente.** O CLI expõe `orca worktree create`, `snapshot`, `click`,
`fill` e um `orca agent-context` que imprime o schema de comandos para consumo por
agente. Ou seja, o próprio cockpit é scriptável — o que o torna útil como
infraestrutura, não só como interface.

Extras que pesam no dia a dia: engine de terminal classe Ghostty (WebGL, splits
infinitos, scrollback que sobrevive a restart), browser Chromium embutido com
*Design Mode* (captura HTML/CSS + screenshot de um elemento e injeta no prompt do
agente), e app mobile para acompanhar agente rodando.

## Onde ele entra — e onde não

O Orca é **conveniência, não fundação**. `tmux` + `git worktree` entregam 80% do
valor com zero dependência, e é por isso que a trilha do
[README](../README.md#trilha-de-adoção) só chega no Orca no passo 4.

Adote quando: você já roda 2+ agentes ao mesmo tempo com frequência, e perder o fio
de qual terminal tem qual tarefa já te custou tempo.

Não adote quando: você está no primeiro mês. Um cockpit para frota que você ainda
não tem é complexidade sem retorno — e cria dependência de GUI num roteiro que
deveria ser ensinável por terminal.

## Limites que medimos

Testamos o Orca como backend de worktree do firstmate. O app respondeu bem
(`orca status` → `state: ready`, `reachable: true`), mas a integração falhou de um
jeito que vale conhecer **antes** de depender dela:

**1. Classificação `folder` vs `git` é decisiva e silenciosa.** O Orca registra cada
projeto com um `kind`. Projetos `kind: "folder"` **não recebem worktree git** — ele
devolve a própria pasta. Nos nossos dados, o discriminador foi ter **`remote=origin`
configurado**: todos os repos classificados como `git` tinham remote; um repositório
git recém-criado sem remote foi classificado como `folder`.

**2. `orca worktree create` retorna `ok: true` sem isolar.** Quando o projeto é
`folder`, o comando reporta sucesso e devolve o caminho do checkout primário com
`branch: ""`. Nenhum erro. Quem confiar no código de retorno vai escrever no
próprio checkout achando que está numa worktree.

**3. Não há `orca repo rm`.** A classificação fica em cache e `repo add` sobre o
mesmo caminho não a atualiza. Configurar o remote depois **não conserta** — tentamos.

**Como evitar:** configure `origin` no repositório **antes** de registrá-lo no Orca,
e confirme a classificação com:

```sh
orca repo list --json | jq -r '.result.repos[] | "\(.kind)  \(.path)"'
```

Se aparecer `folder` num repositório que deveria ser `git`, não há caminho de volta
pelo CLI — registre por outro caminho ou use outro backend.

**4. No firstmate, o backend Orca é experimental de fato.** O `/afk` (supervisão
com você longe do teclado) e os *secondmates* recusam iniciar em backend não-tmux.
Spawn de crewmate, ship/scout e acompanhamento funcionam; essas duas coisas não.

## O que isso não invalida

Nada disso é argumento contra o Orca como ADE — é argumento para **verificar em vez
de confiar**, que é a mesma lição que atravessa este kit. Como cockpit de terminais
e agentes ele cumpre o papel, e a propriedade que mais nos interessa (rodar qualquer
agente CLI, sem markup, com worktree por agente) está de pé.

Aliás, quem pegou a falha nº 2 foi a guarda de isolamento do firstmate, que
comparou o caminho retornado com o checkout primário e **recusou lançar**. Bom
exemplo de por que essa disciplina paga.
