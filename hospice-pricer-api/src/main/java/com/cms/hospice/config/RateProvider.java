package com.cms.hospice.config;

import com.cms.hospice.model.FiscalYearRates;
import jakarta.annotation.PostConstruct;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.core.io.Resource;
import org.springframework.core.io.support.ResourcePatternResolver;
import org.springframework.stereotype.Component;
import org.yaml.snakeyaml.Yaml;

import java.io.IOException;
import java.io.InputStream;
import java.math.BigDecimal;
import java.util.HashMap;
import java.util.Map;

/**
 * Loads all fiscal year rate configurations from YAML files at startup.
 * Each YAML file corresponds to one fiscal year period and contains LS/NLS
 * rates
 * for all care types (RHC-HIGH, RHC-LOW, CHC, IRC, GIC) and QIP variants.
 */
@Component
public class RateProvider {

    private static final Logger log = LoggerFactory.getLogger(RateProvider.class);

    private final ResourcePatternResolver resourcePatternResolver;
    private final Map<String, FiscalYearRates> rates = new HashMap<>();

    public RateProvider(ResourcePatternResolver resourcePatternResolver) {
        this.resourcePatternResolver = resourcePatternResolver;
    }

    @PostConstruct
    public void loadRates() throws IOException {
        Resource[] resources = resourcePatternResolver.getResources("classpath:rates/fy*.yaml");
        if (resources.length == 0) {
            throw new IllegalStateException("No rate YAML files found in classpath:rates/. Cannot start.");
        }
        Yaml yaml = new Yaml();
        for (Resource resource : resources) {
            try (InputStream is = resource.getInputStream()) {                
                Map<String, Object> data = yaml.load(is);
                FiscalYearRates fyRates = parseRates(data);
                rates.put(fyRates.fiscalYear(), fyRates);
                log.debug("Loaded rates for fiscal year: {}", fyRates.fiscalYear());
            }
        }
        log.info("Loaded {} fiscal year rate configurations", rates.size());
        validateAllFiscalYears();
    }

    public FiscalYearRates getRates(String fiscalYear) {
        FiscalYearRates result = rates.get(fiscalYear);
        if (result == null) {
            throw new IllegalArgumentException("No rate configuration found for fiscal year: " + fiscalYear);
        }
        return result;
    }

    private void validateAllFiscalYears() {
        String[] requiredFYs = {
                "FY1998", "FY1999", "FY2000", "FY2001", "FY2001A",
                "FY2002", "FY2003", "FY2004", "FY2005", "FY2006",
                "FY2007", "FY2007_1", "FY2008", "FY2009", "FY2010",
                "FY2011", "FY2012", "FY2013", "FY2014", "FY2015",
                "FY2016", "FY2016_1", "FY2017", "FY2018", "FY2019",
                "FY2020", "FY2021"
        };
        for (String fy : requiredFYs) {
            if (!rates.containsKey(fy)) {
                throw new IllegalStateException("Missing required rate configuration for: " + fy);
            }
            validateRates(rates.get(fy));
        }
    }

    private void validateRates(FiscalYearRates r) {
        if (r.rhcHighLs() == null || r.rhcHighNls() == null ||
                r.chcLs() == null || r.chcNls() == null ||
                r.ircLs() == null || r.ircNls() == null ||
                r.gicLs() == null || r.gicNls() == null) {
            throw new IllegalStateException("Incomplete rate configuration for: " + r.fiscalYear());
        }
        if (r.hasQip() && (r.rhcHighLsQ() == null || r.chcLsQ() == null)) {
            throw new IllegalStateException("Missing QIP rates for QIP-enabled FY: " + r.fiscalYear());
        }
    }

    @SuppressWarnings("unchecked")
    private FiscalYearRates parseRates(Map<String, Object> data) {
        String fiscalYear = (String) data.get("fiscalYear");
        Map<String, Object> std = (Map<String, Object>) data.get("rates");
        Map<String, Object> qip = (Map<String, Object>) data.getOrDefault("qipRates", std);
        Map<String, Object> flags = (Map<String, Object>) data.get("flags");

        boolean hasQip = getFlag(flags, "hasQip");
        boolean has60DaySplit = getFlag(flags, "has60DaySplit");
        boolean hasSia = getFlag(flags, "hasSia");
        boolean chcIn15MinUnits = getFlag(flags, "chcIn15MinUnits");
        boolean hasMinChc8Hours = getFlag(flags, "hasMinChc8Hours");

        BigDecimal rhcHighLs = bd(std, "rhcHighLs");
        BigDecimal rhcHighNls = bd(std, "rhcHighNls");
        BigDecimal rhcLowLs = has60DaySplit ? bd(std, "rhcLowLs") : rhcHighLs;
        BigDecimal rhcLowNls = has60DaySplit ? bd(std, "rhcLowNls") : rhcHighNls;

        return new FiscalYearRates(
                fiscalYear,
                rhcHighLs, rhcHighNls,
                rhcLowLs, rhcLowNls,
                bd(std, "chcLs"), bd(std, "chcNls"),
                bd(std, "ircLs"), bd(std, "ircNls"),
                bd(std, "gicLs"), bd(std, "gicNls"),
                // QIP variants (fall back to standard if no QIP)
                bd(qip, "rhcHighLs"), bd(qip, "rhcHighNls"),
                has60DaySplit ? bd(qip, "rhcLowLs") : bd(qip, "rhcHighLs"),
                has60DaySplit ? bd(qip, "rhcLowNls") : bd(qip, "rhcHighNls"),
                bd(qip, "chcLs"), bd(qip, "chcNls"),
                bd(qip, "ircLs"), bd(qip, "ircNls"),
                bd(qip, "gicLs"), bd(qip, "gicNls"),
                hasQip, has60DaySplit, hasSia, chcIn15MinUnits, hasMinChc8Hours);
    }

    private BigDecimal bd(Map<String, Object> map, String key) {
        Object value = map.get(key);
        if (value == null)
            return null;
        if (value instanceof BigDecimal bd)
            return bd;
        if (value instanceof Double d)
            return BigDecimal.valueOf(d);
        if (value instanceof Integer i)
            return BigDecimal.valueOf(i);
        if (value instanceof String s)
            return new BigDecimal(s);
        return new BigDecimal(value.toString());
    }

    private boolean getFlag(Map<String, Object> flags, String key) {
        if (flags == null)
            return false;
        Object val = flags.get(key);
        return Boolean.TRUE.equals(val);
    }
}
