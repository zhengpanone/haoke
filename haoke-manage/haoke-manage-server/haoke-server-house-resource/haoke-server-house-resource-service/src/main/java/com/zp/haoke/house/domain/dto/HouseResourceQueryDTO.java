package com.zp.haoke.house.domain.dto;

import com.zp.haoke.framework.core.enums.HouseRentStatus;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

/**
 * 房源查询请求DTO
 *
 * @author zhengpanone
 */
@Data
@Schema(description = "房源查询请求")
public class HouseResourceQueryDTO {

    @Schema(description = "房源标题（模糊搜索）")
    private String title;

    @Schema(description = "楼盘ID")
    private String estateId;

    @Schema(description = "租赁方式：1-整租，2-合租")
    private Integer rentMethod;

    @Schema(description = "房源状态")
    private HouseRentStatus status;

    @Schema(description = "页码", example = "1")
    private Integer currentPage = 1;

    @Schema(description = "每页条数", example = "10")
    private Integer pageSize = 10;
}
