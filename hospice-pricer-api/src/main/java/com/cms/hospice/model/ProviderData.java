package com.cms.hospice.model;

import java.time.LocalDate;

public record ProviderData(
        String npi,
        String providerNumber,
        LocalDate effectiveDate,
        LocalDate fyBeginDate,
        String cbsaGeoLoc,
        String msaGeoLoc,
        String censusDivision) {
}
