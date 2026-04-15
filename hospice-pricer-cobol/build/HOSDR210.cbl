       IDENTIFICATION DIVISION.
       PROGRAM-ID.           HOSDR210.
      *AUTHOR.  DDS TEAM
      *         (CENTERS FOR MEDICARE AND MEDICAID SERVICES)
      *REMARKS. A). HOSPICE DRIVER WILL CALL HOSPR___ MODULE.
      *             CALLS THE HOSPR___ MODULE.
      *             LOADS THE PROV FILE MSA FILEAND CBSA FILE.
      *             FINDS THE PROV RECORD AND WAGE-INDEX RECORD FOR
      *             GIVEN HOSPICE DATA TO BE PASSED TO HOSPR___ MODULE.
      ******************************************************************
      *REMARKS.
      ******** PROD VERSION FOR FY2021   ************************
      *
      *     HOSPR210   REVISIONS FOR OCT 1, 2020
      *                2021 RATE REVISIONS
      *     HOSDR210   NEW PROCESSES OCT 1, 2020
      *                2020 CBSA WAGE INDEX DATA
      *                CALL TO HOSPR210
      *     HOSOP210   NEW PROCESSES OCT 1, 2020
      *                CICS VERSION TO OPEN FILES CALL HOSDR210
      *
      ******** PROD VERSION FOR FY2020   ************************
      *
      *     HOSPR200   REVISIONS FOR OCT 1, 2019
      *                2020 RATE REVISIONS
      *     HOSDR200   NEW PROCESSES OCT 1, 2019
      *                2019 CBSA WAGE INDEX DATA
      *                CALL TO HOSPR200
      *     HOSOP200   NEW PROCESSES OCT 1, 2019
      *                CICS VERSION TO OPEN FILES CALL HOSDR200
      *
      ******** PROD VERSION FOR FY2019 - PRODUCTION     ****************
      *
      *     HOSPR190   REVISIONS FOR OCT 1, 2018
      *                2019 RATE REVISIONS
      *     HOSDR190   NEW PROCESSES OCT 1, 2018
      *                2019 CBSA WAGE INDEX DATA
      *                CALL TO HOSPR190
      *     HOSOP190   NEW PROCESSES OCT 1, 2018
      *                CICS VERSION TO OPEN FILES CALL HOSDR190
      *
      ******** BETA VERSION FOR FY2019 - TESTING ONLY ***********
      *
      *     HOSPR19B   REVISIONS FOR OCT 1, 2018
      *                2017 RATE REVISIONS
      *     HOSDR19B   NEW PROCESSES OCT 1, 2018
      *                CALL TO HOSPR19B
      *     HOSOP19B   NEW PROCESSES OCT 1, 2018
      *                CICS VERSION TO OPEN FILES CALL HOSDR19B
      ******** BETA VERSION FOR FY2019 - TESTING ONLY ***********
      *
      *
      *     HOSPR180   REVISIONS FOR OCT 1, 2017
      *                2017 RATE REVISIONS
      *     HOSDR180   NEW PROCESSES OCT 1, 2017
      *                CALL TO HOSPR180
      *     HOSOP180   NEW PROCESSES OCT 1, 2017
      *                CICS VERSION TO OPEN FILES CALL HOSDR180
      *
      *
      *     HOSPR170   REVISIONS FOR OCT 1, 2016
      *                2017 RATE REVISIONS
      *     HOSDR170   NEW PROCESSES OCT 1, 2016
      *                CALL TO HOSPR170
      *     HOSOP170   NEW PROCESSES OCT 1, 2016
      *                CICS VERSION TO OPEN FILES CALL HOSDR170
      *
      *     HOSPR162   REVISIONS FOR JAN 1, 2016
      *         ==>>>> 2016 LOGIC UPDATE - TYPO CORRECTION
      *     HOSDR162   NEW PROCESSES JAN 1, 2016
      *                CALL TO HOSPR162
      *     HOSOP162   NEW PROCESSES JAN 1, 2016
      *                CICS VERSION TO OPEN FILES CALL HOSDR162
      *
      *     HOSPR161   REVISIONS FOR JAN 1, 2016
      *                2016 RATE REVISIONS
      *         ==>>>> REVISED BILL RECORD LENGTH FROM 215 TO 315
      *         ==>>>> 2016 LOGIC CHANGES
      *     HOSDR161   NEW PROCESSES JAN 1, 2016
      *                CALL TO HOSPR161
      *         ==>>>> REVISED BILL RECORD LENGTH FROM 215 TO 315
      *     HOSOP161   NEW PROCESSES JAN 1, 2016
      *                CICS VERSION TO OPEN FILES CALL HOSDR161
      *
      *     HOSPR160   REVISIONS FOR OCT 1, 2015
      *                2016 RATE REVISIONS
      *     HOSDR160   NEW PROCESSES OCT 1, 2015
      *                CALL TO HOSPR160
      *     HOSOP160   NEW PROCESSES OCT 1, 2015
      *                CICS VERSION TO OPEN FILES CALL HOSDR160
      *
      *     HOSPR150   REVISIONS FOR OCT 1, 2014
      *                2015 RATE REVISIONS
      *     HOSDR150   NEW PROCESSES OCT 1, 2014
      *                CALL TO HOSPR150
      *     HOSOP150   NEW PROCESSES OCT 1, 2014
      *                CICS VERSION TO OPEN FILES CALL HOSDR150
      *
      *     HOSPR140   REVISIONS FOR OCT 1, 2013
      *                2014 RATE REVISIONS
      *         ==>>>> REVISED BILL & RATE RECORD LENGTH FROM 135 TO 215
      *         ==>>>> NEW LOGIC FOR QIP INDICATOR
      *     HOSDR140   NEW PROCESSES OCT 1, 2013
      *                CALL TO HOSPR140
      *     HOSOP140   NEW PROCESSES OCT 1, 2013
      *                CICS VERSION TO OPEN FILES CALL HOSDR140
      *
      *     HOSPR130   REVISIONS FOR OCT 1, 2012
      *                2013 RATE REVISIONS
      *     HOSDR130   NEW PROCESSES OCT 1, 2012
      *                CALL TO HOSPR130
      *     HOSOP130   NEW PROCESSES OCT 1, 2012
      *                CICS VERSION TO OPEN FILES CALL HOSDR130
      *
      *     HOSPR120   REVISIONS FOR OCT 1, 2011
      *                2012 RATE REVISIONS
      *     HOSDR120   NEW PROCESSES OCT 1, 2011
      *                CALL TO HOSPR120
      *     HOSOP120   NEW PROCESSES OCT 1, 2011
      *                CICS VERSION TO OPEN FILES CALL HOSDR120
      *
      *     HOSPR110   REVISIONS FOR OCT 1, 2010
      *                2011 RATE REVISIONS
      *     HOSDR110   NEW PROCESSES OCT 1, 2010
      *                CALL TO HOSPR110
      *     HOSOP110   NEW PROCESSES OCT 1, 2010
      *                CICS VERSION TO OPEN FILES CALL HOSDR110
      *
      *     HOSPR100   REVISIONS FOR OCT 1, 2009
      *                2010 RATE REVISIONS
      *     HOSDR100   NEW PROCESSES OCT 1, 2009
      *                CALL TO HOSPR100
      *     HOSOP100   NEW PROCESSES OCT 1, 2009
      *                CICS VERSION TO OPEN FILES CALL HOSDR100
      *
      *     HOSPR091   REVISIONS FOR JAN 1, 2008
      *                2009 RATE REVISIONS
      *     HOSDR091   NEW PROCESSES JAN 1, 2008
      *                CALL TO HOSPR091
      *                STIMULUS PKG RECOMPILE
      *     HOSOP091   NEW PROCESSES JAN 1, 2008
      *                CICS VERSION TO OPEN FILES CALL HOSDR091
      *
      *     HOSPR090   REVISIONS FOR OCT 1, 2008
      *                2008 RATE REVISIONS
      *     HOSDR090   NEW PROCESSES OCT 1, 2008
      *                CALL TO HOSPR090
      *     HOSOP090   NEW PROCESSES OCT 1, 2008
      *                CICS VERSION TO OPEN FILES CALL HOSDR090
      *
      *     HOSPR081   REVISIONS FOR OCT 1, 2007
      *                2008 RATE REVISIONS
      *     HOSDR081   NEW PROCESSES OCT 1, 2007
      *                CALL TO HOSPR081
      *     HOSOP081   NEW PROCESSES OCT 1, 2007
      *                CICS VERSION TO OPEN FILES CALL HOSDR081
      *
      *     HOSPR071   REVISIONS FOR JAN 1, 2007
      *                2007.1-PROCESS-DATA 1 UNIT = 15 MIN CODE 652
      *                2007 CALCULATE HOME RATE BY REVENUE CODE FACTORS
      *     HOSDR071   NEW PROCESSES JAN 1, 2007
      *                CALL TO HOSPR071
      *     HOSOP071   NEW PROCESSES JAN 1, 2007
      *                CICS VERSION TO OPEN FILES CALL HOSDR071
      *
      *     HOSPR070   REVISIONS FOR OCT 1, 2006
      *                2007-PROCESS-DATA
      *                2007 CALCULATE HOME RATE BY REVENUE CODE FACTORS
      *     HOSDR070   NEW PROCESSES OCT 1, 2006
      *                CBSA FILE PROCESSING
      *     HOSOP070   NEW PROCESSES OCT 1, 2006
      *                CICS VERSION TO OPEN FILES
      *
      ***************************************************************
       DATE-COMPILED.
       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       SOURCE-COMPUTER.            IBM-370.
       OBJECT-COMPUTER.            IBM-370.
       INPUT-OUTPUT  SECTION.
       FILE-CONTROL.
      
       DATA DIVISION.
       FILE SECTION.
      
       WORKING-STORAGE SECTION.
       01  W-STORAGE-REF                  PIC X(46)  VALUE
           'HOSDR210      - W O R K I N G   S T O R A G E'.
       01  HOS-VERSION                    PIC X(09)  VALUE 'HOSDR210'.
       01  HOSOP210                       PIC X(08)  VALUE 'HOSOP210'.
       01  HOSPR210                       PIC X(08)  VALUE 'HOSPR210'.
       01  EOF-MSA-SW                     PIC 9(01)  VALUE 0.
       01  EOF-CBSA-SW                    PIC 9(01)  VALUE 0.
       01  EOF-BILL-SW                    PIC 9(01)  VALUE 0.
       01  EOF-PROV-SW                    PIC 9(01)  VALUE 0.
       01  BILL-CTR                       PIC 9(09)  VALUE 0.
       01  RATE-CTR                       PIC 9(09)  VALUE 0.
       01  PROV-CTR                       PIC 9(09)  VALUE 0.
      
       01  SEARCH-MSA-LUGAR.
           05  SEARCH-MSA.
               10  SEARCH-MSA-POS12  PIC 9(02).
               10  SEARCH-MSA-POS34  PIC 9(02).
           05  SEARCH-LUGAR          PIC X.
      
       01  SEARCH-CBSA.
           05  SEARCH-CBSA-POS123    PIC 9(03).
           05  SEARCH-CBSA-POS45     PIC 9(02).
      
       01  UT1-STAT.
           05  UT1-STAT1             PIC X.
           05  UT1-STAT2             PIC X.
       01  UT2-STAT.
           05  UT2-STAT1             PIC X.
           05  UT2-STAT2             PIC X.
       01  UT3-STAT.
           05  UT3-STAT1             PIC X.
           05  UT3-STAT2             PIC X.
       01  UT4-STAT.
           05  UT4-STAT1             PIC X.
           05  UT4-STAT2             PIC X.
       01  UT5-STAT.
           05  UT5-STAT1             PIC X.
           05  UT5-STAT2             PIC X.
      
      **************************************************************
      *      MILLINNIUM COMPATIBLE                                 *
      **************************************************************
       01  PROV-NEW-HOLD.
           02  PROV-NEWREC-HOLD1.
               05  P-NEW-NPI10.
                   10  P-NEW-NPI8             PIC X(08).
                   10  P-NEW-NPI-FILLER       PIC X(02).
               05  P-NEW-PROVIDER-NO.
                   10  P-NEW-STATE            PIC 9(02).
                   10  FILLER                 PIC X(04).
               05  P-NEW-DATE-DATA.
                   10  P-NEW-EFF-DATE.
                       15  P-NEW-EFF-DT-CC    PIC 9(02).
                       15  P-NEW-EFF-DT-YY    PIC 9(02).
                       15  P-NEW-EFF-DT-MM    PIC 9(02).
                       15  P-NEW-EFF-DT-DD    PIC 9(02).
                   10  P-NEW-FY-BEGIN-DATE.
                       15  P-NEW-FY-BEG-DT-CC PIC 9(02).
                       15  P-NEW-FY-BEG-DT-YY PIC 9(02).
                       15  P-NEW-FY-BEG-DT-MM PIC 9(02).
                       15  P-NEW-FY-BEG-DT-DD PIC 9(02).
                   10  P-NEW-REPORT-DATE.
                       15  P-NEW-REPORT-DT-CC PIC 9(02).
                       15  P-NEW-REPORT-DT-YY PIC 9(02).
                       15  P-NEW-REPORT-DT-MM PIC 9(02).
                       15  P-NEW-REPORT-DT-DD PIC 9(02).
                   10  P-NEW-TERMINATION-DATE.
                       15  P-NEW-TERM-DT-CC   PIC 9(02).
                       15  P-NEW-TERM-DT-YY   PIC 9(02).
                       15  P-NEW-TERM-DT-MM   PIC 9(02).
                       15  P-NEW-TERM-DT-DD   PIC 9(02).
               05  P-NEW-WAIVER-CODE          PIC X(01).
                   88  P-NEW-WAIVER-STATE       VALUE 'Y'.
               05  P-NEW-INTER-NO             PIC 9(05).
               05  P-NEW-PROVIDER-TYPE        PIC X(02).
                   88  P-N-SOLE-COMMUNITY-PROV    VALUE '01' '11'.
                   88  P-N-REFERRAL-CENTER        VALUE '07' '11'
                                                        '15' '17'
                                                        '22'.
                   88  P-N-INDIAN-HEALTH-SERVICE  VALUE '08'.
                   88  P-N-REDESIGNATED-RURAL-YR1 VALUE '09'.
                   88  P-N-REDESIGNATED-RURAL-YR2 VALUE '10'.
                   88  P-N-SOLE-COM-REF-CENT      VALUE '11'.
                   88  P-N-MDH-REBASED-FY90       VALUE '14' '15'.
                   88  P-N-MDH-RRC-REBASED-FY90   VALUE '15'.
                   88  P-N-SCH-REBASED-FY90       VALUE '16' '17'.
                   88  P-N-SCH-RRC-REBASED-FY90   VALUE '17'.
                   88  P-N-MEDICAL-ASSIST-FACIL   VALUE '18'.
                   88  P-N-EACH                   VALUE '21' '22'.
                   88  P-N-EACH-REFERRAL-CENTER   VALUE '22'.
                   88  P-N-NHCMQ-II-SNF           VALUE '32'.
                   88  P-N-NHCMQ-III-SNF          VALUE '33'.
               05  P-NEW-CURRENT-CENSUS-DIV   PIC 9(01).
                   88  P-N-NEW-ENGLAND            VALUE  1.
                   88  P-N-MIDDLE-ATLANTIC        VALUE  2.
                   88  P-N-SOUTH-ATLANTIC         VALUE  3.
                   88  P-N-EAST-NORTH-CENTRAL     VALUE  4.
                   88  P-N-EAST-SOUTH-CENTRAL     VALUE  5.
                   88  P-N-WEST-NORTH-CENTRAL     VALUE  6.
                   88  P-N-WEST-SOUTH-CENTRAL     VALUE  7.
                   88  P-N-MOUNTAIN               VALUE  8.
                   88  P-N-PACIFIC                VALUE  9.
               05  P-NEW-CURRENT-DIV   REDEFINES
                          P-NEW-CURRENT-CENSUS-DIV   PIC 9(01).
                   88  P-N-VALID-CENSUS-DIV    VALUE 1 THRU 9.
               05  P-NEW-MSA-DATA.
                   10  P-NEW-CHG-CODE-INDEX       PIC X.
                   10  P-NEW-GEO-LOC-MSAX         PIC X(04) JUST RIGHT.
                   10  P-NEW-GEO-LOC-MSAX-RUR REDEFINES
                                           P-NEW-GEO-LOC-MSAX.
                       15  P-NEW-RURAL1    PIC X(02).
                           88  P-NEW-GEO-RURAL1   VALUE '  '.
                       15  P-NEW-GEO-RURAL2    PIC X(02).
                   10  P-NEW-GEO-LOC-MSA9   REDEFINES
                                   P-NEW-GEO-LOC-MSAX-RUR PIC 9(04).
                   10  P-NEW-WAGE-INDEX-LOC-MSA   PIC X(04) JUST RIGHT.
                   10  P-NEW-STAND-AMT-LOC-MSA    PIC X(04) JUST RIGHT.
                   10  P-NEW-STAND-AMT-LOC-MSA9
             REDEFINES P-NEW-STAND-AMT-LOC-MSA.
                       15  P-NEW-RURAL-1ST.
                           20  P-NEW-STAND-RURAL  PIC XX.
                               88  P-NEW-STD-RURAL-CHECK VALUE '  '.
                       15  P-NEW-RURAL-2ND        PIC XX.
               05  P-NEW-SOL-COM-DEP-HOSP-YR PIC XX.
                       88  P-NEW-SCH-YRBLANK    VALUE   '  '.
                       88  P-NEW-SCH-YR82       VALUE   '82'.
                       88  P-NEW-SCH-YR87       VALUE   '87'.
               05  P-NEW-LUGAR                    PIC X.
               05  P-NEW-TEMP-RELIEF-IND          PIC X.
               05  P-NEW-FED-PPS-BLEND-IND        PIC X.
               05  FILLER                         PIC X(05).
           02  PROV-NEWREC-HOLD2.
               05  P-NEW-VARIABLES.
                   10  P-NEW-FAC-SPEC-RATE       PIC 9(05)V9(02).
                   10  P-NEW-COLA                PIC 9(01)V9(03).
                   10  P-NEW-INTERN-RATIO        PIC 9(01)V9(04).
                   10  P-NEW-BED-SIZE            PIC 9(05).
                   10  P-NEW-OPER-CSTCHG-RATIO   PIC 9(01)V9(03).
                   10  P-NEW-CMI                 PIC 9(01)V9(04).
                   10  P-NEW-SSI-RATIO           PIC V9(04).
                   10  P-NEW-MEDICAID-RATIO      PIC V9(04).
                   10  P-NEW-PPS-BLEND-YR-IND    PIC X(01).
                   10  P-NEW-PRUP-UPDATE-FACTOR  PIC 9(01)V9(05).
                   10  P-NEW-DSH-PERCENT         PIC V9(04).
                   10  P-NEW-FYE-DATE            PIC 9(08).
               05  P-NEW-CBSA-DATA.
                   10  W-P-NEW-CBSA-SPEC-PAY-IND     PIC X.
                       88  P-NEW-CBSA-WI-GEO        VALUE 'N'.
                       88  P-NEW-CBSA-WI-RECLASS    VALUE 'Y'.
                       88  P-NEW-CBSA-WI-SPECIAL    VALUE '1' '2'.
      ***                  1 = ANYTHING OR HOLD HARMLESS WITH SPEC WI
      ***                  2 = RECLASS WITH SPEC WI
                   10  W-P-NEW-CBSA-HOSP-QUAL-IND    PIC X.
      
                   10  W-P-NEW-CBSA-GEO-LOC       PIC X(05) JUST RIGHT.
                   10  W-P-NEW-CBSA-GEO-RURAL REDEFINES
                       W-P-NEW-CBSA-GEO-LOC.
                       15  W-P-NEW-CBSA-GEO-RURAL1ST PIC XXX.
                           88  W-P-NEW-CBSA-GEO-RURAL1  VALUE '   '.
                       15  W-P-NEW-CBSA-GEO-RURAL2ND PIC XX.
      
                   10  W-P-NEW-CBSA-RECLASS-LOC   PIC X(05) JUST RIGHT.
                   10  W-P-NEW-CBSA-STAND-AMT-LOC PIC X(05) JUST RIGHT.
                   10  W-P-NEW-CBSA-SPEC-WAGE-INDEX  PIC 9(02)V9(04).
           02  PROV-NEWREC-HOLD3.
               05  P-NEW-PASS-AMT-DATA.
                   10  P-NEW-PASS-AMT-CAPITAL    PIC 9(04)V99.
                   10  P-NEW-PASS-AMT-DIR-MED-ED PIC 9(04)V99.
                   10  P-NEW-PASS-AMT-ORGAN-ACQ  PIC 9(04)V99.
                   10  P-NEW-PASS-AMT-PLUS-MISC  PIC 9(04)V99.
               05  P-NEW-CAPI-DATA.
                   15  P-NEW-CAPI-PPS-PAY-CODE   PIC X.
                   15  P-NEW-CAPI-HOSP-SPEC-RATE PIC 9(04)V99.
                   15  P-NEW-CAPI-OLD-HARM-RATE  PIC 9(04)V99.
                   15  P-NEW-CAPI-NEW-HARM-RATIO PIC 9(01)V9999.
                   15  P-NEW-CAPI-CSTCHG-RATIO   PIC 9V999.
                   15  P-NEW-CAPI-NEW-HOSP       PIC X.
                   15  P-NEW-CAPI-IME            PIC 9V9999.
                   15  P-NEW-CAPI-EXCEPTIONS     PIC 9(04)V99.
                   15  P-VAL-BASED-PURCH-SCORE   PIC 9V999.
               05  FILLER                        PIC X(18).
      
      
      *-------------------------------------------------------------*
      * VARIABLES TO HOLD THE BILL'S FY BEGIN AND END DATES         *
      *-------------------------------------------------------------*
       01  W-FY-BEGIN-DATE.
           05  W-FY-BEGIN-CC              PIC 9(02).
           05  W-FY-BEGIN-YY              PIC 9(02).
           05  W-FY-BEGIN-MM              PIC 9(02) VALUE 10.
           05  W-FY-BEGIN-DD              PIC 9(02) VALUE 01.
      
       01  W-FY-END-DATE.
           05  W-FY-END-CC                PIC 9(02).
           05  W-FY-END-YY                PIC 9(02).
           05  W-FY-END-MM                PIC 9(02) VALUE 09.
           05  W-FY-END-DD                PIC 9(02) VALUE 30.
      
      
      
      ******************************************************************
       LINKAGE SECTION.
      ***************************************************************
      *                 * * * * * * * * *                           *
      ***************************************************************
      ***************************************************************
      *    THIS DATA IS CALCULATED BY THIS HOSPRICER PROGRAM        *
      *    AND PASSED BACK                                          *
      *            RETURN CODE VALUES (BILL-RTC)                    *
      *                                                             *
      *            BILL-RTC                                         *
      *              00 = HOME RATE RETURNED                        *
      *                                                             *
      *              73 = LOW RHC RATE APPLIES TO ALL RHC           *
      *                                                             *
      *              74 = LOW RHC RATE WITH EOL SIA                 *
      *                                                             *
      *              75 = HIGH RHC RATE APPLIES TO SOME OR ALL RHC  *
      *                                                             *
      *              77 = HIGH RHC WITH EOL SIA                     *
      *                                                             *
      *            BILL-RTC  NO RATE RETURNED                       *
      *              10 = BAD UNITS                                 *
      *                                                             *
      *              20 = BAD UNITS2 < 8                            *
      *                                                             *
      *              30 = BAD MSA CODE OR CBSA CODE                 *
      *                                                             *
      *              40 = BAD PROV WAGE INDEX CBSA OR MSAFILE       *
      *                                                             *
      *              50 = BAD BENE WAGE INDEX CBSA OR MSAFILE       *
      *                                                             *
      *              51 = BAD PROV NUMBER                           *
      *                                                             *
      ***************************************************************
      
      *-------------------------------------------------------------*
      *  BILL RECORD - 315 RECORD LENGTH LAYOUT                     *
      *  CONTAINS INPUT AND OUTPUT VALUES                           *
      *-------------------------------------------------------------*
       01  BILL-315-DATA.
           10  BILL-NPI                PIC X(10).
           10  BILL-PROV-NO            PIC X(06).
      *
           10  BILL-FROM-DATE.
               15  BILL-FROM-CC        PIC 99.
               15  BILL-FROM-YY        PIC 99.
               15  BILL-FROM-MM        PIC 99.
               15  BILL-FROM-DD        PIC 99.
      *
           10  BILL-ADMISSION-DATE.
               15  BILL-ADM-CC         PIC 99.
               15  BILL-ADM-YY         PIC 99.
               15  BILL-ADM-MM         PIC 99.
               15  BILL-ADM-DD         PIC 99.
      *
           10  FILLER                  PIC X(10).
      *
           10  BILL-PROV-MSA-LUGAR.
               15  BILL-PROV-MSA       PIC X(04).
               15  BILL-PROV-LUGAR     PIC X.
           10  BILL-PROV-CBSA          REDEFINES
                   BILL-PROV-MSA-LUGAR         PIC X(05).
      *
           10  BILL-BENE-MSA-LUGAR.
               15 BILL-BENE-MSA        PIC X(04).
               15 BILL-BENE-LUGAR      PIC X.
           10  BILL-BENE-CBSA          REDEFINES
                    BILL-BENE-MSA-LUGAR         PIC X(05).
      *
           10  BILL-PROV-WAGE-INDEX    PIC 9(02)V9(04).
           10  BILL-BENE-WAGE-INDEX    PIC 9(02)V9(04).
      *
           10  BILL-SIA-ADD-ON-UNITS.
               15  BILL-NA-ADD-ON-DAY1-UNITS   PIC 99.
               15  BILL-NA-ADD-ON-DAY2-UNITS   PIC 99.
               15  BILL-EOL-ADD-ON-DAY1-UNITS  PIC 99.
               15  BILL-EOL-ADD-ON-DAY2-UNITS  PIC 99.
               15  BILL-EOL-ADD-ON-DAY3-UNITS  PIC 99.
               15  BILL-EOL-ADD-ON-DAY4-UNITS  PIC 99.
               15  BILL-EOL-ADD-ON-DAY5-UNITS  PIC 99.
               15  BILL-EOL-ADD-ON-DAY6-UNITS  PIC 99.
               15  BILL-EOL-ADD-ON-DAY7-UNITS  PIC 99.
      *
           10  FILLER                       PIC X(10).
           10  BILL-QIP-IND                 PIC X.
      *
           10  BILL-GROUP1.
               15  BILL-REV1                PIC XXXX.
               15  BILL-HCPC1               PIC X(05).
               15  BILL-LINE-ITEM-DOS1.
                   20  BILL-LIDOS1-CC       PIC 99.
                   20  BILL-LIDOS1-YY       PIC 99.
                   20  BILL-LIDOS1-MM       PIC 99.
                   20  BILL-LIDOS1-DD       PIC 99.
               15  BILL-UNITS1              PIC 9(07).
               15  BILL-PAY-AMT1            PIC 9(06)V99.
      *
           10  BILL-GROUP2.
               15  BILL-REV2                PIC XXXX.
               15  BILL-HCPC2               PIC X(05).
               15  BILL-LINE-ITEM-DOS2.
                   20  BILL-LIDOS2-CC       PIC 99.
                   20  BILL-LIDOS2-YY       PIC 99.
                   20  BILL-LIDOS2-MM       PIC 99.
                   20  BILL-LIDOS2-DD       PIC 99.
               15  BILL-UNITS2              PIC 9(07).
               15  BILL-PAY-AMT2            PIC 9(06)V99.
      *
           10  BILL-GROUP3.
               15  BILL-REV3                PIC XXXX.
               15  BILL-HCPC3               PIC X(05).
               15  BILL-LINE-ITEM-DOS3.
                   20  BILL-LIDOS3-CC       PIC 99.
                   20  BILL-LIDOS3-YY       PIC 99.
                   20  BILL-LIDOS3-MM       PIC 99.
                   20  BILL-LIDOS3-DD       PIC 99.
               15  BILL-UNITS3              PIC 9(07).
               15  BILL-PAY-AMT3            PIC 9(06)V99.
      *
           10  BILL-GROUP4.
               15  BILL-REV4                PIC XXXX.
               15  BILL-HCPC4               PIC X(05).
               15  BILL-LINE-ITEM-DOS4.
                   20  BILL-LIDOS4-CC       PIC 99.
                   20  BILL-LIDOS4-YY       PIC 99.
                   20  BILL-LIDOS4-MM       PIC 99.
                   20  BILL-LIDOS4-DD       PIC 99.
               15  BILL-UNITS4              PIC 9(07).
               15  BILL-PAY-AMT4            PIC 9(06)V99.
      *
           10  BILL-SIA-ADD-ON-PYMTS.
               15  BILL-NA-ADD-ON-DAY1-PAY   PIC 9(06)V99.
               15  BILL-NA-ADD-ON-DAY2-PAY   PIC 9(06)V99.
               15  BILL-EOL-ADD-ON-DAY1-PAY  PIC 9(06)V99.
               15  BILL-EOL-ADD-ON-DAY2-PAY  PIC 9(06)V99.
               15  BILL-EOL-ADD-ON-DAY3-PAY  PIC 9(06)V99.
               15  BILL-EOL-ADD-ON-DAY4-PAY  PIC 9(06)V99.
               15  BILL-EOL-ADD-ON-DAY5-PAY  PIC 9(06)V99.
               15  BILL-EOL-ADD-ON-DAY6-PAY  PIC 9(06)V99.
               15  BILL-EOL-ADD-ON-DAY7-PAY  PIC 9(06)V99.
      *
           10  BILL-RETURNED-DATA.
               15  BILL-PAY-AMT-TOTAL       PIC 9(06)V99.
               15  BILL-RTC                 PIC XX.
      *
           10  BILL-RHC-DAYS-PAID.
               15  BILL-HIGH-RHC-DAYS        PIC 99.
               15  BILL-LOW-RHC-DAYS         PIC 99.
           10  FILLER                        PIC X(08).
      *
      
      
      ***************************************************************
      
      ***************************************************************
      *----------------------------------------------------------****
      ******************************************************************
      *
      *    FILE MUST BE PROV-NO EFF-DATE SEQUENCE
      *
      ******************************************************************
      
       01  PROV-TABLE.
           02  PROV-ENTRIES               OCCURS 2400
                                          ASCENDING KEY IS PROV-NO
                                          INDEXED BY PX1 PX2 PX3.
               10  PROV-DATA1.
                   15  PROV-NPI10.
                       20  PROV-NPI8     PIC X(08).
                       20  PROV-NPI-FIL  PIC X(02).
                   15  PROV-NO           PIC X(06).
                   15  PROV-EFF-DATE     PIC X(08).
                   15  FILLER            PIC X(56).
      
       01  PROV-DATA-2.
           02  PROV-ENTRIES2              OCCURS 2400
                                          INDEXED BY PD2.
               10  PROV-DATA2            PIC X(80).
      
       01  PROV-DATA-3.
           02  PROV-ENTRIES3              OCCURS 2400
                                          INDEXED BY PD3.
               10  PROV-DATA3            PIC X(80).
      
      ***************************************************************
      ***************************************************************
       01  MSA-WI-TABLE.
           05  M-MSA-DATA              OCCURS 4000
                                       INDEXED BY MU1 MU2 MU3.
               10  MSA-MSA-LUGAR.
                   15  MSA-MSA       PIC 9(04).
                   15  MSA-LUGAR     PIC X.
               10  MSA-EFFDTE        PIC X(08).
               10  MSA-WAGE-IND      PIC S9(02)V9(04).
      
      ***************************************************************
      ***************************************************************
       01  CBSA-WI-TABLE.
           05  M-CBSA-DATA             OCCURS 9000
                                       INDEXED BY CU1 CU2 CU3.
               10  M-CBSA              PIC 9(05).
               10  M-CBSA-EFFDTE       PIC X(08).
               10  M-CBSA-WAGE-IND     PIC S9(02)V9(04).
      
      ***************************************************************
      **-----------------------------------------------------------**
      
      **-----------------------------------------------------------**
      **-----------------------------------------------------------**
      **-----------------------------------------------------------**
      
       PROCEDURE DIVISION USING  BILL-315-DATA
                                 PROV-TABLE
                                 PROV-DATA-2
                                 PROV-DATA-3
                                 MSA-WI-TABLE
                                 CBSA-WI-TABLE.
      **-----------------------------------------------------------**
      **-----------------------------------------------------------**
      
           PERFORM 0200-PROCESS-RECORDS
              THRU 0200-EXIT.
      
           GOBACK.
      
      
       0200-PROCESS-RECORDS.
      **
      *----------------------------------------------------------*
      * INITIALIZE VARIABLES                                     *
      *----------------------------------------------------------*
           MOVE ALL '0' TO BILL-RETURNED-DATA
                           BILL-PAY-AMT1
                           BILL-PAY-AMT2
                           BILL-PAY-AMT3
                           BILL-PAY-AMT4
                           BILL-SIA-ADD-ON-PYMTS.
      
           INITIALIZE W-FY-BEGIN-CC
                      W-FY-BEGIN-YY
                      W-FY-END-CC
                      W-FY-END-YY.
      
      *----------------------------------------------------------*
      * SET FY BEGIN AND END DATES USING BILL DISCHARGE DATE     *
      *----------------------------------------------------------*
           MOVE BILL-FROM-CC TO W-FY-BEGIN-CC.
           MOVE BILL-FROM-CC TO W-FY-END-CC.
      
      *----------------------------------*
      * FOR CLAIMS DISCHARGED JAN - SEPT *
      *----------------------------------*
           IF BILL-FROM-MM >= 01 AND
              BILL-FROM-MM <= 09
              COMPUTE W-FY-BEGIN-YY = BILL-FROM-YY - 1
              MOVE BILL-FROM-YY TO W-FY-END-YY
      
      *----------------------------------*
      * FOR CLAIMS DISCHARGED OCT - DEC  *
      *----------------------------------*
           ELSE
              MOVE BILL-FROM-YY TO W-FY-BEGIN-YY
              COMPUTE W-FY-END-YY = BILL-FROM-YY + 1
           END-IF.
      
           IF EOF-BILL-SW = 0
                 ADD 1               TO BILL-CTR
                 PERFORM 0300-PROCESS-DATA
                    THRU 0300-EXIT.
      
       0200-EXIT.  EXIT.
      
       0300-PROCESS-DATA.
      ****-------------------------------------------****
      ****    GET PROV RECORD FOR HOSPICE MSA OR CBSA
      ****-------------------------------------------****
      
           PERFORM 0700-GET-PROVIDER
              THRU 0700-EXIT.
      
           IF BILL-RTC NOT = 00
              GO TO 0300-EXIT.
      
           IF P-NEW-EFF-DATE < 20051001 AND
              BILL-FROM-DATE > 20050930
              MOVE 51                TO BILL-RTC
      
      
              GO TO 0300-EXIT.
      
      
           IF BILL-FROM-DATE > 20050930
              PERFORM 0375-GET-CBSA
                 THRU 0375-EXIT
           ELSE
              PERFORM 0350-GET-MSA
                 THRU 0350-EXIT.
      
       0300-EXIT.   EXIT.
      
       0350-GET-MSA.
      
      ****-------------------------------------------****
      ****    GET PROV-HOSP WAGE INDEX
      ****-------------------------------------------****
      
           IF P-NEW-GEO-RURAL1
              MOVE '99'              TO SEARCH-MSA-POS12
              MOVE P-NEW-GEO-RURAL2  TO SEARCH-MSA-POS34
           ELSE
              MOVE P-NEW-GEO-LOC-MSA9
                                     TO SEARCH-MSA.
      
           IF BILL-FROM-DATE < 19991001
              MOVE P-NEW-LUGAR       TO SEARCH-LUGAR
           ELSE
              MOVE SPACE             TO SEARCH-LUGAR.
      
           MOVE P-NEW-GEO-LOC-MSAX   TO BILL-PROV-MSA.
      
           IF BILL-FROM-DATE < 19991001
              MOVE P-NEW-LUGAR       TO BILL-PROV-LUGAR
           ELSE
              MOVE SPACE             TO BILL-PROV-LUGAR.
      
              IF BILL-FROM-DATE < 19991001
                 MOVE P-NEW-LUGAR       TO SEARCH-LUGAR
              ELSE
                 MOVE SPACE             TO SEARCH-LUGAR.
      
              MOVE P-NEW-GEO-LOC-MSAX   TO BILL-PROV-MSA.
      
              IF BILL-FROM-DATE < 19991001
                 MOVE P-NEW-LUGAR       TO BILL-PROV-LUGAR
              ELSE
                 MOVE SPACE             TO BILL-PROV-LUGAR.
      
           PERFORM 0400-SEARCH-4-MSA
              THRU 0400-SEARCH-EXIT.
      
           IF BILL-RTC = 00
              PERFORM 0500-GET-HOSP-WAGE-INDEX
                      THRU 0500-EXIT  VARYING MU2
                      FROM MU1 BY 1 UNTIL
                      MSA-MSA-LUGAR (MU2) NOT = SEARCH-MSA-LUGAR
           ELSE
              MOVE 0                 TO BILL-PROV-WAGE-INDEX
                                        BILL-BENE-WAGE-INDEX
              GO TO 0350-EXIT.
      
           IF (BILL-PROV-WAGE-INDEX  NOT NUMERIC) OR
              (BILL-PROV-WAGE-INDEX  = ZERO)
              MOVE '40'              TO BILL-RTC
              GO TO 0350-EXIT.
      
      
      ****-------------------------------------------****
      ****    GET BENE WAGE INDEX
      ****-------------------------------------------****
      
           MOVE BILL-BENE-MSA        TO SEARCH-MSA.
      
           IF BILL-FROM-DATE  < 19991001
              MOVE BILL-BENE-LUGAR   TO SEARCH-LUGAR
           ELSE
              MOVE SPACE             TO SEARCH-LUGAR.
      
           PERFORM 0400-SEARCH-4-MSA
              THRU 0400-SEARCH-EXIT.
      
           IF BILL-RTC = 00
              PERFORM 0550-GET-BENE-WAGE-INDEX
                      THRU 0550-EXIT  VARYING MU2
                      FROM MU1 BY 1 UNTIL
                      MSA-MSA-LUGAR (MU2) NOT = SEARCH-MSA-LUGAR
           ELSE
              MOVE 0                   TO BILL-PROV-WAGE-INDEX
                                          BILL-BENE-WAGE-INDEX
              GO TO 0350-EXIT.
      
           IF (BILL-BENE-WAGE-INDEX NOT NUMERIC) OR
              (BILL-BENE-WAGE-INDEX = ZERO)
              MOVE '50'                TO BILL-RTC
              GO TO 0350-EXIT.
      
           PERFORM 1000-CALL
              THRU 1000-EXIT.
      
       0350-EXIT.  EXIT.
      
       0375-GET-CBSA.
      
      ****------------------------------------------------****
      ****    GET PROV-HOSP WAGE INDEX
      ****    AS OF 01/01/2008 PROV CBSA ONLY COMES FROM CLAIM
      ****------------------------------------------------****
      
           IF BILL-FROM-DATE < 20080101
             IF W-P-NEW-CBSA-GEO-RURAL1
                MOVE '999'           TO SEARCH-CBSA-POS123
                MOVE W-P-NEW-CBSA-GEO-RURAL2ND
                                     TO SEARCH-CBSA-POS45
             ELSE
                MOVE W-P-NEW-CBSA-GEO-LOC
                                     TO SEARCH-CBSA
                MOVE W-P-NEW-CBSA-GEO-LOC
                                     TO BILL-PROV-CBSA
           ELSE
                MOVE BILL-PROV-CBSA  TO SEARCH-CBSA.
      
      
      ****------------------------------------------------****
      ****    CBSA BETWEEN 50000 AND 59999 NOT VALID FOR 2007
      ****------------------------------------------------****
      
      *    IF BILL-FROM-DATE > 20060930 AND
      *       BILL-PROV-CBSA > 49999 AND
      *       BILL-PROV-CBSA < 99900
      *       MOVE '30'              TO BILL-RTC
      *       GO TO 0375-EXIT.
      
      
           PERFORM 0450-SEARCH-4-CBSA
              THRU 0450-SEARCH-EXIT.
      
           IF BILL-RTC = 00
              PERFORM 0525-GET-HOSP-WAGE-INDEX
                      THRU 0525-EXIT  VARYING CU2
                      FROM CU1 BY 1 UNTIL
                      M-CBSA (CU2) NOT = SEARCH-CBSA
           ELSE
              MOVE 0                 TO BILL-PROV-WAGE-INDEX
                                        BILL-BENE-WAGE-INDEX
              GO TO 0375-EXIT.
      
           IF (BILL-PROV-WAGE-INDEX NOT NUMERIC) OR
              (BILL-PROV-WAGE-INDEX = ZERO)
              MOVE '40'          TO BILL-RTC
              GO TO 0375-EXIT.
      
      
      ****------------------------------------------------****
      ****    GET BENE WAGE INDEX
      ****------------------------------------------------****
      
           MOVE BILL-BENE-CBSA   TO SEARCH-CBSA.
      
           PERFORM 0450-SEARCH-4-CBSA
              THRU 0450-SEARCH-EXIT.
      
           IF BILL-RTC = 00
              PERFORM 0575-GET-BENE-WAGE-INDEX
                 THRU 0575-EXIT
                     VARYING CU2
                        FROM CU1 BY 1 UNTIL
                             M-CBSA (CU2) NOT = SEARCH-CBSA
           ELSE
              MOVE 0             TO BILL-PROV-WAGE-INDEX
                                    BILL-BENE-WAGE-INDEX
              GO TO 0375-EXIT.
      
           IF (BILL-BENE-WAGE-INDEX NOT NUMERIC) OR
              (BILL-BENE-WAGE-INDEX = ZERO)
              MOVE '50'          TO BILL-RTC
              GO TO 0375-EXIT.
      
           PERFORM 1000-CALL
              THRU 1000-EXIT.
      
       0375-EXIT.  EXIT.
      
       0400-SEARCH-4-MSA.
      ****------------------------------------------------****
      ****   SEARCH FOR MSA
      ****------------------------------------------------****
           SET MU1               TO 1.
           SEARCH M-MSA-DATA VARYING MU1
                  AT END
                      MOVE 30    TO BILL-RTC
      
      
           WHEN MSA-MSA-LUGAR (MU1) = SEARCH-MSA-LUGAR
                SET MU2          TO MU1.
      
       0400-SEARCH-EXIT.  EXIT.
      
       0450-SEARCH-4-CBSA.
      ****------------------------------------------------****
      ****   SEARCH FOR CBSA
      ****------------------------------------------------****
      
           SET CU1               TO 1.
      
      
           SEARCH M-CBSA-DATA VARYING CU1
                  AT END
                      MOVE 30    TO BILL-RTC
      
      
           WHEN M-CBSA (CU1) = SEARCH-CBSA
                SET CU2          TO CU1.
      
       0450-SEARCH-EXIT.  EXIT.
      
       0500-GET-HOSP-WAGE-INDEX.
      
      ****------------------------------------------------****
      ****   LOOKUP FOR MSA
      ****------------------------------------------------****
           IF BILL-FROM-DATE NOT < MSA-EFFDTE (MU2)
              MOVE MSA-WAGE-IND (MU2)
                                 TO BILL-PROV-WAGE-INDEX.
      
       0500-EXIT.   EXIT.
      
       0525-GET-HOSP-WAGE-INDEX.
      
      ****------------------------------------------------****
      ****   LOOKUP FOR CBSA
      ****   MUST BE EFFECTIVE WITHIN THE CLAIM'S FY
      ****------------------------------------------------****
           IF BILL-FROM-DATE NOT < M-CBSA-EFFDTE (CU2) AND
      
              (M-CBSA-EFFDTE (CU2)  >= W-FY-BEGIN-DATE AND
               M-CBSA-EFFDTE (CU2)  <= W-FY-END-DATE)
      
              MOVE M-CBSA-WAGE-IND (CU2)
                                 TO BILL-PROV-WAGE-INDEX.
      
       0525-EXIT.   EXIT.
      
       0550-GET-BENE-WAGE-INDEX.
      
      ****------------------------------------------------****
      ****   LOOKUP FOR MSA
      ****------------------------------------------------****
           IF BILL-FROM-DATE NOT < MSA-EFFDTE (MU2)
              MOVE MSA-WAGE-IND (MU2)
                                 TO BILL-BENE-WAGE-INDEX.
      
       0550-EXIT.   EXIT.
      
       0575-GET-BENE-WAGE-INDEX.
      
      ****------------------------------------------------****
      ****   LOOKUP FOR CBSA
      ****   MUST BE EFFECTIVE WITHIN THE CLAIM'S FY
      ****------------------------------------------------****
           IF BILL-FROM-DATE NOT < M-CBSA-EFFDTE (CU2) AND
      
              (M-CBSA-EFFDTE(CU2)  >= W-FY-BEGIN-DATE AND
               M-CBSA-EFFDTE(CU2)  <= W-FY-END-DATE)
      
              MOVE M-CBSA-WAGE-IND (CU2)
                                 TO BILL-BENE-WAGE-INDEX.
      
       0575-EXIT.   EXIT.
      
       0700-GET-PROVIDER.
      ****------------------------------------------------****
      *    ON A PROVIDER BREAK:                              *
      *    FIND THE PROVIDER MSA AND LUGAR ELEMENTS          *
      *    FILE MUST BE PROV-NO EFF-DATE SEQUENCE            *
      ****------------------------------------------------****
      
           IF  BILL-PROV-NO NOT = P-NEW-PROVIDER-NO
               SET PX2               TO 1
               SEARCH PROV-ENTRIES VARYING PX2
                   AT END
                       MOVE 51       TO BILL-RTC
                       GO TO 0700-EXIT
                   WHEN BILL-PROV-NO = PROV-NO (PX2)
                       MOVE 00       TO BILL-RTC.
      
           MOVE PROV-DATA1 (PX2)     TO PROV-NEWREC-HOLD1.
           SET PD2                   TO PX2.
           SET PD3                   TO PX2.
           MOVE PROV-DATA2 (PD2)     TO PROV-NEWREC-HOLD2.
           MOVE PROV-DATA3 (PD3)     TO PROV-NEWREC-HOLD3.
      
           PERFORM 0800-GET-CURR-PROV
              THRU 0800-EXIT
                   VARYING PX3
                   FROM PX2 BY 1 UNTIL PROV-NO (PX3) NOT =
                        BILL-PROV-NO OR PROV-NO (PX3) = '999999'.
      
       0700-EXIT.  EXIT.
      
       0800-GET-CURR-PROV.
      
           IF BILL-FROM-DATE NOT < PROV-EFF-DATE (PX3)
               MOVE PROV-DATA1 (PX3) TO PROV-NEWREC-HOLD1
               SET PD2               TO PX3
               SET PD3               TO PX3
               MOVE PROV-DATA2 (PD2) TO PROV-NEWREC-HOLD2
               MOVE PROV-DATA3 (PD3) TO PROV-NEWREC-HOLD3.
      
      
       0800-EXIT.  EXIT.
      
      
       1000-CALL.
      *
      *
           CALL HOSPR210            USING BILL-315-DATA.
      
      
       1000-EXIT.   EXIT.
      
      ***************************************************************
      ******        L A S T   S O U R C E   S T A T E M E N T   *****
      ***************************************************************

