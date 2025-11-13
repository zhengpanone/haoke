package com.zp.haoke.house.domain.vo;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;
import java.time.LocalDateTime;

@Data
@Schema(description = "房源详情响应VO")
public class HouseResourceVO {

    @Schema(description = "房源ID", example = "1")
    private Long id;

    @Schema(description = "房源标题", example = "南北通透，两室朝南，主卧带阳台")
    private String title;

    @Schema(description = "楼盘信息")
    private EstateVO estate;

    @Schema(description = "楼号", example = "A栋")
    private String buildingNum;

    @Schema(description = "单元号", example = "2单元")
    private String buildingUnit;

    @Schema(description = "门牌号", example = "803")
    private String buildingFloorNum;

    @Schema(description = "租金(元/月)", example = "3500")
    private Integer rent;

    @Schema(description = "租赁方式: 1-整租, 2-合租", example = "1")
    private Integer rentMethod;

    @Schema(description = "支付方式: 1-付一押一, 2-付三押一, 3-付六押一, 4-年付押一, 5-其它", example = "2")
    private Integer paymentMethod;

    @Schema(description = "户型", example = "2室1厅1卫")
    private String houseType;

    @Schema(description = "建筑面积", example = "89.5㎡")
    private String coveredArea;

    @Schema(description = "使用面积", example = "75.0㎡")
    private String useArea;

    @Schema(description = "楼层", example = "8/26")
    private String floor;

    @Schema(description = "朝向", example = "南")
    private String orientation;

    @Schema(description = "装修", example = "精装")
    private String decoration;

    @Schema(description = "配套设施", example = "空调,洗衣机,冰箱")
    private String facilities;

    @Schema(description = "房源描述")
    private String description;

    @Schema(description = "创建时间")
    private LocalDateTime created;

    @Schema(description = "更新时间")
    private LocalDateTime updated;
}