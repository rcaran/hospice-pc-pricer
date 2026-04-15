# Tasks: Correção de Bugs no Gerador de Dados de Teste

**Feature:** FIX-GENDATA-001  
**Spec:** [spec.md](spec.md)  
**Última atualização:** 2026-04-11

---

## Visão geral das tarefas

| ID | Tarefa | Depende de | Paralelo? | Status |
|----|--------|------------|-----------|--------|
| T01 | Corrigir QIP-IND "Y" → "1" em GENDATA.cbl | — | Sim | ✅ |
| T02 | Adicionar INITIALIZE antes do Provider 2 | — | Sim | ✅ |
| T03 | Criar run/MSAFILE com entradas MSA 6740 | — | Sim | ✅ |
| T03b | Corrigir CBSA→MSA code em bills pré-FY2006 | T03 | Não | ✅ |
| T04 | Rebuild e execução do teste completo | T01, T02, T03, T03b | Não | ✅ |
| T05 | Verificar comportamento WI=0 TC01–TC07 | T04 | Não | ✅ |

> T01, T02, T03 são independentes entre si e podem ser executadas em paralelo
> por agentes separados. T04 só se inicia após T01+T02+T03 concluídas.

---

## T01 — Corrigir QIP-IND: substituir `"Y"` por `"1"` em 7 locais

**Spec:** REQ-01  
**Arquivo:** `test/GENDATA.cbl`  
**Impacto:** 7 linhas, sem risco de efeito colateral (string única em cada contexto)

### O que fazer

Substituir cada ocorrência de `MOVE "Y" TO WB-QIP-IND` pelo valor `"1"` nas 7 linhas abaixo.
Use `multi_replace_string_in_file` para aplicar todas as substituições em uma única chamada.

**Ocorrências a substituir:**

| Linha | Contexto (3 linhas antes) | Caso |
|-------|--------------------------|------|
| 464 | `MOVE "16740" TO WB-BENE-CBSA` (linha 458–463) + `MOVE "0651" TO WB-REV1` (linha 465) | TC05 |
| 848 | `MOVE "16740" TO WB-BENE-CBSA` + `MOVE "0652" TO WB-REV1` | TC17 |
| 873 | `MOVE "16740" TO WB-BENE-CBSA` + `MOVE "0655" TO WB-REV1` | TC18 |
| 898 | `MOVE "16740" TO WB-BENE-CBSA` + `MOVE "0656" TO WB-REV1` | TC19 |
| 932 | `MOVE "16740" TO WB-BENE-CBSA` + `MOVE "0651" TO WB-REV1` | TC20 |
| 1099 | `MOVE "20140115" TO WB-ADM-DATE` + `MOVE "0651" TO WB-REV1` | TC25 |
| 1124 | `MOVE "20150115" TO WB-ADM-DATE` + `MOVE "0651" TO WB-REV1` | TC26 |

### Cada substituição individual

Para cada linha, o par exato a substituir é:

```cobol
           MOVE "Y"          TO WB-QIP-IND
```

por:

```cobol
           MOVE "1"          TO WB-QIP-IND
```

> **ATENÇÃO:** Há 7 ocorrências de `MOVE "Y" TO WB-QIP-IND` no arquivo. Todas devem ser
> substituídas — nenhuma usa `"Y"` com semântica diferente. Confirme lendo o arquivo
> antes de editar para ter contexto de cada bloco.

### Verificação (gate check)

```bash
grep -c 'MOVE "Y".*WB-QIP-IND' test/GENDATA.cbl
# DEVE retornar: 0

grep -c 'MOVE "1".*WB-QIP-IND' test/GENDATA.cbl
# DEVE retornar: 7
```

### Saída esperada

```
Status: Complete
Arquivo alterado: test/GENDATA.cbl
Gate check: PASS (0 ocorrências de "Y", 7 ocorrências de "1")
```

---

## T02 — Adicionar INITIALIZE antes do Provider 2 em GENDATA.cbl

**Spec:** REQ-02  
**Arquivo:** `test/GENDATA.cbl`  
**Impacto:** 3 linhas inseridas, sem alteração das linhas existentes

### O que fazer

Adicionar as 3 linhas de INITIALIZE **imediatamente antes** do comentário
`*--- Provider 2: 341235 in CBSA 35614 (New York metro) ---*`.

O bloco atual (aproximadamente linha 260) é:

```cobol
      *--- Provider 2: 341235 in CBSA 35614 (New York metro) ---*
           MOVE "9876543210" TO WS-P-NPI
           MOVE "341235"     TO WS-P-PROV-NO
```

Deve ser substituído por:

```cobol
      *--- Provider 2: 341235 in CBSA 35614 (New York metro) ---*
           INITIALIZE WS-PROV-SEG1
           INITIALIZE WS-PROV-SEG2
           INITIALIZE WS-PROV-SEG3
           MOVE "9876543210" TO WS-P-NPI
           MOVE "341235"     TO WS-P-PROV-NO
```

> **Regra COBOL:** `INITIALIZE` zera campos numéricos e preenche alfanuméricos com espaços,
> garantindo que nenhum campo do Provider 1 seja herdado pelo Provider 2.

### Verificação (gate check)

Ler as linhas em torno da linha do Provider 2 e confirmar a presença dos 3 INITIALIZEs:

```bash
grep -n "INITIALIZE\|Provider 2\|341235" test/GENDATA.cbl | head -10
# DEVE mostrar as 3 linhas INITIALIZE antes de "Provider 2" e "341235"
```

### Saída esperada

```
Status: Complete
Arquivo alterado: test/GENDATA.cbl
Gate check: PASS (3 INITIALIZEs visíveis antes do bloco Provider 2)
```

---

## T03 — Criar run/MSAFILE com entrada MSA 6740

**Spec:** REQ-03  
**Arquivo a criar:** `run/MSAFILE`  
**Tipo:** Arquivo de dados fixo (LINE SEQUENTIAL, IBM ASCII, 80 bytes por registro)

### Contexto para o agente

O `HOSOP210.cbl` (driver de teste) abre `MSAFILE` como LINE SEQUENTIAL opcional.
Lê cada registro para `WS-MSA-IN` (80 bytes), parseando:

```
PIC X(04)  bytes 1–4   WS-MSA-CODE      "6740"
PIC X(01)  byte 5      WS-MSA-LUGAR     " "
PIC X(01)  byte 6      FILLER           " "
PIC X(08)  bytes 7–14  WS-MSA-EFF       "19981001"
PIC X(01)  byte 15     FILLER           " "
PIC 9(02)V9(04) bytes 16–21  WS-MSA-WI-RAW  "010000"  ← = 1.0000
PIC X(59)  bytes 22–80 FILLER           (59 espaços)
```

`HOSDR210` busca no MSA-TABLE pelo par `(MSA-MSA, MSA-LUGAR)`.
Para os 6 casos bloqueados, o par procurado é `("6740", " ")` (LUGAR=" " porque
`FROM-DATE >= 19991001` para TC09/TC29A/TC29B/TC31/TC32 e Provider 341234 tem
`WS-P-LUGAR = " "` para TC30 com `FROM-DATE=19990115`).

### Conteúdo exato do arquivo

Um único registro de 80 bytes (excluindo o newline do LINE SEQUENTIAL):

```
6740  19981001 010000                                                           
^   ^^        ^      ^                                                         ^
|   ||        |      |                                                         |
cols:
1-4  = "6740"  (MSA code)
5    = " "     (LUGAR)
6    = " "     (separator)
7-14 = "19981001" (effective date — cobre todos os FROM-DATEs acima)
15   = " "     (separator)
16-21= "010000" (WI = 01.0000 = 1.0000 — referência neutra para cálculos)
22-80= 59 espaços
```

### Como criar

**Opção 1 — via Python** (recomendado para precisão de bytes):

```python
record = "6740  19981001 010000" + " " * 59
with open("run/MSAFILE", "w", newline="\n") as f:
    f.write(record + "\n")
```

**Opção 2 — via printf/bash** (verificar contagem de espaços):

```bash
printf "6740  19981001 010000%-59s\n" " " > run/MSAFILE
```

**Opção 3 — via create_file** com o conteúdo exato:

```
6740  19981001 010000                                                           
```

(80 chars visíveis + newline)

### Verificação (gate check)

```bash
# Verificar que existe e tem exatamente 1 linha
wc -l run/MSAFILE
# DEVE retornar: 1

# Verificar bytes 1-21 (campos preenchidos)
cut -c1-21 run/MSAFILE
# DEVE retornar: "6740  19981001 010000"

# Verificar comprimento total da linha (sem newline)
awk '{ print length }' run/MSAFILE
# DEVE retornar: 80
```

### Saída esperada

```
Status: Complete
Arquivo criado: run/MSAFILE
Gate check: PASS (1 linha, 80 chars, campos corretos)
```

---

## T04 — Rebuild e execução completa do teste

**Depende de:** T01 + T02 + T03  
**Spec:** REQ-01, REQ-02, REQ-03, REQ-04 (critério de aceite)  
**Diretório de trabalho:** raiz do workspace

### Contexto

Build commands (do `hospice-pricer-setup.md`):

```bash
# Setup de ambiente
export PATH="/d/Projetos/Test-Cobol/Hospice-PC-Pricer/tools/gnucobol32/bin:$PATH"
export COB_CONFIG_DIR="d:/Projetos/Test-Cobol/Hospice-PC-Pricer/tools/gnucobol32/config"
export COB_COPY_DIR="d:/Projetos/Test-Cobol/Hospice-PC-Pricer/tools/gnucobol32/copy"
export COB_LIBRARY_PATH="d:/Projetos/Test-Cobol/Hospice-PC-Pricer/build"
```

### Passo 1 — Strip de line numbers e compilação dos módulos

```bash
cd /d/Projetos/Test-Cobol/Hospice-PC-Pricer

# Strip IBM 6-digit line numbers
sed 's/^[0-9]\{6\}/      /' HOSPRATE > build/copy/HOSPRATE.cpy
sed 's/^[0-9]\{6\}/      /' HOSPR210 > build/HOSPR210.cbl
sed 's/^[0-9]\{6\}/      /' HOSDR210 > build/HOSDR210.cbl
sed -i 's/COPY HOSPRATE\./COPY "HOSPRATE.cpy"./' build/HOSPR210.cbl

# Compilar DLLs
cobc -fixed -std=ibm -m -I build/copy -o build/HOSPR210.dll build/HOSPR210.cbl
cobc -fixed -std=ibm -m -I build/copy -o build/HOSDR210.dll build/HOSDR210.cbl
```

### Passo 2 — Compilar programas de teste

```bash
cobc -fixed -x -o build/GENDATA.exe  test/GENDATA.cbl
cobc -fixed -x -o build/HOSOP210.exe test/HOSOP210.cbl
```

### Passo 3 — Gerar dados e executar

```bash
cd run/
export COB_LIBRARY_PATH="../build"

../build/GENDATA.exe          # Gera PROVFILE + BILLFILE (40 bills)
cp ../CBSA2021 CBSAFILE       # Wage index data (FY2006–FY2021)
# MSAFILE já existe em run/ (criado por T03)

../build/HOSOP210.exe         # Executa pricer, gera RATEFILE
```

### Passo 4 — Verificação dos resultados (gate checks)

Ler `RATEFILE` (LINE SEQUENTIAL, 315 bytes por registro — mas GnuCOBOL pode truncar em 275).
O `WB-TEST-CASE` está nos últimos bytes do registro. Campos chave:
- `BILL-PAY-AMT-TOTAL` (PAY_TOTAL): offset ~267, 8 bytes (9(06)V99)
- `BILL-RTC`: 2 bytes após PAY_TOTAL
- `WB-TEST-CASE`: 8 bytes, near end

**Verificações obrigatórias:**

```bash
# Verificar que HOSOP210 carregou MSA:
# Output deve incluir "MSA records loaded:  1"

# Verificar RTC dos casos problemáticos via grep no RATEFILE:
# (os campos estão em posição fixa, mas com LINE SEQUENTIAL o tamanho pode variar)
# Use a saída de DISPLAY do HOSOP210 para confirmar processamento

# RTC=30 eliminados: TC09, TC29A, TC29B, TC30, TC31, TC32 devem ter RTC≠30
# RTC de QIP corretos: TC05, TC17, TC18, TC19, TC20, TC25, TC26 devem ter RTC=00
# TC06 deve ter resultado consistente sem herdar campos do Provider 1
```

**Script de verificação sugerido:**

```bash
# Mostrar RTC de todos os casos QIP
grep -o "TC[0-9A-Z-]*.\{0,6\}" RATEFILE 2>/dev/null || \
python3 -c "
with open('RATEFILE', 'r') as f:
    for line in f:
        tc = line[267:275].strip() if len(line) > 275 else line[-10:].strip()
        rtc = line[259:261] if len(line) > 261 else '??'
        print(f'TC={tc} RTC={rtc}')
"
```

> **Nota:** O RATEFILE é LINE SEQUENTIAL — registros podem ter tamanho variável
> (ver nota em `hospice-pricer-setup.md`: "LINE SEQUENTIAL output trims trailing spaces").
> Preferir analisar a saída de DISPLAY/CONSOLE do HOSOP210.exe.

### Saída esperada

```
Status: Complete
Compilação: PASS (sem erros de compilação)
Execução: PASS (HOSOP210 processa 40 bills sem abortar)
MSA loaded: 1
Gate checks:
  - TC05/17/18/19/20/25/26: todos com RTC≠30 e pagamento QIP aplicado
  - TC09: RTC=20
  - TC29A/29B/TC30/TC31/TC32: RTC=00
  - TC06: sem RTC=50 (wage index inválido)
```

---

## T05 — Verificar WI=0 em TC01–TC07 (pós-confirmação)

**Depende de:** T04  
**Spec:** REQ-04  
**Tipo:** Análise de saída — pode não requerer mudanças em código

### O que fazer

Após a execução de T04, inspecionar o RATEFILE para TC01–TC07 e verificar:

1. O campo `BILL-PROV-WAGE-INDEX` na saída é **diferente de zero** para esses casos.
   - Se sim: HOSDR210 está preenchendo corretamente via CBSA lookup. `MOVE ZEROS`
     no GENDATA não é problema. **Nenhuma correção necessária.**
   - Se não (permanece zero): há um problema no CBSA lookup para CBSA 16740.
     Investigar se CBSA2021 tem entrada para "16740" com uma data efetiva
     compatível com `FROM-DATE` dos casos.

2. Para TC01 (FROM=20210115, CBSA 16740 FY2021): O CBSA2021 deve ter uma entrada
   para `16740` com `EFFDTE <= 20210115` e dentro do FY2021 (`>= 20201001`).

**Verificação:**

```bash
# Buscar CBSA 16740 no CBSA2021
grep "^16740" CBSA2021 | head -5
# DEVE mostrar pelo menos 1 linha com data efetiva dentro de FY2021
```

### Saída esperada

```
Status: Complete (ou Informação)
Resultado: WI=zero-or-nonzero (documentar o achado)
Ação: Nenhuma correção necessária (se WI != 0) OU criar task T06 para corrigir
```

---

## Instruções para o Agente Orquestrador

1. **Executar T01, T02, T03 em paralelo** (agentes independentes, sem dependência)
2. **Aguardar conclusão de T01+T02+T03** antes de iniciar T04
3. **T04 executa no mesmo terminal bash** configurado com o PATH do GnuCOBOL
4. **T05 é opcional** e deve ser executado após T04 para fechar o REQ-04
5. **Se um sub-agente reportar BLOCKED**, escalar para o orquestrador com o erro exato
   e o estado do arquivo no momento do bloqueio

### Contexto que cada sub-agente precisa

Para **T01** e **T02**: pathnames absolutos de GENDATA.cbl + esta tasks.md  
Para **T03**: apenas o formato do MSAFILE descrito acima e o path `run/MSAFILE`  
Para **T04**: hospice-pricer-setup.md + paths de todos os arquivos envolvidos  
Para **T05**: saída do T04 (console output de HOSOP210) + PATH de CBSA2021

### Workspace root

```
d:\Projetos\Test-Cobol\Hospice-PC-Pricer\
```

### Arquivos-chave por tarefa

| Tarefa | Lê | Escreve |
|--------|-----|---------|
| T01 | test/GENDATA.cbl | test/GENDATA.cbl |
| T02 | test/GENDATA.cbl | test/GENDATA.cbl |
| T03 | — | run/MSAFILE |
| T04 | HOSDR210, HOSPR210, HOSPRATE, test/*.cbl, run/* | build/*, run/PROVFILE, run/BILLFILE, run/RATEFILE |
| T05 | run/RATEFILE, CBSA2021 | — (somente leitura) |
