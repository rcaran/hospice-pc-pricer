package com.cms.hospice.data;

import com.cms.hospice.model.WageIndexEntry;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Component;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.*;

/**
 * In-memory repository for CBSA and MSA wage index data.
 * CBSA records are indexed by code; MSA records by code+lugar.
 */
@Component
public class WageIndexRepository {

    private static final Logger log = LoggerFactory.getLogger(WageIndexRepository.class);

    // CBSA: code → sorted list of entries (sorted by effectiveDate)
    private final Map<String, List<WageIndexEntry>> cbsaIndex = new HashMap<>();

    // MSA: code+lugar → sorted list of entries
    private final Map<String, List<WageIndexEntry>> msaIndex = new HashMap<>();

    public void loadCbsa(List<WageIndexEntry> entries) {
        cbsaIndex.clear();
        for (WageIndexEntry e : entries) {
            cbsaIndex.computeIfAbsent(e.code(), k -> new ArrayList<>()).add(e);
        }
        cbsaIndex.values().forEach(list -> list.sort(Comparator.comparing(WageIndexEntry::effectiveDate)));
        log.info("CBSA wage index loaded: {} CBSA codes, {} total records", cbsaIndex.size(), entries.size());
    }

    public void loadMsa(List<WageIndexEntry> entries) {
        msaIndex.clear();
        for (WageIndexEntry e : entries) {
            msaIndex.computeIfAbsent(e.code(), k -> new ArrayList<>()).add(e);
        }
        msaIndex.values().forEach(list -> list.sort(Comparator.comparing(WageIndexEntry::effectiveDate)));
        log.info("MSA wage index loaded: {} MSA codes, {} total records", msaIndex.size(), entries.size());
    }

    /**
     * Finds CBSA wage index for a given CBSA code that:
     * - has effective date within the FY boundary [fyBegin, fyEnd]
     * - has effective date <= the claim's from date
     * Matches COBOL logic in 0525/0575-GET-HOSP/BENE-WAGE-INDEX.
     */
    public Optional<BigDecimal> findCbsaWageIndex(String cbsaCode, LocalDate fromDate,
            LocalDate fyBegin, LocalDate fyEnd) {
        String normalizedCode = normalizeCbsaCode(cbsaCode);
        List<WageIndexEntry> entries = cbsaIndex.get(normalizedCode);
        if (entries == null || entries.isEmpty()) {
            return Optional.empty();
        }

        BigDecimal result = null;
        for (WageIndexEntry entry : entries) {
            LocalDate effDate = entry.effectiveDate();
            // Must be within FY boundaries AND claim from-date >= effective date
            if (!fromDate.isBefore(effDate)
                    && !effDate.isBefore(fyBegin)
                    && !effDate.isAfter(fyEnd)) {
                result = entry.wageIndex(); // Take last valid (entries are sorted ascending)
            }
        }
        return Optional.ofNullable(result);
    }

    /**
     * Finds MSA wage index — simpler lookup, just find any entry with eff-date <=
     * fromDate.
     * Matches COBOL logic in 0500/0550-GET-HOSP/BENE-WAGE-INDEX.
     */
    public Optional<BigDecimal> findMsaWageIndex(String msaCode, LocalDate fromDate) {
        String normalizedCode = normalizeMsaCode(msaCode);
        List<WageIndexEntry> entries = msaIndex.get(normalizedCode);
        if (entries == null || entries.isEmpty()) {
            return Optional.empty();
        }

        BigDecimal result = null;
        for (WageIndexEntry entry : entries) {
            if (!fromDate.isBefore(entry.effectiveDate())) {
                result = entry.wageIndex();
            }
        }
        return Optional.ofNullable(result);
    }

    private String normalizeCbsaCode(String raw) {
        if (raw == null)
            return "";
        return raw.trim();
    }

    private String normalizeMsaCode(String raw) {
        if (raw == null)
            return "";
        return raw.trim();
    }

    public boolean hasCbsaCode(String cbsaCode) {
        return cbsaIndex.containsKey(normalizeCbsaCode(cbsaCode));
    }

    public boolean hasMsaCode(String msaCode) {
        return msaIndex.containsKey(normalizeMsaCode(msaCode));
    }
}
