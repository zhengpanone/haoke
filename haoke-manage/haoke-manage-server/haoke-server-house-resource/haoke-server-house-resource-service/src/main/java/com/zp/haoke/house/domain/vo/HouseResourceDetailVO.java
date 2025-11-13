package com.zp.haoke.house.domain.vo;


import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;
import java.util.List;

@Data
@Schema(description = "房源详情响应对象")
public class HouseResourceDetailVO {

    @Schema(description = "房源基础信息")
    private HouseResourceVO houseResources;

    @Schema(description = "关联的楼盘信息")
    private EstateVO estate;

    @Schema(description = "房源图片列表")
    private List<ImageVO> images;

    @Schema(description = "配套设施详情")
    private List<FacilityVO> facilities;

    @Data
    @Schema(description = "图片信息")
    public static class ImageVO {

        @Schema(description = "图片ID", example = "1")
        private Long id;

        @Schema(description = "图片URL", example = "https://example.com/image1.jpg")
        private String url;

        @Schema(description = "图片排序", example = "1")
        private Integer sortOrder;
    }

    @Data
    @Schema(description = "设施信息")
    public static class FacilityVO {

        @Schema(description = "设施ID", example = "1")
        private Long id;

        @Schema(description = "设施名称", example = "空调")
        private String name;

        @Schema(description = "设施图标", example = "icon-air-conditioner")
        private String icon;
    }
}