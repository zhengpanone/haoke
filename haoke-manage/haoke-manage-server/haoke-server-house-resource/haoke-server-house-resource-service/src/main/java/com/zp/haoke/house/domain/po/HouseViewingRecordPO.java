package com.zp.haoke.house.domain.po;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import com.zp.haoke.framework.core.domain.pojo.BasePojo;
import lombok.Data;

import java.time.LocalDateTime;

@Data
@TableName("house_viewing_record")
public class HouseViewingRecordPO extends BasePojo {
    @TableId(value = "id", type = IdType.ASSIGN_ID)
    private String id;

    @TableField("user_id")
    private String userId;

    @TableField("house_id")
    private String houseId;

    @TableField("title")
    private String title;

    @TableField("address")
    private String address;

    @TableField("appointment_time")
    private LocalDateTime appointmentTime;

    @TableField("contact_name")
    private String contactName;

    @TableField("contact_phone")
    private String contactPhone;

    @TableField("status")
    private String status;

    @TableField("note")
    private String note;
}
