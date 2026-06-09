package com.zp.haoke.house.domain.vo;

import lombok.Data;

import java.math.BigDecimal;
import java.util.List;

@Data
public class WalletOverviewVO {
    private BigDecimal balance;
    private BigDecimal frozenAmount;
    private List<WalletRecordVO> records;
}
