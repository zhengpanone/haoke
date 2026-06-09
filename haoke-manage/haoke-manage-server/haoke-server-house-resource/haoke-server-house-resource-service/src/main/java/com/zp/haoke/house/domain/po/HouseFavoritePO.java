package com.zp.haoke.house.domain.po;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import com.zp.haoke.framework.core.domain.pojo.BasePojo;
import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
@TableName("house_favorite")
public class HouseFavoritePO extends BasePojo {
    @TableId(value = "id", type = IdType.ASSIGN_ID)
    private String id;

    @TableField("user_id")
    private String userId;

    @TableField("house_id")
    private String houseId;

    @TableField("title")
    private String title;

    @TableField("address")
    private String address;

    @TableField("price")
    private BigDecimal price;

    @TableField("tags")
    private String tags;

    @TableField("image_url")
    private String imageUrl;

    @TableField("favorite_time")
    private LocalDateTime favoriteTime;
}
