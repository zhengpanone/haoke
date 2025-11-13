package com.zp.haoke.house.domain.po;

import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import java.io.Serializable;
import java.time.LocalDateTime;

import io.swagger.v3.oas.annotations.media.Schema;

import lombok.Data;
import lombok.Getter;
import lombok.Setter;

/**
 * <p>
 * 房源数据表
 * </p>
 *
 * @author zhengpanone
 * @since 2025-11-14
 */
@Data
@TableName("house_resource")
@Schema(title = "HouseResource对象", description = "房源数据表")
public class HouseResourcePO implements Serializable {

    private static final long serialVersionUID = 1L;
    /**
     * 房源id
     */
    @TableId("id")
    private String id;
    /**
     * 房源标题，如：南北通透，两室朝南，主卧带阳台
     */
    @TableField("title")
    private String title;
    /**
     * 楼盘id
     */
    @Schema(description = "")
    @TableField("estate_id")
    private String estateId;
    /**
     * 楼号（栋）
     */
    @TableField("building_num")
    private String buildingNum;
    /**
     * 单元号
     */
    @TableField("building_unit")
    private String buildingUnit;
    /**
     *门牌号
     */
    @TableField("building_floor_num")
    private String buildingFloorNum;
    /**
     *租金
     */
    @TableField("rent")
    private Integer rent;
    /**
     *租赁方式，1-整租，2-合租
     */
    @TableField("rent_method")
    private Integer rentMethod;
    /**
     *支付方式，1-付一押一，2-付三押一，3-付六押一，4-年付押一，5-其它
     */
    @TableField("payment_method")
    private Integer paymentMethod;
    /**
     *户型，如：2室1厅1卫
     */
    @TableField("house_type")
    private String houseType;
    /**
     *建筑面积
     */
    @TableField("covered_area")
    private String coveredArea;
    /**
     *使用面积
     */
    @TableField("use_area")
    private String useArea;
    /**
     *楼层，如：8/26
     */
    @TableField("floor")
    private String floor;
    /**
     *朝向：东、南、西、北
     */
    @TableField("orientation")
    private Integer orientation;
    /**
     *装修，1-精装，2-简装，3-毛坯
     */
    @TableField("decoration")
    private Integer decoration;
    /**
     *配套设施，如：1,2,3
     */
    @Schema(description = "")
    @TableField("facilities")
    private String facilities;
    /**
     *图片，最多5张
     */
    @TableField("pic")
    private String pic;
    /**
     *房源描述
     */
    @TableField("house_desc")
    private String houseDesc;
    /**
     *联系人
     */
    @TableField("contact")
    private String contact;
    /**
     *手机号
     */
    @TableField("mobile")
    private String mobile;
    /**
     *看房时间，1-上午、2-中午、3-下午、4-晚上、5-全天
     */
    @TableField("time")
    private Boolean time;
    /**
     *物业费
     */
    @TableField("property_cost")
    private String propertyCost;
    /**
     *创建时间
     */
    @TableField("created")
    private LocalDateTime created;
    /**
     *更新时间
     */
    @TableField("updated")
    private LocalDateTime updated;
}
