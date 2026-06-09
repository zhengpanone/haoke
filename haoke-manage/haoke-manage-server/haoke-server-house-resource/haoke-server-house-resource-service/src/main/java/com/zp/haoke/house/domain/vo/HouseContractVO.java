package com.zp.haoke.house.domain.vo;

import lombok.Data;

import java.time.LocalDate;

@Data
public class HouseContractVO {
    private String id;
    private String houseId;
    private String orderId;
    private String contractNo;
    private String title;
    private LocalDate periodStart;
    private LocalDate periodEnd;
    private String status;
    private String statusText;
    private String pdfUrl;
    private String signUrl;
}
