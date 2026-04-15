package com.cms.hospice.model;

import java.math.BigDecimal;
import java.time.LocalDate;

/**
 * Represents the BILL-315-DATA input record mapped to a clean domain model.
 * Maps directly from the COBOL BILL-315-DATA 315-byte linkage section.
 */
public record HospiceClaim(
        String npi, // BILL-NPI (10)
        String providerNumber, // BILL-PROV-NO (6)
        LocalDate fromDate, // BILL-FROM-DATE (8)
        LocalDate admissionDate, // BILL-ADMISSION-DATE (8)
        String providerCbsa, // BILL-PROV-CBSA (5)
        String beneficiaryCbsa, // BILL-BENE-CBSA (5)
        BigDecimal providerWageIndex, // BILL-PROV-WAGE-INDEX (populated by DriverService)
        BigDecimal beneficiaryWageIndex, // BILL-BENE-WAGE-INDEX (populated by DriverService)
        int priorBenefitDays, // BILL-NA-ADD-ON-DAY1-UNITS (prior RHC days before service date)
        int priorBenefitDays2, // BILL-NA-ADD-ON-DAY2-UNITS
        int[] eolAddOnDayUnits, // BILL-EOL-ADD-ON-DAY1-7-UNITS (7 days, CHC 15-min units)
        String qipIndicator, // BILL-QIP-IND ("1" = QIP, " " = no QIP)
        RevenueLineItem lineItem1, // Rev 0651 (RHC)
        RevenueLineItem lineItem2, // Rev 0652 (CHC)
        RevenueLineItem lineItem3, // Rev 0655 (IRC)
        RevenueLineItem lineItem4 // Rev 0656 (GIC)
) {
    public boolean isQip() {
        return "1".equals(qipIndicator);
    }

    public RevenueLineItem[] lineItems() {
        return new RevenueLineItem[] { lineItem1, lineItem2, lineItem3, lineItem4 };
    }

    public int[] safeEolDayUnits() {
        if (eolAddOnDayUnits == null)
            return new int[7];
        int[] result = new int[7];
        for (int i = 0; i < Math.min(7, eolAddOnDayUnits.length); i++) {
            result[i] = eolAddOnDayUnits[i];
        }
        return result;
    }

    /**
     * Returns a new HospiceClaim identical to this one but with resolved wage
     * indexes.
     * Used by DriverService after CBSA/MSA lookup.
     */
    public HospiceClaim withWageIndexes(BigDecimal provWI, BigDecimal beneWI) {
        return new HospiceClaim(npi, providerNumber, fromDate, admissionDate,
                providerCbsa, beneficiaryCbsa, provWI, beneWI,
                priorBenefitDays, priorBenefitDays2, eolAddOnDayUnits,
                qipIndicator, lineItem1, lineItem2, lineItem3, lineItem4);
    }
}
