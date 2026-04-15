# Hospice PC Pricer — Módulo COBOL

Implementação original em COBOL do **Medicare/Medicaid Hospice PC Pricer** — motor de cálculo de pagamentos para reivindicações de cuidados paliativos (hospice) nos anos fiscais FY1998 a FY2021.

---

## Visão Geral

O sistema recebe um registro de fatura de 315 bytes (`BILL-315-DATA`), realiza lookup de provedor e índice de salário geográfico (wage index), aplica as regras de pagamento do ano fiscal correspondente e retorna os valores calculados.

```
HOSOP210 (CICS / wrapper batch)
    │
    └─► HOSDR210  (Driver)
            │  • Lookup de provedor (PROV-TABLE)
            │  • Lookup de wage index (MSA / CBSA)
            │
            └─► HOSPR210  (Pricer)
                    │  • Roteamento por ano fiscal (FY1998–FY2021)
                    │  • Cálculo de pagamento por código de receita
                    │  • Aplicação de wage index, QIP, SIA
                    │
                    └─► HOSPRATE  (Copybook — taxas FY2016+)
```

---

## Estrutura de Diretórios

```
hospice-pricer-cobol/
├── HOSDR210            # Fonte COBOL — Driver (997 linhas, IBM format)
├── HOSPR210            # Fonte COBOL — Pricer (6.555 linhas, IBM format)
├── HOSPRATE            # Copybook — Taxas de pagamento FY2016–FY2021
├── CBSA2021            # Dados de wage index CBSA (~7.478 registros)
├── TESTJCL             # JCL para execução batch no mainframe + relatório SAS
├── build/              # Artefatos compilados (gerado pelo build)
│   ├── HOSPR210.cbl    # Fonte preparado (sem numeração IBM)
│   ├── HOSDR210.cbl    # Fonte preparado (sem numeração IBM)
│   ├── HOSPR210.dll    # Módulo compilado
│   ├── HOSDR210.dll    # Módulo compilado
│   └── copy/
│       └── HOSPRATE.cpy
├── run/                # Diretório de execução (arquivos de dados gerados aqui)
│   ├── BILLFILE        # Registros de fatura (entrada — gerado por GENDATA)
│   ├── PROVFILE        # Dados de provedor (entrada — gerado por GENDATA)
│   ├── CBSAFILE        # Wage index CBSA (cópia de CBSA2021)
│   ├── MSAFILE         # Wage index MSA legado (pré-2006)
│   └── RATEFILE        # Saída do pricer (315 bytes/registro)
├── test/               # Ambiente de teste local (GnuCOBOL)
│   ├── HOSOP210.cbl    # Driver batch substituto do wrapper CICS
│   ├── GENDATA.cbl     # Gerador de dados de teste
│   ├── build-and-run.bat
│   └── README.md
├── tools/
│   └── gnucobol32/     # GnuCOBOL 3.2 (Windows x86-64)
└── docs/
    ├── regras-negocio-HOSPR210-PricerModule.md
    └── validacao-cobol-java.md
```

---

## Módulos

### HOSDR210 — Driver (997 linhas)

Orquestra o processamento do ciclo de faturamento:

- Recebe `BILL-315-DATA` (315 bytes) via `LINKAGE SECTION`
- Carrega tabelas em memória: `PROV-TABLE` (2.400 entradas), `MSA-WI-TABLE` (4.000), `CBSA-WI-TABLE` (9.000)
- Realiza lookup de provedor e wage index geográfico
- Delega o cálculo de pagamento chamando `HOSPR210`

### HOSPR210 — Pricer (6.555 linhas)

Motor central de cálculo de pagamentos:

- Roteia para o bloco de regras do ano fiscal correto com base em `BILL-FROM-DATE` (FY1998–FY2021)
- Valida entradas (códigos de receita, unidades, MSA/CBSA)
- Calcula pagamento por código de receita:

| Código | Tipo de Cuidado |
|--------|----------------|
| `0651` | RHC — Routine Home Care |
| `0652` | CHC — Continuous Home Care |
| `0655` | IRC — Inpatient Respite Care |
| `0656` | GIC — General Inpatient Care |

- Aplica wage index, redução QIP e complemento SIA (FY2016.1+)
- Retorna código de resultado (`BILL-RTC`)

### HOSPRATE — Copybook de Taxas (FY2016–FY2021)

Externaliza as constantes de taxas de pagamento para os anos fiscais mais recentes. As taxas de FY1998–FY2015 permanecem embutidas nos parágrafos do HOSPR210.

### CBSA2021 — Dados de Wage Index

Arquivo de referência com ~7.478 registros CBSA de wage index geográfico cobrindo FY2006–FY2021. Formato fixo posicional:

```
CBSA(5) + EffDate(8) + WageIndex(6) + Filler(6) + AreaName(variable)
```

---

## Fórmula de Cálculo

$$\text{Pagamento} = (\text{Taxa}_\text{LS} \times \text{WageIndex} + \text{Taxa}_\text{NLS}) \times \text{Unidades}$$

Onde:
- **LS** = Labor Share (parcela laboral, ajustada pelo wage index geográfico)
- **NLS** = Non-Labor Share (parcela não-laboral, fixa)
- **WageIndex** = índice CBSA ou MSA da localidade do beneficiário

Ajustes adicionais:
- **QIP** — redutor de qualidade (multiplica pela taxa `-Q`)
- **RHC 60 dias** — split entre taxa "low" (primeiros 60 dias) e "high" (após 60 dias) a partir de FY2016.1
- **SIA** — complemento de fim de vida baseado nas visitas RN/SW do beneficiário

---

## Códigos de Retorno (BILL-RTC)

| RTC | Significado |
|-----|-------------|
| `00` | Pagamento calculado com sucesso |
| `10` | Unidades inválidas |
| `20` | Código de receita inválido |
| `30` | MSA/CBSA inválido |
| `51` | Provedor não encontrado |
| `73` | RHC — taxa low aplicada |
| `74` | RHC — taxa low com SIA |
| `75` | RHC — taxa high aplicada |
| `77` | RHC — taxa high com SIA |

---

## Execução Local (GnuCOBOL — Windows)

### Pré-requisitos

GnuCOBOL 3.2 incluído em `tools/gnucobol32/`. Nenhuma instalação adicional é necessária.

### Build e Execução (tudo em um)

```cmd
hospice-pricer-cobol\test\build-and-run.bat
```

O script executa automaticamente:

1. Configura o ambiente GnuCOBOL
2. Prepara os fontes (remove numeração de linha IBM, corrige `COPY HOSPRATE`)
3. Compila `HOSPR210.dll`, `HOSDR210.dll`, `GENDATA.exe`, `HOSOP210.exe`
4. Gera dados de teste (`PROVFILE`, `BILLFILE`)
5. Copia `CBSA2021` → `run/CBSAFILE`
6. Executa o pricer
7. Exibe o resultado do `RATEFILE`

### Build Manual (bash/Git Bash)

```bash
cd hospice-pricer-cobol/

# Ambiente
export PATH="$PWD/tools/gnucobol32/bin:$PATH"
export COB_CONFIG_DIR="$PWD/tools/gnucobol32/config"
export COB_COPY_DIR="$PWD/tools/gnucobol32/copy"
export COB_LIBRARY_PATH="$PWD/build"

# Preparar fontes
sed 's/^[0-9]\{6\}/      /' HOSPRATE > build/copy/HOSPRATE.cpy
sed 's/^[0-9]\{6\}/      /' HOSPR210 > build/HOSPR210.cbl
sed 's/^[0-9]\{6\}/      /' HOSDR210 > build/HOSDR210.cbl
sed -i 's/COPY HOSPRATE\./COPY "HOSPRATE.cpy"./' build/HOSPR210.cbl

# Compilar módulos
cobc -fixed -std=ibm -m -I build/copy -o build/HOSPR210.dll build/HOSPR210.cbl
cobc -fixed -std=ibm -m -I build/copy -o build/HOSDR210.dll build/HOSDR210.cbl

# Compilar programas de teste
cobc -fixed -x -o build/GENDATA.exe test/GENDATA.cbl
cobc -fixed -x -o build/HOSOP210.exe test/HOSOP210.cbl
```

### Execução Manual

```bash
cd hospice-pricer-cobol/run/
export COB_LIBRARY_PATH="../build"
../build/GENDATA.exe        # gera PROVFILE + BILLFILE
cp ../CBSA2021 CBSAFILE     # wage index
../build/HOSOP210.exe       # executa o pricer
```

---

## Execução em Mainframe (z/OS)

Utilize o `TESTJCL` como base. O job executa:

1. **STEP02** — remove datasets de saída anteriores
2. **RUN** — executa `HOSOP210` (CICS wrapper) com region de 9M, passando `BILLFILE`, `PROVFILE`, `CBSAFILE` e `MSAFILE`
3. **LIST** — SAS `PROC PRINT` para formatação do relatório de saída

Arquivos de saída: `RATEFILE` (`RECFM=FB, LRECL=315`) e relatório SAS (`RECFM=VBA, LRECL=137`).

---

## Documentação

| Documento | Descrição |
|-----------|-----------|
| [docs/regras-negocio-HOSPR210-PricerModule.md](docs/regras-negocio-HOSPR210-PricerModule.md) | Regras de negócio detalhadas do HOSPR210 |
| [docs/validacao-cobol-java.md](docs/validacao-cobol-java.md) | Validação COBOL × Java — status, cobertura, itens pendentes |
| [test/README.md](test/README.md) | Guia do ambiente de teste local |
