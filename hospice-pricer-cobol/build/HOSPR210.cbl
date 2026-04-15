       IDENTIFICATION DIVISION.
       PROGRAM-ID.           HOSPR210.
      *AUTHOR.  DDS TEAM.
      *         (CENTERS FOR MEDICARE AND MEDICAID SERVICES)
      *REMARKS. A). HOSPICE PRICER
      *************************************************************
      *REMARKS.
      *
      *
      ********    PROD VERSION FOR FY2021 ----------***********
      *
      *     HOSPR210   REVISIONS FOR OCT 1, 2021
      *                PAYMENT RATES FOR FY2021
      *     HOSDR210   NEW PROCEESS OCT 1, 2021
      *                CBSA WAGE INDEX DATA FOR FY2021
      *     HOSOP210   NEW PROCEESS OCT 1, 2020
      *                VERSION TO OPEN FILES CALL HOSDR210
      *
      ****-----  PROD VERSION FOR FY2021  --------------------***
      *
      ******** PROD VERSION FOR FY2020 -              ***********
      *
      *     HOSPR200   REVISIONS FOR OCT 1, 2019
      *                PAYMENT RATES FOR FY2020
      *     HOSDR200   NEW PROCEESS OCT 1, 2019
      *                CBSA WAGE INDEX DATA FOR FY2020
      *     HOSOP200   NEW PROCEESS OCT 1, 2019
      *                VERSION TO OPEN FILES CALL HOSDR200
      *
      ****----- PROD VERSION FOR FY2019 ------------***
      *
      *     HOSPR190   REVISIONS FOR OCT 1, 2019
      *                PAYMENT RATES FOR FY2020
      *     HOSDR190   NEW PROCEESS OCT 1, 2018
      *                CBSA WAGE INDEX DATA FOR FY2019
      *     HOSOP190   NEW PROCEESS OCT 1, 2018
      *                VERSION TO OPEN FILES CALL HOSDR190
      *
      ****---- BETA VERSION FOR FY2019 - TESTING ONLY ------*****
      *
      *
      *     HOSPR19B   REVISIONS FOR OCT 1, 2018
      *                USED PAYMENT RATES FOR FY2018
      *     HOSDR19B   NEW PROCEESS OCT 1, 2018
      *                CBSA FILE BASED ON FY2018 FILE
      *     HOSOP19B   NEW PROCEESS OCT 1, 2018
      *                VERSION TO OPEN FILES CALL HOSDR19B
      *
      ******** BETA VERSION FOR FY2019 - TESTING ONLY ***********
      *
      *
      *     HOSPR180   REVISIONS FOR OCT 1, 2017
      *                REVISED PAYMENT RATES FOR FY2018
      *                MADE COPYBOOK (HOSPRATE) FOR PAYMENT RATES
      *     HOSDR180   NEW PROCEESS OCT 1, 2017
      *                CBSA FILE PROCESSING DRIVER CALL HOSPR180
      *     HOSOP180   NEW PROCEESS OCT 1, 2017
      *                VERSION TO OPEN FILES CALL HOSDR180
      *
      *
      *     HOSPR170   REVISIONS FOR OCT 1, 2016
      *                REVISED PAYMENT RATES FOR FY2016
      *                MADE COPYBOOK (HOSPRATE) FOR PAYMENT RATES
      *     HOSDR170   NEW PROCEESS OCT 1, 2016
      *                CBSA FILE PROCESSING DRIVER CALL HOSPR170
      *     HOSOP170   NEW PROCEESS OCT 1, 2016
      *                VERSION TO OPEN FILES CALL HOSDR170
      *
      *     HOSPR162   UPDATES TO REVISIONS FOR JAN 1, 2016
      *                CORRECTED A CALCULATION FOR EOL6
      *                SERVICE INTENSITY ADD-ON PAYMENTS
      *                MODIFIED  '> 0 ' NOTATIONS TO USE '> ZEROES '
      *     HOSDR162   UPDATES TO REVISIONS FOR JAN 1, 2016
      *                CBSA FILE PROCESSING DRIVER CALL HOSPR162
      *     HOSOP162   UPDATES TO REVISIONS FOR JAN 1, 2016
      *                CICS VERSION TO OPEN FILES CALL HOSDR162
      *
      *     HOSPR161   REVISIONS FOR JAN 1, 2016
      *                REVISED PAYMENT RATES FOR FY2016 PER CR #9289
      *                NEW DATA FIELDS FOR SIA CR # 9289
      *                RHC LOW RATE/HIGH RATE PAYMENT FOR RHC PAYMENT
      *                  CALCULATION AND CHC RATE DETERMINATION
      *                SERVICE INTENSITY ADD-ON PAYMENTS
      *                NEW RETURN CODES FOR RHC - 73, 74, 75, & 77
      *                UPDATED COPYBOOK (HOSPRATE) FOR PAYMENT RATES
      *        ==>>>>  REVISED BILL & RATE RECORD LENGTH FROM 215 TO 315
      *     HOSDR161   NEW PROCEESS JAN 1, 2016
      *                CBSA FILE PROCESSING DRIVER CALL HOSPR161
      *                NEW DATA FIELDS FOR SIA CR # 9289
      *        ==>>>>  REVISED BILL & RATE RECORD LENGTH FROM 215 TO 315
      *     HOSOP161   NEW PROCEESS JAN 1, 2016
      *                CICS VERSION TO OPEN FILES CALL HOSDR161
      *
      *     HOSPR160   REVISIONS FOR OCT 1, 2015
      *                REVISED PAYMENT RATES FOR FY2016
      *                MADE COPYBOOK (HOSPRATE) FOR PAYMENT RATES
      *     HOSDR160   NEW PROCEESS OCT 1, 2015
      *                CBSA FILE PROCESSING DRIVER CALL HOSPR160
      *     HOSOP160   NEW PROCEESS OCT 1, 2015
      *                CICS VERSION TO OPEN FILES CALL HOSDR160
      *
      *     HOSPR150   REVISIONS FOR OCT 1, 2014
      *                REVISED PAYMENT RATES FOR FY2015
      *     HOSDR150   NEW PROCEESS OCT 1, 2014
      *                CBSA FILE PROCESSING DRIVER CALL HOSPR150
      *     HOSOP150   NEW PROCEESS OCT 1, 2014
      *                CICS VERSION TO OPEN FILES CALL HOSDR150
      *
      *     HOSPR140   REVISIONS FOR OCT 1, 2013
      *        ==>>>>  REVISED BILL & RATE RECORD LENGTH FROM 135 TO 215
      *        ==>>>>  NEW LOGIC FOR QIP INDICATOR
      *     HOSDR140   NEW PROCEESS OCT 1, 2013
      *                CBSA FILE PROCESSING DRIVER CALL HOSPR140
      *     HOSOP140   NEW PROCEESS OCT 1, 2013
      *                CICS VERSION TO OPEN FILES CALL HOSDR140
      *
      *     HOSPR130   REVISIONS FOR OCT 1, 2012
      *                REVISED GO TO EXIT LOGIC FOR 2007, 7-1, 8 AND 9
      *                        FOR 2007, 7-1, 8 AND 9
      *     HOSDR130   NEW PROCEESS OCT 1, 2012
      *                CBSA FILE PROCESSING DRIVER CALL HOSPR130
      *     HOSOP130   NEW PROCEESS OCT 1, 2012
      *                CICS VERSION TO OPEN FILES CALL HOSDR130
      *
      *     HOSPR120   REVISIONS FOR OCT 1, 2011
      *                REVISED GO TO EXIT LOGIC FOR 2007, 7-1, 8 AND 9
      *                        FOR 2007, 7-1, 8 AND 9
      *     HOSDR120   NEW PROCEESS OCT 1, 2011
      *                CBSA FILE PROCESSING DRIVER CALL HOSPR120
      *     HOSOP120   NEW PROCEESS OCT 1, 2011
      *                CICS VERSION TO OPEN FILES CALL HOSDR120
      *
      *     HOSPR110   REVISIONS FOR OCT 1, 2010
      *                REVISED GO TO EXIT LOGIC FOR 2007, 7-1, 8 AND 9
      *     HOSDR110   NEW PROCEESS OCT 1, 2010
      *                CBSA FILE PROCESSING DRIVER CALL HOSPR110
      *     HOSOP110   NEW PROCEESS OCT 1, 2010
      *                CICS VERSION TO OPEN FILES CALL HOSDR110
      *
      *     HOSPR100   REVISIONS FOR OCT 1, 2009
      *                REVISED GO TO EXIT LOGIC FOR 2007, 7-1, 8 AND 9
      *     HOSDR100   NEW PROCEESS OCT 1, 2009
      *                CBSA FILE PROCESSING DRIVER CALL HOSPR100
      *     HOSOP100   NEW PROCEESS OCT 1, 2009
      *                CICS VERSION TO OPEN FILES CALL HOSDR100
      *
      *     HOSPR091   REVISIONS FOR OCT 1, 2008
      *                REVISED GO TO EXIT LOGIC FOR 2007, 7-1, 8 AND 9
      *                STIMULUS PKG RECOMPILE
      *     HOSDR091   NEW PROCEESS OCT 1, 2008
      *                CBSA FILE PROCESSING DRIVER CALL HOSPR091
      *     HOSOP091   NEW PROCEESS OCT 1, 2008
      *                CICS VERSION TO OPEN FILES CALL HOSDR091
      *
      *     HOSPR090   REVISIONS FOR OCT 1, 2008
      *                REVISED PAYMENT RATES FOR FY2009
      *     HOSDR090   NEW PROCEESS OCT 1, 2008
      *                CBSA FILE PROCESSING DRIVER CALL HOSPR090
      *     HOSOP090   NEW PROCEESS OCT 1, 2008
      *                CICS VERSION TO OPEN FILES CALL HOSDR090
      *
      *     HOSPR081   REVISIONS FOR OCT 1, 2007
      *                REVISED PAYMENT RATES FOR FY2008
      *     HOSDR081   NEW PROCEESS OCT 1, 2007
      *                CBSA FILE PROCESSING DRIVER CALL HOSPR081
      *     HOSOP081   NEW PROCEESS OCT 1, 2007
      *                CICS VERSION TO OPEN FILES CALL HOSDR081
      *
      *     HOSPR071   REVISIONS FOR JAN 1, 2007
      *                2007-CHANGE TO UNITS = 15 MINUTES CODE 652.
      *     HOSDR071   NEW PROCEESS JAN 1, 2007
      *                CBSA FILE PROCESSING DRIVER CALL HOSPR071
      *     HOSOP071   NEW PROCEESS JAN 1, 2007
      *                CICS VERSION TO OPEN FILES CALL HOSDR071
      *
      *     HOSPR070   REVISIONS FOR OCT 1, 2006
      *                2007-PROCESS-DATA
      *                2007 CALCULATE HOME RATE BY REVENUE CODE FACTORS
      *     HOSDR070   NEW PROCEESS OCT 1, 2006
      *                CBSA FILE PROCESSING DRIVER
      *     HOSOP070   NEW PROCEESS OCT 1, 2006
      *                CICS VERSION TO OPEN FILES
      *
      ***************************************************************
      ******************************************************************
      ***     WILL PROCESS CLAIMS  FOR 1998 THRU 2020
      ***                ALL RATES FOR 1998 THRU 2020
      ******************************************************************
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
           'HOSPR210     - W O R K I N G   S T O R A G E'.
       01  HOS-VERSION                    PIC X(09)  VALUE 'HOSPR210'.
       01  WRK-PAY-RATE1                  PIC 9(06)V9(02) VALUE 0.
       01  WRK-PAY-RATE2                  PIC 9(06)V9(02) VALUE 0.
       01  WRK-PAY-RATE3                  PIC 9(06)V9(02) VALUE 0.
       01  WRK-PAY-RATE4                  PIC 9(06)V9(02) VALUE 0.
      
      
      
      *-------------------------------------------------------------*
      *     HOSPRATE COPYBOOK CONTAINS THE PAYMENT RATES            *
      *   IN VARIABLE FORMAT TO COMPLETE THE HOSPICE PRICING        *
      *     << ONLY AVAILABLE FROM FY2016 FORWARD >>                *
      *          (PRIOR YEAR RATES ARE HARD CODED)                  *
      *-------------------------------------------------------------*
      *
       COPY "HOSPRATE.cpy".
      
      
      *-------------------------------------------------------------*
      * VARIABLES TO STORE RHC LOGIC FLAGS & INDICATORS CR #9289    *
      *           NEEDED TO NAVIGATE PAYMENT & RTC LOGIC            *
      *-------------------------------------------------------------*
       01  RHC-LOGIC-FLAGS.
           05  RHC-HIGH-DAY-IND           PIC X.
           05  RHC-LOW-DAY-IND            PIC X.
           05  SIA-UNITS-IND              PIC X.
      
      
      *-------------------------------------------------------------*
      * VARIABLES TO STORE RHC LOGIC VALUES -  CR #9289             *
      *           NEEDED TO DETERMINE PAYMENT                       *
      *-------------------------------------------------------------*
       01  RHC-LOGIC-VALUES.
           05  PRIOR-BENEFIT-DAYS         PIC 9(4).
           05  PRIOR-SVC-DAYS             PIC 9(4).
           05  HR-BILL-UNITS1             PIC 9(4).
           05  LR-BILL-UNITS1             PIC 9(4).
           05  EOL-HOURS1                 PIC 999V99.
           05  EOL-HOURS2                 PIC 999V99.
           05  EOL-HOURS3                 PIC 999V99.
           05  EOL-HOURS4                 PIC 999V99.
           05  EOL-HOURS5                 PIC 999V99.
           05  EOL-HOURS6                 PIC 999V99.
           05  EOL-HOURS7                 PIC 999V99.
           05  EOL-UNITS1                 PIC 99.
           05  EOL-UNITS2                 PIC 99.
019B00     05  EOL-UNITS3                 PIC 99.
           05  EOL-UNITS4                 PIC 99.
           05  EOL-UNITS5                 PIC 99.
           05  EOL-UNITS6                 PIC 99.
           05  EOL-UNITS7                 PIC 99.
           05  SIA-PYMT-RATE              PIC 999V99.
           05  SIA-PAY-AMT-TOTAL          PIC 9(06)V99.
           05  HR-BILL-PAY-AMT1           PIC 9(06)V99.
           05  LR-BILL-PAY-AMT1           PIC 9(06)V99.
      
      
      *-------------------------------------------------------------*
      *              DATE CALCULATION VARIABLES                     *
      *        USED TO DETERMINE WHICH RHC RATE APPLIES             *
      *  # PRIOR DAYS = ((DOS - ADM DATE) + NA-ADD-ON-DAY1-UNITS    *
      *-------------------------------------------------------------*
      
       01 DATE-CALCULATION-FIELDS.
          05 DATE-1-ADM               PIC 9(8).
          05 DATE-2-DOS               PIC 9(8).
          05 DATE-1-ADM-INTEGER       PIC 9(8).
          05 DATE-2-DOS-INTEGER       PIC 9(8).
          05 DAYS-BETWEEN-DATES       PIC S9(8) SIGN LEADING SEPARATE.
          05 HIGH-RATE-DAYS-LEFT      PIC S9(8) SIGN LEADING SEPARATE.
      
      
      
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
      **>>>>>>>>>>>BILL-RTC      NO RATE RETURNED                   *
      *              10 = BAD UNITS                                 *
      *                                                             *
      *              20 = BAD UNITS2 < 8                            *
      *                                                             *
      *              30 = BAD MSA CODE                              *
      *                                                             *
      *              40 = BAD HOSPICE WAGE INDEX FROM MSAFILE       *
      *                                                             *
      *              50 = BAD BENE    WAGE INDEX FROM MSAFILE       *
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
               15  BILL-PAY-AMT-TOTAL        PIC 9(06)V99.
               15  BILL-RTC                  PIC XX.
      *
           10  BILL-RHC-DAYS-PAID.
               15  BILL-HIGH-RHC-DAYS        PIC 99.
               15  BILL-LOW-RHC-DAYS         PIC 99.
      *
           10  FILLER                        PIC X(08).
      *
      
      ***************************************************************
      ***************************************************************
      ***************************************************************
      
      
      ***************************************************************
      *----------------------------------------------------------****
       PROCEDURE DIVISION USING BILL-315-DATA.
      
      
      ***************************************************************
      
      *----------------------------------------------------------****
      * INITIALIZE VARIABLES FOR THE NEW CLAIM
      *----------------------------------------------------------****
      
           PERFORM 1000-INITIALIZE
              THRU 1000-INITIALIZE-EXIT.
      
      *----------------------------------------------------------****
      *  FY 2021 PROCESS - OCT 2020 RELEASE 20.0
      *----------------------------------------------------------****
      
           IF BILL-FROM-DATE > 20200930
              PERFORM 2021-V210-PROCESS-DATA
                 THRU 2021-V210-PROCESS-EXIT
              GOBACK.
      
      
      
      *----------------------------------------------------------****
      *  FY 2020 PROCESS - OCT 2019 RELEASE 20.0
      *----------------------------------------------------------****
      
           IF BILL-FROM-DATE > 20190930
              PERFORM 2020-V200-PROCESS-DATA
                 THRU 2020-V200-PROCESS-EXIT
              GOBACK.
      
      
      *----------------------------------------------------------****
      *  FY 2019 PROCESS - OCT 2018 RELEASE 19.B
      *----------------------------------------------------------****
      
           IF BILL-FROM-DATE > 20180930
              PERFORM 2019-V190-PROCESS-DATA
                 THRU 2019-V190-PROCESS-EXIT
              GOBACK.
      
      
      *----------------------------------------------------------****
      *  FY 2018 PROCESS - OCT 2017 RELEASE 18.0
      *----------------------------------------------------------****
      
           IF BILL-FROM-DATE > 20170930
              PERFORM 2018-V180-PROCESS-DATA
                 THRU 2018-V180-PROCESS-EXIT
              GOBACK.
      
      
      *----------------------------------------------------------****
      *  FY 2017 PROCESS - OCT 2016 RELEASE 17.0
      *----------------------------------------------------------****
      
           IF BILL-FROM-DATE > 20160930
              PERFORM 2017-V170-PROCESS-DATA
                 THRU 2017-V170-PROCESS-EXIT
              GOBACK.
      
      
      *----------------------------------------------------------****
      *  FY 2016 PROCESS - JAN 2016 RELEASE 16.1
      *----------------------------------------------------------****
      
           IF BILL-FROM-DATE > 20151231
              PERFORM 2016-V161-PROCESS-DATA
                 THRU 2016-V161-PROCESS-EXIT
              GOBACK.
      
      
      *----------------------------------------------------------****
      *  FY 2016 PROCESS - OCT 2015 RELEASE 16.0
      *----------------------------------------------------------****
      
           IF BILL-FROM-DATE > 20150930
              PERFORM 2016-PROCESS-DATA
                 THRU 2016-EXIT
              GOBACK.
      
      
      *----------------------------------------------------------****
      *  FY 2015 PROCESS
      *----------------------------------------------------------****
      
           IF BILL-FROM-DATE > 20140930
              PERFORM 2015-PROCESS-DATA
                 THRU 2015-EXIT
              GOBACK.
      
      
      *----------------------------------------------------------****
      *  FY 2014 PROCESS
      *----------------------------------------------------------****
      
           IF BILL-FROM-DATE > 20130930
              PERFORM 2014-PROCESS-DATA
                 THRU 2014-EXIT
              GOBACK.
      
      *----------------------------------------------------------****
      *  FY 2013 PROCESS
      *----------------------------------------------------------****
      
           IF BILL-FROM-DATE > 20120930
              PERFORM 2013-PROCESS-DATA
                 THRU 2013-EXIT
              GOBACK.
      
      *----------------------------------------------------------****
      *  FY 2012 PROCESS
      *----------------------------------------------------------****
      
           IF BILL-FROM-DATE  > 20110930
              PERFORM 2012-PROCESS-DATA
                 THRU 2012-EXIT
              GOBACK.
      
      *----------------------------------------------------------****
      *  FY 2011 PROCESS
      *----------------------------------------------------------****
      
           IF BILL-FROM-DATE  > 20100930
              PERFORM 2011-PROCESS-DATA
                 THRU 2011-EXIT
              GOBACK.
      
      *----------------------------------------------------------****
      *  FY 2010 PROCESS
      *----------------------------------------------------------****
      
           IF BILL-FROM-DATE  > 20090930
              PERFORM 2010-PROCESS-DATA
                 THRU 2010-EXIT
              GOBACK.
      
      *----------------------------------------------------------****
      *  FY 2009 PROCESS
      *----------------------------------------------------------****
      
           IF BILL-FROM-DATE  > 20080930
              PERFORM 2009-PROCESS-DATA
                 THRU 2009-EXIT
              GOBACK.
      
      *----------------------------------------------------------****
      *  FY 2008 PROCESS
      *----------------------------------------------------------****
      
           IF BILL-FROM-DATE  > 20070930
              PERFORM 2008-PROCESS-DATA
                 THRU 2008-EXIT
              GOBACK.
      
      *----------------------------------------------------------****
      *  FY 2007.1 PROCESS
      *----------------------------------------------------------****
      
           IF BILL-FROM-DATE  > 20061231
              PERFORM 2007-1-PROCESS-DATA
                 THRU 2007-1-EXIT
              GOBACK.
      
      *----------------------------------------------------------****
      *  FY 2007 PROCESS
      *----------------------------------------------------------****
      
           IF BILL-FROM-DATE  > 20060930
              PERFORM 2007-PROCESS-DATA
                 THRU 2007-EXIT
              GOBACK.
      
      *----------------------------------------------------------****
      *  FY 2006 PROCESS
      *----------------------------------------------------------****
      
           IF BILL-FROM-DATE  > 20050930
              PERFORM 2006-PROCESS-DATA
                 THRU 2006-EXIT
              GOBACK.
      
      *----------------------------------------------------------****
      *  FY 2005 PROCESS
      *----------------------------------------------------------****
      
           IF BILL-FROM-DATE  > 20040930
              PERFORM 2005-PROCESS-DATA
                 THRU 2005-EXIT
              GOBACK.
      
      *----------------------------------------------------------****
      *  FY 2004 PROCESS
      *----------------------------------------------------------****
      
           IF BILL-FROM-DATE  > 20030930
              PERFORM 2004-PROCESS-DATA
                 THRU 2004-EXIT
              GOBACK.
      
      *----------------------------------------------------------****
      *  FY 2003 PROCESS
      *----------------------------------------------------------****
      
           IF BILL-FROM-DATE  > 20020930
              PERFORM 2003-PROCESS-DATA
                 THRU 2003-EXIT
              GOBACK.
      
      *----------------------------------------------------------****
      *  FY 2002 PROCESS
      *----------------------------------------------------------****
      
           IF BILL-FROM-DATE  > 20010930
              PERFORM 2002-PROCESS-DATA
                 THRU 2002-EXIT
              GOBACK.
      
      *----------------------------------------------------------****
      *  FY 2001-A PROCESS
      *----------------------------------------------------------****
      
           IF BILL-FROM-DATE  > 20010331
              PERFORM 2001A-PROCESS-DATA
                 THRU 2001A-EXIT
              GOBACK.
      
      *----------------------------------------------------------****
      *  FY 2001 PROCESS
      *----------------------------------------------------------****
      
           IF BILL-FROM-DATE  > 20000930
              PERFORM 2001-PROCESS-DATA
                 THRU 2001-EXIT
              GOBACK.
      
      *----------------------------------------------------------****
      *  FY 2000 PROCESS
      *----------------------------------------------------------****
      
           IF BILL-FROM-DATE  > 19990930
              PERFORM 2000-PROCESS-DATA
                 THRU 2000-EXIT
              GOBACK.
      
      *----------------------------------------------------------****
      *  FY 1999 PROCESS
      *----------------------------------------------------------****
      
           IF BILL-FROM-DATE  > 19980930
              PERFORM 1999-PROCESS-DATA
                 THRU 1999-EXIT
              GOBACK.
      
      *----------------------------------------------------------****
      *  FY 1998 PROCESS
      *----------------------------------------------------------****
      
           PERFORM 1998-PROCESS-DATA
              THRU 1998-EXIT
      
           GOBACK.
      
      
      
      ****************************************************************
      ****          INITIALIZE VARIABLES FOR NEW CLAIM            ****
      ****************************************************************
       1000-INITIALIZE.
      
      *--------------------------------------------------------------
      *  SET OUTPUT VARIABLE VALUES TO ZEROS
      *--------------------------------------------------------------
           MOVE ALL '0' TO BILL-RETURNED-DATA
                           BILL-RHC-DAYS-PAID
                           BILL-PAY-AMT1
                           BILL-PAY-AMT2
                           BILL-PAY-AMT3
                           BILL-PAY-AMT4
                           BILL-SIA-ADD-ON-PYMTS.
      
      *--------------------------------------------------------------
      *  INTIALIZE WORKING-STORAGE VARIABLE VALUES
      *--------------------------------------------------------------
           INITIALIZE RHC-LOGIC-FLAGS
                      RHC-LOGIC-VALUES
                      DATE-CALCULATION-FIELDS.
      
      
       1000-INITIALIZE-EXIT.
           EXIT.
      
      
      *----------------------------------------------------------****
      *  FY 1998 PROCESS
      *----------------------------------------------------------****
      
       1998-PROCESS-DATA.
      
           IF BILL-UNITS1 > 1000 OR
              BILL-UNITS2 > 1000 OR
              BILL-UNITS3 > 1000 OR
              BILL-UNITS4 > 1000
              MOVE '10'              TO BILL-RTC
              GO TO 1998-EXIT.
      
           IF BILL-REV2 = '0652'
              IF BILL-UNITS2 < 8
                 MOVE '20'           TO BILL-RTC
                 GO TO 1998-EXIT.
      
      ****    CALCULATE HOME RATE BY REVENUE CODE
      ****    CALCULATE HOME RATE BY REVENUE CODE
      
           IF BILL-REV1 = '0651'
              COMPUTE WRK-PAY-RATE1 ROUNDED =
               ((65.80 * BILL-BENE-WAGE-INDEX) + 29.97) * BILL-UNITS1.
      
           IF BILL-REV2 = '0652'
              COMPUTE WRK-PAY-RATE2 ROUNDED =
               (((384.08 * BILL-BENE-WAGE-INDEX)
                                         + 174.91) / 24) * BILL-UNITS2.
      
           IF BILL-REV3 = '0655'
              COMPUTE WRK-PAY-RATE3 ROUNDED =
               ((53.63 * BILL-PROV-WAGE-INDEX) + 45.44) * BILL-UNITS3.
      
           IF BILL-REV4 = '0656'
              COMPUTE WRK-PAY-RATE4 ROUNDED =
               ((272.71 * BILL-PROV-WAGE-INDEX) + 153.34) * BILL-UNITS4.
      
           COMPUTE BILL-PAY-AMT-TOTAL =
                   WRK-PAY-RATE1 +
                   WRK-PAY-RATE2 +
                   WRK-PAY-RATE3 +
                   WRK-PAY-RATE4.
      
           MOVE WRK-PAY-RATE1        TO BILL-PAY-AMT1.
           MOVE WRK-PAY-RATE2        TO BILL-PAY-AMT2.
           MOVE WRK-PAY-RATE3        TO BILL-PAY-AMT3.
           MOVE WRK-PAY-RATE4        TO BILL-PAY-AMT4.
      
           MOVE ZEROES               TO WRK-PAY-RATE1
                                        WRK-PAY-RATE2
                                        WRK-PAY-RATE3
                                        WRK-PAY-RATE4.
      
       1998-EXIT.  EXIT.
      
      *----------------------------------------------------------****
      *  FY 1999 PROCESS
      *----------------------------------------------------------****
      
       1999-PROCESS-DATA.
           IF BILL-UNITS1 > 1000 OR
              BILL-UNITS2 > 1000 OR
              BILL-UNITS3 > 1000 OR
              BILL-UNITS4 > 1000
              MOVE '10'              TO BILL-RTC
              GO TO 1999-EXIT.
      
           IF BILL-REV2 = '0652'
              IF BILL-UNITS2 < 8
                 MOVE '20'           TO BILL-RTC
                 GO TO 1999-EXIT.
      
      ****    CALCULATE HOME RATE BY REVENUE CODE
      ****    CALCULATE HOME RATE BY REVENUE CODE
      
           IF BILL-REV1 = '0651'
              COMPUTE WRK-PAY-RATE1 ROUNDED =
               ((66.72 * BILL-BENE-WAGE-INDEX) + 30.39) * BILL-UNITS1.
      
           IF BILL-REV2 = '0652'
              COMPUTE WRK-PAY-RATE2 ROUNDED =
               (((389.46 * BILL-BENE-WAGE-INDEX)
                                         + 177.36) / 24) * BILL-UNITS2.
      
           IF BILL-REV3 = '0655'
              COMPUTE WRK-PAY-RATE3 ROUNDED =
               ((54.38 * BILL-PROV-WAGE-INDEX) + 46.08) * BILL-UNITS3.
      
           IF BILL-REV4 = '0656'
              COMPUTE WRK-PAY-RATE4 ROUNDED =
               ((276.53 * BILL-PROV-WAGE-INDEX) + 155.48) * BILL-UNITS4.
      
           COMPUTE BILL-PAY-AMT-TOTAL =
                   WRK-PAY-RATE1 +
                   WRK-PAY-RATE2 +
                   WRK-PAY-RATE3 +
                   WRK-PAY-RATE4.
      
           MOVE WRK-PAY-RATE1        TO BILL-PAY-AMT1.
           MOVE WRK-PAY-RATE2        TO BILL-PAY-AMT2.
           MOVE WRK-PAY-RATE3        TO BILL-PAY-AMT3.
           MOVE WRK-PAY-RATE4        TO BILL-PAY-AMT4.
      
      
           MOVE ZEROES               TO WRK-PAY-RATE1
                                        WRK-PAY-RATE2
                                        WRK-PAY-RATE3
                                        WRK-PAY-RATE4.
      
       1999-EXIT.  EXIT.
      
      *----------------------------------------------------------****
      *  FY 2000 PROCESS
      *----------------------------------------------------------****
      
       2000-PROCESS-DATA.
           IF BILL-UNITS1 > 1000 OR
              BILL-UNITS2 > 1000 OR
              BILL-UNITS3 > 1000 OR
              BILL-UNITS4 > 1000
              MOVE '10'              TO BILL-RTC
              GO TO 2000-EXIT.
      
           IF BILL-REV2 = '0652'
              IF BILL-UNITS2 < 8
                 MOVE '20'           TO BILL-RTC
                 GO TO 2000-EXIT.
      
      ****    CALCULATE HOME RATE BY REVENUE CODE
      ****    CALCULATE HOME RATE BY REVENUE CODE
      
           IF BILL-REV1 = '0651'
              COMPUTE WRK-PAY-RATE1 ROUNDED =
               ((68.00 * BILL-BENE-WAGE-INDEX) + 30.96) * BILL-UNITS1.
      
           IF BILL-REV2 = '0652'
              COMPUTE WRK-PAY-RATE2 ROUNDED =
               (((396.86 * BILL-BENE-WAGE-INDEX)
                                         + 180.73) / 24) * BILL-UNITS2.
      
           IF BILL-REV3 = '0655'
              COMPUTE WRK-PAY-RATE3 ROUNDED =
               ((55.41 * BILL-PROV-WAGE-INDEX) + 46.96) * BILL-UNITS3.
      
           IF BILL-REV4 = '0656'
              COMPUTE WRK-PAY-RATE4 ROUNDED =
               ((281.78 * BILL-PROV-WAGE-INDEX) + 158.44) * BILL-UNITS4.
      
           COMPUTE BILL-PAY-AMT-TOTAL =
                   WRK-PAY-RATE1 +
                   WRK-PAY-RATE2 +
                   WRK-PAY-RATE3 +
                   WRK-PAY-RATE4.
      
           MOVE WRK-PAY-RATE1        TO BILL-PAY-AMT1.
           MOVE WRK-PAY-RATE2        TO BILL-PAY-AMT2.
           MOVE WRK-PAY-RATE3        TO BILL-PAY-AMT3.
           MOVE WRK-PAY-RATE4        TO BILL-PAY-AMT4.
      
      
           MOVE ZEROES               TO WRK-PAY-RATE1
                                        WRK-PAY-RATE2
                                        WRK-PAY-RATE3
                                        WRK-PAY-RATE4.
      
       2000-EXIT.  EXIT.
      
      *----------------------------------------------------------****
      *  FY 2001 PROCESS
      *----------------------------------------------------------****
      
       2001-PROCESS-DATA.
           IF BILL-UNITS1 > 1000 OR
              BILL-UNITS2 > 1000 OR
              BILL-UNITS3 > 1000 OR
              BILL-UNITS4 > 1000
              MOVE '10' TO BILL-RTC
              GO TO 2001-EXIT.
      
           IF BILL-REV2 = '0652'
              IF BILL-UNITS2 < 8
                 MOVE '20' TO BILL-RTC
                 GO TO 2001-EXIT.
      
      ****    CALCULATE HOME RATE BY REVENUE CODE
      ****    CALCULATE HOME RATE BY REVENUE CODE
      
           IF BILL-REV1 = '0651'
              COMPUTE WRK-PAY-RATE1 ROUNDED =
               ((69.97 * BILL-BENE-WAGE-INDEX) + 31.87) * BILL-UNITS1.
      
           IF BILL-REV2 = '0652'
              COMPUTE WRK-PAY-RATE2 ROUNDED =
               (((408.42 * BILL-BENE-WAGE-INDEX)
                                         + 185.99) / 24) * BILL-UNITS2.
      
           IF BILL-REV3 = '0655'
              COMPUTE WRK-PAY-RATE3 ROUNDED =
               ((57.03 * BILL-PROV-WAGE-INDEX) + 48.32) * BILL-UNITS3.
      
           IF BILL-REV4 = '0656'
              COMPUTE WRK-PAY-RATE4 ROUNDED =
               ((289.99 * BILL-PROV-WAGE-INDEX) + 163.05) * BILL-UNITS4.
      
           COMPUTE BILL-PAY-AMT-TOTAL =
                   WRK-PAY-RATE1 +
                   WRK-PAY-RATE2 +
                   WRK-PAY-RATE3 +
                   WRK-PAY-RATE4.
      
           MOVE WRK-PAY-RATE1 TO  BILL-PAY-AMT1.
           MOVE WRK-PAY-RATE2 TO  BILL-PAY-AMT2.
           MOVE WRK-PAY-RATE3 TO  BILL-PAY-AMT3.
           MOVE WRK-PAY-RATE4 TO  BILL-PAY-AMT4.
      
      
           MOVE ZEROES TO WRK-PAY-RATE1
                           WRK-PAY-RATE2
                           WRK-PAY-RATE3
                           WRK-PAY-RATE4.
      
       2001-EXIT.  EXIT.
      
      *----------------------------------------------------------****
      *  FY 2001-A PROCESS
      *----------------------------------------------------------****
      
       2001A-PROCESS-DATA.
           IF BILL-UNITS1 > 1000 OR
              BILL-UNITS2 > 1000 OR
              BILL-UNITS3 > 1000 OR
              BILL-UNITS4 > 1000
              MOVE '10' TO BILL-RTC
              GO TO 2001A-EXIT.
      
           IF BILL-REV2 = '0652'
              IF BILL-UNITS2 < 8
                 MOVE '20' TO BILL-RTC
                 GO TO 2001A-EXIT.
      
      ****    CALCULATE HOME RATE BY REVENUE CODE
      ****    CALCULATE HOME RATE BY REVENUE CODE
      
           IF BILL-REV1 = '0651'
              COMPUTE WRK-PAY-RATE1 ROUNDED =
               ((73.47 * BILL-BENE-WAGE-INDEX) + 33.46) * BILL-UNITS1.
      
           IF BILL-REV2 = '0652'
              COMPUTE WRK-PAY-RATE2 ROUNDED =
               (((428.84 * BILL-BENE-WAGE-INDEX)
                                         + 195.29) / 24) * BILL-UNITS2.
      
           IF BILL-REV3 = '0655'
              COMPUTE WRK-PAY-RATE3 ROUNDED =
               ((59.88 * BILL-PROV-WAGE-INDEX) + 50.74) * BILL-UNITS3.
      
           IF BILL-REV4 = '0656'
              COMPUTE WRK-PAY-RATE4 ROUNDED =
               ((304.49 * BILL-PROV-WAGE-INDEX) + 171.20) * BILL-UNITS4.
      
           COMPUTE BILL-PAY-AMT-TOTAL =
                   WRK-PAY-RATE1 +
                   WRK-PAY-RATE2 +
                   WRK-PAY-RATE3 +
                   WRK-PAY-RATE4.
      
           MOVE WRK-PAY-RATE1       TO  BILL-PAY-AMT1.
           MOVE WRK-PAY-RATE2       TO  BILL-PAY-AMT2.
           MOVE WRK-PAY-RATE3       TO  BILL-PAY-AMT3.
           MOVE WRK-PAY-RATE4       TO  BILL-PAY-AMT4.
      
      
           MOVE ZEROES TO WRK-PAY-RATE1
                           WRK-PAY-RATE2
                           WRK-PAY-RATE3
                           WRK-PAY-RATE4.
      
       2001A-EXIT.  EXIT.
      
      *----------------------------------------------------------****
      *  FY 2002 PROCESS
      *----------------------------------------------------------****
      
       2002-PROCESS-DATA.
           IF BILL-UNITS1 > 1000 OR
              BILL-UNITS2 > 1000 OR
              BILL-UNITS3 > 1000 OR
              BILL-UNITS4 > 1000
              MOVE '10' TO BILL-RTC
              GO TO 2002-EXIT.
      
           IF BILL-REV2 = '0652'
              IF BILL-UNITS2 < 8
                 MOVE '20' TO BILL-RTC
                 GO TO 2002-EXIT.
      
      ****    CALCULATE HOME RATE BY REVENUE CODE
      ****    CALCULATE HOME RATE BY REVENUE CODE
      
           IF BILL-REV1 = '0651'
              COMPUTE WRK-PAY-RATE1 ROUNDED =
               ((75.87 * BILL-BENE-WAGE-INDEX) + 34.55) * BILL-UNITS1.
      
           IF BILL-REV2 = '0652'
              COMPUTE WRK-PAY-RATE2 ROUNDED =
               (((442.80 * BILL-BENE-WAGE-INDEX)
                                         + 201.65) / 24) * BILL-UNITS2.
      
           IF BILL-REV3 = '0655'
              COMPUTE WRK-PAY-RATE3 ROUNDED =
               ((61.83 * BILL-PROV-WAGE-INDEX) + 52.39) * BILL-UNITS3.
      
           IF BILL-REV4 = '0656'
              COMPUTE WRK-PAY-RATE4 ROUNDED =
               ((314.41 * BILL-PROV-WAGE-INDEX) + 176.78) * BILL-UNITS4.
      
           COMPUTE BILL-PAY-AMT-TOTAL =
                   WRK-PAY-RATE1 +
                   WRK-PAY-RATE2 +
                   WRK-PAY-RATE3 +
                   WRK-PAY-RATE4.
      
           MOVE WRK-PAY-RATE1 TO  BILL-PAY-AMT1.
           MOVE WRK-PAY-RATE2 TO  BILL-PAY-AMT2.
           MOVE WRK-PAY-RATE3 TO  BILL-PAY-AMT3.
           MOVE WRK-PAY-RATE4 TO  BILL-PAY-AMT4.
      
      
           MOVE ZEROES TO WRK-PAY-RATE1
                           WRK-PAY-RATE2
                           WRK-PAY-RATE3
                           WRK-PAY-RATE4.
      
       2002-EXIT.  EXIT.
      
      *----------------------------------------------------------****
      *  FY 2003 PROCESS
      *----------------------------------------------------------****
      
       2003-PROCESS-DATA.
           IF BILL-UNITS1 > 1000 OR
              BILL-UNITS2 > 1000 OR
              BILL-UNITS3 > 1000 OR
              BILL-UNITS4 > 1000
              MOVE '10' TO BILL-RTC
              GO TO 2003-EXIT.
      
           IF BILL-REV2 = '0652'
              IF BILL-UNITS2 < 8
                 MOVE '20' TO BILL-RTC
                 GO TO 2003-EXIT.
      
      ****    CALCULATE HOME RATE BY REVENUE CODE
      ****    CALCULATE HOME RATE BY REVENUE CODE
      
           IF BILL-REV1 = '0651'
              COMPUTE WRK-PAY-RATE1 ROUNDED =
               ((78.47 * BILL-BENE-WAGE-INDEX) + 35.73) * BILL-UNITS1.
      
           IF BILL-REV2 = '0652'
              COMPUTE WRK-PAY-RATE2 ROUNDED =
               (((457.97 * BILL-BENE-WAGE-INDEX)
                                         + 208.55) / 24) * BILL-UNITS2.
      
           IF BILL-REV3 = '0655'
              COMPUTE WRK-PAY-RATE3 ROUNDED =
               ((63.94 * BILL-PROV-WAGE-INDEX) + 54.19) * BILL-UNITS3.
      
           IF BILL-REV4 = '0656'
              COMPUTE WRK-PAY-RATE4 ROUNDED =
               ((325.18 * BILL-PROV-WAGE-INDEX) + 182.83) * BILL-UNITS4.
      
           COMPUTE BILL-PAY-AMT-TOTAL =
                   WRK-PAY-RATE1 +
                   WRK-PAY-RATE2 +
                   WRK-PAY-RATE3 +
                   WRK-PAY-RATE4.
      
           MOVE WRK-PAY-RATE1 TO  BILL-PAY-AMT1.
           MOVE WRK-PAY-RATE2 TO  BILL-PAY-AMT2.
           MOVE WRK-PAY-RATE3 TO  BILL-PAY-AMT3.
           MOVE WRK-PAY-RATE4 TO  BILL-PAY-AMT4.
      
      
           MOVE ZEROES TO WRK-PAY-RATE1
                           WRK-PAY-RATE2
                           WRK-PAY-RATE3
                           WRK-PAY-RATE4.
      
       2003-EXIT.  EXIT.
      
      *----------------------------------------------------------****
      *  FY 2004 PROCESS
      *----------------------------------------------------------****
      
       2004-PROCESS-DATA.
           IF BILL-UNITS1 > 1000 OR
              BILL-UNITS2 > 1000 OR
              BILL-UNITS3 > 1000 OR
              BILL-UNITS4 > 1000
              MOVE '10' TO BILL-RTC
              GO TO 2004-EXIT.
      
           IF BILL-REV2 = '0652'
              IF BILL-UNITS2 < 8
                 MOVE '20' TO BILL-RTC
                 GO TO 2004-EXIT.
      
      ****    CALCULATE HOME RATE BY REVENUE CODE
      ****    CALCULATE HOME RATE BY REVENUE CODE
      
           IF BILL-REV1 = '0651'
              COMPUTE WRK-PAY-RATE1 ROUNDED =
               ((81.13 * BILL-BENE-WAGE-INDEX) + 36.95) * BILL-UNITS1.
      
           IF BILL-REV2 = '0652'
              COMPUTE WRK-PAY-RATE2 ROUNDED =
               (((473.54 * BILL-BENE-WAGE-INDEX)
                                         + 215.64) / 24) * BILL-UNITS2.
      
           IF BILL-REV3 = '0655'
              COMPUTE WRK-PAY-RATE3 ROUNDED =
               ((66.12 * BILL-PROV-WAGE-INDEX) + 56.03) * BILL-UNITS3.
      
           IF BILL-REV4 = '0656'
              COMPUTE WRK-PAY-RATE4 ROUNDED =
               ((336.23 * BILL-PROV-WAGE-INDEX) + 189.05) * BILL-UNITS4.
      
           COMPUTE BILL-PAY-AMT-TOTAL =
                   WRK-PAY-RATE1 +
                   WRK-PAY-RATE2 +
                   WRK-PAY-RATE3 +
                   WRK-PAY-RATE4.
      
           MOVE WRK-PAY-RATE1 TO  BILL-PAY-AMT1.
           MOVE WRK-PAY-RATE2 TO  BILL-PAY-AMT2.
           MOVE WRK-PAY-RATE3 TO  BILL-PAY-AMT3.
           MOVE WRK-PAY-RATE4 TO  BILL-PAY-AMT4.
      
      
           MOVE ZEROES TO WRK-PAY-RATE1
                           WRK-PAY-RATE2
                           WRK-PAY-RATE3
                           WRK-PAY-RATE4.
      
       2004-EXIT.  EXIT.
      
      *----------------------------------------------------------****
      *  FY 2005 PROCESS
      *----------------------------------------------------------****
      
       2005-PROCESS-DATA.
           IF BILL-UNITS1 > 1000 OR
              BILL-UNITS2 > 1000 OR
              BILL-UNITS3 > 1000 OR
              BILL-UNITS4 > 1000
              MOVE '10' TO BILL-RTC
              GO TO 2005-EXIT.
      
           IF BILL-REV2 = '0652'
              IF BILL-UNITS2 < 8
                 MOVE '20' TO BILL-RTC
                 GO TO 2005-EXIT.
      
      ****    CALCULATE HOME RATE BY REVENUE CODE
      ****    CALCULATE HOME RATE BY REVENUE CODE
      
           IF BILL-REV1 = '0651'
              COMPUTE WRK-PAY-RATE1 ROUNDED =
               ((83.81 * BILL-BENE-WAGE-INDEX) + 38.17) * BILL-UNITS1.
      
           IF BILL-REV2 = '0652'
              COMPUTE WRK-PAY-RATE2 ROUNDED =
               (((489.16 * BILL-BENE-WAGE-INDEX)
                                         + 222.76) / 24) * BILL-UNITS2.
      
           IF BILL-REV3 = '0655'
              COMPUTE WRK-PAY-RATE3 ROUNDED =
               ((68.30 * BILL-PROV-WAGE-INDEX) + 57.88) * BILL-UNITS3.
      
           IF BILL-REV4 = '0656'
              COMPUTE WRK-PAY-RATE4 ROUNDED =
               ((347.32 * BILL-PROV-WAGE-INDEX) + 195.29) * BILL-UNITS4.
      
           COMPUTE BILL-PAY-AMT-TOTAL =
                   WRK-PAY-RATE1 +
                   WRK-PAY-RATE2 +
                   WRK-PAY-RATE3 +
                   WRK-PAY-RATE4.
      
           MOVE WRK-PAY-RATE1 TO  BILL-PAY-AMT1.
           MOVE WRK-PAY-RATE2 TO  BILL-PAY-AMT2.
           MOVE WRK-PAY-RATE3 TO  BILL-PAY-AMT3.
           MOVE WRK-PAY-RATE4 TO  BILL-PAY-AMT4.
      
      
           MOVE ZEROES TO WRK-PAY-RATE1
                           WRK-PAY-RATE2
                           WRK-PAY-RATE3
                           WRK-PAY-RATE4.
      
       2005-EXIT.  EXIT.
      
      *----------------------------------------------------------****
      *  FY 2006 PROCESS
      *----------------------------------------------------------****
      
       2006-PROCESS-DATA.
           IF BILL-UNITS1 > 1000 OR
              BILL-UNITS2 > 1000 OR
              BILL-UNITS3 > 1000 OR
              BILL-UNITS4 > 1000
              MOVE '10' TO BILL-RTC
              GO TO 2006-EXIT.
      
           IF BILL-REV2 = '0652'
              IF BILL-UNITS2 < 8
                 MOVE '20' TO BILL-RTC
                 GO TO 2006-EXIT.
      
      ****    CALCULATE HOME RATE BY REVENUE CODE
      ****    CALCULATE HOME RATE BY REVENUE CODE
      
           IF BILL-REV1 = '0651'
              COMPUTE WRK-PAY-RATE1 ROUNDED =
               ((86.91 * BILL-BENE-WAGE-INDEX) + 39.58) * BILL-UNITS1.
      
           IF BILL-REV2 = '0652'
              COMPUTE WRK-PAY-RATE2 ROUNDED =
               (((507.26 * BILL-BENE-WAGE-INDEX)
                                         + 231.00) / 24) * BILL-UNITS2.
      
           IF BILL-REV3 = '0655'
              COMPUTE WRK-PAY-RATE3 ROUNDED =
               ((70.83 * BILL-PROV-WAGE-INDEX) + 60.02) * BILL-UNITS3.
      
           IF BILL-REV4 = '0656'
              COMPUTE WRK-PAY-RATE4 ROUNDED =
               ((360.18 * BILL-PROV-WAGE-INDEX) + 202.51) * BILL-UNITS4.
      
           COMPUTE BILL-PAY-AMT-TOTAL =
                   WRK-PAY-RATE1 +
                   WRK-PAY-RATE2 +
                   WRK-PAY-RATE3 +
                   WRK-PAY-RATE4.
      
           MOVE WRK-PAY-RATE1 TO  BILL-PAY-AMT1.
           MOVE WRK-PAY-RATE2 TO  BILL-PAY-AMT2.
           MOVE WRK-PAY-RATE3 TO  BILL-PAY-AMT3.
           MOVE WRK-PAY-RATE4 TO  BILL-PAY-AMT4.
      
      
           MOVE ZEROES TO WRK-PAY-RATE1
                           WRK-PAY-RATE2
                           WRK-PAY-RATE3
                           WRK-PAY-RATE4.
      
       2006-EXIT.  EXIT.
      
      *----------------------------------------------------------****
      *  FY 2007 PROCESS
      *----------------------------------------------------------****
      
       2007-PROCESS-DATA.
           IF BILL-UNITS1 > 1000 OR
              BILL-UNITS2 > 1000 OR
              BILL-UNITS3 > 1000 OR
              BILL-UNITS4 > 1000
              MOVE '10' TO BILL-RTC
              GO TO 2007-EXIT.
      
           IF BILL-REV2 = '0652'
              IF BILL-UNITS2 < 8
                 MOVE '20' TO BILL-RTC
                 GO TO 2007-EXIT.
      
      ****    CALCULATE HOME RATE BY REVENUE CODE
      ****    CALCULATE HOME RATE BY REVENUE CODE
      
           IF BILL-REV1 = '0651'
              COMPUTE WRK-PAY-RATE1 ROUNDED =
               ((89.87 * BILL-BENE-WAGE-INDEX) + 40.92) * BILL-UNITS1.
      
           IF BILL-REV2 = '0652'
              COMPUTE WRK-PAY-RATE2 ROUNDED =
               (((524.50 * BILL-BENE-WAGE-INDEX)
                                         + 238.86) / 24) * BILL-UNITS2.
      
           IF BILL-REV3 = '0655'
              COMPUTE WRK-PAY-RATE3 ROUNDED =
               ((73.24 * BILL-PROV-WAGE-INDEX) + 62.06) * BILL-UNITS3.
      
           IF BILL-REV4 = '0656'
              COMPUTE WRK-PAY-RATE4 ROUNDED =
               ((372.42 * BILL-PROV-WAGE-INDEX) + 209.40) * BILL-UNITS4.
      
           COMPUTE BILL-PAY-AMT-TOTAL =
                   WRK-PAY-RATE1 +
                   WRK-PAY-RATE2 +
                   WRK-PAY-RATE3 +
                   WRK-PAY-RATE4.
      
           MOVE WRK-PAY-RATE1 TO  BILL-PAY-AMT1.
           MOVE WRK-PAY-RATE2 TO  BILL-PAY-AMT2.
           MOVE WRK-PAY-RATE3 TO  BILL-PAY-AMT3.
           MOVE WRK-PAY-RATE4 TO  BILL-PAY-AMT4.
      
      
           MOVE ZEROES TO WRK-PAY-RATE1
                           WRK-PAY-RATE2
                           WRK-PAY-RATE3
                           WRK-PAY-RATE4.
      
       2007-EXIT.  EXIT.
      
      *----------------------------------------------------------****
      *  FY 2007-1 PROCESS
      *----------------------------------------------------------****
      
       2007-1-PROCESS-DATA.
           IF BILL-UNITS1 > 1000 OR
              BILL-UNITS2 > 1000 OR
              BILL-UNITS3 > 1000 OR
              BILL-UNITS4 > 1000
              MOVE '10' TO BILL-RTC
              GO TO 2007-1-EXIT.
      
      ****    CALCULATE HOME RATE BY REVENUE CODE
      ****    CALCULATE HOME RATE BY REVENUE CODE
      
           IF BILL-REV1 = '0651'
              COMPUTE WRK-PAY-RATE1 ROUNDED =
               ((89.87 * BILL-BENE-WAGE-INDEX) + 40.92) * BILL-UNITS1.
      
           IF BILL-REV2 = '0652'
              IF BILL-UNITS2 > 0
                 IF BILL-UNITS2 < 32
                   COMPUTE WRK-PAY-RATE2 ROUNDED =
                     ((89.87 * BILL-BENE-WAGE-INDEX) + 40.92)
                 ELSE
                   COMPUTE WRK-PAY-RATE2 ROUNDED =
                     (((524.50 * BILL-BENE-WAGE-INDEX)
                            + 238.86) / 24) * (BILL-UNITS2 / 4).
      
           IF BILL-REV3 = '0655'
              COMPUTE WRK-PAY-RATE3 ROUNDED =
               ((73.24 * BILL-PROV-WAGE-INDEX) + 62.06) * BILL-UNITS3.
      
           IF BILL-REV4 = '0656'
              COMPUTE WRK-PAY-RATE4 ROUNDED =
              ((372.42 * BILL-PROV-WAGE-INDEX) + 209.40) * BILL-UNITS4.
      
           COMPUTE BILL-PAY-AMT-TOTAL =
                   WRK-PAY-RATE1 +
                   WRK-PAY-RATE2 +
                   WRK-PAY-RATE3 +
                   WRK-PAY-RATE4.
      
           MOVE WRK-PAY-RATE1 TO  BILL-PAY-AMT1.
           MOVE WRK-PAY-RATE2 TO  BILL-PAY-AMT2.
           MOVE WRK-PAY-RATE3 TO  BILL-PAY-AMT3.
           MOVE WRK-PAY-RATE4 TO  BILL-PAY-AMT4.
      
      
           MOVE ZEROES TO WRK-PAY-RATE1
                           WRK-PAY-RATE2
                           WRK-PAY-RATE3
                           WRK-PAY-RATE4.
      
       2007-1-EXIT. EXIT.
      *----------------------------------------------------------****
      *----------------------------------------------------------****
      *  FY 2008 PROCESS
      *----------------------------------------------------------****
      
       2008-PROCESS-DATA.
           IF BILL-UNITS1 > 1000 OR
              BILL-UNITS2 > 1000 OR
              BILL-UNITS3 > 1000 OR
              BILL-UNITS4 > 1000
              MOVE '10' TO BILL-RTC
              GO TO 2008-EXIT.
      
      ****    CALCULATE HOME RATE BY REVENUE CODE
      ****    CALCULATE HOME RATE BY REVENUE CODE
      
           IF BILL-REV1 = '0651'
              COMPUTE WRK-PAY-RATE1 ROUNDED =
               ((92.83 * BILL-BENE-WAGE-INDEX) + 42.28) * BILL-UNITS1.
      
           IF BILL-REV2 = '0652'
              IF BILL-UNITS2 > 0
                 IF BILL-UNITS2 < 32
                   COMPUTE WRK-PAY-RATE2 ROUNDED =
                     ((92.83 * BILL-BENE-WAGE-INDEX) + 42.28)
                 ELSE
                   COMPUTE WRK-PAY-RATE2 ROUNDED =
                     (((541.81 * BILL-BENE-WAGE-INDEX)
                            + 246.74) / 24) * (BILL-UNITS2 / 4).
      
           IF BILL-REV3 = '0655'
              COMPUTE WRK-PAY-RATE3 ROUNDED =
                ((75.65 * BILL-PROV-WAGE-INDEX) + 64.11) * BILL-UNITS3.
      
           IF BILL-REV4 = '0656'
              COMPUTE WRK-PAY-RATE4 ROUNDED =
              ((384.71 * BILL-PROV-WAGE-INDEX) + 216.31) * BILL-UNITS4.
      
           COMPUTE BILL-PAY-AMT-TOTAL =
                   WRK-PAY-RATE1 +
                   WRK-PAY-RATE2 +
                   WRK-PAY-RATE3 +
                   WRK-PAY-RATE4.
      
           MOVE WRK-PAY-RATE1 TO  BILL-PAY-AMT1.
           MOVE WRK-PAY-RATE2 TO  BILL-PAY-AMT2.
           MOVE WRK-PAY-RATE3 TO  BILL-PAY-AMT3.
           MOVE WRK-PAY-RATE4 TO  BILL-PAY-AMT4.
      
      
           MOVE ZEROES TO WRK-PAY-RATE1
                           WRK-PAY-RATE2
                           WRK-PAY-RATE3
                           WRK-PAY-RATE4.
      
       2008-EXIT. EXIT.
      *----------------------------------------------------------****
      *----------------------------------------------------------****
      *  FY 2009 PROCESS
      *----------------------------------------------------------****
      
       2009-PROCESS-DATA.
           IF BILL-UNITS1 > 1000 OR
              BILL-UNITS2 > 1000 OR
              BILL-UNITS3 > 1000 OR
              BILL-UNITS4 > 1000
              MOVE '10' TO BILL-RTC
              GO TO 2009-EXIT.
      
      ****    CALCULATE HOME RATE BY REVENUE CODE
      ****    CALCULATE HOME RATE BY REVENUE CODE
      
           IF BILL-REV1 = '0651'
              COMPUTE WRK-PAY-RATE1 ROUNDED =
                ((96.17 * BILL-BENE-WAGE-INDEX) + 43.80) * BILL-UNITS1.
      
           IF BILL-REV2 = '0652'
              IF BILL-UNITS2 > 0
                 IF BILL-UNITS2 < 32
                   COMPUTE WRK-PAY-RATE2 ROUNDED =
                     ((96.17 * BILL-BENE-WAGE-INDEX) + 43.80)
                 ELSE
                   COMPUTE WRK-PAY-RATE2 ROUNDED =
                     (((561.32 * BILL-BENE-WAGE-INDEX)
                            + 255.62) / 24) * (BILL-UNITS2 / 4).
      
           IF BILL-REV3 = '0655'
              COMPUTE WRK-PAY-RATE3 ROUNDED =
               ((78.37 * BILL-PROV-WAGE-INDEX) + 66.42) * BILL-UNITS3.
      
           IF BILL-REV4 = '0656'
              COMPUTE WRK-PAY-RATE4 ROUNDED =
              ((398.56 * BILL-PROV-WAGE-INDEX) + 224.10) * BILL-UNITS4.
      
           COMPUTE BILL-PAY-AMT-TOTAL =
                   WRK-PAY-RATE1 +
                   WRK-PAY-RATE2 +
                   WRK-PAY-RATE3 +
                   WRK-PAY-RATE4.
      
           MOVE WRK-PAY-RATE1 TO  BILL-PAY-AMT1.
           MOVE WRK-PAY-RATE2 TO  BILL-PAY-AMT2.
           MOVE WRK-PAY-RATE3 TO  BILL-PAY-AMT3.
           MOVE WRK-PAY-RATE4 TO  BILL-PAY-AMT4.
      
      
           MOVE ZEROES TO WRK-PAY-RATE1
                           WRK-PAY-RATE2
                           WRK-PAY-RATE3
                           WRK-PAY-RATE4.
      
       2009-EXIT. EXIT.
      *----------------------------------------------------------****
      *----------------------------------------------------------****
      *  FY 2010 PROCESS
      *----------------------------------------------------------****
      
       2010-PROCESS-DATA.
           IF BILL-UNITS1 > 1000 OR
              BILL-UNITS2 > 1000 OR
              BILL-UNITS3 > 1000 OR
              BILL-UNITS4 > 1000
              MOVE '10' TO BILL-RTC
              GO TO 2010-EXIT.
      
      ****    CALCULATE HOME RATE BY REVENUE CODE
      ****    CALCULATE HOME RATE BY REVENUE CODE
      
           IF BILL-REV1 = '0651'
              COMPUTE WRK-PAY-RATE1 ROUNDED =
                ((98.19 * BILL-BENE-WAGE-INDEX) + 44.72) * BILL-UNITS1.
      
           IF BILL-REV2 = '0652'
              IF BILL-UNITS2 > 0
                 IF BILL-UNITS2 < 32
                   COMPUTE WRK-PAY-RATE2 ROUNDED =
                     ((98.19 * BILL-BENE-WAGE-INDEX) + 44.72)
                 ELSE
                   COMPUTE WRK-PAY-RATE2 ROUNDED =
                     (((573.11 * BILL-BENE-WAGE-INDEX)
                            + 260.99) / 24) * (BILL-UNITS2 / 4).
      
           IF BILL-REV3 = '0655'
              COMPUTE WRK-PAY-RATE3 ROUNDED =
               ((80.02 * BILL-PROV-WAGE-INDEX) + 67.81) * BILL-UNITS3.
      
           IF BILL-REV4 = '0656'
              COMPUTE WRK-PAY-RATE4 ROUNDED =
               ((406.94 * BILL-PROV-WAGE-INDEX) + 228.80) * BILL-UNITS4.
      
           COMPUTE BILL-PAY-AMT-TOTAL =
                   WRK-PAY-RATE1 +
                   WRK-PAY-RATE2 +
                   WRK-PAY-RATE3 +
                   WRK-PAY-RATE4.
      
           MOVE WRK-PAY-RATE1 TO  BILL-PAY-AMT1.
           MOVE WRK-PAY-RATE2 TO  BILL-PAY-AMT2.
           MOVE WRK-PAY-RATE3 TO  BILL-PAY-AMT3.
           MOVE WRK-PAY-RATE4 TO  BILL-PAY-AMT4.
      
      
           MOVE ZEROES TO WRK-PAY-RATE1
                           WRK-PAY-RATE2
                           WRK-PAY-RATE3
                           WRK-PAY-RATE4.
      
       2010-EXIT. EXIT.
      *----------------------------------------------------------****
      *  FY 2011 PROCESS
      *----------------------------------------------------------****
      
       2011-PROCESS-DATA.
           IF BILL-UNITS1 > 1000 OR
              BILL-UNITS2 > 1000 OR
              BILL-UNITS3 > 1000 OR
              BILL-UNITS4 > 1000
              MOVE '10' TO BILL-RTC
              GO TO 2011-EXIT.
      
      ****    CALCULATE HOME RATE BY REVENUE CODE
      ****    CALCULATE HOME RATE BY REVENUE CODE
      
           IF BILL-REV1 = '0651'
              COMPUTE WRK-PAY-RATE1 ROUNDED =
               ((100.75 * BILL-BENE-WAGE-INDEX) + 45.88) * BILL-UNITS1.
      
           IF BILL-REV2 = '0652'
              IF BILL-UNITS2 > 0
                 IF BILL-UNITS2 < 32
                   COMPUTE WRK-PAY-RATE2 ROUNDED =
                     ((100.75 * BILL-BENE-WAGE-INDEX) + 45.88)
                 ELSE
                   COMPUTE WRK-PAY-RATE2 ROUNDED =
                     (((588.01 * BILL-BENE-WAGE-INDEX)
                            + 267.78) / 24) * (BILL-UNITS2 / 4).
      
           IF BILL-REV3 = '0655'
              COMPUTE WRK-PAY-RATE3 ROUNDED =
               ((82.10 * BILL-PROV-WAGE-INDEX) + 69.57) * BILL-UNITS3.
      
           IF BILL-REV4 = '0656'
              COMPUTE WRK-PAY-RATE4 ROUNDED =
               ((417.52 * BILL-PROV-WAGE-INDEX) + 234.75) * BILL-UNITS4.
      
           COMPUTE BILL-PAY-AMT-TOTAL =
                   WRK-PAY-RATE1 +
                   WRK-PAY-RATE2 +
                   WRK-PAY-RATE3 +
                   WRK-PAY-RATE4.
      
           MOVE WRK-PAY-RATE1 TO  BILL-PAY-AMT1.
           MOVE WRK-PAY-RATE2 TO  BILL-PAY-AMT2.
           MOVE WRK-PAY-RATE3 TO  BILL-PAY-AMT3.
           MOVE WRK-PAY-RATE4 TO  BILL-PAY-AMT4.
      
      
           MOVE ZEROES TO WRK-PAY-RATE1
                           WRK-PAY-RATE2
                           WRK-PAY-RATE3
                           WRK-PAY-RATE4.
      
       2011-EXIT. EXIT.
      
      *----------------------------------------------------------****
      *  FY 2012 PROCESS
      *----------------------------------------------------------****
      
       2012-PROCESS-DATA.
           IF BILL-UNITS1 > 1000 OR
              BILL-UNITS2 > 1000 OR
              BILL-UNITS3 > 1000 OR
              BILL-UNITS4 > 1000
              MOVE '10' TO BILL-RTC
              GO TO 2012-EXIT.
      
      ****    CALCULATE HOME RATE BY REVENUE CODE
      ****    CALCULATE HOME RATE BY REVENUE CODE
      
           IF BILL-REV1 = '0651'
              COMPUTE WRK-PAY-RATE1 ROUNDED =
               ((103.77 * BILL-BENE-WAGE-INDEX) + 47.26) * BILL-UNITS1.
      
           IF BILL-REV2 = '0652'
              IF BILL-UNITS2 > 0
                 IF BILL-UNITS2 < 32
                   COMPUTE WRK-PAY-RATE2 ROUNDED =
                     ((103.77 * BILL-BENE-WAGE-INDEX) + 47.26)
                 ELSE
                   COMPUTE WRK-PAY-RATE2 ROUNDED =
                     (((605.65 * BILL-BENE-WAGE-INDEX)
                            + 275.81) / 24) * (BILL-UNITS2 / 4).
      
           IF BILL-REV3 = '0655'
              COMPUTE WRK-PAY-RATE3 ROUNDED =
               ((84.56 * BILL-PROV-WAGE-INDEX) + 71.66) * BILL-UNITS3.
      
           IF BILL-REV4 = '0656'
              COMPUTE WRK-PAY-RATE4 ROUNDED =
               ((430.04 * BILL-PROV-WAGE-INDEX) + 241.80) * BILL-UNITS4.
      
           COMPUTE BILL-PAY-AMT-TOTAL =
                   WRK-PAY-RATE1 +
                   WRK-PAY-RATE2 +
                   WRK-PAY-RATE3 +
                   WRK-PAY-RATE4.
      
           MOVE WRK-PAY-RATE1        TO BILL-PAY-AMT1.
           MOVE WRK-PAY-RATE2        TO BILL-PAY-AMT2.
           MOVE WRK-PAY-RATE3        TO BILL-PAY-AMT3.
           MOVE WRK-PAY-RATE4        TO BILL-PAY-AMT4.
      
      
           MOVE ZEROES               TO WRK-PAY-RATE1
                                        WRK-PAY-RATE2
                                        WRK-PAY-RATE3
                                        WRK-PAY-RATE4.
      
       2012-EXIT. EXIT.
      
      *----------------------------------------------------------****
      *  FY 2013 PROCESS
      *----------------------------------------------------------****
      
       2013-PROCESS-DATA.
           IF BILL-UNITS1 > 1000 OR
              BILL-UNITS2 > 1000 OR
              BILL-UNITS3 > 1000 OR
              BILL-UNITS4 > 1000
              MOVE '10' TO BILL-RTC
              GO TO 2013-EXIT.
      
      ****    CALCULATE HOME RATE BY REVENUE CODE
      ****    CALCULATE HOME RATE BY REVENUE CODE
      
           IF BILL-REV1 = '0651'
              COMPUTE WRK-PAY-RATE1 ROUNDED =
                ((105.44 * BILL-BENE-WAGE-INDEX) + 48.01) * BILL-UNITS1.
      
           IF BILL-REV2 = '0652'
              IF BILL-UNITS2 > 0
                 IF BILL-UNITS2 < 32
                   COMPUTE WRK-PAY-RATE2 ROUNDED =
                     ((105.44 * BILL-BENE-WAGE-INDEX) + 48.01)
                 ELSE
                   COMPUTE WRK-PAY-RATE2 ROUNDED =
                     (((615.34 * BILL-BENE-WAGE-INDEX)
                            + 280.22) / 24) * (BILL-UNITS2 / 4).
      
           IF BILL-REV3 = '0655'
              COMPUTE WRK-PAY-RATE3 ROUNDED =
                ((85.92 * BILL-PROV-WAGE-INDEX) + 72.80) * BILL-UNITS3.
      
           IF BILL-REV4 = '0656'
              COMPUTE WRK-PAY-RATE4 ROUNDED =
               ((436.93 * BILL-PROV-WAGE-INDEX) + 245.66) * BILL-UNITS4.
      
           COMPUTE BILL-PAY-AMT-TOTAL =
                   WRK-PAY-RATE1 +
                   WRK-PAY-RATE2 +
                   WRK-PAY-RATE3 +
                   WRK-PAY-RATE4.
      
           MOVE WRK-PAY-RATE1        TO  BILL-PAY-AMT1.
           MOVE WRK-PAY-RATE2        TO  BILL-PAY-AMT2.
           MOVE WRK-PAY-RATE3        TO  BILL-PAY-AMT3.
           MOVE WRK-PAY-RATE4        TO BILL-PAY-AMT4.
      
      
           MOVE ZEROES               TO WRK-PAY-RATE1
                                        WRK-PAY-RATE2
                                        WRK-PAY-RATE3
                                        WRK-PAY-RATE4.
      
       2013-EXIT. EXIT.
      
      *----------------------------------------------------------****
      *  FY 2014 PROCESS
      *----------------------------------------------------------****
      
       2014-PROCESS-DATA.
      
           IF BILL-UNITS1 > 1000 OR
              BILL-UNITS2 > 1000 OR
              BILL-UNITS3 > 1000 OR
              BILL-UNITS4 > 1000
              MOVE '10'              TO BILL-RTC
              GO TO 2014-EXIT.
      
      
           IF BILL-QIP-IND = '1'
              PERFORM 2014-APPLY-QIP
                 THRU 2014-QIP-EXIT
           ELSE
              PERFORM 2014-APPLY-NO-QIP
                 THRU 2014-NO-QIP-EXIT.
      
           COMPUTE BILL-PAY-AMT-TOTAL =
                   WRK-PAY-RATE1 +
                   WRK-PAY-RATE2 +
                   WRK-PAY-RATE3 +
                   WRK-PAY-RATE4.
      
      
           MOVE WRK-PAY-RATE1        TO  BILL-PAY-AMT1.
           MOVE WRK-PAY-RATE2        TO  BILL-PAY-AMT2.
           MOVE WRK-PAY-RATE3        TO  BILL-PAY-AMT3.
           MOVE WRK-PAY-RATE4        TO  BILL-PAY-AMT4.
      
      
           MOVE ZEROES               TO WRK-PAY-RATE1
                                        WRK-PAY-RATE2
                                        WRK-PAY-RATE3
                                        WRK-PAY-RATE4.
      
       2014-EXIT. EXIT.
      
       2014-APPLY-NO-QIP.
      
      ****=====================
      ****    QIP IND = '  '
      ****=====================
      ****    CALCULATE HOME RATE BY REVENUE CODE (NO QIP REDUCTION)
      ****    CALCULATE HOME RATE BY REVENUE CODE (NO QIP REDUCTION)
      
      
           IF BILL-REV1 = '0651'
              COMPUTE WRK-PAY-RATE1 ROUNDED =
               ((107.23 * BILL-BENE-WAGE-INDEX) + 48.83) * BILL-UNITS1.
      
      
      
      
           IF BILL-REV2 = '0652'
              IF BILL-UNITS2 > 0
                 IF BILL-UNITS2 < 32
                   COMPUTE WRK-PAY-RATE2 ROUNDED =
                     ((107.23 * BILL-BENE-WAGE-INDEX) + 48.83)
                 ELSE
                   COMPUTE WRK-PAY-RATE2 ROUNDED =
                     (((625.80 * BILL-BENE-WAGE-INDEX)
                            + 284.98) / 24) * (BILL-UNITS2 / 4).
      
      
      
           IF BILL-REV3 = '0655'
              COMPUTE WRK-PAY-RATE3 ROUNDED =
               ((87.38 * BILL-PROV-WAGE-INDEX) + 74.04) * BILL-UNITS3.
      
      
      
      
           IF BILL-REV4 = '0656'
              COMPUTE WRK-PAY-RATE4 ROUNDED =
             ((444.35 * BILL-PROV-WAGE-INDEX) + 249.84) * BILL-UNITS4.
      
      
       2014-NO-QIP-EXIT. EXIT.
      
      
       2014-APPLY-QIP.
      
      ****=====================
      ****    QIP IND = '1'    >> PAYMENT RATE IS LOWER
      ****=====================
      ****    CALCULATE HOME RATE BY REVENUE CODE (WITH QIP REDUCTION)
      ****    CALCULATE HOME RATE BY REVENUE CODE (WITH QIP REDUCTION)
      
           IF BILL-REV1 = '0651'
              COMPUTE WRK-PAY-RATE1 ROUNDED =
                ((105.12 * BILL-BENE-WAGE-INDEX) + 47.87) * BILL-UNITS1.
      
           IF BILL-REV2 = '0652'
              IF BILL-UNITS2 > 0
                 IF BILL-UNITS2 < 32
                   COMPUTE WRK-PAY-RATE2 ROUNDED =
                     ((105.12 * BILL-BENE-WAGE-INDEX) + 47.87)
                 ELSE
                   COMPUTE WRK-PAY-RATE2 ROUNDED =
                     (((613.49 * BILL-BENE-WAGE-INDEX)
                            + 279.38) / 24) * (BILL-UNITS2 / 4).
      
           IF BILL-REV3 = '0655'
              COMPUTE WRK-PAY-RATE3 ROUNDED =
                ((85.66 * BILL-PROV-WAGE-INDEX) + 72.58) * BILL-UNITS3.
      
           IF BILL-REV4 = '0656'
              COMPUTE WRK-PAY-RATE4 ROUNDED =
               ((435.61 * BILL-PROV-WAGE-INDEX) + 244.93) * BILL-UNITS4.
      
      
       2014-QIP-EXIT. EXIT.
      
       2015-PROCESS-DATA.
      
           IF BILL-UNITS1 > 1000 OR
              BILL-UNITS2 > 1000 OR
              BILL-UNITS3 > 1000 OR
              BILL-UNITS4 > 1000
              MOVE '10'              TO BILL-RTC
              GO TO 2015-EXIT.
      
      
           IF BILL-QIP-IND = '1'
              PERFORM 2015-APPLY-QIP
                 THRU 2015-QIP-EXIT
           ELSE
              PERFORM 2015-APPLY-NO-QIP
                 THRU 2015-NO-QIP-EXIT.
      
           COMPUTE BILL-PAY-AMT-TOTAL =
                   WRK-PAY-RATE1 +
                   WRK-PAY-RATE2 +
                   WRK-PAY-RATE3 +
                   WRK-PAY-RATE4.
      
      
           MOVE WRK-PAY-RATE1        TO  BILL-PAY-AMT1.
           MOVE WRK-PAY-RATE2        TO  BILL-PAY-AMT2.
           MOVE WRK-PAY-RATE3        TO  BILL-PAY-AMT3.
           MOVE WRK-PAY-RATE4        TO  BILL-PAY-AMT4.
      
      
           MOVE ZEROES               TO WRK-PAY-RATE1
                                        WRK-PAY-RATE2
                                        WRK-PAY-RATE3
                                        WRK-PAY-RATE4.
      
       2015-EXIT. EXIT.
      
       2015-APPLY-NO-QIP.
      
      ****=====================
      ****    QIP IND = '  '   PAYMENT RATE IS HIGHER  (TABLE 1)
      ****=====================
      ****    CALCULATE HOME RATE BY REVENUE CODE (NO QIP REDUCTION)
      ****    CALCULATE HOME RATE BY REVENUE CODE (NO QIP REDUCTION)
      
      
           IF BILL-REV1 = '0651'
              COMPUTE WRK-PAY-RATE1 ROUNDED =
               ((109.48 * BILL-BENE-WAGE-INDEX) + 49.86) * BILL-UNITS1.
      
      
           IF BILL-REV2 = '0652'
              IF BILL-UNITS2 > 0
                 IF BILL-UNITS2 < 32
                   COMPUTE WRK-PAY-RATE2 ROUNDED =
                     ((109.48 * BILL-BENE-WAGE-INDEX) + 49.86)
                 ELSE
                   COMPUTE WRK-PAY-RATE2 ROUNDED =
                     (((638.94 * BILL-BENE-WAGE-INDEX)
                            + 290.97) / 24) * (BILL-UNITS2 / 4).
      
      
           IF BILL-REV3 = '0655'
              COMPUTE WRK-PAY-RATE3 ROUNDED =
                ((89.21 * BILL-PROV-WAGE-INDEX) + 75.60) * BILL-UNITS3.
      
      
      
      
           IF BILL-REV4 = '0656'
              COMPUTE WRK-PAY-RATE4 ROUNDED =
               ((453.68 * BILL-PROV-WAGE-INDEX) + 255.09) * BILL-UNITS4.
      
      
       2015-NO-QIP-EXIT. EXIT.
      
      
       2015-APPLY-QIP.
      
      
      ****=====================
      ****    QIP IND = '1'    >> PAYMENT RATE IS LOWER (TABLE 2)
      ****=====================
      ****    CALCULATE HOME RATE BY REVENUE CODE (WITH QIP REDUCTION)
      ****    CALCULATE HOME RATE BY REVENUE CODE (WITH QIP REDUCTION)
      
           IF BILL-REV1 = '0651'
              COMPUTE WRK-PAY-RATE1 ROUNDED =
                ((107.34 * BILL-BENE-WAGE-INDEX) + 48.88) * BILL-UNITS1.
      
           IF BILL-REV2 = '0652'
              IF BILL-UNITS2 > 0
                 IF BILL-UNITS2 < 32
                   COMPUTE WRK-PAY-RATE2 ROUNDED =
                     ((107.34 * BILL-BENE-WAGE-INDEX) + 48.88)
                 ELSE
                   COMPUTE WRK-PAY-RATE2 ROUNDED =
                     (((626.42 * BILL-BENE-WAGE-INDEX)
                            + 285.27) / 24) * (BILL-UNITS2 / 4).
      
           IF BILL-REV3 = '0655'
              COMPUTE WRK-PAY-RATE3 ROUNDED =
                ((87.46 * BILL-PROV-WAGE-INDEX) + 74.12) * BILL-UNITS3.
      
           IF BILL-REV4 = '0656'
              COMPUTE WRK-PAY-RATE4 ROUNDED =
              ((444.79 * BILL-PROV-WAGE-INDEX) + 250.09) * BILL-UNITS4.
      
      
       2015-QIP-EXIT. EXIT.
      
      
      ****========================================================****
      ****==============  BEGIN V160 PROCESS  ====================****
      ****=========  VALID FROM 10/01/15 THRU 12/31/15  ==========****
      ****========================================================****
      
       2016-PROCESS-DATA.
      
           IF BILL-UNITS1 > 1000 OR
              BILL-UNITS2 > 1000 OR
              BILL-UNITS3 > 1000 OR
              BILL-UNITS4 > 1000
              MOVE '10'              TO BILL-RTC
              GO TO 2016-EXIT.
      
      
           IF BILL-QIP-IND = '1'
              PERFORM 2016-APPLY-QIP
                 THRU 2016-QIP-EXIT
           ELSE
              PERFORM 2016-APPLY-NO-QIP
                 THRU 2016-NO-QIP-EXIT.
      
           COMPUTE BILL-PAY-AMT-TOTAL =
                   WRK-PAY-RATE1 +
                   WRK-PAY-RATE2 +
                   WRK-PAY-RATE3 +
                   WRK-PAY-RATE4.
      
      
           MOVE WRK-PAY-RATE1        TO  BILL-PAY-AMT1.
           MOVE WRK-PAY-RATE2        TO  BILL-PAY-AMT2.
           MOVE WRK-PAY-RATE3        TO  BILL-PAY-AMT3.
           MOVE WRK-PAY-RATE4        TO  BILL-PAY-AMT4.
      
      
           MOVE ZEROES               TO WRK-PAY-RATE1
                                        WRK-PAY-RATE2
                                        WRK-PAY-RATE3
                                        WRK-PAY-RATE4.
      
       2016-EXIT. EXIT.
      
       2016-APPLY-NO-QIP.
      
      
      ****=====================================================
      ****    QIP IND = '  '   PAYMENT RATE IS HIGHER  (TABLE 1)
      ****======================================================
      ****    CALCULATE HOME RATE BY REVENUE CODE (NO QIP REDUCTION)
      ****    CALCULATE HOME RATE BY REVENUE CODE (NO QIP REDUCTION)
      
      ****============================================================
      ****  V16.0  RHC - ROUTINE HOME CARE = REVENUE CODE = 0651
      ****============================================================
      
      
           IF BILL-REV1 = '0651'
              COMPUTE WRK-PAY-RATE1 ROUNDED =
           ((2016-RHC-LS-RATE * BILL-BENE-WAGE-INDEX)
              + 2016-RHC-NLS-RATE)  * BILL-UNITS1.
      
      
      ****============================================================
      **** V16.0 CHC - CONTINUOUS HOME CARE = REVENUE CODE = 0652
      ****============================================================
      
           IF BILL-REV2 = '0652'
              IF BILL-UNITS2 > 0
                 IF BILL-UNITS2 < 32
                   COMPUTE WRK-PAY-RATE2 ROUNDED =
                   ((2016-RHC-LS-RATE * BILL-BENE-WAGE-INDEX)
                        + 2016-RHC-NLS-RATE)
                 ELSE
                   COMPUTE WRK-PAY-RATE2 ROUNDED =
                    (((2016-CHC-LS-RATE *  BILL-BENE-WAGE-INDEX)
                        + 2016-CHC-NLS-RATE) / 24) * (BILL-UNITS2 / 4).
      
      
      
      ****============================================================
      **** V16.0 IRC - INPATIENT RESPITE CARE = REVENUE CODE = 0655
      ****============================================================
      
      
           IF BILL-REV3 = '0655'
              COMPUTE WRK-PAY-RATE3 ROUNDED =
                  ((2016-IRC-LS-RATE * BILL-PROV-WAGE-INDEX)
                        + 2016-IRC-NLS-RATE) *  BILL-UNITS3.
      
      
      
      ****============================================================
      ****  V16.0 GIC - GENERAL INPATIENT CARE = REVENUE CODE = 0656
      ****============================================================
      
      
           IF BILL-REV4 = '0656'
              COMPUTE WRK-PAY-RATE4 ROUNDED =
                  ((2016-GIC-LS-RATE * BILL-PROV-WAGE-INDEX)
                        + 2016-GIC-NLS-RATE) *  BILL-UNITS4.
      
       2016-NO-QIP-EXIT. EXIT.
      
      
       2016-APPLY-QIP.
      
      *
      ****=====================
      ****    QIP IND = '1'    >> PAYMENT RATE IS LOWER (TABLE 2)
      ****=====================
      ****    CALCULATE HOME RATE BY REVENUE CODE (WITH QIP REDUCTION)
      ****    CALCULATE HOME RATE BY REVENUE CODE (WITH QIP REDUCTION)
      
      
           IF BILL-REV1 = '0651'
              COMPUTE WRK-PAY-RATE1 ROUNDED =
                  ((2016-RHC-LS-RATE-Q * BILL-BENE-WAGE-INDEX)
                        + 2016-RHC-NLS-RATE-Q) *  BILL-UNITS1.
      
      ****============================================================
      ****  V16.0 CHC - CONTINUOUS HOME CARE = REVENUE CODE = 0652
      ****============================================================
      
           IF BILL-REV2 = '0652'
              IF BILL-UNITS2 > 0
                 IF BILL-UNITS2 < 32
                   COMPUTE WRK-PAY-RATE2 ROUNDED =
                    ((2016-RHC-LS-RATE-Q * BILL-BENE-WAGE-INDEX)
                        + 2016-RHC-NLS-RATE-Q)
                 ELSE
                   COMPUTE WRK-PAY-RATE2 ROUNDED =
                    (((2016-CHC-LS-RATE-Q * BILL-BENE-WAGE-INDEX)
                      + 2016-CHC-NLS-RATE-Q) / 24) * (BILL-UNITS2 / 4).
      
      
      ****============================================================
      ****  V16.0  IRC - INPATIENT RESPITE CARE = REVENUE CODE = 0655
      ****============================================================
      
           IF BILL-REV3 = '0655'
              COMPUTE WRK-PAY-RATE3 ROUNDED =
                  ((2016-IRC-LS-RATE-Q * BILL-PROV-WAGE-INDEX)
                        + 2016-IRC-NLS-RATE-Q) *  BILL-UNITS3.
      
      
      ****============================================================
      **** V16.0 GIC - GENERAL INPATIENT CARE = REVENUE CODE = 0656
      ****============================================================
      
      
           IF BILL-REV4 = '0656'
              COMPUTE WRK-PAY-RATE4 ROUNDED =
                  ((2016-GIC-LS-RATE-Q * BILL-PROV-WAGE-INDEX)
                        + 2016-GIC-NLS-RATE-Q) *  BILL-UNITS4.
      
      
       2016-QIP-EXIT. EXIT.
      
      ****==============  END OF V160 PROCESS  ===================****
      ****=========  VALID FROM 10/01/15 THRU 12/31/15  ==========****
      
      
      
      ****========================================================****
      ****==============  BEGIN V161 PROCESS  ====================****
      ****=========  VALID FROM 01/01/16 THRU 09/30/16  ==========****
      ****========================================================****
      
      
      ****************************************************************
      **** V16.1   MAINLINE PROCESS FOR V161
      ****************************************************************
       2016-V161-PROCESS-DATA.
      
      
      *---------------------------------------------------------------
      *  VALIDATE BILL INPUT DATA - UNITS
      *---------------------------------------------------------------
           IF BILL-UNITS1 > 1000 OR
              BILL-UNITS2 > 1000 OR
              BILL-UNITS3 > 1000 OR
              BILL-UNITS4 > 1000
              MOVE '10' TO BILL-RTC
              GO TO 2016-V161-PROCESS-EXIT
           END-IF.
      
      
      *---------------------------------------------------------------
      *  CALCULATE PAYMENT FOR EACH LEVEL OF CARE BY REVENUE CODE
      *---------------------------------------------------------------
           IF BILL-REV1 = '0651'
              PERFORM 2016-V161-RHC-0651
                 THRU 2016-V161-RHC-0651-EXIT.
      
      
      
           IF BILL-REV2 = '0652'
              PERFORM 2020-V200-CHC-0652
                 THRU 2020-V200-CHC-0652-EXIT.
      
      
           IF BILL-REV3 = '0655'
              PERFORM 2020-V200-IRC-0655
                 THRU 2020-V200-IRC-0655-EXIT.
      
      
           IF BILL-REV4 = '0656'
              PERFORM 2020-V200-GIC-0656
                 THRU 2020-V200-GIC-0656-EXIT.
      
      
      *---------------------------------------------------------------
      *  CALCULATE TOTAL CLAIM PAYMENT
      *---------------------------------------------------------------
           COMPUTE BILL-PAY-AMT-TOTAL =
                   WRK-PAY-RATE1 +
                   WRK-PAY-RATE2 +
                   WRK-PAY-RATE3 +
                   WRK-PAY-RATE4 +
                   SIA-PAY-AMT-TOTAL.
      
      
      *---------------------------------------------------------------
      *  MOVE EACH LEVEL OF CARE'S PAYMENT TO THE OUTPUT RECORD
      *---------------------------------------------------------------
           MOVE WRK-PAY-RATE1        TO  BILL-PAY-AMT1.
           MOVE WRK-PAY-RATE2        TO  BILL-PAY-AMT2.
           MOVE WRK-PAY-RATE3        TO  BILL-PAY-AMT3.
           MOVE WRK-PAY-RATE4        TO  BILL-PAY-AMT4.
      
      
      *---------------------------------------------------------------
      *  INITIALIZE WORKING STORAGE PAYMENT VARIABLES
      *---------------------------------------------------------------
           MOVE ZEROES               TO WRK-PAY-RATE1
                                        WRK-PAY-RATE2
                                        WRK-PAY-RATE3
                                        WRK-PAY-RATE4.
      
       2016-V161-PROCESS-EXIT.
           EXIT.
      
      
      
      ****************************************************************
      **** V16.1   RHC - ROUTINE HOME CARE = REVENUE CODE = 0651
      ****************************************************************
       2016-V161-RHC-0651.
      
      
      *==================================================
      *  >>> IF REVENUE CODE '0651' UNITS > 0         <<<
      *  >>> [THE DAY IS AN RHC LEVEL OF CARE DAY]    <<<
      *  >>> 1 UNIT = 1 DAY                           <<<
      *==================================================
           IF BILL-UNITS1 NOT > 0
              GO TO 2016-V161-RHC-0651-EXIT
           END-IF.
      
      
      *---------------------------------------------------------------
      * DATE ERROR - CANNOT CONTINUE RHC LEVEL OF CARE DAY PROCESSING
      *---------------------------------------------------------------
           IF BILL-LINE-ITEM-DOS1 < BILL-ADMISSION-DATE
              GO TO 2016-V161-RHC-0651-EXIT
           END-IF.
      
      
      *---------------------------------------------------------------
      * CALCULATE RHC LEVEL OF CARE DAY PAYMENT
      *---------------------------------------------------------------
      
           MOVE BILL-LINE-ITEM-DOS1 TO DATE-2-DOS.
           PERFORM V161-CALC-PRIOR-SVC-DAYS
              THRU V161-CALC-PRIOR-SVC-DAYS-EXIT.
      
           PERFORM V161-EVAL-RHC-DAYS
              THRU V161-EVAL-RHC-DAYS-EXIT.
      
           PERFORM V161-CALC-RHC-EOL-SIA
              THRU V161-CALC-RHC-EOL-SIA-EXIT.
      
           PERFORM V161-SUM-RHC-0651-RATE
              THRU V161-SUM-RHC-0651-RATE-EXIT.
      
      
       2016-V161-RHC-0651-EXIT.
           EXIT.
      
      
      
      ****************************************************************
       V161-EVAL-RHC-DAYS.
      ****************************************************************
      
      *---------------------------------------------------------------
      * SERVICE BEYOND 60TH DAY - APPLY RHC LOW RATE TO ALL RHC DAYS
      *---------------------------------------------------------------
           IF PRIOR-SVC-DAYS >= 60
              MOVE BILL-UNITS1 TO LR-BILL-UNITS1
              PERFORM V161-APPLY-LOW-RHC-RATE
                 THRU V161-APPLY-LOW-RHC-RATE-EXIT
              GO TO V161-EVAL-RHC-DAYS-EXIT
           END-IF.
      
      
      *---------------------------------------------------------------
      * SERVICE ON 60TH DAY OR EARLIER - APPLY RHC HIGH/LOW RATES
      *---------------------------------------------------------------
           IF PRIOR-SVC-DAYS < 60
              COMPUTE HIGH-RATE-DAYS-LEFT = 60 - PRIOR-SVC-DAYS
      
      
      *---------------------------------------------------------------
      * - RHC DAYS <= HIGH RATE DAYS LEFT - APPLY RHC HIGH RATE TO ALL
      *---------------------------------------------------------------
              IF BILL-UNITS1 <= HIGH-RATE-DAYS-LEFT
                 MOVE BILL-UNITS1 TO HR-BILL-UNITS1
                 PERFORM V161-APPLY-HIGH-RHC-RATE
                    THRU V161-APPLY-HIGH-RHC-RATE-EXIT
                 GO TO V161-EVAL-RHC-DAYS-EXIT
      
      
      *---------------------------------------------------------------
      * - RHC DAYS > HIGH RATE DAYS LEFT - APPLY RHC HIGH & LOW RATES
      *---------------------------------------------------------------
              ELSE
      
                 MOVE HIGH-RATE-DAYS-LEFT TO HR-BILL-UNITS1
                 PERFORM V161-APPLY-HIGH-RHC-RATE
                    THRU V161-APPLY-HIGH-RHC-RATE-EXIT
      
                 COMPUTE LR-BILL-UNITS1 =
                         BILL-UNITS1 - HR-BILL-UNITS1
                 PERFORM V161-APPLY-LOW-RHC-RATE
                    THRU V161-APPLY-LOW-RHC-RATE-EXIT
      
              END-IF
           END-IF.
      
      
       V161-EVAL-RHC-DAYS-EXIT.
           EXIT.
      
      
      
      ****************************************************************
      **** V16.1   CALCULATE RHC LOW-RATE PAYMENT
      ****************************************************************
       V161-APPLY-LOW-RHC-RATE.
      *---------------------------------------------------------------
      * QIP REDUCTION APPLIED
      *---------------------------------------------------------------
           IF BILL-QIP-IND = '1'
              COMPUTE LR-BILL-PAY-AMT1 ROUNDED =
                 ((2016-V161-LOW-RHC-LS-RATE-Q * BILL-BENE-WAGE-INDEX)
                 + 2016-V161-LOW-RHC-NLS-RATE-Q) *  LR-BILL-UNITS1
      
      *---------------------------------------------------------------
      * NO QIP REDUCTION
      *---------------------------------------------------------------
           ELSE
              COMPUTE LR-BILL-PAY-AMT1 ROUNDED =
                 ((2016-V161-LOW-RHC-LS-RATE * BILL-BENE-WAGE-INDEX)
                 + 2016-V161-LOW-RHC-NLS-RATE) *  LR-BILL-UNITS1
           END-IF.
      
           MOVE 'Y' TO RHC-LOW-DAY-IND.
      
      
       V161-APPLY-LOW-RHC-RATE-EXIT.
           EXIT.
      
      
      
      ****************************************************************
      **** V16.1   CALCULATE RHC HIGH-RATE PAYMENT
      ****************************************************************
       V161-APPLY-HIGH-RHC-RATE.
      
      *---------------------------------------------------------------
      * QIP REDUCTION APPLIED
      *---------------------------------------------------------------
           IF BILL-QIP-IND = '1'
              COMPUTE HR-BILL-PAY-AMT1 ROUNDED =
                 ((2016-V161-HIGH-RHC-LS-RATE-Q * BILL-BENE-WAGE-INDEX)
                 + 2016-V161-HIGH-RHC-NLS-RATE-Q) *  HR-BILL-UNITS1
      
      *---------------------------------------------------------------
      * NO QIP REDUCTION
      *---------------------------------------------------------------
           ELSE
              COMPUTE HR-BILL-PAY-AMT1 ROUNDED =
                 ((2016-V161-HIGH-RHC-LS-RATE * BILL-BENE-WAGE-INDEX)
                 + 2016-V161-HIGH-RHC-NLS-RATE) *  HR-BILL-UNITS1
           END-IF.
      
           MOVE 'Y' TO RHC-HIGH-DAY-IND.
      
      
       V161-APPLY-HIGH-RHC-RATE-EXIT.
           EXIT.
      
      
      
      ****************************************************************
      **** V16.1   CALCULATE END-OF-LIFE SERVICE-INTENSITY ADD-ON
      ****************************************************************
       V161-CALC-RHC-EOL-SIA.
      
      *===============================================================
      *  SET  INDICATOR  [SIA-UNITS-IND = 'Y']
      *  SIA INDICATOR WILL BE USED TO HELP DETERMINE THE CORRECT RTC
      *===============================================================
           IF  BILL-EOL-ADD-ON-DAY1-UNITS > ZEROES OR
               BILL-EOL-ADD-ON-DAY2-UNITS > ZEROES OR
               BILL-EOL-ADD-ON-DAY3-UNITS > ZEROES OR
               BILL-EOL-ADD-ON-DAY4-UNITS > ZEROES OR
               BILL-EOL-ADD-ON-DAY5-UNITS > ZEROES OR
               BILL-EOL-ADD-ON-DAY6-UNITS > ZEROES OR
               BILL-EOL-ADD-ON-DAY7-UNITS > ZEROES
      
               MOVE 'Y' TO SIA-UNITS-IND
           ELSE
               MOVE 'N' TO SIA-UNITS-IND
               GO TO V161-CALC-RHC-EOL-SIA-EXIT
           END-IF.
      
      
      *===============================================================
      *     IF ANY OF THE EOL FIELDS ARE GREATER THAN ZERO
      *     THEN COMPUTE THE >> CHC-WAGE-INDEXED-RATE << FOR
      *     SIA PAYMENT AMOUNT CALCULATION (QIP OR NON-QIP)
      *===============================================================
      
      *---------------------------------------------------------------
      * CALCULATE SIA PAYMENT RATE: HOURLY CHC RATE W/ QIP REDUCTION
      *---------------------------------------------------------------
           IF  BILL-QIP-IND = '1'
               COMPUTE SIA-PYMT-RATE ROUNDED =
                 (((2016-V161-CHC-LS-RATE-Q * BILL-BENE-WAGE-INDEX)
                      + 2016-V161-CHC-NLS-RATE-Q) / 24)
      
      *---------------------------------------------------------------
      * CALCULATE SIA PAYMENT RATE: HOURLY CHC RATE W/OUT QIP REDUCT.
      *---------------------------------------------------------------
           ELSE
               COMPUTE SIA-PYMT-RATE ROUNDED =
                 (((2016-V161-CHC-LS-RATE * BILL-BENE-WAGE-INDEX)
                      + 2016-V161-CHC-NLS-RATE) / 24)
           END-IF.
      
      
      *===============================================================
      *     CALCULATE END OF LIFE SIA PAYMENT FOR UP TO 7 DAYS
      *       - SIA UNITS IN 15 MIN BLOCKS - CONVERT TO HOURS
      *       - SIA PAYMENT AMT IS CAPPED AT 4 HOURS
      *===============================================================
      
      *---------------------------------------------------------------
      * CALCULATE >> DAY 1 EOL SIA PYMT UP TO 4 HRS, 1 UNIT = 15 MIN
      *---------------------------------------------------------------
           IF  BILL-EOL-ADD-ON-DAY1-UNITS > ZEROES
               COMPUTE EOL-UNITS1 = BILL-EOL-ADD-ON-DAY1-UNITS
      
               IF EOL-UNITS1 >= 16
                   MOVE 4 TO EOL-HOURS1
               ELSE
                   COMPUTE EOL-HOURS1 ROUNDED = (EOL-UNITS1 / 4)
               END-IF
      
               COMPUTE BILL-EOL-ADD-ON-DAY1-PAY ROUNDED =
                       EOL-HOURS1 * SIA-PYMT-RATE
      
           END-IF.
      
      
      *---------------------------------------------------------------
      * CALCULATE >> DAY 2 EOL SIA PYMT UP TO 4 HRS, 1 UNIT = 15 MIN
      *---------------------------------------------------------------
           IF  BILL-EOL-ADD-ON-DAY2-UNITS > ZEROES
               COMPUTE EOL-UNITS2 =  BILL-EOL-ADD-ON-DAY2-UNITS
      
               IF EOL-UNITS2 >= 16
                   MOVE 4 TO EOL-HOURS2
               ELSE
                   COMPUTE EOL-HOURS2 ROUNDED = (EOL-UNITS2 / 4)
               END-IF
      
               COMPUTE BILL-EOL-ADD-ON-DAY2-PAY  ROUNDED =
                       EOL-HOURS2 * SIA-PYMT-RATE
           END-IF.
      
      
      *---------------------------------------------------------------
      * CALCULATE >> DAY 3 EOL SIA PYMT UP TO 4 HRS, 1 UNIT = 15 MIN
      *---------------------------------------------------------------
           IF  BILL-EOL-ADD-ON-DAY3-UNITS > ZEROES
               COMPUTE EOL-UNITS3 = BILL-EOL-ADD-ON-DAY3-UNITS
      
               IF EOL-UNITS3 >= 16
                   MOVE 4 TO EOL-HOURS3
               ELSE
                   COMPUTE EOL-HOURS3 ROUNDED = (EOL-UNITS3 / 4)
               END-IF
      
               COMPUTE BILL-EOL-ADD-ON-DAY3-PAY  ROUNDED =
                       EOL-HOURS3 * SIA-PYMT-RATE
           END-IF.
      
      
      *---------------------------------------------------------------
      * CALCULATE >> DAY 4 EOL SIA PYMT UP TO 4 HRS, 1 UNIT = 15 MIN
      *---------------------------------------------------------------
           IF  BILL-EOL-ADD-ON-DAY4-UNITS > ZEROES
               COMPUTE EOL-UNITS4 =  BILL-EOL-ADD-ON-DAY4-UNITS
      
               IF EOL-UNITS4 >= 16
                   MOVE 4 TO EOL-HOURS4
               ELSE
                   COMPUTE EOL-HOURS4 ROUNDED = (EOL-UNITS4 / 4)
               END-IF
      
               COMPUTE BILL-EOL-ADD-ON-DAY4-PAY ROUNDED =
                       EOL-HOURS4 * SIA-PYMT-RATE
           END-IF.
      
      
      *---------------------------------------------------------------
      * CALCULATE >> DAY 5 EOL SIA PYMT UP TO 4 HRS, 1 UNIT = 15 MIN
      *---------------------------------------------------------------
           IF  BILL-EOL-ADD-ON-DAY5-UNITS > ZEROES
               COMPUTE EOL-UNITS5 = BILL-EOL-ADD-ON-DAY5-UNITS
      
               IF EOL-UNITS5 >= 16
                   MOVE 4 TO EOL-HOURS5
               ELSE
                   COMPUTE EOL-HOURS5 ROUNDED = (EOL-UNITS5 / 4)
               END-IF
      
               COMPUTE BILL-EOL-ADD-ON-DAY5-PAY ROUNDED =
                       EOL-HOURS5 * SIA-PYMT-RATE
           END-IF.
      
      
      *---------------------------------------------------------------
      * CALCULATE >> DAY 6 EOL SIA PYMT UP TO 4 HRS, 1 UNIT = 15 MIN
      *---------------------------------------------------------------
           IF  BILL-EOL-ADD-ON-DAY6-UNITS > ZEROES
               COMPUTE EOL-UNITS6 =   BILL-EOL-ADD-ON-DAY6-UNITS
      
               IF EOL-UNITS6 >= 16
                   MOVE 4 TO EOL-HOURS6
               ELSE
                   COMPUTE EOL-HOURS6 ROUNDED = (EOL-UNITS6 / 4)
               END-IF
      
               COMPUTE BILL-EOL-ADD-ON-DAY6-PAY ROUNDED =
                       EOL-HOURS6 * SIA-PYMT-RATE
           END-IF.
      
      
      *---------------------------------------------------------------
      * CALCULATE >> DAY 7 EOL SIA PYMT UP TO 4 HRS, 1 UNIT = 15 MIN
      *---------------------------------------------------------------
           IF  BILL-EOL-ADD-ON-DAY7-UNITS > ZEROES
               COMPUTE EOL-UNITS7 =  BILL-EOL-ADD-ON-DAY7-UNITS
      
               IF EOL-UNITS7 >= 16
                   MOVE 4 TO EOL-HOURS7
               ELSE
                   COMPUTE EOL-HOURS7 ROUNDED = (EOL-UNITS7 / 4)
               END-IF
      
               COMPUTE BILL-EOL-ADD-ON-DAY7-PAY ROUNDED =
                       EOL-HOURS7 * SIA-PYMT-RATE
           END-IF.
      
      
      *---------------------------------------------------------------
      *  CALCULATE >> TOTAL CLAIM EOL SIA ADD-ON PAYMENT
      *---------------------------------------------------------------
           COMPUTE SIA-PAY-AMT-TOTAL =
                   BILL-EOL-ADD-ON-DAY1-PAY +
                   BILL-EOL-ADD-ON-DAY2-PAY +
                   BILL-EOL-ADD-ON-DAY3-PAY +
                   BILL-EOL-ADD-ON-DAY4-PAY +
                   BILL-EOL-ADD-ON-DAY5-PAY +
                   BILL-EOL-ADD-ON-DAY6-PAY +
                   BILL-EOL-ADD-ON-DAY7-PAY.
      
      
       V161-CALC-RHC-EOL-SIA-EXIT.
           EXIT.
      
      
      
      ****************************************************************
      **** V16.1   RHC - SUM RHC '0651' COMPONENTS
      ****************************************************************
       V161-SUM-RHC-0651-RATE.
      
      
      ****============================================================
      **** CALCULATE TOTAL RHC PAYMENT
      ****============================================================
           COMPUTE WRK-PAY-RATE1 =
                   HR-BILL-PAY-AMT1 + LR-BILL-PAY-AMT1.
      
      
      ****============================================================
      **** ASSIGN RHC RETURN CODE (RTC)
      ****============================================================
      
      *---------------------------------------------------------------
      * END-OF-LIFE (EOL) SERVICE INTENSITY (SIA) ADD-ON PRESENT
      *---------------------------------------------------------------
           IF SIA-UNITS-IND = 'Y'
      
      *---------------------------------------------------------------
      *     HIGH RHC RATE (APPLIES TO SOME OR ALL RHC) & EOL SIA
      *---------------------------------------------------------------
              IF RHC-HIGH-DAY-IND = 'Y'
                 MOVE '77' TO BILL-RTC
      
      *---------------------------------------------------------------
      *     LOW RHC RATE APPLIES TO ALL RHC & EOL SIA
      *---------------------------------------------------------------
              ELSE
                 IF RHC-LOW-DAY-IND = 'Y'
                    MOVE '74' TO BILL-RTC
                 END-IF
              END-IF
           END-IF.
      
      
      *---------------------------------------------------------------
      * END-OF-LIFE (EOL) SERVICE INTENSITY ADD-ON (SIA) NOT PRESENT
      *---------------------------------------------------------------
           IF SIA-UNITS-IND = 'N'
      
      *---------------------------------------------------------------
      *     HIGH RHC RATE (APPLIES TO SOME OR ALL RHC) & NO EOL SIA
      *---------------------------------------------------------------
              IF RHC-HIGH-DAY-IND = 'Y'
                 MOVE '75' TO BILL-RTC
      
      *---------------------------------------------------------------
      *     LOW RHC RATE APPLIES TO ALL RHC & NO EOL SIA
      *---------------------------------------------------------------
              ELSE
                 IF RHC-LOW-DAY-IND = 'Y'
                    MOVE '73' TO BILL-RTC
                 END-IF
              END-IF
           END-IF.
      
      
       V161-SUM-RHC-0651-RATE-EXIT.
           EXIT.
      
      
      
      ****************************************************************
      **** V16.1   CHC - CONTINUOUS HOME CARE = REVENUE CODE = 0652
      ****************************************************************
       2016-V161-CHC-0652.
      
      *==================================================
      *  >>> IF REVENUE CODE '0652' UNITS > 0         <<<
      *  >>> [THE DAY IS A CHC LEVEL OF CARE DAY]     <<<
      *  >>> 1 UNIT = 15 MIN.                         <<<
      *==================================================
           IF BILL-UNITS2 NOT > 0
              GO TO 2016-V161-CHC-0652-EXIT
           END-IF.
      
      
      *---------------------------------------------------------------
      * IF USING THE RHC RATE (LESS THAN 32 UNITS/8 HOURS):
      *    CALCULATE NUMBER OF SERVICE DAYS PRIOR TO CHC SERVICE DATE
      *---------------------------------------------------------------
           IF BILL-UNITS2 < 32
              INITIALIZE DATE-CALCULATION-FIELDS
              MOVE BILL-LINE-ITEM-DOS2 TO DATE-2-DOS
              PERFORM V161-CALC-PRIOR-SVC-DAYS
                 THRU V161-CALC-PRIOR-SVC-DAYS-EXIT
           END-IF.
      
      
      ****============================================================
      **** CHC - APPLY QIP REDUCTION
      ****============================================================
           IF BILL-QIP-IND = '1'
      
      *---------------------------------------------------------------
      *  PAY 1 DAY USING THE RHC RATE IF LESS THAN 32 UNITS/8 HOURS
      *---------------------------------------------------------------
              IF BILL-UNITS2 < 32
      
      *---------------------------------------------------------------
      *  - USE HIGH RATE IF CHC DAY IS WITHIN 60 DAYS OF ADMISSION
      *---------------------------------------------------------------
                 IF PRIOR-SVC-DAYS < 60
                    COMPUTE WRK-PAY-RATE2 ROUNDED =
                            ((2016-V161-HIGH-RHC-LS-RATE-Q *
                              BILL-BENE-WAGE-INDEX) +
                              2016-V161-HIGH-RHC-NLS-RATE-Q)
      
      *---------------------------------------------------------------
      *  - USE LOW RATE IF CHC DAY ISN'T WITHIN 60 DAYS OF ADMISSION
      *---------------------------------------------------------------
                 ELSE
                    COMPUTE WRK-PAY-RATE2 ROUNDED =
                            ((2016-V161-LOW-RHC-LS-RATE-Q *
                              BILL-BENE-WAGE-INDEX) +
                              2016-V161-LOW-RHC-NLS-RATE-Q)
                 END-IF
      
      
      *---------------------------------------------------------------
      *  PAY USING CHC RATE FOR 32 OR MORE UNITS (8 - 24 HOURS)
      *      - 1 UNIT = 15 MIN., DIVIDE BY 4 TO GET HOURS
      *      - DIVIDE DAILY CHC RATE BY 24 TO GET HOURLY RATE
      *---------------------------------------------------------------
              ELSE
                 COMPUTE WRK-PAY-RATE2 ROUNDED =
                         (((2016-V161-CHC-LS-RATE-Q *
                            BILL-BENE-WAGE-INDEX) +
                            2016-V161-CHC-NLS-RATE-Q) / 24) *
                            (BILL-UNITS2 / 4)
              END-IF
      
              GO TO 2016-V161-CHC-0652-EXIT
      
           END-IF.
      
      
      ****============================================================
      **** CHC - NO QIP REDUCTION  CODE = 0652
      ****============================================================
           IF BILL-QIP-IND NOT = '1'
      
      *---------------------------------------------------------------
      *    PAY 1 DAY USING THE RHC RATE IF LESS THAN 32 UNITS/8 HOURS
      *---------------------------------------------------------------
              IF BILL-UNITS2 < 32
      
      *---------------------------------------------------------------
      *  - USE HIGH RATE IF CHC DAY IS WITHIN 60 DAYS OF ADMISSION
      *---------------------------------------------------------------
                 IF PRIOR-SVC-DAYS < 60
                    COMPUTE WRK-PAY-RATE2 ROUNDED =
                            ((2016-V161-HIGH-RHC-LS-RATE *
                              BILL-BENE-WAGE-INDEX) +
                              2016-V161-HIGH-RHC-NLS-RATE)
      
      *---------------------------------------------------------------
      *  - USE LOW RATE IF CHC DAY ISN'T WITHIN 60 DAYS OF ADMISSION
      *---------------------------------------------------------------
                 ELSE
                    COMPUTE WRK-PAY-RATE2 ROUNDED =
                            ((2016-V161-LOW-RHC-LS-RATE *
                              BILL-BENE-WAGE-INDEX) +
                              2016-V161-LOW-RHC-NLS-RATE)
                 END-IF
      
      *---------------------------------------------------------------
      *    PAY USING CHC RATE FOR 32 OR MORE UNITS (8 - 24 HOURS)
      *        - 1 UNIT = 15 MIN., DIVIDE BY 4 TO GET HOURS
      *        - DIVIDE DAILY CHC RATE BY 24 TO GET HOURLY RATE
      *---------------------------------------------------------------
              ELSE
                   COMPUTE WRK-PAY-RATE2 ROUNDED =
                           (((2016-V161-CHC-LS-RATE *
                              BILL-BENE-WAGE-INDEX) +
                              2016-V161-CHC-NLS-RATE) / 24) *
                              (BILL-UNITS2 / 4)
              END-IF
           END-IF.
      
      
       2016-V161-CHC-0652-EXIT.
           EXIT.
      
      
      
      ****************************************************************
      **** V16.1 IRC - INPATIENT RESPITE CARE = REVENUE CODE = 0655
      ****************************************************************
       2016-V161-IRC-0655.
      
      ****============================================================
      **** CALCULATE IRC PAYMENT WITH QIP REDUCTION (1 UNIT = 1 DAY)
      ****============================================================
           IF BILL-QIP-IND = '1'
              COMPUTE WRK-PAY-RATE3 ROUNDED =
                     ((2016-V161-IRC-LS-RATE-Q * BILL-PROV-WAGE-INDEX)
                       + 2016-V161-IRC-NLS-RATE-Q) *  BILL-UNITS3
      
      ****============================================================
      **** CALCULATE IRC PAYMENT W/OUT QIP REDUCTION (1 UNIT = 1 DAY)
      ****============================================================
           ELSE
              COMPUTE WRK-PAY-RATE3 ROUNDED =
                     ((2016-V161-IRC-LS-RATE * BILL-PROV-WAGE-INDEX)
                       + 2016-V161-IRC-NLS-RATE) *  BILL-UNITS3
           END-IF.
      
      
       2016-V161-IRC-0655-EXIT.
           EXIT.
      
      
      
      ****************************************************************
      ****    GIC - GENERAL INPATIENT CARE = REVENUE CODE = 0656
      ****************************************************************
       2016-V161-GIC-0656.
      
      ****============================================================
      **** CALCULATE GIC PAYMENT WITH QIP REDUCTION (1 UNIT = 1 DAY)
      ****============================================================
           IF BILL-QIP-IND = '1'
              COMPUTE WRK-PAY-RATE4 ROUNDED =
                     ((2016-V161-GIC-LS-RATE-Q * BILL-PROV-WAGE-INDEX)
                       + 2016-V161-GIC-NLS-RATE-Q) *  BILL-UNITS4
      
      ****============================================================
      **** CALCULATE GIC PAYMENT W/OUT QIP REDUCTION (1 UNIT = 1 DAY)
      ****============================================================
           ELSE
              COMPUTE WRK-PAY-RATE4 ROUNDED =
                     ((2016-V161-GIC-LS-RATE * BILL-PROV-WAGE-INDEX)
                       + 2016-V161-GIC-NLS-RATE) *  BILL-UNITS4
           END-IF.
      
       2016-V161-GIC-0656-EXIT.
           EXIT.
      
      
      
      ****************************************************************
       V161-CALC-PRIOR-SVC-DAYS.
      ****************************************************************
      
      *---------------------------------------------------------------
      * GET ADMISSION DATE (SERVICE DATE SET PRIOR TO THIS PARAGRAPH)
      *---------------------------------------------------------------
           MOVE BILL-ADMISSION-DATE TO DATE-1-ADM.
      
      
      *---------------------------------------------------------------
      * CONVERT ADMISSION AND SERVICE DATES INTO INTEGERS
      *---------------------------------------------------------------
           COMPUTE DATE-1-ADM-INTEGER =
                   FUNCTION INTEGER-OF-DATE (DATE-1-ADM).
      
           COMPUTE DATE-2-DOS-INTEGER =
                   FUNCTION INTEGER-OF-DATE (DATE-2-DOS).
      
      
      *---------------------------------------------------------------
      * CALCULATE DAYS ELAPSED BETWEEN ADMISSION AND SERVICE DATES
      *---------------------------------------------------------------
           COMPUTE DAYS-BETWEEN-DATES =
                   DATE-2-DOS-INTEGER - DATE-1-ADM-INTEGER.
      
      
      *---------------------------------------------------------------
      * DETERMINE THE NUMBER OF PRIOR BENEFIT DAYS
      *---------------------------------------------------------------
           IF BILL-NA-ADD-ON-DAY1-UNITS > ZEROES
               COMPUTE PRIOR-BENEFIT-DAYS = BILL-NA-ADD-ON-DAY1-UNITS
           ELSE
               MOVE ZERO        TO PRIOR-BENEFIT-DAYS
           END-IF.
      
      
      *---------------------------------------------------------------
      * CALCULATE TOTAL DAYS SINCE ADMISSION & BEFORE SERVICE DATE
      *---------------------------------------------------------------
           COMPUTE PRIOR-SVC-DAYS =
                   DAYS-BETWEEN-DATES + PRIOR-BENEFIT-DAYS.
      
      
       V161-CALC-PRIOR-SVC-DAYS-EXIT.
           EXIT.
      
      
      ****==============  BEGIN V170 PROCESS  ====================****
      ****=========  VALID FROM 10/01/16 THRU 09/30/17  ==========****
      ****========================================================****
      
      
      ****************************************************************
      **** V17.0   MAINLINE PROCESS FOR V170
      ****************************************************************
       2017-V170-PROCESS-DATA.
      
      
      *---------------------------------------------------------------
      *  VALIDATE BILL INPUT DATA - UNITS
      *---------------------------------------------------------------
           IF BILL-UNITS1 > 1000 OR
              BILL-UNITS2 > 1000 OR
              BILL-UNITS3 > 1000 OR
              BILL-UNITS4 > 1000
              MOVE '10' TO BILL-RTC
              GO TO 2017-V170-PROCESS-EXIT
           END-IF.
      
      
      *---------------------------------------------------------------
      *  CALCULATE PAYMENT FOR EACH LEVEL OF CARE BY REVENUE CODE
      *---------------------------------------------------------------
           IF BILL-REV1 = '0651'
              PERFORM 2017-V170-RHC-0651
                 THRU 2017-V170-RHC-0651-EXIT.
      
      
           IF BILL-REV2 = '0652'
              PERFORM 2017-V170-CHC-0652
                 THRU 2017-V170-CHC-0652-EXIT.
      
      
           IF BILL-REV3 = '0655'
              PERFORM 2017-V170-IRC-0655
                 THRU 2017-V170-IRC-0655-EXIT.
      
      
           IF BILL-REV4 = '0656'
              PERFORM 2017-V170-GIC-0656
                 THRU 2017-V170-GIC-0656-EXIT.
      
      
      *---------------------------------------------------------------
      *  CALCULATE TOTAL CLAIM PAYMENT
      *---------------------------------------------------------------
           COMPUTE BILL-PAY-AMT-TOTAL =
                   WRK-PAY-RATE1 +
                   WRK-PAY-RATE2 +
                   WRK-PAY-RATE3 +
                   WRK-PAY-RATE4 +
                   SIA-PAY-AMT-TOTAL.
      
      
      *---------------------------------------------------------------
      *  MOVE EACH LEVEL OF CARE'S PAYMENT TO THE OUTPUT RECORD
      *---------------------------------------------------------------
           MOVE WRK-PAY-RATE1        TO  BILL-PAY-AMT1.
           MOVE WRK-PAY-RATE2        TO  BILL-PAY-AMT2.
           MOVE WRK-PAY-RATE3        TO  BILL-PAY-AMT3.
           MOVE WRK-PAY-RATE4        TO  BILL-PAY-AMT4.
      
      
      *---------------------------------------------------------------
      *  INITIALIZE WORKING STORAGE PAYMENT VARIABLES
      *---------------------------------------------------------------
           MOVE ZEROES               TO WRK-PAY-RATE1
                                        WRK-PAY-RATE2
                                        WRK-PAY-RATE3
                                        WRK-PAY-RATE4.
      
       2017-V170-PROCESS-EXIT.
           EXIT.
      
      
      
      ****************************************************************
      **** V17.0   RHC - ROUTINE HOME CARE = REVENUE CODE = 0651
      ****************************************************************
       2017-V170-RHC-0651.
      
      
      *==================================================
      *  >>> IF REVENUE CODE '0651' UNITS > 0         <<<
      *  >>> [THE DAY IS AN RHC LEVEL OF CARE DAY]    <<<
      *  >>> 1 UNIT = 1 DAY                           <<<
      *==================================================
           IF BILL-UNITS1 NOT > 0
              GO TO 2017-V170-RHC-0651-EXIT
           END-IF.
      
      
      *---------------------------------------------------------------
      * DATE ERROR - CANNOT CONTINUE RHC LEVEL OF CARE DAY PROCESSING
      *---------------------------------------------------------------
           IF BILL-LINE-ITEM-DOS1 < BILL-ADMISSION-DATE
              GO TO 2017-V170-RHC-0651-EXIT
           END-IF.
      
      
      *---------------------------------------------------------------
      * CALCULATE RHC LEVEL OF CARE DAY PAYMENT
      *---------------------------------------------------------------
      
           MOVE BILL-LINE-ITEM-DOS1 TO DATE-2-DOS.
           PERFORM V170-CALC-PRIOR-SVC-DAYS
              THRU V170-CALC-PRIOR-SVC-DAYS-EXIT.
      
           PERFORM V170-EVAL-RHC-DAYS
              THRU V170-EVAL-RHC-DAYS-EXIT.
      
           PERFORM V170-CALC-RHC-EOL-SIA
              THRU V170-CALC-RHC-EOL-SIA-EXIT.
      
           PERFORM V170-SUM-RHC-0651-RATE
              THRU V170-SUM-RHC-0651-RATE-EXIT.
      
      
       2017-V170-RHC-0651-EXIT.
           EXIT.
      
      
      
      ****************************************************************
       V170-EVAL-RHC-DAYS.
      ****************************************************************
      
      *---------------------------------------------------------------
      * SERVICE BEYOND 60TH DAY - APPLY RHC LOW RATE TO ALL RHC DAYS
      *---------------------------------------------------------------
           IF PRIOR-SVC-DAYS >= 60
              MOVE BILL-UNITS1 TO LR-BILL-UNITS1
              PERFORM V170-APPLY-LOW-RHC-RATE
                 THRU V170-APPLY-LOW-RHC-RATE-EXIT
              GO TO V170-EVAL-RHC-DAYS-EXIT
           END-IF.
      
      
      *---------------------------------------------------------------
      * SERVICE ON 60TH DAY OR EARLIER - APPLY RHC HIGH/LOW RATES
      *---------------------------------------------------------------
           IF PRIOR-SVC-DAYS < 60
              COMPUTE HIGH-RATE-DAYS-LEFT = 60 - PRIOR-SVC-DAYS
      
      
      *---------------------------------------------------------------
      * - RHC DAYS <= HIGH RATE DAYS LEFT - APPLY RHC HIGH RATE TO ALL
      *---------------------------------------------------------------
              IF BILL-UNITS1 <= HIGH-RATE-DAYS-LEFT
                 MOVE BILL-UNITS1 TO HR-BILL-UNITS1
                 PERFORM V170-APPLY-HIGH-RHC-RATE
                    THRU V170-APPLY-HIGH-RHC-RATE-EXIT
                 GO TO V170-EVAL-RHC-DAYS-EXIT
      
      
      *---------------------------------------------------------------
      * - RHC DAYS > HIGH RATE DAYS LEFT - APPLY RHC HIGH & LOW RATES
      *---------------------------------------------------------------
              ELSE
      
                 MOVE HIGH-RATE-DAYS-LEFT TO HR-BILL-UNITS1
                 PERFORM V170-APPLY-HIGH-RHC-RATE
                    THRU V170-APPLY-HIGH-RHC-RATE-EXIT
      
                 COMPUTE LR-BILL-UNITS1 =
                         BILL-UNITS1 - HR-BILL-UNITS1
                 PERFORM V170-APPLY-LOW-RHC-RATE
                    THRU V170-APPLY-LOW-RHC-RATE-EXIT
      
              END-IF
           END-IF.
      
      
       V170-EVAL-RHC-DAYS-EXIT.
           EXIT.
      
      
      
      ****************************************************************
      **** V17.0   CALCULATE RHC LOW-RATE PAYMENT
      ****************************************************************
       V170-APPLY-LOW-RHC-RATE.
      
      *---------------------------------------------------------------
      * QIP REDUCTION APPLIED
      *---------------------------------------------------------------
           IF BILL-QIP-IND = '1'
              COMPUTE LR-BILL-PAY-AMT1 ROUNDED =
                 ((2017-V170-LOW-RHC-LS-RATE-Q * BILL-BENE-WAGE-INDEX)
                 + 2017-V170-LOW-RHC-NLS-RATE-Q) *  LR-BILL-UNITS1
      
      *---------------------------------------------------------------
      * NO QIP REDUCTION
      *---------------------------------------------------------------
           ELSE
              COMPUTE LR-BILL-PAY-AMT1 ROUNDED =
                 ((2017-V170-LOW-RHC-LS-RATE * BILL-BENE-WAGE-INDEX)
                 + 2017-V170-LOW-RHC-NLS-RATE) *  LR-BILL-UNITS1
           END-IF.
      
           MOVE 'Y' TO RHC-LOW-DAY-IND.
      
      
       V170-APPLY-LOW-RHC-RATE-EXIT.
           EXIT.
      
      
      
      ****************************************************************
      **** V17.0   CALCULATE RHC HIGH-RATE PAYMENT
      ****************************************************************
       V170-APPLY-HIGH-RHC-RATE.
      
      *---------------------------------------------------------------
      * QIP REDUCTION APPLIED
      *---------------------------------------------------------------
           IF BILL-QIP-IND = '1'
              COMPUTE HR-BILL-PAY-AMT1 ROUNDED =
                 ((2017-V170-HIGH-RHC-LS-RATE-Q * BILL-BENE-WAGE-INDEX)
                 + 2017-V170-HIGH-RHC-NLS-RATE-Q) *  HR-BILL-UNITS1
      
      *---------------------------------------------------------------
      * NO QIP REDUCTION
      *---------------------------------------------------------------
           ELSE
              COMPUTE HR-BILL-PAY-AMT1 ROUNDED =
                 ((2017-V170-HIGH-RHC-LS-RATE * BILL-BENE-WAGE-INDEX)
                 + 2017-V170-HIGH-RHC-NLS-RATE) *  HR-BILL-UNITS1
           END-IF.
      
           MOVE 'Y' TO RHC-HIGH-DAY-IND.
      
      
       V170-APPLY-HIGH-RHC-RATE-EXIT.
           EXIT.
      
      
      
      ****************************************************************
      **** V17.0   CALCULATE END-OF-LIFE SERVICE-INTENSITY ADD-ON
      ****************************************************************
       V170-CALC-RHC-EOL-SIA.
      
      *===============================================================
      *  SET  INDICATOR  [SIA-UNITS-IND = 'Y']
      *  SIA INDICATOR WILL BE USED TO HELP DETERMINE THE CORRECT RTC
      *===============================================================
           IF  BILL-EOL-ADD-ON-DAY1-UNITS > ZEROES OR
               BILL-EOL-ADD-ON-DAY2-UNITS > ZEROES OR
               BILL-EOL-ADD-ON-DAY3-UNITS > ZEROES OR
               BILL-EOL-ADD-ON-DAY4-UNITS > ZEROES OR
               BILL-EOL-ADD-ON-DAY5-UNITS > ZEROES OR
               BILL-EOL-ADD-ON-DAY6-UNITS > ZEROES OR
               BILL-EOL-ADD-ON-DAY7-UNITS > ZEROES
      
               MOVE 'Y' TO SIA-UNITS-IND
           ELSE
               MOVE 'N' TO SIA-UNITS-IND
               GO TO V170-CALC-RHC-EOL-SIA-EXIT
           END-IF.
      
      
      *===============================================================
      *     IF ANY OF THE EOL FIELDS ARE GREATER THAN ZERO
      *     THEN COMPUTE THE >> CHC-WAGE-INDEXED-RATE << FOR
      *     SIA PAYMENT AMOUNT CALCULATION (QIP OR NON-QIP)
      *===============================================================
      
      *---------------------------------------------------------------
      * CALCULATE SIA PAYMENT RATE: HOURLY CHC RATE W/ QIP REDUCTION
      *---------------------------------------------------------------
           IF  BILL-QIP-IND = '1'
               COMPUTE SIA-PYMT-RATE ROUNDED =
                 (((2017-V170-CHC-LS-RATE-Q * BILL-BENE-WAGE-INDEX)
                      + 2017-V170-CHC-NLS-RATE-Q) / 24)
      
      *---------------------------------------------------------------
      * CALCULATE SIA PAYMENT RATE: HOURLY CHC RATE W/OUT QIP REDUCT.
      *---------------------------------------------------------------
           ELSE
               COMPUTE SIA-PYMT-RATE ROUNDED =
                 (((2017-V170-CHC-LS-RATE * BILL-BENE-WAGE-INDEX)
                      + 2017-V170-CHC-NLS-RATE) / 24)
           END-IF.
      
      
      *===============================================================
      *     CALCULATE END OF LIFE SIA PAYMENT FOR UP TO 7 DAYS
      *       - SIA UNITS IN 15 MIN BLOCKS - CONVERT TO HOURS
      *       - SIA PAYMENT AMT IS CAPPED AT 4 HOURS
      *===============================================================
      
      *---------------------------------------------------------------
      * CALCULATE >> DAY 1 EOL SIA PYMT UP TO 4 HRS, 1 UNIT = 15 MIN
      *---------------------------------------------------------------
           IF  BILL-EOL-ADD-ON-DAY1-UNITS > ZEROES
               COMPUTE EOL-UNITS1 = BILL-EOL-ADD-ON-DAY1-UNITS
      
               IF EOL-UNITS1 >= 16
                   MOVE 4 TO EOL-HOURS1
               ELSE
                   COMPUTE EOL-HOURS1 ROUNDED = (EOL-UNITS1 / 4)
               END-IF
      
               COMPUTE BILL-EOL-ADD-ON-DAY1-PAY ROUNDED =
                       EOL-HOURS1 * SIA-PYMT-RATE
      
           END-IF.
      
      
      *---------------------------------------------------------------
      * CALCULATE >> DAY 2 EOL SIA PYMT UP TO 4 HRS, 1 UNIT = 15 MIN
      *---------------------------------------------------------------
           IF  BILL-EOL-ADD-ON-DAY2-UNITS > ZEROES
               COMPUTE EOL-UNITS2 = BILL-EOL-ADD-ON-DAY2-UNITS
      
               IF EOL-UNITS2 >= 16
                   MOVE 4 TO EOL-HOURS2
               ELSE
                   COMPUTE EOL-HOURS2 ROUNDED = (EOL-UNITS2 / 4)
               END-IF
      
               COMPUTE BILL-EOL-ADD-ON-DAY2-PAY  ROUNDED =
                       EOL-HOURS2 * SIA-PYMT-RATE
           END-IF.
      
      
      *---------------------------------------------------------------
      * CALCULATE >> DAY 3 EOL SIA PYMT UP TO 4 HRS, 1 UNIT = 15 MIN
      *---------------------------------------------------------------
           IF  BILL-EOL-ADD-ON-DAY3-UNITS > ZEROES
               COMPUTE EOL-UNITS3 = BILL-EOL-ADD-ON-DAY3-UNITS
      
               IF EOL-UNITS3 >= 16
                   MOVE 4 TO EOL-HOURS3
               ELSE
                   COMPUTE EOL-HOURS3 ROUNDED = (EOL-UNITS3 / 4)
               END-IF
      
               COMPUTE BILL-EOL-ADD-ON-DAY3-PAY  ROUNDED =
                       EOL-HOURS3 * SIA-PYMT-RATE
           END-IF.
      
      
      *---------------------------------------------------------------
      * CALCULATE >> DAY 4 EOL SIA PYMT UP TO 4 HRS, 1 UNIT = 15 MIN
      *---------------------------------------------------------------
           IF  BILL-EOL-ADD-ON-DAY4-UNITS > ZEROES
               COMPUTE EOL-UNITS4 = BILL-EOL-ADD-ON-DAY4-UNITS
      
               IF EOL-UNITS4 >= 16
                   MOVE 4 TO EOL-HOURS4
               ELSE
                   COMPUTE EOL-HOURS4 ROUNDED = (EOL-UNITS4 / 4)
               END-IF
      
               COMPUTE BILL-EOL-ADD-ON-DAY4-PAY ROUNDED =
                       EOL-HOURS4 * SIA-PYMT-RATE
           END-IF.
      
      
      *---------------------------------------------------------------
      * CALCULATE >> DAY 5 EOL SIA PYMT UP TO 4 HRS, 1 UNIT = 15 MIN
      *---------------------------------------------------------------
           IF  BILL-EOL-ADD-ON-DAY5-UNITS > ZEROES
               COMPUTE EOL-UNITS5 = BILL-EOL-ADD-ON-DAY5-UNITS
      
               IF EOL-UNITS5 >= 16
                   MOVE 4 TO EOL-HOURS5
               ELSE
                   COMPUTE EOL-HOURS5 ROUNDED = (EOL-UNITS5 / 4)
               END-IF
      
               COMPUTE BILL-EOL-ADD-ON-DAY5-PAY ROUNDED =
                       EOL-HOURS5 * SIA-PYMT-RATE
           END-IF.
      
      
      *---------------------------------------------------------------
      * CALCULATE >> DAY 6 EOL SIA PYMT UP TO 4 HRS, 1 UNIT = 15 MIN
      *---------------------------------------------------------------
           IF  BILL-EOL-ADD-ON-DAY6-UNITS > ZEROES
               COMPUTE EOL-UNITS6 = BILL-EOL-ADD-ON-DAY6-UNITS
      
               IF EOL-UNITS6 >= 16
                   MOVE 4 TO EOL-HOURS6
               ELSE
                   COMPUTE EOL-HOURS6 ROUNDED = (EOL-UNITS6 / 4)
               END-IF
      
               COMPUTE BILL-EOL-ADD-ON-DAY6-PAY ROUNDED =
                       EOL-HOURS6 * SIA-PYMT-RATE
           END-IF.
      
      
      *---------------------------------------------------------------
      * CALCULATE >> DAY 7 EOL SIA PYMT UP TO 4 HRS, 1 UNIT = 15 MIN
      *---------------------------------------------------------------
           IF  BILL-EOL-ADD-ON-DAY7-UNITS > ZEROES
               COMPUTE EOL-UNITS7 = BILL-EOL-ADD-ON-DAY7-UNITS
      
               IF EOL-UNITS7 >= 16
                   MOVE 4 TO EOL-HOURS7
               ELSE
                   COMPUTE EOL-HOURS7 ROUNDED = (EOL-UNITS7 / 4)
               END-IF
      
               COMPUTE BILL-EOL-ADD-ON-DAY7-PAY ROUNDED =
                       EOL-HOURS7 * SIA-PYMT-RATE
           END-IF.
      
      
      *---------------------------------------------------------------
      *  CALCULATE >> TOTAL CLAIM EOL SIA ADD-ON PAYMENT
      *---------------------------------------------------------------
           COMPUTE SIA-PAY-AMT-TOTAL =
                   BILL-EOL-ADD-ON-DAY1-PAY +
                   BILL-EOL-ADD-ON-DAY2-PAY +
                   BILL-EOL-ADD-ON-DAY3-PAY +
                   BILL-EOL-ADD-ON-DAY4-PAY +
                   BILL-EOL-ADD-ON-DAY5-PAY +
                   BILL-EOL-ADD-ON-DAY6-PAY +
                   BILL-EOL-ADD-ON-DAY7-PAY.
      
      
       V170-CALC-RHC-EOL-SIA-EXIT.
           EXIT.
      
      
      
      ****************************************************************
      **** V17.0   RHC - SUM RHC '0651' COMPONENTS
      ****************************************************************
       V170-SUM-RHC-0651-RATE.
      
      
      ****============================================================
      **** CALCULATE TOTAL RHC PAYMENT
      ****============================================================
           COMPUTE WRK-PAY-RATE1 =
                   HR-BILL-PAY-AMT1 + LR-BILL-PAY-AMT1.
      
      
      ****============================================================
      **** ASSIGN RHC RETURN CODE (RTC)
      ****============================================================
      
      *---------------------------------------------------------------
      * END-OF-LIFE (EOL) SERVICE INTENSITY (SIA) ADD-ON PRESENT
      *---------------------------------------------------------------
           IF SIA-UNITS-IND = 'Y'
      
      *---------------------------------------------------------------
      *     HIGH RHC RATE (APPLIES TO SOME OR ALL RHC) & EOL SIA
      *---------------------------------------------------------------
              IF RHC-HIGH-DAY-IND = 'Y'
                 MOVE '77' TO BILL-RTC
      
      *---------------------------------------------------------------
      *     LOW RHC RATE APPLIES TO ALL RHC & EOL SIA
      *---------------------------------------------------------------
              ELSE
                 IF RHC-LOW-DAY-IND = 'Y'
                    MOVE '74' TO BILL-RTC
                 END-IF
              END-IF
           END-IF.
      
      
      *---------------------------------------------------------------
      * END-OF-LIFE (EOL) SERVICE INTENSITY ADD-ON (SIA) NOT PRESENT
      *---------------------------------------------------------------
           IF SIA-UNITS-IND = 'N'
      
      *---------------------------------------------------------------
      *     HIGH RHC RATE (APPLIES TO SOME OR ALL RHC) & NO EOL SIA
      *---------------------------------------------------------------
              IF RHC-HIGH-DAY-IND = 'Y'
                 MOVE '75' TO BILL-RTC
      
      *---------------------------------------------------------------
      *     LOW RHC RATE APPLIES TO ALL RHC & NO EOL SIA
      *---------------------------------------------------------------
              ELSE
                 IF RHC-LOW-DAY-IND = 'Y'
                    MOVE '73' TO BILL-RTC
                 END-IF
              END-IF
           END-IF.
      
      
       V170-SUM-RHC-0651-RATE-EXIT.
           EXIT.
      
      
      
      ****************************************************************
      **** V17.0   CHC - CONTINUOUS HOME CARE = REVENUE CODE = 0652
      ****************************************************************
       2017-V170-CHC-0652.
      
      *==================================================
      *  >>> IF REVENUE CODE '0652' UNITS > 0         <<<
      *  >>> [THE DAY IS A CHC LEVEL OF CARE DAY]     <<<
      *  >>> 1 UNIT = 15 MIN.                         <<<
      *==================================================
           IF BILL-UNITS2 NOT > 0
              GO TO 2017-V170-CHC-0652-EXIT
           END-IF.
      
      
      *---------------------------------------------------------------
      * IF USING THE RHC RATE (LESS THAN 32 UNITS/8 HOURS):
      *    CALCULATE NUMBER OF SERVICE DAYS PRIOR TO CHC SERVICE DATE
      *---------------------------------------------------------------
           IF BILL-UNITS2 < 32
              INITIALIZE DATE-CALCULATION-FIELDS
              MOVE BILL-LINE-ITEM-DOS2 TO DATE-2-DOS
              PERFORM V170-CALC-PRIOR-SVC-DAYS
                 THRU V170-CALC-PRIOR-SVC-DAYS-EXIT
           END-IF.
      
      
      ****============================================================
      **** CHC - APPLY QIP REDUCTION
      ****============================================================
           IF BILL-QIP-IND = '1'
      
      *---------------------------------------------------------------
      *  PAY 1 DAY USING THE RHC RATE IF LESS THAN 32 UNITS/8 HOURS
      *---------------------------------------------------------------
              IF BILL-UNITS2 < 32
      
      *---------------------------------------------------------------
      *  - USE HIGH RATE IF CHC DAY IS WITHIN 60 DAYS OF ADMISSION
      *---------------------------------------------------------------
                 IF PRIOR-SVC-DAYS < 60
                    COMPUTE WRK-PAY-RATE2 ROUNDED =
                            ((2017-V170-HIGH-RHC-LS-RATE-Q *
                              BILL-BENE-WAGE-INDEX) +
                              2017-V170-HIGH-RHC-NLS-RATE-Q)
      
      *---------------------------------------------------------------
      *  - USE LOW RATE IF CHC DAY ISN'T WITHIN 60 DAYS OF ADMISSION
      *---------------------------------------------------------------
                 ELSE
                    COMPUTE WRK-PAY-RATE2 ROUNDED =
                            ((2017-V170-LOW-RHC-LS-RATE-Q *
                              BILL-BENE-WAGE-INDEX) +
                              2017-V170-LOW-RHC-NLS-RATE-Q)
                 END-IF
      
      
      *---------------------------------------------------------------
      *  PAY USING CHC RATE FOR 32 OR MORE UNITS (8 - 24 HOURS)
      *      - 1 UNIT = 15 MIN., DIVIDE BY 4 TO GET HOURS
      *      - DIVIDE DAILY CHC RATE BY 24 TO GET HOURLY RATE
      *---------------------------------------------------------------
              ELSE
                 COMPUTE WRK-PAY-RATE2 ROUNDED =
                         (((2017-V170-CHC-LS-RATE-Q *
                            BILL-BENE-WAGE-INDEX) +
                            2017-V170-CHC-NLS-RATE-Q) / 24) *
                            (BILL-UNITS2 / 4)
              END-IF
      
              GO TO 2017-V170-CHC-0652-EXIT
      
           END-IF.
      
      
      ****============================================================
      **** CHC - NO QIP REDUCTION  CODE = 0652
      ****============================================================
           IF BILL-QIP-IND NOT = '1'
      
      *---------------------------------------------------------------
      *    PAY 1 DAY USING THE RHC RATE IF LESS THAN 32 UNITS/8 HOURS
      *---------------------------------------------------------------
              IF BILL-UNITS2 < 32
      
      *---------------------------------------------------------------
      *  - USE HIGH RATE IF CHC DAY IS WITHIN 60 DAYS OF ADMISSION
      *---------------------------------------------------------------
                 IF PRIOR-SVC-DAYS < 60
                    COMPUTE WRK-PAY-RATE2 ROUNDED =
                            ((2017-V170-HIGH-RHC-LS-RATE *
                              BILL-BENE-WAGE-INDEX) +
                              2017-V170-HIGH-RHC-NLS-RATE)
      
      *---------------------------------------------------------------
      *  - USE LOW RATE IF CHC DAY ISN'T WITHIN 60 DAYS OF ADMISSION
      *---------------------------------------------------------------
                 ELSE
                    COMPUTE WRK-PAY-RATE2 ROUNDED =
                            ((2017-V170-LOW-RHC-LS-RATE *
                              BILL-BENE-WAGE-INDEX) +
                              2017-V170-LOW-RHC-NLS-RATE)
                 END-IF
      
      *---------------------------------------------------------------
      *    PAY USING CHC RATE FOR 32 OR MORE UNITS (8 - 24 HOURS)
      *        - 1 UNIT = 15 MIN., DIVIDE BY 4 TO GET HOURS
      *        - DIVIDE DAILY CHC RATE BY 24 TO GET HOURLY RATE
      *---------------------------------------------------------------
              ELSE
                   COMPUTE WRK-PAY-RATE2 ROUNDED =
                           (((2017-V170-CHC-LS-RATE *
                              BILL-BENE-WAGE-INDEX) +
                              2017-V170-CHC-NLS-RATE) / 24) *
                              (BILL-UNITS2 / 4)
              END-IF
           END-IF.
      
      
       2017-V170-CHC-0652-EXIT.
           EXIT.
      
      
      
      ****************************************************************
      **** V17.0 IRC - INPATIENT RESPITE CARE = REVENUE CODE = 0655
      ****************************************************************
       2017-V170-IRC-0655.
      
      ****============================================================
      **** CALCULATE IRC PAYMENT WITH QIP REDUCTION (1 UNIT = 1 DAY)
      ****============================================================
           IF BILL-QIP-IND = '1'
              COMPUTE WRK-PAY-RATE3 ROUNDED =
                     ((2017-V170-IRC-LS-RATE-Q * BILL-PROV-WAGE-INDEX)
                       + 2017-V170-IRC-NLS-RATE-Q) *  BILL-UNITS3
      
      ****============================================================
      **** CALCULATE IRC PAYMENT W/OUT QIP REDUCTION (1 UNIT = 1 DAY)
      ****============================================================
           ELSE
              COMPUTE WRK-PAY-RATE3 ROUNDED =
                     ((2017-V170-IRC-LS-RATE * BILL-PROV-WAGE-INDEX)
                       + 2017-V170-IRC-NLS-RATE) *  BILL-UNITS3
           END-IF.
      
      
       2017-V170-IRC-0655-EXIT.
           EXIT.
      
      
      
      ****************************************************************
      ****    GIC - GENERAL INPATIENT CARE = REVENUE CODE = 0656
      ****************************************************************
       2017-V170-GIC-0656.
      
      ****============================================================
      **** CALCULATE GIC PAYMENT WITH QIP REDUCTION (1 UNIT = 1 DAY)
      ****============================================================
           IF BILL-QIP-IND = '1'
              COMPUTE WRK-PAY-RATE4 ROUNDED =
                     ((2017-V170-GIC-LS-RATE-Q * BILL-PROV-WAGE-INDEX)
                       + 2017-V170-GIC-NLS-RATE-Q) *  BILL-UNITS4
      
      ****============================================================
      **** CALCULATE GIC PAYMENT W/OUT QIP REDUCTION (1 UNIT = 1 DAY)
      ****============================================================
           ELSE
              COMPUTE WRK-PAY-RATE4 ROUNDED =
                     ((2017-V170-GIC-LS-RATE * BILL-PROV-WAGE-INDEX)
                       + 2017-V170-GIC-NLS-RATE) *  BILL-UNITS4
           END-IF.
      
       2017-V170-GIC-0656-EXIT.
           EXIT.
      
      
      
      ****************************************************************
       V170-CALC-PRIOR-SVC-DAYS.
      ****************************************************************
      
      *---------------------------------------------------------------
      * GET ADMISSION DATE (SERVICE DATE SET PRIOR TO THIS PARAGRAPH)
      *---------------------------------------------------------------
           MOVE BILL-ADMISSION-DATE TO DATE-1-ADM.
      
      
      *---------------------------------------------------------------
      * CONVERT ADMISSION AND SERVICE DATES INTO INTEGERS
      *---------------------------------------------------------------
           COMPUTE DATE-1-ADM-INTEGER =
                   FUNCTION INTEGER-OF-DATE (DATE-1-ADM).
      
           COMPUTE DATE-2-DOS-INTEGER =
                   FUNCTION INTEGER-OF-DATE (DATE-2-DOS).
      
      
      *---------------------------------------------------------------
      * CALCULATE DAYS ELAPSED BETWEEN ADMISSION AND SERVICE DATES
      *---------------------------------------------------------------
           COMPUTE DAYS-BETWEEN-DATES =
                   DATE-2-DOS-INTEGER - DATE-1-ADM-INTEGER.
      
      
      *---------------------------------------------------------------
      * DETERMINE THE NUMBER OF PRIOR BENEFIT DAYS
      *---------------------------------------------------------------
           IF BILL-NA-ADD-ON-DAY1-UNITS > ZEROES
               COMPUTE PRIOR-BENEFIT-DAYS = BILL-NA-ADD-ON-DAY1-UNITS
           ELSE
               MOVE ZERO TO PRIOR-BENEFIT-DAYS
           END-IF.
      
      
      *---------------------------------------------------------------
      * CALCULATE TOTAL DAYS SINCE ADMISSION & BEFORE SERVICE DATE
      *---------------------------------------------------------------
           COMPUTE PRIOR-SVC-DAYS =
                   DAYS-BETWEEN-DATES + PRIOR-BENEFIT-DAYS.
      
      
       V170-CALC-PRIOR-SVC-DAYS-EXIT.
           EXIT.
      
      
      
      
      ****==============  BEGIN V180 PROCESS  ====================****
      ****=========  VALID FROM 10/01/17 THRU 09/30/18  ==========****
      ****========================================================****
      
      
      ****************************************************************
      **** V18.0   MAINLINE PROCESS FOR V180
      ****************************************************************
       2018-V180-PROCESS-DATA.
      
      
      *---------------------------------------------------------------
      *  VALIDATE BILL INPUT DATA - UNITS
      *---------------------------------------------------------------
           IF BILL-UNITS1 > 1000 OR
              BILL-UNITS2 > 1000 OR
              BILL-UNITS3 > 1000 OR
              BILL-UNITS4 > 1000
              MOVE '10' TO BILL-RTC
              GO TO 2018-V180-PROCESS-EXIT
           END-IF.
      
      
      *---------------------------------------------------------------
      *  CALCULATE PAYMENT FOR EACH LEVEL OF CARE BY REVENUE CODE
      *---------------------------------------------------------------
           IF BILL-REV1 = '0651'
              PERFORM 2018-V180-RHC-0651
                 THRU 2018-V180-RHC-0651-EXIT.
      
      
           IF BILL-REV2 = '0652'
              PERFORM 2018-V180-CHC-0652
                 THRU 2018-V180-CHC-0652-EXIT.
      
      
           IF BILL-REV3 = '0655'
              PERFORM 2018-V180-IRC-0655
                 THRU 2018-V180-IRC-0655-EXIT.
      
      
           IF BILL-REV4 = '0656'
              PERFORM 2018-V180-GIC-0656
                 THRU 2018-V180-GIC-0656-EXIT.
      
      
      *---------------------------------------------------------------
      *  CALCULATE TOTAL CLAIM PAYMENT
      *---------------------------------------------------------------
           COMPUTE BILL-PAY-AMT-TOTAL =
                   WRK-PAY-RATE1 +
                   WRK-PAY-RATE2 +
                   WRK-PAY-RATE3 +
                   WRK-PAY-RATE4 +
                   SIA-PAY-AMT-TOTAL.
      
      
      *---------------------------------------------------------------
      *  MOVE EACH LEVEL OF CARE'S PAYMENT TO THE OUTPUT RECORD
      *---------------------------------------------------------------
           MOVE WRK-PAY-RATE1        TO  BILL-PAY-AMT1.
           MOVE WRK-PAY-RATE2        TO  BILL-PAY-AMT2.
           MOVE WRK-PAY-RATE3        TO  BILL-PAY-AMT3.
           MOVE WRK-PAY-RATE4        TO  BILL-PAY-AMT4.
      
      
      *---------------------------------------------------------------
      *  INITIALIZE WORKING STORAGE PAYMENT VARIABLES
      *---------------------------------------------------------------
           MOVE ZEROES               TO WRK-PAY-RATE1
                                        WRK-PAY-RATE2
                                        WRK-PAY-RATE3
                                        WRK-PAY-RATE4.
      
       2018-V180-PROCESS-EXIT.
           EXIT.
      
      
      
      ****************************************************************
      **** V18.0   RHC - ROUTINE HOME CARE = REVENUE CODE = 0651
      ****************************************************************
       2018-V180-RHC-0651.
      
      
      *==================================================
      *  >>> IF REVENUE CODE '0651' UNITS > 0         <<<
      *  >>> [THE DAY IS AN RHC LEVEL OF CARE DAY]    <<<
      *  >>> 1 UNIT = 1 DAY                           <<<
      *==================================================
           IF BILL-UNITS1 NOT > 0
              GO TO 2018-V180-RHC-0651-EXIT
           END-IF.
      
      
      *---------------------------------------------------------------
      * DATE ERROR - CANNOT CONTINUE RHC LEVEL OF CARE DAY PROCESSING
      *---------------------------------------------------------------
           IF BILL-LINE-ITEM-DOS1 < BILL-ADMISSION-DATE
              GO TO 2018-V180-RHC-0651-EXIT
           END-IF.
      
      
      *---------------------------------------------------------------
      * CALCULATE RHC LEVEL OF CARE DAY PAYMENT
      *---------------------------------------------------------------
      
           MOVE BILL-LINE-ITEM-DOS1 TO DATE-2-DOS.
           PERFORM V180-CALC-PRIOR-SVC-DAYS
              THRU V180-CALC-PRIOR-SVC-DAYS-EXIT.
      
           PERFORM V180-EVAL-RHC-DAYS
              THRU V180-EVAL-RHC-DAYS-EXIT.
      
           PERFORM V180-CALC-RHC-EOL-SIA
              THRU V180-CALC-RHC-EOL-SIA-EXIT.
      
           PERFORM V180-SUM-RHC-0651-RATE
              THRU V180-SUM-RHC-0651-RATE-EXIT.
      
      
       2018-V180-RHC-0651-EXIT.
           EXIT.
      
      
      
      ****************************************************************
       V180-EVAL-RHC-DAYS.
      ****************************************************************
      
      *---------------------------------------------------------------
      * SERVICE BEYOND 60TH DAY - APPLY RHC LOW RATE TO ALL RHC DAYS
      *---------------------------------------------------------------
           IF PRIOR-SVC-DAYS >= 60
              MOVE BILL-UNITS1 TO LR-BILL-UNITS1
              PERFORM V180-APPLY-LOW-RHC-RATE
                 THRU V180-APPLY-LOW-RHC-RATE-EXIT
              GO TO V180-EVAL-RHC-DAYS-EXIT
           END-IF.
      
      
      *---------------------------------------------------------------
      * SERVICE ON 60TH DAY OR EARLIER - APPLY RHC HIGH/LOW RATES
      *---------------------------------------------------------------
           IF PRIOR-SVC-DAYS < 60
              COMPUTE HIGH-RATE-DAYS-LEFT = 60 - PRIOR-SVC-DAYS
      
      
      *---------------------------------------------------------------
      * - RHC DAYS <= HIGH RATE DAYS LEFT - APPLY RHC HIGH RATE TO ALL
      *---------------------------------------------------------------
              IF BILL-UNITS1 <= HIGH-RATE-DAYS-LEFT
                 MOVE BILL-UNITS1 TO HR-BILL-UNITS1
                 PERFORM V180-APPLY-HIGH-RHC-RATE
                    THRU V180-APPLY-HIGH-RHC-RATE-EXIT
                 GO TO V180-EVAL-RHC-DAYS-EXIT
      
      
      *---------------------------------------------------------------
      * - RHC DAYS > HIGH RATE DAYS LEFT - APPLY RHC HIGH & LOW RATES
      *---------------------------------------------------------------
              ELSE
      
                 MOVE HIGH-RATE-DAYS-LEFT TO HR-BILL-UNITS1
                 PERFORM V180-APPLY-HIGH-RHC-RATE
                    THRU V180-APPLY-HIGH-RHC-RATE-EXIT
      
                 COMPUTE LR-BILL-UNITS1 =
                         BILL-UNITS1 - HR-BILL-UNITS1
                 PERFORM V180-APPLY-LOW-RHC-RATE
                    THRU V180-APPLY-LOW-RHC-RATE-EXIT
      
              END-IF
           END-IF.
      
      
       V180-EVAL-RHC-DAYS-EXIT.
           EXIT.
      
      
      
      ****************************************************************
      **** V18.0   CALCULATE RHC LOW-RATE PAYMENT
      ****************************************************************
       V180-APPLY-LOW-RHC-RATE.
      
      *---------------------------------------------------------------
      * QIP REDUCTION APPLIED
      *---------------------------------------------------------------
           IF BILL-QIP-IND = '1'
              COMPUTE LR-BILL-PAY-AMT1 ROUNDED =
                 ((2018-V180-LOW-RHC-LS-RATE-Q * BILL-BENE-WAGE-INDEX)
                 + 2018-V180-LOW-RHC-NLS-RATE-Q) *  LR-BILL-UNITS1
      
      *---------------------------------------------------------------
      * NO QIP REDUCTION
      *---------------------------------------------------------------
           ELSE
              COMPUTE LR-BILL-PAY-AMT1 ROUNDED =
                 ((2018-V180-LOW-RHC-LS-RATE * BILL-BENE-WAGE-INDEX)
                 + 2018-V180-LOW-RHC-NLS-RATE) *  LR-BILL-UNITS1
           END-IF.
      
           MOVE 'Y' TO RHC-LOW-DAY-IND.
      
      
       V180-APPLY-LOW-RHC-RATE-EXIT.
           EXIT.
      
      
      
      ****************************************************************
      **** V18.0   CALCULATE RHC HIGH-RATE PAYMENT
      ****************************************************************
       V180-APPLY-HIGH-RHC-RATE.
      
      *---------------------------------------------------------------
      * QIP REDUCTION APPLIED
      *---------------------------------------------------------------
           IF BILL-QIP-IND = '1'
              COMPUTE HR-BILL-PAY-AMT1 ROUNDED =
                 ((2018-V180-HIGH-RHC-LS-RATE-Q * BILL-BENE-WAGE-INDEX)
                 + 2018-V180-HIGH-RHC-NLS-RATE-Q) *  HR-BILL-UNITS1
      
      *---------------------------------------------------------------
      * NO QIP REDUCTION
      *---------------------------------------------------------------
           ELSE
              COMPUTE HR-BILL-PAY-AMT1 ROUNDED =
                 ((2018-V180-HIGH-RHC-LS-RATE * BILL-BENE-WAGE-INDEX)
                 + 2018-V180-HIGH-RHC-NLS-RATE) *  HR-BILL-UNITS1
           END-IF.
      
           MOVE 'Y' TO RHC-HIGH-DAY-IND.
      
      
       V180-APPLY-HIGH-RHC-RATE-EXIT.
           EXIT.
      
      
      
      ****************************************************************
      **** V18.0   CALCULATE END-OF-LIFE SERVICE-INTENSITY ADD-ON
      ****************************************************************
       V180-CALC-RHC-EOL-SIA.
      
      *===============================================================
      *  SET  INDICATOR  [SIA-UNITS-IND = 'Y']
      *  SIA INDICATOR WILL BE USED TO HELP DETERMINE THE CORRECT RTC
      *===============================================================
           IF  BILL-EOL-ADD-ON-DAY1-UNITS > ZEROES OR
               BILL-EOL-ADD-ON-DAY2-UNITS > ZEROES OR
               BILL-EOL-ADD-ON-DAY3-UNITS > ZEROES OR
               BILL-EOL-ADD-ON-DAY4-UNITS > ZEROES OR
               BILL-EOL-ADD-ON-DAY5-UNITS > ZEROES OR
               BILL-EOL-ADD-ON-DAY6-UNITS > ZEROES OR
               BILL-EOL-ADD-ON-DAY7-UNITS > ZEROES
      
               MOVE 'Y' TO SIA-UNITS-IND
           ELSE
               MOVE 'N' TO SIA-UNITS-IND
               GO TO V180-CALC-RHC-EOL-SIA-EXIT
           END-IF.
      
      
      *===============================================================
      *     IF ANY OF THE EOL FIELDS ARE GREATER THAN ZERO
      *     THEN COMPUTE THE >> CHC-WAGE-INDEXED-RATE << FOR
      *     SIA PAYMENT AMOUNT CALCULATION (QIP OR NON-QIP)
      *===============================================================
      
      *---------------------------------------------------------------
      * CALCULATE SIA PAYMENT RATE: HOURLY CHC RATE W/ QIP REDUCTION
      *---------------------------------------------------------------
           IF  BILL-QIP-IND = '1'
               COMPUTE SIA-PYMT-RATE ROUNDED =
                 (((2018-V180-CHC-LS-RATE-Q * BILL-BENE-WAGE-INDEX)
                      + 2018-V180-CHC-NLS-RATE-Q) / 24)
      
      *---------------------------------------------------------------
      * CALCULATE SIA PAYMENT RATE: HOURLY CHC RATE W/OUT QIP REDUCT.
      *---------------------------------------------------------------
           ELSE
               COMPUTE SIA-PYMT-RATE ROUNDED =
                 (((2018-V180-CHC-LS-RATE * BILL-BENE-WAGE-INDEX)
                      + 2018-V180-CHC-NLS-RATE) / 24)
           END-IF.
      
      
      *===============================================================
      *     CALCULATE END OF LIFE SIA PAYMENT FOR UP TO 7 DAYS
      *       - SIA UNITS IN 15 MIN BLOCKS - CONVERT TO HOURS
      *       - SIA PAYMENT AMT IS CAPPED AT 4 HOURS
      *===============================================================
      
      *---------------------------------------------------------------
      * CALCULATE >> DAY 1 EOL SIA PYMT UP TO 4 HRS, 1 UNIT = 15 MIN
      *---------------------------------------------------------------
           IF  BILL-EOL-ADD-ON-DAY1-UNITS > ZEROES
               COMPUTE EOL-UNITS1 = BILL-EOL-ADD-ON-DAY1-UNITS
      
               IF EOL-UNITS1 >= 16
                   MOVE 4 TO EOL-HOURS1
               ELSE
                   COMPUTE EOL-HOURS1 ROUNDED = (EOL-UNITS1 / 4)
               END-IF
      
               COMPUTE BILL-EOL-ADD-ON-DAY1-PAY ROUNDED =
                       EOL-HOURS1 * SIA-PYMT-RATE
      
           END-IF.
      
      
      *---------------------------------------------------------------
      * CALCULATE >> DAY 2 EOL SIA PYMT UP TO 4 HRS, 1 UNIT = 15 MIN
      *---------------------------------------------------------------
           IF  BILL-EOL-ADD-ON-DAY2-UNITS > ZEROES
               COMPUTE EOL-UNITS2 = BILL-EOL-ADD-ON-DAY2-UNITS
      
               IF EOL-UNITS2 >= 16
                   MOVE 4 TO EOL-HOURS2
               ELSE
                   COMPUTE EOL-HOURS2 ROUNDED = (EOL-UNITS2 / 4)
               END-IF
      
               COMPUTE BILL-EOL-ADD-ON-DAY2-PAY  ROUNDED =
                       EOL-HOURS2 * SIA-PYMT-RATE
           END-IF.
      
      
      *---------------------------------------------------------------
      * CALCULATE >> DAY 3 EOL SIA PYMT UP TO 4 HRS, 1 UNIT = 15 MIN
      *---------------------------------------------------------------
           IF  BILL-EOL-ADD-ON-DAY3-UNITS > ZEROES
               COMPUTE EOL-UNITS3 = BILL-EOL-ADD-ON-DAY3-UNITS
      
               IF EOL-UNITS3 >= 16
                   MOVE 4 TO EOL-HOURS3
               ELSE
                   COMPUTE EOL-HOURS3 ROUNDED = (EOL-UNITS3 / 4)
               END-IF
      
               COMPUTE BILL-EOL-ADD-ON-DAY3-PAY  ROUNDED =
                       EOL-HOURS3 * SIA-PYMT-RATE
           END-IF.
      
      
      *---------------------------------------------------------------
      * CALCULATE >> DAY 4 EOL SIA PYMT UP TO 4 HRS, 1 UNIT = 15 MIN
      *---------------------------------------------------------------
           IF  BILL-EOL-ADD-ON-DAY4-UNITS > ZEROES
               COMPUTE EOL-UNITS4 = BILL-EOL-ADD-ON-DAY4-UNITS
      
               IF EOL-UNITS4 >= 16
                   MOVE 4 TO EOL-HOURS4
               ELSE
                   COMPUTE EOL-HOURS4 ROUNDED = (EOL-UNITS4 / 4)
               END-IF
      
               COMPUTE BILL-EOL-ADD-ON-DAY4-PAY ROUNDED =
                       EOL-HOURS4 * SIA-PYMT-RATE
           END-IF.
      
      
      *---------------------------------------------------------------
      * CALCULATE >> DAY 5 EOL SIA PYMT UP TO 4 HRS, 1 UNIT = 15 MIN
      *---------------------------------------------------------------
           IF  BILL-EOL-ADD-ON-DAY5-UNITS > ZEROES
               COMPUTE EOL-UNITS5 = BILL-EOL-ADD-ON-DAY5-UNITS
      
               IF EOL-UNITS5 >= 16
                   MOVE 4 TO EOL-HOURS5
               ELSE
                   COMPUTE EOL-HOURS5 ROUNDED = (EOL-UNITS5 / 4)
               END-IF
      
               COMPUTE BILL-EOL-ADD-ON-DAY5-PAY ROUNDED =
                       EOL-HOURS5 * SIA-PYMT-RATE
           END-IF.
      
      
      *---------------------------------------------------------------
      * CALCULATE >> DAY 6 EOL SIA PYMT UP TO 4 HRS, 1 UNIT = 15 MIN
      *---------------------------------------------------------------
           IF  BILL-EOL-ADD-ON-DAY6-UNITS > ZEROES
               COMPUTE EOL-UNITS6 = BILL-EOL-ADD-ON-DAY6-UNITS
      
               IF EOL-UNITS6 >= 16
                   MOVE 4 TO EOL-HOURS6
               ELSE
                   COMPUTE EOL-HOURS6 ROUNDED = (EOL-UNITS6 / 4)
               END-IF
      
               COMPUTE BILL-EOL-ADD-ON-DAY6-PAY ROUNDED =
                       EOL-HOURS6 * SIA-PYMT-RATE
           END-IF.
      
      
      *---------------------------------------------------------------
      * CALCULATE >> DAY 7 EOL SIA PYMT UP TO 4 HRS, 1 UNIT = 15 MIN
      *---------------------------------------------------------------
           IF  BILL-EOL-ADD-ON-DAY7-UNITS > ZEROES
               COMPUTE EOL-UNITS7 = BILL-EOL-ADD-ON-DAY7-UNITS
      
               IF EOL-UNITS7 >= 16
                   MOVE 4 TO EOL-HOURS7
               ELSE
                   COMPUTE EOL-HOURS7 ROUNDED = (EOL-UNITS7 / 4)
               END-IF
      
               COMPUTE BILL-EOL-ADD-ON-DAY7-PAY ROUNDED =
                       EOL-HOURS7 * SIA-PYMT-RATE
           END-IF.
      
      
      *---------------------------------------------------------------
      *  CALCULATE >> TOTAL CLAIM EOL SIA ADD-ON PAYMENT
      *---------------------------------------------------------------
           COMPUTE SIA-PAY-AMT-TOTAL =
                   BILL-EOL-ADD-ON-DAY1-PAY +
                   BILL-EOL-ADD-ON-DAY2-PAY +
                   BILL-EOL-ADD-ON-DAY3-PAY +
                   BILL-EOL-ADD-ON-DAY4-PAY +
                   BILL-EOL-ADD-ON-DAY5-PAY +
                   BILL-EOL-ADD-ON-DAY6-PAY +
                   BILL-EOL-ADD-ON-DAY7-PAY.
      
      
       V180-CALC-RHC-EOL-SIA-EXIT.
           EXIT.
      
      
      
      ****************************************************************
      **** V18.0   RHC - SUM RHC '0651' COMPONENTS
      ****************************************************************
       V180-SUM-RHC-0651-RATE.
      
      
      ****============================================================
      **** CALCULATE TOTAL RHC PAYMENT
      ****============================================================
           COMPUTE WRK-PAY-RATE1 =
                   HR-BILL-PAY-AMT1 + LR-BILL-PAY-AMT1.
      
      
      ****============================================================
      **** ASSIGN RHC RETURN CODE (RTC)
      ****============================================================
      
      *---------------------------------------------------------------
      * END-OF-LIFE (EOL) SERVICE INTENSITY (SIA) ADD-ON PRESENT
      *---------------------------------------------------------------
           IF SIA-UNITS-IND = 'Y'
      
      *---------------------------------------------------------------
      *     HIGH RHC RATE (APPLIES TO SOME OR ALL RHC) & EOL SIA
      *---------------------------------------------------------------
              IF RHC-HIGH-DAY-IND = 'Y'
                 MOVE '77' TO BILL-RTC
      
      *---------------------------------------------------------------
      *     LOW RHC RATE APPLIES TO ALL RHC & EOL SIA
      *---------------------------------------------------------------
              ELSE
                 IF RHC-LOW-DAY-IND = 'Y'
                    MOVE '74' TO BILL-RTC
                 END-IF
              END-IF
           END-IF.
      
      
      *---------------------------------------------------------------
      * END-OF-LIFE (EOL) SERVICE INTENSITY ADD-ON (SIA) NOT PRESENT
      *---------------------------------------------------------------
           IF SIA-UNITS-IND = 'N'
      
      *---------------------------------------------------------------
      *     HIGH RHC RATE (APPLIES TO SOME OR ALL RHC) & NO EOL SIA
      *---------------------------------------------------------------
              IF RHC-HIGH-DAY-IND = 'Y'
                 MOVE '75' TO BILL-RTC
      
      *---------------------------------------------------------------
      *     LOW RHC RATE APPLIES TO ALL RHC & NO EOL SIA
      *---------------------------------------------------------------
              ELSE
                 IF RHC-LOW-DAY-IND = 'Y'
                    MOVE '73' TO BILL-RTC
                 END-IF
              END-IF
           END-IF.
      
      
       V180-SUM-RHC-0651-RATE-EXIT.
           EXIT.
      
      
      
      ****************************************************************
      **** V18.0   CHC - CONTINUOUS HOME CARE = REVENUE CODE = 0652
      ****************************************************************
       2018-V180-CHC-0652.
      
      *==================================================
      *  >>> IF REVENUE CODE '0652' UNITS > 0         <<<
      *  >>> [THE DAY IS A CHC LEVEL OF CARE DAY]     <<<
      *  >>> 1 UNIT = 15 MIN.                         <<<
      *==================================================
           IF BILL-UNITS2 NOT > 0
              GO TO 2018-V180-CHC-0652-EXIT
           END-IF.
      
      
      *---------------------------------------------------------------
      * IF USING THE RHC RATE (LESS THAN 32 UNITS/8 HOURS):
      *    CALCULATE NUMBER OF SERVICE DAYS PRIOR TO CHC SERVICE DATE
      *---------------------------------------------------------------
           IF BILL-UNITS2 < 32
              INITIALIZE DATE-CALCULATION-FIELDS
              MOVE BILL-LINE-ITEM-DOS2 TO DATE-2-DOS
              PERFORM V180-CALC-PRIOR-SVC-DAYS
                 THRU V180-CALC-PRIOR-SVC-DAYS-EXIT
           END-IF.
      
      
      ****============================================================
      **** CHC - APPLY QIP REDUCTION
      ****============================================================
           IF BILL-QIP-IND = '1'
      
      *---------------------------------------------------------------
      *  PAY 1 DAY USING THE RHC RATE IF LESS THAN 32 UNITS/8 HOURS
      *---------------------------------------------------------------
              IF BILL-UNITS2 < 32
      
      *---------------------------------------------------------------
      *  - USE HIGH RATE IF CHC DAY IS WITHIN 60 DAYS OF ADMISSION
      *---------------------------------------------------------------
                 IF PRIOR-SVC-DAYS < 60
                    COMPUTE WRK-PAY-RATE2 ROUNDED =
                            ((2018-V180-HIGH-RHC-LS-RATE-Q *
                              BILL-BENE-WAGE-INDEX) +
                              2018-V180-HIGH-RHC-NLS-RATE-Q)
      
      *---------------------------------------------------------------
      *  - USE LOW RATE IF CHC DAY ISN'T WITHIN 60 DAYS OF ADMISSION
      *---------------------------------------------------------------
                 ELSE
                    COMPUTE WRK-PAY-RATE2 ROUNDED =
                            ((2018-V180-LOW-RHC-LS-RATE-Q *
                              BILL-BENE-WAGE-INDEX) +
                              2018-V180-LOW-RHC-NLS-RATE-Q)
                 END-IF
      
      
      *---------------------------------------------------------------
      *  PAY USING CHC RATE FOR 32 OR MORE UNITS (8 - 24 HOURS)
      *      - 1 UNIT = 15 MIN., DIVIDE BY 4 TO GET HOURS
      *      - DIVIDE DAILY CHC RATE BY 24 TO GET HOURLY RATE
      *---------------------------------------------------------------
              ELSE
                 COMPUTE WRK-PAY-RATE2 ROUNDED =
                         (((2018-V180-CHC-LS-RATE-Q *
                            BILL-BENE-WAGE-INDEX) +
                            2018-V180-CHC-NLS-RATE-Q) / 24) *
                            (BILL-UNITS2 / 4)
              END-IF
      
              GO TO 2018-V180-CHC-0652-EXIT
      
           END-IF.
      
      
      ****============================================================
      **** CHC - NO QIP REDUCTION  CODE = 0652
      ****============================================================
           IF BILL-QIP-IND NOT = '1'
      
      *---------------------------------------------------------------
      *    PAY 1 DAY USING THE RHC RATE IF LESS THAN 32 UNITS/8 HOURS
      *---------------------------------------------------------------
              IF BILL-UNITS2 < 32
      
      *---------------------------------------------------------------
      *  - USE HIGH RATE IF CHC DAY IS WITHIN 60 DAYS OF ADMISSION
      *---------------------------------------------------------------
                 IF PRIOR-SVC-DAYS < 60
                    COMPUTE WRK-PAY-RATE2 ROUNDED =
                            ((2018-V180-HIGH-RHC-LS-RATE *
                              BILL-BENE-WAGE-INDEX) +
                              2018-V180-HIGH-RHC-NLS-RATE)
      
      *---------------------------------------------------------------
      *  - USE LOW RATE IF CHC DAY ISN'T WITHIN 60 DAYS OF ADMISSION
      *---------------------------------------------------------------
                 ELSE
                    COMPUTE WRK-PAY-RATE2 ROUNDED =
                            ((2018-V180-LOW-RHC-LS-RATE *
                              BILL-BENE-WAGE-INDEX) +
                              2018-V180-LOW-RHC-NLS-RATE)
                 END-IF
      
      *---------------------------------------------------------------
      *    PAY USING CHC RATE FOR 32 OR MORE UNITS (8 - 24 HOURS)
      *        - 1 UNIT = 15 MIN., DIVIDE BY 4 TO GET HOURS
      *        - DIVIDE DAILY CHC RATE BY 24 TO GET HOURLY RATE
      *---------------------------------------------------------------
              ELSE
                   COMPUTE WRK-PAY-RATE2 ROUNDED =
                           (((2018-V180-CHC-LS-RATE *
                              BILL-BENE-WAGE-INDEX) +
                              2018-V180-CHC-NLS-RATE) / 24) *
                              (BILL-UNITS2 / 4)
              END-IF
           END-IF.
      
      
       2018-V180-CHC-0652-EXIT.
           EXIT.
      
      
      
      ****************************************************************
      **** V18.0 IRC - INPATIENT RESPITE CARE = REVENUE CODE = 0655
      ****************************************************************
       2018-V180-IRC-0655.
      
      ****============================================================
      **** CALCULATE IRC PAYMENT WITH QIP REDUCTION (1 UNIT = 1 DAY)
      ****============================================================
           IF BILL-QIP-IND = '1'
              COMPUTE WRK-PAY-RATE3 ROUNDED =
                     ((2018-V180-IRC-LS-RATE-Q * BILL-PROV-WAGE-INDEX)
                       + 2018-V180-IRC-NLS-RATE-Q) *  BILL-UNITS3
      
      ****============================================================
      **** CALCULATE IRC PAYMENT W/OUT QIP REDUCTION (1 UNIT = 1 DAY)
      ****============================================================
           ELSE
              COMPUTE WRK-PAY-RATE3 ROUNDED =
                     ((2018-V180-IRC-LS-RATE * BILL-PROV-WAGE-INDEX)
                       + 2018-V180-IRC-NLS-RATE) *  BILL-UNITS3
           END-IF.
      
      
       2018-V180-IRC-0655-EXIT.
           EXIT.
      
      
      
      ****************************************************************
      ****    GIC - GENERAL INPATIENT CARE = REVENUE CODE = 0656
      ****************************************************************
       2018-V180-GIC-0656.
      
      ****============================================================
      **** CALCULATE GIC PAYMENT WITH QIP REDUCTION (1 UNIT = 1 DAY)
      ****============================================================
           IF BILL-QIP-IND = '1'
              COMPUTE WRK-PAY-RATE4 ROUNDED =
                     ((2018-V180-GIC-LS-RATE-Q * BILL-PROV-WAGE-INDEX)
                       + 2018-V180-GIC-NLS-RATE-Q) *  BILL-UNITS4
      
      ****============================================================
      **** CALCULATE GIC PAYMENT W/OUT QIP REDUCTION (1 UNIT = 1 DAY)
      ****============================================================
           ELSE
              COMPUTE WRK-PAY-RATE4 ROUNDED =
                     ((2018-V180-GIC-LS-RATE * BILL-PROV-WAGE-INDEX)
                       + 2018-V180-GIC-NLS-RATE) *  BILL-UNITS4
           END-IF.
      
       2018-V180-GIC-0656-EXIT.
           EXIT.
      
      
      
      ****************************************************************
       V180-CALC-PRIOR-SVC-DAYS.
      ****************************************************************
      
      *---------------------------------------------------------------
      * GET ADMISSION DATE (SERVICE DATE SET PRIOR TO THIS PARAGRAPH)
      *---------------------------------------------------------------
           MOVE BILL-ADMISSION-DATE TO DATE-1-ADM.
      
      
      *---------------------------------------------------------------
      * CONVERT ADMISSION AND SERVICE DATES INTO INTEGERS
      *---------------------------------------------------------------
           COMPUTE DATE-1-ADM-INTEGER =
                   FUNCTION INTEGER-OF-DATE (DATE-1-ADM).
      
           COMPUTE DATE-2-DOS-INTEGER =
                   FUNCTION INTEGER-OF-DATE (DATE-2-DOS).
      
      
      *---------------------------------------------------------------
      * CALCULATE DAYS ELAPSED BETWEEN ADMISSION AND SERVICE DATES
      *---------------------------------------------------------------
           COMPUTE DAYS-BETWEEN-DATES =
                   DATE-2-DOS-INTEGER - DATE-1-ADM-INTEGER.
      
      
      *---------------------------------------------------------------
      * DETERMINE THE NUMBER OF PRIOR BENEFIT DAYS
      *---------------------------------------------------------------
           IF BILL-NA-ADD-ON-DAY1-UNITS > ZEROES
               COMPUTE PRIOR-BENEFIT-DAYS = BILL-NA-ADD-ON-DAY1-UNITS
           ELSE
               MOVE ZERO TO PRIOR-BENEFIT-DAYS
           END-IF.
      
      
      *---------------------------------------------------------------
      * CALCULATE TOTAL DAYS SINCE ADMISSION & BEFORE SERVICE DATE
      *---------------------------------------------------------------
           COMPUTE PRIOR-SVC-DAYS =
                   DAYS-BETWEEN-DATES + PRIOR-BENEFIT-DAYS.
      
      
       V180-CALC-PRIOR-SVC-DAYS-EXIT.
           EXIT.
      
      
      
      ****=============  BEGIN FY 2019 LOGIC =====================****
      ****==============  BEGIN V190 PROCESS  ====================****
      ****=========  VALID FROM 10/01/18 THRU 09/30/19  ==========****
      ****========================================================****
      
      
      
      
      ****************************************************************
      **** V190   MAINLINE PROCESS FOR V190
      ****************************************************************
       2019-V190-PROCESS-DATA.
      
      
      *---------------------------------------------------------------
      *  VALIDATE BILL INPUT DATA - UNITS
      *---------------------------------------------------------------
           IF BILL-UNITS1 > 1000 OR
              BILL-UNITS2 > 1000 OR
              BILL-UNITS3 > 1000 OR
              BILL-UNITS4 > 1000
              MOVE '10' TO BILL-RTC
              GO TO 2019-V190-PROCESS-EXIT
           END-IF.
      
      
      *---------------------------------------------------------------
      *  CALCULATE PAYMENT FOR EACH LEVEL OF CARE BY REVENUE CODE
      *---------------------------------------------------------------
           IF BILL-REV1 = '0651'
              PERFORM 2019-V190-RHC-0651
                 THRU 2019-V190-RHC-0651-EXIT.
      
      
           IF BILL-REV2 = '0652'
              PERFORM 2019-V190-CHC-0652
                 THRU 2019-V190-CHC-0652-EXIT.
      
      
           IF BILL-REV3 = '0655'
              PERFORM 2019-V190-IRC-0655
                 THRU 2019-V190-IRC-0655-EXIT.
      
      
           IF BILL-REV4 = '0656'
              PERFORM 2019-V190-GIC-0656
                 THRU 2019-V190-GIC-0656-EXIT.
      
      
      *---------------------------------------------------------------
      *  CALCULATE TOTAL CLAIM PAYMENT
      *---------------------------------------------------------------
           COMPUTE BILL-PAY-AMT-TOTAL =
                   WRK-PAY-RATE1 +
                   WRK-PAY-RATE2 +
                   WRK-PAY-RATE3 +
                   WRK-PAY-RATE4 +
                   SIA-PAY-AMT-TOTAL.
      
      
      *---------------------------------------------------------------
      *  MOVE EACH LEVEL OF CARE'S PAYMENT TO THE OUTPUT RECORD
      *---------------------------------------------------------------
           MOVE WRK-PAY-RATE1        TO  BILL-PAY-AMT1.
           MOVE WRK-PAY-RATE2        TO  BILL-PAY-AMT2.
           MOVE WRK-PAY-RATE3        TO  BILL-PAY-AMT3.
           MOVE WRK-PAY-RATE4        TO  BILL-PAY-AMT4.
      
      
      *---------------------------------------------------------------
      *  INITIALIZE WORKING STORAGE PAYMENT VARIABLES
      *---------------------------------------------------------------
           MOVE ZEROES               TO WRK-PAY-RATE1
                                        WRK-PAY-RATE2
                                        WRK-PAY-RATE3
                                        WRK-PAY-RATE4.
      
       2019-V190-PROCESS-EXIT.
           EXIT.
      
      
      
      ****************************************************************
      **** V190   RHC - ROUTINE HOME CARE = REVENUE CODE = 0651
      ****************************************************************
       2019-V190-RHC-0651.
      
      
      *==================================================
      *  >>> IF REVENUE CODE '0651' UNITS > 0         <<<
      *  >>> [THE DAY IS AN RHC LEVEL OF CARE DAY]    <<<
      *  >>> 1 UNIT = 1 DAY                           <<<
      *==================================================
           IF BILL-UNITS1 NOT > 0
              GO TO 2019-V190-RHC-0651-EXIT
           END-IF.
      
      
      *---------------------------------------------------------------
      * DATE ERROR - CANNOT CONTINUE RHC LEVEL OF CARE DAY PROCESSING
      *---------------------------------------------------------------
           IF BILL-LINE-ITEM-DOS1 < BILL-ADMISSION-DATE
              GO TO 2019-V190-RHC-0651-EXIT
           END-IF.
      
      
      *---------------------------------------------------------------
      * CALCULATE RHC LEVEL OF CARE DAY PAYMENT
      *---------------------------------------------------------------
      
           MOVE BILL-LINE-ITEM-DOS1 TO DATE-2-DOS.
           PERFORM V190-CALC-PRIOR-SVC-DAYS
              THRU V190-CALC-PRIOR-SVC-DAYS-EXIT.
      
           PERFORM V190-EVAL-RHC-DAYS
              THRU V190-EVAL-RHC-DAYS-EXIT.
      
           PERFORM V190-CALC-RHC-EOL-SIA
              THRU V190-CALC-RHC-EOL-SIA-EXIT.
      
           PERFORM V190-SUM-RHC-0651-RATE
              THRU V190-SUM-RHC-0651-RATE-EXIT.
      
      
       2019-V190-RHC-0651-EXIT.
           EXIT.
      
      
      
      ****************************************************************
       V190-EVAL-RHC-DAYS.
      ****************************************************************
      
      *---------------------------------------------------------------
      * SERVICE BEYOND 60TH DAY - APPLY RHC LOW RATE TO ALL RHC DAYS
      *---------------------------------------------------------------
           IF PRIOR-SVC-DAYS >= 60
              MOVE BILL-UNITS1 TO LR-BILL-UNITS1
              PERFORM V190-APPLY-LOW-RHC-RATE
                 THRU V190-APPLY-LOW-RHC-RATE-EXIT
              GO TO V190-EVAL-RHC-DAYS-EXIT
           END-IF.
      
      
      *---------------------------------------------------------------
      * SERVICE ON 60TH DAY OR EARLIER - APPLY RHC HIGH/LOW RATES
      *---------------------------------------------------------------
           IF PRIOR-SVC-DAYS < 60
              COMPUTE HIGH-RATE-DAYS-LEFT = 60 - PRIOR-SVC-DAYS
      
      
      *---------------------------------------------------------------
      * - RHC DAYS <= HIGH RATE DAYS LEFT - APPLY RHC HIGH RATE TO ALL
      *---------------------------------------------------------------
              IF BILL-UNITS1 <= HIGH-RATE-DAYS-LEFT
                 MOVE BILL-UNITS1 TO HR-BILL-UNITS1
                 PERFORM V190-APPLY-HIGH-RHC-RATE
                    THRU V190-APPLY-HIGH-RHC-RATE-EXIT
                 GO TO V190-EVAL-RHC-DAYS-EXIT
      
      
      *---------------------------------------------------------------
      * - RHC DAYS > HIGH RATE DAYS LEFT - APPLY RHC HIGH & LOW RATES
      *---------------------------------------------------------------
              ELSE
      
                 MOVE HIGH-RATE-DAYS-LEFT TO HR-BILL-UNITS1
                 PERFORM V190-APPLY-HIGH-RHC-RATE
                    THRU V190-APPLY-HIGH-RHC-RATE-EXIT
      
                 COMPUTE LR-BILL-UNITS1 =
                         BILL-UNITS1 - HR-BILL-UNITS1
                 PERFORM V190-APPLY-LOW-RHC-RATE
                    THRU V190-APPLY-LOW-RHC-RATE-EXIT
      
              END-IF
           END-IF.
      
      
       V190-EVAL-RHC-DAYS-EXIT.
           EXIT.
      
      
      
      ****************************************************************
      **** V190    CALCULATE RHC LOW-RATE PAYMENT
      ****************************************************************
       V190-APPLY-LOW-RHC-RATE.
      
      *---------------------------------------------------------------
      * FY 2019 CR # 10573
      *---------------------------------------------------------------
      
           MOVE LR-BILL-UNITS1  TO BILL-LOW-RHC-DAYS.
      
      
      
      *---------------------------------------------------------------
      * QIP REDUCTION APPLIED
      *---------------------------------------------------------------
           IF BILL-QIP-IND = '1'
              COMPUTE LR-BILL-PAY-AMT1 ROUNDED =
                 ((2019-V190-LOW-RHC-LS-RATE-Q * BILL-BENE-WAGE-INDEX)
                 + 2019-V190-LOW-RHC-NLS-RATE-Q) *  LR-BILL-UNITS1
      
      *---------------------------------------------------------------
      * NO QIP REDUCTION
      *---------------------------------------------------------------
           ELSE
              COMPUTE LR-BILL-PAY-AMT1 ROUNDED =
                 ((2019-V190-LOW-RHC-LS-RATE * BILL-BENE-WAGE-INDEX)
                 + 2019-V190-LOW-RHC-NLS-RATE) *  LR-BILL-UNITS1
           END-IF.
      
           MOVE 'Y' TO RHC-LOW-DAY-IND.
      
      
       V190-APPLY-LOW-RHC-RATE-EXIT.
           EXIT.
      
      
      
      ****************************************************************
      **** V190   CALCULATE RHC HIGH-RATE PAYMENT
      ****************************************************************
       V190-APPLY-HIGH-RHC-RATE.
      
      
      *---------------------------------------------------------------
      * FY 2019 CR # 10573
      *---------------------------------------------------------------
      
           MOVE HR-BILL-UNITS1  TO BILL-HIGH-RHC-DAYS.
      
      *---------------------------------------------------------------
      * QIP REDUCTION APPLIED
      *---------------------------------------------------------------
           IF BILL-QIP-IND = '1'
              COMPUTE HR-BILL-PAY-AMT1 ROUNDED =
                 ((2019-V190-HIGH-RHC-LS-RATE-Q * BILL-BENE-WAGE-INDEX)
                 + 2019-V190-HIGH-RHC-NLS-RATE-Q) *  HR-BILL-UNITS1
      
      *---------------------------------------------------------------
      * NO QIP REDUCTION
      *---------------------------------------------------------------
           ELSE
              COMPUTE HR-BILL-PAY-AMT1 ROUNDED =
                 ((2019-V190-HIGH-RHC-LS-RATE * BILL-BENE-WAGE-INDEX)
                 + 2019-V190-HIGH-RHC-NLS-RATE) *  HR-BILL-UNITS1
           END-IF.
      
           MOVE 'Y' TO RHC-HIGH-DAY-IND.
      
      
       V190-APPLY-HIGH-RHC-RATE-EXIT.
           EXIT.
      
      
      
      ****************************************************************
      **** V190    CALCULATE END-OF-LIFE SERVICE-INTENSITY ADD-ON
      ****************************************************************
       V190-CALC-RHC-EOL-SIA.
      
      *===============================================================
      *  SET  INDICATOR  [SIA-UNITS-IND = 'Y']
      *  SIA INDICATOR WILL BE USED TO HELP DETERMINE THE CORRECT RTC
      *===============================================================
           IF  BILL-EOL-ADD-ON-DAY1-UNITS > ZEROES OR
               BILL-EOL-ADD-ON-DAY2-UNITS > ZEROES OR
               BILL-EOL-ADD-ON-DAY3-UNITS > ZEROES OR
               BILL-EOL-ADD-ON-DAY4-UNITS > ZEROES OR
               BILL-EOL-ADD-ON-DAY5-UNITS > ZEROES OR
               BILL-EOL-ADD-ON-DAY6-UNITS > ZEROES OR
               BILL-EOL-ADD-ON-DAY7-UNITS > ZEROES
      
               MOVE 'Y' TO SIA-UNITS-IND
           ELSE
               MOVE 'N' TO SIA-UNITS-IND
               GO TO V190-CALC-RHC-EOL-SIA-EXIT
           END-IF.
      
      
      *===============================================================
      *     IF ANY OF THE EOL FIELDS ARE GREATER THAN ZERO
      *     THEN COMPUTE THE >> CHC-WAGE-INDEXED-RATE << FOR
      *     SIA PAYMENT AMOUNT CALCULATION (QIP OR NON-QIP)
      *===============================================================
      
      *---------------------------------------------------------------
      * CALCULATE SIA PAYMENT RATE: HOURLY CHC RATE W/ QIP REDUCTION
      *---------------------------------------------------------------
           IF  BILL-QIP-IND = '1'
               COMPUTE SIA-PYMT-RATE ROUNDED =
                 (((2019-V190-CHC-LS-RATE-Q * BILL-BENE-WAGE-INDEX)
                      + 2019-V190-CHC-NLS-RATE-Q) / 24)
      
      *---------------------------------------------------------------
      * CALCULATE SIA PAYMENT RATE: HOURLY CHC RATE W/OUT QIP REDUCT.
      *---------------------------------------------------------------
           ELSE
               COMPUTE SIA-PYMT-RATE ROUNDED =
                 (((2019-V190-CHC-LS-RATE * BILL-BENE-WAGE-INDEX)
                      + 2019-V190-CHC-NLS-RATE) / 24)
           END-IF.
      
      
      *===============================================================
      *     CALCULATE END OF LIFE SIA PAYMENT FOR UP TO 7 DAYS
      *       - SIA UNITS IN 15 MIN BLOCKS - CONVERT TO HOURS
      *       - SIA PAYMENT AMT IS CAPPED AT 4 HOURS
      *===============================================================
      
      *---------------------------------------------------------------
      * CALCULATE >> DAY 1 EOL SIA PYMT UP TO 4 HRS, 1 UNIT = 15 MIN
      *---------------------------------------------------------------
           IF  BILL-EOL-ADD-ON-DAY1-UNITS > ZEROES
               COMPUTE EOL-UNITS1 = BILL-EOL-ADD-ON-DAY1-UNITS
      
               IF EOL-UNITS1 >= 16
                   MOVE 4 TO EOL-HOURS1
               ELSE
                   COMPUTE EOL-HOURS1 ROUNDED = (EOL-UNITS1 / 4)
               END-IF
      
               COMPUTE BILL-EOL-ADD-ON-DAY1-PAY ROUNDED =
                       EOL-HOURS1 * SIA-PYMT-RATE
      
           END-IF.
      
      
      *---------------------------------------------------------------
      * CALCULATE >> DAY 2 EOL SIA PYMT UP TO 4 HRS, 1 UNIT = 15 MIN
      *---------------------------------------------------------------
           IF  BILL-EOL-ADD-ON-DAY2-UNITS > ZEROES
               COMPUTE EOL-UNITS2 = BILL-EOL-ADD-ON-DAY2-UNITS
      
               IF EOL-UNITS2 >= 16
                   MOVE 4 TO EOL-HOURS2
               ELSE
                   COMPUTE EOL-HOURS2 ROUNDED = (EOL-UNITS2 / 4)
               END-IF
      
               COMPUTE BILL-EOL-ADD-ON-DAY2-PAY  ROUNDED =
                       EOL-HOURS2 * SIA-PYMT-RATE
           END-IF.
      
      
      *---------------------------------------------------------------
      * CALCULATE >> DAY 3 EOL SIA PYMT UP TO 4 HRS, 1 UNIT = 15 MIN
      *---------------------------------------------------------------
           IF  BILL-EOL-ADD-ON-DAY3-UNITS > ZEROES
               COMPUTE EOL-UNITS3 = BILL-EOL-ADD-ON-DAY3-UNITS
      
               IF EOL-UNITS3 >= 16
                   MOVE 4 TO EOL-HOURS3
               ELSE
                   COMPUTE EOL-HOURS3 ROUNDED = (EOL-UNITS3 / 4)
               END-IF
      
               COMPUTE BILL-EOL-ADD-ON-DAY3-PAY  ROUNDED =
                       EOL-HOURS3 * SIA-PYMT-RATE
           END-IF.
      
      
      *---------------------------------------------------------------
      * CALCULATE >> DAY 4 EOL SIA PYMT UP TO 4 HRS, 1 UNIT = 15 MIN
      *---------------------------------------------------------------
           IF  BILL-EOL-ADD-ON-DAY4-UNITS > ZEROES
               COMPUTE EOL-UNITS4 = BILL-EOL-ADD-ON-DAY4-UNITS
      
               IF EOL-UNITS4 >= 16
                   MOVE 4 TO EOL-HOURS4
               ELSE
                   COMPUTE EOL-HOURS4 ROUNDED = (EOL-UNITS4 / 4)
               END-IF
      
               COMPUTE BILL-EOL-ADD-ON-DAY4-PAY ROUNDED =
                       EOL-HOURS4 * SIA-PYMT-RATE
           END-IF.
      
      
      *---------------------------------------------------------------
      * CALCULATE >> DAY 5 EOL SIA PYMT UP TO 4 HRS, 1 UNIT = 15 MIN
      *---------------------------------------------------------------
           IF  BILL-EOL-ADD-ON-DAY5-UNITS > ZEROES
               COMPUTE EOL-UNITS5 = BILL-EOL-ADD-ON-DAY5-UNITS
      
               IF EOL-UNITS5 >= 16
                   MOVE 4 TO EOL-HOURS5
               ELSE
                   COMPUTE EOL-HOURS5 ROUNDED = (EOL-UNITS5 / 4)
               END-IF
      
               COMPUTE BILL-EOL-ADD-ON-DAY5-PAY ROUNDED =
                       EOL-HOURS5 * SIA-PYMT-RATE
           END-IF.
      
      
      *---------------------------------------------------------------
      * CALCULATE >> DAY 6 EOL SIA PYMT UP TO 4 HRS, 1 UNIT = 15 MIN
      *---------------------------------------------------------------
           IF  BILL-EOL-ADD-ON-DAY6-UNITS > ZEROES
               COMPUTE EOL-UNITS6 = BILL-EOL-ADD-ON-DAY6-UNITS
      
               IF EOL-UNITS6 >= 16
                   MOVE 4 TO EOL-HOURS6
               ELSE
                   COMPUTE EOL-HOURS6 ROUNDED = (EOL-UNITS6 / 4)
               END-IF
      
               COMPUTE BILL-EOL-ADD-ON-DAY6-PAY ROUNDED =
                       EOL-HOURS6 * SIA-PYMT-RATE
           END-IF.
      
      
      *---------------------------------------------------------------
      * CALCULATE >> DAY 7 EOL SIA PYMT UP TO 4 HRS, 1 UNIT = 15 MIN
      *---------------------------------------------------------------
           IF  BILL-EOL-ADD-ON-DAY7-UNITS > ZEROES
               COMPUTE EOL-UNITS7 = BILL-EOL-ADD-ON-DAY7-UNITS
      
               IF EOL-UNITS7 >= 16
                   MOVE 4 TO EOL-HOURS7
               ELSE
                   COMPUTE EOL-HOURS7 ROUNDED = (EOL-UNITS7 / 4)
               END-IF
      
               COMPUTE BILL-EOL-ADD-ON-DAY7-PAY ROUNDED =
                       EOL-HOURS7 * SIA-PYMT-RATE
           END-IF.
      
      
      *---------------------------------------------------------------
      *  CALCULATE >> TOTAL CLAIM EOL SIA ADD-ON PAYMENT
      *---------------------------------------------------------------
           COMPUTE SIA-PAY-AMT-TOTAL =
                   BILL-EOL-ADD-ON-DAY1-PAY +
                   BILL-EOL-ADD-ON-DAY2-PAY +
                   BILL-EOL-ADD-ON-DAY3-PAY +
                   BILL-EOL-ADD-ON-DAY4-PAY +
                   BILL-EOL-ADD-ON-DAY5-PAY +
                   BILL-EOL-ADD-ON-DAY6-PAY +
                   BILL-EOL-ADD-ON-DAY7-PAY.
      
      
       V190-CALC-RHC-EOL-SIA-EXIT.
           EXIT.
      
      
      
      ****************************************************************
      **** V19.B   RHC - SUM RHC '0651' COMPONENTS
      ****************************************************************
       V190-SUM-RHC-0651-RATE.
      
      
      ****============================================================
      **** CALCULATE TOTAL RHC PAYMENT
      ****============================================================
           COMPUTE WRK-PAY-RATE1 =
                   HR-BILL-PAY-AMT1 + LR-BILL-PAY-AMT1.
      
      
      ****============================================================
      **** ASSIGN RHC RETURN CODE (RTC)
      ****============================================================
      
      *---------------------------------------------------------------
      * END-OF-LIFE (EOL) SERVICE INTENSITY (SIA) ADD-ON PRESENT
      *---------------------------------------------------------------
           IF SIA-UNITS-IND = 'Y'
      
      *---------------------------------------------------------------
      *     HIGH RHC RATE (APPLIES TO SOME OR ALL RHC) & EOL SIA
      *---------------------------------------------------------------
              IF RHC-HIGH-DAY-IND = 'Y'
                 MOVE '77' TO BILL-RTC
      
      *---------------------------------------------------------------
      *     LOW RHC RATE APPLIES TO ALL RHC & EOL SIA
      *---------------------------------------------------------------
              ELSE
                 IF RHC-LOW-DAY-IND = 'Y'
                    MOVE '74' TO BILL-RTC
                 END-IF
              END-IF
           END-IF.
      
      
      *---------------------------------------------------------------
      * END-OF-LIFE (EOL) SERVICE INTENSITY ADD-ON (SIA) NOT PRESENT
      *---------------------------------------------------------------
           IF SIA-UNITS-IND = 'N'
      
      *---------------------------------------------------------------
      *     HIGH RHC RATE (APPLIES TO SOME OR ALL RHC) & NO EOL SIA
      *---------------------------------------------------------------
              IF RHC-HIGH-DAY-IND = 'Y'
                 MOVE '75' TO BILL-RTC
      
      *---------------------------------------------------------------
      *     LOW RHC RATE APPLIES TO ALL RHC & NO EOL SIA
      *---------------------------------------------------------------
              ELSE
                 IF RHC-LOW-DAY-IND = 'Y'
                    MOVE '73' TO BILL-RTC
                 END-IF
              END-IF
           END-IF.
      
      
       V190-SUM-RHC-0651-RATE-EXIT.
           EXIT.
      
      
      
      ****************************************************************
      **** V19.B   CHC - CONTINUOUS HOME CARE = REVENUE CODE = 0652
      ****************************************************************
       2019-V190-CHC-0652.
      
      *==================================================
      *  >>> IF REVENUE CODE '0652' UNITS > 0         <<<
      *  >>> [THE DAY IS A CHC LEVEL OF CARE DAY]     <<<
      *  >>> 1 UNIT = 15 MIN.                         <<<
      *==================================================
           IF BILL-UNITS2 NOT > 0
              GO TO 2019-V190-CHC-0652-EXIT
           END-IF.
      
      
      *---------------------------------------------------------------
      * IF USING THE RHC RATE (LESS THAN 32 UNITS/8 HOURS):
      *    CALCULATE NUMBER OF SERVICE DAYS PRIOR TO CHC SERVICE DATE
      *---------------------------------------------------------------
           IF BILL-UNITS2 < 32
              INITIALIZE DATE-CALCULATION-FIELDS
              MOVE BILL-LINE-ITEM-DOS2 TO DATE-2-DOS
              PERFORM V190-CALC-PRIOR-SVC-DAYS
                 THRU V190-CALC-PRIOR-SVC-DAYS-EXIT
           END-IF.
      
      
      ****============================================================
      **** CHC - APPLY QIP REDUCTION
      ****============================================================
           IF BILL-QIP-IND = '1'
      
      *---------------------------------------------------------------
      *  PAY 1 DAY USING THE RHC RATE IF LESS THAN 32 UNITS/8 HOURS
      *---------------------------------------------------------------
              IF BILL-UNITS2 < 32
      
      *---------------------------------------------------------------
      *  - USE HIGH RATE IF CHC DAY IS WITHIN 60 DAYS OF ADMISSION
      *---------------------------------------------------------------
                 IF PRIOR-SVC-DAYS < 60
                    COMPUTE WRK-PAY-RATE2 ROUNDED =
                            ((2019-V190-HIGH-RHC-LS-RATE-Q *
                              BILL-BENE-WAGE-INDEX) +
                              2019-V190-HIGH-RHC-NLS-RATE-Q)
      
      *---------------------------------------------------------------
      *  - USE LOW RATE IF CHC DAY ISN'T WITHIN 60 DAYS OF ADMISSION
      *---------------------------------------------------------------
                 ELSE
                    COMPUTE WRK-PAY-RATE2 ROUNDED =
                            ((2019-V190-LOW-RHC-LS-RATE-Q *
                              BILL-BENE-WAGE-INDEX) +
                              2019-V190-LOW-RHC-NLS-RATE-Q)
                 END-IF
      
      
      *---------------------------------------------------------------
      *  PAY USING CHC RATE FOR 32 OR MORE UNITS (8 - 24 HOURS)
      *      - 1 UNIT = 15 MIN., DIVIDE BY 4 TO GET HOURS
      *      - DIVIDE DAILY CHC RATE BY 24 TO GET HOURLY RATE
      *---------------------------------------------------------------
              ELSE
                 COMPUTE WRK-PAY-RATE2 ROUNDED =
                         (((2019-V190-CHC-LS-RATE-Q *
                            BILL-BENE-WAGE-INDEX) +
                            2019-V190-CHC-NLS-RATE-Q) / 24) *
                            (BILL-UNITS2 / 4)
              END-IF
      
              GO TO 2019-V190-CHC-0652-EXIT
      
           END-IF.
      
      
      ****============================================================
      **** CHC - NO QIP REDUCTION  CODE = 0652
      ****============================================================
           IF BILL-QIP-IND NOT = '1'
      
      *---------------------------------------------------------------
      *    PAY 1 DAY USING THE RHC RATE IF LESS THAN 32 UNITS/8 HOURS
      *---------------------------------------------------------------
              IF BILL-UNITS2 < 32
      
      *---------------------------------------------------------------
      *  - USE HIGH RATE IF CHC DAY IS WITHIN 60 DAYS OF ADMISSION
      *---------------------------------------------------------------
                 IF PRIOR-SVC-DAYS < 60
                    COMPUTE WRK-PAY-RATE2 ROUNDED =
                            ((2019-V190-HIGH-RHC-LS-RATE *
                              BILL-BENE-WAGE-INDEX) +
                              2019-V190-HIGH-RHC-NLS-RATE)
      
      *---------------------------------------------------------------
      *  - USE LOW RATE IF CHC DAY ISN'T WITHIN 60 DAYS OF ADMISSION
      *---------------------------------------------------------------
                 ELSE
                    COMPUTE WRK-PAY-RATE2 ROUNDED =
                            ((2019-V190-LOW-RHC-LS-RATE *
                              BILL-BENE-WAGE-INDEX) +
                              2019-V190-LOW-RHC-NLS-RATE)
                 END-IF
      
      *---------------------------------------------------------------
      *    PAY USING CHC RATE FOR 32 OR MORE UNITS (8 - 24 HOURS)
      *        - 1 UNIT = 15 MIN., DIVIDE BY 4 TO GET HOURS
      *        - DIVIDE DAILY CHC RATE BY 24 TO GET HOURLY RATE
      *---------------------------------------------------------------
              ELSE
                   COMPUTE WRK-PAY-RATE2 ROUNDED =
                           (((2019-V190-CHC-LS-RATE *
                              BILL-BENE-WAGE-INDEX) +
                              2019-V190-CHC-NLS-RATE) / 24) *
                              (BILL-UNITS2 / 4)
              END-IF
           END-IF.
      
      
       2019-V190-CHC-0652-EXIT.
           EXIT.
      
      
      
      ****************************************************************
      **** V16.1 IRC - INPATIENT RESPITE CARE = REVENUE CODE = 0655
      ****************************************************************
       2019-V190-IRC-0655.
      
      ****============================================================
      **** CALCULATE IRC PAYMENT WITH QIP REDUCTION (1 UNIT = 1 DAY)
      ****============================================================
           IF BILL-QIP-IND = '1'
              COMPUTE WRK-PAY-RATE3 ROUNDED =
                     ((2019-V190-IRC-LS-RATE-Q * BILL-PROV-WAGE-INDEX)
                       + 2019-V190-IRC-NLS-RATE-Q) *  BILL-UNITS3
      
      ****============================================================
      **** CALCULATE IRC PAYMENT W/OUT QIP REDUCTION (1 UNIT = 1 DAY)
      ****============================================================
           ELSE
              COMPUTE WRK-PAY-RATE3 ROUNDED =
                     ((2019-V190-IRC-LS-RATE * BILL-PROV-WAGE-INDEX)
                       + 2019-V190-IRC-NLS-RATE) *  BILL-UNITS3
           END-IF.
      
      
       2019-V190-IRC-0655-EXIT.
           EXIT.
      
      
      
      ****************************************************************
      ****    GIC - GENERAL INPATIENT CARE = REVENUE CODE = 0656
      ****************************************************************
       2019-V190-GIC-0656.
      
      ****============================================================
      **** CALCULATE GIC PAYMENT WITH QIP REDUCTION (1 UNIT = 1 DAY)
      ****============================================================
           IF BILL-QIP-IND = '1'
              COMPUTE WRK-PAY-RATE4 ROUNDED =
                     ((2019-V190-GIC-LS-RATE-Q * BILL-PROV-WAGE-INDEX)
                       + 2019-V190-GIC-NLS-RATE-Q) *  BILL-UNITS4
      
      ****============================================================
      **** CALCULATE GIC PAYMENT W/OUT QIP REDUCTION (1 UNIT = 1 DAY)
      ****============================================================
           ELSE
              COMPUTE WRK-PAY-RATE4 ROUNDED =
                     ((2019-V190-GIC-LS-RATE * BILL-PROV-WAGE-INDEX)
                       + 2019-V190-GIC-NLS-RATE) *  BILL-UNITS4
           END-IF.
      
       2019-V190-GIC-0656-EXIT.
           EXIT.
      
      
      
      ****************************************************************
       V190-CALC-PRIOR-SVC-DAYS.
      ****************************************************************
      
      *---------------------------------------------------------------
      * GET ADMISSION DATE (SERVICE DATE SET PRIOR TO THIS PARAGRAPH)
      *---------------------------------------------------------------
           MOVE BILL-ADMISSION-DATE TO DATE-1-ADM.
      
      
      *---------------------------------------------------------------
      * CONVERT ADMISSION AND SERVICE DATES INTO INTEGERS
      *---------------------------------------------------------------
           COMPUTE DATE-1-ADM-INTEGER =
                   FUNCTION INTEGER-OF-DATE (DATE-1-ADM).
      
           COMPUTE DATE-2-DOS-INTEGER =
                   FUNCTION INTEGER-OF-DATE (DATE-2-DOS).
      
      
      *---------------------------------------------------------------
      * CALCULATE DAYS ELAPSED BETWEEN ADMISSION AND SERVICE DATES
      *---------------------------------------------------------------
           COMPUTE DAYS-BETWEEN-DATES =
                   DATE-2-DOS-INTEGER - DATE-1-ADM-INTEGER.
      
      
      *---------------------------------------------------------------
      * DETERMINE THE NUMBER OF PRIOR BENEFIT DAYS
      *---------------------------------------------------------------
           IF BILL-NA-ADD-ON-DAY1-UNITS > ZEROES
               COMPUTE PRIOR-BENEFIT-DAYS = BILL-NA-ADD-ON-DAY1-UNITS
           ELSE
               MOVE ZERO TO PRIOR-BENEFIT-DAYS
           END-IF.
      
      
      *---------------------------------------------------------------
      * CALCULATE TOTAL DAYS SINCE ADMISSION & BEFORE SERVICE DATE
      *---------------------------------------------------------------
           COMPUTE PRIOR-SVC-DAYS =
                   DAYS-BETWEEN-DATES + PRIOR-BENEFIT-DAYS.
      
      
       V190-CALC-PRIOR-SVC-DAYS-EXIT.
           EXIT.
      
      
      
      ****========^^^^^  BEGIN FY 2020 LOGIC ^^^^^================****
      ****==============  BEGIN V200 PROCESS  ====================****
      ****======  VALID FROM 10/01/2019 THRU 09/30/2020  =========****
      ****========================================================****
      
      
      
      
      ****************************************************************
      **** V200   MAINLINE PROCESS FOR V200
      ****************************************************************
       2020-V200-PROCESS-DATA.
      
      
      *---------------------------------------------------------------
      *  VALIDATE BILL INPUT DATA - UNITS
      *---------------------------------------------------------------
           IF BILL-UNITS1 > 1000 OR
              BILL-UNITS2 > 1000 OR
              BILL-UNITS3 > 1000 OR
              BILL-UNITS4 > 1000
              MOVE '10' TO BILL-RTC
              GO TO 2020-V200-PROCESS-EXIT
           END-IF.
      
      
      *---------------------------------------------------------------
      *  CALCULATE PAYMENT FOR EACH LEVEL OF CARE BY REVENUE CODE
      *---------------------------------------------------------------
           IF BILL-REV1 = '0651'
              PERFORM 2020-V200-RHC-0651
                 THRU 2020-V200-RHC-0651-EXIT.
      
      
           IF BILL-REV2 = '0652'
              PERFORM 2020-V200-CHC-0652
                 THRU 2020-V200-CHC-0652-EXIT.
      
      
           IF BILL-REV3 = '0655'
              PERFORM 2020-V200-IRC-0655
                 THRU 2020-V200-IRC-0655-EXIT.
      
      
           IF BILL-REV4 = '0656'
              PERFORM 2020-V200-GIC-0656
                 THRU 2020-V200-GIC-0656-EXIT.
      
      
      *---------------------------------------------------------------
      *  CALCULATE TOTAL CLAIM PAYMENT
      *---------------------------------------------------------------
           COMPUTE BILL-PAY-AMT-TOTAL =
                   WRK-PAY-RATE1 +
                   WRK-PAY-RATE2 +
                   WRK-PAY-RATE3 +
                   WRK-PAY-RATE4 +
                   SIA-PAY-AMT-TOTAL.
      
      
      *---------------------------------------------------------------
      *  MOVE EACH LEVEL OF CARE'S PAYMENT TO THE OUTPUT RECORD
      *---------------------------------------------------------------
           MOVE WRK-PAY-RATE1        TO  BILL-PAY-AMT1.
           MOVE WRK-PAY-RATE2        TO  BILL-PAY-AMT2.
           MOVE WRK-PAY-RATE3        TO  BILL-PAY-AMT3.
           MOVE WRK-PAY-RATE4        TO  BILL-PAY-AMT4.
      
      
      *---------------------------------------------------------------
      *  INITIALIZE WORKING STORAGE PAYMENT VARIABLES
      *---------------------------------------------------------------
           MOVE ZEROES               TO WRK-PAY-RATE1
                                        WRK-PAY-RATE2
                                        WRK-PAY-RATE3
                                        WRK-PAY-RATE4.
      
       2020-V200-PROCESS-EXIT.
           EXIT.
      
      
      
      ****************************************************************
      **** V200   RHC - ROUTINE HOME CARE = REVENUE CODE = 0651
      ****************************************************************
       2020-V200-RHC-0651.
      
      
      *==================================================
      *  >>> IF REVENUE CODE '0651' UNITS > 0         <<<
      *  >>> [THE DAY IS AN RHC LEVEL OF CARE DAY]    <<<
      *  >>> 1 UNIT = 1 DAY                           <<<
      *==================================================
           IF BILL-UNITS1 NOT > 0
              GO TO 2020-V200-RHC-0651-EXIT
           END-IF.
      
      
      *---------------------------------------------------------------
      * DATE ERROR - CANNOT CONTINUE RHC LEVEL OF CARE DAY PROCESSING
      *---------------------------------------------------------------
           IF BILL-LINE-ITEM-DOS1 < BILL-ADMISSION-DATE
              GO TO 2020-V200-RHC-0651-EXIT
           END-IF.
      
      
      *---------------------------------------------------------------
      * CALCULATE RHC LEVEL OF CARE DAY PAYMENT
      *---------------------------------------------------------------
      
           MOVE BILL-LINE-ITEM-DOS1 TO DATE-2-DOS.
           PERFORM V200-CALC-PRIOR-SVC-DAYS
              THRU V200-CALC-PRIOR-SVC-DAYS-EXIT.
      
           PERFORM V200-EVAL-RHC-DAYS
              THRU V200-EVAL-RHC-DAYS-EXIT.
      
           PERFORM V200-CALC-RHC-EOL-SIA
              THRU V200-CALC-RHC-EOL-SIA-EXIT.
      
           PERFORM V200-SUM-RHC-0651-RATE
              THRU V200-SUM-RHC-0651-RATE-EXIT.
      
      
       2020-V200-RHC-0651-EXIT.
           EXIT.
      
      
      
      ****************************************************************
       V200-EVAL-RHC-DAYS.
      ****************************************************************
      
      *---------------------------------------------------------------
      * SERVICE BEYOND 60TH DAY - APPLY RHC LOW RATE TO ALL RHC DAYS
      *---------------------------------------------------------------
           IF PRIOR-SVC-DAYS >= 60
              MOVE BILL-UNITS1 TO LR-BILL-UNITS1
              PERFORM V200-APPLY-LOW-RHC-RATE
                 THRU V200-APPLY-LOW-RHC-RATE-EXIT
              GO TO V200-EVAL-RHC-DAYS-EXIT
           END-IF.
      
      
      *---------------------------------------------------------------
      * SERVICE ON 60TH DAY OR EARLIER - APPLY RHC HIGH/LOW RATES
      *---------------------------------------------------------------
           IF PRIOR-SVC-DAYS < 60
              COMPUTE HIGH-RATE-DAYS-LEFT = 60 - PRIOR-SVC-DAYS
      
      
      *---------------------------------------------------------------
      * - RHC DAYS <= HIGH RATE DAYS LEFT - APPLY RHC HIGH RATE TO ALL
      *---------------------------------------------------------------
              IF BILL-UNITS1 <= HIGH-RATE-DAYS-LEFT
                 MOVE BILL-UNITS1 TO HR-BILL-UNITS1
                 PERFORM V200-APPLY-HIGH-RHC-RATE
                    THRU V200-APPLY-HIGH-RHC-RATE-EXIT
                 GO TO V200-EVAL-RHC-DAYS-EXIT
      
      
      *---------------------------------------------------------------
      * - RHC DAYS > HIGH RATE DAYS LEFT - APPLY RHC HIGH & LOW RATES
      *---------------------------------------------------------------
              ELSE
      
                 MOVE HIGH-RATE-DAYS-LEFT TO HR-BILL-UNITS1
                 PERFORM V200-APPLY-HIGH-RHC-RATE
                    THRU V200-APPLY-HIGH-RHC-RATE-EXIT
      
                 COMPUTE LR-BILL-UNITS1 =
                         BILL-UNITS1 - HR-BILL-UNITS1
                 PERFORM V200-APPLY-LOW-RHC-RATE
                    THRU V200-APPLY-LOW-RHC-RATE-EXIT
      
              END-IF
           END-IF.
      
      
       V200-EVAL-RHC-DAYS-EXIT.
           EXIT.
      
      
      
      ****************************************************************
      **** V200    CALCULATE RHC LOW-RATE PAYMENT
      ****************************************************************
       V200-APPLY-LOW-RHC-RATE.
      
      *---------------------------------------------------------------
      * FY 2020- CR # 11411
      *---------------------------------------------------------------
      
           MOVE LR-BILL-UNITS1  TO BILL-LOW-RHC-DAYS.
      
      
      
      *---------------------------------------------------------------
      * QIP REDUCTION APPLIED
      *---------------------------------------------------------------
           IF BILL-QIP-IND = '1'
              COMPUTE LR-BILL-PAY-AMT1 ROUNDED =
                 ((2020-V200-LOW-RHC-LS-RATE-Q * BILL-BENE-WAGE-INDEX)
                 + 2020-V200-LOW-RHC-NLS-RATE-Q) *  LR-BILL-UNITS1
      
      *---------------------------------------------------------------
      * NO QIP REDUCTION
      *---------------------------------------------------------------
           ELSE
              COMPUTE LR-BILL-PAY-AMT1 ROUNDED =
                 ((2020-V200-LOW-RHC-LS-RATE * BILL-BENE-WAGE-INDEX)
                 + 2020-V200-LOW-RHC-NLS-RATE) *  LR-BILL-UNITS1
           END-IF.
      
           MOVE 'Y' TO RHC-LOW-DAY-IND.
      
      
       V200-APPLY-LOW-RHC-RATE-EXIT.
           EXIT.
      
      
      
      ****************************************************************
      **** V200   CALCULATE RHC HIGH-RATE PAYMENT
      ****************************************************************
       V200-APPLY-HIGH-RHC-RATE.
      
      
      *---------------------------------------------------------------
      * FY 2020- CR # 11411
      *---------------------------------------------------------------
      
           MOVE HR-BILL-UNITS1  TO BILL-HIGH-RHC-DAYS.
      
      *---------------------------------------------------------------
      * QIP REDUCTION APPLIED
      *---------------------------------------------------------------
           IF BILL-QIP-IND = '1'
              COMPUTE HR-BILL-PAY-AMT1 ROUNDED =
                 ((2020-V200-HIGH-RHC-LS-RATE-Q * BILL-BENE-WAGE-INDEX)
                 + 2020-V200-HIGH-RHC-NLS-RATE-Q) *  HR-BILL-UNITS1
      
      *---------------------------------------------------------------
      * NO QIP REDUCTION
      *---------------------------------------------------------------
           ELSE
              COMPUTE HR-BILL-PAY-AMT1 ROUNDED =
                 ((2020-V200-HIGH-RHC-LS-RATE * BILL-BENE-WAGE-INDEX)
                 + 2020-V200-HIGH-RHC-NLS-RATE) *  HR-BILL-UNITS1
           END-IF.
      
           MOVE 'Y' TO RHC-HIGH-DAY-IND.
      
      
       V200-APPLY-HIGH-RHC-RATE-EXIT.
           EXIT.
      
      
      
      ****************************************************************
      **** V200    CALCULATE END-OF-LIFE SERVICE-INTENSITY ADD-ON
      ****************************************************************
       V200-CALC-RHC-EOL-SIA.
      
      *===============================================================
      *  SET  INDICATOR  [SIA-UNITS-IND = 'Y']
      *  SIA INDICATOR WILL BE USED TO HELP DETERMINE THE CORRECT RTC
      *===============================================================
           IF  BILL-EOL-ADD-ON-DAY1-UNITS > ZEROES OR
               BILL-EOL-ADD-ON-DAY2-UNITS > ZEROES OR
               BILL-EOL-ADD-ON-DAY3-UNITS > ZEROES OR
               BILL-EOL-ADD-ON-DAY4-UNITS > ZEROES OR
               BILL-EOL-ADD-ON-DAY5-UNITS > ZEROES OR
               BILL-EOL-ADD-ON-DAY6-UNITS > ZEROES OR
               BILL-EOL-ADD-ON-DAY7-UNITS > ZEROES
      
               MOVE 'Y' TO SIA-UNITS-IND
           ELSE
               MOVE 'N' TO SIA-UNITS-IND
               GO TO V200-CALC-RHC-EOL-SIA-EXIT
           END-IF.
      
      
      *===============================================================
      *     IF ANY OF THE EOL FIELDS ARE GREATER THAN ZERO
      *     THEN COMPUTE THE >> CHC-WAGE-INDEXED-RATE << FOR
      *     SIA PAYMENT AMOUNT CALCULATION (QIP OR NON-QIP)
      *===============================================================
      
      *---------------------------------------------------------------
      * CALCULATE SIA PAYMENT RATE: HOURLY CHC RATE W/ QIP REDUCTION
      *---------------------------------------------------------------
           IF  BILL-QIP-IND = '1'
               COMPUTE SIA-PYMT-RATE ROUNDED =
                 (((2020-V200-CHC-LS-RATE-Q * BILL-BENE-WAGE-INDEX)
                      + 2020-V200-CHC-NLS-RATE-Q) / 24)
      
      *---------------------------------------------------------------
      * CALCULATE SIA PAYMENT RATE: HOURLY CHC RATE W/OUT QIP REDUCT.
      *---------------------------------------------------------------
           ELSE
               COMPUTE SIA-PYMT-RATE ROUNDED =
                 (((2020-V200-CHC-LS-RATE * BILL-BENE-WAGE-INDEX)
                      + 2020-V200-CHC-NLS-RATE) / 24)
           END-IF.
      
      
      *===============================================================
      *     CALCULATE END OF LIFE SIA PAYMENT FOR UP TO 7 DAYS
      *       - SIA UNITS IN 15 MIN BLOCKS - CONVERT TO HOURS
      *       - SIA PAYMENT AMT IS CAPPED AT 4 HOURS
      *===============================================================
      
      *---------------------------------------------------------------
      * CALCULATE >> DAY 1 EOL SIA PYMT UP TO 4 HRS, 1 UNIT = 15 MIN
      *---------------------------------------------------------------
           IF  BILL-EOL-ADD-ON-DAY1-UNITS > ZEROES
               COMPUTE EOL-UNITS1 = BILL-EOL-ADD-ON-DAY1-UNITS
      
               IF EOL-UNITS1 >= 16
                   MOVE 4 TO EOL-HOURS1
               ELSE
                   COMPUTE EOL-HOURS1 ROUNDED = (EOL-UNITS1 / 4)
               END-IF
      
               COMPUTE BILL-EOL-ADD-ON-DAY1-PAY ROUNDED =
                       EOL-HOURS1 * SIA-PYMT-RATE
      
           END-IF.
      
      
      *---------------------------------------------------------------
      * CALCULATE >> DAY 2 EOL SIA PYMT UP TO 4 HRS, 1 UNIT = 15 MIN
      *---------------------------------------------------------------
           IF  BILL-EOL-ADD-ON-DAY2-UNITS > ZEROES
               COMPUTE EOL-UNITS2 = BILL-EOL-ADD-ON-DAY2-UNITS
      
               IF EOL-UNITS2 >= 16
                   MOVE 4 TO EOL-HOURS2
               ELSE
                   COMPUTE EOL-HOURS2 ROUNDED = (EOL-UNITS2 / 4)
               END-IF
      
               COMPUTE BILL-EOL-ADD-ON-DAY2-PAY  ROUNDED =
                       EOL-HOURS2 * SIA-PYMT-RATE
           END-IF.
      
      
      *---------------------------------------------------------------
      * CALCULATE >> DAY 3 EOL SIA PYMT UP TO 4 HRS, 1 UNIT = 15 MIN
      *---------------------------------------------------------------
           IF  BILL-EOL-ADD-ON-DAY3-UNITS > ZEROES
               COMPUTE EOL-UNITS3 = BILL-EOL-ADD-ON-DAY3-UNITS
      
               IF EOL-UNITS3 >= 16
                   MOVE 4 TO EOL-HOURS3
               ELSE
                   COMPUTE EOL-HOURS3 ROUNDED = (EOL-UNITS3 / 4)
               END-IF
      
               COMPUTE BILL-EOL-ADD-ON-DAY3-PAY  ROUNDED =
                       EOL-HOURS3 * SIA-PYMT-RATE
           END-IF.
      
      
      *---------------------------------------------------------------
      * CALCULATE >> DAY 4 EOL SIA PYMT UP TO 4 HRS, 1 UNIT = 15 MIN
      *---------------------------------------------------------------
           IF  BILL-EOL-ADD-ON-DAY4-UNITS > ZEROES
               COMPUTE EOL-UNITS4 = BILL-EOL-ADD-ON-DAY4-UNITS
      
               IF EOL-UNITS4 >= 16
                   MOVE 4 TO EOL-HOURS4
               ELSE
                   COMPUTE EOL-HOURS4 ROUNDED = (EOL-UNITS4 / 4)
               END-IF
      
               COMPUTE BILL-EOL-ADD-ON-DAY4-PAY ROUNDED =
                       EOL-HOURS4 * SIA-PYMT-RATE
           END-IF.
      
      
      *---------------------------------------------------------------
      * CALCULATE >> DAY 5 EOL SIA PYMT UP TO 4 HRS, 1 UNIT = 15 MIN
      *---------------------------------------------------------------
           IF  BILL-EOL-ADD-ON-DAY5-UNITS > ZEROES
               COMPUTE EOL-UNITS5 = BILL-EOL-ADD-ON-DAY5-UNITS
      
               IF EOL-UNITS5 >= 16
                   MOVE 4 TO EOL-HOURS5
               ELSE
                   COMPUTE EOL-HOURS5 ROUNDED = (EOL-UNITS5 / 4)
               END-IF
      
               COMPUTE BILL-EOL-ADD-ON-DAY5-PAY ROUNDED =
                       EOL-HOURS5 * SIA-PYMT-RATE
           END-IF.
      
      
      *---------------------------------------------------------------
      * CALCULATE >> DAY 6 EOL SIA PYMT UP TO 4 HRS, 1 UNIT = 15 MIN
      *---------------------------------------------------------------
           IF  BILL-EOL-ADD-ON-DAY6-UNITS > ZEROES
               COMPUTE EOL-UNITS6 = BILL-EOL-ADD-ON-DAY6-UNITS
      
               IF EOL-UNITS6 >= 16
                   MOVE 4 TO EOL-HOURS6
               ELSE
                   COMPUTE EOL-HOURS6 ROUNDED = (EOL-UNITS6 / 4)
               END-IF
      
               COMPUTE BILL-EOL-ADD-ON-DAY6-PAY ROUNDED =
                       EOL-HOURS6 * SIA-PYMT-RATE
           END-IF.
      
      
      *---------------------------------------------------------------
      * CALCULATE >> DAY 7 EOL SIA PYMT UP TO 4 HRS, 1 UNIT = 15 MIN
      *---------------------------------------------------------------
           IF  BILL-EOL-ADD-ON-DAY7-UNITS > ZEROES
               COMPUTE EOL-UNITS7 = BILL-EOL-ADD-ON-DAY7-UNITS
      
               IF EOL-UNITS7 >= 16
                   MOVE 4 TO EOL-HOURS7
               ELSE
                   COMPUTE EOL-HOURS7 ROUNDED = (EOL-UNITS7 / 4)
               END-IF
      
               COMPUTE BILL-EOL-ADD-ON-DAY7-PAY ROUNDED =
                       EOL-HOURS7 * SIA-PYMT-RATE
           END-IF.
      
      
      *---------------------------------------------------------------
      *  CALCULATE >> TOTAL CLAIM EOL SIA ADD-ON PAYMENT
      *---------------------------------------------------------------
           COMPUTE SIA-PAY-AMT-TOTAL =
                   BILL-EOL-ADD-ON-DAY1-PAY +
                   BILL-EOL-ADD-ON-DAY2-PAY +
                   BILL-EOL-ADD-ON-DAY3-PAY +
                   BILL-EOL-ADD-ON-DAY4-PAY +
                   BILL-EOL-ADD-ON-DAY5-PAY +
                   BILL-EOL-ADD-ON-DAY6-PAY +
                   BILL-EOL-ADD-ON-DAY7-PAY.
      
      
       V200-CALC-RHC-EOL-SIA-EXIT.
           EXIT.
      
      
      
      ****************************************************************
      **** V19.B   RHC - SUM RHC '0651' COMPONENTS
      ****************************************************************
       V200-SUM-RHC-0651-RATE.
      
      
      ****============================================================
      **** CALCULATE TOTAL RHC PAYMENT
      ****============================================================
           COMPUTE WRK-PAY-RATE1 =
                   HR-BILL-PAY-AMT1 + LR-BILL-PAY-AMT1.
      
      
      ****============================================================
      **** ASSIGN RHC RETURN CODE (RTC)
      ****============================================================
      
      *---------------------------------------------------------------
      * END-OF-LIFE (EOL) SERVICE INTENSITY (SIA) ADD-ON PRESENT
      *---------------------------------------------------------------
           IF SIA-UNITS-IND = 'Y'
      
      *---------------------------------------------------------------
      *     HIGH RHC RATE (APPLIES TO SOME OR ALL RHC) & EOL SIA
      *---------------------------------------------------------------
              IF RHC-HIGH-DAY-IND = 'Y'
                 MOVE '77' TO BILL-RTC
      
      *---------------------------------------------------------------
      *     LOW RHC RATE APPLIES TO ALL RHC & EOL SIA
      *---------------------------------------------------------------
              ELSE
                 IF RHC-LOW-DAY-IND = 'Y'
                    MOVE '74' TO BILL-RTC
                 END-IF
              END-IF
           END-IF.
      
      
      *---------------------------------------------------------------
      * END-OF-LIFE (EOL) SERVICE INTENSITY ADD-ON (SIA) NOT PRESENT
      *---------------------------------------------------------------
           IF SIA-UNITS-IND = 'N'
      
      *---------------------------------------------------------------
      *     HIGH RHC RATE (APPLIES TO SOME OR ALL RHC) & NO EOL SIA
      *---------------------------------------------------------------
              IF RHC-HIGH-DAY-IND = 'Y'
                 MOVE '75' TO BILL-RTC
      
      *---------------------------------------------------------------
      *     LOW RHC RATE APPLIES TO ALL RHC & NO EOL SIA
      *---------------------------------------------------------------
              ELSE
                 IF RHC-LOW-DAY-IND = 'Y'
                    MOVE '73' TO BILL-RTC
                 END-IF
              END-IF
           END-IF.
      
      
       V200-SUM-RHC-0651-RATE-EXIT.
           EXIT.
      
      
      
      ****************************************************************
      **** V20.0   CHC - CONTINUOUS HOME CARE = REVENUE CODE = 0652
      ****************************************************************
       2020-V200-CHC-0652.
      
      *==================================================
      *  >>> IF REVENUE CODE '0652' UNITS > 0         <<<
      *  >>> [THE DAY IS A CHC LEVEL OF CARE DAY]     <<<
      *  >>> 1 UNIT = 15 MIN.                         <<<
      *==================================================
           IF BILL-UNITS2 NOT > 0
              GO TO 2020-V200-CHC-0652-EXIT
           END-IF.
      
      
      *---------------------------------------------------------------
      * IF USING THE RHC RATE (LESS THAN 32 UNITS/8 HOURS):
      *    CALCULATE NUMBER OF SERVICE DAYS PRIOR TO CHC SERVICE DATE
      *---------------------------------------------------------------
           IF BILL-UNITS2 < 32
              INITIALIZE DATE-CALCULATION-FIELDS
              MOVE BILL-LINE-ITEM-DOS2 TO DATE-2-DOS
              PERFORM V200-CALC-PRIOR-SVC-DAYS
                 THRU V200-CALC-PRIOR-SVC-DAYS-EXIT
           END-IF.
      
      
      ****============================================================
      **** CHC - APPLY QIP REDUCTION
      ****============================================================
           IF BILL-QIP-IND = '1'
      
      *---------------------------------------------------------------
      *  PAY 1 DAY USING THE RHC RATE IF LESS THAN 32 UNITS/8 HOURS
      *---------------------------------------------------------------
              IF BILL-UNITS2 < 32
      
      *---------------------------------------------------------------
      *  - USE HIGH RATE IF CHC DAY IS WITHIN 60 DAYS OF ADMISSION
      *---------------------------------------------------------------
                 IF PRIOR-SVC-DAYS < 60
                    COMPUTE WRK-PAY-RATE2 ROUNDED =
                            ((2020-V200-HIGH-RHC-LS-RATE-Q *
                              BILL-BENE-WAGE-INDEX) +
                              2020-V200-HIGH-RHC-NLS-RATE-Q)
      
      *---------------------------------------------------------------
      *  - USE LOW RATE IF CHC DAY ISN'T WITHIN 60 DAYS OF ADMISSION
      *---------------------------------------------------------------
                 ELSE
                    COMPUTE WRK-PAY-RATE2 ROUNDED =
                            ((2020-V200-LOW-RHC-LS-RATE-Q *
                              BILL-BENE-WAGE-INDEX) +
                              2020-V200-LOW-RHC-NLS-RATE-Q)
                 END-IF
      
      
      *---------------------------------------------------------------
      *  PAY USING CHC RATE FOR 32 OR MORE UNITS (8 - 24 HOURS)
      *      - 1 UNIT = 15 MIN., DIVIDE BY 4 TO GET HOURS
      *      - DIVIDE DAILY CHC RATE BY 24 TO GET HOURLY RATE
      *---------------------------------------------------------------
              ELSE
                 COMPUTE WRK-PAY-RATE2 ROUNDED =
                         (((2020-V200-CHC-LS-RATE-Q *
                            BILL-BENE-WAGE-INDEX) +
                            2020-V200-CHC-NLS-RATE-Q) / 24) *
                            (BILL-UNITS2 / 4)
              END-IF
      
              GO TO 2020-V200-CHC-0652-EXIT
      
           END-IF.
      
      
      ****============================================================
      **** CHC - NO QIP REDUCTION  CODE = 0652
      ****============================================================
           IF BILL-QIP-IND NOT = '1'
      
      *---------------------------------------------------------------
      *    PAY 1 DAY USING THE RHC RATE IF LESS THAN 32 UNITS/8 HOURS
      *---------------------------------------------------------------
              IF BILL-UNITS2 < 32
      
      *---------------------------------------------------------------
      *  - USE HIGH RATE IF CHC DAY IS WITHIN 60 DAYS OF ADMISSION
      *---------------------------------------------------------------
                 IF PRIOR-SVC-DAYS < 60
                    COMPUTE WRK-PAY-RATE2 ROUNDED =
                            ((2020-V200-HIGH-RHC-LS-RATE *
                              BILL-BENE-WAGE-INDEX) +
                              2020-V200-HIGH-RHC-NLS-RATE)
      
      *---------------------------------------------------------------
      *  - USE LOW RATE IF CHC DAY ISN'T WITHIN 60 DAYS OF ADMISSION
      *---------------------------------------------------------------
                 ELSE
                    COMPUTE WRK-PAY-RATE2 ROUNDED =
                            ((2020-V200-LOW-RHC-LS-RATE *
                              BILL-BENE-WAGE-INDEX) +
                              2020-V200-LOW-RHC-NLS-RATE)
                 END-IF
      
      *---------------------------------------------------------------
      *    PAY USING CHC RATE FOR 32 OR MORE UNITS (8 - 24 HOURS)
      *        - 1 UNIT = 15 MIN., DIVIDE BY 4 TO GET HOURS
      *        - DIVIDE DAILY CHC RATE BY 24 TO GET HOURLY RATE
      *---------------------------------------------------------------
              ELSE
                   COMPUTE WRK-PAY-RATE2 ROUNDED =
                           (((2020-V200-CHC-LS-RATE *
                              BILL-BENE-WAGE-INDEX) +
                              2020-V200-CHC-NLS-RATE) / 24) *
                              (BILL-UNITS2 / 4)
              END-IF
           END-IF.
      
      
       2020-V200-CHC-0652-EXIT.
           EXIT.
      
      
      
      ****************************************************************
      **** V20.0 IRC - INPATIENT RESPITE CARE = REVENUE CODE = 0655
      ****************************************************************
       2020-V200-IRC-0655.
      
      ****============================================================
      **** CALCULATE IRC PAYMENT WITH QIP REDUCTION (1 UNIT = 1 DAY)
      ****============================================================
           IF BILL-QIP-IND = '1'
              COMPUTE WRK-PAY-RATE3 ROUNDED =
                     ((2020-V200-IRC-LS-RATE-Q * BILL-PROV-WAGE-INDEX)
                       + 2020-V200-IRC-NLS-RATE-Q) *  BILL-UNITS3
      
      ****============================================================
      **** CALCULATE IRC PAYMENT W/OUT QIP REDUCTION (1 UNIT = 1 DAY)
      ****============================================================
           ELSE
              COMPUTE WRK-PAY-RATE3 ROUNDED =
                     ((2020-V200-IRC-LS-RATE * BILL-PROV-WAGE-INDEX)
                       + 2020-V200-IRC-NLS-RATE) *  BILL-UNITS3
           END-IF.
      
      
       2020-V200-IRC-0655-EXIT.
           EXIT.
      
      
      
      ****************************************************************
      ****    GIC - GENERAL INPATIENT CARE = REVENUE CODE = 0656
      ****************************************************************
       2020-V200-GIC-0656.
      
      ****============================================================
      **** CALCULATE GIC PAYMENT WITH QIP REDUCTION (1 UNIT = 1 DAY)
      ****============================================================
           IF BILL-QIP-IND = '1'
              COMPUTE WRK-PAY-RATE4 ROUNDED =
                     ((2020-V200-GIC-LS-RATE-Q * BILL-PROV-WAGE-INDEX)
                       + 2020-V200-GIC-NLS-RATE-Q) *  BILL-UNITS4
      
      ****============================================================
      **** CALCULATE GIC PAYMENT W/OUT QIP REDUCTION (1 UNIT = 1 DAY)
      ****============================================================
           ELSE
              COMPUTE WRK-PAY-RATE4 ROUNDED =
                     ((2020-V200-GIC-LS-RATE * BILL-PROV-WAGE-INDEX)
                       + 2020-V200-GIC-NLS-RATE) *  BILL-UNITS4
           END-IF.
      
       2020-V200-GIC-0656-EXIT.
           EXIT.
      
      
      
      ****************************************************************
       V200-CALC-PRIOR-SVC-DAYS.
      ****************************************************************
      
      *---------------------------------------------------------------
      * GET ADMISSION DATE (SERVICE DATE SET PRIOR TO THIS PARAGRAPH)
      *---------------------------------------------------------------
           MOVE BILL-ADMISSION-DATE TO DATE-1-ADM.
      
      
      *---------------------------------------------------------------
      * CONVERT ADMISSION AND SERVICE DATES INTO INTEGERS
      *---------------------------------------------------------------
           COMPUTE DATE-1-ADM-INTEGER =
                   FUNCTION INTEGER-OF-DATE (DATE-1-ADM).
      
           COMPUTE DATE-2-DOS-INTEGER =
                   FUNCTION INTEGER-OF-DATE (DATE-2-DOS).
      
      
      *---------------------------------------------------------------
      * CALCULATE DAYS ELAPSED BETWEEN ADMISSION AND SERVICE DATES
      *---------------------------------------------------------------
           COMPUTE DAYS-BETWEEN-DATES =
                   DATE-2-DOS-INTEGER - DATE-1-ADM-INTEGER.
      
      
      *---------------------------------------------------------------
      * DETERMINE THE NUMBER OF PRIOR BENEFIT DAYS
      *---------------------------------------------------------------
           IF BILL-NA-ADD-ON-DAY1-UNITS > ZEROES
               COMPUTE PRIOR-BENEFIT-DAYS = BILL-NA-ADD-ON-DAY1-UNITS
           ELSE
               MOVE ZERO TO PRIOR-BENEFIT-DAYS
           END-IF.
      
      
      *---------------------------------------------------------------
      * CALCULATE TOTAL DAYS SINCE ADMISSION & BEFORE SERVICE DATE
      *---------------------------------------------------------------
           COMPUTE PRIOR-SVC-DAYS =
                   DAYS-BETWEEN-DATES + PRIOR-BENEFIT-DAYS.
      
      
       V200-CALC-PRIOR-SVC-DAYS-EXIT.
           EXIT.
      
      
      
      
      
      ****^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^****
      ****=============  BEGIN FY 2021 LOGIC =====================****
      ****=========^^^^^  BEGIN V210 PROCESS  ^^^^^===============****
      ****======  VALID FROM 10/01/2020 THRU 09/30/2021  =========****
      ****========================================================****
      ****^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^****
      
      
      
      ****************************************************************
      **** V210   MAINLINE PROCESS FOR V210
      ****************************************************************
       2021-V210-PROCESS-DATA.
      
      
      *---------------------------------------------------------------
      *  VALIDATE BILL INPUT DATA - UNITS
      *---------------------------------------------------------------
           IF BILL-UNITS1 > 1000 OR
              BILL-UNITS2 > 1000 OR
              BILL-UNITS3 > 1000 OR
              BILL-UNITS4 > 1000
              MOVE '10' TO BILL-RTC
              GO TO 2021-V210-PROCESS-EXIT
           END-IF.
      
      
      *---------------------------------------------------------------
      *  CALCULATE PAYMENT FOR EACH LEVEL OF CARE BY REVENUE CODE
      *---------------------------------------------------------------
           IF BILL-REV1 = '0651'
              PERFORM 2021-V210-RHC-0651
                 THRU 2021-V210-RHC-0651-EXIT.
      
      
           IF BILL-REV2 = '0652'
              PERFORM 2021-V210-CHC-0652
                 THRU 2021-V210-CHC-0652-EXIT.
      
      
           IF BILL-REV3 = '0655'
              PERFORM 2021-V210-IRC-0655
                 THRU 2021-V210-IRC-0655-EXIT.
      
      
           IF BILL-REV4 = '0656'
              PERFORM 2021-V210-GIC-0656
                 THRU 2021-V210-GIC-0656-EXIT.
      
      
      *---------------------------------------------------------------
      *  CALCULATE TOTAL CLAIM PAYMENT
      *---------------------------------------------------------------
           COMPUTE BILL-PAY-AMT-TOTAL =
                   WRK-PAY-RATE1 +
                   WRK-PAY-RATE2 +
                   WRK-PAY-RATE3 +
                   WRK-PAY-RATE4 +
                   SIA-PAY-AMT-TOTAL.
      
      *---------------------------------------------------------------
      *  MOVE EACH LEVEL OF CARE'S PAYMENT TO THE OUTPUT RECORD
      *---------------------------------------------------------------
           MOVE WRK-PAY-RATE1        TO  BILL-PAY-AMT1.
           MOVE WRK-PAY-RATE2        TO  BILL-PAY-AMT2.
           MOVE WRK-PAY-RATE3        TO  BILL-PAY-AMT3.
           MOVE WRK-PAY-RATE4        TO  BILL-PAY-AMT4.
      
      
      *---------------------------------------------------------------
      *  INITIALIZE WORKING STORAGE PAYMENT VARIABLES
      *---------------------------------------------------------------
           MOVE ZEROES               TO WRK-PAY-RATE1
                                        WRK-PAY-RATE2
                                        WRK-PAY-RATE3
                                        WRK-PAY-RATE4.
      
       2021-V210-PROCESS-EXIT.
           EXIT.
      
      
      
      ****************************************************************
      **** V210   RHC - ROUTINE HOME CARE = REVENUE CODE = 0651
      ****************************************************************
       2021-V210-RHC-0651.
      
      
      *==================================================
      *  >>> IF REVENUE CODE '0651' UNITS > 0         <<<
      *  >>> [THE DAY IS AN RHC LEVEL OF CARE DAY]    <<<
      *  >>> 1 UNIT = 1 DAY                           <<<
      *==================================================
           IF BILL-UNITS1 NOT > 0
              GO TO 2021-V210-RHC-0651-EXIT
           END-IF.
      
      
      *---------------------------------------------------------------
      * DATE ERROR - CANNOT CONTINUE RHC LEVEL OF CARE DAY PROCESSING
      *---------------------------------------------------------------
           IF BILL-LINE-ITEM-DOS1 < BILL-ADMISSION-DATE
              GO TO 2021-V210-RHC-0651-EXIT
           END-IF.
      
      
      *---------------------------------------------------------------
      * CALCULATE RHC LEVEL OF CARE DAY PAYMENT
      *---------------------------------------------------------------
      
           MOVE BILL-LINE-ITEM-DOS1 TO DATE-2-DOS.
           PERFORM V210-CALC-PRIOR-SVC-DAYS
              THRU V210-CALC-PRIOR-SVC-DAYS-EXIT.
      
           PERFORM V210-EVAL-RHC-DAYS
              THRU V210-EVAL-RHC-DAYS-EXIT.
      
           PERFORM V210-CALC-RHC-EOL-SIA
              THRU V210-CALC-RHC-EOL-SIA-EXIT.
      
           PERFORM V210-SUM-RHC-0651-RATE
              THRU V210-SUM-RHC-0651-RATE-EXIT.
      
      
       2021-V210-RHC-0651-EXIT.
           EXIT.
      
      
      
      ****************************************************************
       V210-EVAL-RHC-DAYS.
      ****************************************************************
      
      *---------------------------------------------------------------
      * SERVICE BEYOND 60TH DAY - APPLY RHC LOW RATE TO ALL RHC DAYS
      *---------------------------------------------------------------
           IF PRIOR-SVC-DAYS >= 60
              MOVE BILL-UNITS1 TO LR-BILL-UNITS1
              PERFORM V210-APPLY-LOW-RHC-RATE
                 THRU V210-APPLY-LOW-RHC-RATE-EXIT
              GO TO V210-EVAL-RHC-DAYS-EXIT
           END-IF.
      
      
      *---------------------------------------------------------------
      * SERVICE ON 60TH DAY OR EARLIER - APPLY RHC HIGH/LOW RATES
      *---------------------------------------------------------------
           IF PRIOR-SVC-DAYS < 60
              COMPUTE HIGH-RATE-DAYS-LEFT = 60 - PRIOR-SVC-DAYS
      
      
      *---------------------------------------------------------------
      * - RHC DAYS <= HIGH RATE DAYS LEFT - APPLY RHC HIGH RATE TO ALL
      *---------------------------------------------------------------
              IF BILL-UNITS1 <= HIGH-RATE-DAYS-LEFT
                 MOVE BILL-UNITS1 TO HR-BILL-UNITS1
                 PERFORM V210-APPLY-HIGH-RHC-RATE
                    THRU V210-APPLY-HIGH-RHC-RATE-EXIT
                 GO TO V210-EVAL-RHC-DAYS-EXIT
      
      
      *---------------------------------------------------------------
      * - RHC DAYS > HIGH RATE DAYS LEFT - APPLY RHC HIGH & LOW RATES
      *---------------------------------------------------------------
              ELSE
      
                 MOVE HIGH-RATE-DAYS-LEFT TO HR-BILL-UNITS1
                 PERFORM V210-APPLY-HIGH-RHC-RATE
                    THRU V210-APPLY-HIGH-RHC-RATE-EXIT
      
                 COMPUTE LR-BILL-UNITS1 =
                         BILL-UNITS1 - HR-BILL-UNITS1
                 PERFORM V210-APPLY-LOW-RHC-RATE
                    THRU V210-APPLY-LOW-RHC-RATE-EXIT
      
              END-IF
           END-IF.
      
      
       V210-EVAL-RHC-DAYS-EXIT.
           EXIT.
      
      
      
      ****************************************************************
      **** V210    CALCULATE RHC LOW-RATE PAYMENT
      ****************************************************************
       V210-APPLY-LOW-RHC-RATE.
      
      *---------------------------------------------------------------
      * FY 2021- CR # 11411
      *---------------------------------------------------------------
      
           MOVE LR-BILL-UNITS1  TO BILL-LOW-RHC-DAYS.
      
      
      
      *---------------------------------------------------------------
      * QIP REDUCTION APPLIED
      *---------------------------------------------------------------
           IF BILL-QIP-IND = '1'
              COMPUTE LR-BILL-PAY-AMT1 ROUNDED =
                 ((2021-V210-LOW-RHC-LS-RATE-Q * BILL-BENE-WAGE-INDEX)
                 + 2021-V210-LOW-RHC-NLS-RATE-Q) *  LR-BILL-UNITS1
      
      *---------------------------------------------------------------
      * NO QIP REDUCTION
      *---------------------------------------------------------------
           ELSE
              COMPUTE LR-BILL-PAY-AMT1 ROUNDED =
                 ((2021-V210-LOW-RHC-LS-RATE * BILL-BENE-WAGE-INDEX)
                 + 2021-V210-LOW-RHC-NLS-RATE) *  LR-BILL-UNITS1
           END-IF.
      
           MOVE 'Y' TO RHC-LOW-DAY-IND.
      
      
       V210-APPLY-LOW-RHC-RATE-EXIT.
           EXIT.
      
      
      
      ****************************************************************
      **** V210   CALCULATE RHC HIGH-RATE PAYMENT
      ****************************************************************
       V210-APPLY-HIGH-RHC-RATE.
      
      
      *---------------------------------------------------------------
      * FY 2020- CR # 11411
      *---------------------------------------------------------------
      
           MOVE HR-BILL-UNITS1  TO BILL-HIGH-RHC-DAYS.
      
      *---------------------------------------------------------------
      * QIP REDUCTION APPLIED
      *---------------------------------------------------------------
           IF BILL-QIP-IND = '1'
              COMPUTE HR-BILL-PAY-AMT1 ROUNDED =
                 ((2021-V210-HIGH-RHC-LS-RATE-Q * BILL-BENE-WAGE-INDEX)
                 + 2021-V210-HIGH-RHC-NLS-RATE-Q) *  HR-BILL-UNITS1
      
      *---------------------------------------------------------------
      * NO QIP REDUCTION
      *---------------------------------------------------------------
           ELSE
              COMPUTE HR-BILL-PAY-AMT1 ROUNDED =
                 ((2021-V210-HIGH-RHC-LS-RATE * BILL-BENE-WAGE-INDEX)
                 + 2021-V210-HIGH-RHC-NLS-RATE) *  HR-BILL-UNITS1
           END-IF.
      
           MOVE 'Y' TO RHC-HIGH-DAY-IND.
      
      
       V210-APPLY-HIGH-RHC-RATE-EXIT.
           EXIT.
      
      
      
      ****************************************************************
      **** V210    CALCULATE END-OF-LIFE SERVICE-INTENSITY ADD-ON
      ****************************************************************
       V210-CALC-RHC-EOL-SIA.
      
      *===============================================================
      *  SET  INDICATOR  [SIA-UNITS-IND = 'Y']
      *  SIA INDICATOR WILL BE USED TO HELP DETERMINE THE CORRECT RTC
      *===============================================================
           IF  BILL-EOL-ADD-ON-DAY1-UNITS > ZEROES OR
               BILL-EOL-ADD-ON-DAY2-UNITS > ZEROES OR
               BILL-EOL-ADD-ON-DAY3-UNITS > ZEROES OR
               BILL-EOL-ADD-ON-DAY4-UNITS > ZEROES OR
               BILL-EOL-ADD-ON-DAY5-UNITS > ZEROES OR
               BILL-EOL-ADD-ON-DAY6-UNITS > ZEROES OR
               BILL-EOL-ADD-ON-DAY7-UNITS > ZEROES
      
               MOVE 'Y' TO SIA-UNITS-IND
           ELSE
               MOVE 'N' TO SIA-UNITS-IND
               GO TO V210-CALC-RHC-EOL-SIA-EXIT
           END-IF.
      
      
      *===============================================================
      *     IF ANY OF THE EOL FIELDS ARE GREATER THAN ZERO
      *     THEN COMPUTE THE >> CHC-WAGE-INDEXED-RATE << FOR
      *     SIA PAYMENT AMOUNT CALCULATION (QIP OR NON-QIP)
      *===============================================================
      
      *---------------------------------------------------------------
      * CALCULATE SIA PAYMENT RATE: HOURLY CHC RATE W/ QIP REDUCTION
      *---------------------------------------------------------------
           IF  BILL-QIP-IND = '1'
               COMPUTE SIA-PYMT-RATE ROUNDED =
                 (((2021-V210-CHC-LS-RATE-Q * BILL-BENE-WAGE-INDEX)
                      + 2021-V210-CHC-NLS-RATE-Q) / 24)
      
      *---------------------------------------------------------------
      * CALCULATE SIA PAYMENT RATE: HOURLY CHC RATE W/OUT QIP REDUCT.
      *---------------------------------------------------------------
           ELSE
               COMPUTE SIA-PYMT-RATE ROUNDED =
                 (((2021-V210-CHC-LS-RATE * BILL-BENE-WAGE-INDEX)
                      + 2021-V210-CHC-NLS-RATE) / 24)
           END-IF.
      
      
      *===============================================================
      *     CALCULATE END OF LIFE SIA PAYMENT FOR UP TO 7 DAYS
      *       - SIA UNITS IN 15 MIN BLOCKS - CONVERT TO HOURS
      *       - SIA PAYMENT AMT IS CAPPED AT 4 HOURS
      *===============================================================
      
      *---------------------------------------------------------------
      * CALCULATE >> DAY 1 EOL SIA PYMT UP TO 4 HRS, 1 UNIT = 15 MIN
      *---------------------------------------------------------------
           IF  BILL-EOL-ADD-ON-DAY1-UNITS > ZEROES
               COMPUTE EOL-UNITS1 = BILL-EOL-ADD-ON-DAY1-UNITS
      
               IF EOL-UNITS1 >= 16
                   MOVE 4 TO EOL-HOURS1
               ELSE
                   COMPUTE EOL-HOURS1 ROUNDED = (EOL-UNITS1 / 4)
               END-IF
      
               COMPUTE BILL-EOL-ADD-ON-DAY1-PAY ROUNDED =
                       EOL-HOURS1 * SIA-PYMT-RATE
      
           END-IF.
      
      
      *---------------------------------------------------------------
      * CALCULATE >> DAY 2 EOL SIA PYMT UP TO 4 HRS, 1 UNIT = 15 MIN
      *---------------------------------------------------------------
           IF  BILL-EOL-ADD-ON-DAY2-UNITS > ZEROES
               COMPUTE EOL-UNITS2 = BILL-EOL-ADD-ON-DAY2-UNITS
      
               IF EOL-UNITS2 >= 16
                   MOVE 4 TO EOL-HOURS2
               ELSE
                   COMPUTE EOL-HOURS2 ROUNDED = (EOL-UNITS2 / 4)
               END-IF
      
               COMPUTE BILL-EOL-ADD-ON-DAY2-PAY  ROUNDED =
                       EOL-HOURS2 * SIA-PYMT-RATE
           END-IF.
      
      
      *---------------------------------------------------------------
      * CALCULATE >> DAY 3 EOL SIA PYMT UP TO 4 HRS, 1 UNIT = 15 MIN
      *---------------------------------------------------------------
           IF  BILL-EOL-ADD-ON-DAY3-UNITS > ZEROES
               COMPUTE EOL-UNITS3 = BILL-EOL-ADD-ON-DAY3-UNITS
      
               IF EOL-UNITS3 >= 16
                   MOVE 4 TO EOL-HOURS3
               ELSE
                   COMPUTE EOL-HOURS3 ROUNDED = (EOL-UNITS3 / 4)
               END-IF
      
               COMPUTE BILL-EOL-ADD-ON-DAY3-PAY  ROUNDED =
                       EOL-HOURS3 * SIA-PYMT-RATE
           END-IF.
      
      
      *---------------------------------------------------------------
      * CALCULATE >> DAY 4 EOL SIA PYMT UP TO 4 HRS, 1 UNIT = 15 MIN
      *---------------------------------------------------------------
           IF  BILL-EOL-ADD-ON-DAY4-UNITS > ZEROES
               COMPUTE EOL-UNITS4 = BILL-EOL-ADD-ON-DAY4-UNITS
      
               IF EOL-UNITS4 >= 16
                   MOVE 4 TO EOL-HOURS4
               ELSE
                   COMPUTE EOL-HOURS4 ROUNDED = (EOL-UNITS4 / 4)
               END-IF
      
               COMPUTE BILL-EOL-ADD-ON-DAY4-PAY ROUNDED =
                       EOL-HOURS4 * SIA-PYMT-RATE
           END-IF.
      
      
      *---------------------------------------------------------------
      * CALCULATE >> DAY 5 EOL SIA PYMT UP TO 4 HRS, 1 UNIT = 15 MIN
      *---------------------------------------------------------------
           IF  BILL-EOL-ADD-ON-DAY5-UNITS > ZEROES
               COMPUTE EOL-UNITS5 = BILL-EOL-ADD-ON-DAY5-UNITS
      
               IF EOL-UNITS5 >= 16
                   MOVE 4 TO EOL-HOURS5
               ELSE
                   COMPUTE EOL-HOURS5 ROUNDED = (EOL-UNITS5 / 4)
               END-IF
      
               COMPUTE BILL-EOL-ADD-ON-DAY5-PAY ROUNDED =
                       EOL-HOURS5 * SIA-PYMT-RATE
           END-IF.
      
      
      *---------------------------------------------------------------
      * CALCULATE >> DAY 6 EOL SIA PYMT UP TO 4 HRS, 1 UNIT = 15 MIN
      *---------------------------------------------------------------
           IF  BILL-EOL-ADD-ON-DAY6-UNITS > ZEROES
               COMPUTE EOL-UNITS6 = BILL-EOL-ADD-ON-DAY6-UNITS
      
               IF EOL-UNITS6 >= 16
                   MOVE 4 TO EOL-HOURS6
               ELSE
                   COMPUTE EOL-HOURS6 ROUNDED = (EOL-UNITS6 / 4)
               END-IF
      
               COMPUTE BILL-EOL-ADD-ON-DAY6-PAY ROUNDED =
                       EOL-HOURS6 * SIA-PYMT-RATE
           END-IF.
      
      
      *---------------------------------------------------------------
      * CALCULATE >> DAY 7 EOL SIA PYMT UP TO 4 HRS, 1 UNIT = 15 MIN
      *---------------------------------------------------------------
           IF  BILL-EOL-ADD-ON-DAY7-UNITS > ZEROES
               COMPUTE EOL-UNITS7 = BILL-EOL-ADD-ON-DAY7-UNITS
      
               IF EOL-UNITS7 >= 16
                   MOVE 4 TO EOL-HOURS7
               ELSE
                   COMPUTE EOL-HOURS7 ROUNDED = (EOL-UNITS7 / 4)
               END-IF
      
               COMPUTE BILL-EOL-ADD-ON-DAY7-PAY ROUNDED =
                       EOL-HOURS7 * SIA-PYMT-RATE
           END-IF.
      
      
      *---------------------------------------------------------------
      *  CALCULATE >> TOTAL CLAIM EOL SIA ADD-ON PAYMENT
      *---------------------------------------------------------------
           COMPUTE SIA-PAY-AMT-TOTAL =
                   BILL-EOL-ADD-ON-DAY1-PAY +
                   BILL-EOL-ADD-ON-DAY2-PAY +
                   BILL-EOL-ADD-ON-DAY3-PAY +
                   BILL-EOL-ADD-ON-DAY4-PAY +
                   BILL-EOL-ADD-ON-DAY5-PAY +
                   BILL-EOL-ADD-ON-DAY6-PAY +
                   BILL-EOL-ADD-ON-DAY7-PAY.
      
       V210-CALC-RHC-EOL-SIA-EXIT.
           EXIT.
      
      
      
      ****************************************************************
      **** V21.0   RHC - SUM RHC '0651' COMPONENTS
      ****************************************************************
       V210-SUM-RHC-0651-RATE.
      
      
      ****============================================================
      **** CALCULATE TOTAL RHC PAYMENT
      ****============================================================
           COMPUTE WRK-PAY-RATE1 =
                   HR-BILL-PAY-AMT1 + LR-BILL-PAY-AMT1.
      
      
      ****============================================================
      **** ASSIGN RHC RETURN CODE (RTC)
      ****============================================================
      
      *---------------------------------------------------------------
      * END-OF-LIFE (EOL) SERVICE INTENSITY (SIA) ADD-ON PRESENT
      *---------------------------------------------------------------
           IF SIA-UNITS-IND = 'Y'
      
      *---------------------------------------------------------------
      *     HIGH RHC RATE (APPLIES TO SOME OR ALL RHC) & EOL SIA
      *---------------------------------------------------------------
              IF RHC-HIGH-DAY-IND = 'Y'
                 MOVE '77' TO BILL-RTC
      
      *---------------------------------------------------------------
      *     LOW RHC RATE APPLIES TO ALL RHC & EOL SIA
      *---------------------------------------------------------------
              ELSE
                 IF RHC-LOW-DAY-IND = 'Y'
                    MOVE '74' TO BILL-RTC
                 END-IF
              END-IF
           END-IF.
      
      
      *---------------------------------------------------------------
      * END-OF-LIFE (EOL) SERVICE INTENSITY ADD-ON (SIA) NOT PRESENT
      *---------------------------------------------------------------
           IF SIA-UNITS-IND = 'N'
      
      *---------------------------------------------------------------
      *     HIGH RHC RATE (APPLIES TO SOME OR ALL RHC) & NO EOL SIA
      *---------------------------------------------------------------
              IF RHC-HIGH-DAY-IND = 'Y'
                 MOVE '75' TO BILL-RTC
      
      *---------------------------------------------------------------
      *     LOW RHC RATE APPLIES TO ALL RHC & NO EOL SIA
      *---------------------------------------------------------------
              ELSE
                 IF RHC-LOW-DAY-IND = 'Y'
                    MOVE '73' TO BILL-RTC
                 END-IF
              END-IF
           END-IF.
      
      
       V210-SUM-RHC-0651-RATE-EXIT.
           EXIT.
      
      
      
      ****************************************************************
      **** V20.0   CHC - CONTINUOUS HOME CARE = REVENUE CODE = 0652
      ****************************************************************
       2021-V210-CHC-0652.
      
      *==================================================
      *  >>> IF REVENUE CODE '0652' UNITS > 0         <<<
      *  >>> [THE DAY IS A CHC LEVEL OF CARE DAY]     <<<
      *  >>> 1 UNIT = 15 MIN.                         <<<
      *==================================================
           IF BILL-UNITS2 NOT > 0
              GO TO 2021-V210-CHC-0652-EXIT
           END-IF.
      
      
      *---------------------------------------------------------------
      * IF USING THE RHC RATE (LESS THAN 32 UNITS/8 HOURS):
      *    CALCULATE NUMBER OF SERVICE DAYS PRIOR TO CHC SERVICE DATE
      *---------------------------------------------------------------
           IF BILL-UNITS2 < 32
              INITIALIZE DATE-CALCULATION-FIELDS
              MOVE BILL-LINE-ITEM-DOS2 TO DATE-2-DOS
              PERFORM V210-CALC-PRIOR-SVC-DAYS
                 THRU V210-CALC-PRIOR-SVC-DAYS-EXIT
           END-IF.
      
      
      ****============================================================
      **** CHC - APPLY QIP REDUCTION
      ****============================================================
           IF BILL-QIP-IND = '1'
      
      *---------------------------------------------------------------
      *  PAY 1 DAY USING THE RHC RATE IF LESS THAN 32 UNITS/8 HOURS
      *---------------------------------------------------------------
              IF BILL-UNITS2 < 32
      
      *---------------------------------------------------------------
      *  - USE HIGH RATE IF CHC DAY IS WITHIN 60 DAYS OF ADMISSION
      *---------------------------------------------------------------
                 IF PRIOR-SVC-DAYS < 60
                    COMPUTE WRK-PAY-RATE2 ROUNDED =
                            ((2021-V210-HIGH-RHC-LS-RATE-Q *
                              BILL-BENE-WAGE-INDEX) +
                              2021-V210-HIGH-RHC-NLS-RATE-Q)
      
      *---------------------------------------------------------------
      *  - USE LOW RATE IF CHC DAY ISN'T WITHIN 60 DAYS OF ADMISSION
      *---------------------------------------------------------------
                 ELSE
                    COMPUTE WRK-PAY-RATE2 ROUNDED =
                            ((2021-V210-LOW-RHC-LS-RATE-Q *
                              BILL-BENE-WAGE-INDEX) +
                              2021-V210-LOW-RHC-NLS-RATE-Q)
                 END-IF
      
      
      *---------------------------------------------------------------
      *  PAY USING CHC RATE FOR 32 OR MORE UNITS (8 - 24 HOURS)
      *      - 1 UNIT = 15 MIN., DIVIDE BY 4 TO GET HOURS
      *      - DIVIDE DAILY CHC RATE BY 24 TO GET HOURLY RATE
      *---------------------------------------------------------------
              ELSE
                 COMPUTE WRK-PAY-RATE2 ROUNDED =
                         (((2021-V210-CHC-LS-RATE-Q *
                            BILL-BENE-WAGE-INDEX) +
                            2021-V210-CHC-NLS-RATE-Q) / 24) *
                            (BILL-UNITS2 / 4)
              END-IF
      
              GO TO 2021-V210-CHC-0652-EXIT
      
           END-IF.
      
      
      ****============================================================
      **** CHC - NO QIP REDUCTION  CODE = 0652
      ****============================================================
           IF BILL-QIP-IND NOT = '1'
      
      *---------------------------------------------------------------
      *    PAY 1 DAY USING THE RHC RATE IF LESS THAN 32 UNITS/8 HOURS
      *---------------------------------------------------------------
              IF BILL-UNITS2 < 32
      
      *---------------------------------------------------------------
      *  - USE HIGH RATE IF CHC DAY IS WITHIN 60 DAYS OF ADMISSION
      *---------------------------------------------------------------
                 IF PRIOR-SVC-DAYS < 60
                    COMPUTE WRK-PAY-RATE2 ROUNDED =
                            ((2021-V210-HIGH-RHC-LS-RATE *
                              BILL-BENE-WAGE-INDEX) +
                              2021-V210-HIGH-RHC-NLS-RATE)
      
      *---------------------------------------------------------------
      *  - USE LOW RATE IF CHC DAY ISN'T WITHIN 60 DAYS OF ADMISSION
      *---------------------------------------------------------------
                 ELSE
                    COMPUTE WRK-PAY-RATE2 ROUNDED =
                            ((2021-V210-LOW-RHC-LS-RATE *
                              BILL-BENE-WAGE-INDEX) +
                              2021-V210-LOW-RHC-NLS-RATE)
                 END-IF
      
      *---------------------------------------------------------------
      *    PAY USING CHC RATE FOR 32 OR MORE UNITS (8 - 24 HOURS)
      *        - 1 UNIT = 15 MIN., DIVIDE BY 4 TO GET HOURS
      *        - DIVIDE DAILY CHC RATE BY 24 TO GET HOURLY RATE
      *---------------------------------------------------------------
              ELSE
                   COMPUTE WRK-PAY-RATE2 ROUNDED =
                           (((2021-V210-CHC-LS-RATE *
                              BILL-BENE-WAGE-INDEX) +
                              2021-V210-CHC-NLS-RATE) / 24) *
                              (BILL-UNITS2 / 4)
              END-IF
           END-IF.
      
      
       2021-V210-CHC-0652-EXIT.
           EXIT.
      
      
      
      ****************************************************************
      **** V20.0 IRC - INPATIENT RESPITE CARE = REVENUE CODE = 0655
      ****************************************************************
       2021-V210-IRC-0655.
      
      ****============================================================
      **** CALCULATE IRC PAYMENT WITH QIP REDUCTION (1 UNIT = 1 DAY)
      ****============================================================
           IF BILL-QIP-IND = '1'
              COMPUTE WRK-PAY-RATE3 ROUNDED =
                     ((2021-V210-IRC-LS-RATE-Q * BILL-PROV-WAGE-INDEX)
                       + 2021-V210-IRC-NLS-RATE-Q) *  BILL-UNITS3
      
      ****============================================================
      **** CALCULATE IRC PAYMENT W/OUT QIP REDUCTION (1 UNIT = 1 DAY)
      ****============================================================
           ELSE
              COMPUTE WRK-PAY-RATE3 ROUNDED =
                     ((2021-V210-IRC-LS-RATE * BILL-PROV-WAGE-INDEX)
                       + 2021-V210-IRC-NLS-RATE) *  BILL-UNITS3
           END-IF.
      
      
       2021-V210-IRC-0655-EXIT.
           EXIT.
      
      
      
      ****************************************************************
      ****    GIC - GENERAL INPATIENT CARE = REVENUE CODE = 0656
      ****************************************************************
       2021-V210-GIC-0656.
      
      ****============================================================
      **** CALCULATE GIC PAYMENT WITH QIP REDUCTION (1 UNIT = 1 DAY)
      ****============================================================
           IF BILL-QIP-IND = '1'
              COMPUTE WRK-PAY-RATE4 ROUNDED =
                     ((2021-V210-GIC-LS-RATE-Q * BILL-PROV-WAGE-INDEX)
                       + 2021-V210-GIC-NLS-RATE-Q) *  BILL-UNITS4
      
      ****============================================================
      **** CALCULATE GIC PAYMENT W/OUT QIP REDUCTION (1 UNIT = 1 DAY)
      ****============================================================
           ELSE
              COMPUTE WRK-PAY-RATE4 ROUNDED =
                     ((2021-V210-GIC-LS-RATE * BILL-PROV-WAGE-INDEX)
                       + 2021-V210-GIC-NLS-RATE) *  BILL-UNITS4
           END-IF.
      
       2021-V210-GIC-0656-EXIT.
           EXIT.
      
      
      
      ****************************************************************
       V210-CALC-PRIOR-SVC-DAYS.
      ****************************************************************
      
      *---------------------------------------------------------------
      * GET ADMISSION DATE (SERVICE DATE SET PRIOR TO THIS PARAGRAPH)
      *---------------------------------------------------------------
           MOVE BILL-ADMISSION-DATE TO DATE-1-ADM.
      
      
      *---------------------------------------------------------------
      * CONVERT ADMISSION AND SERVICE DATES INTO INTEGERS
      *---------------------------------------------------------------
           COMPUTE DATE-1-ADM-INTEGER =
                   FUNCTION INTEGER-OF-DATE (DATE-1-ADM).
      
           COMPUTE DATE-2-DOS-INTEGER =
                   FUNCTION INTEGER-OF-DATE (DATE-2-DOS).
      
      
      *---------------------------------------------------------------
      * CALCULATE DAYS ELAPSED BETWEEN ADMISSION AND SERVICE DATES
      *---------------------------------------------------------------
           COMPUTE DAYS-BETWEEN-DATES =
                   DATE-2-DOS-INTEGER - DATE-1-ADM-INTEGER.
      
      
      *---------------------------------------------------------------
      * DETERMINE THE NUMBER OF PRIOR BENEFIT DAYS
      *---------------------------------------------------------------
           IF BILL-NA-ADD-ON-DAY1-UNITS > ZEROES
               COMPUTE PRIOR-BENEFIT-DAYS = BILL-NA-ADD-ON-DAY1-UNITS
           ELSE
               MOVE ZERO TO PRIOR-BENEFIT-DAYS
           END-IF.
      
      
      *---------------------------------------------------------------
      * CALCULATE TOTAL DAYS SINCE ADMISSION & BEFORE SERVICE DATE
      *---------------------------------------------------------------
           COMPUTE PRIOR-SVC-DAYS =
                   DAYS-BETWEEN-DATES + PRIOR-BENEFIT-DAYS.
      
      
       V210-CALC-PRIOR-SVC-DAYS-EXIT.
           EXIT.
      
      
      
      
      
      ****=============  BEGIN FY 2020 LOGIC =====================****
      
      
      ****-------------------------------------------------------****
      ******     L A S T   S O U R C E   S T A T E M E N T     ******
      ****-------------------------------------------------------****

