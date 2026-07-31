# AGENTS.md

> Este é o arquivo mais importante do kit. Ele é carregado em toda sessão e é o
> contrato de operação do projeto. Substitua o conteúdo pelo do **seu** projeto —
> o que está aqui é gabarito comentado.
>
> Lido nativamente por pi, Codex e OpenCode. Para o Claude Code: `ln -s AGENTS.md CLAUDE.md`

## O projeto

<!-- Uma ou duas frases: o que é, para quem, qual o problema que resolve. -->
<!-- O agente usa isso para decidir o que é relevante. Seja concreto. -->

Projeto exemplo: API de relatórios em Python, consumida pelo painel interno.

## Como rodar e testar

<!-- Comandos exatos. Isto economiza mais token que qualquer outra seção, porque
     sem eles o agente tenta descobrir sozinho, errando algumas vezes. -->

```sh
make setup      # dependências
make test       # suíte completa
make lint       # formatação e lint
```

## Convenções que valem neste repositório

<!-- Só o que NÃO é dedutível do código. Não repita o que o linter já garante. -->

- Migrações nunca são editadas depois de aplicadas; crie uma nova.
- Nada de chamada de rede em teste unitário — use os fixtures em `tests/fixtures/`.
- Mensagem de commit em português, imperativo, sem prefixo de tipo.

## Limites — o que exige minha autorização

<!-- Escreva isto ANTES de soltar agente autônomo. O pi não tem popup de
     permissão: este arquivo é a sua principal linha de contenção. -->

- Não rode migração contra banco que não seja local.
- Não altere nada em `infra/` nem `.github/workflows/`.
- Não adicione dependência nova sem me perguntar.
- Não faça `push`, nem abra PR, sem eu pedir.

## Como trabalhar aqui

- Antes de mudança que passe de um arquivo, escreva o plano em `PLAN.md`
  (skill `planejar`).
- Terminou de implementar? Rode a revisão cruzada (skill `revisar`) antes de me
  chamar.
- Tarefas em `TODO.md`. Marque o que concluiu.
- Ao concluir, mostre `git diff` e o resultado dos testes — não só o resumo do que
  você acha que fez.

## Verificação

<!-- A regra que mais evita retrabalho neste kit. -->

Afirmação de conclusão precisa de evidência executada: saída de teste, `git diff`,
comando rodado. "Corrigi e deve funcionar" não conta.
