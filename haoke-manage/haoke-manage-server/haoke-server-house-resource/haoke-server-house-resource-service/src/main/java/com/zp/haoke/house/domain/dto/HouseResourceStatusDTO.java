package com.zp.haoke.house.domain.dto;

import com.zp.haoke.framework.core.enums.HouseRentStatus;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

@Data
public class HouseResourceStatusDTO {

    @NotNull(message = "房源状态不能为空")
    private HouseRentStatus status;
}
