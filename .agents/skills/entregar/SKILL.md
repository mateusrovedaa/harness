---
name: entregar
description: Fecha uma tarefa com disciplina — testes verdes, diff conferido, commit e (se autorizado) PR. Use quando a implementação estiver pronta, quando o usuário pedir para entregar, commitar, fechar a tarefa ou abrir PR.
---

# Entregar

O equivalente da tarefa *ship* do firstmate, em versão de sessão única. A ideia é
que "pronto" tenha significado verificável.

## Procedimento

1. **Rode a verificação e cole a saída.** Não parafraseie.

   ```sh
   make test    # ou o comando do AGENTS.md deste projeto
   make lint
   ```

   Teste vermelho encerra a entrega. Conserte ou reporte — não siga adiante.

2. **Leia o próprio diff, inteiro.**

   ```sh
   git diff HEAD
   git status --short     # pega arquivo esquecido e lixo não rastreado
   ```

   Procure especificamente: arquivo temporário ou de debug, `print`/`console.log`
   esquecido, mudança fora do escopo pedido, credencial ou caminho local vazado.

3. **Confira os limites do `AGENTS.md`.** Se o diff toca algo listado como
   proibido — infra, workflows, dependência nova — **pare e pergunte**, mesmo que a
   mudança pareça certa.

4. **Commit.** Uma tarefa, um commit, mensagem que diz o *porquê*:

   ```sh
   git add -A
   git commit -m "corrige arredondamento no cálculo de desconto"
   ```

5. **PR só se autorizado.** `push` e abertura de PR são ações externas: exigem pedido
   explícito do usuário nesta conversa. Autorização de uma vez não vale para a
   próxima.

   ```sh
   git push -u origin HEAD
   gh pr create --fill
   ```

## Trabalho paralelo

Se houver mais de uma tarefa ao mesmo tempo, cada uma na própria worktree:

```sh
scripts/worktree-nova.sh <nome-da-tarefa>
```

Assim os agentes não se atropelam e cada diff fica isolado. Esta é a ideia mais
valiosa do firstmate, e não precisa do firstmate para usar.

## Não faça

- Não anuncie conclusão sem saída de comando. "Deve funcionar" não é entrega.
- Não commite com teste vermelho "para não perder o trabalho" — use `git stash` ou
  uma branch.
- Não junte refactor oportunista com a correção pedida. Diff misturado é diff que
  ninguém revisa bem.
