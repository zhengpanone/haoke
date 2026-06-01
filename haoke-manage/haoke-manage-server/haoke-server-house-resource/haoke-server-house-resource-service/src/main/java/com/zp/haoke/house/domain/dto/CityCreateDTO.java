package com.zp.haoke.house.domain.dto;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

@Data
@Schema(description = "City create request")
public class CityCreateDTO {
    @NotBlank(message = "name is required")
    @Schema(description = "City name", example = "Beijing")
    private String name;

    @Schema(description = "City code", example = "110000")
    private String code;

    @Schema(description = "Parent city id. Root nodes use 0.", example = "0")
    private String parentId = "0";

    @NotNull(message = "level is required")
    @Min(value = 1, message = "level must be between 1 and 3")
    @Max(value = 3, message = "level must be between 1 and 3")
    @Schema(description = "Level: 1 province, 2 city, 3 area", example = "2")
    private Integer level;

    @Schema(description = "Sort order", example = "10")
    private Integer sort = 0;

    @Schema(description = "Hot city flag", example = "true")
    private Boolean hot = false;
}
