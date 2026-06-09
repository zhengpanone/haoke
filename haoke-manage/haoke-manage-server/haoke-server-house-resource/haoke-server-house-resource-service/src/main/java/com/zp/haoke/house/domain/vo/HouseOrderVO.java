package com.zp.haoke.house.domain.vo;

import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
public class HouseOrderVO {
    private String id;
    private String houseId;
    private String orderNo;
    private String title;
    private String address;
    private BigDecimal amount;
    private String status;
    private String statusText;
    private String actionText;
    private LocalDateTime orderTime;
}
