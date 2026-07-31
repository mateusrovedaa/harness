---
name: planejar
description: Escreve um plano de implementação em PLAN.md antes de mexer no código. Use quando a tarefa envolver mais de um arquivo, tiver ambiguidade, ou quando o usuário pedir plano, planejamento ou "pensar antes de fazer". Substitui o plan mode de harnesses fechados por um arquivo versionado.
---

# Planejar antes de implementar

Plan mode não precisa ser recurso do harness: um arquivo resolve, e ainda fica no
histórico do git para consulta e revisão.

## Quando usar

- A mudança toca mais de um arquivo.
- O enunciado tem ambiguidade real (mais de uma interpretação defensável).
- A tarefa é arriscada ou difícil de reverter.

Tarefa de um arquivo com enunciado claro **não** precisa de plano. Escrever plano
para isso é cerimônia.

## Procedimento

1. **Leia antes de propor.** Localize os arquivos envolvidos e leia as partes
   relevantes. Plano escrito sem ler o código é chute formatado.

2. **Escreva `PLAN.md`** nesta estrutura:

   ```markdown
   # <tarefa>

   ## Entendimento
   O que vai ser feito, em duas ou três frases.

   ## Ambiguidades
   O que o enunciado não decide, e a interpretação que vou adotar.
   Se houver ambiguidade que muda o resultado, PARE e pergunte em vez de escolher.

   ## Passos
   1. arquivo:linha — o que muda e por quê
   2. ...

   ## Como vou verificar
   O comando exato que prova que funcionou.

   ## Fora de escopo
   O que eu poderia ter mexido e deliberadamente não vou.
   ```

3. **Mostre o plano e espere.** Não comece a implementar na mesma volta.

## Dica de custo

Planejamento se beneficia de modelo forte; implementação de plano bom aceita modelo
mais barato. Se o harness permitir trocar modelo em sessão (`/model` no pi), planeje
com o modelo caro e implemente com o barato — o plano é o que carrega a inteligência
para a etapa seguinte.

## Não faça

- Não escreva plano de 40 linhas para mudança de 3 linhas.
- Não liste "rodar os testes" como passo: isso é a verificação, não o trabalho.
- Não invente ambiguidade para parecer cuidadoso. Se está claro, diga que está claro.
