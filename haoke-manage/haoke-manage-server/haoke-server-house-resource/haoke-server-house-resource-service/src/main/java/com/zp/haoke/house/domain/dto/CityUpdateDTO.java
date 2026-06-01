package com.zp.haoke.house.domain.dto;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.NotBlank;
import lombok.Data;
import lombok.EqualsAndHashCode;

@Data
@EqualsAndHashCode(callSuper = true)
@Schema(description = "City update request")
public class CityUpdateDTO extends CityCreateDTO {
    @NotBlank(message = "id is required")
    @Schema(description = "City id", example = "11010000000000000000000000000000")
    private String id;
}
