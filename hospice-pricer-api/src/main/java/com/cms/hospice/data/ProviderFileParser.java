package com.cms.hospice.data;

import com.cms.hospice.model.ProviderData;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Component;

import java.io.*;
import java.nio.charset.StandardCharsets;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;
import java.util.ArrayList;
import java.util.List;

/**
 * Parses the provider flat file (PROVFILE).
 *
 * Each record is LRECL=240 (3 × 80-byte segments concatenated on one line).
 *
 * Key field offsets (0-indexed within the 240-byte record):
 *
 * Segment 1 (bytes 0–79) – maps to PROV-NEWREC-HOLD1 / P-NEW-* fields:
 * 0–9 : NPI (PIC 9(10) with 2-byte filler → stored as 10 visible chars)
 * 10–15 : Provider number (PIC 9(02) state + FILLER PIC X(04))
 * 16–23 : Effective date YYYYMMDD
 * 24–31 : FY begin date YYYYMMDD
 * 56 : Current census division (PIC 9(01))
 * 57 : MSA change-code index (PIC X)
 * 58–61 : MSA geo-loc (P-NEW-GEO-LOC-MSAX, PIC X(04))
 *
 * Segment 2 (bytes 80–159) – maps to PROV-NEWREC-HOLD2 / P-NEW-VARIABLES +
 * P-NEW-CBSA-DATA:
 * 137 : CBSA spec-pay indicator (W-P-NEW-CBSA-SPEC-PAY-IND, PIC X)
 * 'N' = geographic, 'Y' = reclassified, '1'/'2' = special
 * 138 : CBSA hosp-qual indicator (PIC X)
 * 139–143: CBSA geo-loc (W-P-NEW-CBSA-GEO-LOC, PIC X(05)) ← primary CBSA lookup
 * key
 *
 * Only segments 1 and 2 fields are extracted; segment 3 (bytes 160–239) is not
 * used.
 */
@Component
public class ProviderFileParser {

    private static final Logger log = LoggerFactory.getLogger(ProviderFileParser.class);
    private static final DateTimeFormatter DATE_FMT = DateTimeFormatter.ofPattern("yyyyMMdd");

    private static final int MIN_RECORD_LEN = 144; // need at least through CBSA-GEO-LOC

    public List<ProviderData> parse(InputStream input) throws IOException {
        List<ProviderData> providers = new ArrayList<>();
        try (BufferedReader reader = new BufferedReader(
                new InputStreamReader(input, StandardCharsets.ISO_8859_1))) {
            String line;
            int lineNo = 0;
            while ((line = reader.readLine()) != null) {
                lineNo++;
                if (line.isBlank() || line.length() < MIN_RECORD_LEN) {
                    continue;
                }
                try {
                    ProviderData p = parseRecord(line);
                    if (p != null) {
                        providers.add(p);
                    }
                } catch (Exception e) {
                    log.warn("PROV file: skipping line {} — {}", lineNo, e.getMessage());
                }
            }
        }
        log.info("Provider file parsed: {} records", providers.size());
        return providers;
    }

    private ProviderData parseRecord(String rec) {
        // NPI: positions 0–9 (10 chars, may include trailing filler space)
        String npi = rec.substring(0, 10).trim();

        // Provider number: positions 10–15 (6 chars = 2-char state code + 4-char
        // sequence)
        String providerNumber = rec.substring(10, 16).trim();

        if (npi.isEmpty() && providerNumber.isEmpty()) {
            return null; // skip blank / filler records
        }

        // Effective date: positions 16–23
        LocalDate effectiveDate = parseDate(rec.substring(16, 24));
        if (effectiveDate == null) {
            return null;
        }

        // FY begin date: positions 24–31
        LocalDate fyBeginDate = parseDate(rec.substring(24, 32));

        // Census division: position 56 (1 char)
        String censusDivision = rec.substring(56, 57).trim();

        // MSA geo-loc: positions 58–61 (4 chars)
        String msaGeoLoc = rec.substring(58, 62).trim();

        // CBSA spec-pay indicator: position 137 (checked but not stored)
        // CBSA geo-loc: positions 139–143 (5 chars)
        String cbsaGeoLoc = "";
        if (rec.length() >= 144) {
            cbsaGeoLoc = rec.substring(139, 144).trim();
        }

        return new ProviderData(npi, providerNumber, effectiveDate, fyBeginDate,
                cbsaGeoLoc, msaGeoLoc, censusDivision);
    }

    private LocalDate parseDate(String raw) {
        if (raw == null || raw.isBlank() || "00000000".equals(raw.trim())) {
            return null;
        }
        try {
            return LocalDate.parse(raw.trim(), DATE_FMT);
        } catch (DateTimeParseException e) {
            return null;
        }
    }
}
