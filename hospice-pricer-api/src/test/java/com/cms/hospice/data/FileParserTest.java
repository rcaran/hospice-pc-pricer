package com.cms.hospice.data;

import com.cms.hospice.model.ProviderData;
import com.cms.hospice.model.WageIndexEntry;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.CsvSource;

import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.math.BigDecimal;
import java.nio.charset.StandardCharsets;
import java.time.LocalDate;
import java.util.Arrays;
import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;

/**
 * Unit tests for CbsaFileParser, MsaFileParser, and their decodeWageIndex
 * method.
 *
 * Uses in-memory byte streams to avoid depending on actual data files.
 */
class FileParserTest {

    private static InputStream asStream(String content) {
        return new ByteArrayInputStream(content.getBytes(StandardCharsets.ISO_8859_1));
    }

    // ── decodeWageIndex ───────────────────────────────────────────────────────

    @ParameterizedTest
    @CsvSource({
            "008397, 0.8397",
            "010000, 1.0000",
            "011234, 1.1234",
            "009000, 0.9000",
            "000000, 0.0000",
            "013500, 1.3500",
    })
    void decodeWageIndex_correctlyParsesFormat(String raw, String expected) {
        BigDecimal result = CbsaFileParser.decodeWageIndex(raw);
        assertThat(result).isEqualByComparingTo(expected);
    }

    @Test
    void decodeWageIndex_wrongLength_throws() {
        assertThatThrownBy(() -> CbsaFileParser.decodeWageIndex("1234"))
                .isInstanceOf(IllegalArgumentException.class);
    }

    // ── CbsaFileParser ────────────────────────────────────────────────────────

    @Test
    void cbsaParser_parsesSingleRecord() throws IOException {
        // 80-char line: CBSA(5) + ' ' + Date(8) + ' ' + WI(6) + remainder
        String line = "16740 20201001 010000                                               \n";
        CbsaFileParser parser = new CbsaFileParser();

        List<WageIndexEntry> entries = parser.parse(asStream(line));

        assertThat(entries).hasSize(1);
        WageIndexEntry e = entries.get(0);
        assertThat(e.code()).isEqualTo("16740");
        assertThat(e.effectiveDate()).isEqualTo(LocalDate.of(2020, 10, 1));
        assertThat(e.wageIndex()).isEqualByComparingTo("1.0000");
    }

    @Test
    void cbsaParser_parsesMultipleRecords() throws IOException {
        String lines = "16740 20201001 010000 Charlotte, NC                                  \n" +
                "35620 20201001 013500 New York, NY                                   \n" +
                "99999 20201001 008500 Rural/Non-CBSA                                 \n";

        CbsaFileParser parser = new CbsaFileParser();
        List<WageIndexEntry> entries = parser.parse(asStream(lines));

        assertThat(entries).hasSize(3);
        assertThat(entries.get(0).code()).isEqualTo("16740");
        assertThat(entries.get(0).wageIndex()).isEqualByComparingTo("1.0000");
        assertThat(entries.get(1).code()).isEqualTo("35620");
        assertThat(entries.get(1).wageIndex()).isEqualByComparingTo("1.3500");
        assertThat(entries.get(2).code()).isEqualTo("99999");
        assertThat(entries.get(2).wageIndex()).isEqualByComparingTo("0.8500");
    }

    @Test
    void cbsaParser_ignoresBlankLines() throws IOException {
        String lines = "16740 20201001 010000 Charlotte\n\n\n35620 20201001 013500 NYC\n";
        CbsaFileParser parser = new CbsaFileParser();

        List<WageIndexEntry> entries = parser.parse(asStream(lines));
        assertThat(entries).hasSize(2);
    }

    @Test
    void cbsaParser_ignoresShortLines() throws IOException {
        // Line shorter than 21 chars is skipped
        String lines = "SHORT\n16740 20201001 010000 valid\n";
        CbsaFileParser parser = new CbsaFileParser();

        List<WageIndexEntry> entries = parser.parse(asStream(lines));
        assertThat(entries).hasSize(1);
    }

    @Test
    void cbsaParser_emptyInput_returnsEmptyList() throws IOException {
        CbsaFileParser parser = new CbsaFileParser();
        List<WageIndexEntry> entries = parser.parse(asStream(""));
        assertThat(entries).isEmpty();
    }

    // ── MsaFileParser ─────────────────────────────────────────────────────────

    @Test
    void msaParser_parsesSingleRecord() throws IOException {
        // MSA(4) + LUGAR(1) + ' ' + Date(8) + ' ' + WI(6) + ...
        String line = "2680  20001001 009500 MSA test area                                \n";
        MsaFileParser parser = new MsaFileParser();

        List<WageIndexEntry> entries = parser.parse(asStream(line));

        assertThat(entries).hasSize(1);
        WageIndexEntry e = entries.get(0);
        assertThat(e.code()).isEqualTo("2680");
        assertThat(e.effectiveDate()).isEqualTo(LocalDate.of(2000, 10, 1));
        assertThat(e.wageIndex()).isEqualByComparingTo("0.9500");
    }

    @Test
    void msaParser_parsesMultipleRecords() throws IOException {
        String lines = "2680  20001001 009500 Dallas-Fort Worth\n" +
                "5960  20001001 012000 San Francisco\n";
        MsaFileParser parser = new MsaFileParser();

        List<WageIndexEntry> entries = parser.parse(asStream(lines));

        assertThat(entries).hasSize(2);
        assertThat(entries.get(0).wageIndex()).isEqualByComparingTo("0.9500");
        assertThat(entries.get(1).wageIndex()).isEqualByComparingTo("1.2000");
    }

    // ── ProviderFileParser ────────────────────────────────────────────────────

    /**
     * Builds a 240-byte provider record string. Spaces all fields, then places
     * known values at the documented offsets:
     * 0-9 NPI (10)
     * 10-15 provider number (6)
     * 16-23 effective date (8)
     * 24-31 FY begin date (8)
     * 56 census division (1)
     * 58-61 MSA geo-loc (4)
     * 139-143 CBSA geo-loc (5)
     */
    private static String buildProvRecord(String npi, String provNo,
            String effDate, String fyBeginDate,
            String censusDivision, String msaGeoLoc,
            String cbsaGeoLoc) {
        char[] rec = new char[240];
        Arrays.fill(rec, ' ');

        setField(rec, 0, npi, 10);
        setField(rec, 10, provNo, 6);
        setField(rec, 16, effDate, 8);
        setField(rec, 24, fyBeginDate, 8);
        setField(rec, 56, censusDivision, 1);
        setField(rec, 58, msaGeoLoc, 4);
        setField(rec, 139, cbsaGeoLoc, 5);

        return new String(rec);
    }

    private static void setField(char[] rec, int offset, String value, int maxLen) {
        if (value == null)
            return;
        int len = Math.min(value.length(), maxLen);
        for (int i = 0; i < len; i++) {
            rec[offset + i] = value.charAt(i);
        }
    }

    @Test
    void providerParser_parsesSingleRecord() throws IOException {
        String rec = buildProvRecord("1234567890", "341234",
                "20200101", "20201001", "3", "6740", "16740");
        ProviderFileParser parser = new ProviderFileParser();

        List<ProviderData> providers = parser.parse(asStream(rec + "\n"));

        assertThat(providers).hasSize(1);
        ProviderData p = providers.get(0);
        assertThat(p.npi()).isEqualTo("1234567890");
        assertThat(p.providerNumber()).isEqualTo("341234");
        assertThat(p.effectiveDate()).isEqualTo(LocalDate.of(2020, 1, 1));
        assertThat(p.fyBeginDate()).isEqualTo(LocalDate.of(2020, 10, 1));
        assertThat(p.cbsaGeoLoc()).isEqualTo("16740");
        assertThat(p.msaGeoLoc()).isEqualTo("6740");
        assertThat(p.censusDivision()).isEqualTo("3");
    }

    @Test
    void providerParser_parsesMultipleRecords() throws IOException {
        String rec1 = buildProvRecord("1234567890", "341234",
                "20200101", "20201001", "3", "6740", "16740");
        String rec2 = buildProvRecord("9876543210", "341235",
                "20190101", "20191001", "2", "5614", "35614");

        ProviderFileParser parser = new ProviderFileParser();
        List<ProviderData> providers = parser.parse(asStream(rec1 + "\n" + rec2 + "\n"));

        assertThat(providers).hasSize(2);
        assertThat(providers.get(0).providerNumber()).isEqualTo("341234");
        assertThat(providers.get(0).cbsaGeoLoc()).isEqualTo("16740");
        assertThat(providers.get(1).providerNumber()).isEqualTo("341235");
        assertThat(providers.get(1).cbsaGeoLoc()).isEqualTo("35614");
    }

    @Test
    void providerParser_ignoresShortRecords() throws IOException {
        // Record shorter than MIN_RECORD_LEN (144) should be skipped
        String shortRec = "1234567890341234";

        ProviderFileParser parser = new ProviderFileParser();
        List<ProviderData> providers = parser.parse(asStream(shortRec + "\n"));

        assertThat(providers).isEmpty();
    }

    @Test
    void providerParser_ignoresBlankLines() throws IOException {
        String rec = buildProvRecord("1234567890", "341234",
                "20200101", "20201001", "3", "6740", "16740");

        ProviderFileParser parser = new ProviderFileParser();
        List<ProviderData> providers = parser.parse(asStream("\n\n" + rec + "\n\n"));

        assertThat(providers).hasSize(1);
    }

    @Test
    void providerParser_skipsRecordWithMissingDate() throws IOException {
        // Record with zeros in effective date should be skipped
        String rec = buildProvRecord("1234567890", "341234",
                "00000000", "20201001", "3", "6740", "16740");

        ProviderFileParser parser = new ProviderFileParser();
        List<ProviderData> providers = parser.parse(asStream(rec + "\n"));

        assertThat(providers).isEmpty();
    }

    @Test
    void providerParser_emptyInput_returnsEmptyList() throws IOException {
        ProviderFileParser parser = new ProviderFileParser();
        List<ProviderData> providers = parser.parse(asStream(""));
        assertThat(providers).isEmpty();
    }
}
