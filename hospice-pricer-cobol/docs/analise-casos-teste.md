## Análise de Cobertura: GENDATA.cbl vs. plano-execucao-casos-teste.md

> **Status (2026-04-11):** Todos os 3 problemas críticos identificados abaixo foram **corrigidos** na feature FIX-GENDATA-001. Ver [.specs/features/fix-gendata-bugs/tasks.md](../.specs/features/fix-gendata-bugs/tasks.md) para detalhes de cada correção.
>
> - ✅ **QIP-IND** corrigido: `"Y"` → `"1"` em 7 casos (TC05, TC17–TC20, TC25–TC26)
> - ✅ **Provider 2 INITIALIZE** adicionado: 3 INITIALIZEs antes do bloco Provider 2
> - ✅ **MSAFILE criado**: `run/MSAFILE` com MSA 6740, WI=1.0000 para 6 casos pré-FY2006
> - ✅ **Bug MSA path** em HOSDR210: `PERFORM 1000-CALL` adicionado no parágrafo `0350-GET-MSA`

### Resumo Executivo

**40 bills gerados (TC01–TC36 + TC08B)**. A maioria das estruturas dos casos está correta, mas há **3 problemas críticos** e **2 lacunas de infraestrutura** que invalidam vários resultados esperados.

---

## Problema Crítico 1 — QIP-IND: `"Y"` vs `'1'` (impacta 7 casos)

**Bug confirmado.** HOSPR210 verifica exclusivamente `IF BILL-QIP-IND = '1'` (encontrado em >20 pontos do código). GENDATA usa `MOVE "Y" TO WB-QIP-IND`.

| Caso | Linha | Status real |
|---|---|---|
| TC05 | 464 | QIP ignorado → usa taxas standard FY2021 |
| TC17 | 848 | QIP-CHC ignorado → usa taxas CHC standard |
| TC18 | 873 | QIP-IRC ignorado |
| TC19 | 898 | QIP-GIC ignorado |
| TC20 | 932 | QIP-SIA ignorado |
| TC25 | 1099 | QIP-FY2014 ignorado |
| TC26 | 1124 | QIP-FY2015 ignorado |

Todos esses casos produzirão pagamentos com taxas **standard**, não com as taxas QIP reduzidas esperadas. O `BILL-RTC` também pode diferir do esperado.

---

## Problema Crítico 2 — Fase 1 (P1 Critical): WI = 0 não corrigido

O plano explicitamente exige como **primeira ação** corrigir `WB-PROV-WAGE` e `WB-BENE-WAGE` em TC01–TC07. **Todos os 7 casos originais ainda têm `MOVE ZEROS TO WB-PROV-WAGE/BENE-WAGE`**, e os novos casos TC08–TC36 também herdam ZEROS pelo `INITIALIZE`. Se o lookup do CBSAFILE realmente preenche esses campos no runtime, os valores de saída esperados (expressos com WI real) não serão reproduzíveis sem saber o WI exato em CBSAFILE para cada data.

---

## Problema: Provider 2 não inicializado (TC06)

Provider 2 (341235, NYC) **não tem `INITIALIZE`** antes de configurar seus campos — herda diretamente os valores do Provider 1 (Charlotte). Campos como `WS-P-FYE-DATE = 20201001`, MSA `"6740"`, e `WS-P-CBSA-RECLASS-LOC = "     "` vêm do Provider 1. Para TC06 (FY2020, CBSA 35614), os campos CBSA-GEO-LOC e CBSA-STD-AMT-LOC foram sobrescritos corretamente, mas outros campos herdados podem causar comportamento inesperado dependendo do que o driver lê.

---

## Lacuna de Infraestrutura — MSAFILE ausente

Os casos abaixo foram implementados estruturalmente, mas **produzirão RTC=30** (MSA lookup fail) em vez do resultado esperado sem um MSAFILE válido:

| Caso | FY | Resultado atual | Resultado esperado |
|---|---|---|---|
| TC09 | FY2005 | RTC=30 | RTC=20 |
| TC29A | FY2001 | RTC=30 | RTC=00, taxas 69.97/31.87 |
| TC29B | FY2001-A | RTC=30 | RTC=00, taxas 73.47/33.46 |
| TC30 | FY1999 | RTC=30 | taxas FY1999 |
| TC31 | FY2000 | RTC=30 | CHC 10h válido |
| TC32 | FY2003 | RTC=30 | IRC com WI do provider |

---

## Casos TC37–TC46 ausentes

O plano declara **38 novos casos (TC08–TC46)**, mas apenas 33 foram implementados (TC08–TC36 + TC08B). Não há descrição detalhada de TC37–TC46 no plano — são contados no total mas não especificados em nenhuma das 10 fases.

---

## Casos Corretamente Implementados (sem ressalvas funcionais)

| Fase | Casos | Status |
|---|---|---|
| P1 — Validação entrada | TC08, TC08B | ✅ Corretos |
| P1 — RHC 60 dias | TC10, TC11, TC12, TC13 | ✅ Corretos |
| P2 — CHC | TC14, TC15, TC16 | ✅ Corretos |
| P2 — SIA | TC21, TC22 | ✅ Corretos |
| P2 — Multi-código | TC23 | ✅ Correto |
| P3 — FY2014 sem QIP | TC24 | ✅ Correto |
| P3 — Fronteira FY2016 | TC27A, TC27B | ✅ Corretos |
| P3 — Fronteira FY2007 | TC28A, TC28B | ✅ Corretos |
| P3 — FYs pós-2006 | TC33, TC34, TC35, TC36 | ✅ Corretos |

---

## Ordem de Correção Recomendada

1. **Imediato:** substituir `MOVE "Y" TO WB-QIP-IND` por `MOVE "1" TO WB-QIP-IND` em TC05, TC17–TC20, TC25–TC26 (7 linhas)
2. **P1:** criar MSAFILE mínimo com MSA `6740` para habilitar TC09, TC29A, TC29B, TC30, TC31, TC32
3. **P1:** adicionar `INITIALIZE WS-PROV-SEG1/SEG2/SEG3` antes da configuração do Provider 2
4. **Discussão:** confirmar se a correção do WI=0 em TC01–TC07 é necessária ou se o driver já preenche corretamente via CBSAFILE durante o runtime