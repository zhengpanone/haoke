package com.zp.haoke.house.domain.dto;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

@Data
@Schema(description = "House estate query request")
public class HouseEstateQueryDTO {
    @Schema(description = "Search keyword")
    private String keyword;

    @Schema(description = "Page number", example = "1")
    private Integer pageNum = 1;

    @Schema(description = "Page size", example = "20")
    private Integer pageSize = 20;
}
