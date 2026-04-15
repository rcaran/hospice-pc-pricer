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
 * Parses the MSA wage index flat file (MSAFILE).
 *
 * Record format (80-byte fixed-width):
 * Positions (0-indexed):
 * 0–3 : MSA code (4 chars, PIC 9(04))
 * 4 : LUGAR flag (1 char, PIC X) – typically space or alpha
 * 5 : space separator
 * 6–13 : effective date YYYYMMDD (PIC X(08))
 * 14 : space separator
 * 15–20: wage index (6 digits, PIC S9(02)V9(04)) → xx.xxxx
 * 21+ : filler (ignored)
 *
 * Lookup key is MSA code only (4 chars). LUGAR is retained for future use.
 * Wage index decoding is identical to CbsaFileParser.
 */
@Component
public class MsaFileParser {

    private static final Logger log = LoggerFactory.getLogger(MsaFileParser.class);
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
                    String msaCode = line.substring(0, 4).trim();
                    // position 4 is LUGAR (ignored for lookup — MSA code is the key)
                    String rawDate = line.substring(6, 14);
                    String rawWi = line.substring(15, 21);

                    if (msaCode.isEmpty() || rawDate.isBlank() || rawWi.isBlank()) {
                        continue;
                    }

                    LocalDate effectiveDate = LocalDate.parse(rawDate, DATE_FMT);
                    BigDecimal wageIndex = CbsaFileParser.decodeWageIndex(rawWi);

                    entries.add(new WageIndexEntry(msaCode, effectiveDate, wageIndex));
                } catch (Exception e) {
                    log.warn("MSA file: skipping line {} — {}", lineNo, e.getMessage());
                }
            }
        }
        log.info("MSA file parsed: {} entries", entries.size());
        return entries;
    }
}
