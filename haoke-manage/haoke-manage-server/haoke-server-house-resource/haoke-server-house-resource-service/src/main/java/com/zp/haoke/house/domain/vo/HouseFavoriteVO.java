package com.zp.haoke.house.domain.vo;

import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

@Data
public class HouseFavoriteVO {
    private String id;
    private String houseId;
    private String title;
    private String address;
    private BigDecimal price;
    private List<String> tags;
    private String imageUrl;
    private LocalDateTime favoriteTime;
}
