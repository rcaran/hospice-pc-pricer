package com.cms.hospice.data;

import com.cms.hospice.model.ProviderData;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Component;

import java.util.*;

/**
 * In-memory repository for provider data.
 * Indexed by provider number; supports multiple entries per provider sorted by
 * effective date.
 */
@Component
public class ProviderRepository {

    private static final Logger log = LoggerFactory.getLogger(ProviderRepository.class);

    // providerNumber → list of ProviderData sorted by effectiveDate ascending
    private final Map<String, List<ProviderData>> providerIndex = new HashMap<>();

    public void load(List<ProviderData> providers) {
        providerIndex.clear();
        for (ProviderData p : providers) {
            providerIndex.computeIfAbsent(p.providerNumber(), k -> new ArrayList<>()).add(p);
        }
        providerIndex.values().forEach(list -> list.sort(Comparator.comparing(ProviderData::effectiveDate)));
        log.info("Provider data loaded: {} providers, {} total records",
                providerIndex.size(), providers.size());
    }

    /**
     * Finds the most recent provider record with effective date <= fromDate.
     * Matches COBOL 0700-GET-PROVIDER / 0800-GET-CURR-PROV logic.
     */
    public Optional<ProviderData> findByProviderNumber(String providerNumber, java.time.LocalDate fromDate) {
        List<ProviderData> entries = providerIndex.get(providerNumber);
        if (entries == null || entries.isEmpty()) {
            return Optional.empty();
        }

        ProviderData result = null;
        for (ProviderData p : entries) {
            if (!fromDate.isBefore(p.effectiveDate())) {
                result = p;
            }
        }
        return Optional.ofNullable(result);
    }

    /**
     * Finds any provider record by provider number (ignores date).
     * Used to check if provider exists at all.
     */
    public boolean exists(String providerNumber) {
        return providerIndex.containsKey(providerNumber);
    }
}
