package com.zp.haoke.house.domain.vo;

import lombok.Data;

import java.time.LocalDateTime;

@Data
public class IdentityVerificationVO {
    private String id;
    private String realName;
    private String idCardNo;
    private String status;
    private String statusText;
    private String rejectReason;
    private LocalDateTime submittedAt;
    private LocalDateTime reviewedAt;
}
