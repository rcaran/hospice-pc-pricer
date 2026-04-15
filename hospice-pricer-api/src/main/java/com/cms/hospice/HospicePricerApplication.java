package com.cms.hospice;

import io.swagger.v3.oas.annotations.OpenAPIDefinition;
import io.swagger.v3.oas.annotations.info.Contact;
import io.swagger.v3.oas.annotations.info.Info;
import io.swagger.v3.oas.annotations.info.License;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@OpenAPIDefinition(info = @Info(title = "Hospice PC Pricer API", version = "1.0", description = "Medicare/Medicaid Hospice Payment Pricer — calculates payment amounts for hospice claims across fiscal years FY1998–FY2021.", contact = @Contact(name = "CMS"), license = @License(name = "Public Domain")))
@SpringBootApplication
public class HospicePricerApplication {

    public static void main(String[] args) {
        SpringApplication.run(HospicePricerApplication.class, args);
    }
}
