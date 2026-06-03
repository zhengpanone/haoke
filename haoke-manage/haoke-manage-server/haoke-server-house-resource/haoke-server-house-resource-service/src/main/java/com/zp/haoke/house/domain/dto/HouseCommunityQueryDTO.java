package com.zp.haoke.house.domain.dto;

import com.zp.haoke.framework.core.domain.dto.PageDTO;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;
import lombok.EqualsAndHashCode;

@EqualsAndHashCode(callSuper = true)
@Data
@Schema(description = "House estate query request")
public class HouseCommunityQueryDTO extends PageDTO {
    @Schema(description = "Search keyword")
    private String keyword;


}
