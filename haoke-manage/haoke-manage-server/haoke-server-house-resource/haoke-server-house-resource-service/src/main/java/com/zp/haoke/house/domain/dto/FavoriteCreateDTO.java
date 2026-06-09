package com.zp.haoke.house.domain.dto;

import lombok.Data;

import java.math.BigDecimal;

@Data
public class FavoriteCreateDTO {
    private String houseId;
    private String title;
    private String address;
    private BigDecimal price;
    private String tags;
    private String imageUrl;
}
