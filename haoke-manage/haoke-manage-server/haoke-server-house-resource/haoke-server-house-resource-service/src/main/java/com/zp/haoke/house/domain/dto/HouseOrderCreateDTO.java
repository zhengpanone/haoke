package com.zp.haoke.house.domain.dto;

import lombok.Data;

import java.math.BigDecimal;

@Data
public class HouseOrderCreateDTO {
    private String houseId;
    private String title;
    private String address;
    private BigDecimal amount;
    private String status;
    private String actionText;
}
