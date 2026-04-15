# Hospice PC Pricer

Motor de cálculo de pagamentos **Medicare/Medicaid Hospice** do CMS — cobre os anos fiscais FY1998 a FY2021 e inclui tanto a implementação original em COBOL quanto uma reimplementação moderna em Java/Spring Boot.

---

## Visão Geral

O Hospice PC Pricer calcula valores de pagamento per-diem e por hora para reivindicações de cuidados paliativos (hospice) com base nas regras do Prospective Payment System (PPS) do CMS. Dado um registro de fatura com dados do beneficiário, provedor e serviços prestados, o sistema determina o pagamento aplicável para o ano fiscal correspondente.

---

## Estrutura do Repositório

```
hospice-pc-pricer/
├── hospice-pricer-cobol/   # Implementação original IBM COBOL (IBM-370 / z/OS)
└── hospice-pricer-api/     # Reimplementação Java 21 + Spring Boot 3.3 (REST API)
```

---

## Módulos

### `hospice-pricer-cobol/` — Implementação COBOL Original

Código-fonte original do CMS para execução em mainframe IBM z/OS. Inclui ambiente de teste local usando GnuCOBOL 3.2 no Windows.

**Cobertura:** FY1998–FY2021 | **Linguagem:** IBM Enterprise COBOL | **Plataforma original:** IBM z/OS + CICS

```
HOSDR210  →  HOSPR210  →  HOSPRATE (copybook)
(Driver)     (Pricer)     (Taxas FY2016–FY2021)
```

| Componente | Descrição |
|------------|-----------|
| `HOSDR210` | Driver — lookup de provedor e wage index geográfico |
| `HOSPR210` | Pricer — motor de cálculo por ano fiscal (6.555 linhas) |
| `HOSPRATE` | Copybook de taxas de pagamento FY2016–FY2021 |
| `CBSA2021` | Dados de wage index CBSA (~7.478 registros) |
| `TESTJCL`  | JCL para execução batch no mainframe + relatório SAS |

**Execução rápida (Windows):**
```cmd
hospice-pricer-cobol\test\build-and-run.bat
```

→ [hospice-pricer-cobol/README.md](hospice-pricer-cobol/README.md)

---

### `hospice-pricer-api/` — API Java/Spring Boot

Reimplementação completa em Java 21 com paridade funcional em relação ao COBOL. Expõe o motor de precificação como uma API REST JSON.

**Tecnologia:** Java 21 · Spring Boot 3.3 · Maven · OpenAPI/Swagger

```
POST /api/v1/hospice/price
        │
        ▼
  DriverService       (provider lookup + wage index — espelha HOSDR210)
        │
        ▼
  FiscalYearRouter    (roteamento por data — O(log n) NavigableMap)
        │
        ▼
  PaymentCalculator   (cálculo por código de receita — espelha HOSPR210)
```

**Build e execução:**
```bash
cd hospice-pricer-api
mvn spring-boot:run
```

API disponível em `http://localhost:8080`  
Swagger UI: `http://localhost:8080/swagger-ui.html`

→ [hospice-pricer-api/README.md](hospice-pricer-api/README.md)

---

## Cálculo de Pagamento

$$\text{Pagamento} = (\text{Taxa}_\text{LS} \times \text{WageIndex} + \text{Taxa}_\text{NLS}) \times \text{Unidades}$$

| Código | Tipo de Cuidado | Descrição |
|--------|----------------|-----------|
| `0651` | RHC | Routine Home Care |
| `0652` | CHC | Continuous Home Care |
| `0655` | IRC | Inpatient Respite Care |
| `0656` | GIC | General Inpatient Care |

Ajustes aplicáveis:
- **QIP** — redutor de qualidade (Quality Improvement Program)
- **RHC 60 dias** — split de taxa low/high a partir de FY2016.1
- **SIA** — complemento Service Intensity Add-On de fim de vida (FY2016.1+)

---

## Pré-requisitos

| Componente | Versão | Uso |
|------------|--------|-----|
| GnuCOBOL 3.2 | incluído em `hospice-pricer-cobol/tools/gnucobol32/` | Build COBOL local |
| Java | 21 | API Java |
| Maven | 3.9+ | Build da API Java |

---

## Documentação

| Documento | Descrição |
|-----------|-----------|
| [hospice-pricer-cobol/README.md](hospice-pricer-cobol/README.md) | Guia completo do módulo COBOL |
| [hospice-pricer-api/README.md](hospice-pricer-api/README.md) | Guia completo da API Java |
| [hospice-pricer-cobol/docs/regras-negocio-HOSPR210-PricerModule.md](hospice-pricer-cobol/docs/regras-negocio-HOSPR210-PricerModule.md) | Regras de negócio detalhadas |
| [hospice-pricer-cobol/docs/analise-casos-teste.md](hospice-pricer-cobol/docs/analise-casos-teste.md) | Análise dos casos de teste |
| [hospice-pricer-cobol/docs/plano-execucao-casos-teste.md](hospice-pricer-cobol/docs/plano-execucao-casos-teste.md) | Plano de expansão de testes |
| [.specs/project/PROJECT.md](.specs/project/PROJECT.md) | Visão, objetivos e escopo do projeto |
| [.specs/project/ROADMAP.md](.specs/project/ROADMAP.md) | Roadmap e status das features |
