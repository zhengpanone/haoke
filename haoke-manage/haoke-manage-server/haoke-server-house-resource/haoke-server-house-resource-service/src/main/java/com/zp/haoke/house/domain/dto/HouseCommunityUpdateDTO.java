package com.zp.haoke.house.domain.dto;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.NotBlank;
import lombok.Data;
import lombok.EqualsAndHashCode;

@Data
@EqualsAndHashCode(callSuper = true)
@Schema(description = "House estate update request")
public class HouseCommunityUpdateDTO extends HouseCommunityCreateDTO {
    @NotBlank(message = "id is required")
    @Schema(description = "Estate id", example = "2034514861085626370")
    private String id;
}
