package com.zp.haoke.framework.core.domain.dto;

import lombok.Data;
import io.swagger.v3.oas.annotations.media.Schema;

@Data
@Schema(description = "分页请求")
public class PageDTO {

    @Schema(description = "页码", example = "1")
    private Integer currentPage = 1;

    @Schema(description = "每页条数", example = "10")
    private Integer pageSize = 10;
}
