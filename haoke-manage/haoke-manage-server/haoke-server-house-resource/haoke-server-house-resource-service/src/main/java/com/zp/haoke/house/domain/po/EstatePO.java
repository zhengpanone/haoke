package com.zp.haoke.house.domain.po;

import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import java.io.Serializable;
import java.time.LocalDateTime;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Getter;
import lombok.Setter;

/**
 * <p>
 * 楼盘数据表
 * </p>
 *
 * @author zhengpanone
 * @since 2025-11-14
 */
@Getter
@Setter
@TableName("estate")
@Schema(title = "Estate", description = "楼盘数据表")
public class EstatePO implements Serializable {

    private static final long serialVersionUID = 1L;

    @Schema(description = "楼盘id")
    @TableId("id")
    private String id;

    @Schema(description = "楼盘名称")
    @TableField("name")
    private String name;

    @Schema(description = "所在省")
    @TableField("province")
    private String province;

    @Schema(description = "所在市")
    @TableField("city")
    private String city;

    @Schema(description = "所在区")
    @TableField("area")
    private String area;

    @Schema(description = "具体地址")
    @TableField("address")
    private String address;

    @Schema(description = "建筑年代")
    @TableField("year")
    private String year;

    @Schema(description = "建筑类型")
    @TableField("type")
    private String type;

    @Schema(description = "物业费")
    @TableField("property_cost")
    private String propertyCost;

    @Schema(description = "物业公司")
    @TableField("property_company")
    private String propertyCompany;

    @Schema(description = "开发商")
    @TableField("developers")
    private String developers;

    @Schema(description = "创建时间")
    @TableField("created")
    private LocalDateTime created;

    @Schema(description = "更新时间")
    @TableField("updated")
    private LocalDateTime updated;
}
