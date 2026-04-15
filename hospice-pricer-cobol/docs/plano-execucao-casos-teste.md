# Plano de Execução — Casos de Teste Faltantes

> **Status (2026-04-11):** Os pré-requisitos deste plano foram atendidos pela feature FIX-GENDATA-001:
> - ✅ QIP-IND corrigido (`"Y"` → `"1"`) em 7 casos
> - ✅ MSAFILE criado para casos pré-FY2006
> - ✅ Provider 2 inicializado corretamente
> - ✅ MSA path em HOSDR210 agora invoca o pricer
>
> Os 40 casos existentes (TC01–TC36 + TC08B) estão prontos para validação de saída.
> A implementação dos casos TC37–TC46 permanece pendente (não especificados no plano).

> **Referência:** `docs/regras-negocio-HOSPR210-PricerModule.md`  
> **Alvo de implementação:** `test/GENDATA.cbl`  
> **Casos existentes:** TC01–TC07  
> **Casos a criar:** TC08–TC46 (38 novos casos)

---

## Sumário de Lacunas

| Área | Casos em falta | Prioridade |
|---|---|:-:|
| Wage index com valores reais (≠ 0) | Crítico — afeta todos os cálculos atuais | P1 |
| Validações de entrada (RTC 10, 20) | 2 | P1 |
| Cenários RHC 60 dias — ALL HIGH e SPLIT | 4 | P1 |
| RTCs de sucesso ausentes (75, 77) | derivados do item acima | P1 |
| CHC com ≥ 32 unidades (fórmula real) | 2 | P2 |
| QIP para CHC, IRC, GIC | 3 | P2 |
| QIP com SIA | 1 | P2 |
| SIA — cap 16 unidades, 7 dias, QIP | 3 | P2 |
| Bill com múltiplos códigos de receita | 1 | P2 |
| QIP em FY2014/2015 (taxas hard-coded) | 2 | P3 |
| Fronteiras de ano fiscal (FY2007.1, FY2016.1, FY2001-A) | 3 | P3 |
| Anos fiscais representativos não cobertos | 7 | P3 |

---

## Fase 1 — Correção Crítica: Wage Index Real

**Problema:** Todos os 7 casos existentes têm `WB-PROV-WAGE = ZEROS` e  
`WB-BENE-WAGE = ZEROS`. A parcela laboral `(LS × WageIndex)` resulta sempre zero,  
tornando os pagamentos calculados financeiramente incorretos.

**Solução:** Nos casos existentes e em todos os novos, usar wage index da tabela CBSA2021.

### CBSA de referência para os testes

| CBSA | Área | Wage Index Aproximado | Uso |
|---|---|---|---|
| `16740` | Charlotte, NC | ~1.0000 (referência neutra) | Provedor e beneficiário |
| `35620` | New York, NY | ~1.3000 (alto) | Beneficiário em região cara |
| `99999` ou `00000` | Rural / não-CBSA | ~0.7000–0.8000 (baixo) | Testar WI < 1 |

> **Nota de implementação:** O HOSDR210 realiza o lookup do wage index no CBSAFILE  
> e preenche `BILL-PROV-WAGE-INDEX` e `BILL-BENE-WAGE-INDEX` antes de chamar o  
> pricer. Para fazer o lookup funcionar, o CBSA informado no bill deve existir no  
> arquivo CBSAFILE (= `run/CBSAFILE`, cópia de `CBSA2021`). Usar os CBSAs que  
> já constam nos providers criados no GENDATA (`16740` e `35620`).

### Ação requerida nos casos TC01–TC07

Revisar todos os casos existentes substituindo `CBSA 16740` por um CBSA com  
wage index conhecido e não-zero para validar os valores de saída esperados.  
Alternativamente, criar versões paralelas (TC01b, etc.) com WI real.

---

## Fase 2 — Validações de Entrada (Prioridade P1)

### TC08 — RTC=10: Unidades acima de 1.000

**Objetivo:** Verificar que o pricer retorna RTC=10 e pagamento=zero quando  
qualquer `BILL-UNITS` excede 1.000.

```
FY:            2021
FROM-DATE:     20210115
REV1/UNITS1:   0651 / 1500   ← > 1000 → dispara RTC=10
REV2/UNITS2:   (vazio)
QIP:           ' '
SIA:           zeros
Resultado esperado:
  BILL-RTC        = '10'
  BILL-PAY-AMT-TOTAL = 0
```

**Variante TC08b:** Testar com UNITS2, UNITS3 ou UNITS4 acima de 1.000 para  
confirmar que a checagem cobre todos os 4 grupos de linha de item.

---

### TC09 — RTC=20: 0652 com menos de 8 unidades em FY1998–FY2006

**Objetivo:** Verificar que o pricer retorna RTC=20 ao receber código 0652  
com menos de 8 horas em qualquer FY do período 1998–2006.

```
FY:            2005
FROM-DATE:     20050115   ← > 20040930, período FY2005
ADM-DATE:      20050115
PROV-CBSA:     provider com CBSA pré-2006 (MSA legado)
REV1/UNITS1:   0652 / 5   ← < 8 horas → dispara RTC=20
QIP:           ' '
SIA:           zeros
Resultado esperado:
  BILL-RTC        = '20'
  BILL-PAY-AMT-TOTAL = 0
```

> **Nota:** Este caso exige MSAFILE (wage index MSA legado), que atualmente  
> não está incluso no ambiente. Será necessário criar um MSAFILE mínimo com  
> ao menos 1 registro MSA compatível com o provider utilizado.

---

## Fase 3 — Lógica RHC 60 Dias: Cenários Faltantes (Prioridade P1)

### TC10 — Cenário B: ALL HIGH (todos os dias dentro dos 60 primeiros)

**Objetivo:** Exercitar o caminho onde `BILL-UNITS1 <= HIGH-RATE-DAYS-LEFT`,  
resultando em pagamento 100% na taxa alta. Deve retornar RTC=75.

```
FY:            2021
FROM-DATE:     20210115
ADM-DATE:      20210110   ← 5 dias desde admissão
NA-ADD-ON:     00          ← sem dias prévios
REV1/UNITS1:   0651 / 10  ← 10 dias faturados
                           PRIOR-SVC-DAYS = 5
                           HIGH-RATE-DAYS-LEFT = 60-5 = 55
                           UNITS1 (10) <= 55 → ALL HIGH
QIP:           ' '
SIA:           zeros
Resultado esperado:
  BILL-HIGH-RHC-DAYS = 10
  BILL-LOW-RHC-DAYS  = 0
  BILL-RTC           = '75'
  WRK-PAY-RATE1 = ((136.90 × BENE_WI) + 62.35) × 10
```

---

### TC11 — Cenário B com dias prévios NA-ADD-ON

**Objetivo:** Verificar que dias de benefício prévios (`WB-NA-DAY1-UNITS`)  
são somados corretamente ao cálculo de `PRIOR-SVC-DAYS`.

```
FY:            2021
FROM-DATE:     20210115
ADM-DATE:      20210110   ← 5 dias desde admissão
NA-ADD-ON-DAY1: 10        ← 10 dias prévios de outro período
                           PRIOR-SVC-DAYS = 5 + 10 = 15
                           HIGH-RATE-DAYS-LEFT = 60-15 = 45
REV1/UNITS1:   0651 / 5
                           UNITS1 (5) <= 45 → ALL HIGH
Resultado esperado:
  BILL-HIGH-RHC-DAYS = 5
  BILL-LOW-RHC-DAYS  = 0
  BILL-RTC           = '75'
```

---

### TC12 — Cenário C: SPLIT HIGH + LOW (dias cruzam o limite de 60)

**Objetivo:** Exercitar o caminho onde parte dos dias vai para HIGH e parte  
para LOW. Verifica a divisão e soma dos dois segmentos. Deve retornar RTC=75.

```
FY:            2021
FROM-DATE:     20210315
ADM-DATE:      20210119   ← 55 dias desde admissão
NA-ADD-ON:     00
REV1/UNITS1:   0651 / 10  ← cenário da doc seção 11.4
                           PRIOR-SVC-DAYS = 55
                           HIGH-RATE-DAYS-LEFT = 5
                           HR-BILL-UNITS1 = 5 (taxa ALTA)
                           LR-BILL-UNITS1 = 5 (taxa BAIXA)
QIP:           ' '
SIA:           zeros
Resultado esperado (BENE_WI = 1.0000):
  BILL-HIGH-RHC-DAYS = 5
  BILL-LOW-RHC-DAYS  = 5
  BILL-RTC           = '75'
  WRK-PAY-RATE1 = (HIGH × 5) + (LOW × 5)
                = ((136.90 + 62.35) × 5) + ((108.21 + 49.28) × 5)
                = 997.25 + 786.45 = $1.783,70
```

---

### TC13 — Cenário C com SIA: deve retornar RTC=77

**Objetivo:** Verificar que a combinação SPLIT + SIA gera RTC=77.

```
FY:            2021
FROM-DATE:     20210315
ADM-DATE:      20210119   ← mesmo cenário TC12
REV1/UNITS1:   0651 / 10
EOL-DAY1-UNITS: 08        ← SIA presente
EOL-DAY2-UNITS: 12
EOL-DAY3-7:    00
QIP:           ' '
Resultado esperado:
  BILL-RTC = '77'         ← HIGH presente + SIA presente
```

---

## Fase 4 — CHC Completo (Prioridade P2)

### TC14 — CHC com ≥ 32 unidades (fórmula horária real)

**Objetivo:** TC02 usa apenas 10 unidades (< 32), disparando o caminho RHC  
substituto. Este caso cobre a fórmula `(CHC_rate/24) × (UNITS/4)`.

```
FY:            2021
FROM-DATE:     20210220
ADM-DATE:      20210215
REV1/UNITS1:   0652 / 40  ← 40 unidades (10 horas), >= 32
QIP:           ' '
SIA:           zeros
Resultado esperado (BENE_WI = 1.0000):
  WRK-PAY-RATE1 = (((984.21 + 448.20) / 24) × (40 / 4))
                = (1432.41 / 24) × 10
                = 59.68 × 10 = $596,75 aprox.
  BILL-RTC = '00'
```

---

### TC15 — CHC com exatamente 32 unidades (boundary)

**Objetivo:** Verificar o comportamento no valor exato de fronteira.

```
FY:            2021
REV1/UNITS1:   0652 / 32  ← boundary: deve usar fórmula CHC (>= 32)
Resultado esperado:
  Fórmula CHC (não RHC)
  BILL-RTC = '00'
```

---

### TC16 — CHC com 31 unidades (abaixo do threshold)

**Objetivo:** Verificar que 31 unidades usa taxa RHC e não CHC.

```
FY:            2021
REV1/UNITS1:   0652 / 31  ← < 32: deve pagar na taxa RHC (1 dia)
Resultado esperado:
  Fórmula RHC aplicada (1 dia)
  BILL-RTC = '00' ou '73'/'75' conforme posição no período 60d
```

---

## Fase 5 — QIP Completo (Prioridade P2)

TC05 cobre apenas RHC+QIP. Os demais tipos de cuidado não têm cobertura QIP.

### TC17 — QIP com CHC (0652 >= 32 unidades)

```
FY:            2021
QIP-IND:       '1'
REV1/UNITS1:   0652 / 40
Resultado esperado:
  Fórmula CHC com taxas -Q (964.99 / 439.45)
```

### TC18 — QIP com IRC (0655)

```
FY:            2021
QIP-IND:       '1'
REV1/UNITS1:   0655 / 5
Resultado esperado:
  ((244.71 × PROV_WI) + 207.37) × 5
```

### TC19 — QIP com GIC (0656)

```
FY:            2021
QIP-IND:       '1'
REV1/UNITS1:   0656 / 3
Resultado esperado:
  ((656.25 × PROV_WI) + 368.98) × 3
```

### TC20 — QIP com SIA

**Objetivo:** Verificar que a taxa SIA horária também usa as taxas CHC-Q  
quando QIP=1.

```
FY:            2021
QIP-IND:       '1'
REV1/UNITS1:   0651 / 5   ← ALL HIGH (ADM próxima)
EOL-DAY1-UNITS: 08
EOL-DAY2-UNITS: 12
Resultado esperado:
  SIA-PYMT-RATE = ((964.99 × BENE_WI) + 439.45) / 24   ← taxas -Q
  BILL-RTC = '77'
```

---

## Fase 6 — SIA Completo (Prioridade P2)

### TC21 — SIA com cap de 16 unidades (4 horas) acionado

**Objetivo:** TC07 usa no máximo 10 unidades por dia. Este caso verifica que  
16+ unidades são capadas em 4 horas.

```
FY:            2021
EOL-DAY1-UNITS: 20        ← > 16: deve ser capado em 4 horas
EOL-DAY2-UNITS: 16        ← = 16: boundary do cap
EOL-DAY3-UNITS: 15        ← < 16: sem cap (3,75 horas)
Resultado esperado:
  EOL-HOURS1 = 4          (cap acionado)
  EOL-HOURS2 = 4          (boundary exato)
  EOL-HOURS3 = 15/4 = 3,75
```

### TC22 — SIA com todos os 7 dias preenchidos

**Objetivo:** Verificar que o cálculo dos 7 dias EOL funciona corretamente  
para o máximo de dias possível.

```
FY:            2021
REV1/UNITS1:   0651 / 7
EOL-DAY1 a DAY7-UNITS: 08 (2 horas cada)
Resultado esperado:
  SIA-PAY-AMT-TOTAL = 7 × 2 × SIA-PYMT-RATE
  BILL-RTC = '73' ou '75'/'77' conforme posição 60d
```

---

## Fase 7 — Bill com Múltiplos Códigos de Receita (Prioridade P2)

### TC23 — Bill com todos os 4 códigos de receita simultaneamente

**Objetivo:** Verificar que `BILL-PAY-AMT-TOTAL` é a soma correta de todos  
os 4 grupos de linha de item. Replica a Simulação 14.1 da documentação.

```
FY:            2021
FROM-DATE:     20210115
ADM-DATE:      20201001   ← > 60 dias: ALL LOW para RHC
QIP:           ' '
REV1/UNITS1:   0651 / 30
REV2/UNITS2:   0652 / 40  ← > 32 unidades: fórmula CHC
REV3/UNITS3:   0655 / 5
REV4/UNITS4:   0656 / 3
SIA:           zeros
Resultado esperado:
  BILL-PAY-AMT-TOTAL = PAY1(RHC) + PAY2(CHC) + PAY3(IRC) + PAY4(GIC)
  BILL-RTC = '73'         ← ALL LOW, sem SIA
```

---

## Fase 8 — Anos Fiscais Representativos com QIP Hard-Coded (Prioridade P3)

### TC24 — FY2014 sem QIP (primeiro FY com QIP disponível)

```
FROM-DATE:     20140115   ← > 20130930, FY2014
REV1/UNITS1:   0651 / 10
QIP:           ' '
Resultado esperado:
  Taxas FY2014 standard: LS=107.23, NLS=48.83
```

### TC25 — FY2014 com QIP

```
FROM-DATE:     20140115
REV1/UNITS1:   0651 / 10
QIP-IND:       '1'
Resultado esperado:
  Taxas FY2014 QIP: LS=105.12, NLS=47.87
  Diferença vs TC24 ≈ -2%
```

### TC26 — FY2015 com QIP

```
FROM-DATE:     20150115   ← > 20140930, FY2015
REV1/UNITS1:   0651 / 10
QIP-IND:       '1'
Resultado esperado:
  Taxas FY2015 QIP: LS=107.34, NLS=48.88
```

---

## Fase 9 — Fronteiras Críticas de Ano Fiscal (Prioridade P3)

### TC27 — Fronteira FY2016 → FY2016.1 (31/Dez/2015 vs 1/Jan/2016)

**Objetivo:** Verificar que datas em 20151231 usam FY2016 (taxa RHC única)  
e 20160101 usam FY2016.1 (taxa alta/baixa + SIA).

```
TC27a — último dia FY2016:
  FROM-DATE: 20151231   ← <= 20151231: deve ir para 2016-PROCESS-DATA
  REV1/UNITS1: 0651 / 10
  Resultado esperado: taxa RHC única (111.23/50.66), sem split, RTC='00'

TC27b — primeiro dia FY2016.1:
  FROM-DATE: 20160101   ← > 20151231: vai para 2016-V161-PROCESS-DATA
  ADM-DATE:  20160101
  REV1/UNITS1: 0651 / 5
  Resultado esperado: lógica 60 dias ativa, RHC split disponível
```

---

### TC28 — Fronteira FY2007 → FY2007.1 (unidade 0652 muda de horas para 15min)

**Objetivo:** Verificar que 0652 no FY2007 (antes de Jan/2007) usa unidades  
em horas e que FY2007.1 (a partir de Jan/2007) usa incrementos de 15 min.

```
TC28a — FY2007 (até 31/Dez/2006):
  FROM-DATE: 20061201   ← > 20060930, <= 20061231: FY2007
  REV1/UNITS1: 0652 / 10  ← 10 horas (unidade = hora)
  Resultado esperado: fórmula (CHC_rate_diária / 24) × horas, mínimo 8h OK

TC28b — FY2007.1 (a partir de 1/Jan/2007):
  FROM-DATE: 20070101   ← > 20061231: FY2007.1
  REV1/UNITS1: 0652 / 10  ← 10 incrementos de 15 min = 2,5 horas (< 32)
  Resultado esperado: pagamento na taxa RHC (< 32 unidades), RTC='00'
```

---

### TC29 — Fronteira FY2001 → FY2001-A (1/Abr/2001)

```
TC29a — FY2001 (até 31/Mar/2001):
  FROM-DATE: 20010315   ← > 20000930, <= 20010331: FY2001
  REV1/UNITS1: 0651 / 5
  Resultado esperado: taxas FY2001 (LS=69.97, NLS=31.87)

TC29b — FY2001-A (a partir de 1/Abr/2001):
  FROM-DATE: 20010401   ← > 20010331: FY2001-A
  REV1/UNITS1: 0651 / 5
  Resultado esperado: taxas FY2001-A (LS=73.47, NLS=33.46) — ~5% maior
```

---

## Fase 10 — Anos Fiscais Representativos (Prioridade P3)

Um caso por grupo de período, cobrindo as variações de lógica mais importantes.

| TC | FY alvo | FROM-DATE | Rev | Objetivo |
|---|---|---|---|---|
| TC30 | FY1998 | 19990115 | 0651 | Taxas iniciais, fórmula base |
| TC31 | FY1999 | 19991115 | 0652 | CHC em horas (mínimo 8h OK) |
| TC32 | FY2003 | 20030601 | 0655 | IRC com WI do provedor |
| TC33 | FY2008 | 20080115 | 0651 | Pós-transição 15min, pré-QIP |
| TC34 | FY2011 | 20111001 | 0656 | GIC mid-range sem QIP |
| TC35 | FY2013 | 20131015 | 0651 | Último FY sem QIP |
| TC36 | FY2016 | 20151015 | 0651 | Primeiro FY com HOSPRATE, taxa única |

> **Nota:** Todos estes casos exigem que o CBSAFILE contenha registros com  
> a data efetiva compatível com o FY alvo. O arquivo `CBSA2021` inclui  
> registros a partir de FY2006. Para FY1998–FY2005, será necessário criar  
> um MSAFILE mínimo com entradas MSA.

---

## Infraestrutura de Teste Necessária

### Provedor adicional para testes legados (MSA pré-2006)

Adicionar ao `GENDATA.cbl` um terceiro provider com:
- CBSA/MSA compatível com períodos pré-FY2006
- MSA Code preenchido em `WS-P-GEO-LOC-MSA`

### MSAFILE mínimo

Criar em `test/` um arquivo de wage index MSA com pelo menos 2–3 registros  
cobrindo MSAs usados pelos providers de teste, no formato esperado pelo  
HOSDR210 (5 bytes MSA-LUGAR + 1 espaço + 8 data + 1 espaço + 6 wage index).

### Provider para testes de alta variação de WI

Adicionar um provider com CBSA de New York (`35620`) já configurado  
corretamente no `WS-PROV-SEG2` para uso em TCs que validam WI > 1.0.

---

## Ordem de Implementação Recomendada

```
Prioridade 1 (P1) — corrição e fundação:
  1. Corrigir WI=0 em TC01–TC07 (usar CBSAs com WI real)
  2. TC08 — RTC=10 (unidades > 1000)
  3. TC10 — ALL HIGH sem SIA (RTC=75)
  4. TC12 — SPLIT HIGH+LOW sem SIA (RTC=75)
  5. TC13 — SPLIT com SIA (RTC=77)

Prioridade 2 (P2) — cobertura de fórmulas:
  6. TC14 — CHC >= 32 unidades
  7. TC15 e TC16 — CHC boundary (32 e 31 unidades)
  8. TC17–TC19 — QIP para CHC, IRC, GIC
  9. TC20 — QIP com SIA
  10. TC21 — SIA com cap
  11. TC22 — SIA todos os 7 dias
  12. TC23 — bill multi-código

Prioridade 3 (P3) — cobertura de FYs históricos:
  13. TC24–TC26 — FY2014/2015 com QIP hard-coded
  14. TC27–TC29 — fronteiras críticas de FY
  15. TC30–TC36 — FYs representativos
  16. TC09 — RTC=20 (requer MSAFILE)
  17. TC11 — dias prévios NA-ADD-ON
```

---

## Critérios de Validação

Para cada caso de teste, após execução, verificar no `RATEFILE`:

1. **`BILL-RTC`** — código de retorno esperado
2. **`BILL-PAY-AMT-TOTAL`** — total calculado vs valor esperado (tolerância ±$0,01 por arredondamento COBOL `ROUNDED`)
3. **`BILL-HIGH-RHC-DAYS` / `BILL-LOW-RHC-DAYS`** — para casos FY2016.1+
4. **`BILL-EOL-ADD-ON-DAYn-PAY`** — para casos com SIA
5. **`BILL-PAY-AMT1`–`BILL-PAY-AMT4`** — pagamentos individuais por grupo

Os valores esperados estão documentados nas simulações das seções 14.1, 14.2  
e 14.3 do arquivo `regras-negocio-HOSPR210-PricerModule.md`.

---

> **Total de novos casos previstos:** 38 (TC08–TC46, incluindo variantes a/b)  
> **Implementação alvo:** `test/GENDATA.cbl` — adicionar novos blocos à  
> `2000-CREATE-BILL-FILE` seguindo o padrão dos casos TC01–TC07 existentes.
