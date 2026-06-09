package com.zp.haoke.house.domain.dto;

import lombok.Data;

@Data
public class IdentityVerificationSubmitDTO {
    private String realName;
    private String idCardNo;
    private String idCardFront;
    private String idCardBack;
}
