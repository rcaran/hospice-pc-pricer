       IDENTIFICATION DIVISION.
       PROGRAM-ID. GENDATA.
      *================================================================*
      * GENDATA - Generate sample test data files for Hospice Pricer   *
      *                                                                *
      * Creates:                                                       *
      *   - PROVFILE: Sample provider records (240 bytes each)         *
      *   - BILLFILE: Sample bill records (315 bytes each)             *
      *                                                                *
      * Revenue codes:                                                 *
      *   0651 = Routine Home Care (RHC)                               *
      *   0652 = Continuous Home Care (CHC)                            *
      *   0655 = Inpatient Respite Care (IRC)                          *
      *   0656 = General Inpatient Care (GIC)                          *
      *================================================================*
       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       SOURCE-COMPUTER. X86-64.
       OBJECT-COMPUTER. X86-64.

       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT PROVFILE ASSIGN TO "PROVFILE"
               ORGANIZATION IS LINE SEQUENTIAL
               FILE STATUS IS WS-PROV-STATUS.
           SELECT BILLFILE ASSIGN TO "BILLFILE"
               ORGANIZATION IS LINE SEQUENTIAL
               FILE STATUS IS WS-BILL-STATUS.

       DATA DIVISION.
       FILE SECTION.

       FD  PROVFILE.
       01  PROV-OUT-RECORD            PIC X(240).

       FD  BILLFILE.
       01  BILL-OUT-RECORD            PIC X(315).

       WORKING-STORAGE SECTION.
       01  WS-PROV-STATUS             PIC XX.
       01  WS-BILL-STATUS             PIC XX.

      *---------------------------------------------------------------*
      * Provider record layout (240 bytes = 3 x 80 segments)
      * Seg1(80): NPI(10) + ProvNo(6) + EffDate(8) + FYBegin(8) +
      *           ReportDate(8) + TermDate(8) + WaiverCode(1) +
      *           InterNo(5) + ProvType(2) + CensusDIV(1) +
      *           MSA-DATA(13) + SCH-YR(2) + LUGAR(1) +
      *           TempRelief(1) + FedPPS(1) + Filler(5)
      * Seg2(80): Variables(~42) + CBSA-DATA(~18) + filler
      * Seg3(80): Pass amounts + Capital data + filler
      *---------------------------------------------------------------*
       01  WS-PROV-SEG1.
           05  WS-P-NPI               PIC X(10).
           05  WS-P-PROV-NO           PIC X(06).
           05  WS-P-EFF-DATE          PIC X(08).
           05  WS-P-FY-BEG-DATE       PIC X(08).
           05  WS-P-REPORT-DATE       PIC X(08).
           05  WS-P-TERM-DATE         PIC X(08).
           05  WS-P-WAIVER-CODE       PIC X(01).
           05  WS-P-INTER-NO          PIC 9(05).
           05  WS-P-PROV-TYPE         PIC X(02).
           05  WS-P-CENSUS-DIV        PIC 9(01).
           05  WS-P-MSA-DATA.
               10  WS-P-CHG-CODE-IDX  PIC X.
               10  WS-P-GEO-LOC-MSA   PIC X(04).
               10  WS-P-WI-LOC-MSA    PIC X(04).
               10  WS-P-STD-AMT-MSA   PIC X(04).
           05  WS-P-SCH-YR            PIC XX.
           05  WS-P-LUGAR             PIC X.
           05  WS-P-TEMP-RELIEF       PIC X.
           05  WS-P-FED-PPS           PIC X.
           05  FILLER                  PIC X(05).

       01  WS-PROV-SEG2.
           05  WS-P-FAC-SPEC-RATE     PIC 9(05)V9(02).
           05  WS-P-COLA              PIC 9(01)V9(03).
           05  WS-P-INTERN-RATIO      PIC 9(01)V9(04).
           05  WS-P-BED-SIZE          PIC 9(05).
           05  WS-P-OPER-CCR          PIC 9(01)V9(03).
           05  WS-P-CMI               PIC 9(01)V9(04).
           05  WS-P-SSI-RATIO         PIC V9(04).
           05  WS-P-MEDICAID-RATIO    PIC V9(04).
           05  WS-P-PPS-BLEND-IND     PIC X(01).
           05  WS-P-PRUP-UPDATE       PIC 9(01)V9(05).
           05  WS-P-DSH-PERCENT       PIC V9(04).
           05  WS-P-FYE-DATE          PIC 9(08).
           05  WS-P-CBSA-SPEC-PAY     PIC X.
           05  WS-P-CBSA-HOSP-QUAL    PIC X.
           05  WS-P-CBSA-GEO-LOC      PIC X(05).
           05  WS-P-CBSA-RECLASS-LOC  PIC X(05).
           05  WS-P-CBSA-STD-AMT-LOC  PIC X(05).
           05  WS-P-CBSA-SPEC-WI      PIC 9(02)V9(04).

       01  WS-PROV-SEG3.
           05  WS-P-PASS-CAP          PIC 9(04)V99.
           05  WS-P-PASS-DME          PIC 9(04)V99.
           05  WS-P-PASS-ORG          PIC 9(04)V99.
           05  WS-P-PASS-MISC         PIC 9(04)V99.
           05  WS-P-CAPI-PPS-CODE     PIC X.
           05  WS-P-CAPI-HSR          PIC 9(04)V99.
           05  WS-P-CAPI-OHR          PIC 9(04)V99.
           05  WS-P-CAPI-NHR          PIC 9(01)V9999.
           05  WS-P-CAPI-CCR          PIC 9V999.
           05  WS-P-CAPI-NEW-HOSP     PIC X.
           05  WS-P-CAPI-IME          PIC 9V9999.
           05  WS-P-CAPI-EXCEP        PIC 9(04)V99.
           05  WS-P-VAL-BASED-SCORE   PIC 9V999.
           05  FILLER                  PIC X(18).

       01  WS-PROV-FULL.
           05  WS-PROV-FULL-S1        PIC X(80).
           05  WS-PROV-FULL-S2        PIC X(80).
           05  WS-PROV-FULL-S3        PIC X(80).

      *---------------------------------------------------------------*
      * Bill record layout (315 bytes)
      *---------------------------------------------------------------*
       01  WS-BILL.
           10  WB-NPI                  PIC X(10).
           10  WB-PROV-NO             PIC X(06).
           10  WB-FROM-DATE           PIC X(08).
           10  WB-ADM-DATE            PIC X(08).
           10  WB-FILLER1             PIC X(10).
           10  WB-PROV-CBSA           PIC X(05).
           10  WB-BENE-CBSA           PIC X(05).
           10  WB-PROV-WAGE           PIC 9(02)V9(04).
           10  WB-BENE-WAGE           PIC 9(02)V9(04).
           10  WB-SIA-UNITS.
               15  WB-NA-DAY1-UNITS   PIC 99.
               15  WB-NA-DAY2-UNITS   PIC 99.
               15  WB-EOL-DAY1-UNITS  PIC 99.
               15  WB-EOL-DAY2-UNITS  PIC 99.
               15  WB-EOL-DAY3-UNITS  PIC 99.
               15  WB-EOL-DAY4-UNITS  PIC 99.
               15  WB-EOL-DAY5-UNITS  PIC 99.
               15  WB-EOL-DAY6-UNITS  PIC 99.
               15  WB-EOL-DAY7-UNITS  PIC 99.
           10  WB-FILLER2             PIC X(10).
           10  WB-QIP-IND             PIC X.
           10  WB-REV1                PIC X(04).
           10  WB-HCPC1               PIC X(05).
           10  WB-DOS1                PIC X(08).
           10  WB-UNITS1              PIC 9(07).
           10  WB-PAY1                PIC 9(06)V99.
           10  WB-REV2                PIC X(04).
           10  WB-HCPC2               PIC X(05).
           10  WB-DOS2                PIC X(08).
           10  WB-UNITS2              PIC 9(07).
           10  WB-PAY2                PIC 9(06)V99.
           10  WB-REV3                PIC X(04).
           10  WB-HCPC3               PIC X(05).
           10  WB-DOS3                PIC X(08).
           10  WB-UNITS3              PIC 9(07).
           10  WB-PAY3                PIC 9(06)V99.
           10  WB-REV4                PIC X(04).
           10  WB-HCPC4               PIC X(05).
           10  WB-DOS4                PIC X(08).
           10  WB-UNITS4              PIC 9(07).
           10  WB-PAY4                PIC 9(06)V99.
           10  WB-SIA-PYMTS.
               15  WB-NA-DAY1-PAY     PIC 9(06)V99.
               15  WB-NA-DAY2-PAY     PIC 9(06)V99.
               15  WB-EOL-DAY1-PAY    PIC 9(06)V99.
               15  WB-EOL-DAY2-PAY    PIC 9(06)V99.
               15  WB-EOL-DAY3-PAY    PIC 9(06)V99.
               15  WB-EOL-DAY4-PAY    PIC 9(06)V99.
               15  WB-EOL-DAY5-PAY    PIC 9(06)V99.
               15  WB-EOL-DAY6-PAY    PIC 9(06)V99.
               15  WB-EOL-DAY7-PAY    PIC 9(06)V99.
           10  WB-PAY-TOTAL           PIC 9(06)V99.
           10  WB-RTC                 PIC XX.
           10  WB-HIGH-RHC-DAYS       PIC 99.
           10  WB-LOW-RHC-DAYS        PIC 99.
           10  WB-TEST-CASE           PIC X(08).

       PROCEDURE DIVISION.

       0000-MAIN.
           DISPLAY "Generating test data files..."

           PERFORM 1000-CREATE-PROV-FILE
              THRU 1000-CREATE-PROV-EXIT

           PERFORM 2000-CREATE-BILL-FILE
              THRU 2000-CREATE-BILL-EXIT

           DISPLAY "Test data generation complete."
           STOP RUN.


      *================================================================*
      * 1000 - CREATE PROVIDER FILE
      *================================================================*
       1000-CREATE-PROV-FILE.
           OPEN OUTPUT PROVFILE

           INITIALIZE WS-PROV-SEG1
           INITIALIZE WS-PROV-SEG2
           INITIALIZE WS-PROV-SEG3

      *--- Provider 1: 341234 in CBSA 16740 (Charlotte NC) ---*
           MOVE "1234567890" TO WS-P-NPI
           MOVE "341234"     TO WS-P-PROV-NO
           MOVE "20200101"   TO WS-P-EFF-DATE
           MOVE "20201001"   TO WS-P-FY-BEG-DATE
           MOVE "20200101"   TO WS-P-REPORT-DATE
           MOVE "00000000"   TO WS-P-TERM-DATE
           MOVE "N"          TO WS-P-WAIVER-CODE
           MOVE 00000        TO WS-P-INTER-NO
           MOVE "00"         TO WS-P-PROV-TYPE
           MOVE 3            TO WS-P-CENSUS-DIV
           MOVE " "          TO WS-P-CHG-CODE-IDX
           MOVE "6740"       TO WS-P-GEO-LOC-MSA
           MOVE "6740"       TO WS-P-WI-LOC-MSA
           MOVE "6740"       TO WS-P-STD-AMT-MSA
           MOVE "  "         TO WS-P-SCH-YR
           MOVE " "          TO WS-P-LUGAR
           MOVE " "          TO WS-P-TEMP-RELIEF
           MOVE " "          TO WS-P-FED-PPS

           MOVE 0            TO WS-P-FAC-SPEC-RATE
           MOVE 0            TO WS-P-COLA
           MOVE 0            TO WS-P-INTERN-RATIO
           MOVE 0            TO WS-P-BED-SIZE
           MOVE 0            TO WS-P-OPER-CCR
           MOVE 0            TO WS-P-CMI
           MOVE 0            TO WS-P-SSI-RATIO
           MOVE 0            TO WS-P-MEDICAID-RATIO
           MOVE " "          TO WS-P-PPS-BLEND-IND
           MOVE 0            TO WS-P-PRUP-UPDATE
           MOVE 0            TO WS-P-DSH-PERCENT
           MOVE 20201001     TO WS-P-FYE-DATE
           MOVE "N"          TO WS-P-CBSA-SPEC-PAY
           MOVE " "          TO WS-P-CBSA-HOSP-QUAL
           MOVE "16740"      TO WS-P-CBSA-GEO-LOC
           MOVE "     "      TO WS-P-CBSA-RECLASS-LOC
           MOVE "16740"      TO WS-P-CBSA-STD-AMT-LOC
           MOVE 0            TO WS-P-CBSA-SPEC-WI

           MOVE 0            TO WS-P-PASS-CAP
           MOVE 0            TO WS-P-PASS-DME
           MOVE 0            TO WS-P-PASS-ORG
           MOVE 0            TO WS-P-PASS-MISC
           MOVE " "          TO WS-P-CAPI-PPS-CODE
           MOVE 0            TO WS-P-CAPI-HSR
           MOVE 0            TO WS-P-CAPI-OHR
           MOVE 0            TO WS-P-CAPI-NHR
           MOVE 0            TO WS-P-CAPI-CCR
           MOVE " "          TO WS-P-CAPI-NEW-HOSP
           MOVE 0            TO WS-P-CAPI-IME
           MOVE 0            TO WS-P-CAPI-EXCEP
           MOVE 0            TO WS-P-VAL-BASED-SCORE

           MOVE WS-PROV-SEG1 TO WS-PROV-FULL-S1
           MOVE WS-PROV-SEG2 TO WS-PROV-FULL-S2
           MOVE WS-PROV-SEG3 TO WS-PROV-FULL-S3
           WRITE PROV-OUT-RECORD FROM WS-PROV-FULL

      *--- Provider 2: 341235 in CBSA 35614 (New York metro) ---*
           INITIALIZE WS-PROV-SEG1
           INITIALIZE WS-PROV-SEG2
           INITIALIZE WS-PROV-SEG3
           MOVE "9876543210" TO WS-P-NPI
           MOVE "341235"     TO WS-P-PROV-NO
           MOVE "20190101"   TO WS-P-EFF-DATE
           MOVE "20191001"   TO WS-P-FY-BEG-DATE
           MOVE "20190101"   TO WS-P-REPORT-DATE
           MOVE "00000000"   TO WS-P-TERM-DATE
           MOVE "35614"      TO WS-P-CBSA-GEO-LOC
           MOVE "35614"      TO WS-P-CBSA-STD-AMT-LOC

           MOVE WS-PROV-SEG1 TO WS-PROV-FULL-S1
           MOVE WS-PROV-SEG2 TO WS-PROV-FULL-S2
           MOVE WS-PROV-SEG3 TO WS-PROV-FULL-S3
           WRITE PROV-OUT-RECORD FROM WS-PROV-FULL

      *--- Provider 3: 341236 in CBSA 10180 (Abilene TX, FY2006-FY2021) ---*
           INITIALIZE WS-PROV-SEG1
           INITIALIZE WS-PROV-SEG2
           INITIALIZE WS-PROV-SEG3
           MOVE "5555555555" TO WS-P-NPI
           MOVE "341236"     TO WS-P-PROV-NO
           MOVE "20150101"   TO WS-P-EFF-DATE
           MOVE "20151001"   TO WS-P-FY-BEG-DATE
           MOVE "20150101"   TO WS-P-REPORT-DATE
           MOVE "00000000"   TO WS-P-TERM-DATE
           MOVE "N"          TO WS-P-WAIVER-CODE
           MOVE 00000        TO WS-P-INTER-NO
           MOVE "00"         TO WS-P-PROV-TYPE
           MOVE 3            TO WS-P-CENSUS-DIV
           MOVE " "          TO WS-P-CHG-CODE-IDX
           MOVE "0180"       TO WS-P-GEO-LOC-MSA
           MOVE "0180"       TO WS-P-WI-LOC-MSA
           MOVE "0180"       TO WS-P-STD-AMT-MSA
           MOVE "  "         TO WS-P-SCH-YR
           MOVE " "          TO WS-P-LUGAR
           MOVE " "          TO WS-P-TEMP-RELIEF
           MOVE " "          TO WS-P-FED-PPS
           MOVE 0            TO WS-P-FAC-SPEC-RATE
           MOVE 0            TO WS-P-COLA
           MOVE 0            TO WS-P-INTERN-RATIO
           MOVE 0            TO WS-P-BED-SIZE
           MOVE 0            TO WS-P-OPER-CCR
           MOVE 0            TO WS-P-CMI
           MOVE 0            TO WS-P-SSI-RATIO
           MOVE 0            TO WS-P-MEDICAID-RATIO
           MOVE " "          TO WS-P-PPS-BLEND-IND
           MOVE 0            TO WS-P-PRUP-UPDATE
           MOVE 0            TO WS-P-DSH-PERCENT
           MOVE 20151001     TO WS-P-FYE-DATE
           MOVE "N"          TO WS-P-CBSA-SPEC-PAY
           MOVE " "          TO WS-P-CBSA-HOSP-QUAL
           MOVE "10180"      TO WS-P-CBSA-GEO-LOC
           MOVE "     "      TO WS-P-CBSA-RECLASS-LOC
           MOVE "10180"      TO WS-P-CBSA-STD-AMT-LOC
           MOVE 0            TO WS-P-CBSA-SPEC-WI
           MOVE 0            TO WS-P-PASS-CAP
           MOVE 0            TO WS-P-PASS-DME
           MOVE 0            TO WS-P-PASS-ORG
           MOVE 0            TO WS-P-PASS-MISC
           MOVE " "          TO WS-P-CAPI-PPS-CODE
           MOVE 0            TO WS-P-CAPI-HSR
           MOVE 0            TO WS-P-CAPI-OHR
           MOVE 0            TO WS-P-CAPI-NHR
           MOVE 0            TO WS-P-CAPI-CCR
           MOVE " "          TO WS-P-CAPI-NEW-HOSP
           MOVE 0            TO WS-P-CAPI-IME
           MOVE 0            TO WS-P-CAPI-EXCEP
           MOVE 0            TO WS-P-VAL-BASED-SCORE
           MOVE WS-PROV-SEG1 TO WS-PROV-FULL-S1
           MOVE WS-PROV-SEG2 TO WS-PROV-FULL-S2
           MOVE WS-PROV-SEG3 TO WS-PROV-FULL-S3
           WRITE PROV-OUT-RECORD FROM WS-PROV-FULL

           CLOSE PROVFILE
           DISPLAY "PROVFILE: 3 providers created".

       1000-CREATE-PROV-EXIT. EXIT.


      *================================================================*
      * 2000 - CREATE BILL FILE
      *================================================================*
       2000-CREATE-BILL-FILE.
           OPEN OUTPUT BILLFILE

      *--- Test Case 1: FY2021, RHC (0651), normal - CBSA 16740 ---*
           INITIALIZE WS-BILL
           MOVE "1234567890" TO WB-NPI
           MOVE "341234"     TO WB-PROV-NO
           MOVE "20210115"   TO WB-FROM-DATE
           MOVE "20201001"   TO WB-ADM-DATE
           MOVE "16740"      TO WB-PROV-CBSA
           MOVE "16740"      TO WB-BENE-CBSA
           MOVE ZEROS        TO WB-PROV-WAGE
           MOVE ZEROS        TO WB-BENE-WAGE
           MOVE ZEROS        TO WB-SIA-UNITS
           MOVE " "          TO WB-QIP-IND
           MOVE "0651"       TO WB-REV1
           MOVE "     "      TO WB-HCPC1
           MOVE "20210115"   TO WB-DOS1
           MOVE 0000030      TO WB-UNITS1
           MOVE ZEROS        TO WB-PAY1
           MOVE SPACES       TO WB-REV2
           MOVE ZEROS        TO WB-UNITS2
           MOVE SPACES       TO WB-REV3
           MOVE ZEROS        TO WB-UNITS3
           MOVE SPACES       TO WB-REV4
           MOVE ZEROS        TO WB-UNITS4
           MOVE ZEROS        TO WB-SIA-PYMTS
           MOVE "TC01    "   TO WB-TEST-CASE
           WRITE BILL-OUT-RECORD FROM WS-BILL

      *--- Test Case 2: FY2021, CHC (0652) ---*
           INITIALIZE WS-BILL
           MOVE "1234567890" TO WB-NPI
           MOVE "341234"     TO WB-PROV-NO
           MOVE "20210220"   TO WB-FROM-DATE
           MOVE "20210215"   TO WB-ADM-DATE
           MOVE "16740"      TO WB-PROV-CBSA
           MOVE "16740"      TO WB-BENE-CBSA
           MOVE ZEROS        TO WB-PROV-WAGE
           MOVE ZEROS        TO WB-BENE-WAGE
           MOVE ZEROS        TO WB-SIA-UNITS
           MOVE " "          TO WB-QIP-IND
           MOVE "0652"       TO WB-REV1
           MOVE "     "      TO WB-HCPC1
           MOVE "20210220"   TO WB-DOS1
           MOVE 0000010      TO WB-UNITS1
           MOVE ZEROS        TO WB-PAY1
           MOVE SPACES       TO WB-REV2
           MOVE ZEROS        TO WB-UNITS2
           MOVE SPACES       TO WB-REV3
           MOVE ZEROS        TO WB-UNITS3
           MOVE SPACES       TO WB-REV4
           MOVE ZEROS        TO WB-UNITS4
           MOVE ZEROS        TO WB-SIA-PYMTS
           MOVE "TC02    "   TO WB-TEST-CASE
           WRITE BILL-OUT-RECORD FROM WS-BILL

      *--- Test Case 3: FY2021, IRC (0655) ---*
           INITIALIZE WS-BILL
           MOVE "1234567890" TO WB-NPI
           MOVE "341234"     TO WB-PROV-NO
           MOVE "20210310"   TO WB-FROM-DATE
           MOVE "20210308"   TO WB-ADM-DATE
           MOVE "16740"      TO WB-PROV-CBSA
           MOVE "16740"      TO WB-BENE-CBSA
           MOVE ZEROS        TO WB-PROV-WAGE
           MOVE ZEROS        TO WB-BENE-WAGE
           MOVE ZEROS        TO WB-SIA-UNITS
           MOVE " "          TO WB-QIP-IND
           MOVE "0655"       TO WB-REV1
           MOVE "     "      TO WB-HCPC1
           MOVE "20210310"   TO WB-DOS1
           MOVE 0000005      TO WB-UNITS1
           MOVE ZEROS        TO WB-PAY1
           MOVE SPACES       TO WB-REV2
           MOVE ZEROS        TO WB-UNITS2
           MOVE SPACES       TO WB-REV3
           MOVE ZEROS        TO WB-UNITS3
           MOVE SPACES       TO WB-REV4
           MOVE ZEROS        TO WB-UNITS4
           MOVE ZEROS        TO WB-SIA-PYMTS
           MOVE "TC03    "   TO WB-TEST-CASE
           WRITE BILL-OUT-RECORD FROM WS-BILL

      *--- Test Case 4: FY2021, GIC (0656) ---*
           INITIALIZE WS-BILL
           MOVE "1234567890" TO WB-NPI
           MOVE "341234"     TO WB-PROV-NO
           MOVE "20210401"   TO WB-FROM-DATE
           MOVE "20210325"   TO WB-ADM-DATE
           MOVE "16740"      TO WB-PROV-CBSA
           MOVE "16740"      TO WB-BENE-CBSA
           MOVE ZEROS        TO WB-PROV-WAGE
           MOVE ZEROS        TO WB-BENE-WAGE
           MOVE ZEROS        TO WB-SIA-UNITS
           MOVE " "          TO WB-QIP-IND
           MOVE "0656"       TO WB-REV1
           MOVE "     "      TO WB-HCPC1
           MOVE "20210401"   TO WB-DOS1
           MOVE 0000007      TO WB-UNITS1
           MOVE ZEROS        TO WB-PAY1
           MOVE SPACES       TO WB-REV2
           MOVE ZEROS        TO WB-UNITS2
           MOVE SPACES       TO WB-REV3
           MOVE ZEROS        TO WB-UNITS3
           MOVE SPACES       TO WB-REV4
           MOVE ZEROS        TO WB-UNITS4
           MOVE ZEROS        TO WB-SIA-PYMTS
           MOVE "TC04    "   TO WB-TEST-CASE
           WRITE BILL-OUT-RECORD FROM WS-BILL

      *--- Test Case 5: FY2021, RHC with QIP reduction ---*
           INITIALIZE WS-BILL
           MOVE "1234567890" TO WB-NPI
           MOVE "341234"     TO WB-PROV-NO
           MOVE "20210501"   TO WB-FROM-DATE
           MOVE "20210101"   TO WB-ADM-DATE
           MOVE "16740"      TO WB-PROV-CBSA
           MOVE "16740"      TO WB-BENE-CBSA
           MOVE ZEROS        TO WB-PROV-WAGE
           MOVE ZEROS        TO WB-BENE-WAGE
           MOVE ZEROS        TO WB-SIA-UNITS
           MOVE "1"          TO WB-QIP-IND
           MOVE "0651"       TO WB-REV1
           MOVE "     "      TO WB-HCPC1
           MOVE "20210501"   TO WB-DOS1
           MOVE 0000020      TO WB-UNITS1
           MOVE ZEROS        TO WB-PAY1
           MOVE SPACES       TO WB-REV2
           MOVE ZEROS        TO WB-UNITS2
           MOVE SPACES       TO WB-REV3
           MOVE ZEROS        TO WB-UNITS3
           MOVE SPACES       TO WB-REV4
           MOVE ZEROS        TO WB-UNITS4
           MOVE ZEROS        TO WB-SIA-PYMTS
           MOVE "TC05-QIP"   TO WB-TEST-CASE
           WRITE BILL-OUT-RECORD FROM WS-BILL

      *--- Test Case 6: FY2020, RHC (0651), CBSA 35614 (NYC metro) ---*
           INITIALIZE WS-BILL
           MOVE "9876543210" TO WB-NPI
           MOVE "341235"     TO WB-PROV-NO
           MOVE "20200315"   TO WB-FROM-DATE
           MOVE "20200101"   TO WB-ADM-DATE
           MOVE "35614"      TO WB-PROV-CBSA
           MOVE "35614"      TO WB-BENE-CBSA
           MOVE ZEROS        TO WB-PROV-WAGE
           MOVE ZEROS        TO WB-BENE-WAGE
           MOVE ZEROS        TO WB-SIA-UNITS
           MOVE " "          TO WB-QIP-IND
           MOVE "0651"       TO WB-REV1
           MOVE "     "      TO WB-HCPC1
           MOVE "20200315"   TO WB-DOS1
           MOVE 0000015      TO WB-UNITS1
           MOVE ZEROS        TO WB-PAY1
           MOVE SPACES       TO WB-REV2
           MOVE ZEROS        TO WB-UNITS2
           MOVE SPACES       TO WB-REV3
           MOVE ZEROS        TO WB-UNITS3
           MOVE SPACES       TO WB-REV4
           MOVE ZEROS        TO WB-UNITS4
           MOVE ZEROS        TO WB-SIA-PYMTS
           MOVE "TC06-20 "   TO WB-TEST-CASE
           WRITE BILL-OUT-RECORD FROM WS-BILL

      *--- Test Case 7: FY2021 RHC with SIA EOL add-on ---*
           INITIALIZE WS-BILL
           MOVE "1234567890" TO WB-NPI
           MOVE "341234"     TO WB-PROV-NO
           MOVE "20210601"   TO WB-FROM-DATE
           MOVE "20210101"   TO WB-ADM-DATE
           MOVE "16740"      TO WB-PROV-CBSA
           MOVE "16740"      TO WB-BENE-CBSA
           MOVE ZEROS        TO WB-PROV-WAGE
           MOVE ZEROS        TO WB-BENE-WAGE
           MOVE 00           TO WB-NA-DAY1-UNITS
           MOVE 00           TO WB-NA-DAY2-UNITS
           MOVE 08           TO WB-EOL-DAY1-UNITS
           MOVE 10           TO WB-EOL-DAY2-UNITS
           MOVE 00           TO WB-EOL-DAY3-UNITS
           MOVE 00           TO WB-EOL-DAY4-UNITS
           MOVE 00           TO WB-EOL-DAY5-UNITS
           MOVE 00           TO WB-EOL-DAY6-UNITS
           MOVE 00           TO WB-EOL-DAY7-UNITS
           MOVE " "          TO WB-QIP-IND
           MOVE "0651"       TO WB-REV1
           MOVE "     "      TO WB-HCPC1
           MOVE "20210601"   TO WB-DOS1
           MOVE 0000025      TO WB-UNITS1
           MOVE ZEROS        TO WB-PAY1
           MOVE SPACES       TO WB-REV2
           MOVE ZEROS        TO WB-UNITS2
           MOVE SPACES       TO WB-REV3
           MOVE ZEROS        TO WB-UNITS3
           MOVE SPACES       TO WB-REV4
           MOVE ZEROS        TO WB-UNITS4
           MOVE ZEROS        TO WB-SIA-PYMTS
           MOVE "TC07-SIA"   TO WB-TEST-CASE
           WRITE BILL-OUT-RECORD FROM WS-BILL


      *============================================================*
      * PHASE 1 — P1: VALIDATION CASES (TC08-TC09)
      *============================================================*

      *--- TC08: RTC=10 — UNITS1 > 1,000 ---*
           INITIALIZE WS-BILL
           MOVE "1234567890" TO WB-NPI
           MOVE "341234"     TO WB-PROV-NO
           MOVE "20210115"   TO WB-FROM-DATE
           MOVE "20210110"   TO WB-ADM-DATE
           MOVE "16740"      TO WB-PROV-CBSA
           MOVE "16740"      TO WB-BENE-CBSA
           MOVE ZEROS        TO WB-SIA-UNITS
           MOVE " "          TO WB-QIP-IND
           MOVE "0651"       TO WB-REV1
           MOVE "     "      TO WB-HCPC1
           MOVE "20210115"   TO WB-DOS1
           MOVE 0001500      TO WB-UNITS1
           MOVE ZEROS        TO WB-PAY1
           MOVE SPACES       TO WB-REV2
           MOVE ZEROS        TO WB-UNITS2
           MOVE SPACES       TO WB-REV3
           MOVE ZEROS        TO WB-UNITS3
           MOVE SPACES       TO WB-REV4
           MOVE ZEROS        TO WB-UNITS4
           MOVE ZEROS        TO WB-SIA-PYMTS
           MOVE "TC08    "   TO WB-TEST-CASE
           WRITE BILL-OUT-RECORD FROM WS-BILL

      *--- TC08B: RTC=10 — UNITS2 > 1,000 ---*
           INITIALIZE WS-BILL
           MOVE "1234567890" TO WB-NPI
           MOVE "341234"     TO WB-PROV-NO
           MOVE "20210115"   TO WB-FROM-DATE
           MOVE "20210110"   TO WB-ADM-DATE
           MOVE "16740"      TO WB-PROV-CBSA
           MOVE "16740"      TO WB-BENE-CBSA
           MOVE ZEROS        TO WB-SIA-UNITS
           MOVE " "          TO WB-QIP-IND
           MOVE "0651"       TO WB-REV1
           MOVE "     "      TO WB-HCPC1
           MOVE "20210115"   TO WB-DOS1
           MOVE 0000010      TO WB-UNITS1
           MOVE ZEROS        TO WB-PAY1
           MOVE "0652"       TO WB-REV2
           MOVE "     "      TO WB-HCPC2
           MOVE "20210115"   TO WB-DOS2
           MOVE 0001500      TO WB-UNITS2
           MOVE ZEROS        TO WB-PAY2
           MOVE SPACES       TO WB-REV3
           MOVE ZEROS        TO WB-UNITS3
           MOVE SPACES       TO WB-REV4
           MOVE ZEROS        TO WB-UNITS4
           MOVE ZEROS        TO WB-SIA-PYMTS
           MOVE "TC08B   "   TO WB-TEST-CASE
           WRITE BILL-OUT-RECORD FROM WS-BILL

      *--- TC09: RTC=20 — 0652 < 8 units FY2005 (needs MSAFILE) ---*
      *   Without MSAFILE: gets RTC=30 (MSA lookup fails)
      *   With MSAFILE: pricer validates < 8h → RTC=20
      *   NOTE: 0652 must be in REV2 — pricer checks BILL-REV2 only
           INITIALIZE WS-BILL
           MOVE "1234567890" TO WB-NPI
           MOVE "341234"     TO WB-PROV-NO
           MOVE "20050115"   TO WB-FROM-DATE
           MOVE "20050115"   TO WB-ADM-DATE
           MOVE "6740 "      TO WB-PROV-CBSA
           MOVE "6740 "      TO WB-BENE-CBSA
           MOVE ZEROS        TO WB-SIA-UNITS
           MOVE " "          TO WB-QIP-IND
           MOVE SPACES       TO WB-REV1
           MOVE ZEROS        TO WB-UNITS1
           MOVE "0652"       TO WB-REV2
           MOVE "     "      TO WB-HCPC2
           MOVE "20050115"   TO WB-DOS2
           MOVE 0000005      TO WB-UNITS2
           MOVE ZEROS        TO WB-PAY2
           MOVE SPACES       TO WB-REV3
           MOVE ZEROS        TO WB-UNITS3
           MOVE SPACES       TO WB-REV4
           MOVE ZEROS        TO WB-UNITS4
           MOVE ZEROS        TO WB-SIA-PYMTS
           MOVE "TC09    "   TO WB-TEST-CASE
           WRITE BILL-OUT-RECORD FROM WS-BILL

      *============================================================*
      * PHASE 3 — P1: RHC 60-DAY SCENARIOS (TC10-TC13)
      *============================================================*

      *--- TC10: RHC ALL HIGH — UNITS <= HIGH-RATE-DAYS-LEFT ---*
      *   ADM=20210110, FROM=20210115: PRIOR=5, HIGH-LEFT=55
      *   UNITS=10 <= 55 → ALL HIGH, RTC=75
           INITIALIZE WS-BILL
           MOVE "1234567890" TO WB-NPI
           MOVE "341234"     TO WB-PROV-NO
           MOVE "20210115"   TO WB-FROM-DATE
           MOVE "20210110"   TO WB-ADM-DATE
           MOVE "16740"      TO WB-PROV-CBSA
           MOVE "16740"      TO WB-BENE-CBSA
           MOVE ZEROS        TO WB-SIA-UNITS
           MOVE " "          TO WB-QIP-IND
           MOVE "0651"       TO WB-REV1
           MOVE "     "      TO WB-HCPC1
           MOVE "20210115"   TO WB-DOS1
           MOVE 0000010      TO WB-UNITS1
           MOVE ZEROS        TO WB-PAY1
           MOVE SPACES       TO WB-REV2
           MOVE ZEROS        TO WB-UNITS2
           MOVE SPACES       TO WB-REV3
           MOVE ZEROS        TO WB-UNITS3
           MOVE SPACES       TO WB-REV4
           MOVE ZEROS        TO WB-UNITS4
           MOVE ZEROS        TO WB-SIA-PYMTS
           MOVE "TC10    "   TO WB-TEST-CASE
           WRITE BILL-OUT-RECORD FROM WS-BILL

      *--- TC11: RHC ALL HIGH with NA-ADD-ON prior days ---*
      *   ADM=20210110, FROM=20210115: PRIOR=5+10=15, HIGH-LEFT=45
      *   UNITS=5 <= 45 → ALL HIGH, RTC=75
           INITIALIZE WS-BILL
           MOVE "1234567890" TO WB-NPI
           MOVE "341234"     TO WB-PROV-NO
           MOVE "20210115"   TO WB-FROM-DATE
           MOVE "20210110"   TO WB-ADM-DATE
           MOVE "16740"      TO WB-PROV-CBSA
           MOVE "16740"      TO WB-BENE-CBSA
           MOVE 10           TO WB-NA-DAY1-UNITS
           MOVE 00           TO WB-NA-DAY2-UNITS
           MOVE ZEROS        TO WB-EOL-DAY1-UNITS
           MOVE ZEROS        TO WB-EOL-DAY2-UNITS
           MOVE ZEROS        TO WB-EOL-DAY3-UNITS
           MOVE ZEROS        TO WB-EOL-DAY4-UNITS
           MOVE ZEROS        TO WB-EOL-DAY5-UNITS
           MOVE ZEROS        TO WB-EOL-DAY6-UNITS
           MOVE ZEROS        TO WB-EOL-DAY7-UNITS
           MOVE " "          TO WB-QIP-IND
           MOVE "0651"       TO WB-REV1
           MOVE "     "      TO WB-HCPC1
           MOVE "20210115"   TO WB-DOS1
           MOVE 0000005      TO WB-UNITS1
           MOVE ZEROS        TO WB-PAY1
           MOVE SPACES       TO WB-REV2
           MOVE ZEROS        TO WB-UNITS2
           MOVE SPACES       TO WB-REV3
           MOVE ZEROS        TO WB-UNITS3
           MOVE SPACES       TO WB-REV4
           MOVE ZEROS        TO WB-UNITS4
           MOVE ZEROS        TO WB-SIA-PYMTS
           MOVE "TC11    "   TO WB-TEST-CASE
           WRITE BILL-OUT-RECORD FROM WS-BILL

      *--- TC12: RHC SPLIT HIGH+LOW — UNITS > HIGH-RATE-DAYS-LEFT ---*
      *   ADM=20210119, FROM=20210315: PRIOR=55, HIGH-LEFT=5
      *   UNITS=10 > 5 → SPLIT: 5 HIGH + 5 LOW, RTC=75
           INITIALIZE WS-BILL
           MOVE "1234567890" TO WB-NPI
           MOVE "341234"     TO WB-PROV-NO
           MOVE "20210315"   TO WB-FROM-DATE
           MOVE "20210119"   TO WB-ADM-DATE
           MOVE "16740"      TO WB-PROV-CBSA
           MOVE "16740"      TO WB-BENE-CBSA
           MOVE ZEROS        TO WB-SIA-UNITS
           MOVE " "          TO WB-QIP-IND
           MOVE "0651"       TO WB-REV1
           MOVE "     "      TO WB-HCPC1
           MOVE "20210315"   TO WB-DOS1
           MOVE 0000010      TO WB-UNITS1
           MOVE ZEROS        TO WB-PAY1
           MOVE SPACES       TO WB-REV2
           MOVE ZEROS        TO WB-UNITS2
           MOVE SPACES       TO WB-REV3
           MOVE ZEROS        TO WB-UNITS3
           MOVE SPACES       TO WB-REV4
           MOVE ZEROS        TO WB-UNITS4
           MOVE ZEROS        TO WB-SIA-PYMTS
           MOVE "TC12    "   TO WB-TEST-CASE
           WRITE BILL-OUT-RECORD FROM WS-BILL

      *--- TC13: SPLIT HIGH+LOW + SIA → RTC=77 ---*
      *   Same 55-day split scenario as TC12 + SIA present
           INITIALIZE WS-BILL
           MOVE "1234567890" TO WB-NPI
           MOVE "341234"     TO WB-PROV-NO
           MOVE "20210315"   TO WB-FROM-DATE
           MOVE "20210119"   TO WB-ADM-DATE
           MOVE "16740"      TO WB-PROV-CBSA
           MOVE "16740"      TO WB-BENE-CBSA
           MOVE 00           TO WB-NA-DAY1-UNITS
           MOVE 00           TO WB-NA-DAY2-UNITS
           MOVE 08           TO WB-EOL-DAY1-UNITS
           MOVE 12           TO WB-EOL-DAY2-UNITS
           MOVE 00           TO WB-EOL-DAY3-UNITS
           MOVE 00           TO WB-EOL-DAY4-UNITS
           MOVE 00           TO WB-EOL-DAY5-UNITS
           MOVE 00           TO WB-EOL-DAY6-UNITS
           MOVE 00           TO WB-EOL-DAY7-UNITS
           MOVE " "          TO WB-QIP-IND
           MOVE "0651"       TO WB-REV1
           MOVE "     "      TO WB-HCPC1
           MOVE "20210315"   TO WB-DOS1
           MOVE 0000010      TO WB-UNITS1
           MOVE ZEROS        TO WB-PAY1
           MOVE SPACES       TO WB-REV2
           MOVE ZEROS        TO WB-UNITS2
           MOVE SPACES       TO WB-REV3
           MOVE ZEROS        TO WB-UNITS3
           MOVE SPACES       TO WB-REV4
           MOVE ZEROS        TO WB-UNITS4
           MOVE ZEROS        TO WB-SIA-PYMTS
           MOVE "TC13-SIA"   TO WB-TEST-CASE
           WRITE BILL-OUT-RECORD FROM WS-BILL

      *============================================================*
      * PHASE 4 — P2: CHC COMPLETE (TC14-TC16)
      *============================================================*

      *--- TC14: CHC >= 32 units — real CHC formula ---*
      *   (CHC_rate/24) x (UNITS/4). FY2021 rates apply
           INITIALIZE WS-BILL
           MOVE "1234567890" TO WB-NPI
           MOVE "341234"     TO WB-PROV-NO
           MOVE "20210220"   TO WB-FROM-DATE
           MOVE "20210215"   TO WB-ADM-DATE
           MOVE "16740"      TO WB-PROV-CBSA
           MOVE "16740"      TO WB-BENE-CBSA
           MOVE ZEROS        TO WB-SIA-UNITS
           MOVE " "          TO WB-QIP-IND
           MOVE "0652"       TO WB-REV1
           MOVE "     "      TO WB-HCPC1
           MOVE "20210220"   TO WB-DOS1
           MOVE 0000040      TO WB-UNITS1
           MOVE ZEROS        TO WB-PAY1
           MOVE SPACES       TO WB-REV2
           MOVE ZEROS        TO WB-UNITS2
           MOVE SPACES       TO WB-REV3
           MOVE ZEROS        TO WB-UNITS3
           MOVE SPACES       TO WB-REV4
           MOVE ZEROS        TO WB-UNITS4
           MOVE ZEROS        TO WB-SIA-PYMTS
           MOVE "TC14-CHC"   TO WB-TEST-CASE
           WRITE BILL-OUT-RECORD FROM WS-BILL

      *--- TC15: CHC = 32 units — boundary (must use CHC formula) ---*
           INITIALIZE WS-BILL
           MOVE "1234567890" TO WB-NPI
           MOVE "341234"     TO WB-PROV-NO
           MOVE "20210220"   TO WB-FROM-DATE
           MOVE "20210215"   TO WB-ADM-DATE
           MOVE "16740"      TO WB-PROV-CBSA
           MOVE "16740"      TO WB-BENE-CBSA
           MOVE ZEROS        TO WB-SIA-UNITS
           MOVE " "          TO WB-QIP-IND
           MOVE "0652"       TO WB-REV1
           MOVE "     "      TO WB-HCPC1
           MOVE "20210220"   TO WB-DOS1
           MOVE 0000032      TO WB-UNITS1
           MOVE ZEROS        TO WB-PAY1
           MOVE SPACES       TO WB-REV2
           MOVE ZEROS        TO WB-UNITS2
           MOVE SPACES       TO WB-REV3
           MOVE ZEROS        TO WB-UNITS3
           MOVE SPACES       TO WB-REV4
           MOVE ZEROS        TO WB-UNITS4
           MOVE ZEROS        TO WB-SIA-PYMTS
           MOVE "TC15-CH="   TO WB-TEST-CASE
           WRITE BILL-OUT-RECORD FROM WS-BILL

      *--- TC16: CHC = 31 units — below threshold (RHC for 1 day) ---*
      *   < 32 units: uses RHC rate for 1 day. ADM 5 days ago → ALL HIGH
           INITIALIZE WS-BILL
           MOVE "1234567890" TO WB-NPI
           MOVE "341234"     TO WB-PROV-NO
           MOVE "20210220"   TO WB-FROM-DATE
           MOVE "20210215"   TO WB-ADM-DATE
           MOVE "16740"      TO WB-PROV-CBSA
           MOVE "16740"      TO WB-BENE-CBSA
           MOVE ZEROS        TO WB-SIA-UNITS
           MOVE " "          TO WB-QIP-IND
           MOVE "0652"       TO WB-REV1
           MOVE "     "      TO WB-HCPC1
           MOVE "20210220"   TO WB-DOS1
           MOVE 0000031      TO WB-UNITS1
           MOVE ZEROS        TO WB-PAY1
           MOVE SPACES       TO WB-REV2
           MOVE ZEROS        TO WB-UNITS2
           MOVE SPACES       TO WB-REV3
           MOVE ZEROS        TO WB-UNITS3
           MOVE SPACES       TO WB-REV4
           MOVE ZEROS        TO WB-UNITS4
           MOVE ZEROS        TO WB-SIA-PYMTS
           MOVE "TC16-CH<"   TO WB-TEST-CASE
           WRITE BILL-OUT-RECORD FROM WS-BILL

      *============================================================*
      * PHASE 5 — P2: QIP COMPLETE (TC17-TC20)
      *============================================================*

      *--- TC17: QIP with CHC >= 32 units (uses -Q CHC rates) ---*
           INITIALIZE WS-BILL
           MOVE "1234567890" TO WB-NPI
           MOVE "341234"     TO WB-PROV-NO
           MOVE "20210115"   TO WB-FROM-DATE
           MOVE "20210110"   TO WB-ADM-DATE
           MOVE "16740"      TO WB-PROV-CBSA
           MOVE "16740"      TO WB-BENE-CBSA
           MOVE ZEROS        TO WB-SIA-UNITS
           MOVE "1"          TO WB-QIP-IND
           MOVE "0652"       TO WB-REV1
           MOVE "     "      TO WB-HCPC1
           MOVE "20210115"   TO WB-DOS1
           MOVE 0000040      TO WB-UNITS1
           MOVE ZEROS        TO WB-PAY1
           MOVE SPACES       TO WB-REV2
           MOVE ZEROS        TO WB-UNITS2
           MOVE SPACES       TO WB-REV3
           MOVE ZEROS        TO WB-UNITS3
           MOVE SPACES       TO WB-REV4
           MOVE ZEROS        TO WB-UNITS4
           MOVE ZEROS        TO WB-SIA-PYMTS
           MOVE "TC17-QCH"   TO WB-TEST-CASE
           WRITE BILL-OUT-RECORD FROM WS-BILL

      *--- TC18: QIP with IRC (0655) ---*
           INITIALIZE WS-BILL
           MOVE "1234567890" TO WB-NPI
           MOVE "341234"     TO WB-PROV-NO
           MOVE "20210115"   TO WB-FROM-DATE
           MOVE "20210110"   TO WB-ADM-DATE
           MOVE "16740"      TO WB-PROV-CBSA
           MOVE "16740"      TO WB-BENE-CBSA
           MOVE ZEROS        TO WB-SIA-UNITS
           MOVE "1"          TO WB-QIP-IND
           MOVE "0655"       TO WB-REV1
           MOVE "     "      TO WB-HCPC1
           MOVE "20210115"   TO WB-DOS1
           MOVE 0000005      TO WB-UNITS1
           MOVE ZEROS        TO WB-PAY1
           MOVE SPACES       TO WB-REV2
           MOVE ZEROS        TO WB-UNITS2
           MOVE SPACES       TO WB-REV3
           MOVE ZEROS        TO WB-UNITS3
           MOVE SPACES       TO WB-REV4
           MOVE ZEROS        TO WB-UNITS4
           MOVE ZEROS        TO WB-SIA-PYMTS
           MOVE "TC18-QIR"   TO WB-TEST-CASE
           WRITE BILL-OUT-RECORD FROM WS-BILL

      *--- TC19: QIP with GIC (0656) ---*
           INITIALIZE WS-BILL
           MOVE "1234567890" TO WB-NPI
           MOVE "341234"     TO WB-PROV-NO
           MOVE "20210115"   TO WB-FROM-DATE
           MOVE "20210110"   TO WB-ADM-DATE
           MOVE "16740"      TO WB-PROV-CBSA
           MOVE "16740"      TO WB-BENE-CBSA
           MOVE ZEROS        TO WB-SIA-UNITS
           MOVE "1"          TO WB-QIP-IND
           MOVE "0656"       TO WB-REV1
           MOVE "     "      TO WB-HCPC1
           MOVE "20210115"   TO WB-DOS1
           MOVE 0000003      TO WB-UNITS1
           MOVE ZEROS        TO WB-PAY1
           MOVE SPACES       TO WB-REV2
           MOVE ZEROS        TO WB-UNITS2
           MOVE SPACES       TO WB-REV3
           MOVE ZEROS        TO WB-UNITS3
           MOVE SPACES       TO WB-REV4
           MOVE ZEROS        TO WB-UNITS4
           MOVE ZEROS        TO WB-SIA-PYMTS
           MOVE "TC19-QGI"   TO WB-TEST-CASE
           WRITE BILL-OUT-RECORD FROM WS-BILL

      *--- TC20: QIP with SIA (uses CHC-Q rate for SIA hourly) ---*
      *   ADM=20210110, FROM=20210115: 5 days prior → ALL HIGH
           INITIALIZE WS-BILL
           MOVE "1234567890" TO WB-NPI
           MOVE "341234"     TO WB-PROV-NO
           MOVE "20210115"   TO WB-FROM-DATE
           MOVE "20210110"   TO WB-ADM-DATE
           MOVE "16740"      TO WB-PROV-CBSA
           MOVE "16740"      TO WB-BENE-CBSA
           MOVE 00           TO WB-NA-DAY1-UNITS
           MOVE 00           TO WB-NA-DAY2-UNITS
           MOVE 08           TO WB-EOL-DAY1-UNITS
           MOVE 12           TO WB-EOL-DAY2-UNITS
           MOVE 00           TO WB-EOL-DAY3-UNITS
           MOVE 00           TO WB-EOL-DAY4-UNITS
           MOVE 00           TO WB-EOL-DAY5-UNITS
           MOVE 00           TO WB-EOL-DAY6-UNITS
           MOVE 00           TO WB-EOL-DAY7-UNITS
           MOVE "1"          TO WB-QIP-IND
           MOVE "0651"       TO WB-REV1
           MOVE "     "      TO WB-HCPC1
           MOVE "20210115"   TO WB-DOS1
           MOVE 0000005      TO WB-UNITS1
           MOVE ZEROS        TO WB-PAY1
           MOVE SPACES       TO WB-REV2
           MOVE ZEROS        TO WB-UNITS2
           MOVE SPACES       TO WB-REV3
           MOVE ZEROS        TO WB-UNITS3
           MOVE SPACES       TO WB-REV4
           MOVE ZEROS        TO WB-UNITS4
           MOVE ZEROS        TO WB-SIA-PYMTS
           MOVE "TC20-QSI"   TO WB-TEST-CASE
           WRITE BILL-OUT-RECORD FROM WS-BILL

      *============================================================*
      * PHASE 6 — P2: SIA COMPLETE (TC21-TC22)
      *============================================================*

      *--- TC21: SIA cap of 16 units (4 hours) ---*
      *   DAY1=20 (>16 → cap 4h), DAY2=16 (=16 → cap 4h), DAY3=15 (<16)
           INITIALIZE WS-BILL
           MOVE "1234567890" TO WB-NPI
           MOVE "341234"     TO WB-PROV-NO
           MOVE "20210115"   TO WB-FROM-DATE
           MOVE "20210110"   TO WB-ADM-DATE
           MOVE "16740"      TO WB-PROV-CBSA
           MOVE "16740"      TO WB-BENE-CBSA
           MOVE 00           TO WB-NA-DAY1-UNITS
           MOVE 00           TO WB-NA-DAY2-UNITS
           MOVE 20           TO WB-EOL-DAY1-UNITS
           MOVE 16           TO WB-EOL-DAY2-UNITS
           MOVE 15           TO WB-EOL-DAY3-UNITS
           MOVE 00           TO WB-EOL-DAY4-UNITS
           MOVE 00           TO WB-EOL-DAY5-UNITS
           MOVE 00           TO WB-EOL-DAY6-UNITS
           MOVE 00           TO WB-EOL-DAY7-UNITS
           MOVE " "          TO WB-QIP-IND
           MOVE "0651"       TO WB-REV1
           MOVE "     "      TO WB-HCPC1
           MOVE "20210115"   TO WB-DOS1
           MOVE 0000010      TO WB-UNITS1
           MOVE ZEROS        TO WB-PAY1
           MOVE SPACES       TO WB-REV2
           MOVE ZEROS        TO WB-UNITS2
           MOVE SPACES       TO WB-REV3
           MOVE ZEROS        TO WB-UNITS3
           MOVE SPACES       TO WB-REV4
           MOVE ZEROS        TO WB-UNITS4
           MOVE ZEROS        TO WB-SIA-PYMTS
           MOVE "TC21-CAP"   TO WB-TEST-CASE
           WRITE BILL-OUT-RECORD FROM WS-BILL

      *--- TC22: SIA all 7 days with 8 units each ---*
      *   7 RHC days, 7 SIA EOL days at 8 units (2h each) → RTC=77
           INITIALIZE WS-BILL
           MOVE "1234567890" TO WB-NPI
           MOVE "341234"     TO WB-PROV-NO
           MOVE "20210115"   TO WB-FROM-DATE
           MOVE "20210110"   TO WB-ADM-DATE
           MOVE "16740"      TO WB-PROV-CBSA
           MOVE "16740"      TO WB-BENE-CBSA
           MOVE 00           TO WB-NA-DAY1-UNITS
           MOVE 00           TO WB-NA-DAY2-UNITS
           MOVE 08           TO WB-EOL-DAY1-UNITS
           MOVE 08           TO WB-EOL-DAY2-UNITS
           MOVE 08           TO WB-EOL-DAY3-UNITS
           MOVE 08           TO WB-EOL-DAY4-UNITS
           MOVE 08           TO WB-EOL-DAY5-UNITS
           MOVE 08           TO WB-EOL-DAY6-UNITS
           MOVE 08           TO WB-EOL-DAY7-UNITS
           MOVE " "          TO WB-QIP-IND
           MOVE "0651"       TO WB-REV1
           MOVE "     "      TO WB-HCPC1
           MOVE "20210115"   TO WB-DOS1
           MOVE 0000007      TO WB-UNITS1
           MOVE ZEROS        TO WB-PAY1
           MOVE SPACES       TO WB-REV2
           MOVE ZEROS        TO WB-UNITS2
           MOVE SPACES       TO WB-REV3
           MOVE ZEROS        TO WB-UNITS3
           MOVE SPACES       TO WB-REV4
           MOVE ZEROS        TO WB-UNITS4
           MOVE ZEROS        TO WB-SIA-PYMTS
           MOVE "TC22-7DY"   TO WB-TEST-CASE
           WRITE BILL-OUT-RECORD FROM WS-BILL

      *============================================================*
      * PHASE 7 — P2: MULTI-CODE BILL (TC23)
      *============================================================*

      *--- TC23: All 4 revenue codes simultaneously ---*
      *   ADM=20201001: >60 days prior → ALL LOW for RHC (0651)
      *   RHC 30d ALL LOW + CHC 40u + IRC 5d + GIC 3d → RTC=73
           INITIALIZE WS-BILL
           MOVE "1234567890" TO WB-NPI
           MOVE "341234"     TO WB-PROV-NO
           MOVE "20210115"   TO WB-FROM-DATE
           MOVE "20201001"   TO WB-ADM-DATE
           MOVE "16740"      TO WB-PROV-CBSA
           MOVE "16740"      TO WB-BENE-CBSA
           MOVE ZEROS        TO WB-SIA-UNITS
           MOVE " "          TO WB-QIP-IND
           MOVE "0651"       TO WB-REV1
           MOVE "     "      TO WB-HCPC1
           MOVE "20210115"   TO WB-DOS1
           MOVE 0000030      TO WB-UNITS1
           MOVE ZEROS        TO WB-PAY1
           MOVE "0652"       TO WB-REV2
           MOVE "     "      TO WB-HCPC2
           MOVE "20210115"   TO WB-DOS2
           MOVE 0000040      TO WB-UNITS2
           MOVE ZEROS        TO WB-PAY2
           MOVE "0655"       TO WB-REV3
           MOVE "     "      TO WB-HCPC3
           MOVE "20210115"   TO WB-DOS3
           MOVE 0000005      TO WB-UNITS3
           MOVE ZEROS        TO WB-PAY3
           MOVE "0656"       TO WB-REV4
           MOVE "     "      TO WB-HCPC4
           MOVE "20210115"   TO WB-DOS4
           MOVE 0000003      TO WB-UNITS4
           MOVE ZEROS        TO WB-PAY4
           MOVE ZEROS        TO WB-SIA-PYMTS
           MOVE "TC23-MLT"   TO WB-TEST-CASE
           WRITE BILL-OUT-RECORD FROM WS-BILL


      *============================================================*
      * PHASE 8 — P3: FY2014/2015 QIP HARD-CODED RATES (TC24-TC26)
      *============================================================*

      *--- TC24: FY2014 standard (no QIP) — rates LS=107.23, NLS=48.83 ---*
           INITIALIZE WS-BILL
           MOVE "1234567890" TO WB-NPI
           MOVE "341234"     TO WB-PROV-NO
           MOVE "20140115"   TO WB-FROM-DATE
           MOVE "20140115"   TO WB-ADM-DATE
           MOVE "16740"      TO WB-PROV-CBSA
           MOVE "16740"      TO WB-BENE-CBSA
           MOVE ZEROS        TO WB-SIA-UNITS
           MOVE " "          TO WB-QIP-IND
           MOVE "0651"       TO WB-REV1
           MOVE "     "      TO WB-HCPC1
           MOVE "20140115"   TO WB-DOS1
           MOVE 0000010      TO WB-UNITS1
           MOVE ZEROS        TO WB-PAY1
           MOVE SPACES       TO WB-REV2
           MOVE ZEROS        TO WB-UNITS2
           MOVE SPACES       TO WB-REV3
           MOVE ZEROS        TO WB-UNITS3
           MOVE SPACES       TO WB-REV4
           MOVE ZEROS        TO WB-UNITS4
           MOVE ZEROS        TO WB-SIA-PYMTS
           MOVE "TC24-14 "   TO WB-TEST-CASE
           WRITE BILL-OUT-RECORD FROM WS-BILL

      *--- TC25: FY2014 with QIP — rates LS=105.12, NLS=47.87 ---*
           INITIALIZE WS-BILL
           MOVE "1234567890" TO WB-NPI
           MOVE "341234"     TO WB-PROV-NO
           MOVE "20140115"   TO WB-FROM-DATE
           MOVE "20140115"   TO WB-ADM-DATE
           MOVE "16740"      TO WB-PROV-CBSA
           MOVE "16740"      TO WB-BENE-CBSA
           MOVE ZEROS        TO WB-SIA-UNITS
           MOVE "1"          TO WB-QIP-IND
           MOVE "0651"       TO WB-REV1
           MOVE "     "      TO WB-HCPC1
           MOVE "20140115"   TO WB-DOS1
           MOVE 0000010      TO WB-UNITS1
           MOVE ZEROS        TO WB-PAY1
           MOVE SPACES       TO WB-REV2
           MOVE ZEROS        TO WB-UNITS2
           MOVE SPACES       TO WB-REV3
           MOVE ZEROS        TO WB-UNITS3
           MOVE SPACES       TO WB-REV4
           MOVE ZEROS        TO WB-UNITS4
           MOVE ZEROS        TO WB-SIA-PYMTS
           MOVE "TC25-14Q"   TO WB-TEST-CASE
           WRITE BILL-OUT-RECORD FROM WS-BILL

      *--- TC26: FY2015 with QIP — rates LS=107.34, NLS=48.88 ---*
           INITIALIZE WS-BILL
           MOVE "1234567890" TO WB-NPI
           MOVE "341234"     TO WB-PROV-NO
           MOVE "20150115"   TO WB-FROM-DATE
           MOVE "20150115"   TO WB-ADM-DATE
           MOVE "16740"      TO WB-PROV-CBSA
           MOVE "16740"      TO WB-BENE-CBSA
           MOVE ZEROS        TO WB-SIA-UNITS
           MOVE "1"          TO WB-QIP-IND
           MOVE "0651"       TO WB-REV1
           MOVE "     "      TO WB-HCPC1
           MOVE "20150115"   TO WB-DOS1
           MOVE 0000010      TO WB-UNITS1
           MOVE ZEROS        TO WB-PAY1
           MOVE SPACES       TO WB-REV2
           MOVE ZEROS        TO WB-UNITS2
           MOVE SPACES       TO WB-REV3
           MOVE ZEROS        TO WB-UNITS3
           MOVE SPACES       TO WB-REV4
           MOVE ZEROS        TO WB-UNITS4
           MOVE ZEROS        TO WB-SIA-PYMTS
           MOVE "TC26-15Q"   TO WB-TEST-CASE
           WRITE BILL-OUT-RECORD FROM WS-BILL

      *============================================================*
      * PHASE 9 — P3: FY BOUNDARY TESTS (TC27-TC29)
      * Provider 3 (341236, CBSA 10180) for FY2015/FY2016 tests
      *============================================================*

      *--- TC27A: FY2016 old single-rate (FROM <= 20151231) ---*
      *   HOSPR210 routes to 2016-PROCESS-DATA: single RHC rate, no split
           INITIALIZE WS-BILL
           MOVE "5555555555" TO WB-NPI
           MOVE "341236"     TO WB-PROV-NO
           MOVE "20151231"   TO WB-FROM-DATE
           MOVE "20151225"   TO WB-ADM-DATE
           MOVE "10180"      TO WB-PROV-CBSA
           MOVE "10180"      TO WB-BENE-CBSA
           MOVE ZEROS        TO WB-SIA-UNITS
           MOVE " "          TO WB-QIP-IND
           MOVE "0651"       TO WB-REV1
           MOVE "     "      TO WB-HCPC1
           MOVE "20151231"   TO WB-DOS1
           MOVE 0000010      TO WB-UNITS1
           MOVE ZEROS        TO WB-PAY1
           MOVE SPACES       TO WB-REV2
           MOVE ZEROS        TO WB-UNITS2
           MOVE SPACES       TO WB-REV3
           MOVE ZEROS        TO WB-UNITS3
           MOVE SPACES       TO WB-REV4
           MOVE ZEROS        TO WB-UNITS4
           MOVE ZEROS        TO WB-SIA-PYMTS
           MOVE "TC27A   "   TO WB-TEST-CASE
           WRITE BILL-OUT-RECORD FROM WS-BILL

      *--- TC27B: FY2016.1 (FROM >= 20160101) — 60-day split active ---*
      *   ADM same as FROM: 0 prior days → ALL HIGH, RTC=75
           INITIALIZE WS-BILL
           MOVE "5555555555" TO WB-NPI
           MOVE "341236"     TO WB-PROV-NO
           MOVE "20160101"   TO WB-FROM-DATE
           MOVE "20160101"   TO WB-ADM-DATE
           MOVE "10180"      TO WB-PROV-CBSA
           MOVE "10180"      TO WB-BENE-CBSA
           MOVE ZEROS        TO WB-SIA-UNITS
           MOVE " "          TO WB-QIP-IND
           MOVE "0651"       TO WB-REV1
           MOVE "     "      TO WB-HCPC1
           MOVE "20160101"   TO WB-DOS1
           MOVE 0000005      TO WB-UNITS1
           MOVE ZEROS        TO WB-PAY1
           MOVE SPACES       TO WB-REV2
           MOVE ZEROS        TO WB-UNITS2
           MOVE SPACES       TO WB-REV3
           MOVE ZEROS        TO WB-UNITS3
           MOVE SPACES       TO WB-REV4
           MOVE ZEROS        TO WB-UNITS4
           MOVE ZEROS        TO WB-SIA-PYMTS
           MOVE "TC27B   "   TO WB-TEST-CASE
           WRITE BILL-OUT-RECORD FROM WS-BILL

      *--- TC28A: FY2007 (FROM=20061201) — 0652 old CHC hours format ---*
      *   For FROM < 20080101, prov CBSA-GEO-LOC used (16740 FY2007 entry)
      *   10 hours CHC (old format): (CHC_rate/24) x 10
           INITIALIZE WS-BILL
           MOVE "1234567890" TO WB-NPI
           MOVE "341234"     TO WB-PROV-NO
           MOVE "20061201"   TO WB-FROM-DATE
           MOVE "20061201"   TO WB-ADM-DATE
           MOVE "16740"      TO WB-PROV-CBSA
           MOVE "16740"      TO WB-BENE-CBSA
           MOVE ZEROS        TO WB-SIA-UNITS
           MOVE " "          TO WB-QIP-IND
           MOVE "0652"       TO WB-REV1
           MOVE "     "      TO WB-HCPC1
           MOVE "20061201"   TO WB-DOS1
           MOVE 0000010      TO WB-UNITS1
           MOVE ZEROS        TO WB-PAY1
           MOVE SPACES       TO WB-REV2
           MOVE ZEROS        TO WB-UNITS2
           MOVE SPACES       TO WB-REV3
           MOVE ZEROS        TO WB-UNITS3
           MOVE SPACES       TO WB-REV4
           MOVE ZEROS        TO WB-UNITS4
           MOVE ZEROS        TO WB-SIA-PYMTS
           MOVE "TC28A   "   TO WB-TEST-CASE
           WRITE BILL-OUT-RECORD FROM WS-BILL

      *--- TC28B: FY2007.1 (FROM=20070101) — 0652 new 15-min format ---*
      *   10 increments x 15min = 2.5h < 32 → RHC substitute (1 day)
           INITIALIZE WS-BILL
           MOVE "1234567890" TO WB-NPI
           MOVE "341234"     TO WB-PROV-NO
           MOVE "20070101"   TO WB-FROM-DATE
           MOVE "20070101"   TO WB-ADM-DATE
           MOVE "16740"      TO WB-PROV-CBSA
           MOVE "16740"      TO WB-BENE-CBSA
           MOVE ZEROS        TO WB-SIA-UNITS
           MOVE " "          TO WB-QIP-IND
           MOVE "0652"       TO WB-REV1
           MOVE "     "      TO WB-HCPC1
           MOVE "20070101"   TO WB-DOS1
           MOVE 0000010      TO WB-UNITS1
           MOVE ZEROS        TO WB-PAY1
           MOVE SPACES       TO WB-REV2
           MOVE ZEROS        TO WB-UNITS2
           MOVE SPACES       TO WB-REV3
           MOVE ZEROS        TO WB-UNITS3
           MOVE SPACES       TO WB-REV4
           MOVE ZEROS        TO WB-UNITS4
           MOVE ZEROS        TO WB-SIA-PYMTS
           MOVE "TC28B   "   TO WB-TEST-CASE
           WRITE BILL-OUT-RECORD FROM WS-BILL

      *--- TC29A: FY2001 (FROM=20010315) — LS=69.97, NLS=31.87 ---*
      *   MSA path (FROM <= 20050930). Needs MSAFILE for WI lookup.
           INITIALIZE WS-BILL
           MOVE "1234567890" TO WB-NPI
           MOVE "341234"     TO WB-PROV-NO
           MOVE "20010315"   TO WB-FROM-DATE
           MOVE "20010315"   TO WB-ADM-DATE
           MOVE "6740 "      TO WB-PROV-CBSA
           MOVE "6740 "      TO WB-BENE-CBSA
           MOVE ZEROS        TO WB-SIA-UNITS
           MOVE " "          TO WB-QIP-IND
           MOVE "0651"       TO WB-REV1
           MOVE "     "      TO WB-HCPC1
           MOVE "20010315"   TO WB-DOS1
           MOVE 0000005      TO WB-UNITS1
           MOVE ZEROS        TO WB-PAY1
           MOVE SPACES       TO WB-REV2
           MOVE ZEROS        TO WB-UNITS2
           MOVE SPACES       TO WB-REV3
           MOVE ZEROS        TO WB-UNITS3
           MOVE SPACES       TO WB-REV4
           MOVE ZEROS        TO WB-UNITS4
           MOVE ZEROS        TO WB-SIA-PYMTS
           MOVE "TC29A   "   TO WB-TEST-CASE
           WRITE BILL-OUT-RECORD FROM WS-BILL

      *--- TC29B: FY2001-A (FROM=20010401) — LS=73.47, NLS=33.46 (~5% more) ---*
      *   MSA path. Eff date 20010401 triggers FY2001-A rate table.
           INITIALIZE WS-BILL
           MOVE "1234567890" TO WB-NPI
           MOVE "341234"     TO WB-PROV-NO
           MOVE "20010401"   TO WB-FROM-DATE
           MOVE "20010401"   TO WB-ADM-DATE
           MOVE "6740 "      TO WB-PROV-CBSA
           MOVE "6740 "      TO WB-BENE-CBSA
           MOVE ZEROS        TO WB-SIA-UNITS
           MOVE " "          TO WB-QIP-IND
           MOVE "0651"       TO WB-REV1
           MOVE "     "      TO WB-HCPC1
           MOVE "20010401"   TO WB-DOS1
           MOVE 0000005      TO WB-UNITS1
           MOVE ZEROS        TO WB-PAY1
           MOVE SPACES       TO WB-REV2
           MOVE ZEROS        TO WB-UNITS2
           MOVE SPACES       TO WB-REV3
           MOVE ZEROS        TO WB-UNITS3
           MOVE SPACES       TO WB-REV4
           MOVE ZEROS        TO WB-UNITS4
           MOVE ZEROS        TO WB-SIA-PYMTS
           MOVE "TC29B   "   TO WB-TEST-CASE
           WRITE BILL-OUT-RECORD FROM WS-BILL

      *============================================================*
      * PHASE 10 — P3: REPRESENTATIVE FISCAL YEARS (TC30-TC36)
      *============================================================*

      *--- TC30: FY1998/1999 — initial rates, base formula ---*
      *   MSA path (FROM <= 20050930). Needs MSAFILE.
           INITIALIZE WS-BILL
           MOVE "1234567890" TO WB-NPI
           MOVE "341234"     TO WB-PROV-NO
           MOVE "19990115"   TO WB-FROM-DATE
           MOVE "19990115"   TO WB-ADM-DATE
           MOVE "6740 "      TO WB-PROV-CBSA
           MOVE "6740 "      TO WB-BENE-CBSA
           MOVE ZEROS        TO WB-SIA-UNITS
           MOVE " "          TO WB-QIP-IND
           MOVE "0651"       TO WB-REV1
           MOVE "     "      TO WB-HCPC1
           MOVE "19990115"   TO WB-DOS1
           MOVE 0000005      TO WB-UNITS1
           MOVE ZEROS        TO WB-PAY1
           MOVE SPACES       TO WB-REV2
           MOVE ZEROS        TO WB-UNITS2
           MOVE SPACES       TO WB-REV3
           MOVE ZEROS        TO WB-UNITS3
           MOVE SPACES       TO WB-REV4
           MOVE ZEROS        TO WB-UNITS4
           MOVE ZEROS        TO WB-SIA-PYMTS
           MOVE "TC30-98 "   TO WB-TEST-CASE
           WRITE BILL-OUT-RECORD FROM WS-BILL

      *--- TC31: FY2000 — CHC in hours (min 8h, here 10h OK) ---*
      *   MSA path. 0652/10 = 10 hours, meets 8h minimum
           INITIALIZE WS-BILL
           MOVE "1234567890" TO WB-NPI
           MOVE "341234"     TO WB-PROV-NO
           MOVE "19991115"   TO WB-FROM-DATE
           MOVE "19991115"   TO WB-ADM-DATE
           MOVE "6740 "      TO WB-PROV-CBSA
           MOVE "6740 "      TO WB-BENE-CBSA
           MOVE ZEROS        TO WB-SIA-UNITS
           MOVE " "          TO WB-QIP-IND
           MOVE "0652"       TO WB-REV1
           MOVE "     "      TO WB-HCPC1
           MOVE "19991115"   TO WB-DOS1
           MOVE 0000010      TO WB-UNITS1
           MOVE ZEROS        TO WB-PAY1
           MOVE SPACES       TO WB-REV2
           MOVE ZEROS        TO WB-UNITS2
           MOVE SPACES       TO WB-REV3
           MOVE ZEROS        TO WB-UNITS3
           MOVE SPACES       TO WB-REV4
           MOVE ZEROS        TO WB-UNITS4
           MOVE ZEROS        TO WB-SIA-PYMTS
           MOVE "TC31-99C"   TO WB-TEST-CASE
           WRITE BILL-OUT-RECORD FROM WS-BILL

      *--- TC32: FY2003 — IRC with provider WI ---*
      *   MSA path. 0655/5 days inpatient respite.
           INITIALIZE WS-BILL
           MOVE "1234567890" TO WB-NPI
           MOVE "341234"     TO WB-PROV-NO
           MOVE "20030601"   TO WB-FROM-DATE
           MOVE "20030601"   TO WB-ADM-DATE
           MOVE "6740 "      TO WB-PROV-CBSA
           MOVE "6740 "      TO WB-BENE-CBSA
           MOVE ZEROS        TO WB-SIA-UNITS
           MOVE " "          TO WB-QIP-IND
           MOVE "0655"       TO WB-REV1
           MOVE "     "      TO WB-HCPC1
           MOVE "20030601"   TO WB-DOS1
           MOVE 0000005      TO WB-UNITS1
           MOVE ZEROS        TO WB-PAY1
           MOVE SPACES       TO WB-REV2
           MOVE ZEROS        TO WB-UNITS2
           MOVE SPACES       TO WB-REV3
           MOVE ZEROS        TO WB-UNITS3
           MOVE SPACES       TO WB-REV4
           MOVE ZEROS        TO WB-UNITS4
           MOVE ZEROS        TO WB-SIA-PYMTS
           MOVE "TC32-03I"   TO WB-TEST-CASE
           WRITE BILL-OUT-RECORD FROM WS-BILL

      *--- TC33: FY2008 — post 15-min transition, pre-QIP ---*
      *   CBSA path (FROM >= 20080101). Bill PROV-CBSA used directly.
           INITIALIZE WS-BILL
           MOVE "1234567890" TO WB-NPI
           MOVE "341234"     TO WB-PROV-NO
           MOVE "20080115"   TO WB-FROM-DATE
           MOVE "20080115"   TO WB-ADM-DATE
           MOVE "16740"      TO WB-PROV-CBSA
           MOVE "16740"      TO WB-BENE-CBSA
           MOVE ZEROS        TO WB-SIA-UNITS
           MOVE " "          TO WB-QIP-IND
           MOVE "0651"       TO WB-REV1
           MOVE "     "      TO WB-HCPC1
           MOVE "20080115"   TO WB-DOS1
           MOVE 0000010      TO WB-UNITS1
           MOVE ZEROS        TO WB-PAY1
           MOVE SPACES       TO WB-REV2
           MOVE ZEROS        TO WB-UNITS2
           MOVE SPACES       TO WB-REV3
           MOVE ZEROS        TO WB-UNITS3
           MOVE SPACES       TO WB-REV4
           MOVE ZEROS        TO WB-UNITS4
           MOVE ZEROS        TO WB-SIA-PYMTS
           MOVE "TC33-08 "   TO WB-TEST-CASE
           WRITE BILL-OUT-RECORD FROM WS-BILL

      *--- TC34: FY2011 — GIC mid-range without QIP ---*
           INITIALIZE WS-BILL
           MOVE "1234567890" TO WB-NPI
           MOVE "341234"     TO WB-PROV-NO
           MOVE "20111001"   TO WB-FROM-DATE
           MOVE "20111001"   TO WB-ADM-DATE
           MOVE "16740"      TO WB-PROV-CBSA
           MOVE "16740"      TO WB-BENE-CBSA
           MOVE ZEROS        TO WB-SIA-UNITS
           MOVE " "          TO WB-QIP-IND
           MOVE "0656"       TO WB-REV1
           MOVE "     "      TO WB-HCPC1
           MOVE "20111001"   TO WB-DOS1
           MOVE 0000005      TO WB-UNITS1
           MOVE ZEROS        TO WB-PAY1
           MOVE SPACES       TO WB-REV2
           MOVE ZEROS        TO WB-UNITS2
           MOVE SPACES       TO WB-REV3
           MOVE ZEROS        TO WB-UNITS3
           MOVE SPACES       TO WB-REV4
           MOVE ZEROS        TO WB-UNITS4
           MOVE ZEROS        TO WB-SIA-PYMTS
           MOVE "TC34-11G"   TO WB-TEST-CASE
           WRITE BILL-OUT-RECORD FROM WS-BILL

      *--- TC35: FY2013 — last FY without QIP ---*
           INITIALIZE WS-BILL
           MOVE "1234567890" TO WB-NPI
           MOVE "341234"     TO WB-PROV-NO
           MOVE "20131015"   TO WB-FROM-DATE
           MOVE "20131015"   TO WB-ADM-DATE
           MOVE "16740"      TO WB-PROV-CBSA
           MOVE "16740"      TO WB-BENE-CBSA
           MOVE ZEROS        TO WB-SIA-UNITS
           MOVE " "          TO WB-QIP-IND
           MOVE "0651"       TO WB-REV1
           MOVE "     "      TO WB-HCPC1
           MOVE "20131015"   TO WB-DOS1
           MOVE 0000010      TO WB-UNITS1
           MOVE ZEROS        TO WB-PAY1
           MOVE SPACES       TO WB-REV2
           MOVE ZEROS        TO WB-UNITS2
           MOVE SPACES       TO WB-REV3
           MOVE ZEROS        TO WB-UNITS3
           MOVE SPACES       TO WB-REV4
           MOVE ZEROS        TO WB-UNITS4
           MOVE ZEROS        TO WB-SIA-PYMTS
           MOVE "TC35-13 "   TO WB-TEST-CASE
           WRITE BILL-OUT-RECORD FROM WS-BILL

      *--- TC36: FY2016 — first FY with HOSPRATE, single RHC rate ---*
      *   Provider 3 (CBSA 10180 has 20151001 entry for FY2016 range)
           INITIALIZE WS-BILL
           MOVE "5555555555" TO WB-NPI
           MOVE "341236"     TO WB-PROV-NO
           MOVE "20151015"   TO WB-FROM-DATE
           MOVE "20151015"   TO WB-ADM-DATE
           MOVE "10180"      TO WB-PROV-CBSA
           MOVE "10180"      TO WB-BENE-CBSA
           MOVE ZEROS        TO WB-SIA-UNITS
           MOVE " "          TO WB-QIP-IND
           MOVE "0651"       TO WB-REV1
           MOVE "     "      TO WB-HCPC1
           MOVE "20151015"   TO WB-DOS1
           MOVE 0000010      TO WB-UNITS1
           MOVE ZEROS        TO WB-PAY1
           MOVE SPACES       TO WB-REV2
           MOVE ZEROS        TO WB-UNITS2
           MOVE SPACES       TO WB-REV3
           MOVE ZEROS        TO WB-UNITS3
           MOVE SPACES       TO WB-REV4
           MOVE ZEROS        TO WB-UNITS4
           MOVE ZEROS        TO WB-SIA-PYMTS
           MOVE "TC36-16 "   TO WB-TEST-CASE
           WRITE BILL-OUT-RECORD FROM WS-BILL

      *============================================================*
      * PHASE 11 — FY2010 CHC (0652) BRANCH COVERAGE (TC37-TC41)
      * BILL-REV2='0652', FROM-DATE=20100115 → routes to 2010-PROCESS-DATA
      * CBSA 16740 FY2010 wage index = 1.0128
      *============================================================*

      *--- TC37-10Z: UNITS2=0 → IF BILL-UNITS2 > 0 fails (Branch B) ---*
      *   No payment computed for REV2; WRK-PAY-RATE2 stays zero
           INITIALIZE WS-BILL
           MOVE "1234567890" TO WB-NPI
           MOVE "341234"     TO WB-PROV-NO
           MOVE "20100115"   TO WB-FROM-DATE
           MOVE "20100115"   TO WB-ADM-DATE
           MOVE "16740"      TO WB-PROV-CBSA
           MOVE "16740"      TO WB-BENE-CBSA
           MOVE ZEROS        TO WB-SIA-UNITS
           MOVE " "          TO WB-QIP-IND
           MOVE SPACES       TO WB-REV1
           MOVE ZEROS        TO WB-UNITS1
           MOVE "0652"       TO WB-REV2
           MOVE "     "      TO WB-HCPC2
           MOVE "20100115"   TO WB-DOS2
           MOVE ZEROS        TO WB-UNITS2
           MOVE ZEROS        TO WB-PAY2
           MOVE SPACES       TO WB-REV3
           MOVE ZEROS        TO WB-UNITS3
           MOVE SPACES       TO WB-REV4
           MOVE ZEROS        TO WB-UNITS4
           MOVE ZEROS        TO WB-SIA-PYMTS
           MOVE "TC37-10Z"   TO WB-TEST-CASE
           WRITE BILL-OUT-RECORD FROM WS-BILL

      *--- TC38-10L: UNITS2=16 < 32 → RHC day-rate formula (Branch C) ---*
      *   COMPUTE WRK-PAY-RATE2 = ((98.19 * WI) + 44.72) [no units multiplier]
      *   Expected: (98.19 * 1.0128) + 44.72 ≈ 144.28
           INITIALIZE WS-BILL
           MOVE "1234567890" TO WB-NPI
           MOVE "341234"     TO WB-PROV-NO
           MOVE "20100115"   TO WB-FROM-DATE
           MOVE "20100115"   TO WB-ADM-DATE
           MOVE "16740"      TO WB-PROV-CBSA
           MOVE "16740"      TO WB-BENE-CBSA
           MOVE ZEROS        TO WB-SIA-UNITS
           MOVE " "          TO WB-QIP-IND
           MOVE SPACES       TO WB-REV1
           MOVE ZEROS        TO WB-UNITS1
           MOVE "0652"       TO WB-REV2
           MOVE "     "      TO WB-HCPC2
           MOVE "20100115"   TO WB-DOS2
           MOVE 0000016      TO WB-UNITS2
           MOVE ZEROS        TO WB-PAY2
           MOVE SPACES       TO WB-REV3
           MOVE ZEROS        TO WB-UNITS3
           MOVE SPACES       TO WB-REV4
           MOVE ZEROS        TO WB-UNITS4
           MOVE ZEROS        TO WB-SIA-PYMTS
           MOVE "TC38-10L"   TO WB-TEST-CASE
           WRITE BILL-OUT-RECORD FROM WS-BILL

      *--- TC39-10B: UNITS2=31 (boundary case, still < 32) → Branch C ---*
      *   31 < 32 threshold: still uses RHC day-rate, not CHC hourly
           INITIALIZE WS-BILL
           MOVE "1234567890" TO WB-NPI
           MOVE "341234"     TO WB-PROV-NO
           MOVE "20100115"   TO WB-FROM-DATE
           MOVE "20100115"   TO WB-ADM-DATE
           MOVE "16740"      TO WB-PROV-CBSA
           MOVE "16740"      TO WB-BENE-CBSA
           MOVE ZEROS        TO WB-SIA-UNITS
           MOVE " "          TO WB-QIP-IND
           MOVE SPACES       TO WB-REV1
           MOVE ZEROS        TO WB-UNITS1
           MOVE "0652"       TO WB-REV2
           MOVE "     "      TO WB-HCPC2
           MOVE "20100115"   TO WB-DOS2
           MOVE 0000031      TO WB-UNITS2
           MOVE ZEROS        TO WB-PAY2
           MOVE SPACES       TO WB-REV3
           MOVE ZEROS        TO WB-UNITS3
           MOVE SPACES       TO WB-REV4
           MOVE ZEROS        TO WB-UNITS4
           MOVE ZEROS        TO WB-SIA-PYMTS
           MOVE "TC39-10B"   TO WB-TEST-CASE
           WRITE BILL-OUT-RECORD FROM WS-BILL

      *--- TC40-10H: UNITS2=32 (boundary >= 32) → CHC hourly (Branch D) ---*
      *   COMPUTE: (((573.11*WI)+260.99)/24) * (32/4)  = 8-hour CHC day
      *   Expected: (((573.11*1.0128)+260.99)/24) * 8 ≈ (580.44+260.99)/24*8
           INITIALIZE WS-BILL
           MOVE "1234567890" TO WB-NPI
           MOVE "341234"     TO WB-PROV-NO
           MOVE "20100115"   TO WB-FROM-DATE
           MOVE "20100115"   TO WB-ADM-DATE
           MOVE "16740"      TO WB-PROV-CBSA
           MOVE "16740"      TO WB-BENE-CBSA
           MOVE ZEROS        TO WB-SIA-UNITS
           MOVE " "          TO WB-QIP-IND
           MOVE SPACES       TO WB-REV1
           MOVE ZEROS        TO WB-UNITS1
           MOVE "0652"       TO WB-REV2
           MOVE "     "      TO WB-HCPC2
           MOVE "20100115"   TO WB-DOS2
           MOVE 0000032      TO WB-UNITS2
           MOVE ZEROS        TO WB-PAY2
           MOVE SPACES       TO WB-REV3
           MOVE ZEROS        TO WB-UNITS3
           MOVE SPACES       TO WB-REV4
           MOVE ZEROS        TO WB-UNITS4
           MOVE ZEROS        TO WB-SIA-PYMTS
           MOVE "TC40-10H"   TO WB-TEST-CASE
           WRITE BILL-OUT-RECORD FROM WS-BILL

      *--- TC41-10C: UNITS2=40 > 32 → CHC hourly formula normal (Branch D) ---*
      *   COMPUTE: (((573.11*WI)+260.99)/24) * (40/4) = 10-hour CHC day
      *   Expected: (((573.11*1.0128)+260.99)/24) * 10 ≈ 350.60
           INITIALIZE WS-BILL
           MOVE "1234567890" TO WB-NPI
           MOVE "341234"     TO WB-PROV-NO
           MOVE "20100115"   TO WB-FROM-DATE
           MOVE "20100115"   TO WB-ADM-DATE
           MOVE "16740"      TO WB-PROV-CBSA
           MOVE "16740"      TO WB-BENE-CBSA
           MOVE ZEROS        TO WB-SIA-UNITS
           MOVE " "          TO WB-QIP-IND
           MOVE SPACES       TO WB-REV1
           MOVE ZEROS        TO WB-UNITS1
           MOVE "0652"       TO WB-REV2
           MOVE "     "      TO WB-HCPC2
           MOVE "20100115"   TO WB-DOS2
           MOVE 0000040      TO WB-UNITS2
           MOVE ZEROS        TO WB-PAY2
           MOVE SPACES       TO WB-REV3
           MOVE ZEROS        TO WB-UNITS3
           MOVE SPACES       TO WB-REV4
           MOVE ZEROS        TO WB-UNITS4
           MOVE ZEROS        TO WB-SIA-PYMTS
           MOVE "TC41-10C"   TO WB-TEST-CASE
           WRITE BILL-OUT-RECORD FROM WS-BILL

           CLOSE BILLFILE
           DISPLAY "BILLFILE: 45 test bills created (TC01-TC41)".

       2000-CREATE-BILL-EXIT. EXIT.
