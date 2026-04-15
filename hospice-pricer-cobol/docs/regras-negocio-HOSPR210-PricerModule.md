# Regras de Negócio — HOSPR210 (Hospice PC Pricer Module)

> **Programa:** HOSPR210 — Motor de Cálculo de Pagamentos Hospice  
> **Linguagem:** COBOL (IBM-370)  
> **Linhas de código:** 6.555  
> **Cobertura fiscal:** FY1998 a FY2021  
> **Chamado por:** HOSDR210 (Driver) via `CALL 'HOSPR210' USING BILL-315-DATA`  
> **Copybook externo:** HOSPRATE (taxas de pagamento FY2016+)

---

## Sumário

1. [Visão Geral do Fluxo de Processamento](#1-visão-geral-do-fluxo-de-processamento)
2. [Estrutura do Registro de Entrada/Saída (BILL-315-DATA)](#2-estrutura-do-registro-de-entradasaída-bill-315-data)
3. [Inicialização de Variáveis](#3-inicialização-de-variáveis)
4. [Roteamento por Ano Fiscal (FY Routing)](#4-roteamento-por-ano-fiscal-fy-routing)
5. [Validações de Entrada](#5-validações-de-entrada)
6. [Códigos de Retorno (BILL-RTC)](#6-códigos-de-retorno-bill-rtc)
7. [Fórmula Geral de Cálculo de Pagamento](#7-fórmula-geral-de-cálculo-de-pagamento)
8. [Tipos de Cuidado e Códigos de Receita](#8-tipos-de-cuidado-e-códigos-de-receita)
9. [Índice de Salário (Wage Index)](#9-índice-de-salário-wage-index)
10. [Indicador QIP — Programa de Melhoria de Qualidade](#10-indicador-qip--programa-de-melhoria-de-qualidade)
11. [Lógica RHC — Período de Benefício de 60 Dias (FY2016.1+)](#11-lógica-rhc--período-de-benefício-de-60-dias-fy20161)
12. [Service Intensity Add-On (SIA) — Fim de Vida (FY2016.1+)](#12-service-intensity-add-on-sia--fim-de-vida-fy20161)
13. [Evolução das Taxas por Ano Fiscal](#13-evolução-das-taxas-por-ano-fiscal)
14. [Simulações Completas de Cálculo](#14-simulações-completas-de-cálculo)
15. [Linha do Tempo de Mudanças Regulatórias](#15-linha-do-tempo-de-mudanças-regulatórias)

---

## 1. Visão Geral do Fluxo de Processamento

O HOSPR210 é o **motor central de precificação** do sistema Hospice. Recebe um registro de 315 bytes (BILL-315-DATA) contendo dados da fatura e retorna os valores de pagamento calculados.

```
┌──────────────┐     CALL HOSPR210        ┌──────────────┐
│  HOSDR210    │  ───────────────────────► │  HOSPR210    │
│  (Driver)    │  USING BILL-315-DATA      │  (Pricer)    │
│              │                           │              │
│ • Busca      │  ◄───────────────────────  │ • Valida     │
│   provedor   │  Retorna valores em        │ • Calcula    │
│ • Busca      │  BILL-315-DATA             │ • Aplica     │
│   wage index │                           │   wage index │
└──────────────┘                           └──────────────┘
```

**Sequência interna do HOSPR210:**

1. **Inicializa** variáveis de saída (1000-INITIALIZE)
2. **Roteia** para o parágrafo do ano fiscal correto com base em `BILL-FROM-DATE`
3. **Valida** unidades de entrada
4. **Calcula** pagamento por código de receita aplicando wage index
5. **Totaliza** e retorna via GOBACK

---

## 2. Estrutura do Registro de Entrada/Saída (BILL-315-DATA)

O registro de 315 bytes é a interface de comunicação entre o Driver e o Pricer. Contém campos de **entrada** (preenchidos pelo Driver) e campos de **saída** (preenchidos pelo Pricer).

### 2.1 Campos de Identificação (Entrada)

| Campo | Tipo | Tamanho | Descrição |
|-------|------|---------|-----------|
| `BILL-NPI` | X(10) | 10 | National Provider Identifier |
| `BILL-PROV-NO` | X(06) | 6 | Número do provedor |

### 2.2 Datas (Entrada)

| Campo | Formato | Descrição |
|-------|---------|-----------|
| `BILL-FROM-DATE` | CCYYMMDD | Data de início do serviço — **determina o ano fiscal** |
| `BILL-ADMISSION-DATE` | CCYYMMDD | Data de admissão no hospice — usada na lógica RHC 60 dias |

```cobol
10  BILL-FROM-DATE.
    15  BILL-FROM-CC        PIC 99.    *> Século (19 ou 20)
    15  BILL-FROM-YY        PIC 99.    *> Ano
    15  BILL-FROM-MM        PIC 99.    *> Mês
    15  BILL-FROM-DD        PIC 99.    *> Dia

10  BILL-ADMISSION-DATE.
    15  BILL-ADM-CC         PIC 99.
    15  BILL-ADM-YY         PIC 99.
    15  BILL-ADM-MM         PIC 99.
    15  BILL-ADM-DD         PIC 99.
```

### 2.3 Códigos Geográficos (Entrada)

| Campo | Tipo | Descrição |
|-------|------|-----------|
| `BILL-PROV-CBSA` | X(05) | CBSA do provedor — usado para wage index do provedor |
| `BILL-BENE-CBSA` | X(05) | CBSA do beneficiário — usado para wage index do beneficiário |
| `BILL-PROV-WAGE-INDEX` | 9(02)V9(04) | Índice de salário do provedor (ex: 1.2345) |
| `BILL-BENE-WAGE-INDEX` | 9(02)V9(04) | Índice de salário do beneficiário (ex: 0.9876) |

```cobol
*> Estrutura REDEFINES — compatibilidade MSA legado / CBSA novo
10  BILL-PROV-MSA-LUGAR.
    15  BILL-PROV-MSA       PIC X(04).    *> Código MSA (legado)
    15  BILL-PROV-LUGAR     PIC X.        *> Indicador de localização
10  BILL-PROV-CBSA          REDEFINES
    BILL-PROV-MSA-LUGAR     PIC X(05).    *> Código CBSA (5 dígitos)
```

> **Regra:** Dois códigos geográficos distintos são mantidos — um para o provedor e outro para o beneficiário (paciente). O wage index do provedor é aplicado a IRC/GIC, enquanto o do beneficiário é aplicado a RHC/CHC.

### 2.4 Unidades SIA — Service Intensity Add-On (Entrada, a partir de FY2016.1)

| Campo | Tipo | Descrição |
|-------|------|-----------|
| `BILL-NA-ADD-ON-DAY1-UNITS` | PIC 99 | Dias de benefício prévios (não rotineiros) — Dia 1 |
| `BILL-NA-ADD-ON-DAY2-UNITS` | PIC 99 | Dias de benefício prévios — Dia 2 |
| `BILL-EOL-ADD-ON-DAY1-UNITS` a `DAY7-UNITS` | PIC 99 | Unidades EOL (15 min cada) para até 7 dias |

### 2.5 Indicador QIP (Entrada, a partir de FY2014)

| Campo | Tipo | Descrição |
|-------|------|-----------|
| `BILL-QIP-IND` | X(01) | `'1'` = Redução QIP aplicada; outro valor = taxa padrão |

### 2.6 Grupos de Linha de Item (4 grupos — Entrada/Saída)

Cada grupo contém:

| Campo | Tipo | Descrição |
|-------|------|-----------|
| `BILL-REVn` | X(04) | Código de receita (0651, 0652, 0655, 0656) |
| `BILL-HCPCn` | X(05) | Código HCPC |
| `BILL-LINE-ITEM-DOSn` | CCYYMMDD | Data de serviço da linha |
| `BILL-UNITSn` | 9(07) | Quantidade (dias, horas ou incrementos de 15 min) |
| `BILL-PAY-AMTn` | 9(06)V99 | **SAÍDA:** Valor de pagamento calculado |

```cobol
10  BILL-GROUP1.
    15  BILL-REV1                PIC XXXX.       *> Ex: '0651'
    15  BILL-HCPC1               PIC X(05).
    15  BILL-LINE-ITEM-DOS1.
        20  BILL-LIDOS1-CC       PIC 99.
        20  BILL-LIDOS1-YY       PIC 99.
        20  BILL-LIDOS1-MM       PIC 99.
        20  BILL-LIDOS1-DD       PIC 99.
    15  BILL-UNITS1              PIC 9(07).      *> Até 9.999.999
    15  BILL-PAY-AMT1            PIC 9(06)V99.   *> SAÍDA: pagamento
```

### 2.7 Campos de Saída

| Campo | Tipo | Descrição |
|-------|------|-----------|
| `BILL-PAY-AMT-TOTAL` | 9(06)V99 | **Total geral** de pagamento da fatura |
| `BILL-RTC` | XX | Código de retorno (veja Seção 6) |
| `BILL-HIGH-RHC-DAYS` | 99 | Dias pagos na taxa alta RHC |
| `BILL-LOW-RHC-DAYS` | 99 | Dias pagos na taxa baixa RHC |
| `BILL-EOL-ADD-ON-DAYn-PAY` | 9(06)V99 | Pagamento SIA por dia (7 campos) |

---

## 3. Inicialização de Variáveis

Antes de processar cada fatura, **todos os campos de saída são zerados**:

```cobol
1000-INITIALIZE.
    MOVE ALL '0' TO BILL-RETURNED-DATA      *> Total + RTC
                    BILL-RHC-DAYS-PAID       *> Dias HIGH/LOW RHC
                    BILL-PAY-AMT1            *> Pagamento linha 1
                    BILL-PAY-AMT2            *> Pagamento linha 2
                    BILL-PAY-AMT3            *> Pagamento linha 3
                    BILL-PAY-AMT4            *> Pagamento linha 4
                    BILL-SIA-ADD-ON-PYMTS.   *> 9 campos SIA

    INITIALIZE RHC-LOGIC-FLAGS              *> Flags HIGH/LOW/SIA
               RHC-LOGIC-VALUES             *> Dias prévios, horas EOL
               DATE-CALCULATION-FIELDS.     *> Variáveis de cálculo de data
```

> **Regra de Negócio:** A inicialização garante que nenhum valor residual de uma fatura anterior contamine o cálculo da fatura corrente.

---

## 4. Roteamento por Ano Fiscal (FY Routing)

O programa utiliza uma **cascata de condições IF** para direcionar cada fatura ao parágrafo correto com base na data de início do serviço (`BILL-FROM-DATE`).

```cobol
PROCEDURE DIVISION USING BILL-315-DATA.

    PERFORM 1000-INITIALIZE THRU 1000-INITIALIZE-EXIT.

    IF BILL-FROM-DATE > 20200930
       PERFORM 2021-V210-PROCESS-DATA THRU 2021-V210-PROCESS-EXIT
       GOBACK.

    IF BILL-FROM-DATE > 20190930
       PERFORM 2020-V200-PROCESS-DATA THRU 2020-V200-PROCESS-EXIT
       GOBACK.

    *> ... cascata continua até FY1998 ...

    PERFORM 1998-PROCESS-DATA THRU 1998-EXIT
    GOBACK.
```

### Tabela Completa de Roteamento

| Ano Fiscal | Data Limite (>) | Parágrafo | Observação |
|-----------|-----------------|-----------|------------|
| FY 2021 | 20200930 | `2021-V210-PROCESS-DATA` | Versão mais recente |
| FY 2020 | 20190930 | `2020-V200-PROCESS-DATA` | |
| FY 2019 | 20180930 | `2019-V190-PROCESS-DATA` | |
| FY 2018 | 20170930 | `2018-V180-PROCESS-DATA` | |
| FY 2017 | 20160930 | `2017-V170-PROCESS-DATA` | |
| FY 2016.1 | **20151231** | `2016-V161-PROCESS-DATA` | **Data especial:** 1/Jan/2016 — SIA introduzido |
| FY 2016 | 20150930 | `2016-PROCESS-DATA` | |
| FY 2015 | 20140930 | `2015-PROCESS-DATA` | |
| FY 2014 | 20130930 | `2014-PROCESS-DATA` | QIP introduzido |
| FY 2013 | 20120930 | `2013-PROCESS-DATA` | |
| FY 2012 | 20110930 | `2012-PROCESS-DATA` | |
| FY 2011 | 20100930 | `2011-PROCESS-DATA` | |
| FY 2010 | 20090930 | `2010-PROCESS-DATA` | |
| FY 2009 | 20080930 | `2009-PROCESS-DATA` | |
| FY 2008 | 20070930 | `2008-PROCESS-DATA` | |
| FY 2007.1 | **20061231** | `2007-1-PROCESS-DATA` | **Data especial:** 1/Jan/2007 — unidade 0652 muda para 15 min |
| FY 2007 | 20060930 | `2007-PROCESS-DATA` | Último FY com 0652 em horas |
| FY 2006 | 20050930 | `2006-PROCESS-DATA` | |
| FY 2005 | 20040930 | `2005-PROCESS-DATA` | |
| FY 2004 | 20030930 | `2004-PROCESS-DATA` | |
| FY 2003 | 20020930 | `2003-PROCESS-DATA` | |
| FY 2002 | 20010930 | `2002-PROCESS-DATA` | |
| FY 2001-A | **20010331** | `2001A-PROCESS-DATA` | **Data especial:** 1/Abr/2001 |
| FY 2001 | 20000930 | `2001-PROCESS-DATA` | |
| FY 2000 | 19990930 | `2000-PROCESS-DATA` | |
| FY 1999 | 19980930 | `1999-PROCESS-DATA` | |
| FY 1998 | *(padrão)* | `1998-PROCESS-DATA` | Default — sem comparação IF |

> **Regra de Negócio:** A avaliação é feita **de cima para baixo** (mais recente primeiro). A primeira condição verdadeira dirige o processamento; as condições subsequentes não são avaliadas (`GOBACK` encerra a execução). Datas com limites especiais (31/Dez/2006, 31/Dez/2015, 31/Mar/2001) representam revisões de meio de ano fiscal.

---

## 5. Validações de Entrada

### 5.1 Validação de Unidades Máximas (Todas as FYs)

**Regra:** Nenhuma linha de item pode ter mais de 1.000 unidades.

```cobol
IF BILL-UNITS1 > 1000 OR
   BILL-UNITS2 > 1000 OR
   BILL-UNITS3 > 1000 OR
   BILL-UNITS4 > 1000
   MOVE '10' TO BILL-RTC
   GO TO xxxx-EXIT.
```

| Condição | Código RTC | Ação |
|----------|-----------|------|
| Qualquer `BILL-UNITSn > 1000` | **10** | Rejeita — nenhum pagamento calculado |

### 5.2 Validação de Unidades Mínimas para Código 0652 (FY1998–FY2006)

**Regra:** Antes de FY2007, o código 0652 (CHC) exigia no mínimo 8 unidades (horas).

```cobol
IF BILL-REV2 = '0652'
   IF BILL-UNITS2 < 8
      MOVE '20' TO BILL-RTC
      GO TO xxxx-EXIT.
```

| Condição | Código RTC | Ação | Vigência |
|----------|-----------|------|----------|
| `BILL-REV2 = '0652'` E `BILL-UNITS2 < 8` | **20** | Rejeita | FY1998 a FY2006 |

> **Mudança em FY2007.1:** A partir de janeiro de 2007, a unidade do código 0652 muda de **horas** para **incrementos de 15 minutos**. A validação de mínimo 8 unidades é **removida**, substituída pela lógica de threshold de 32 unidades (8 horas).

---

## 6. Códigos de Retorno (BILL-RTC)

| RTC | Significado | Tipo | Quando Retorna |
|-----|-------------|------|----------------|
| **00** | Pagamento calculado com sucesso (taxa domiciliar) | Sucesso | Cálculo normal concluído |
| **10** | Unidades inválidas (> 1.000) | Erro | Validação de entrada |
| **20** | Unidades 0652 < 8 (somente FY1998–FY2006) | Erro | Validação de entrada |
| **30** | Código MSA/CBSA inválido | Erro | Busca em HOSDR210 |
| **40** | Wage index do provedor inválido | Erro | Validação do HOSDR210 |
| **50** | Wage index do beneficiário inválido | Erro | Validação do HOSDR210 |
| **51** | Número do provedor inválido | Erro | Validação do HOSDR210 |
| **73** | Taxa RHC baixa para todos os dias (sem SIA) | Sucesso | FY2016.1+ |
| **74** | Taxa RHC baixa **com** SIA End-of-Life | Sucesso | FY2016.1+ |
| **75** | Taxa RHC alta para alguns ou todos os dias (sem SIA) | Sucesso | FY2016.1+ |
| **77** | Taxa RHC alta **com** SIA End-of-Life | Sucesso | FY2016.1+ |

> **Regra:** Códigos 10, 20 são retornados **pelo Pricer** (HOSPR210). Códigos 30, 40, 50, 51 são retornados **pelo Driver** (HOSDR210). Códigos 73, 74, 75, 77 indicam sucesso com detalhamento do tipo de cálculo RHC utilizado.

---

## 7. Fórmula Geral de Cálculo de Pagamento

### 7.1 Fórmula Base (FY1998–FY2015)

Para cada código de receita, a fórmula consiste em:

```
Pagamento = ((Taxa_LS × Wage_Index) + Taxa_NLS) × Unidades
```

Onde:
- **Taxa_LS** = Parcela sensível ao custo de mão de obra (*Labor Share*)
- **Wage_Index** = Índice de salário geográfico (beneficiário ou provedor, conforme o tipo)
- **Taxa_NLS** = Parcela não sensível à mão de obra (*Non-Labor Share*) — valor fixo
- **Unidades** = Dias, horas ou incrementos de 15 minutos

### 7.2 Fórmula com Período de Benefício de 60 Dias (FY2016.1+)

Para RHC (0651), o pagamento é dividido em duas partes:

```
Pagamento_Total_RHC = Pagamento_Taxa_Alta + Pagamento_Taxa_Baixa

Pagamento_Taxa_Alta = ((LS_HIGH × BENE_WI) + NLS_HIGH) × Dias_Taxa_Alta
Pagamento_Taxa_Baixa = ((LS_LOW × BENE_WI) + NLS_LOW) × Dias_Taxa_Baixa
```

### 7.3 Fórmula Total da Fatura

```cobol
COMPUTE BILL-PAY-AMT-TOTAL =
    WRK-PAY-RATE1 +          *> RHC (0651) ou parte Alta+Baixa
    WRK-PAY-RATE2 +          *> CHC (0652)
    WRK-PAY-RATE3 +          *> IRC (0655)
    WRK-PAY-RATE4 +          *> GIC (0656)
    SIA-PAY-AMT-TOTAL        *> Add-on EOL (FY2016.1+)
```

---

## 8. Tipos de Cuidado e Códigos de Receita

### 8.1 Resumo dos 4 Tipos de Cuidado Hospice

| Código de Receita | Tipo de Cuidado | Sigla | Descrição | Wage Index |
|:-:|:-:|:-:|---|:-:|
| **0651** | Routine Home Care | **RHC** | Cuidado domiciliar de rotina — visitas de enfermagem, apoio ao paciente em casa | Beneficiário |
| **0652** | Continuous Home Care | **CHC** | Cuidado domiciliar contínuo — para crises, 8+ horas/dia de enfermagem predominante | Beneficiário |
| **0655** | Inpatient Respite Care | **IRC** | Cuidado temporário internado — alívio ao cuidador, estadias curtas | Provedor |
| **0656** | General Inpatient Care | **GIC** | Cuidado internado geral — controle de sintomas/dor aguda em hospital ou SNF | Provedor |

### 8.2 Regras Específicas do Código 0651 (RHC)

**Até FY2015:**
- 1 unidade = 1 dia de cuidado
- Fórmula simples: `((LS × BENE_WI) + NLS) × Dias`

**A partir de FY2016.1 (CR #9289):**
- Introdução de **taxa alta** (primeiros 60 dias) e **taxa baixa** (após 60 dias)
- Cálculo de dias prévios de benefício
- Novos códigos de retorno (73, 74, 75, 77)
- Adição de pagamentos SIA (Service Intensity Add-On)

### 8.3 Regras Específicas do Código 0652 (CHC)

#### Período FY1998 a FY2006 (Unidades em Horas)

```cobol
*> Fórmula FY1998: conversão de taxa diária para taxa horária
COMPUTE BILL-PAY-AMT2 ROUNDED =
    (((384.08 * BILL-BENE-WAGE-INDEX) + 174.91) / 24)
    * BILL-UNITS2
```

- 1 unidade = 1 hora
- Mínimo: 8 unidades (retorno RTC=20 se < 8)
- Taxa diária dividida por 24 para obter taxa horária

#### Período FY2007 (Out/2006–Dez/2006 — Transição)

Mesmo modelo de FY2006 ainda em horas.

#### Período FY2007.1+ (Jan/2007 em diante — Incrementos de 15 Minutos)

**Mudança crítica:** A unidade do código 0652 passa de **horas** para **incrementos de 15 minutos**.

```cobol
*> Lógica condicional com threshold de 32 unidades (= 8 horas)
IF BILL-REV2 = '0652'
   IF BILL-UNITS2 > 0
      IF BILL-UNITS2 < 32
         *> < 8 horas: paga 1 dia na taxa RHC (flat rate)
         COMPUTE WRK-PAY-RATE2 ROUNDED =
              ((LS-RHC-RATE * BILL-BENE-WAGE-INDEX) + NLS-RHC-RATE)
      ELSE
         *> >= 8 horas: paga na taxa CHC por hora
         COMPUTE WRK-PAY-RATE2 ROUNDED =
              (((LS-CHC-RATE * BILL-BENE-WAGE-INDEX) + NLS-CHC-RATE)
              / 24) * (BILL-UNITS2 / 4)
```

| Condição | Resultado | Explicação |
|----------|-----------|------------|
| `UNITS2 < 32` (< 8h) | Taxa fixa RHC | Pagamento como 1 dia de cuidado RHC |
| `UNITS2 >= 32` (≥ 8h) | Taxa horária CHC | `(Taxa_diária / 24) × (Unidades / 4)` |

> **Conversão:** 4 incrementos de 15 min = 1 hora. A divisão por 4 converte unidades em horas; a divisão da taxa diária por 24 converte para taxa horária.

**A partir de FY2016.1:** Se CHC < 32 unidades, a taxa RHC aplicada (alta ou baixa) depende da regra dos 60 dias (ver Seção 11).

### 8.4 Regras Específicas do Código 0655 (IRC)

```cobol
COMPUTE WRK-PAY-RATE3 ROUNDED =
    ((IRC-LS-RATE * BILL-PROV-WAGE-INDEX) + IRC-NLS-RATE)
    * BILL-UNITS3
```

- 1 unidade = 1 dia de internação
- Utiliza **wage index do provedor** (não do beneficiário)

### 8.5 Regras Específicas do Código 0656 (GIC)

```cobol
COMPUTE WRK-PAY-RATE4 ROUNDED =
    ((GIC-LS-RATE * BILL-PROV-WAGE-INDEX) + GIC-NLS-RATE)
    * BILL-UNITS4
```

- 1 unidade = 1 dia de internação
- Utiliza **wage index do provedor**
- Maiores valores entre os 4 tipos de cuidado

---

## 9. Índice de Salário (Wage Index)

O wage index é um fator multiplicador geográfico que ajusta a parcela laboral (*labor share*) do pagamento com base nos custos de mão de obra da região.

### 9.1 Regra de Aplicação por Tipo de Cuidado

| Tipo de Cuidado | Código Receita | Wage Index Utilizado | Justificativa |
|:-:|:-:|:-:|---|
| RHC | 0651 | **BILL-BENE-WAGE-INDEX** | O custo está onde o paciente reside |
| CHC | 0652 | **BILL-BENE-WAGE-INDEX** | Serviço prestado no domicílio do paciente |
| IRC | 0655 | **BILL-PROV-WAGE-INDEX** | Custo da instalação onde o paciente está internado |
| GIC | 0656 | **BILL-PROV-WAGE-INDEX** | Custo da instalação hospitalar |

### 9.2 Mecânica do Cálculo

A fórmula **não** multiplica todo o pagamento pelo wage index. Apenas a **parcela laboral (LS)** é ajustada:

```
Pagamento = (Parcela_LS × Wage_Index) + Parcela_NLS_Fixa
```

**Exemplo com wage index de 1.2000:**
- LS = $100.00, NLS = $50.00
- `Pagamento_dia = (100.00 × 1.2000) + 50.00 = 120.00 + 50.00 = $170.00`

**Exemplo com wage index de 0.8000:**
- `Pagamento_dia = (100.00 × 0.8000) + 50.00 = 80.00 + 50.00 = $130.00`

> **Regra:** O wage index **nunca** é aplicado à parcela NLS. Isso garante um piso mínimo de pagamento independentemente da localização geográfica.

---

## 10. Indicador QIP — Programa de Melhoria de Qualidade

### 10.1 Introdução (FY2014)

A partir de FY2014, o campo `BILL-QIP-IND` indica se o provedor Hospice está sujeito à **redução de ~2%** por não conformidade com o programa de melhoria de qualidade.

### 10.2 Lógica de Aplicação

```cobol
IF BILL-QIP-IND = '1'
   *> Aplica taxas com sufixo "-Q" (QIP-reduzidas)
   COMPUTE pagamento ROUNDED =
       ((xxxx-LS-RATE-Q * WAGE-INDEX) + xxxx-NLS-RATE-Q) * UNITS
ELSE
   *> Aplica taxas padrão (sem redução)
   COMPUTE pagamento ROUNDED =
       ((xxxx-LS-RATE * WAGE-INDEX) + xxxx-NLS-RATE) * UNITS
```

### 10.3 Impacto nas Taxas

As taxas com sufixo `-Q` são aproximadamente **2% menores** que as taxas padrão. Exemplo FY2021:

| Tipo | Taxa LS Padrão | Taxa LS com QIP | Redução |
|------|:-:|:-:|:-:|
| RHC HIGH | $136.90 | $134.23 | -1.95% |
| RHC LOW | $108.21 | $106.10 | -1.95% |
| CHC | $984.21 | $964.99 | -1.95% |
| IRC | $249.59 | $244.71 | -1.96% |
| GIC | $669.33 | $656.25 | -1.95% |

> **Regra de Negócio:** A redução QIP se aplica a **todos os 4 tipos de cuidado** igualmente. O indicador `'1'` = não conformidade (aplica redução). Qualquer outro valor = taxas padrão integrais.

### 10.4 Evolução da Lógica QIP

| Período | Comportamento |
|---------|---------------|
| FY1998–FY2013 | **Sem QIP** — taxa única por tipo de cuidado |
| FY2014–FY2015 | **QIP introduzido** — taxas hard-coded no programa |
| FY2016+ | **QIP via copybook** — taxas no HOSPRATE com sufixo `-Q` |

---

## 11. Lógica RHC — Período de Benefício de 60 Dias (FY2016.1+)

### 11.1 Conceito

A partir de janeiro de 2016 (FY2016.1), o cuidado RHC (código 0651) passou a ter **duas taxas** baseadas no tempo desde a admissão:

- **Taxa Alta (HIGH):** Primeiros 60 dias de benefício — reflete custos mais elevados no início do cuidado
- **Taxa Baixa (LOW):** A partir do 61º dia — custos estabilizados

### 11.2 Cálculo de Dias Prévios de Serviço

```cobol
*> Converter datas para inteiros (formato numérico)
MOVE BILL-ADMISSION-DATE TO DATE-1-ADM.
MOVE BILL-LINE-ITEM-DOS1 TO DATE-2-DOS.

COMPUTE DATE-1-ADM-INTEGER = FUNCTION INTEGER-OF-DATE(DATE-1-ADM)
COMPUTE DATE-2-DOS-INTEGER = FUNCTION INTEGER-OF-DATE(DATE-2-DOS)

*> Calcular dias entre admissão e data de serviço
COMPUTE DAYS-BETWEEN-DATES =
    DATE-2-DOS-INTEGER - DATE-1-ADM-INTEGER

*> Adicionar dias de benefício prévios (transferências)
IF BILL-NA-ADD-ON-DAY1-UNITS > ZEROES
    COMPUTE PRIOR-BENEFIT-DAYS = BILL-NA-ADD-ON-DAY1-UNITS
ELSE
    MOVE ZERO TO PRIOR-BENEFIT-DAYS
END-IF

*> Total de dias prévios de serviço
COMPUTE PRIOR-SVC-DAYS =
    DAYS-BETWEEN-DATES + PRIOR-BENEFIT-DAYS
```

**Fórmula:**
```
PRIOR-SVC-DAYS = (Data_Serviço - Data_Admissão) + Dias_Benefício_Prévios
```

### 11.3 Determinação de Taxa Alta vs Baixa

Existem **3 cenários** para a distribuição dos dias:

#### Cenário A: Todos os dias após o 60º dia

```cobol
IF PRIOR-SVC-DAYS >= 60
   MOVE BILL-UNITS1 TO LR-BILL-UNITS1      *> Todos = LOW rate
   PERFORM V210-APPLY-LOW-RHC-RATE
```

#### Cenário B: Todos os dias dentro dos primeiros 60 dias

```cobol
IF PRIOR-SVC-DAYS < 60
   COMPUTE HIGH-RATE-DAYS-LEFT = 60 - PRIOR-SVC-DAYS

   IF BILL-UNITS1 <= HIGH-RATE-DAYS-LEFT
      MOVE BILL-UNITS1 TO HR-BILL-UNITS1    *> Todos = HIGH rate
      PERFORM V210-APPLY-HIGH-RHC-RATE
```

#### Cenário C: Dias cruzam o limite de 60

```cobol
   ELSE
      *> Parte no HIGH rate
      MOVE HIGH-RATE-DAYS-LEFT TO HR-BILL-UNITS1
      PERFORM V210-APPLY-HIGH-RHC-RATE

      *> Restante no LOW rate
      COMPUTE LR-BILL-UNITS1 = BILL-UNITS1 - HR-BILL-UNITS1
      PERFORM V210-APPLY-LOW-RHC-RATE
   END-IF
```

### 11.4 Simulação da Lógica de 60 Dias

**Dados de exemplo:**
- Admissão: 01/Jan/2021
- Data de serviço: 20/Fev/2021
- Dias de benefício prévios (NA-ADD-ON): 5
- Unidades RHC faturadas: 10 dias

```
PRIOR-SVC-DAYS = (20/Fev - 01/Jan) + 5 = 51 + 5 = 56
HIGH-RATE-DAYS-LEFT = 60 - 56 = 4

Como BILL-UNITS1 (10) > HIGH-RATE-DAYS-LEFT (4):
  → HR-BILL-UNITS1 = 4 (taxa ALTA)
  → LR-BILL-UNITS1 = 10 - 4 = 6 (taxa BAIXA)
```

**Cálculo (FY2021, sem QIP, BENE_WI = 1.0000):**
```
Pagamento_ALTO = ((136.90 × 1.0000) + 62.35) × 4 = 199.25 × 4 = $797.00
Pagamento_BAIXO = ((108.21 × 1.0000) + 49.28) × 6 = 157.49 × 6 = $944.94
Total RHC = $797.00 + $944.94 = $1.741.94
```

### 11.5 Determinação do Código de Retorno RHC

Após o cálculo, o código de retorno é definido pela combinação de tipo de taxa e presença de SIA:

```cobol
IF SIA-UNITS-IND = 'Y'
   IF RHC-HIGH-DAY-IND = 'Y'
      MOVE '77' TO BILL-RTC          *> HIGH + SIA
   ELSE
      IF RHC-LOW-DAY-IND = 'Y'
         MOVE '74' TO BILL-RTC       *> LOW + SIA

IF SIA-UNITS-IND NOT = 'Y'
   IF RHC-HIGH-DAY-IND = 'Y'
      MOVE '75' TO BILL-RTC          *> HIGH sem SIA
   ELSE
      IF RHC-LOW-DAY-IND = 'Y'
         MOVE '73' TO BILL-RTC       *> LOW sem SIA
```

| SIA Presente? | Algum dia HIGH? | RTC | Descrição |
|:-:|:-:|:-:|---|
| Sim | Sim | **77** | Taxa alta RHC com add-on EOL |
| Sim | Não | **74** | Taxa baixa RHC com add-on EOL |
| Não | Sim | **75** | Taxa alta RHC sem add-on |
| Não | Não | **73** | Taxa baixa RHC sem add-on |

> **Nota:** Se houve split (Cenário C), o `RHC-HIGH-DAY-IND` terá `'Y'`, resultando em RTC 75 ou 77.

---

## 12. Service Intensity Add-On (SIA) — Fim de Vida (FY2016.1+)

### 12.1 Conceito

O SIA (Service Intensity Add-on) é um pagamento adicional para pacientes nos **últimos 7 dias de vida**, refletindo a intensidade maior dos cuidados nesse período.

### 12.2 Determinação da Presença de SIA

```cobol
IF BILL-EOL-ADD-ON-DAY1-UNITS > ZEROES OR
   BILL-EOL-ADD-ON-DAY2-UNITS > ZEROES OR
   BILL-EOL-ADD-ON-DAY3-UNITS > ZEROES OR
   BILL-EOL-ADD-ON-DAY4-UNITS > ZEROES OR
   BILL-EOL-ADD-ON-DAY5-UNITS > ZEROES OR
   BILL-EOL-ADD-ON-DAY6-UNITS > ZEROES OR
   BILL-EOL-ADD-ON-DAY7-UNITS > ZEROES
   MOVE 'Y' TO SIA-UNITS-IND
ELSE
   MOVE 'N' TO SIA-UNITS-IND
```

### 12.3 Taxa Horária SIA

A taxa SIA é a **taxa CHC diária dividida por 24** (taxa por hora):

```cobol
*> Com QIP:
COMPUTE SIA-PYMT-RATE ROUNDED =
    (((CHC-LS-RATE-Q * BILL-BENE-WAGE-INDEX)
       + CHC-NLS-RATE-Q) / 24)

*> Sem QIP:
COMPUTE SIA-PYMT-RATE ROUNDED =
    (((CHC-LS-RATE * BILL-BENE-WAGE-INDEX)
       + CHC-NLS-RATE) / 24)
```

### 12.4 Cálculo por Dia (até 7 dias)

Para cada dia EOL (1 a 7):
- 1 unidade = 15 minutos
- **Cap:** Máximo de 4 horas por dia (16 unidades)

```cobol
*> Exemplo para Dia 1:
IF BILL-EOL-ADD-ON-DAY1-UNITS > ZEROES
   COMPUTE EOL-UNITS1 = BILL-EOL-ADD-ON-DAY1-UNITS

   IF EOL-UNITS1 >= 16              *> 16 × 15min = 4 horas
      MOVE 4 TO EOL-HOURS1          *> Cap em 4 horas
   ELSE
      COMPUTE EOL-HOURS1 ROUNDED = (EOL-UNITS1 / 4)  *> Converte para horas
   END-IF

   COMPUTE BILL-EOL-ADD-ON-DAY1-PAY ROUNDED =
       EOL-HOURS1 * SIA-PYMT-RATE
END-IF
```

O mesmo padrão se repete para os dias 2 a 7.

### 12.5 Total SIA

```cobol
COMPUTE SIA-PAY-AMT-TOTAL =
    BILL-EOL-ADD-ON-DAY1-PAY +
    BILL-EOL-ADD-ON-DAY2-PAY +
    BILL-EOL-ADD-ON-DAY3-PAY +
    BILL-EOL-ADD-ON-DAY4-PAY +
    BILL-EOL-ADD-ON-DAY5-PAY +
    BILL-EOL-ADD-ON-DAY6-PAY +
    BILL-EOL-ADD-ON-DAY7-PAY
```

### 12.6 Simulação SIA

**Dados de exemplo (FY2021, sem QIP, BENE_WI = 1.0000):**
- Dia 1: 12 unidades (3 horas)
- Dia 2: 20 unidades → cap em 4 horas
- Dia 3: 8 unidades (2 horas)
- Dias 4–7: 0 unidades

```
Taxa CHC diária = (984.21 × 1.0000) + 448.20 = $1.432,41
SIA-PYMT-RATE = $1.432,41 / 24 = $59,68/hora

Dia 1: 12 unidades → 12/4 = 3 horas → 3 × $59,68 = $179,04
Dia 2: 20 unidades → cap 4 horas → 4 × $59,68 = $238,72
Dia 3: 8 unidades → 8/4 = 2 horas → 2 × $59,68 = $119,36

SIA-PAY-AMT-TOTAL = $179,04 + $238,72 + $119,36 = $537,12
```

### 12.7 Limites do SIA

| Parâmetro | Valor | Justificativa |
|-----------|-------|---------------|
| Máximo de dias | 7 | Últimos 7 dias de vida |
| Máximo de horas/dia | 4 | Cap regulatório |
| Unidade por hora | 4 incrementos de 15 min | 1 unidade = 15 minutos |
| Máximo de unidades/dia com efeito | 16 | 16 × 15 min = 4 horas |
| Máximo teórico total | 28 horas | 7 dias × 4 horas |

---

## 13. Evolução das Taxas por Ano Fiscal

### 13.1 Taxas FY1998–FY2006 (Fórmula Simples — Hard-coded)

| FY | RHC-LS | RHC-NLS | CHC-LS | CHC-NLS | IRC-LS | IRC-NLS | GIC-LS | GIC-NLS |
|:-:|:-:|:-:|:-:|:-:|:-:|:-:|:-:|:-:|
| 1998 | 65.80 | 29.97 | 384.08 | 174.91 | 53.63 | 45.44 | 272.71 | 153.34 |
| 1999 | 66.72 | 30.39 | 389.46 | 177.36 | 54.38 | 46.08 | 276.53 | 155.48 |
| 2000 | 68.00 | 30.96 | 396.86 | 180.73 | 55.41 | 46.96 | 281.78 | 158.44 |
| 2001 | 69.97 | 31.87 | 408.42 | 185.99 | 57.03 | 48.32 | 289.99 | 163.05 |
| 2001-A | 73.47 | 33.46 | 428.84 | 195.29 | 59.88 | 50.74 | 304.49 | 171.20 |
| 2002 | 75.87 | 34.55 | 442.80 | 201.65 | 61.83 | 52.39 | 314.41 | 176.78 |
| 2003 | 78.47 | 35.73 | 457.97 | 208.55 | 63.94 | 54.19 | 325.18 | 182.83 |
| 2004 | 81.13 | 36.95 | 473.54 | 215.64 | 66.12 | 56.03 | 336.23 | 189.05 |
| 2005 | 83.81 | 38.17 | 489.16 | 222.76 | 68.30 | 57.88 | 347.32 | 195.29 |
| 2006 | 86.91 | 39.58 | 507.26 | 231.00 | 70.83 | 60.02 | 360.18 | 202.51 |

> **Nota:** FY2001-A é uma revisão de meio de ano (a partir de 01/Abr/2001).

### 13.2 Taxas FY2007–FY2008 (Unidades 0652 mudam para 15 min em FY2007.1)

| FY | RHC-LS | RHC-NLS | CHC-LS | CHC-NLS | IRC-LS | IRC-NLS | GIC-LS | GIC-NLS |
|:-:|:-:|:-:|:-:|:-:|:-:|:-:|:-:|:-:|
| 2007 | 89.87 | 40.92 | 524.50 | 238.86 | 73.24 | 62.06 | 372.42 | 209.40 |
| 2007.1 | 89.87 | 40.92 | 524.50 | 238.86 | 73.24 | 62.06 | 372.42 | 209.40 |
| 2008 | 92.83 | 42.28 | 541.81 | 246.74 | 75.65 | 64.11 | 384.71 | 216.31 |

> **Nota:** FY2007 e FY2007.1 possuem as mesmas taxas, mas a **interpretação da unidade** do código 0652 muda de horas para incrementos de 15 minutos.

### 13.3 Taxas FY2009–FY2013 (Sem QIP)

| FY | RHC-LS | RHC-NLS | CHC-LS | CHC-NLS | IRC-LS | IRC-NLS | GIC-LS | GIC-NLS |
|:-:|:-:|:-:|:-:|:-:|:-:|:-:|:-:|:-:|
| 2009 | 96.17 | 43.80 | 561.32 | 255.62 | 78.37 | 66.42 | 398.56 | 224.10 |
| 2010 | 98.19 | 44.72 | 573.11 | 260.99 | 80.02 | 67.81 | 406.94 | 228.80 |
| 2011 | 100.75 | 45.88 | 588.01 | 267.78 | 82.10 | 69.57 | 417.52 | 234.75 |
| 2012 | 103.77 | 47.26 | 605.65 | 275.81 | 84.56 | 71.66 | 430.04 | 241.80 |
| 2013 | 105.44 | 48.01 | 615.34 | 280.22 | 85.92 | 72.80 | 436.93 | 245.66 |

### 13.4 Taxas FY2014–FY2015 (Introdução QIP)

#### FY2014

| Tipo | LS (Padrão) | NLS (Padrão) | LS (QIP) | NLS (QIP) |
|:-:|:-:|:-:|:-:|:-:|
| RHC | 107.23 | 48.83 | 105.12 | 47.87 |
| CHC | 625.80 | 284.98 | 613.49 | 279.38 |
| IRC | 87.38 | 74.04 | 85.66 | 72.58 |
| GIC | 444.35 | 249.84 | 435.61 | 244.93 |

#### FY2015

| Tipo | LS (Padrão) | NLS (Padrão) | LS (QIP) | NLS (QIP) |
|:-:|:-:|:-:|:-:|:-:|
| RHC | 109.48 | 49.86 | 107.34 | 48.88 |
| CHC | 638.94 | 290.97 | 626.42 | 285.27 |
| IRC | 89.21 | 75.60 | 87.46 | 74.12 |
| GIC | 453.68 | 255.09 | 444.79 | 250.09 |

### 13.5 Taxas FY2016 (Copybook HOSPRATE Introduzido — Taxa Única RHC)

| Tipo | LS (Padrão) | NLS (Padrão) | LS (QIP) | NLS (QIP) |
|:-:|:-:|:-:|:-:|:-:|
| RHC | 111.23 | 50.66 | 109.04 | 49.66 |
| CHC | 649.17 | 295.62 | 636.39 | 289.80 |
| IRC | 90.64 | 76.81 | 88.85 | 75.30 |
| GIC | 460.94 | 259.17 | 451.87 | 254.06 |

### 13.6 Taxas FY2016.1+ (RHC Split em HIGH/LOW — HOSPRATE)

#### FY2016.1 (Jan/2016)

| Tipo | LS (Padrão) | NLS (Padrão) | LS (QIP) | NLS (QIP) |
|:-:|:-:|:-:|:-:|:-:|
| RHC HIGH | 128.38 | 58.46 | 125.86 | 57.31 |
| RHC LOW | 100.89 | 45.94 | 98.90 | 45.04 |
| CHC | 649.17 | 295.62 | 636.39 | 289.80 |
| IRC | 90.64 | 76.81 | 88.85 | 75.30 |
| GIC | 460.94 | 259.17 | 451.87 | 254.06 |

#### FY2017

| Tipo | LS (Padrão) | NLS (Padrão) | LS (QIP) | NLS (QIP) |
|:-:|:-:|:-:|:-:|:-:|
| RHC HIGH | 130.93 | 59.62 | 128.36 | 58.46 |
| RHC LOW | 102.94 | 46.88 | 100.93 | 45.96 |
| CHC | 662.80 | 301.83 | 649.81 | 295.92 |
| IRC | 92.55 | 78.42 | 90.73 | 76.89 |
| GIC | 470.44 | 264.50 | 461.22 | 259.32 |

#### FY2018

| Tipo | LS (Padrão) | NLS (Padrão) | LS (QIP) | NLS (QIP) |
|:-:|:-:|:-:|:-:|:-:|
| RHC HIGH | 132.46 | 60.32 | 129.84 | 59.13 |
| RHC LOW | 104.03 | 47.38 | 101.97 | 46.44 |
| CHC | 670.90 | 305.52 | 657.61 | 299.47 |
| IRC | 93.53 | 79.25 | 91.67 | 77.69 |
| GIC | 475.95 | 267.60 | 466.52 | 262.31 |

#### FY2019

| Tipo | LS (Padrão) | NLS (Padrão) | LS (QIP) | NLS (QIP) |
|:-:|:-:|:-:|:-:|:-:|
| RHC HIGH | 134.84 | 61.41 | 132.19 | 60.20 |
| RHC LOW | 105.96 | 48.25 | 103.88 | 47.30 |
| CHC | 685.30 | 312.08 | 671.83 | 305.95 |
| IRC | 95.27 | 80.74 | 93.41 | 79.15 |
| GIC | 485.24 | 272.83 | 475.71 | 267.47 |

#### FY2020

| Tipo | LS (Padrão) | NLS (Padrão) | LS (QIP) | NLS (QIP) |
|:-:|:-:|:-:|:-:|:-:|
| RHC HIGH | 133.64 | 60.86 | 131.04 | 59.67 |
| RHC LOW | 105.62 | 48.10 | 103.56 | 47.16 |
| CHC | 958.94 | 436.69 | 940.24 | 428.18 |
| IRC | 243.64 | 206.46 | 238.89 | 202.43 |
| GIC | 653.70 | 367.55 | 640.96 | 360.39 |

> **Atenção FY2020:** Aumento significativo nas taxas CHC, IRC e GIC em relação ao FY2019. RHC permanece estável.

#### FY2021 (Versão Mais Recente)

| Tipo | LS (Padrão) | NLS (Padrão) | LS (QIP) | NLS (QIP) |
|:-:|:-:|:-:|:-:|:-:|
| RHC HIGH | **136.90** | **62.35** | 134.23 | 61.13 |
| RHC LOW | **108.21** | **49.28** | 106.10 | 48.32 |
| CHC | **984.21** | **448.20** | 964.99 | 439.45 |
| IRC | **249.59** | **211.50** | 244.71 | 207.37 |
| GIC | **669.33** | **376.33** | 656.25 | 368.98 |

---

## 14. Simulações Completas de Cálculo

### 14.1 Simulação FY1998 — Modelo Simples

**Cenário:** Fatura de hospice com todos os 4 tipos de cuidado, região metropolitana com wage index médio.

| Dado de Entrada | Valor |
|---|---|
| BILL-FROM-DATE | 19990115 |
| BILL-BENE-WAGE-INDEX | 1.0500 |
| BILL-PROV-WAGE-INDEX | 0.9800 |
| BILL-REV1 / UNITS1 | 0651 / 30 dias |
| BILL-REV2 / UNITS2 | 0652 / 24 horas |
| BILL-REV3 / UNITS3 | 0655 / 5 dias |
| BILL-REV4 / UNITS4 | 0656 / 3 dias |

**Roteamento:** `BILL-FROM-DATE (19990115) > 19980930` → `1999-PROCESS-DATA`

**Validações:**
- Todas as unidades ≤ 1.000 ✓
- BILL-UNITS2 (24) ≥ 8 ✓

**Cálculos:**

```
0651 (RHC): ((66.72 × 1.0500) + 30.39) × 30 = (70.06 + 30.39) × 30
          = 100.45 × 30 = $3.013,35

0652 (CHC): (((389.46 × 1.0500) + 177.36) / 24) × 24 = ((408.93 + 177.36) / 24) × 24
          = (586.29 / 24) × 24 = 24.43 × 24 = $586,29

0655 (IRC): ((54.38 × 0.9800) + 46.08) × 5 = (53.29 + 46.08) × 5
          = 99.37 × 5 = $496,86

0656 (GIC): ((276.53 × 0.9800) + 155.48) × 3 = (271.00 + 155.48) × 3
          = 426.48 × 3 = $1.279,44

BILL-PAY-AMT-TOTAL = $3.013,35 + $586,29 + $496,86 + $1.279,44 = $5.375,94
BILL-RTC = '00' (Sucesso)
```

---

### 14.2 Simulação FY2021 — Modelo Completo com RHC 60 Dias + SIA

**Cenário:** Paciente em fim de vida, admitido há 55 dias, combinando taxa alta/baixa RHC com add-on SIA.

| Dado de Entrada | Valor |
|---|---|
| BILL-FROM-DATE | 20210315 |
| BILL-ADMISSION-DATE | 20210119 |
| BILL-QIP-IND | `' '` (sem redução QIP) |
| BILL-BENE-WAGE-INDEX | 1.1500 |
| BILL-PROV-WAGE-INDEX | 1.0200 |
| BILL-NA-ADD-ON-DAY1-UNITS | 00 (sem dias prévios) |
| BILL-REV1 / UNITS1 | 0651 / 10 dias |
| BILL-REV2 / UNITS2 | 0652 / 40 unidades (10 horas) |
| BILL-REV3 / UNITS3 | 0655 / 2 dias |
| BILL-REV4 / UNITS4 | 0656 / 1 dia |
| BILL-EOL-ADD-ON-DAY1-UNITS | 12 (3 horas) |
| BILL-EOL-ADD-ON-DAY2-UNITS | 16 (4 horas — cap) |
| BILL-EOL-ADD-ON-DAY3-UNITS | 08 (2 horas) |
| BILL-EOL-ADD-ON-DAY4-7 | 00 |

**Roteamento:** `BILL-FROM-DATE (20210315) > 20200930` → `2021-V210-PROCESS-DATA`

**Validações:**
- Todas as unidades ≤ 1.000 ✓

---

**Passo 1: Cálculo de Dias Prévios**
```
PRIOR-SVC-DAYS = (20210315 - 20210119) + 0 = 55 dias
HIGH-RATE-DAYS-LEFT = 60 - 55 = 5 dias
```

**Passo 2: RHC (0651) — Split HIGH/LOW**
```
BILL-UNITS1 (10) > HIGH-RATE-DAYS-LEFT (5) → Cenário C (split)

Dias taxa ALTA: HR-BILL-UNITS1 = 5
Pagamento ALTO = ((136.90 × 1.1500) + 62.35) × 5
               = (157.44 + 62.35) × 5 = 219.79 × 5 = $1.098,93

Dias taxa BAIXA: LR-BILL-UNITS1 = 10 - 5 = 5
Pagamento BAIXO = ((108.21 × 1.1500) + 49.28) × 5
                = (124.44 + 49.28) × 5 = 173.72 × 5 = $868,61

WRK-PAY-RATE1 = $1.098,93 + $868,61 = $1.967,54
BILL-HIGH-RHC-DAYS = 5
BILL-LOW-RHC-DAYS = 5
RHC-HIGH-DAY-IND = 'Y'
RHC-LOW-DAY-IND = 'Y'
```

**Passo 3: CHC (0652) — 40 unidades (≥ 32)**
```
BILL-UNITS2 (40) >= 32 → Taxa CHC horária

WRK-PAY-RATE2 = (((984.21 × 1.1500) + 448.20) / 24) × (40 / 4)
              = ((1131.84 + 448.20) / 24) × 10
              = (1580.04 / 24) × 10
              = 65.84 × 10 = $658,35
```

**Passo 4: IRC (0655)**
```
WRK-PAY-RATE3 = ((249.59 × 1.0200) + 211.50) × 2
              = (254.58 + 211.50) × 2 = 466.08 × 2 = $932,16
```

**Passo 5: GIC (0656)**
```
WRK-PAY-RATE4 = ((669.33 × 1.0200) + 376.33) × 1
              = (682.72 + 376.33) × 1 = $1.059,05
```

**Passo 6: SIA — Pagamento End-of-Life**
```
SIA-PYMT-RATE = ((984.21 × 1.1500) + 448.20) / 24
              = 1580.04 / 24 = $65,84/hora

Dia 1: 12 unidades → 12/4 = 3 horas → 3 × $65,84 = $197,51
Dia 2: 16 unidades → cap 4 horas → 4 × $65,84 = $263,35
Dia 3: 8 unidades → 8/4 = 2 horas → 2 × $65,84 = $131,67
Dias 4-7: $0,00

SIA-PAY-AMT-TOTAL = $197,51 + $263,35 + $131,67 = $592,53
SIA-UNITS-IND = 'Y'
```

**Passo 7: Total**
```
BILL-PAY-AMT-TOTAL = $1.967,54 + $658,35 + $932,16 + $1.059,05 + $592,53
                   = $5.209,63

BILL-RTC = '77' (HIGH RHC + SIA presente)
```

---

### 14.3 Simulação FY2021 — QIP Aplicado

**Mesmo cenário da Simulação 14.2, mas com `BILL-QIP-IND = '1'`:**

**Passo 2 (QIP): RHC**
```
Pagamento ALTO = ((134.23 × 1.1500) + 61.13) × 5
               = (154.36 + 61.13) × 5 = 215.49 × 5 = $1.077,47

Pagamento BAIXO = ((106.10 × 1.1500) + 48.32) × 5
                = (122.02 + 48.32) × 5 = 170.34 × 5 = $851,68

WRK-PAY-RATE1 (QIP) = $1.929,15
```

**Passo 6 (QIP): SIA**
```
SIA-PYMT-RATE = ((964.99 × 1.1500) + 439.45) / 24
              = (1109.74 + 439.45) / 24 = 1549.19 / 24 = $64,55/hora

Total SIA (QIP) = (3 × 64.55) + (4 × 64.55) + (2 × 64.55) = $580,96
```

**Total com QIP = $5.099,63** (redução de ~2.1% vs sem QIP)

---

### 14.4 Simulação de Erros de Validação

| Cenário | Entrada | Resultado |
|---------|---------|-----------|
| Unidades acima do limite | BILL-UNITS1 = 1500 | RTC = '10', pagamento = $0 |
| CHC abaixo do mínimo (FY2005) | BILL-REV2='0652', UNITS2=5 | RTC = '20', pagamento = $0 |
| CHC abaixo de 32 (FY2021) | BILL-REV2='0652', UNITS2=20 | Calcula **na taxa RHC** (1 dia) |

---

## 15. Linha do Tempo de Mudanças Regulatórias

| Data Efetiva | Versão | Mudança Regulatória | Impacto no Código |
|:--:|:--:|---|---|
| Oct/1997 | FY1998 | Versão inicial | 4 tipos de cuidado, fórmula base LS/NLS |
| Apr/2001 | FY2001-A | Ajuste de meio de ano | Novas taxas, mudança na lógica 0652 |
| Oct/2006 | FY2007 | Novo cálculo por código de receita | Parágrafo 2007-PROCESS-DATA |
| **Jan/2007** | **FY2007.1** | **Unidade 0652 muda para 15 minutos** | Threshold 32 unidades, validação mínimo 8 removida |
| Oct/2013 | FY2014 | **QIP introduzido** | `BILL-QIP-IND`, taxas duplas (padrão/-Q), registro 135→215 bytes |
| Oct/2015 | FY2016 | Copybook HOSPRATE externalizado | Taxas em arquivo separado |
| **Jan/2016** | **FY2016.1 (CR #9289)** | **RHC taxa alta/baixa (60 dias); SIA/EOL** | Registro 215→315 bytes, RTC 73/74/75/77, campos SIA |
| Oct/2016 | FY2017 | Atualização de taxas | Mesma estrutura de FY2016.1 |
| Oct/2017 | FY2018 | Atualização de taxas | Mesma estrutura |
| Oct/2018 | FY2019 | Atualização de taxas + CR #10573 | Rastreamento explícito dias HIGH/LOW |
| Oct/2019 | FY2020 | Atualização de taxas + CR #11411 | Aumento significativo CHC/IRC/GIC |
| Oct/2020 | FY2021 | Atualização de taxas | Versão mais recente do programa |

---

## Glossário

| Termo | Significado |
|-------|-------------|
| **FY** | *Fiscal Year* — Ano fiscal (Out a Set) |
| **RHC** | *Routine Home Care* — Cuidado domiciliar de rotina |
| **CHC** | *Continuous Home Care* — Cuidado domiciliar contínuo |
| **IRC** | *Inpatient Respite Care* — Cuidado temporário internado |
| **GIC** | *General Inpatient Care* — Cuidado internado geral |
| **LS** | *Labor Share* — Parcela sensível ao custo de mão de obra |
| **NLS** | *Non-Labor Share* — Parcela não sensível à mão de obra |
| **CBSA** | *Core-Based Statistical Area* — Área estatística central |
| **MSA** | *Metropolitan Statistical Area* — Área estatística metropolitana (legado) |
| **QIP** | *Quality Improvement Program* — Programa de Melhoria de Qualidade |
| **SIA** | *Service Intensity Add-on* — Complemento por Intensidade de Serviço |
| **EOL** | *End of Life* — Fim de vida |
| **WI** | *Wage Index* — Índice de salário geográfico |
| **RTC** | *Return Code* — Código de retorno |
| **CR** | *Change Request* — Solicitação de mudança regulatória |
| **NPI** | *National Provider Identifier* — Identificador nacional do provedor |
| **HCPC** | *Healthcare Common Procedure Coding System* — Sistema de codificação de procedimentos |

---

> **Documento gerado a partir da análise do código-fonte HOSPR210 (6.555 linhas COBOL).**  
> **Copybook HOSPRATE (333 linhas) utilizado como referência para taxas FY2016–FY2021.**
