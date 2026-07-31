---
name: revisar
description: Revisão cruzada do diff atual usando um modelo de OUTRO fornecedor, para pegar o que o modelo que escreveu o código não vê. Use antes de entregar mudança, antes de abrir PR, ou quando o usuário pedir revisão, code review ou segunda opinião.
---

# Revisão cruzada por modelo de outro fornecedor

Modelos diferentes têm modos de falha diferentes. O modelo que escreveu o código é o
pior revisor dele: ele já acredita na própria solução. Trocar de fornecedor na
revisão pega classe de erro que a mesma família repete.

## Procedimento

1. **Reúna o material.** O diff é a unidade de revisão:

   ```sh
   git diff HEAD          # ou: git diff <base>...HEAD
   ```

2. **Chame um modelo de outro fornecedor.** Uma chamada one-shot, sem TUI:

   ```sh
   git diff HEAD | pi --provider openai --model <modelo> -p "$(cat <<'EOF'
   Revise este diff como revisor cético. Não elogie, não resuma o que o código faz.
   Reporte só problemas, cada um com arquivo:linha e o cenário concreto de falha
   (entrada específica -> saída errada). Se não houver problema real, diga isso em
   uma linha.
   Foque em: correção, caso de borda não tratado, erro engolido, e mudança fora do
   escopo pedido.
   EOF
   )"
   ```

   Ajuste o `--provider`/`--model` para um fornecedor **diferente** do que produziu
   o código. Se o código saiu de um modelo Anthropic, revise com OpenAI, e vice-versa.
   Modelo local serve para revisão barata de diff pequeno.

3. **Triagem antes de agir.** Revisor cético produz falso positivo. Para cada achado,
   confirme lendo o código antes de mexer. Achado que você não conseguiu reproduzir
   mentalmente não vira alteração — vira pergunta.

4. **Reporte** o que o revisor achou, o que você confirmou, e o que descartou com o
   motivo.

## Por que one-shot e não sessão

A revisão precisa ser **independente**: contexto limpo, sem o histórico de quem
escreveu o código e sem as justificativas já dadas. Sessão contaminada revisa o
raciocínio, não o resultado.

## Não faça

- Não peça "revise e corrija" na mesma chamada. Revisar e consertar juntos faz o
  modelo justificar as próprias mudanças.
- Não aceite achado sem verificar. Aplicar sugestão de revisor às cegas troca um bug
  por outro.
- Não revise com o mesmo modelo que escreveu — é o caso que esta skill existe para
  evitar.
