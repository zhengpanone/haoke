package com.zp.haoke.house.domain.dto;

import lombok.Data;

import java.time.LocalDateTime;

@Data
public class ViewingRecordCreateDTO {
    private String houseId;
    private String title;
    private String address;
    private LocalDateTime appointmentTime;
    private String contactName;
    private String contactPhone;
    private String note;
}
