package com.zp.haoke.house.domain.dto;

import jakarta.validation.constraints.NotBlank;
import lombok.Data;

@Data
public class AdminStatusUpdateDTO {
    @NotBlank(message = "status cannot be blank")
    private String status;

    private String rejectReason;
}
