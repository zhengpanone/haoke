package com.zp.haoke.house.domain.dto;


import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.experimental.Accessors;

@Builder
@NoArgsConstructor
@AllArgsConstructor
@Data
@Accessors(chain = true)
@Schema(description = "房源创建请求数据传输对象")
public class HouseResourceCreateDTO {

    @NotBlank(message = "房源标题不能为空")
    @Size(min = 5, max = 200, message = "房源标题长度在5-200个字符之间")
    @Schema(
            // 常用属性
            description = "房源标题", // 描述
            example = "南北通透，两室朝南，主卧带阳台", // 示例值
            requiredMode = Schema.RequiredMode.REQUIRED, // 是否必需
            accessMode = Schema.AccessMode.READ_ONLY, // 访问模式
            // 数据类型相关
            type = "string",                 // 数据类型
            maxLength = 200,                  // 最大长度
            minLength = 2// ,                   // 最小长度
            //    format = "email",                // 格式
            //    minimum = "0",                   // 最小值
            //    maximum = "100",                 // 最大值
            // 枚举相关
            //    allowableValues = {"MALE", "FEMALE"}, // 允许的值
            //    defaultValue = "MALE",           // 默认值
            // 其他
            //            hidden = false,                  // 是否隐藏
            //            deprecated = false,              // 是否弃用
            //            implementation = String.class    // 实现类
    )
    private String title;

    @NotNull(message = "楼盘ID不能为空")
    @Schema(description = "关联的楼盘ID", example = "1", requiredMode = Schema.RequiredMode.REQUIRED, minimum = "1")
    private Long estateId;

    @NotNull(message = "租金不能为空")
    @Min(value = 1, message = "租金必须大于0")
    @Max(value = 100000, message = "租金不能超过100000")
    @Schema(description = "月租金(元)", example = "3500", requiredMode = Schema.RequiredMode.REQUIRED, minimum = "1", maximum = "100000")
    private Integer rent;

    @NotNull(message = "租赁方式不能为空")
    @Schema(description = "租赁方式", example = "1", requiredMode = Schema.RequiredMode.REQUIRED, allowableValues = {"1", "2"}, defaultValue = "1")
    private Integer rentMethod;

    @NotBlank(message = "户型不能为空")
    @Pattern(regexp = "^\\d+室\\d+厅\\d+卫$", message = "户型格式不正确")
    @Schema(description = "房屋户型", example = "2室1厅1卫", requiredMode = Schema.RequiredMode.REQUIRED, pattern = "^\\d+室\\d+厅\\d+卫$")
    private String houseType;

    @Schema(description = "建筑面积", example = "89.5", minimum = "0", maximum = "1000")
    private Double coveredArea;

    @Schema(description = "房屋朝向", example = "2", allowableValues = {"1", "2", "3", "4"}, defaultValue = "2")
    private Integer orientation;

    @Schema(description = "装修情况", example = "1", allowableValues = {"1", "2", "3"}, defaultValue = "1")
    private Integer decoration;

    @Email(message = "邮箱格式不正确")
    @Schema(description = "联系人邮箱", example = "contact@example.com", format = "email")
    private String contactEmail;

    @Pattern(regexp = "^1[3-9]\\d{9}$", message = "手机号格式不正确")
    @Schema(description = "联系人手机号", example = "13800138000", pattern = "^1[3-9]\\d{9}$")
    private String contactPhone;
}