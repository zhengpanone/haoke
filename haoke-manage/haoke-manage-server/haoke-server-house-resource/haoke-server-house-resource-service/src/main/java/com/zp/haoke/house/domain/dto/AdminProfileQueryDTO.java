package com.zp.haoke.house.domain.dto;

import com.zp.haoke.framework.core.domain.dto.PageDTO;
import lombok.Data;
import lombok.EqualsAndHashCode;

@EqualsAndHashCode(callSuper = true)
@Data
public class AdminProfileQueryDTO extends PageDTO {
    private String userId;
    private String keyword;
    private String status;
    private String recordType;
    private Boolean income;
}
