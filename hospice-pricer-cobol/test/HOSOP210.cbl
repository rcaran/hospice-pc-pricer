       IDENTIFICATION DIVISION.
       PROGRAM-ID. HOSOP210.
      *================================================================*
      * HOSOP210 - BATCH TEST DRIVER                                   *
      * Replaces the CICS HOSOP210 wrapper for local GnuCOBOL testing  *
      *                                                                *
      * This program:                                                  *
      *   1. Opens and reads PROVFILE into PROV-TABLE                  *
      *   2. Opens and reads CBSAFILE into CBSA-WI-TABLE              *
      *   3. Opens and reads MSAFILE  into MSA-WI-TABLE (optional)    *
      *   4. Opens BILLFILE and reads each 315-byte bill record       *
      *   5. Calls HOSDR210 for each bill                             *
      *   6. Writes result to RATEFILE                                *
      *================================================================*
       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       SOURCE-COMPUTER. X86-64.
       OBJECT-COMPUTER. X86-64.

       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT BILLFILE ASSIGN TO "BILLFILE"
               ORGANIZATION IS LINE SEQUENTIAL
               FILE STATUS IS WS-BILL-STATUS.
           SELECT PROVFILE ASSIGN TO "PROVFILE"
               ORGANIZATION IS LINE SEQUENTIAL
               FILE STATUS IS WS-PROV-STATUS.
           SELECT CBSAFILE ASSIGN TO "CBSAFILE"
               ORGANIZATION IS LINE SEQUENTIAL
               FILE STATUS IS WS-CBSA-STATUS.
           SELECT MSAFILE  ASSIGN TO "MSAFILE"
               ORGANIZATION IS LINE SEQUENTIAL
               FILE STATUS IS WS-MSA-STATUS.
           SELECT RATEFILE ASSIGN TO "RATEFILE"
               ORGANIZATION IS LINE SEQUENTIAL
               FILE STATUS IS WS-RATE-STATUS.

       DATA DIVISION.
       FILE SECTION.

       FD  BILLFILE.
       01  BILL-RECORD                PIC X(315).

       FD  PROVFILE.
       01  PROV-RECORD                PIC X(240).

       FD  CBSAFILE.
       01  CBSA-RECORD                PIC X(80).

       FD  MSAFILE.
       01  MSA-RECORD                 PIC X(80).

       FD  RATEFILE.
       01  RATE-RECORD                PIC X(315).

       WORKING-STORAGE SECTION.
       01  WS-BILL-STATUS             PIC XX.
       01  WS-PROV-STATUS             PIC XX.
       01  WS-CBSA-STATUS             PIC XX.
       01  WS-MSA-STATUS              PIC XX.
       01  WS-RATE-STATUS             PIC XX.

       01  WS-EOF-BILL                PIC 9 VALUE 0.
       01  WS-EOF-PROV                PIC 9 VALUE 0.
       01  WS-EOF-CBSA                PIC 9 VALUE 0.
       01  WS-EOF-MSA                 PIC 9 VALUE 0.

       01  WS-BILL-CTR                PIC 9(09) VALUE 0.
       01  WS-PROV-CTR                PIC 9(09) VALUE 0.
       01  WS-CBSA-CTR                PIC 9(09) VALUE 0.
       01  WS-MSA-CTR                 PIC 9(09) VALUE 0.
       01  WS-RATE-CTR                PIC 9(09) VALUE 0.
       01  WS-ERR-CTR                 PIC 9(09) VALUE 0.

       01  WS-HOSDR210                PIC X(08) VALUE "HOSDR210".

       01  WS-DISPLAY-LINE            PIC X(80).

      *---------------------------------------------------------------*
      * CBSA input record parsing
      *---------------------------------------------------------------*
       01  WS-CBSA-IN.
           05  WS-CBSA-CODE           PIC X(05).
           05  FILLER                  PIC X(01).
           05  WS-CBSA-EFF            PIC X(08).
           05  FILLER                  PIC X(01).
           05  WS-CBSA-WI-RAW         PIC 9(02)V9(04).
           05  FILLER                  PIC X(59).

       01  WS-CBSA-WI-NUM             PIC S9(02)V9(04).

      *---------------------------------------------------------------*
      * MSA input record parsing (5-byte MSA-LUGAR + 8 EffDt + WI)
      *---------------------------------------------------------------*
       01  WS-MSA-IN.
           05  WS-MSA-CODE            PIC X(04).
           05  WS-MSA-LUGAR           PIC X(01).
           05  FILLER                  PIC X(01).
           05  WS-MSA-EFF             PIC X(08).
           05  FILLER                  PIC X(01).
           05  WS-MSA-WI-RAW          PIC 9(02)V9(04).
           05  FILLER                  PIC X(59).

       01  WS-MSA-WI-NUM              PIC S9(02)V9(04).

      *---------------------------------------------------------------*
      * Provider record parsing (240 bytes = 3 x 80-byte segments)
      *---------------------------------------------------------------*
       01  WS-PROV-IN.
           05  WS-PROV-SEG1           PIC X(80).
           05  WS-PROV-SEG2           PIC X(80).
           05  WS-PROV-SEG3           PIC X(80).

      *---------------------------------------------------------------*
      * BILL RECORD - 315 RECORD LENGTH LAYOUT (passed to HOSDR210)
      *---------------------------------------------------------------*
       01  WS-BILL-315-DATA.
           10  WS-BILL-NPI            PIC X(10).
           10  WS-BILL-PROV-NO        PIC X(06).
           10  WS-BILL-FROM-DATE.
               15  WS-BILL-FROM-CC    PIC 99.
               15  WS-BILL-FROM-YY    PIC 99.
               15  WS-BILL-FROM-MM    PIC 99.
               15  WS-BILL-FROM-DD    PIC 99.
           10  WS-BILL-ADMISSION-DATE.
               15  WS-BILL-ADM-CC     PIC 99.
               15  WS-BILL-ADM-YY     PIC 99.
               15  WS-BILL-ADM-MM     PIC 99.
               15  WS-BILL-ADM-DD     PIC 99.
           10  FILLER                  PIC X(10).
           10  WS-BILL-PROV-CBSA      PIC X(05).
           10  WS-BILL-BENE-CBSA      PIC X(05).
           10  WS-BILL-PROV-WAGE      PIC 9(02)V9(04).
           10  WS-BILL-BENE-WAGE      PIC 9(02)V9(04).
           10  FILLER                  PIC X(28).
           10  WS-BILL-QIP-IND        PIC X.
           10  WS-BILL-REV1           PIC X(04).
           10  FILLER                  PIC X(28).
           10  FILLER                  PIC X(168).
           10  WS-BILL-PAY-TOTAL      PIC 9(06)V99.
           10  WS-BILL-RTC            PIC XX.
           10  WS-BILL-HIGH-DAYS      PIC 99.
           10  WS-BILL-LOW-DAYS       PIC 99.
           10  WS-BILL-TEST-CASE      PIC X(08).

      *---------------------------------------------------------------*
      * In-memory tables - same layout as HOSDR210 LINKAGE SECTION
      *---------------------------------------------------------------*
       01  WS-PROV-TABLE.
           02  PROV-ENTRIES            OCCURS 2400
                                       INDEXED BY PX1.
               10  PROV-DATA1.
                   15  PROV-NPI10.
                       20  PROV-NPI8   PIC X(08).
                       20  PROV-NPI-FIL PIC X(02).
                   15  PROV-NO         PIC X(06).
                   15  PROV-EFF-DATE   PIC X(08).
                   15  FILLER          PIC X(56).

       01  WS-PROV-DATA-2.
           02  PROV-ENTRIES2           OCCURS 2400
                                       INDEXED BY PD2.
               10  PROV-DATA2          PIC X(80).

       01  WS-PROV-DATA-3.
           02  PROV-ENTRIES3           OCCURS 2400
                                       INDEXED BY PD3.
               10  PROV-DATA3          PIC X(80).

       01  WS-MSA-WI-TABLE.
           05  M-MSA-DATA             OCCURS 4000
                                      INDEXED BY MU1.
               10  MSA-MSA-LUGAR.
                   15  MSA-MSA         PIC 9(04).
                   15  MSA-LUGAR       PIC X.
               10  MSA-EFFDTE          PIC X(08).
               10  MSA-WAGE-IND        PIC S9(02)V9(04).

       01  WS-CBSA-WI-TABLE.
           05  M-CBSA-DATA            OCCURS 9000
                                      INDEXED BY CU1.
               10  M-CBSA             PIC 9(05).
               10  M-CBSA-EFFDTE      PIC X(08).
               10  M-CBSA-WAGE-IND    PIC S9(02)V9(04).

       PROCEDURE DIVISION.

       0000-MAIN.
           DISPLAY "=========================================="
           DISPLAY " HOSOP210 - Hospice Pricer Batch Driver"
           DISPLAY " (GnuCOBOL Test Environment)"
           DISPLAY "=========================================="

           INITIALIZE WS-PROV-TABLE
           INITIALIZE WS-PROV-DATA-2
           INITIALIZE WS-PROV-DATA-3
           INITIALIZE WS-MSA-WI-TABLE
           INITIALIZE WS-CBSA-WI-TABLE

           PERFORM 1000-LOAD-PROV-FILE
              THRU 1000-LOAD-PROV-EXIT

           PERFORM 2000-LOAD-CBSA-FILE
              THRU 2000-LOAD-CBSA-EXIT

           PERFORM 2500-LOAD-MSA-FILE
              THRU 2500-LOAD-MSA-EXIT

           PERFORM 3000-PROCESS-BILLS
              THRU 3000-PROCESS-BILLS-EXIT

           DISPLAY "=========================================="
           DISPLAY " Processing Complete"
           DISPLAY " Bills  read:     " WS-BILL-CTR
           DISPLAY " Rates  written:  " WS-RATE-CTR
           DISPLAY " Errors:          " WS-ERR-CTR
           DISPLAY " Providers loaded:" WS-PROV-CTR
           DISPLAY " CBSA recs loaded:" WS-CBSA-CTR
           DISPLAY " MSA  recs loaded:" WS-MSA-CTR
           DISPLAY "=========================================="

           STOP RUN.


      *================================================================*
      * 1000 - LOAD PROVIDER FILE
      *================================================================*
       1000-LOAD-PROV-FILE.
           OPEN INPUT PROVFILE
           IF WS-PROV-STATUS NOT = "00"
               DISPLAY "ERROR: Cannot open PROVFILE. Status="
                   WS-PROV-STATUS
               STOP RUN
           END-IF

           MOVE 0 TO WS-PROV-CTR
           SET PX1 TO 1

           PERFORM UNTIL WS-EOF-PROV = 1
               READ PROVFILE INTO WS-PROV-IN
                   AT END
                       MOVE 1 TO WS-EOF-PROV
                   NOT AT END
                       ADD 1 TO WS-PROV-CTR
                       IF WS-PROV-CTR > 2400
                           DISPLAY "WARNING: PROV-TABLE full at "
                               "2400 entries"
                           MOVE 1 TO WS-EOF-PROV
                       ELSE
                           MOVE WS-PROV-SEG1
                               TO PROV-DATA1(WS-PROV-CTR)
                           MOVE WS-PROV-SEG2
                               TO PROV-DATA2(WS-PROV-CTR)
                           MOVE WS-PROV-SEG3
                               TO PROV-DATA3(WS-PROV-CTR)
                           SET PX1 UP BY 1
                       END-IF
               END-READ
           END-PERFORM

           CLOSE PROVFILE
           DISPLAY "Providers loaded: " WS-PROV-CTR.

       1000-LOAD-PROV-EXIT. EXIT.


      *================================================================*
      * 2000 - LOAD CBSA WAGE INDEX FILE
      *================================================================*
       2000-LOAD-CBSA-FILE.
           OPEN INPUT CBSAFILE
           IF WS-CBSA-STATUS NOT = "00"
               DISPLAY "ERROR: Cannot open CBSAFILE. Status="
                   WS-CBSA-STATUS
               STOP RUN
           END-IF

           MOVE 0 TO WS-CBSA-CTR
           SET CU1 TO 1

           PERFORM UNTIL WS-EOF-CBSA = 1
               READ CBSAFILE INTO WS-CBSA-IN
                   AT END
                       MOVE 1 TO WS-EOF-CBSA
                   NOT AT END
                       ADD 1 TO WS-CBSA-CTR
                       IF WS-CBSA-CTR > 9000
                           DISPLAY "WARNING: CBSA-TABLE full at "
                               "9000 entries"
                           MOVE 1 TO WS-EOF-CBSA
                       ELSE
                           MOVE WS-CBSA-CODE
                               TO M-CBSA(WS-CBSA-CTR)
                           MOVE WS-CBSA-EFF
                               TO M-CBSA-EFFDTE(WS-CBSA-CTR)
      *                    Convert 6-digit raw to S9(02)V9(04)
                           MOVE WS-CBSA-WI-RAW
                               TO M-CBSA-WAGE-IND(WS-CBSA-CTR)
                           SET CU1 UP BY 1
                       END-IF
               END-READ
           END-PERFORM

           CLOSE CBSAFILE
           DISPLAY "CBSA records loaded: " WS-CBSA-CTR.

       2000-LOAD-CBSA-EXIT. EXIT.


      *================================================================*
      * 2500 - LOAD MSA WAGE INDEX FILE (OPTIONAL)
      *================================================================*
       2500-LOAD-MSA-FILE.
           OPEN INPUT MSAFILE
           IF WS-MSA-STATUS NOT = "00"
               DISPLAY "INFO: MSAFILE not available (Status="
                   WS-MSA-STATUS "). Pre-2006 claims unsupported."
               GO TO 2500-LOAD-MSA-EXIT
           END-IF

           MOVE 0 TO WS-MSA-CTR
           SET MU1 TO 1

           PERFORM UNTIL WS-EOF-MSA = 1
               READ MSAFILE INTO WS-MSA-IN
                   AT END
                       MOVE 1 TO WS-EOF-MSA
                   NOT AT END
                       ADD 1 TO WS-MSA-CTR
                       IF WS-MSA-CTR > 4000
                           DISPLAY "WARNING: MSA-TABLE full at "
                               "4000 entries"
                           MOVE 1 TO WS-EOF-MSA
                       ELSE
                           MOVE WS-MSA-CODE
                               TO MSA-MSA(WS-MSA-CTR)
                           MOVE WS-MSA-LUGAR
                               TO MSA-LUGAR(WS-MSA-CTR)
                           MOVE WS-MSA-EFF
                               TO MSA-EFFDTE(WS-MSA-CTR)
                           MOVE WS-MSA-WI-RAW
                               TO MSA-WAGE-IND(WS-MSA-CTR)
                           SET MU1 UP BY 1
                       END-IF
               END-READ
           END-PERFORM

           CLOSE MSAFILE
           DISPLAY "MSA records loaded: " WS-MSA-CTR.

       2500-LOAD-MSA-EXIT. EXIT.


      *================================================================*
      * 3000 - PROCESS BILL RECORDS
      *================================================================*
       3000-PROCESS-BILLS.
           OPEN INPUT BILLFILE
           IF WS-BILL-STATUS NOT = "00"
               DISPLAY "ERROR: Cannot open BILLFILE. Status="
                   WS-BILL-STATUS
               STOP RUN
           END-IF

           OPEN OUTPUT RATEFILE
           IF WS-RATE-STATUS NOT = "00"
               DISPLAY "ERROR: Cannot open RATEFILE. Status="
                   WS-RATE-STATUS
               STOP RUN
           END-IF

           PERFORM UNTIL WS-EOF-BILL = 1
               READ BILLFILE INTO WS-BILL-315-DATA
                   AT END
                       MOVE 1 TO WS-EOF-BILL
                   NOT AT END
                       ADD 1 TO WS-BILL-CTR

                       CALL WS-HOSDR210 USING
                           WS-BILL-315-DATA
                           WS-PROV-TABLE
                           WS-PROV-DATA-2
                           WS-PROV-DATA-3
                           WS-MSA-WI-TABLE
                           WS-CBSA-WI-TABLE

                       DISPLAY "Bill #" WS-BILL-CTR
                           " [" WS-BILL-TEST-CASE "]"
                           " Prov=" WS-BILL-PROV-NO
                           " From=" WS-BILL-FROM-DATE
                           " RTC=" WS-BILL-RTC
                           " Pay=" WS-BILL-PAY-TOTAL
                           " H=" WS-BILL-HIGH-DAYS
                           " L=" WS-BILL-LOW-DAYS

                       IF WS-BILL-RTC NOT = "00"
                       AND WS-BILL-RTC NOT = "73"
                       AND WS-BILL-RTC NOT = "74"
                       AND WS-BILL-RTC NOT = "75"
                       AND WS-BILL-RTC NOT = "77"
                           ADD 1 TO WS-ERR-CTR
                       END-IF

                       WRITE RATE-RECORD
                           FROM WS-BILL-315-DATA
                       ADD 1 TO WS-RATE-CTR
               END-READ
           END-PERFORM

           CLOSE BILLFILE
           CLOSE RATEFILE.

       3000-PROCESS-BILLS-EXIT. EXIT.
