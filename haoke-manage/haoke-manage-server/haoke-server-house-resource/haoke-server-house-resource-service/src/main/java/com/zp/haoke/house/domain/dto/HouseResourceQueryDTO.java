package com.zp.haoke.house.domain.dto;

import com.zp.haoke.framework.core.domain.dto.PageDTO;
import com.zp.haoke.framework.core.enums.HouseRentStatus;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;
import lombok.EqualsAndHashCode;

import java.util.List;

/**
 * 房源查询请求DTO
 *
 * @author zhengpanone
 */
@EqualsAndHashCode(callSuper = true)
@Data
@Schema(description = "房源查询请求")
public class HouseResourceQueryDTO extends PageDTO {

    @Schema(description = "房源标题（模糊搜索）")
    private String title;

    @Schema(description = "关键词，支持标题、户型、描述模糊搜索")
    private String keyword;

    @Schema(description = "楼盘ID")
    private String estateId;

    @Schema(description = "租赁方式：1-整租，2-合租")
    private Integer rentMethod;

    @Schema(description = "最低租金")
    private Integer minRent;

    @Schema(description = "最高租金")
    private Integer maxRent;

    @Schema(description = "户型关键词列表")
    private List<String> houseTypes;

    @Schema(description = "楼层关键词列表")
    private List<String> floorKeywords;

    @Schema(description = "朝向列表")
    private List<Integer> orientations;

    @Schema(description = "装修列表")
    private List<Integer> decorations;

    @Schema(description = "房源状态")
    private HouseRentStatus status;

    private List<HouseRentStatus> statusList;


}
