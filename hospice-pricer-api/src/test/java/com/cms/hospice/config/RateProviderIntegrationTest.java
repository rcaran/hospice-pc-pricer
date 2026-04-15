package com.cms.hospice.config;

import com.cms.hospice.model.FiscalYearRates;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.ValueSource;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.TestPropertySource;

import java.math.BigDecimal;

import static org.assertj.core.api.Assertions.assertThat;

/**
 * Integration test verifying all 27 fiscal year YAML rate files load correctly.
 * Tests that each FY has non-null LS/NLS rates and correct feature flags.
 */
@SpringBootTest
@TestPropertySource(properties = {
        "hospice.data.cbsa-file=classpath:data/CBSA2021",
        "hospice.data.msa-file=classpath:data/MSAFILE",
        "hospice.data.provider-file=classpath:data/PROVFILE"
})
class RateProviderIntegrationTest {

    @Autowired
    private RateProvider rateProvider;

    @ParameterizedTest
    @ValueSource(strings = {
            "FY1998", "FY1999", "FY2000", "FY2001", "FY2001A",
            "FY2002", "FY2003", "FY2004", "FY2005", "FY2006",
            "FY2007", "FY2007_1", "FY2008", "FY2009", "FY2010",
            "FY2011", "FY2012", "FY2013", "FY2014", "FY2015",
            "FY2016", "FY2016_1", "FY2017", "FY2018", "FY2019",
            "FY2020", "FY2021"
    })
    void allFiscalYearsLoadWithValidRates(String fyId) {
        FiscalYearRates rates = rateProvider.getRates(fyId);

        assertThat(rates).isNotNull();
        assertThat(rates.fiscalYear()).isEqualTo(fyId);

        // Core LS/NLS rates must be positive
        assertPositive(rates.rhcHighLs(), fyId + ".rhcHighLs");
        assertPositive(rates.rhcHighNls(), fyId + ".rhcHighNls");
        assertPositive(rates.chcLs(), fyId + ".chcLs");
        assertPositive(rates.chcNls(), fyId + ".chcNls");
        assertPositive(rates.ircLs(), fyId + ".ircLs");
        assertPositive(rates.ircNls(), fyId + ".ircNls");
        assertPositive(rates.gicLs(), fyId + ".gicLs");
        assertPositive(rates.gicNls(), fyId + ".gicNls");
    }

    @Test
    void fy2021HasCorrectRatesMatchingCobolSource() {
        FiscalYearRates rates = rateProvider.getRates("FY2021");

        // Values from HOSPRATE.cpy (FY2021 section — 2021-V210-DATA-VALUES)
        assertThat(rates.rhcHighLs()).isEqualByComparingTo(new BigDecimal("136.90"));
        assertThat(rates.rhcHighNls()).isEqualByComparingTo(new BigDecimal("62.35"));
        assertThat(rates.chcLs()).isEqualByComparingTo(new BigDecimal("984.21"));
        assertThat(rates.chcNls()).isEqualByComparingTo(new BigDecimal("448.20"));
        assertThat(rates.ircLs()).isEqualByComparingTo(new BigDecimal("249.59"));
        assertThat(rates.ircNls()).isEqualByComparingTo(new BigDecimal("211.50"));
        assertThat(rates.gicLs()).isEqualByComparingTo(new BigDecimal("669.33"));
        assertThat(rates.gicNls()).isEqualByComparingTo(new BigDecimal("376.33"));

        // Feature flags
        assertThat(rates.hasQip()).isTrue();
        assertThat(rates.has60DaySplit()).isTrue();
        assertThat(rates.hasSia()).isTrue();
        assertThat(rates.chcIn15MinUnits()).isTrue();
        assertThat(rates.hasMinChc8Hours()).isFalse();
    }

    @Test
    void fy2016HasSplitDisabledAndFy2016_1HasSplitEnabled() {
        FiscalYearRates fy2016 = rateProvider.getRates("FY2016");
        FiscalYearRates fy2016_1 = rateProvider.getRates("FY2016_1");

        assertThat(fy2016.has60DaySplit()).isFalse();
        assertThat(fy2016.hasSia()).isFalse();

        assertThat(fy2016_1.has60DaySplit()).isTrue();
        assertThat(fy2016_1.hasSia()).isTrue();
    }

    @Test
    void preFy2014FyscalesHaveNoQip() {
        for (String fy : new String[] { "FY1998", "FY2006", "FY2007", "FY2013" }) {
            assertThat(rateProvider.getRates(fy).hasQip())
                    .as(fy + " should not have QIP").isFalse();
        }
    }

    @Test
    void fy2014AndLaterHaveQip() {
        for (String fy : new String[] { "FY2014", "FY2015", "FY2016", "FY2021" }) {
            assertThat(rateProvider.getRates(fy).hasQip())
                    .as(fy + " should have QIP").isTrue();
        }
    }

    @Test
    void fy1998HasMinChc8HoursFlag() {
        assertThat(rateProvider.getRates("FY1998").hasMinChc8Hours()).isTrue();
    }

    private void assertPositive(BigDecimal value, String label) {
        assertThat(value).as(label + " must be non-null and positive")
                .isNotNull()
                .isGreaterThan(BigDecimal.ZERO);
    }
}
