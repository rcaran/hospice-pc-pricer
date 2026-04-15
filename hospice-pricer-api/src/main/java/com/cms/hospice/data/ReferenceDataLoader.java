package com.cms.hospice.data;

import com.cms.hospice.model.ProviderData;
import com.cms.hospice.model.WageIndexEntry;
import jakarta.annotation.PostConstruct;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.Resource;
import org.springframework.stereotype.Component;

import java.io.IOException;
import java.util.List;

/**
 * Loads all reference-data flat files into memory at application startup.
 * Matches the in-memory table population that HOSOP210 / HOSDR210 perform
 * when initialising the CBSA-WI-TABLE, MSA-WI-TABLE, and PROV-TABLE.
 */
@Component
public class ReferenceDataLoader {

    private static final Logger log = LoggerFactory.getLogger(ReferenceDataLoader.class);

    private final CbsaFileParser cbsaFileParser;
    private final MsaFileParser msaFileParser;
    private final ProviderFileParser providerFileParser;
    private final WageIndexRepository wageIndexRepository;
    private final ProviderRepository providerRepository;

    @Value("${hospice.data.cbsa-file}")
    private Resource cbsaFile;

    @Value("${hospice.data.msa-file}")
    private Resource msaFile;

    @Value("${hospice.data.provider-file}")
    private Resource providerFile;

    public ReferenceDataLoader(CbsaFileParser cbsaFileParser,
            MsaFileParser msaFileParser,
            ProviderFileParser providerFileParser,
            WageIndexRepository wageIndexRepository,
            ProviderRepository providerRepository) {
        this.cbsaFileParser = cbsaFileParser;
        this.msaFileParser = msaFileParser;
        this.providerFileParser = providerFileParser;
        this.wageIndexRepository = wageIndexRepository;
        this.providerRepository = providerRepository;
    }

    @PostConstruct
    public void load() throws IOException {
        log.info("Loading reference data files...");

        List<WageIndexEntry> cbsaEntries = cbsaFileParser.parse(cbsaFile.getInputStream());
        wageIndexRepository.loadCbsa(cbsaEntries);

        List<WageIndexEntry> msaEntries = msaFileParser.parse(msaFile.getInputStream());
        wageIndexRepository.loadMsa(msaEntries);

        List<ProviderData> providerEntries = providerFileParser.parse(providerFile.getInputStream());
        providerRepository.load(providerEntries);

        log.info("Reference data load complete — CBSA:{} MSA:{} PROV:{}",
                cbsaEntries.size(), msaEntries.size(), providerEntries.size());
    }
}
