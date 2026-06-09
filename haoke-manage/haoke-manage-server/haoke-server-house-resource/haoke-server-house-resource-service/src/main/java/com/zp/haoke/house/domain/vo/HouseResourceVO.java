package com.zp.haoke.house.domain.vo;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

@Data
@Schema(description = "House resource list response")
public class HouseResourceVO {

    @Schema(description = "House resource id", example = "1")
    private String id;

    @Schema(description = "House resource title")
    private String title;

    @Schema(description = "Estate info")
    private HouseEstateVO estate;

    @Schema(description = "Community name")
    private String communityName;

    @Schema(description = "List cover image")
    private String imageUrl;

    @Schema(description = "List tags")
    private List<String> tags;

    @Schema(description = "List subtitle")
    private String subTitle;

    @Schema(description = "Building number")
    private String buildingNum;

    @Schema(description = "Building unit")
    private String buildingUnit;

    @Schema(description = "Building floor number")
    private String buildingFloorNum;

    @Schema(description = "Rent per month")
    private BigDecimal rent;

    @Schema(description = "Rent method: 1 whole, 2 shared")
    private String rentMethod;

    @Schema(description = "Payment method")
    private Integer paymentMethod;

    @Schema(description = "House type")
    private String houseType;

    @Schema(description = "Covered area")
    private BigDecimal coveredArea;

    @Schema(description = "Use area")
    private String useArea;

    @Schema(description = "Floor")
    private String floor;

    @Schema(description = "Orientation code")
    private String orientation;

    @Schema(description = "Decoration code")
    private String decoration;

    @Schema(description = "Facilities")
    private String facilities;

    @Schema(description = "Description")
    private String description;

    @Schema(description = "Contact name")
    private String contact;

    @Schema(description = "Contact mobile")
    private String mobile;

    @Schema(description = "Rent status")
    private String status;

    @Schema(description = "Created time")
    private LocalDateTime created;

    @Schema(description = "Updated time")
    private LocalDateTime updated;
}
