# Hospice Pricer - Ambiente de Teste Local

## Pré-requisitos

- GnuCOBOL 3.2 instalado em `tools/gnucobol32/`

---

## Como Executar

Execute a partir da raiz do projeto:

```cmd
test\build-and-run.bat
```

O script realiza automaticamente:
1. Configura o ambiente GnuCOBOL (`tools/gnucobol32`)
2. Prepara os fontes (strip de numeração IBM)
3. Compila `HOSPR210`, `HOSDR210`, `GENDATA` e `HOSOP210`
4. Gera os dados de teste (`PROVFILE`, `BILLFILE`)
5. Executa o pricer e exibe o resultado

---

## Estrutura do Ambiente de Teste

```
test/
├── HOSOP210.cbl      # Driver batch (substitui o wrapper CICS)
├── GENDATA.cbl       # Gerador de dados de teste
├── build-and-run.bat # Script tudo-em-um para Windows
└── README.md
```

## Arquitetura

```
                    ┌─────────────┐
                    │  HOSOP210   │  ← Driver batch (test/HOSOP210.cbl)
                    │  (novo)     │     Carrega arquivos, orquestra
                    └──────┬──────┘
                           │ CALL HOSDR210
                    ┌──────┴──────┐
                    │  HOSDR210   │  ← Driver original
                    │  (original) │     Lookup provider, wage index
                    └──────┬──────┘
                           │ CALL HOSPR210
                    ┌──────┴──────┐
                    │  HOSPR210   │  ← Pricer original
                    │  (original) │     Calcula pagamento por FY
                    └─────────────┘
```

## Casos de Teste Incluídos

O BILLFILE contém **45 registros** (TC01–TC41, com TC08B e TC27A/B como sub-casos).

### Fase 0 — Casos base FY2021 (TC01–TC07)

| ID | FY   | Rev Code | Tipo                                        | QIP | SIA | RTC esp. |
|----|------|----------|---------------------------------------------|-----|-----|----------|
| TC01 | 2021 | 0651 | RHC normal (CBSA 16740, 30d, ADM 106d atrás) | N | N | 73 |
| TC02 | 2021 | 0652 | CHC (10 units < 32 → taxa RHC 1 dia)         | N | N | 75 |
| TC03 | 2021 | 0655 | IRC (5 dias)                                  | N | N | 00 |
| TC04 | 2021 | 0656 | GIC (7 dias)                                  | N | N | 00 |
| TC05 | 2021 | 0651 | RHC com QIP reduction (20d, ADM 120d)        | Y | N | 73 |
| TC06 | 2020 | 0651 | RHC FY2020, CBSA 35614 (NYC metro)           | N | N | 73 |
| TC07 | 2021 | 0651 | RHC com SIA EOL add-on (EOL-D1=8, D2=10)    | N | Y | 77 |

### Fase 1 — Validações (TC08–TC09)

| ID    | FY   | Rev Code    | Tipo                                             | QIP | SIA | RTC esp.    |
|-------|------|-------------|--------------------------------------------------|-----|-----|-------------|
| TC08  | 2021 | 0651        | UNITS1 = 1.500 > 1.000 → RTC=10                 | N   | N   | 10          |
| TC08B | 2021 | 0651 + 0652 | UNITS2 = 1.500 > 1.000 → RTC=10                 | N   | N   | 10          |
| TC09  | 2005 | 0652        | CHC < 8h FY2005 → RTC=20 (req. MSAFILE; sem ele: 30) | N | N | 20/30 |

### Fase 3 — RHC 60-day split (TC10–TC13)

| ID   | FY   | Rev Code | Tipo                                                      | QIP | SIA | RTC esp. |
|------|------|----------|-----------------------------------------------------------|-----|-----|----------|
| TC10 | 2021 | 0651     | TODOS HIGH: PRIOR=5, UNITS=10 ≤ HIGH-LEFT=55              | N   | N   | 75       |
| TC11 | 2021 | 0651     | TODOS HIGH + NA add-on: PRIOR=15, UNITS=5 ≤ HIGH-LEFT=45 | N   | N   | 75       |
| TC12 | 2021 | 0651     | SPLIT HIGH+LOW: PRIOR=55, 5H + 5L                         | N   | N   | 75       |
| TC13 | 2021 | 0651     | SPLIT HIGH+LOW + SIA: EOL-D1=8, D2=12                    | N   | Y   | 77       |

### Fase 4 — CHC completo (TC14–TC16)

| ID   | FY   | Rev Code | Tipo                                       | QIP | SIA | RTC esp. |
|------|------|----------|--------------------------------------------|-----|-----|----------|
| TC14 | 2021 | 0652     | CHC ≥ 32 units (40u → fórmula CHC horária) | N   | N   | 00       |
| TC15 | 2021 | 0652     | CHC = 32 units (limite exato → fórmula CHC)| N   | N   | 00       |
| TC16 | 2021 | 0652     | CHC = 31 units (< limite → RHC 1 dia HIGH) | N   | N   | 75       |

### Fase 5 — QIP completo (TC17–TC20)

| ID   | FY   | Rev Code | Tipo                                  | QIP | SIA | RTC esp. |
|------|------|----------|---------------------------------------|-----|-----|----------|
| TC17 | 2021 | 0652     | QIP + CHC ≥ 32u (taxas CHC-Q)         | Y   | N   | 00       |
| TC18 | 2021 | 0655     | QIP + IRC (5 dias)                    | Y   | N   | 00       |
| TC19 | 2021 | 0656     | QIP + GIC (3 dias)                    | Y   | N   | 00       |
| TC20 | 2021 | 0651     | QIP + SIA (EOL-D1=8, D2=12) ALL HIGH  | Y   | Y   | 77       |

### Fase 6 — SIA completo (TC21–TC22)

| ID   | FY   | Rev Code | Tipo                                                 | QIP | SIA | RTC esp. |
|------|------|----------|------------------------------------------------------|-----|-----|----------|
| TC21 | 2021 | 0651     | SIA cap 16u: D1=20 (cap 4h), D2=16 (=cap), D3=15   | N   | Y   | 77       |
| TC22 | 2021 | 0651     | SIA 7 dias × 8u (2h/dia), 7 dias RHC ALL HIGH        | N   | Y   | 77       |

### Fase 7 — Multi-code (TC23)

| ID   | FY   | Rev Code              | Tipo                                                    | QIP | SIA | RTC esp. |
|------|------|-----------------------|---------------------------------------------------------|-----|-----|----------|
| TC23 | 2021 | 0651+0652+0655+0656   | Todos 4 códigos; ADM > 60d → RHC ALL LOW (30d+CHC 40u+IRC 5d+GIC 3d) | N | N | 73 |

### Fase 8 — Taxas fixas QIP FY2014/2015 (TC24–TC26)

| ID   | FY   | Rev Code | Tipo                                            | QIP | SIA | RTC esp. |
|------|------|----------|-------------------------------------------------|-----|-----|----------|
| TC24 | 2014 | 0651     | RHC sem QIP (LS=107,23; NLS=48,83)             | N   | N   | 75       |
| TC25 | 2014 | 0651     | RHC com QIP (LS=105,12; NLS=47,87)             | Y   | N   | 75       |
| TC26 | 2015 | 0651     | RHC com QIP FY2015 (LS=107,34; NLS=48,88)      | Y   | N   | 75       |

### Fase 9 — Limites de FY e formatos CHC (TC27–TC29)

| ID    | FY      | Rev Code | Tipo                                                       | QIP | SIA | RTC esp. |
|-------|---------|----------|------------------------------------------------------------|-----|-----|----------|
| TC27A | 2016    | 0651     | FY2016 antigo (FROM ≤ 20151231): taxa única, sem split 60d | N   | N   | 00       |
| TC27B | 2016.1  | 0651     | FY2016.1 (FROM ≥ 20160101): split 60d ativo, ALL HIGH     | N   | N   | 75       |
| TC28A | 2007    | 0652     | CHC formato horas (FROM=20061201): 10h → fórmula CHC       | N   | N   | 00       |
| TC28B | 2007.1  | 0652     | CHC formato 15-min (FROM=20070101): 10×15min=2,5h → RHC   | N   | N   | 75       |
| TC29A | 2001    | 0651     | RHC via MSA (LS=69,97; NLS=31,87; req. MSAFILE)           | N   | N   | 75/30    |
| TC29B | 2001-A  | 0651     | RHC via MSA eff 20010401 (LS=73,47; NLS=33,46; req. MSAFILE) | N | N | 75/30 |

### Fase 10 — Anos fiscais representativos (TC30–TC36)

| ID   | FY        | Rev Code | Tipo                                                      | QIP | SIA | RTC esp. | MSAFILE |
|------|-----------|----------|-----------------------------------------------------------|-----|-----|----------|---------|
| TC30 | 1998/1999 | 0651     | Taxas iniciais FY99                                       | N   | N   | 75/30    | Req.    |
| TC31 | 2000      | 0652     | CHC em horas (10h ≥ 8h mín)                              | N   | N   | 00/30    | Req.    |
| TC32 | 2003      | 0655     | IRC com WI do provider via MSA                            | N   | N   | 00/30    | Req.    |
| TC33 | 2008      | 0651     | Pós-transição 15-min, pré-QIP, via CBSA                   | N   | N   | 75       | N       |
| TC34 | 2011      | 0656     | GIC sem QIP                                               | N   | N   | 00       | N       |
| TC35 | 2013      | 0651     | Último FY sem QIP                                         | N   | N   | 75       | N       |
| TC36 | 2016      | 0651     | Primeiro FY com HOSPRATE, taxa RHC única (CBSA 10180)     | N   | N   | 00       | N       |

### Fase 11 — Cobertura de branches CHC FY2010 (TC37–TC41)

| ID       | FY   | Rev Code | Tipo                                              | Branch | RTC esp. |
|----------|------|----------|---------------------------------------------------|--------|----------|
| TC37-10Z | 2010 | 0652     | UNITS2=0 → sem pagamento REV2                     | B      | 00       |
| TC38-10L | 2010 | 0652     | UNITS2=16 < 32 → taxa dia RHC ≈ 144,28            | C      | 00       |
| TC39-10B | 2010 | 0652     | UNITS2=31 (limite) → ainda taxa dia RHC (Branch C)| C      | 00       |
| TC40-10H | 2010 | 0652     | UNITS2=32 → CHC horária 8h ≈ (∑rates/24)×8        | D      | 00       |
| TC41-10C | 2010 | 0652     | UNITS2=40 > 32 → CHC horária 10h ≈ 350,60         | D      | 00       |

## Saída Esperada

O programa exibe para cada bill:
- **RTC 00**: Pagamento calculado com sucesso (CHC, IRC, GIC, RHC pré-2016)
- **RTC 10**: Unidades inválidas (> 1.000)
- **RTC 20**: CHC < 8 horas (FY pré-2006)
- **RTC 30**: MSA não encontrado no MSAFILE
- **RTC 73**: Low RHC rate aplicada (ALL LOW)
- **RTC 74**: Low RHC com SIA add-on
- **RTC 75**: High RHC rate aplicada (ALL HIGH ou split HIGH+LOW)
- **RTC 77**: High RHC com SIA add-on
- **RTC 10–51**: Outros erros de validação

Os resultados são escritos no arquivo `RATEFILE` (315 bytes por registro).

> **Nota sobre MSAFILE**: Os casos TC09, TC29A/B, TC30–TC32 usam o caminho MSA
> (FROM ≤ 20050930). Sem o arquivo MSAFILE, esses casos retornam RTC=30 em vez
> do RTC calculado indicado na tabela.

## Adicionando Novos Testes

Edite `test/GENDATA.cbl` para adicionar novos registros de bill com diferentes
combinações de:
- Revenue codes (0651, 0652, 0655, 0656)
- Datas (diferentes fiscal years)
- QIP indicator (Y/N/space)
- SIA add-on units (WB-EOL-DAY1..7-UNITS, WB-NA-DAY1..2-UNITS)
- Providers e CBSAs diferentes
- Número de unidades (para casos de branch coverage CHC)

## Limitações

- **Sem CICS**: O ambiente batch bypassa o CICS completamente
- **Sem MSAFILE**: Claims pré-2006 (que usam MSA ao invés de CBSA) precisam
  de um arquivo MSA que não está incluído. Casos afetados: TC09, TC29A/B, TC30–TC32
- **Formato texto**: Os arquivos usam LINE SEQUENTIAL ao invés de FB
  (fixed-block) do mainframe; pode haver diferenças sutis de padding
