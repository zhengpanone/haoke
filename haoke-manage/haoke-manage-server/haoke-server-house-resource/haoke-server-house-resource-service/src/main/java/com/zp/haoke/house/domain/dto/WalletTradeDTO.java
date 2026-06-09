package com.zp.haoke.house.domain.dto;

import lombok.Data;

import java.math.BigDecimal;

@Data
public class WalletTradeDTO {
    private BigDecimal amount;
    private String title;
}
