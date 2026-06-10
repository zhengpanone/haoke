package com.zp.haoke.house.domain.dto;

import com.zp.haoke.framework.core.enums.HouseRentStatus;
import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Pattern;
import jakarta.validation.constraints.Size;
import lombok.Data;

@Data
@Schema(description = "House resource update request")
public class HouseResourceUpdateDTO {

    @NotBlank(message = "房源 ID 不能为空")
    private String id;

    @NotBlank(message = "房源标题不能为空")
    @Size(min = 2, max = 200, message = "房源标题长度需在 2-200 个字符之间")
    private String title;

    @NotBlank(message = "楼盘 ID 不能为空")
    private String estateId;

    private String buildingNum;

    private String buildingUnit;

    private String buildingFloorNum;

    @NotNull(message = "租金不能为空")
    @Min(value = 1, message = "租金必须大于 0")
    @Max(value = 100000, message = "租金不能超过 100000")
    private Integer rent;

    @NotNull(message = "租赁方式不能为空")
    private Integer rentMethod;

    private Integer paymentMethod;

    @NotBlank(message = "户型不能为空")
    @Pattern(regexp = "^\\d+室\\d+厅\\d+卫$", message = "户型格式应为 2室1厅1卫")
    private String houseType;

    private Double coveredArea;

    private String useArea;

    private String floor;

    private Integer orientation;

    private Integer decoration;

    private String facilities;

    private String pic;

    private String houseDesc;

    @Size(max = 10, message = "联系人不能超过 10 个字符")
    private String contact;

    @Pattern(regexp = "^$|^1[3-9]\\d{9}$", message = "手机号格式不正确")
    private String mobile;

    private Integer time;

    private String propertyCost;

    private HouseRentStatus status;
}
