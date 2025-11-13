package com.zp.haoke.house.domain.vo;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;
import java.time.LocalDateTime;

@Data
@Schema(description = "楼盘响应VO")
public class EstateVO {
    
    @Schema(description = "楼盘ID", example = "1")
    private Long id;
    
    @Schema(description = "楼盘名称", example = "阳光花园")
    private String name;
    
    @Schema(description = "所在省", example = "广东省")
    private String province;
    
    @Schema(description = "所在市", example = "深圳市")
    private String city;
    
    @Schema(description = "所在区", example = "南山区")
    private String area;
    
    @Schema(description = "具体地址", example = "科技园南区1号")
    private String address;
    
    @Schema(description = "建筑年代", example = "2020")
    private String year;
    
    @Schema(description = "建筑类型", example = "住宅")
    private String type;
    
    @Schema(description = "物业费(元/平米/月)", example = "3.5")
    private String propertyCost;
    
    @Schema(description = "物业公司", example = "万科物业")
    private String propertyCompany;
    
    @Schema(description = "开发商", example = "万科地产")
    private String developers;
    
    @Schema(description = "创建时间", example = "2023-01-15 10:30:00")
    private LocalDateTime created;
    
    @Schema(description = "更新时间", example = "2023-01-15 10:30:00")
    private LocalDateTime updated;
}