# Escolher o modelo com dado, não com opinião

O motor é agnóstico, então a pergunta vira **qual modelo colocar atrás dele**.
Não responda com opinião: monte meia dúzia de tarefas com verificação objetiva
e meça. A regra central: **toda verificação é script que sai 0 ou 1 — nunca o
relato do modelo**, que é justamente o que está sendo auditado.

## As três dimensões

- **Custo** — a métrica que decide é **custo por tarefa concluída**, não por
  rodada. Preço de tabela engana: um modelo 10× mais barato que falha 2 de 3
  vezes sai mais caro que o caro que acerta de primeira. Modelo local tem dólar
  zero e segundo não-zero — conte o seu tempo de espera.
- **Token** — tokens por conclusão mede a eficiência do loop. Observe também
  turnos por tarefa (cada volta repaga o contexto inteiro), taxa de erro de
  ferramenta (o retrabalho escondido dos modelos pequenos) e fração vinda de
  cache.
- **Qualidade** — inclua tarefas que separam: **adesão a restrição** (o atalho
  proibido que o `git diff` denuncia — a mais importante se o agente vai rodar
  sem babá) e **honestidade** (o arquivo alvo não existe; modelo bom diz que
  não existe, ruim inventa).

## O que 43 rodadas nos ensinaram

- **Modelo local falha no multi-passo, e do pior jeito possível:** resposta
  vazia, `stop_reason: stop`, exit code 0, sem executar nada. Um harness que
  confia no código de saída marca sucesso. É por isso que a verificação tem
  que ser script.
- **"Grátis" custa caro em trabalho interativo:** ~120s por conclusão contra
  ~20s de um modelo de fronteira. Local é racional para lote, ou para dado que
  não pode sair da máquina — não para trabalho que você espera sentado.
- **Entre modelos de fronteira, escolha pelo eixo escasso:** o mais barato e
  com menos retrabalho de ferramenta para frota autônoma em volume; o mais
  rápido para trabalho interativo.

## A divisão de papéis

| Tier de tarefa | Modelo |
|---|---|
| mecânica de passo único, em lote | local (grátis; latência não importa) |
| multi-passo, ambígua, com prazo | fronteira barato (ex.: claude-sonnet-5) |
| sensível a latência interativa | fronteira rápido |

## Ressalvas

- LLM é estocástico: compare com ao menos 3 repetições por tarefa, e depois
  repita com duas ou três tarefas do **seu** repositório real.
- Mantenha o diretório de sessão **fora** do diretório de trabalho medido:
  instrumentação dentro da fixture inflou 38 mil tokens por rodada, porque o
  agente lia o próprio arquivo de sessão em crescimento.
