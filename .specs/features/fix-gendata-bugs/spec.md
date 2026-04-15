# Spec: Correção de Bugs no Gerador de Dados de Teste

**Feature ID:** FIX-GENDATA-001  
**Status:** ✅ Complete (all tasks executed 2026-04-11)  
**Prioridade:** P0 — bloqueador para 15 casos de teste  
**Origem:** [docs/analise-casos-teste.md](../../../docs/analise-casos-teste.md)

---

## Contexto

O arquivo `test/GENDATA.cbl` gera os dados de entrada (`PROVFILE` e `BILLFILE`) usados pelo
teste end-to-end do Hospice Pricer. A análise de cobertura identificou **3 bugs** que invalidam
15 dos 40 casos de teste atualmente gerados, mais uma **lacuna de infraestrutura** que impede
6 casos adicionais de executar corretamente.

---

## Problemas e Requisitos

### REQ-01 — Correção do QIP-IND: `"Y"` → `"1"`

**Bug confirmado:** `HOSPR210` verifica `IF BILL-QIP-IND = '1'` em mais de 20 pontos do código.
`GENDATA.cbl` preenche com `MOVE "Y" TO WB-QIP-IND` em 7 casos de teste.

**Impacto:** Os 7 casos abaixo produzem pagamentos com taxas **standard** em vez das taxas
QIP reduzidas esperadas. O `BILL-RTC` também pode diferir do esperado.

| ID | Caso | Linha em GENDATA.cbl | Fiscal Year |
|----|------|----------------------|-------------|
| REQ-01a | TC05 | 464 | FY2021 RHC-QIP |
| REQ-01b | TC17 | 848 | FY2021 CHC-QIP |
| REQ-01c | TC18 | 873 | FY2021 IRC-QIP |
| REQ-01d | TC19 | 898 | FY2021 GIC-QIP |
| REQ-01e | TC20 | 932 | FY2021 SIA+QIP |
| REQ-01f | TC25 | 1099 | FY2014 RHC-QIP |
| REQ-01g | TC26 | 1124 | FY2015 RHC-QIP |

**Correção:** Substituir `MOVE "Y"` por `MOVE "1"` nas 7 linhas listadas.

---

### REQ-02 — Inicialização faltante antes do Provider 2

**Bug:** O bloco de Provider 2 (341235, New York NYC, CBSA 35614), que inicia aproximadamente
na linha 260 de `test/GENDATA.cbl`, **não possui `INITIALIZE`** antes dos seus MOVEs.
Assim herda os valores do Provider 1 (Charlotte, CBSA 16740) nos campos não sobrescritos.

**Campos críticos herdados do Provider 1:**
- `WS-P-FYE-DATE` = `20201001` (deve ser `20191001` para Provider 2, FY2019)
- `WS-P-MSA-DATA` = `"6740"`/`"6740"`/`"6740"` (deve ser padrão zero/space para NYC)
- `WS-P-CBSA-RECLASS-LOC` = `"     "` (OK, mas coincide por acidente)
- Diversas flags e campos numéricos de Seg2/Seg3

**Impacto:** TC06 (FY2020, CBSA 35614) recebe um registro de provider corrompido.
Comportamento imprevisível dependendo das validações internas do HOSDR210.

**Correção:** Adicionar bloco `INITIALIZE` (3 linhas: SEG1, SEG2, SEG3) imediatamente antes
da linha `*--- Provider 2: 341235 in CBSA 35614 (New York metro) ---*`.

---

### REQ-03 — Criar MSAFILE mínimo para wage index legado (pré-FY2006)

**Lacuna de infraestrutura:** 6 casos de teste com `FROM-DATE <= 20050930` (era MSA pré-CBSA)
produzem `RTC=30` (MSA lookup fail) porque o arquivo `run/MSAFILE` não existe.

`HOSOP210.cbl` trata MSAFILE como opcional — quando ausente, exibe warning e continua.
`HOSDR210` então falha na busca de wage index e seta `BILL-RTC = 30` (linha `084700`).

**Casos bloqueados:**

| Caso | FROM-DATE | Rev | RTC atual | RTC esperado |
|------|-----------|-----|-----------|--------------|
| TC09 | 20050930 | 0652 | 30 | 20 (CHC < 8 units FY2005) |
| TC29A | 20010315 | 0651 | 30 | 00 + taxas FY2001 |
| TC29B | 20010401 | 0651 | 30 | 00 + taxas FY2001-A |
| TC30 | 19990115 | 0651 | 30 | 00 + taxas FY1999 |
| TC31 | 19991115 | 0652 | 30 | 00 + taxas FY2000 CHC |
| TC32 | 20030601 | 0655 | 30 | 00 + taxas FY2003 IRC |

**Todos esses casos usam Provider 341234** cujos campos MSA no PROVFILE são:
- `WS-P-GEO-LOC-MSA = "6740"` (Charlotte NC, MSA code 4 dígitos)
- `WS-P-LUGAR = " "` (espaço)

**Formato do MSAFILE** (80 bytes por registro, LINE SEQUENTIAL):
```
Posição  Tamanho  Campo            Exemplo
1–4      4        MSA code          6740
5        1        LUGAR code        (space)
6        1        Separator         (space)
7–14     8        Effective date    19981001
15       1        Separator         (space)
16–21    6        Wage index raw    010000   ← PIC 9(02)V9(04), 1.0000
22–80    59       Filler spaces
```

**Conteúdo mínimo necessário:**
- 1 registro com MSA=`6740`, LUGAR=` `, EFFDTE=`19981001`, WI=`010000` (1.0000)
- O EFFDTE `19981001` é anterior a todos os `FROM-DATEs` dos casos acima,
  garantindo que `BILL-FROM-DATE NOT < MSA-EFFDTE` seja verdadeiro para todos.
- WI=1.0000 é a referência neutra usada em `plano-execucao-casos-teste.md`
  para cálculo de pagamentos esperados (vide TC29A: "BENE_WI = 1.0000").

> **Nota de precisão:** Para validar os valores de pagamento exatos de TC29A/TC29B,
> o WI deve ser 1.0000. As taxas esperadas (69.97/31.87 e 73.47/33.46) são as taxas
> base LS/NLS; com WI=1.0000, o cálculo é reto: `(LS×WI + NLS) × unidades`.

---

### REQ-04 — Verificação: WI=0 nos casos TC01–TC07 (não-bloqueador)

**Questão em aberto:** TC01–TC07 têm `MOVE ZEROS TO WB-PROV-WAGE` e
`MOVE ZEROS TO WB-BENE-WAGE`. O plano original exigia corrigir esses valores.

**Hipótese atual:** O HOSDR210 realiza o CBSA lookup a partir do CBSAFILE e
**sobrescreve** `BILL-PROV-WAGE-INDEX` / `BILL-BENE-WAGE-INDEX` antes de chamar
HOSPR210. Os zeros em `WB-PROV-WAGE`/`WB-BENE-WAGE` no BILLFILE seriam sobrescritos.

**Ação:** Executar TC01 com o ambiente corrigido pelas REQ-01/02/03 e verificar:
1. Se `BILL-PROV-WAGE-INDEX` na saída (RATEFILE) é diferente de zero.
2. Se o `PAY-TOTAL` corresponde ao esperado com WI real (CBSA 16740 no CBSA2021).

**Não requer mudança em GENDATA.cbl** até confirmação de que o comportamento está errado.

---

## Critério de Aceite Global

Após as correções REQ-01 + REQ-02 + REQ-03:

1. `grep "MOVE \"Y\" TO WB-QIP-IND" test/GENDATA.cbl` retorna 0 resultados.
2. Provider 2 (341235) tem bloco `INITIALIZE` antes de seus MOVEs.
3. `run/MSAFILE` existe, tem exatamente 1 registro e `HOSOP210` exibe `"MSA records loaded: 1"`.
4. Após rebuild + execução:
   - TC09 retorna `RTC=20` (não mais `RTC=30`).
   - TC29A, TC29B, TC30, TC31, TC32 retornam `RTC=00` (não mais `RTC=30`).
   - TC05, TC17, TC18, TC19, TC20, TC25, TC26 retornam o RTC esperado pelas taxas QIP.
