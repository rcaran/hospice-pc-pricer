package com.cms.hospice.data;

import com.cms.hospice.model.WageIndexEntry;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Component;

import java.io.*;
import java.math.BigDecimal;
import java.nio.charset.StandardCharsets;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;

/**
 * Parses the CBSA wage index flat file (CBSA2021).
 *
 * Record format (80-byte fixed-width):
 * Positions (0-indexed):
 * 0–4 : CBSA code (5 chars, PIC 9(05))
 * 5 : space separator
 * 6–13 : effective date YYYYMMDD (PIC X(08))
 * 14 : space separator
 * 15–20: wage index (6 digits, PIC S9(02)V9(04)) → xx.xxxx
 * 21+ : filler / area name (ignored)
 *
 * Wage index decoding:
 * "008397" → 00.8397 → BigDecimal("0.8397")
 * "010000" → 01.0000 → BigDecimal("1.0000")
 * "011234" → 01.1234 → BigDecimal("1.1234")
 */
@Component
public class CbsaFileParser {

    private static final Logger log = LoggerFactory.getLogger(CbsaFileParser.class);
    private static final DateTimeFormatter DATE_FMT = DateTimeFormatter.ofPattern("yyyyMMdd");

    public List<WageIndexEntry> parse(InputStream input) throws IOException {
        List<WageIndexEntry> entries = new ArrayList<>();
        try (BufferedReader reader = new BufferedReader(
                new InputStreamReader(input, StandardCharsets.ISO_8859_1))) {
            String line;
            int lineNo = 0;
            while ((line = reader.readLine()) != null) {
                lineNo++;
                if (line.isBlank() || line.length() < 21) {
                    continue;
                }
                try {
                    String cbsaCode = line.substring(0, 5).trim();
                    String rawDate = line.substring(6, 14);
                    String rawWi = line.substring(15, 21);

                    if (cbsaCode.isEmpty() || rawDate.isBlank() || rawWi.isBlank()) {
                        continue;
                    }

                    LocalDate effectiveDate = LocalDate.parse(rawDate, DATE_FMT);
                    BigDecimal wageIndex = decodeWageIndex(rawWi);

                    entries.add(new WageIndexEntry(cbsaCode, effectiveDate, wageIndex));
                } catch (Exception e) {
                    log.warn("CBSA file: skipping line {} — {}", lineNo, e.getMessage());
                }
            }
        }
        log.info("CBSA file parsed: {} entries", entries.size());
        return entries;
    }

    /**
     * Decodes a 6-digit COBOL PIC S9(02)V9(04) wage index.
     * The implicit decimal point is after position 2 (0-indexed).
     * Example: "008397" → "00" integer + "8397" fraction → 0.8397
     */
    static BigDecimal decodeWageIndex(String raw) {
        if (raw.length() != 6) {
            throw new IllegalArgumentException("Expected 6-digit wage index, got: " + raw);
        }
        // Handle trailing overpunch sign nibble if present (positive = digit unchanged)
        String digits = raw.replaceAll("[^0-9]", "0"); // defensive: treat non-digits as zero
        String intPart = digits.substring(0, 2);
        String fracPart = digits.substring(2, 6);
        return new BigDecimal(intPart + "." + fracPart);
    }
}
