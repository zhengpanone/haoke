package com.zp.haoke.house.domain.dto;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

@Data
@Schema(description = "City query request")
public class CityQueryDTO {
    @Schema(description = "Search keyword")
    private String keyword;

    @Schema(description = "Parent city id")
    private String parentId;

    @Schema(description = "Level: 1 province, 2 city, 3 area")
    private Integer level;

    @Schema(description = "Hot city flag")
    private Boolean hot;
}
