package com.zp.haoke.house.domain.vo;

import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
public class WalletRecordVO {
    private String id;
    private String recordType;
    private String title;
    private BigDecimal amount;
    private Boolean income;
    private String status;
    private String statusText;
    private LocalDateTime recordTime;
}
