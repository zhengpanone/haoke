package com.zp.haoke.house.domain.vo;

import lombok.Data;

import java.time.LocalDateTime;

@Data
public class ViewingRecordVO {
    private String id;
    private String houseId;
    private String title;
    private String address;
    private LocalDateTime appointmentTime;
    private String contactName;
    private String contactPhone;
    private String status;
    private String statusText;
    private String note;
}
