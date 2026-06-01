package com.zp.haoke.house.domain.dto;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import lombok.Data;

@Data
@Schema(description = "House estate create request")
public class HouseEstateCreateDTO {
    @NotBlank(message = "name is required")
    @Size(max = 50, message = "name length must be less than 50")
    @Schema(description = "Estate name", example = "Sunshine Garden")
    private String name;

    @Schema(description = "Province", example = "Beijing")
    private String province;

    @Schema(description = "City", example = "Beijing")
    private String city;

    @Schema(description = "Area", example = "Chaoyang")
    private String area;

    @Schema(description = "Address", example = "No. 88 Jianguo Road")
    private String address;

    @Schema(description = "Building year", example = "2020")
    private String year;

    @Schema(description = "Building type", example = "Residential")
    private String type;

    @Schema(description = "Property cost", example = "3.5")
    private String propertyCost;

    @Schema(description = "Property company", example = "Vanke Property")
    private String propertyCompany;

    @Schema(description = "Developer", example = "Vanke")
    private String developers;
}
